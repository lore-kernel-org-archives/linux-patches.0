Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468DA42A83;
	Wed,  7 May 2025 18:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643867; cv=none; b=cZS8h+ai0YzU3//qW8JZwFaA4tQ/moMFkwxr9ZWTYqLae+5Vqznus/uByY6/G8o7a68BJXKL+2Cj0frAMNESMK2d2GE3JPK9a/dG5EBy3O3ORBf1NZEcFFjnHSK/k/rfdXvQNd9OSX7UX7CWV1pGcZnbbufwfYJbSpvWwM7CvCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643867; c=relaxed/simple;
	bh=YzYk2Dsljt+vok9aBWjDMLcpmJCrRz7morDjtbmNFls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVrPt5vBKJ7JymE8uJSaLBZCLe+SLtSfWNpPYpEgxdIqAGx5/HOV0rslsgdlsQfo2+Ga0QFvHlUxfws4UQMLeBVINDYeyTR0tIaIDh/+8y+sQAm43XKUuDTAcLc7zhdm1JHyaHRYG8tU3wH/RUIbyWUVbUoNnYv9zW2sl6Wbd88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlLDSDvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlLDSDvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF24C4CEE9;
	Wed,  7 May 2025 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643867;
	bh=YzYk2Dsljt+vok9aBWjDMLcpmJCrRz7morDjtbmNFls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlLDSDvXGH6/PEoazV0dOvPqFxqUpBnKrf3ur/AAD1R56KHOoaGBM9T3ZakRodMoE
	 uLpgEZEGIBIb/2hxErgcePzMJSfJt1NYsqNHAMTjBaIFIUWDcGai04kg4mCMtW2/2y
	 M30DGOt87A7OC4ypj/NYbfJaRmMIDlxm+98o4gqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.14 016/183] pinctrl: airoha: fix wrong PHY LED mapping and PHY2 LED defines
Date: Wed,  7 May 2025 20:37:41 +0200
Message-ID: <20250507183825.351810695@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit 457d9772e8a5cdae64f66b5f7d5b0247365191ec upstream.

The current PHY2 LED define are wrong and actually set BITs outside the
related mask. Fix it and set the correct value. While at it, also use
FIELD_PREP_CONST macro to make it simple to understand what values are
actually applied for the mask.

Also fix wrong PHY LED mapping. The SoC Switch supports up to 4 port but
the register define mapping for 5 PHY port, starting from 0. The mapping
was wrongly defined starting from PHY1. Reorder the function group to
start from PHY0. PHY4 is actually never supported as we don't have a
GPIO pin to assign.

Cc: stable@vger.kernel.org
Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Reviewed-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/20250401135026.18018-1-ansuelsmth@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c |  159 +++++++++++++-----------------
 1 file changed, 70 insertions(+), 89 deletions(-)

--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -6,6 +6,7 @@
  */
 
 #include <dt-bindings/pinctrl/mt65xx.h>
+#include <linux/bitfield.h>
 #include <linux/bits.h>
 #include <linux/cleanup.h>
 #include <linux/gpio/driver.h>
@@ -112,39 +113,19 @@
 #define REG_LAN_LED1_MAPPING			0x0280
 
 #define LAN4_LED_MAPPING_MASK			GENMASK(18, 16)
-#define LAN4_PHY4_LED_MAP			BIT(18)
-#define LAN4_PHY2_LED_MAP			BIT(17)
-#define LAN4_PHY1_LED_MAP			BIT(16)
-#define LAN4_PHY0_LED_MAP			0
-#define LAN4_PHY3_LED_MAP			GENMASK(17, 16)
+#define LAN4_PHY_LED_MAP(_n)			FIELD_PREP_CONST(LAN4_LED_MAPPING_MASK, (_n))
 
 #define LAN3_LED_MAPPING_MASK			GENMASK(14, 12)
-#define LAN3_PHY4_LED_MAP			BIT(14)
-#define LAN3_PHY2_LED_MAP			BIT(13)
-#define LAN3_PHY1_LED_MAP			BIT(12)
-#define LAN3_PHY0_LED_MAP			0
-#define LAN3_PHY3_LED_MAP			GENMASK(13, 12)
+#define LAN3_PHY_LED_MAP(_n)			FIELD_PREP_CONST(LAN3_LED_MAPPING_MASK, (_n))
 
 #define LAN2_LED_MAPPING_MASK			GENMASK(10, 8)
