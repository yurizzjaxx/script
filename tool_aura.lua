game:GetService("StarterGui"):SetCore("SendNotification", {
  Title = "OP Killaura";
  Text = "Discord by yurizzjaxx_";
  Dinglish = "Tool"
})
Duration = 16;

  -- Configuração inicial
getgenv().Range = 16
getgenv().AuraEnabled = false

-- Serviços
local players = game:GetService("Players")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Criar a interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillAuraUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false -- Impede que a GUI reset ao respawn
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0, 650, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Label do título
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleLabel.Text = "Op killaura"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.Parent = MainFrame

-- Botão de fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = MainFrame

-- Botão toggle
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -60, 0.5, -20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ToggleButton.Text = "aura OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = MainFrame

-- Status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -20)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Range: " .. Range .. " by yurizzjaxx_"

StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = MainFrame

-- Função para fechar a janela
CloseButton.MouseButton1Click:Connect(function()
    AuraEnabled = false
    ScreenGui:Destroy()
end)

-- Função para toggle do aura
ToggleButton.MouseButton1Click:Connect(function()
    AuraEnabled = not AuraEnabled
    
    if AuraEnabled then
        ToggleButton.Text = "aura ON"
        ToggleButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
    else
        ToggleButton.Text = "aura OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

-- Função do killaura
local function getPartsInViewport(maxDistance)
    local partsInViewport = {}
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local distance = player:DistanceFromCharacter(part.Position)
            if distance <= maxDistance then
                local _, isVisible = camera:WorldToViewportPoint(part.Position)
                if isVisible then
                    table.insert(partsInViewport, part)
                end
            end
        end
    end
    return partsInViewport
end

-- Loop principal do killaura
coroutine.wrap(function()
    while true do
        wait() -- Reduzi a frequência para melhor performance
        
        if AuraEnabled and player.Character then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            local parts = getPartsInViewport(Range)

            if tool and tool:FindFirstChild("Handle") then
                for _, part in ipairs(parts) do
                    if part and part.Parent and part.Parent ~= player.Character then
                        local humanoid = part.Parent:FindFirstChildWhichIsA("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            tool:Activate()
                            firetouchinterest(tool.Handle, part, 0)
                            firetouchinterest(tool.Handle, part, 1)
                        end
                    end
                end
            end
        end
    end
end)()

game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "KillAuraUI" then
        local newGui = ScreenGui:Clone()
        newGui.Parent = game:GetService("CoreGui")
        ScreenGui = newGui
    end
end)

-- Função para arrastar a janela
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)