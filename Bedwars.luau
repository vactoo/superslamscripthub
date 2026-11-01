-- Services
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Create Main Screen Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BedwarsHubPrankGui"
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.Parent = playerGui

-- 2. Create Solid Background Frame
local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bgFrame.BorderSizePixel = 0
bgFrame.Parent = screenGui

-- 3. Fullscreen Image Layer for the Reveal
local fullScreenImage = Instance.new("ImageLabel")
fullScreenImage.Name = "RevealImage"
fullScreenImage.Size = UDim2.new(1, 0, 1, 0)
fullScreenImage.Position = UDim2.new(0, 0, 0, 0)
fullScreenImage.BackgroundTransparency = 1
fullScreenImage.ScaleType = Enum.ScaleType.Stretch
fullScreenImage.Image = "rbxassetid://6404704459"
fullScreenImage.Visible = false
fullScreenImage.Parent = bgFrame

-- 4. Image Container for the First 15 Seconds
local startupImageContainer = Instance.new("Frame")
startupImageContainer.Size = UDim2.new(0, 250, 0, 250)
startupImageContainer.Position = UDim2.new(0.5, 0, 0.15, 0)
startupImageContainer.AnchorPoint = Vector2.new(0.5, 0.5)
startupImageContainer.BackgroundTransparency = 1
startupImageContainer.Parent = screenGui

local imgPhase1 = Instance.new("ImageLabel")
imgPhase1.Size = UDim2.new(1, 0, 1, 0)
imgPhase1.BackgroundTransparency = 1
imgPhase1.ScaleType = Enum.ScaleType.Fit
imgPhase1.Image = "rbxassetid://130521044774541"
imgPhase1.Parent = startupImageContainer

-- 5. Create Main Text Label
local mainLabel = Instance.new("TextLabel")
mainLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
mainLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
mainLabel.BackgroundTransparency = 1
mainLabel.Text = ""
mainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
mainLabel.TextScaled = true
mainLabel.Font = Enum.Font.Code
mainLabel.Parent = bgFrame

-- Track active sounds and loops for the kill switch clean-up
local activeSounds = {}
local isRunning = true

-- 6. Global Click Sound Effect (Plays asset 136774133309136 on every click)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not isRunning then return end
	
	-- Check for mouse clicks or touch presses
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local clickSound = Instance.new("Sound")
		clickSound.SoundId = "rbxassetid://85047859986879"
		clickSound.Volume = 4.0
		clickSound.Parent = SoundService
		clickSound:Play()
		table.insert(activeSounds, clickSound)
		game.Debris:AddItem(clickSound, 2)
	end
	
	-- Hidden Kill Switch (Page Down Key)
	if input.KeyCode == Enum.KeyCode.PageDown then
		isRunning = false
		for _, s in ipairs(activeSounds) do
			if s and s.Parent then
				s:Stop()
				s:Destroy()
			end
		end
		screenGui:Destroy()
	end
end)

-- 7. Setup Primary Audio (Stadium Rave A) at Volume 2.5
local mainSound = Instance.new("Sound")
mainSound.SoundId = "rbxassetid://1846368080"
mainSound.Volume = 2.5
mainSound.Looped = true
mainSound.Parent = SoundService
mainSound:Play()
table.insert(activeSounds, mainSound)

-- 8. Bloat Engine Overhead Simulation
task.spawn(function()
	local bloatStorage = {}
	while isRunning do
		for i = 1, 1000 do
			table.insert(bloatStorage, "bloat_" .. tostring(i))
		end
		if #bloatStorage > 50000 then
			table.clear(bloatStorage)
		end
		task.wait(0.1)
	end
end)

-- 9. Rapid Escape Key Spam (VirtualInputManager)
local success, vim = pcall(function()
	return game:GetService("VirtualInputManager")
end)

task.spawn(function()
	while isRunning do
		if success and vim then
			vim:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
			task.wait(0.02)
			vim:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
		end
		task.wait(0.05)
	end
end)

