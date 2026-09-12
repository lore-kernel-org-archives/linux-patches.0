Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8ED384232;
	Sat, 12 Sep 2026 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210362; cv=none; b=P47aROvQzqSeQeWyMfSTpMeRibjWuGMRF9wFj09Jd4p1U3cluRzRa1Nwq6GN2TDu3NRkLefBt+qB++31sTVgxTkc400lzFjMaxLtEXTxrCgRe7AocuDZxFaXJ7IR3fgXo2P3nrp203sZJvV68OD0A7ehkO5/tbc6ATE3RN6G2y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210362; c=relaxed/simple;
	bh=Vv1zf9qzWgaA9Cy4cDxLoQcUNhQTG3MjB9rHukf4NPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTn69I5paMXev5Xsv7YmaKDi+U2lxRW0cX9JT7KW8pHghzUhozv8iSnKLa9VBLGRrdtM6c46vBQUiSgWOanJTuViJLIrdUvbvCU+5kExPh91AzX/xYijWwiqTWHayNnAOko0s/EUocVs1B2FvSZ8uLY86lXs8fIJOG+zrLPqkes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7KXeMJe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7KXeMJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0803B1F000FF;
	Sat, 12 Sep 2026 10:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210360;
	bh=2pU1YQXb0kKQ/+DT3a6HyuIRlbl7p0987AOz9xu6Ah0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7KXeMJeX5KG7eOJnkflp361KsB5Jk6pqT5PmS+tZRJwPlbIGIHSm5FyW7JHnhXXU
	 StL21oz2ewkK+u8jtSEk+dNjwSRwlwaN8bJs01i/d3+SzXIi9pu027hUSii6qmX2jy
	 tQ91p86Gf6UXgzsQuAdijKC7tDpwE16/3nxnxw/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1008/1518] pinctrl: airoha: convert PHY LED GPIO to macro
Date: Sat, 12 Sep 2026 08:52:57 +0200
Message-ID: <20260912065646.257122660@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 579839c9548cf2a85e873ad787bc2fa6610bf8ab ]

PHY LED GPIO pinctrl struct definition is very similar across the
different 4 PHY and 2 LED and it can be generelized to a macro.

To reduce code size, convert them to a common macro.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: a8454680a6ce ("pinctrl: airoha: fix mdio bitfield names")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 588 ++++------------------
 1 file changed, 100 insertions(+), 488 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 9f8e05e3671d6..2eaac83a1a413 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -1475,516 +1475,128 @@ static const struct airoha_pinctrl_func_group pwm_func_group[] = {
 	},
 };
 
