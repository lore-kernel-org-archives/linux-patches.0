Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC5757CBC;
	Tue, 14 May 2024 11:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686943; cv=none; b=JLfg6bN4mC0ynetlHD/3ZNSrZ6REOUBwdQDx6ey/Ob53cQliCNjsHe0t3b23du+Z7gIX4kw0JSuyX2R0w9uBtWhzg1mAWmiA/PxOD/59kYgOxVjHZG9B0vcEdiRa5IMaatTkWPzIQCOJROVYN6ixKWDJvL38aRVhTbwbW36hvhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686943; c=relaxed/simple;
	bh=q1vPWBGd63YkvvZrnelE36DBA/nj6/d1swBKJIjCg28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hY6xxVgMvksqtBo9ETztkrPy2ORR68JB8SEvGfs0d0c6C0yomsXczhMO0AwvESsDaD7yqcInpg8ERfc6gJqO+kxXF/WI7hxsXbWZzuUt3GpowfnogDwtBYCbAf06KZoLb/x7ZYJD4EYAGfyT4oewmUeyxVv8DQUqA2RP75Q+wq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RB0++80c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RB0++80c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ABCC2BD10;
	Tue, 14 May 2024 11:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686943;
	bh=q1vPWBGd63YkvvZrnelE36DBA/nj6/d1swBKJIjCg28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RB0++80cFcbWIf0qsuD4idpwwMMgmQDG5uAZzJaf9KBPkQqvaGDkT9MbcsbthMyt3
	 vfwUGd+UoVVW1sy6XPjExWolvI6QXb8lUP37hJNRVNxnqM9i105Ot5jXWHLmTJ6+eF
	 Fto9PO6K+wjKRsyFn9n5Hf2ZePsu++NaWYLCpk0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/84] pinctrl: mediatek: paris: Rework mtk_pinconf_{get,set} switch/case logic
Date: Tue, 14 May 2024 12:19:23 +0200
Message-ID: <20240514100952.155517670@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 9b780fa1ff14663c2e0f07ad098b96b8337f27a4 ]

The current code deals with optional features by testing for the
function pointers and returning -ENOTSUPP if it is not valid. This is
done for multiple pin config settings and results in the code that
handles the supporting cases to get indented by one level. This is
aggrevated by the fact that some features require another level of
conditionals.

Instead of assigning the same error code in all unsupported optional
feature cases, simply have that error code as the default, and break
out of the switch/case block whenever a feature is unsupported, or an
error is returned. This reduces indentation by one level for the useful
code.

