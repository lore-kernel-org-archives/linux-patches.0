Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E138142EEAC;
	Sat, 12 Sep 2026 10:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210610; cv=none; b=p7ozAS7GyXJdewuoHeZADpQlEif3L5Pw6mJh8FTlH+1MTeo+NJArsdY3lmmhgjOthYrVyBnQmsDDzoe+0JIephIbK1xvXO3ZS7lrr6HsFzsmALfm7xc8puF71rog3eP0A5Q+NuUhoXqVhzlC0lOUX83Q45wwvXWiDVjg94z/FuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210610; c=relaxed/simple;
	bh=4C+Qv7vYWQoaviVJaqjDp4IKUYH5Cu8bYAvazxdM/so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrBp0D/ZDi7se03wKR/CwwGA/xdbVWeLjGwOlgGm+CzGqKtnCfdaaAc0C0O9dRHSDQT8GVU3sKa3ruQIAGAr82CcNi71Ghz95pnz1RBxmSDhIsOn6qNjp8Emef6p65Mf4jhH5R+bMITbsxSPuCO31ynIIkDtsdJl0v41eGwUSkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBZYu8rv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBZYu8rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36371F000FF;
	Sat, 12 Sep 2026 10:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210608;
	bh=JxmWoxh7B5XEXb3nfF6+jkKvxkmPRMwlYzrtGyYj3e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBZYu8rvqCzrWe+wwvZsvPQSceBP53cx8DBwwPB5up/8TZoWFHj0nJP33KkCKIjDj
	 9kTFEGIVWVpWYdXUGRMOP9GZdBr1I1vyzVYkSMS89/eiAbW2aDoSgFIJXD5D/FcVd7
	 mjFnM6rxBeGGBYxMthCB9ee04VjlA39c7dYN2p/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1018/1518] pinctrl: airoha: add missed get_direction() function for gpio_chip
Date: Sat, 12 Sep 2026 08:53:07 +0200
Message-ID: <20260912065646.481212427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 50 +++++++++++++++--------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index eb099baf74dd5..e2ba5619d44b1 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -2502,6 +2502,22 @@ static int airoha_gpio_get(struct gpio_chip *chip, unsigned int gpio)
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
@@ -2635,19 +2651,13 @@ static int airoha_pinctrl_add_gpiochip(struct airoha_pinctrl *pinctrl,
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
@@ -2857,21 +2867,18 @@ static int airoha_pinctrl_set_conf(struct airoha_pinctrl *pinctrl,
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
@@ -3117,6 +3124,17 @@ static int airoha_pinctrl_probe(struct platform_device *pdev)
 	pinctrl->desc.pins = data->pins,
 	pinctrl->desc.npins = data->num_pins,
 
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



