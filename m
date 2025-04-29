Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA27244679;
	Tue, 29 Apr 2025 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945868; cv=none; b=jwzrH7owJ3A71asiE2TNyyQMMh9wcQsm1hUu/QMLWoDhKhEHugasShLrMsigyRuWFMjaRZf+/16ZHbaKXToDpFJ0kebqSfQdcP7fMW0sYKstJL8s8z7fdIyjkirCE3tI89AsXYwahSJcVNI0U3TvIRwYiRmghC/yJ6R2Rmd9gRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945868; c=relaxed/simple;
	bh=+oQGne0vBZX1jT3CC+4UhsI4pPYin5xm81opKbKlZuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Smp8M7FsRQMu/dQ7WjBhi5wg9+a7CSrUbWDEsWjTgjQFKFZIDyeuLE1+8KrnF+4rPMUPpAISRwyL0V3n7ZfBq0LBDTO8ZrqtV90qnaPRokrE9lbbyMnlAhpXgbYQnaRh+sPAzZEZvnAm6MVDHxaxyZYX5vFcabHSkrx2nEcp0PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOgjEnTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOgjEnTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA2CC4CEE3;
	Tue, 29 Apr 2025 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945868;
	bh=+oQGne0vBZX1jT3CC+4UhsI4pPYin5xm81opKbKlZuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOgjEnTDt6K/SMdw+botbbQmVD17RBEqx75jagJbjgaxKkFISBZ4xfUjD6/hFn/bY
	 KHNZ1s/eFD+UqB52qcPCHBq6tSQSIi04kVXZyR0P3SqEg521qyBXGooikBcIjp3fhr
	 9ukJ4efNG7VNFzeQTzO7j5Jt6DauxuLQQ95WtlIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Fedrau <dimitri.fedrau@liebherr.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 076/311] net: phy: dp83822: Add support for changing the transmit amplitude voltage
Date: Tue, 29 Apr 2025 18:38:33 +0200
Message-ID: <20250429161124.158866314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

From: Dimitri Fedrau <dimitri.fedrau@liebherr.com>

[ Upstream commit 4f3735e82d8a2e80ee39731832536b1e34697c71 ]

Add support for changing the transmit amplitude voltage in 100BASE-TX mode.
Modifying it can be necessary to compensate losses on the PCB and
connector, so the voltages measured on the RJ45 pins are conforming.

Signed-off-by: Dimitri Fedrau <dimitri.fedrau@liebherr.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250214-dp83822-tx-swing-v5-3-02ca72620599@liebherr.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 607b310ada5e ("net: dp83822: Fix OF_MDIO config check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83822.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 6599feca1967d..3662f3905d5ad 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -31,6 +31,7 @@
 #define MII_DP83822_RCSR	0x17
 #define MII_DP83822_RESET_CTRL	0x1f
 #define MII_DP83822_MLEDCR	0x25
+#define MII_DP83822_LDCTRL	0x403
 #define MII_DP83822_LEDCFG1	0x460
 #define MII_DP83822_IOCTRL1	0x462
 #define MII_DP83822_IOCTRL2	0x463
@@ -123,6 +124,9 @@
 #define DP83822_IOCTRL1_GPIO1_CTRL		GENMASK(2, 0)
 #define DP83822_IOCTRL1_GPIO1_CTRL_LED_1	BIT(0)
 
+/* LDCTRL bits */
+#define DP83822_100BASE_TX_LINE_DRIVER_SWING	GENMASK(7, 4)
+
 /* IOCTRL2 bits */
 #define DP83822_IOCTRL2_GPIO2_CLK_SRC		GENMASK(6, 4)
 #define DP83822_IOCTRL2_GPIO2_CTRL		GENMASK(2, 0)
@@ -197,6 +201,7 @@ struct dp83822_private {
 	bool set_gpio2_clk_out;
 	u32 gpio2_clk_out;
 	bool led_pin_enable[DP83822_MAX_LED_PINS];
+	int tx_amplitude_100base_tx_index;
 };
 
 static int dp83822_config_wol(struct phy_device *phydev,
@@ -522,6 +527,12 @@ static int dp83822_config_init(struct phy_device *phydev)
 			       FIELD_PREP(DP83822_IOCTRL2_GPIO2_CLK_SRC,
 					  dp83822->gpio2_clk_out));
 
+	if (dp83822->tx_amplitude_100base_tx_index >= 0)
+		phy_modify_mmd(phydev, MDIO_MMD_VEND2, MII_DP83822_LDCTRL,
+			       DP83822_100BASE_TX_LINE_DRIVER_SWING,
+			       FIELD_PREP(DP83822_100BASE_TX_LINE_DRIVER_SWING,
+					  dp83822->tx_amplitude_100base_tx_index));
+
 	err = dp83822_config_init_leds(phydev);
 	if (err)
 		return err;
@@ -720,6 +731,11 @@ static int dp83822_phy_reset(struct phy_device *phydev)
 }
 
 #ifdef CONFIG_OF_MDIO
+static const u32 tx_amplitude_100base_tx_gain[] = {
+	80, 82, 83, 85, 87, 88, 90, 92,
+	93, 95, 97, 98, 100, 102, 103, 105,
+};
+
 static int dp83822_of_init_leds(struct phy_device *phydev)
 {
 	struct device_node *node = phydev->mdio.dev.of_node;
@@ -780,6 +796,8 @@ static int dp83822_of_init(struct phy_device *phydev)
 	struct dp83822_private *dp83822 = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
 	const char *of_val;
+	int i, ret;
+	u32 val;
 
 	/* Signal detection for the PHY is only enabled if the FX_EN and the
 	 * SD_EN pins are strapped. Signal detection can only enabled if FX_EN
@@ -815,6 +833,26 @@ static int dp83822_of_init(struct phy_device *phydev)
 		dp83822->set_gpio2_clk_out = true;
 	}
 
+	dp83822->tx_amplitude_100base_tx_index = -1;
+	ret = phy_get_tx_amplitude_gain(phydev, dev,
+					ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+					&val);
+	if (!ret) {
+		for (i = 0; i < ARRAY_SIZE(tx_amplitude_100base_tx_gain); i++) {
+			if (tx_amplitude_100base_tx_gain[i] == val) {
+				dp83822->tx_amplitude_100base_tx_index = i;
+				break;
+			}
+		}
+
+		if (dp83822->tx_amplitude_100base_tx_index < 0) {
+			phydev_err(phydev,
+				   "Invalid value for tx-amplitude-100base-tx-percent property (%u)\n",
+				   val);
+			return -EINVAL;
+		}
+	}
+
 	return dp83822_of_init_leds(phydev);
 }
 
-- 
2.39.5



