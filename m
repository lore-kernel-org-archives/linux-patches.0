Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFAC219E7;
	Tue, 14 May 2024 11:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687007; cv=none; b=nRkzEYPsbMEBKKRkQ+0wo+Lu4EXCs4EaInLnCSXdi6aPUG/G078zwdSGPRXdrWWk8XdQvlGFXA1d+2QOLsGhqCVqyxwpOe1HOSgOOHWLP8Mydm1RxqIUUUpUl0U94oay71kgYO5KJva2Qqz2KTgQ4qsv02+9WO1ltZeRTyyquQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687007; c=relaxed/simple;
	bh=2jxXlH+c95SPvyciv/0W5c1a/dzNGWQdET47x9Vkc30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjoLd96qyPeL2uQR8QNNmgw/rgAvEyUNa83UVuVjenS1XnwqNrtCz1UDB+m2g7+u6PC+UUeozZI2GLRFq7zZGBcBhy8QAU7D0m3gvihhhOeojnhJtbDvbLGt62n01QupoCqav9OX3BeniwAnw48IQH5y62iRo0lQMcgpjGdb2oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbnIREDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbnIREDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8186C2BD10;
	Tue, 14 May 2024 11:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687007;
	bh=2jxXlH+c95SPvyciv/0W5c1a/dzNGWQdET47x9Vkc30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbnIREDhR/4kkXA34ed+y41qI0XSD0G+mTFI5ZZylUUhQqmdgcyCyxBnXfI8kp4+T
	 U+enRBg88Qcf76J8BHHXuAjQBZ+eLVINI+WptcA35R+CD7uQnLUBmtPYBPbVIr4oJ7
	 peD0udO1AJpbau6f83mWNhqagA/3gry76H58fnAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Light Hsieh <light.hsieh@mediatek.com>,
	Sean Wang <sean.wang@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/84] pinctrl: mediatek: Refine mtk_pinconf_get() and mtk_pinconf_set()
Date: Tue, 14 May 2024 12:19:18 +0200
Message-ID: <20240514100951.969613868@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Light Hsieh <light.hsieh@mediatek.com>

[ Upstream commit 3599cc525486be6681640ff3083376c001264c61 ]

1.Refine mtk_pinconf_get():
  Use only one occurrence of return at end of this function.

2.Refine mtk_pinconf_set():
2.1 Use only one occurrence of return at end of this function.
2.2 Modify case of PIN_CONFIG_INPUT_ENABLE -
2.2.1
    Regard all non-zero setting value as enable, instead of always enable.
2.2.2
    Remove check of ies_present flag and always invoke mtk_hw_set_value()
    since mtk_hw_pin_field_lookup() invoked inside mtk_hw_set_value() has
    the same effect of checking if ies control is supported.
    [The rationale is that: available of a control is always checked
     in mtk_hw_pin_field_lookup() and no need to add ies_present flag
     specially for ies control.]
2.3 Simply code logic for case of PIN_CONFIG_INPUT_SCHMITT.
2.4 Add case for PIN_CONFIG_INPUT_SCHMITT_ENABLE and process it with the
    same code for case of PIN_CONFIG_INPUT_SCHMITT.

