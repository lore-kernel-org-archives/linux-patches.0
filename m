Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70EB1E51E1;
	Tue, 26 Aug 2025 13:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215457; cv=none; b=cbwY5tfjv56KGAJ6Um18V9g0i3Di7K1A84WotMJJqYR8Jv0Gp12fqYMge37t5/RL+CeJk1v+OOHyUeawa01tPs3A21g/LXU6gK6UEw9p204DxtlzpU9IWbhdEqD0C4fpRMYCZr0V9MYZKQ69LJa9L1lcKxmhktdGMbbhixQdwZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215457; c=relaxed/simple;
	bh=1/nyU+7C2YMZjA7kqd7Q+FlNxP6pqP1YL0+vcvClPaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnUC4VQ9F5ww+cXSu7spIwEt8cYShkAVYity6GviQ8F3Sh3iCl5Oi814uJ4Ize+7v2CfDbFrkABwcPxnv6sLEuggqvjYwD2jioZF1eiCuP5gGcJCJc2hBXTe6sQlVhwC7+hZy7BxQcjnur2+A+xBjVYevkpNFTpmLq8Nson0eKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtAIRjIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtAIRjIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79155C4CEF1;
	Tue, 26 Aug 2025 13:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215456;
	bh=1/nyU+7C2YMZjA7kqd7Q+FlNxP6pqP1YL0+vcvClPaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtAIRjIrXACep1AgFLgHLS8EfCSJob6afallG0IPqzH6Pdp0dWvOl9/HlscTpgnq6
	 DYE1gn45tKmaXEf2OjaYPQ7Vz70MUUnqy2sc9uw1h/CxT7OAJFKD0jz9NecL4q0tM9
	 U+6wulxDUO+6wPU871kB0CKO6r5nvsUt54IsmnHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Shih <sam.shih@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/644] pinctrl: mediatek: moore: check if pin_desc is valid before use
Date: Tue, 26 Aug 2025 13:02:12 +0200
Message-ID: <20250826110947.528291016@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Shih <sam.shih@mediatek.com>

[ Upstream commit d8b94c9ff96c2024a527086d850eb0b314337ff9 ]

Certain SoC are missing the middle part gpios in consecutive pins,
it's better to check if mtk_pin_desc is a valid pin for the extensibility

Signed-off-by: Sam Shih <sam.shih@mediatek.com>
Acked-by: Sean Wang <sean.wang@mediatek.com>
Link: https://lore.kernel.org/r/20210914085137.31761-5-sam.shih@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 705c79101ccf ("smb: client: fix use-after-free in cifs_oplock_break")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-moore.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.c b/drivers/pinctrl/mediatek/pinctrl-moore.c
index 3a4a23c40a719..ad3b671639735 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -60,6 +60,8 @@ static int mtk_pinmux_set_mux(struct pinctrl_dev *pctldev,
 		int pin = grp->pins[i];
 
 		desc = (const struct mtk_pin_desc *)&hw->soc->pins[pin];
+		if (!desc->name)
+			return -ENOTSUPP;
 
 		mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_MODE,
 				 pin_modes[i]);
@@ -76,6 +78,8 @@ static int mtk_pinmux_gpio_request_enable(struct pinctrl_dev *pctldev,
 	const struct mtk_pin_desc *desc;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[pin];
+	if (!desc->name)
+		return -ENOTSUPP;
 
 	return mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_MODE,
 				hw->soc->gpio_m);
@@ -89,6 +93,8 @@ static int mtk_pinmux_gpio_set_direction(struct pinctrl_dev *pctldev,
 	const struct mtk_pin_desc *desc;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[pin];
+	if (!desc->name)
+		return -ENOTSUPP;
 
 	/* hardware would take 0 as input direction */
 	return mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR, !input);
@@ -103,6 +109,8 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 	const struct mtk_pin_desc *desc;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[pin];
+	if (!desc->name)
+		return -ENOTSUPP;
 
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
@@ -218,6 +226,8 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 	int cfg, err = 0;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[pin];
+	if (!desc->name)
+		return -ENOTSUPP;
 
 	for (cfg = 0; cfg < num_configs; cfg++) {
 		param = pinconf_to_config_param(configs[cfg]);
@@ -435,6 +445,8 @@ static int mtk_gpio_get(struct gpio_chip *chip, unsigned int gpio)
 	int value, err;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[gpio];
+	if (!desc->name)
+		return -ENOTSUPP;
 
 	err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_DI, &value);
 	if (err)
@@ -449,6 +461,10 @@ static void mtk_gpio_set(struct gpio_chip *chip, unsigned int gpio, int value)
 	const struct mtk_pin_desc *desc;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[gpio];
+	if (!desc->name) {
+		dev_err(hw->dev, "Failed to set gpio %d\n", gpio);
+		return;
+	}
 
 	mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DO, !!value);
 }
@@ -490,6 +506,8 @@ static int mtk_gpio_set_config(struct gpio_chip *chip, unsigned int offset,
 	u32 debounce;
 
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[offset];
+	if (!desc->name)
+		return -ENOTSUPP;
 
 	if (!hw->eint ||
 	    pinconf_to_config_param(config) != PIN_CONFIG_INPUT_DEBOUNCE ||
-- 
2.39.5