Also replace the goto statements with break statements. The result is
the same, as the gotos simply exit the switch/case block, which can
also be achieved with a break statement. With the latter the intent
is clear and easier to understand.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220308100956.2750295-8-wenst@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c5d3b64c568a ("pinctrl: mediatek: paris: Rework support for PIN_CONFIG_{INPUT,OUTPUT}_ENABLE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 144 ++++++++++-------------
 1 file changed, 61 insertions(+), 83 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index cb4979cefdd09..f568df4f0f643 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -78,37 +78,34 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 {
 	struct mtk_pinctrl *hw = pinctrl_dev_get_drvdata(pctldev);
 	u32 param = pinconf_to_config_param(*config);
-	int pullup, err, reg, ret = 1;
+	int pullup, reg, err = -ENOTSUPP, ret = 1;
 	const struct mtk_pin_desc *desc;
 
-	if (pin >= hw->soc->npins) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (pin >= hw->soc->npins)
+		return -EINVAL;
+
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[pin];
 
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
 	case PIN_CONFIG_BIAS_PULL_UP:
 	case PIN_CONFIG_BIAS_PULL_DOWN:
-		if (hw->soc->bias_get_combo) {
-			err = hw->soc->bias_get_combo(hw, desc, &pullup, &ret);
-			if (err)
-				goto out;
-			if (ret == MTK_PUPD_SET_R1R0_00)
-				ret = MTK_DISABLE;
-			if (param == PIN_CONFIG_BIAS_DISABLE) {
-				if (ret != MTK_DISABLE)
-					err = -EINVAL;
-			} else if (param == PIN_CONFIG_BIAS_PULL_UP) {
-				if (!pullup || ret == MTK_DISABLE)
-					err = -EINVAL;
-			} else if (param == PIN_CONFIG_BIAS_PULL_DOWN) {
-				if (pullup || ret == MTK_DISABLE)
-					err = -EINVAL;
-			}
-		} else {
-			err = -ENOTSUPP;
+		if (!hw->soc->bias_get_combo)
+			break;
+		err = hw->soc->bias_get_combo(hw, desc, &pullup, &ret);
+		if (err)
+			break;
+		if (ret == MTK_PUPD_SET_R1R0_00)
+			ret = MTK_DISABLE;
+		if (param == PIN_CONFIG_BIAS_DISABLE) {
+			if (ret != MTK_DISABLE)
+				err = -EINVAL;
+		} else if (param == PIN_CONFIG_BIAS_PULL_UP) {
+			if (!pullup || ret == MTK_DISABLE)
+				err = -EINVAL;
+		} else if (param == PIN_CONFIG_BIAS_PULL_DOWN) {
+			if (pullup || ret == MTK_DISABLE)
+				err = -EINVAL;
 		}
 		break;
 	case PIN_CONFIG_SLEW_RATE:
@@ -118,7 +115,7 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 	case PIN_CONFIG_OUTPUT_ENABLE:
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_DIR, &ret);
 		if (err)
-			goto out;
+			break;
 		/*     CONFIG     Current direction return value
 		 * -------------  ----------------- ----------------------
 		 * OUTPUT_ENABLE       output       1 (= HW value)
@@ -133,23 +130,21 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 	case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_DIR, &ret);
 		if (err)
-			goto out;
+			break;
 		/* return error when in output mode
 		 * because schmitt trigger only work in input mode
 		 */
 		if (ret) {
 			err = -EINVAL;
-			goto out;
+			break;
 		}
 
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_SMT, &ret);
-
 		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
-		if (hw->soc->drive_get)
-			err = hw->soc->drive_get(hw, desc, &ret);
-		else
-			err = -ENOTSUPP;
+		if (!hw->soc->drive_get)
+			break;
+		err = hw->soc->drive_get(hw, desc, &ret);
 		break;
 	case MTK_PIN_CONFIG_TDSEL:
 	case MTK_PIN_CONFIG_RDSEL:
@@ -159,23 +154,18 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 		break;
 	case MTK_PIN_CONFIG_PU_ADV:
 	case MTK_PIN_CONFIG_PD_ADV:
-		if (hw->soc->adv_pull_get) {
-			pullup = param == MTK_PIN_CONFIG_PU_ADV;
-			err = hw->soc->adv_pull_get(hw, desc, pullup, &ret);
-		} else
-			err = -ENOTSUPP;
+		if (!hw->soc->adv_pull_get)
+			break;
+		pullup = param == MTK_PIN_CONFIG_PU_ADV;
+		err = hw->soc->adv_pull_get(hw, desc, pullup, &ret);
 		break;
 	case MTK_PIN_CONFIG_DRV_ADV:
-		if (hw->soc->adv_drive_get)
-			err = hw->soc->adv_drive_get(hw, desc, &ret);
-		else
-			err = -ENOTSUPP;
+		if (!hw->soc->adv_drive_get)
+			break;
+		err = hw->soc->adv_drive_get(hw, desc, &ret);
 		break;
-	default:
-		err = -ENOTSUPP;
 	}
 
-out:
 	if (!err)
 		*config = pinconf_to_config_packed(param, ret);
 