Signed-off-by: Light Hsieh <light.hsieh@mediatek.com>
Link: https://lore.kernel.org/r/1579675994-7001-3-git-send-email-light.hsieh@mediatek.com
Acked-by: Sean Wang <sean.wang@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c5d3b64c568a ("pinctrl: mediatek: paris: Rework support for PIN_CONFIG_{INPUT,OUTPUT}_ENABLE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt6765.c |   1 -
 drivers/pinctrl/mediatek/pinctrl-mt8183.c |   1 -
 drivers/pinctrl/mediatek/pinctrl-paris.c  | 171 ++++++++--------------
 3 files changed, 65 insertions(+), 108 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt6765.c b/drivers/pinctrl/mediatek/pinctrl-mt6765.c
index 12122646bbc28..7fae397fe27c1 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt6765.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt6765.c
@@ -1070,7 +1070,6 @@ static const struct mtk_pin_soc mt6765_data = {
 	.ngrps = ARRAY_SIZE(mtk_pins_mt6765),
 	.eint_hw = &mt6765_eint_hw,
 	.gpio_m = 0,
-	.ies_present = true,
 	.base_names = mt6765_pinctrl_register_base_names,
 	.nbase_names = ARRAY_SIZE(mt6765_pinctrl_register_base_names),
 	.bias_disable_set = mtk_pinconf_bias_disable_set,
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8183.c b/drivers/pinctrl/mediatek/pinctrl-mt8183.c
index 9a74d5025be64..4eca81864a965 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8183.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8183.c
@@ -554,7 +554,6 @@ static const struct mtk_pin_soc mt8183_data = {
 	.ngrps = ARRAY_SIZE(mtk_pins_mt8183),
 	.eint_hw = &mt8183_eint_hw,
 	.gpio_m = 0,
-	.ies_present = true,
 	.base_names = mt8183_pinctrl_register_base_names,
 	.nbase_names = ARRAY_SIZE(mt8183_pinctrl_register_base_names),
 	.bias_disable_set = mtk_pinconf_bias_disable_set_rev1,
diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 93fa44504bdd7..5ee49da18b3de 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -81,37 +81,30 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 	int val, val2, err, reg, ret = 1;
 	const struct mtk_pin_desc *desc;
 
-	if (pin >= hw->soc->npins)
-		return -EINVAL;
+	if (pin >= hw->soc->npins) {
+		err = -EINVAL;
+		goto out;
+	}
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[pin];
 
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
-		if (hw->soc->bias_disable_get) {
+		if (hw->soc->bias_disable_get)
 			err = hw->soc->bias_disable_get(hw, desc, &ret);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		else
+			err = -ENOTSUPP;
 		break;
 	case PIN_CONFIG_BIAS_PULL_UP:
-		if (hw->soc->bias_get) {
+		if (hw->soc->bias_get)
 			err = hw->soc->bias_get(hw, desc, 1, &ret);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		else
+			err = -ENOTSUPP;
 		break;
 	case PIN_CONFIG_BIAS_PULL_DOWN:
-		if (hw->soc->bias_get) {
+		if (hw->soc->bias_get)
 			err = hw->soc->bias_get(hw, desc, 0, &ret);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		else
+			err = -ENOTSUPP;
 		break;
 	case PIN_CONFIG_SLEW_RATE:
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_SR, &val);
@@ -126,12 +119,16 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 	case PIN_CONFIG_OUTPUT_ENABLE:
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_DIR, &val);
 		if (err)
-			return err;
-
-		/* HW takes input mode as zero; output mode as non-zero */
-		if ((val && param == PIN_CONFIG_INPUT_ENABLE) ||
-		    (!val && param == PIN_CONFIG_OUTPUT_ENABLE))
-			return -EINVAL;
+			goto out;
+		/*     CONFIG     Current direction return value
+		 * -------------  ----------------- ----------------------
+		 * OUTPUT_ENABLE       output       1 (= HW value)
+		 *                     input        0 (= HW value)
+		 * INPUT_ENABLE        output       0 (= reverse HW value)
+		 *                     input        1 (= reverse HW value)
+		 */
+		if (param == PIN_CONFIG_INPUT_ENABLE)
+			val = !val;
 
 		break;
 	case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
@@ -148,13 +145,10 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 
 		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
-		if (hw->soc->drive_get) {
+		if (hw->soc->drive_get)
 			err = hw->soc->drive_get(hw, desc, &ret);
-			if (err)
-				return err;
-		} else {
+		else
 			err = -ENOTSUPP;
-		}
 		break;
 	case MTK_PIN_CONFIG_TDSEL:
 	case MTK_PIN_CONFIG_RDSEL:
@@ -175,28 +169,24 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 
 			pullup = param == MTK_PIN_CONFIG_PU_ADV;
 			err = hw->soc->adv_pull_get(hw, desc, pullup, &ret);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		} else
+			err = -ENOTSUPP;
 		break;
 	case MTK_PIN_CONFIG_DRV_ADV:
-		if (hw->soc->adv_drive_get) {
+		if (hw->soc->adv_drive_get)
 			err = hw->soc->adv_drive_get(hw, desc, &ret);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		else
+			err = -ENOTSUPP;
 		break;
 	default:
-		return -ENOTSUPP;
+		err = -ENOTSUPP;
 	}
 
-	*config = pinconf_to_config_packed(param, ret);
+out:
+	if (!err)
+		*config = pinconf_to_config_packed(param, ret);
 
-	return 0;
+	return err;
 }
 
 static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
@@ -215,60 +205,47 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 
 	switch ((u32)param) {
 	case PIN_CONFIG_BIAS_DISABLE:
-		if (hw->soc->bias_disable_set) {
+		if (hw->soc->bias_disable_set)
 			err = hw->soc->bias_disable_set(hw, desc);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		else
+			err = -ENOTSUPP;
 		break;
 	case PIN_CONFIG_BIAS_PULL_UP:
-		if (hw->soc->bias_set) {
+		if (hw->soc->bias_set)
 			err = hw->soc->bias_set(hw, desc, 1);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		else
+			err = -ENOTSUPP;
 		break;
 	case PIN_CONFIG_BIAS_PULL_DOWN:
-		if (hw->soc->bias_set) {
+		if (hw->soc->bias_set)
 			err = hw->soc->bias_set(hw, desc, 0);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		else
+			err = -ENOTSUPP;
 		break;
 	case PIN_CONFIG_OUTPUT_ENABLE:
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_SMT,
 				       MTK_DISABLE);
-		if (err)
+		/* Keep set direction to consider the case that a GPIO pin
+		 *  does not have SMT control
+		 */
+		if (err != -ENOTSUPP)
 			goto err;
 
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR,
 				       MTK_OUTPUT);
-		if (err)
-			goto err;
 		break;
 	case PIN_CONFIG_INPUT_ENABLE:
-		if (hw->soc->ies_present) {
-			mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_IES,
-					 MTK_ENABLE);
-		}
+		/* regard all non-zero value as enable */
+		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_IES, !!arg);
+		if (err)
+			goto err;
 
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR,
 				       MTK_INPUT);
-		if (err)
-			goto err;
 		break;
 	case PIN_CONFIG_SLEW_RATE:
-		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_SR,
-				       arg);
-		if (err)
-			goto err;
-
+		/* regard all non-zero value as enable */
+		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_SR, !!arg);
 		break;
 	case PIN_CONFIG_OUTPUT:
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR,
@@ -278,41 +255,29 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DO,
 				       arg);