+#define AIROHA_PINCTRL_PHY_LED0(gpio, mux_val, map_mask, map_val)	\
+	{								\
+		.name = (gpio),						\
+		.regmap[0] = {						\
+			AIROHA_FUNC_MUX,				\
+			REG_GPIO_2ND_I2C_MODE,				\
+			(mux_val),					\
+			(mux_val),					\
+		},							\
+		.regmap[1] = {						\
+			AIROHA_FUNC_MUX,				\
+			REG_LAN_LED0_MAPPING,				\
+			(map_mask),					\
+			(map_val),					\
+		},							\
+		.regmap_size = 2,					\
+	}
+
+#define AIROHA_PINCTRL_PHY_LED1(gpio, mux_val, map_mask, map_val)	\
+	{								\
+		.name = (gpio),						\
+		.regmap[0] = {						\
+			AIROHA_FUNC_MUX,				\
+			REG_GPIO_2ND_I2C_MODE,				\
+			(mux_val),					\
+			(mux_val),					\
+		},							\
+		.regmap[1] = {						\
+			AIROHA_FUNC_MUX,				\
+			REG_LAN_LED1_MAPPING,				\
+			(map_mask),					\
+			(map_val),					\
+		},							\
+		.regmap_size = 2,					\
+	}
+
 static const struct airoha_pinctrl_func_group phy1_led0_func_group[] = {
-	{
-		.name = "gpio33",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN0_LED0_MODE_MASK,
-			GPIO_LAN0_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN0_LED_MAPPING_MASK,
-			LAN0_PHY_LED_MAP(0)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio34",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN1_LED0_MODE_MASK,
-			GPIO_LAN1_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY_LED_MAP(0)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio35",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN2_LED0_MODE_MASK,
-			GPIO_LAN2_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY_LED_MAP(0)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio42",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED0_MODE_MASK,
-			GPIO_LAN3_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY_LED_MAP(0)
-		},
-		.regmap_size = 2,
-	},
+	AIROHA_PINCTRL_PHY_LED0("gpio33", GPIO_LAN0_LED0_MODE_MASK,
+				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(0)),
+	AIROHA_PINCTRL_PHY_LED0("gpio34", GPIO_LAN1_LED0_MODE_MASK,
+				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(0)),
+	AIROHA_PINCTRL_PHY_LED0("gpio35", GPIO_LAN2_LED0_MODE_MASK,
+				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(0)),
+	AIROHA_PINCTRL_PHY_LED0("gpio42", GPIO_LAN3_LED0_MODE_MASK,
+				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(0)),
 };
 
 static const struct airoha_pinctrl_func_group phy2_led0_func_group[] = {
-	{
-		.name = "gpio33",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN0_LED0_MODE_MASK,
-			GPIO_LAN0_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN0_LED_MAPPING_MASK,
-			LAN0_PHY_LED_MAP(1)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio34",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN1_LED0_MODE_MASK,
-			GPIO_LAN1_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY_LED_MAP(1)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio35",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN2_LED0_MODE_MASK,
-			GPIO_LAN2_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY_LED_MAP(1)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio42",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED0_MODE_MASK,
-			GPIO_LAN3_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY_LED_MAP(1)
-		},
-		.regmap_size = 2,
-	},
+	AIROHA_PINCTRL_PHY_LED0("gpio33", GPIO_LAN0_LED0_MODE_MASK,
+				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(1)),
+	AIROHA_PINCTRL_PHY_LED0("gpio34", GPIO_LAN1_LED0_MODE_MASK,
+				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(1)),
+	AIROHA_PINCTRL_PHY_LED0("gpio35", GPIO_LAN2_LED0_MODE_MASK,
+				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(1)),
+	AIROHA_PINCTRL_PHY_LED0("gpio42", GPIO_LAN3_LED0_MODE_MASK,
+				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(1)),
 };
 
 static const struct airoha_pinctrl_func_group phy3_led0_func_group[] = {
-	{
-		.name = "gpio33",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN0_LED0_MODE_MASK,
-			GPIO_LAN0_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN0_LED_MAPPING_MASK,
-			LAN0_PHY_LED_MAP(2)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio34",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN1_LED0_MODE_MASK,
-			GPIO_LAN1_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY_LED_MAP(2)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio35",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN2_LED0_MODE_MASK,
-			GPIO_LAN2_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY_LED_MAP(2)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio42",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED0_MODE_MASK,
-			GPIO_LAN3_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY_LED_MAP(2)
-		},
-		.regmap_size = 2,
-	},
+	AIROHA_PINCTRL_PHY_LED0("gpio33", GPIO_LAN0_LED0_MODE_MASK,
+				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(2)),
+	AIROHA_PINCTRL_PHY_LED0("gpio34", GPIO_LAN1_LED0_MODE_MASK,
+				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(2)),
+	AIROHA_PINCTRL_PHY_LED0("gpio35", GPIO_LAN2_LED0_MODE_MASK,
+				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(2)),
+	AIROHA_PINCTRL_PHY_LED0("gpio42", GPIO_LAN3_LED0_MODE_MASK,
+				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(2)),
 };
 
 static const struct airoha_pinctrl_func_group phy4_led0_func_group[] = {
-	{
-		.name = "gpio33",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN0_LED0_MODE_MASK,
-			GPIO_LAN0_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN0_LED_MAPPING_MASK,
-			LAN0_PHY_LED_MAP(3)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio34",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN1_LED0_MODE_MASK,
-			GPIO_LAN1_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY_LED_MAP(3)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio35",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN2_LED0_MODE_MASK,
-			GPIO_LAN2_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY_LED_MAP(3)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio42",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED0_MODE_MASK,
-			GPIO_LAN3_LED0_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED0_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY_LED_MAP(3)
-		},
-		.regmap_size = 2,
-	},
+	AIROHA_PINCTRL_PHY_LED0("gpio33", GPIO_LAN0_LED0_MODE_MASK,
+				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(3)),
+	AIROHA_PINCTRL_PHY_LED0("gpio34", GPIO_LAN1_LED0_MODE_MASK,
+				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(3)),
+	AIROHA_PINCTRL_PHY_LED0("gpio35", GPIO_LAN2_LED0_MODE_MASK,
+				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(3)),
+	AIROHA_PINCTRL_PHY_LED0("gpio42", GPIO_LAN3_LED0_MODE_MASK,
+				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(3)),
 };
 
 static const struct airoha_pinctrl_func_group phy1_led1_func_group[] = {
-	{
-		.name = "gpio43",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN0_LED1_MODE_MASK,
-			GPIO_LAN0_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN0_LED_MAPPING_MASK,
-			LAN0_PHY_LED_MAP(0)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio44",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN1_LED1_MODE_MASK,
-			GPIO_LAN1_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY_LED_MAP(0)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio45",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN2_LED1_MODE_MASK,
-			GPIO_LAN2_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY_LED_MAP(0)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio46",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED1_MODE_MASK,
-			GPIO_LAN3_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY_LED_MAP(0)
-		},
-		.regmap_size = 2,
-	},
+	AIROHA_PINCTRL_PHY_LED1("gpio43", GPIO_LAN0_LED1_MODE_MASK,
+				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(0)),
+	AIROHA_PINCTRL_PHY_LED1("gpio44", GPIO_LAN1_LED1_MODE_MASK,
+				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(0)),
+	AIROHA_PINCTRL_PHY_LED1("gpio45", GPIO_LAN2_LED1_MODE_MASK,
+				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(0)),
+	AIROHA_PINCTRL_PHY_LED1("gpio46", GPIO_LAN3_LED1_MODE_MASK,
+				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(0)),
 };
 
 static const struct airoha_pinctrl_func_group phy2_led1_func_group[] = {
-	{
-		.name = "gpio43",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN0_LED1_MODE_MASK,
-			GPIO_LAN0_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN0_LED_MAPPING_MASK,
-			LAN0_PHY_LED_MAP(1)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio44",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN1_LED1_MODE_MASK,
-			GPIO_LAN1_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY_LED_MAP(1)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio45",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN2_LED1_MODE_MASK,
-			GPIO_LAN2_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY_LED_MAP(1)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio46",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED1_MODE_MASK,
-			GPIO_LAN3_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY_LED_MAP(1)
-		},
-		.regmap_size = 2,
-	},
+	AIROHA_PINCTRL_PHY_LED1("gpio43", GPIO_LAN0_LED1_MODE_MASK,
+				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(1)),
+	AIROHA_PINCTRL_PHY_LED1("gpio44", GPIO_LAN1_LED1_MODE_MASK,
+				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(1)),
+	AIROHA_PINCTRL_PHY_LED1("gpio45", GPIO_LAN2_LED1_MODE_MASK,
+				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(1)),
+	AIROHA_PINCTRL_PHY_LED1("gpio46", GPIO_LAN3_LED1_MODE_MASK,
+				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(1)),
 };
 
 static const struct airoha_pinctrl_func_group phy3_led1_func_group[] = {
-	{
-		.name = "gpio43",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN0_LED1_MODE_MASK,
-			GPIO_LAN0_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN0_LED_MAPPING_MASK,
-			LAN0_PHY_LED_MAP(2)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio44",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN1_LED1_MODE_MASK,
-			GPIO_LAN1_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY_LED_MAP(2)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio45",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN2_LED1_MODE_MASK,
-			GPIO_LAN2_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY_LED_MAP(2)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio46",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED1_MODE_MASK,
-			GPIO_LAN3_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY_LED_MAP(2)
-		},
-		.regmap_size = 2,
-	},
+	AIROHA_PINCTRL_PHY_LED1("gpio43", GPIO_LAN0_LED1_MODE_MASK,
+				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(2)),
+	AIROHA_PINCTRL_PHY_LED1("gpio44", GPIO_LAN1_LED1_MODE_MASK,
+				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(2)),
+	AIROHA_PINCTRL_PHY_LED1("gpio45", GPIO_LAN2_LED1_MODE_MASK,
+				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(2)),
+	AIROHA_PINCTRL_PHY_LED1("gpio46", GPIO_LAN3_LED1_MODE_MASK,
+				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(2)),
 };
 
 static const struct airoha_pinctrl_func_group phy4_led1_func_group[] = {
-	{
-		.name = "gpio43",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN0_LED1_MODE_MASK,
-			GPIO_LAN0_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN0_LED_MAPPING_MASK,
-			LAN0_PHY_LED_MAP(3)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio44",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN1_LED1_MODE_MASK,
-			GPIO_LAN1_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN1_LED_MAPPING_MASK,
-			LAN1_PHY_LED_MAP(3)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio45",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN2_LED1_MODE_MASK,
-			GPIO_LAN2_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN2_LED_MAPPING_MASK,
-			LAN2_PHY_LED_MAP(3)
-		},
-		.regmap_size = 2,
-	}, {
-		.name = "gpio46",
-		.regmap[0] = {
-			AIROHA_FUNC_MUX,
-			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED1_MODE_MASK,
-			GPIO_LAN3_LED1_MODE_MASK
-		},
-		.regmap[1] = {
-			AIROHA_FUNC_MUX,
-			REG_LAN_LED1_MAPPING,
-			LAN3_LED_MAPPING_MASK,
-			LAN3_PHY_LED_MAP(3)
-		},
-		.regmap_size = 2,
-	},
+	AIROHA_PINCTRL_PHY_LED1("gpio43", GPIO_LAN0_LED1_MODE_MASK,
+				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(2)),
+	AIROHA_PINCTRL_PHY_LED1("gpio44", GPIO_LAN1_LED1_MODE_MASK,
+				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(2)),
+	AIROHA_PINCTRL_PHY_LED1("gpio45", GPIO_LAN2_LED1_MODE_MASK,
+				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(2)),
+	AIROHA_PINCTRL_PHY_LED1("gpio46", GPIO_LAN3_LED1_MODE_MASK,
+				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(2)),
 };
 
 static const struct airoha_pinctrl_func en7581_pinctrl_funcs[] = {
-- 
2.53.0



