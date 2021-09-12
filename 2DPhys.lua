--[[
Made by toonrun123V2
9.12.2021 (m/d/y).

Custom physics (not newton's law)

understand uself.

SCALE-ONLY
]]

local tweenservice = game:GetService("TweenService")

local mouse:Mouse = game.Players.LocalPlayer:GetMouse()
local info = TweenInfo.new(0.1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,0)

local HostFrame = script.Parent.Parent --[[HostFrame]]
local Frame = script.Parent --[[Box]]

local Camera = workspace.CurrentCamera

local Weight = 1
local SpeedPhysicsLower = 1
local Speed2DLower = 2
local Bouncedivide = 2
local bounceside = {
	["Down"] = false,
	["Left"] = true,
	["Right"] = true
}

--These Settings Change eveytimes=======
local weight = 0
local XD = nil
local future_position = nil
local Rotation = nil
local IsInProcess = nil

local lastx = nil
local lasty = nil
local newx = nil
local newy = nil
local enable = false
local reversespeed = 0
local oldspeedx = 0
local oldspeedy = 0
--====================================

local Floor,abs = math.floor,math.abs

mouse.Button1Down:Connect(function()
	enable = true
end)
mouse.Button1Up:Connect(function()
	enable = false
end)

local function ScaleToOffset(Scale)
	local ViewPortSize = Camera.ViewportSize
	return ({ViewPortSize.X * Scale[1],ViewPortSize.Y * Scale[2]})
end

local function OffsetToScale(Offset)
	local ViewPortSize = Camera.ViewportSize
	return ({Offset[1] / ViewPortSize.X, Offset[2] / ViewPortSize.Y})
end

game:GetService("RunService").RenderStepped:Connect(function()
	weight = (Frame.AbsoluteSize.X/2)+(Frame.AbsoluteSize.Y/2)
	if enable then
		if not lastx then
			lastx = mouse.X
		end
		if not lasty then
			lasty = mouse.Y
		end
		
		newx = -(lastx - mouse.X)/Weight
		newy = -(lasty - mouse.Y)/Weight
		oldspeedx = newx
		oldspeedy = newy
	else
		if oldspeedx >= 1 then
			oldspeedx -= SpeedPhysicsLower
		end
		if oldspeedx <= -1 then
			oldspeedx += SpeedPhysicsLower
		end
		if oldspeedx <= 1 and oldspeedx >= 0 then
			oldspeedx = 0
		end
		if oldspeedx >= -1 and oldspeedx <= 0 then
			oldspeedx = 0
		end
		oldspeedy += abs(weight/200*((workspace.Gravity/100)-1*10))
	end
	XD = OffsetToScale({oldspeedx/Speed2DLower,oldspeedy/Speed2DLower})
	future_position = Frame.Position + UDim2.new(XD[1],0,XD[2],0)
	Rotation = OffsetToScale({Frame.Rotation,Frame.Rotation})
	IsInProcess = false
	Frame.Position = future_position
	if Frame.Position.Y.Scale < 0 then
		oldspeedy = 0
		Frame.Position = UDim2.new(future_position.X.Scale,0,0,0)
	elseif Frame.Position.Y.Scale > 1-Frame.Size.Y.Scale then
		if bounceside["Down"] then
			oldspeedy = Floor(-(oldspeedy/Bouncedivide))
		else
			oldspeedy = 0
		end
		--[[
		XD = OffsetToScale({oldspeedx/Speed2DLower,oldspeedy/Speed2DLower})
		future_position = Frame.Position + UDim2.new(XD[1],0,XD[2],0)
		
		Dont enabled it because it will broke speed physics
		]]
		Frame.Position = UDim2.new(future_position.X.Scale,0,future_position.Y.Scale,0)
		if Frame.Position.Y.Scale > 1-Frame.Size.Y.Scale then
			Frame.Position = UDim2.new(future_position.X.Scale,0,1-Frame.Size.Y.Scale,0)
		end
		IsInProcess = true
	end
	if Frame.Position.X.Scale < 0 then
		if bounceside["Left"] then
			oldspeedx = Floor(-(oldspeedx/Bouncedivide))
		else
			oldspeedx = 0
		end
		XD = OffsetToScale({oldspeedx/Speed2DLower,oldspeedy/Speed2DLower})
		future_position = Frame.Position + UDim2.new(XD[1],0,XD[2],0)
		Frame.Position = UDim2.new(0,0,future_position.Y.Scale,0)
		IsInProcess = true
	elseif Frame.Position.X.Scale > 1-Frame.Size.X.Scale then
		if bounceside["Right"] then
			oldspeedx = Floor(-(oldspeedx/Bouncedivide))
		else
			oldspeedx = 0
		end
		XD = OffsetToScale({oldspeedx/Speed2DLower,oldspeedy/Speed2DLower})
		future_position = Frame.Position + UDim2.new(XD[1],0,XD[2],0)
		Frame.Position = UDim2.new(1-Frame.Size.X.Scale,0,Frame.Position.Y.Scale,0)
		IsInProcess = true
	end
	--[[if oldspeedx >= 1 then
		oldspeedx += oldspeedx/10
	end
	if oldspeedx <= -1 then
		oldspeedx -= oldspeedx/10
	end]]
	--[[if oldspeedx < reversespeed then
		warn(oldspeedx,reversespeed)
		local Speedclone = script.Parent.Parent:WaitForChild("sPEED"):Clone()
		Speedclone.Text = oldspeedx.." "..reversespeed
		Speedclone.Parent = HostFrame
		Speedclone.Position = Frame.Position
	end
	reversespeed = oldspeedx
	
	UNUSED
	]]
	lasty = mouse.Y
	lastx = mouse.X
end)