-#define LAN2_PHY4_LED_MAP			BIT(12)
-#define LAN2_PHY2_LED_MAP			BIT(11)
-#define LAN2_PHY1_LED_MAP			BIT(10)
-#define LAN2_PHY0_LED_MAP			0
-#define LAN2_PHY3_LED_MAP			GENMASK(11, 10)
+#define LAN2_PHY_LED_MAP(_n)			FIELD_PREP_CONST(LAN2_LED_MAPPING_MASK, (_n))
 
 #define LAN1_LED_MAPPING_MASK			GENMASK(6, 4)
-#define LAN1_PHY4_LED_MAP			BIT(6)
-#define LAN1_PHY2_LED_MAP			BIT(5)
-#define LAN1_PHY1_LED_MAP			BIT(4)
-#define LAN1_PHY0_LED_MAP			0
-#define LAN1_PHY3_LED_MAP			GENMASK(5, 4)
+#define LAN1_PHY_LED_MAP(_n)			FIELD_PREP_CONST(LAN1_LED_MAPPING_MASK, (_n))
 
 #define LAN0_LED_MAPPING_MASK			GENMASK(2, 0)
-#define LAN0_PHY4_LED_MAP			BIT(3)
-#define LAN0_PHY2_LED_MAP			BIT(2)
-#define LAN0_PHY1_LED_MAP			BIT(1)
-#define LAN0_PHY0_LED_MAP			0
-#define LAN0_PHY3_LED_MAP			GENMASK(2, 1)
+#define LAN0_PHY_LED_MAP(_n)			FIELD_PREP_CONST(LAN0_LED_MAPPING_MASK, (_n))
 
 /* CONF */
 #define REG_I2C_SDA_E2				0x001c
@@ -1476,8 +1457,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY1_LED_MAP
+			LAN0_LED_MAPPING_MASK,
+			LAN0_PHY_LED_MAP(0)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1491,8 +1472,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY1_LED_MAP
+			LAN1_LED_MAPPING_MASK,
+			LAN1_PHY_LED_MAP(0)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1506,8 +1487,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY1_LED_MAP
+			LAN2_LED_MAPPING_MASK,
+			LAN2_PHY_LED_MAP(0)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1521,8 +1502,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN4_LED_MAPPING_MASK,
-			LAN4_PHY1_LED_MAP
+			LAN3_LED_MAPPING_MASK,
+			LAN3_PHY_LED_MAP(0)
 		},
 		.regmap_size = 2,
 	},
@@ -1540,8 +1521,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY2_LED_MAP
+			LAN0_LED_MAPPING_MASK,
+			LAN0_PHY_LED_MAP(1)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1555,8 +1536,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY2_LED_MAP
+			LAN1_LED_MAPPING_MASK,
+			LAN1_PHY_LED_MAP(1)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1570,8 +1551,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY2_LED_MAP
+			LAN2_LED_MAPPING_MASK,
+			LAN2_PHY_LED_MAP(1)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1585,8 +1566,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN4_LED_MAPPING_MASK,
-			LAN4_PHY2_LED_MAP
+			LAN3_LED_MAPPING_MASK,
+			LAN3_PHY_LED_MAP(1)
 		},
 		.regmap_size = 2,
 	},
@@ -1604,8 +1585,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY3_LED_MAP
+			LAN0_LED_MAPPING_MASK,
+			LAN0_PHY_LED_MAP(2)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1619,8 +1600,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY3_LED_MAP
+			LAN1_LED_MAPPING_MASK,
+			LAN1_PHY_LED_MAP(2)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1634,8 +1615,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY3_LED_MAP
+			LAN2_LED_MAPPING_MASK,
+			LAN2_PHY_LED_MAP(2)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1649,8 +1630,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN4_LED_MAPPING_MASK,
-			LAN4_PHY3_LED_MAP
+			LAN3_LED_MAPPING_MASK,
+			LAN3_PHY_LED_MAP(2)
 		},
 		.regmap_size = 2,
 	},
