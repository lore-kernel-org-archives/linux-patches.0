Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B6F1CAA4;
	Tue, 14 May 2024 11:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686113; cv=none; b=GoxTF7RKX7mqVDTlW3U6D2Ykzgvl1KjIsfEpA7bqIeJdmbSRccQ7w1rrexlVP0TrlkNFTf+9d8YmXtAQ9GtA+U6hqLkpG7vX27dSWpU75NuH3LN+tOBXsXHn+kyQKp6F8Qkyv1Q4DWYPPqQH90/YsxhG8YiL7cHuNvCROX/tBsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686113; c=relaxed/simple;
	bh=+A8VqBsldHDFjA3X1BUKGJ2ZNHund59hO/WzwrjeqB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiqooED44XT5lUbIMKOGQxKzZOhHCGd2hUfMJo+IRf1wbu7Ba3pl6fy7aO6n2aYLyJzYn4gwlpsMUeTrJzTPRz8lJPtCH9EQGnDejpTndTKaiKw4pcUIDjQn750ZawmXFA9YREMp8A6rLNuCr3eQdZhtkMVqHne++zSPxMexYk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCxXLMht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCxXLMht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4262AC2BD10;
	Tue, 14 May 2024 11:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686113;
	bh=+A8VqBsldHDFjA3X1BUKGJ2ZNHund59hO/WzwrjeqB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCxXLMhtPgmcffsotE0Gdl8abrOqbfUQzNbG9jjRqgJo9SuWQSmpC2LG1DBUaWS7v
	 0yjtY9yfVGnt407XKX0fsp27kKUjH+vwJQUh/Vtftp/xIcjX0IIj1MMEYuts+iKUHw
	 ysnklWO1D8LSTpUABMYJ8ct4Hr4ikfs34ijNZ02k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/236] pinctrl: mediatek: paris: Rework support for PIN_CONFIG_{INPUT,OUTPUT}_ENABLE
Date: Tue, 14 May 2024 12:16:28 +0200
Message-ID: <20240514101021.331613103@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c5d3b64c568a344e998830e0e94a7c04e372f89b ]

There is a misinterpretation of some of the PIN_CONFIG_* options in this
driver library. PIN_CONFIG_OUTPUT_ENABLE should refer to a buffer or
switch in the output direction of the electrical path. The MediaTek
hardware does not have such a thing. The driver incorrectly maps this
option to the GPIO function's direction.

Likewise, PIN_CONFIG_INPUT_ENABLE should refer to a buffer or switch in
the input direction. The hardware does have such a mechanism, and is
mapped to the IES bit. The driver however sets the direction in addition
to the IES bit, which is incorrect. On readback, the IES bit isn't even
considered.

Ironically, the driver does not support readback for PIN_CONFIG_OUTPUT,
while its readback of PIN_CONFIG_{INPUT,OUTPUT}_ENABLE is what it should
be doing for PIN_CONFIG_OUTPUT.

Rework support for these three options, so that PIN_CONFIG_OUTPUT_ENABLE
is completely removed, PIN_CONFIG_INPUT_ENABLE is only linked to the IES
bit, and PIN_CONFIG_OUTPUT is linked to the GPIO function's direction
and output level.

Fixes: 805250982bb5 ("pinctrl: mediatek: add pinctrl-paris that implements the vendor dt-bindings")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Message-ID: <20240327091336.3434141-3-wenst@chromium.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 38 +++++++-----------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 3f2297ee2b765..ee72c6894a5d7 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -160,20 +160,21 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_SR, &ret);
 		break;
 	case PIN_CONFIG_INPUT_ENABLE:
-	case PIN_CONFIG_OUTPUT_ENABLE:
+		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_IES, &ret);
+		if (!ret)
+			err = -EINVAL;
+		break;
+	case PIN_CONFIG_OUTPUT:
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_DIR, &ret);
 		if (err)
 			break;
-		/*     CONFIG     Current direction return value
-		 * -------------  ----------------- ----------------------
-		 * OUTPUT_ENABLE       output       1 (= HW value)
-		 *                     input        0 (= HW value)
-		 * INPUT_ENABLE        output       0 (= reverse HW value)
-		 *                     input        1 (= reverse HW value)
-		 */
-		if (param == PIN_CONFIG_INPUT_ENABLE)
-			ret = !ret;
 
+		if (!ret) {
+			err = -EINVAL;
+			break;
+		}
+
+		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_DO, &ret);
 		break;
 	case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_DIR, &ret);
@@ -278,26 +279,9 @@ static int mtk_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			break;
 		err = hw->soc->bias_set_combo(hw, desc, 0, arg);
 		break;
-	case PIN_CONFIG_OUTPUT_ENABLE:
-		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_SMT,
-				       MTK_DISABLE);
-		/* Keep set direction to consider the case that a GPIO pin
-		 *  does not have SMT control
-		 */
-		if (err != -ENOTSUPP)
-			break;
-
-		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR,
-				       MTK_OUTPUT);
-		break;
 	case PIN_CONFIG_INPUT_ENABLE:
 		/* regard all non-zero value as enable */
 		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_IES, !!arg);
-		if (err)
-			break;
-
-		err = mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DIR,
-				       MTK_INPUT);
 		break;
 	case PIN_CONFIG_SLEW_RATE:
 		/* regard all non-zero value as enable */
-- 
2.43.0



