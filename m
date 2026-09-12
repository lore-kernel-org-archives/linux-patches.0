Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1FB430311;
	Sat, 12 Sep 2026 08:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202629; cv=none; b=nBKp/w6EDErc6UI1TwZjfi9kGdBxMrQ3DPtjSdZTECq2zq0EA9VvFu7yplDlueB7gx3yJ8b8EPH4SaJCmmVf6o2pm7QOUnERRIiFfDWXlK96s87AzB6YtJaby8SAMHF5/BRzDyYXTJ2mgg3QoiGyP/Rh+7ON/TPA4E3aWg6rhTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202629; c=relaxed/simple;
	bh=iRr44cw9b9+gODxUXwlus4HGetguYJQt91ftJTbFYD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZKpeRHyXYeFduaCnMxJNvYXgvpzdSgpVOywYNnbf3vPdBXDvS1e67CHO8DSHQoFt4Mlu201TTtU60G8hPiBaliPvoRNA05ALY0rIBUmdlqITXAqxeBLxzSwXdrJWuPKdmG0nh5gTzxUdVeZ1hs15fjhkj89V0aR/dcn6Uacio8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMcO5v3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMcO5v3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF6C1F000FF;
	Sat, 12 Sep 2026 08:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202628;
	bh=zVSth1Us/nSkCSb7pR4dPR8t4vksjK4RILgdVFv1zeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMcO5v3K1cHYeQN7VoyNMT9hhIfhM5cSLeH2Mlq96Rv9ep3kCGNwYL/cgwUylrVfG
	 nCTaLIn8nVrdDGQXmCHM1BykfTRmbIE2s9/DpoY9c4DyvAleXnW1YWUhTgB+36EnL3
	 W25DT1it/HAWoneOUzPfngbTJ7IBkQqKcqJ9qyvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1243/1815] pinctrl: airoha: add missed get_direction() function for gpio_chip
Date: Sat, 12 Sep 2026 08:49:53 +0200
Message-ID: <20260912065718.194490868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit d6392502a9e6b11c3a93eb4c987672a8c638d749 ]

This patch adds missed get_direction() function for gpio_chip.
Also it reimplements pinconf's get_direction() function using
newly defined function.

Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/airoha/pinctrl-airoha.c | 50 +++++++++++++++++--------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/airoha/pinctrl-airoha.c b/drivers/pinctrl/airoha/pinctrl-airoha.c
index 4900df81a5e75..4265b0a457621 100644
--- a/drivers/pinctrl/airoha/pinctrl-airoha.c
+++ b/drivers/pinctrl/airoha/pinctrl-airoha.c
@@ -2504,6 +2504,22 @@ static int airoha_gpio_get(struct gpio_chip *chip, unsigned int gpio)
 	return err ? err : !!(val & BIT(pin));
 }
 
+static int airoha_gpio_get_direction(struct gpio_chip *chip, unsigned int gpio)
+{
+	struct airoha_pinctrl *pinctrl = gpiochip_get_data(chip);
+	u32 val, mask;
+	u8 index;
+	int err;
+
+	index = gpio / AIROHA_REG_GPIOCTRL_NUM_PIN;
+	err = regmap_read(pinctrl->regmap, pinctrl->gpiochip.dir[index], &val);
+	if (err)
+		return err;
+
+	mask = BIT(2 * (gpio % AIROHA_REG_GPIOCTRL_NUM_PIN));
+	return val & mask ? GPIO_LINE_DIRECTION_OUT : GPIO_LINE_DIRECTION_IN;
+}
+
 static int airoha_gpio_direction_output(struct gpio_chip *chip,
 					unsigned int gpio, int value)
 {
@@ -2637,19 +2653,13 @@ static int airoha_pinctrl_add_gpiochip(struct airoha_pinctrl *pinctrl,
 	struct device *dev = &pdev->dev;
 	int irq, err;
 
-	chip->data = gpio_data_regs;
-	chip->dir = gpio_dir_regs;
-	chip->out = gpio_out_regs;
-	chip->status = irq_status_regs;
-	chip->level = irq_level_regs;
-	chip->edge = irq_edge_regs;
-
 	gc->parent = dev;
 	gc->label = dev_name(dev);
 	gc->request = gpiochip_generic_request;
 	gc->free = gpiochip_generic_free;
 	gc->direction_input = pinctrl_gpio_direction_input;
 	gc->direction_output = airoha_gpio_direction_output;
+	gc->get_direction = airoha_gpio_get_direction;
 	gc->set = airoha_gpio_set;
 	gc->get = airoha_gpio_get;
 	gc->base = -1;
@@ -2859,21 +2869,18 @@ static int airoha_pinctrl_set_conf(struct airoha_pinctrl *pinctrl,
 static int airoha_pinconf_get_direction(struct pinctrl_dev *pctrl_dev, u32 p)
 {
 	struct airoha_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctrl_dev);
-	u32 val, mask;
-	int err, pin;
-	u8 index;
+	int ret, pin;
 
 	pin = airoha_convert_pin_to_reg_offset(pctrl_dev, NULL, p);
 	if (pin < 0)
 		return pin;
 
-	index = pin / AIROHA_REG_GPIOCTRL_NUM_PIN;
-	err = regmap_read(pinctrl->regmap, pinctrl->gpiochip.dir[index], &val);
-	if (err)
-		return err;
+	ret = airoha_gpio_get_direction(&pinctrl->gpiochip.chip, pin);
+	if (ret < 0)
+		return ret;
 
-	mask = BIT(2 * (pin % AIROHA_REG_GPIOCTRL_NUM_PIN));
-	return val & mask ? PIN_CONFIG_OUTPUT_ENABLE : PIN_CONFIG_INPUT_ENABLE;
+	return ret == GPIO_LINE_DIRECTION_OUT ?
+	       PIN_CONFIG_OUTPUT_ENABLE : PIN_CONFIG_INPUT_ENABLE;
 }
 
 static int airoha_pinconf_get(struct pinctrl_dev *pctrl_dev,
@@ -3119,6 +3126,17 @@ static int airoha_pinctrl_probe(struct platform_device *pdev)
 	pinctrl->desc.pins = data->pins;
 	pinctrl->desc.npins = data->num_pins;
 
+	/*
+	 * some pinctrl operations (ex: get_direction) might use gpio registers
+	 * before gpio chip abstraction will be completely initialized.
+	 */
+	pinctrl->gpiochip.data = gpio_data_regs;
+	pinctrl->gpiochip.dir = gpio_dir_regs;
+	pinctrl->gpiochip.out = gpio_out_regs;
+	pinctrl->gpiochip.status = irq_status_regs;
+	pinctrl->gpiochip.level = irq_level_regs;
+	pinctrl->gpiochip.edge = irq_edge_regs;
+
 	err = devm_pinctrl_register_and_init(dev, &pinctrl->desc,
 					     pinctrl, &pinctrl->ctrl);
 	if (err)
-- 
2.53.0



