Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6132D0C94;
	Sat, 12 Sep 2026 10:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210557; cv=none; b=fQLfwxoXwAIiG8MwAHZT+ik4kyo+InS+j7TWNSFs6wZJcMfu3MIsozm9wm5FNPIkWAXFjTV15RSC+LcAcNU1x1he2m026F6CdxWvQxTD7a2xX69UWl6OTBHF9HV/4Aw2ErEmPYHJdXn9AO1DU8hP2AYGLwdNjonX+cxZpYGwuw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210557; c=relaxed/simple;
	bh=CBV3ZUKu/h0t7cuD6w8rAv6TG7oVFKiRb8NBjRVDHHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUV/tPTF2EOh+9HGtVFoLq1x5Ir0N5g/8ViC2Lc/GHRRp6u53uNFZH9OmuXbmo/ZZaicfus0fkuaT38qnyxDq3rp/tYF0UZLn7B0kpTm33Nk3a17zE1OOc4rudRsofFG7Aln0UMZmPFf8+RD2fOOIybBH4HJD3108CFI2alosgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOwdF/jG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOwdF/jG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9211F000FF;
	Sat, 12 Sep 2026 10:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210555;
	bh=A038tYJ8zxZH5tfdWgtDp4JTivSMSIc/w8OQmxCaI/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOwdF/jGixNfg5wPm4n/BCLyNVji42mfpws7/C7dAhVbLhCn/86dSW9X/1v+lVp3Y
	 AmqrhakhS4uQM+sq4eXRJyunx8sgY0Kg+ZDcSl/ml+MPiBeVBSoNLk9PzxLgU9sufP
	 HVZgwVc/fatz5ecy9/uNVmB8oC00xRmMcFKsd0qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1013/1518] pinctrl: airoha: convert PWM GPIO to macro
Date: Sat, 12 Sep 2026 08:53:02 +0200
Message-ID: <20260912065646.368465846@linuxfoundation.org>
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

[ Upstream commit 1552ad5d649cff9d170e5bc1d13ab1487333b4b7 ]

The PWM GPIO struct definition follow the same pattern for every GPIO
pin hence it can be converted to a macro.

Create 2 macro one for normal mux and one for ext mux and convert all
the entry to these new macro to reduce code size.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 739bc85aed14 ("pinctrl: airoha: an7581: fix mux/conf of pcie_reset pins")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 465 ++++------------------
 1 file changed, 68 insertions(+), 397 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 3729da8f7df5e..8939b4a617d3d 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -1435,404 +1435,75 @@ static const struct airoha_pinctrl_func_group an7583_pcie_reset_func_group[] = {
 };
 
 /* PWM */