-- 10. Gentle Floating Animation for Startup Image (First 15 seconds)
local floatTime = 0
local isRevealed = false

RunService.RenderStepped:Connect(function(deltaTime)
	if not isRunning then return end
	if not isRevealed then
		floatTime = floatTime + deltaTime
		local offsetY = math.sin(floatTime * 3) * 10
		startupImageContainer.Position = UDim2.new(0.5, 0, 0.15, offsetY)
	end
end)

-- 11. Typewriter, Volume Scaling, Reveal Transition & Effects Logic
task.spawn(function()
	local fullTitle = "Bedwars Ultimate Superslam Script Hub v8.6.1"
	local totalChars = #fullTitle
	local typeDuration = 12
	local delayPerChar = typeDuration / totalChars

	-- Slowly type out the script hub title over 12 seconds
	for i = 1, totalChars do
		if not isRunning then return end
		mainLabel.Text = string.sub(fullTitle, 1, i)
		task.wait(delayPerChar)
	end

	-- Wait until the exact 15-second mark from execution start
	task.wait(15 - typeDuration)
	if not isRunning then return end

	-- === 15-SECOND MARK TRIGGER ===
	isRevealed = true
	
	-- Stop and completely remove the first song so the screaming takes over
	if mainSound and mainSound.Parent then
		mainSound:Stop()
		mainSound:Destroy()
	end

	-- Clean up startup elements and switch to full-screen image
	startupImageContainer:Destroy()
	fullScreenImage.Visible = true

	-- --- Sound Layer 1 (Fast Screaming Repeater) ---
	task.spawn(function()
		local soundId1 = "rbxassetid://138776356539253"
		while isRunning do
			local s1 = Instance.new("Sound")
			s1.SoundId = soundId1
			s1.Volume = 5.0
			s1.Parent = SoundService
			s1:Play()
			table.insert(activeSounds, s1)
			game.Debris:AddItem(s1, 2)
			task.wait(0.15)
		end
	end)

	-- --- Sound Layer 2 (Staggered Screaming Repeater) ---
	task.spawn(function()
		local soundId2 = "rbxassetid://138850265160928"
		task.wait(0.05)
		while isRunning do
			local s2 = Instance.new("Sound")
			s2.SoundId = soundId2
			s2.Volume = 5.0
			s2.Parent = SoundService
			s2:Play()
			table.insert(activeSounds, s2)
			game.Debris:AddItem(s2, 2)
			task.wait(0.20)
		end
	end)

	-- --- Sound Layer 3 (High-Frequency Screaming Strobe Repeater) ---
	task.spawn(function()
		local soundId3 = "rbxassetid://123573408898322"
		task.wait(0.10)
		while isRunning do
			local s3 = Instance.new("Sound")
			s3.SoundId = soundId3
			s3.Volume = 5.0
			s3.Parent = SoundService
			s3:Play()
			table.insert(activeSounds, s3)
			game.Debris:AddItem(s3, 2)
			task.wait(0.12)
		end
	end)

	-- Update text for the reveal phase
	mainLabel.Text = "NO SCRIPT FOR YOU HAHA!"
	mainLabel.Font = Enum.Font.FredokaOne
	mainLabel.Position = UDim2.new(0.05, 0, 0.7, 0)

	-- Black flicker & Blue/White text flashing loop
	local flickerTimer = 0
	RunService.RenderStepped:Connect(function(deltaTime)
		if not isRunning then return end
		flickerTimer = flickerTimer + deltaTime
		
		-- Black flicker strobe effect
		if math.floor(flickerTimer * 12) % 2 == 0 then
			fullScreenImage.ImageTransparency = 0.2
			bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		else
			fullScreenImage.ImageTransparency = 0
			bgFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end

		-- Rapid flashing between Vivid Blue and White text
		if math.floor(flickerTimer * 8) % 2 == 0 then
			mainLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
		else
			mainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
	end)
end)