-		if (err)
-			goto err;
 		break;
+	case PIN_CONFIG_INPUT_SCHMITT:
 	case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
 		/* arg = 1: Input mode & SMT enable ;
 		 * arg = 0: Output mode & SMT disable
 		 */
-		arg = arg ? 2 : 1;
-		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR,
-				       arg & 1);
+		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR, !arg);
 		if (err)
 			goto err;
 
-		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_SMT,
-				       !!(arg & 2));
-		if (err)
-			goto err;
+		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_SMT, !!arg);
 		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
-		if (hw->soc->drive_set) {
+		if (hw->soc->drive_set)
 			err = hw->soc->drive_set(hw, desc, arg);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		else
+			err = -ENOTSUPP;
 		break;
 	case MTK_PIN_CONFIG_TDSEL:
 	case MTK_PIN_CONFIG_RDSEL:
 		reg = (param == MTK_PIN_CONFIG_TDSEL) ?
 		       PINCTRL_PIN_REG_TDSEL : PINCTRL_PIN_REG_RDSEL;
-
 		err = mtk_hw_set_value(hw, desc, reg, arg);
-		if (err)
-			goto err;
 		break;
 	case MTK_PIN_CONFIG_PU_ADV:
 	case MTK_PIN_CONFIG_PD_ADV:
@@ -322,20 +287,14 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			pullup = param == MTK_PIN_CONFIG_PU_ADV;
 			err = hw->soc->adv_pull_set(hw, desc, pullup,
 						    arg);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		} else
+			err = -ENOTSUPP;
 		break;
 	case MTK_PIN_CONFIG_DRV_ADV:
-		if (hw->soc->adv_drive_set) {
+		if (hw->soc->adv_drive_set)
 			err = hw->soc->adv_drive_set(hw, desc, arg);
-			if (err)
-				return err;
-		} else {
-			return -ENOTSUPP;
-		}
+		else
+			err = -ENOTSUPP;
 		break;
 	default:
 		err = -ENOTSUPP;
-- 
2.43.0