@@ -1668,8 +1649,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY4_LED_MAP
+			LAN0_LED_MAPPING_MASK,
+			LAN0_PHY_LED_MAP(3)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1683,8 +1664,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY4_LED_MAP
+			LAN1_LED_MAPPING_MASK,
+			LAN1_PHY_LED_MAP(3)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1698,8 +1679,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY4_LED_MAP
+			LAN2_LED_MAPPING_MASK,
+			LAN2_PHY_LED_MAP(3)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1713,8 +1694,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED0_MAPPING,
-			LAN4_LED_MAPPING_MASK,
-			LAN4_PHY4_LED_MAP
+			LAN3_LED_MAPPING_MASK,
+			LAN3_PHY_LED_MAP(3)
 		},
 		.regmap_size = 2,
 	},
@@ -1732,8 +1713,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY1_LED_MAP
+			LAN0_LED_MAPPING_MASK,
+			LAN0_PHY_LED_MAP(0)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1747,8 +1728,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY1_LED_MAP
+			LAN1_LED_MAPPING_MASK,
+			LAN1_PHY_LED_MAP(0)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1762,8 +1743,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY1_LED_MAP
+			LAN2_LED_MAPPING_MASK,
+			LAN2_PHY_LED_MAP(0)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1777,8 +1758,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN4_LED_MAPPING_MASK,
-			LAN4_PHY1_LED_MAP
+			LAN3_LED_MAPPING_MASK,
+			LAN3_PHY_LED_MAP(0)
 		},
 		.regmap_size = 2,
 	},
@@ -1796,8 +1777,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY2_LED_MAP
+			LAN0_LED_MAPPING_MASK,
+			LAN0_PHY_LED_MAP(1)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1811,8 +1792,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY2_LED_MAP
+			LAN1_LED_MAPPING_MASK,
+			LAN1_PHY_LED_MAP(1)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1826,8 +1807,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY2_LED_MAP
+			LAN2_LED_MAPPING_MASK,
+			LAN2_PHY_LED_MAP(1)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1841,8 +1822,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN4_LED_MAPPING_MASK,
-			LAN4_PHY2_LED_MAP
+			LAN3_LED_MAPPING_MASK,
+			LAN3_PHY_LED_MAP(1)
 		},
 		.regmap_size = 2,
 	},
@@ -1860,8 +1841,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY3_LED_MAP
+			LAN0_LED_MAPPING_MASK,
+			LAN0_PHY_LED_MAP(2)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1875,8 +1856,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY3_LED_MAP
+			LAN1_LED_MAPPING_MASK,
+			LAN1_PHY_LED_MAP(2)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1890,8 +1871,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY3_LED_MAP
+			LAN2_LED_MAPPING_MASK,
+			LAN2_PHY_LED_MAP(2)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1905,8 +1886,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN4_LED_MAPPING_MASK,
-			LAN4_PHY3_LED_MAP
+			LAN3_LED_MAPPING_MASK,
+			LAN3_PHY_LED_MAP(2)
 		},
 		.regmap_size = 2,
 	},
@@ -1924,8 +1905,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY4_LED_MAP
+			LAN0_LED_MAPPING_MASK,
+			LAN0_PHY_LED_MAP(3)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1939,8 +1920,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY4_LED_MAP
+			LAN1_LED_MAPPING_MASK,
+			LAN1_PHY_LED_MAP(3)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1954,8 +1935,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY4_LED_MAP
+			LAN2_LED_MAPPING_MASK,
+			LAN2_PHY_LED_MAP(3)
 		},
 		.regmap_size = 2,
 	}, {
@@ -1969,8 +1950,8 @@ static const struct airoha_pinctrl_func_
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
 			REG_LAN_LED1_MAPPING,
-			LAN4_LED_MAPPING_MASK,
-			LAN4_PHY4_LED_MAP
+			LAN3_LED_MAPPING_MASK,
+			LAN3_PHY_LED_MAP(3)
 		},
 		.regmap_size = 2,
 	},