+#define AIROHA_PINCTRL_PWM(gpio, mux_val)		\
+	{						\
+		.name = (gpio),				\
+		.regmap[0] = {				\
+			AIROHA_FUNC_PWM_MUX,		\
+			REG_GPIO_FLASH_MODE_CFG,	\
+			(mux_val),			\
+			(mux_val)			\
+		},					\
+		.regmap_size = 1,			\
+	}						\
+
+#define AIROHA_PINCTRL_PWM_EXT(gpio, mux_val)		\
+	{						\
+		.name = (gpio),				\
+		.regmap[0] = {				\
+			AIROHA_FUNC_PWM_EXT_MUX,	\
+			REG_GPIO_FLASH_MODE_CFG_EXT,	\
+			(mux_val),			\
+			(mux_val)			\
+		},					\
+		.regmap_size = 1,			\
+	}						\
+
 static const struct airoha_pinctrl_func_group pwm_func_group[] = {
-	{
-		.name = "gpio0",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO0_FLASH_MODE_CFG,
-			GPIO0_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio1",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO1_FLASH_MODE_CFG,
-			GPIO1_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio2",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO2_FLASH_MODE_CFG,
-			GPIO2_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio3",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO3_FLASH_MODE_CFG,
-			GPIO3_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio4",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO4_FLASH_MODE_CFG,
-			GPIO4_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio5",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO5_FLASH_MODE_CFG,
-			GPIO5_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio6",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO6_FLASH_MODE_CFG,
-			GPIO6_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio7",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO7_FLASH_MODE_CFG,
-			GPIO7_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio8",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO8_FLASH_MODE_CFG,
-			GPIO8_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio9",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO9_FLASH_MODE_CFG,
-			GPIO9_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio10",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO10_FLASH_MODE_CFG,
-			GPIO10_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio11",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO11_FLASH_MODE_CFG,
-			GPIO11_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio12",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO12_FLASH_MODE_CFG,
-			GPIO12_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio13",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO13_FLASH_MODE_CFG,
-			GPIO13_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio14",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO14_FLASH_MODE_CFG,
-			GPIO14_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio15",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_MUX,
-			REG_GPIO_FLASH_MODE_CFG,
-			GPIO15_FLASH_MODE_CFG,
-			GPIO15_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio16",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO16_FLASH_MODE_CFG,
-			GPIO16_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio17",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO17_FLASH_MODE_CFG,
-			GPIO17_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio18",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO18_FLASH_MODE_CFG,
-			GPIO18_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio19",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO19_FLASH_MODE_CFG,
-			GPIO19_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio20",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO20_FLASH_MODE_CFG,
-			GPIO20_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio21",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO21_FLASH_MODE_CFG,
-			GPIO21_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio22",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO22_FLASH_MODE_CFG,
-			GPIO22_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio23",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO23_FLASH_MODE_CFG,
-			GPIO23_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio24",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO24_FLASH_MODE_CFG,
-			GPIO24_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio25",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO25_FLASH_MODE_CFG,
-			GPIO25_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio26",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO26_FLASH_MODE_CFG,
-			GPIO26_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio27",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO27_FLASH_MODE_CFG,
-			GPIO27_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio28",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO28_FLASH_MODE_CFG,
-			GPIO28_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio29",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO29_FLASH_MODE_CFG,
-			GPIO29_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio30",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO30_FLASH_MODE_CFG,
-			GPIO30_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio31",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO31_FLASH_MODE_CFG,
-			GPIO31_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio36",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO36_FLASH_MODE_CFG,
-			GPIO36_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio37",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO37_FLASH_MODE_CFG,
-			GPIO37_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio38",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO38_FLASH_MODE_CFG,
-			GPIO38_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio39",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO39_FLASH_MODE_CFG,
-			GPIO39_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio40",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO40_FLASH_MODE_CFG,
-			GPIO40_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio41",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO41_FLASH_MODE_CFG,
-			GPIO41_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio42",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO42_FLASH_MODE_CFG,
-			GPIO42_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio43",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO43_FLASH_MODE_CFG,
-			GPIO43_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio44",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO44_FLASH_MODE_CFG,
-			GPIO44_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio45",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO45_FLASH_MODE_CFG,
-			GPIO45_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio46",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO46_FLASH_MODE_CFG,
-			GPIO46_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	}, {
-		.name = "gpio47",
-		.regmap[0] = {
-			AIROHA_FUNC_PWM_EXT_MUX,
-			REG_GPIO_FLASH_MODE_CFG_EXT,
-			GPIO47_FLASH_MODE_CFG,
-			GPIO47_FLASH_MODE_CFG
-		},
-		.regmap_size = 1,
-	},
+	AIROHA_PINCTRL_PWM("gpio0", GPIO0_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio1", GPIO1_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio2", GPIO2_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio3", GPIO3_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio4", GPIO4_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio5", GPIO5_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio6", GPIO6_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio7", GPIO7_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio8", GPIO8_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio9", GPIO9_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio10", GPIO10_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio11", GPIO11_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio12", GPIO12_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio13", GPIO13_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio14", GPIO14_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM("gpio15", GPIO15_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio16", GPIO16_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio17", GPIO17_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio18", GPIO18_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio19", GPIO19_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio20", GPIO20_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio21", GPIO21_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio22", GPIO22_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio23", GPIO23_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio24", GPIO24_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio25", GPIO25_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio26", GPIO26_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio27", GPIO27_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio28", GPIO28_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio29", GPIO29_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio30", GPIO30_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio31", GPIO31_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio36", GPIO36_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio37", GPIO37_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio38", GPIO38_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio39", GPIO39_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio40", GPIO40_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio41", GPIO41_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio42", GPIO42_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio43", GPIO43_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio44", GPIO44_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio45", GPIO45_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio46", GPIO46_FLASH_MODE_CFG),
+	AIROHA_PINCTRL_PWM_EXT("gpio47", GPIO47_FLASH_MODE_CFG),
 };
 
 #define AIROHA_PINCTRL_PHY_LED0(gpio, mux_val, map_mask, map_val)	\
-- 
2.53.0