@@ -187,33 +177,29 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 {
 	struct mtk_pinctrl *hw = pinctrl_dev_get_drvdata(pctldev);
 	const struct mtk_pin_desc *desc;
-	int err = 0;
+	int err = -ENOTSUPP;
 	u32 reg;
 
-	if (pin >= hw->soc->npins) {
-		err = -EINVAL;
-		goto err;
-	}
+	if (pin >= hw->soc->npins)
+		return -EINVAL;
+
 	desc = (const struct mtk_pin_desc *)&hw->soc->pins[pin];
 
 	switch ((u32)param) {
 	case PIN_CONFIG_BIAS_DISABLE:
-		if (hw->soc->bias_set_combo)
-			err = hw->soc->bias_set_combo(hw, desc, 0, MTK_DISABLE);
-		else
-			err = -ENOTSUPP;
+		if (!hw->soc->bias_set_combo)
+			break;
+		err = hw->soc->bias_set_combo(hw, desc, 0, MTK_DISABLE);
 		break;
 	case PIN_CONFIG_BIAS_PULL_UP:
-		if (hw->soc->bias_set_combo)
-			err = hw->soc->bias_set_combo(hw, desc, 1, arg);
-		else
-			err = -ENOTSUPP;
+		if (!hw->soc->bias_set_combo)
+			break;
+		err = hw->soc->bias_set_combo(hw, desc, 1, arg);
 		break;
 	case PIN_CONFIG_BIAS_PULL_DOWN:
-		if (hw->soc->bias_set_combo)
-			err = hw->soc->bias_set_combo(hw, desc, 0, arg);
-		else
-			err = -ENOTSUPP;
+		if (!hw->soc->bias_set_combo)
+			break;
+		err = hw->soc->bias_set_combo(hw, desc, 0, arg);
 		break;
 	case PIN_CONFIG_OUTPUT_ENABLE:
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_SMT,
@@ -222,7 +208,7 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 		 *  does not have SMT control
 		 */
 		if (err != -ENOTSUPP)
-			goto err;
+			break;
 
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR,
 				       MTK_OUTPUT);
@@ -231,7 +217,7 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 		/* regard all non-zero value as enable */
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_IES, !!arg);
 		if (err)
-			goto err;
+			break;
 
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR,
 				       MTK_INPUT);
@@ -244,7 +230,7 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR,
 				       MTK_OUTPUT);
 		if (err)
-			goto err;
+			break;
 
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DO,
 				       arg);
@@ -256,15 +242,14 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 		 */
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR, !arg);
 		if (err)
-			goto err;
+			break;
 
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_SMT, !!arg);
 		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
-		if (hw->soc->drive_set)
-			err = hw->soc->drive_set(hw, desc, arg);
-		else
-			err = -ENOTSUPP;
+		if (!hw->soc->drive_set)
+			break;
+		err = hw->soc->drive_set(hw, desc, arg);
 		break;
 	case MTK_PIN_CONFIG_TDSEL:
 	case MTK_PIN_CONFIG_RDSEL:
@@ -274,26 +259,19 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 		break;
 	case MTK_PIN_CONFIG_PU_ADV:
 	case MTK_PIN_CONFIG_PD_ADV:
-		if (hw->soc->adv_pull_set) {
-			bool pullup;
-
-			pullup = param == MTK_PIN_CONFIG_PU_ADV;
-			err = hw->soc->adv_pull_set(hw, desc, pullup,
-						    arg);
-		} else
-			err = -ENOTSUPP;
+		if (!hw->soc->adv_pull_set)
+			break;
+		err = hw->soc->adv_pull_set(hw, desc,
+					    (param == MTK_PIN_CONFIG_PU_ADV),
+					    arg);
 		break;
 	case MTK_PIN_CONFIG_DRV_ADV:
-		if (hw->soc->adv_drive_set)
-			err = hw->soc->adv_drive_set(hw, desc, arg);
-		else
-			err = -ENOTSUPP;
+		if (!hw->soc->adv_drive_set)
+			break;
+		err = hw->soc->adv_drive_set(hw, desc, arg);
 		break;
-	default:
-		err = -ENOTSUPP;
 	}
 
-err:
 	return err;
 }
 
-- 
2.43.0



