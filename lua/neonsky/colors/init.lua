local Util = require("neonsky.util")

local M = {}

---@type table<string, Palette|fun(opts:neonsky.Config):Palette>
M.styles = setmetatable({}, {
  __index = function(_, style)
    return vim.deepcopy(Util.mod("neonsky.colors." .. style))
  end,
})

---@param opts? neonsky.Config
function M.setup(opts)
  opts = require("neonsky.config").extend(opts)

  local palette = M.styles[opts.style]
  if type(palette) == "function" then
    palette = palette(opts) --[[@as Palette]]
  end

  -- Color Palette
  ---@class ColorScheme: Palette
  local colors = palette

  Util.bg = colors.bg
  Util.fg = colors.fg

  colors.none = "NONE"

  -- Map Neon Sky names to Tokyo Night expected names
  colors.blue = colors.blue_300
  colors.blue0 = colors.blue_100
  colors.blue1 = colors.blue_200
  colors.blue2 = colors.blue_300
  colors.blue5 = colors.blue_400
  colors.blue6 = colors.cyan_300
  colors.blue7 = colors.blue_100
  colors.cyan = colors.cyan_300
  colors.green = colors.green_300
  colors.green1 = colors.green_200
  colors.green2 = colors.green_200
  colors.magenta = colors.magenta_300
  colors.magenta2 = colors.magenta_400
  colors.orange = colors.orange_300
  colors.purple = colors.cyan_400
  colors.red = colors.red_300
  colors.red1 = colors.red_200
  colors.teal = colors.cyan_200
  colors.yellow = colors.yellow_300
  colors.terminal_black = colors.gutter
  colors.fg_dark = colors.white
  colors.fg_gutter = colors.gutter
  colors.bg_dark = colors.muted
  colors.bg_dark1 = colors.muted
  colors.bg_highlight = colors.gutter
  colors.dark3 = colors.gutter
  colors.dark5 = colors.white

  colors.diff = {
    add = Util.blend_bg(colors.green2, 0.25),
    delete = Util.blend_bg(colors.red1, 0.25),
    change = Util.blend_bg(colors.blue7, 0.15),
    text = colors.blue7,
  }

  colors.git.ignore = colors.dark3
  colors.black = Util.blend_bg(colors.bg, 0.8, "#000000")
  colors.border_highlight = Util.blend_bg(colors.blue1, 0.8)
  colors.border = colors.black

  -- Popups and statusline always get a dark background
  colors.bg_popup = colors.bg_dark
  colors.bg_statusline = colors.bg_dark

  -- Sidebar and Floats are configurable
  colors.bg_sidebar = opts.styles.sidebars == "transparent" and colors.none
    or opts.styles.sidebars == "dark" and colors.bg_dark
    or colors.bg

  colors.bg_float = opts.styles.floats == "transparent" and colors.none
    or opts.styles.floats == "dark" and colors.bg_dark
    or colors.bg

  colors.bg_visual = Util.blend_bg(colors.blue0, 0.4)
  colors.bg_search = colors.blue0
  colors.fg_sidebar = colors.fg_dark
  colors.fg_float = colors.fg

  colors.error = colors.red1
  colors.todo = colors.blue
  colors.warning = colors.yellow
  colors.info = colors.blue2
  colors.hint = colors.teal

  colors.rainbow = {
    colors.magenta_400, -- H1
    colors.cyan_400,    -- H2
    colors.blue_400,    -- H3
    colors.yellow_400,  -- H4
    colors.orange_400,  -- H5
    colors.green_400,   -- H6
    colors.red_400,     -- H7
    colors.magenta_300, -- H8
  }

  -- stylua: ignore
  --- @class TerminalColors
  colors.terminal = colors.terminal or {
    black          = colors.black,
    black_bright   = colors.terminal_black,
    red            = colors.red,
    red_bright     = Util.brighten(colors.red),
    green          = colors.green,
    green_bright   = Util.brighten(colors.green),
    yellow         = colors.yellow,
    yellow_bright  = Util.brighten(colors.yellow),
    blue           = colors.blue,
    blue_bright    = Util.brighten(colors.blue),
    magenta        = colors.magenta,
    magenta_bright = Util.brighten(colors.magenta),
    cyan           = colors.cyan,
    cyan_bright    = Util.brighten(colors.cyan),
    white          = colors.fg_dark,
    white_bright   = colors.fg,
  }

  opts.on_colors(colors)

  return colors, opts
end

return M
