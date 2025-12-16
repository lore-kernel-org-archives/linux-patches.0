Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8912E363C7D;
	Tue, 16 Dec 2025 12:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887766; cv=none; b=UtvvCgFbdm449K0rx4Sj+9BBZ2RMnayty9Pt/jr2wZiQ4/wZPKJjCn+nYFPnhcU97K08RNPSSmRCiCO65Af9+bN4r7MUczCJeTHD4jgkvvAkupj0O23BYXcp9yx7srX1WkvK5XIUSfIW6LaJ1MfbyZnHX1aiP0gFg5XzKXZc0Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887766; c=relaxed/simple;
	bh=jDhyj9QHCYrwqBgmw+7OrEQzQGQmsfnNWkc8QK2e37Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpNs6Mhsp9l0wq0ImQgL7BFrODzUZih90ma4YACz56aYdluG6+P5ATzM2yUxXK7mqIJXrydBNilRGBQvYmXVglwRoMByeGtSjMTeACcYgnuTGl0Ne4CEiqqq1vNBnvCTuDW9pp9OuC46Nee5SnZfrDiaJALqHigz0UyeYsjgUro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHVHMqdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHVHMqdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FA3C4CEF1;
	Tue, 16 Dec 2025 12:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887766;
	bh=jDhyj9QHCYrwqBgmw+7OrEQzQGQmsfnNWkc8QK2e37Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHVHMqdq5869W0RjHzC/pjBg4viBzFBu0DD8NzoLUAQkZn0rWJYoHBvt9AfALD0Ss
	 PGVOv97ONM475eisiAhgKgqOVYFXPIH1a81uuxRJB1yfzV76h/H7ZBDEa6HzseO6EY
	 XxeA8zcZTnuHBEYPhx9Q4JXtiMq+NzqElOOddqy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 331/614] net: phy: realtek: create rtl8211f_config_rgmii_delay()
Date: Tue, 16 Dec 2025 12:11:38 +0100
Message-ID: <20251216111413.358349536@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 8e982441ba601d982dd0739972115d85ae01d99b ]

The control flow in rtl8211f_config_init() has some pitfalls which were
probably unintended. Specifically it has an early return:

	switch (phydev->interface) {
	...
	default: /* the rest of the modes imply leaving delay as is. */
		return 0;
	}

which exits the entire config_init() function. This means it also skips
doing things such as disabling CLKOUT or disabling PHY-mode EEE.

For the RTL8211FS, which uses PHY_INTERFACE_MODE_SGMII, this might be a
problem. However, I don't know that it is, so there is no Fixes: tag.
The issue was observed through code inspection.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251117234033.345679-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 65 +++++++++++++++-----------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 16a347084293e..b26f4d1c6bbfa 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -560,22 +560,11 @@ static int rtl8211c_config_init(struct phy_device *phydev)
 			    CTL1000_ENABLE_MASTER | CTL1000_AS_MASTER);
 }
 
-static int rtl8211f_config_init(struct phy_device *phydev)
+static int rtl8211f_config_rgmii_delay(struct phy_device *phydev)
 {
-	struct rtl821x_priv *priv = phydev->priv;
-	struct device *dev = &phydev->mdio.dev;
 	u16 val_txdly, val_rxdly;
 	int ret;
 
-	ret = phy_modify_paged_changed(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR1,
-				       RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF,
-				       priv->phycr1);
-	if (ret < 0) {
-		dev_err(dev, "aldps mode  configuration failed: %pe\n",
-			ERR_PTR(ret));
-		return ret;
-	}
-
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		val_txdly = 0;
@@ -605,34 +594,58 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 				       RTL8211F_TXCR, RTL8211F_TX_DELAY,
 				       val_txdly);
 	if (ret < 0) {
-		dev_err(dev, "Failed to update the TX delay register\n");
+		phydev_err(phydev, "Failed to update the TX delay register: %pe\n",
+			   ERR_PTR(ret));
 		return ret;
 	} else if (ret) {
-		dev_dbg(dev,
-			"%s 2ns TX delay (and changing the value from pin-strapping RXD1 or the bootloader)\n",
-			str_enable_disable(val_txdly));
+		phydev_dbg(phydev,
+			   "%s 2ns TX delay (and changing the value from pin-strapping RXD1 or the bootloader)\n",
+			   str_enable_disable(val_txdly));
 	} else {
-		dev_dbg(dev,
-			"2ns TX delay was already %s (by pin-strapping RXD1 or bootloader configuration)\n",
-			str_enabled_disabled(val_txdly));
+		phydev_dbg(phydev,
+			   "2ns TX delay was already %s (by pin-strapping RXD1 or bootloader configuration)\n",
+			   str_enabled_disabled(val_txdly));
 	}
 
 	ret = phy_modify_paged_changed(phydev, RTL8211F_RGMII_PAGE,
 				       RTL8211F_RXCR, RTL8211F_RX_DELAY,
 				       val_rxdly);
 	if (ret < 0) {
-		dev_err(dev, "Failed to update the RX delay register\n");
+		phydev_err(phydev, "Failed to update the RX delay register: %pe\n",
+			   ERR_PTR(ret));
 		return ret;
 	} else if (ret) {
-		dev_dbg(dev,
-			"%s 2ns RX delay (and changing the value from pin-strapping RXD0 or the bootloader)\n",
-			str_enable_disable(val_rxdly));
+		phydev_dbg(phydev,
+			   "%s 2ns RX delay (and changing the value from pin-strapping RXD0 or the bootloader)\n",
+			   str_enable_disable(val_rxdly));
 	} else {
-		dev_dbg(dev,
-			"2ns RX delay was already %s (by pin-strapping RXD0 or bootloader configuration)\n",
-			str_enabled_disabled(val_rxdly));
+		phydev_dbg(phydev,
+			   "2ns RX delay was already %s (by pin-strapping RXD0 or bootloader configuration)\n",
+			   str_enabled_disabled(val_rxdly));
 	}
 
+	return 0;
+}
+
+static int rtl8211f_config_init(struct phy_device *phydev)
+{
+	struct rtl821x_priv *priv = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	int ret;
+
+	ret = phy_modify_paged_changed(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR1,
+				       RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF,
+				       priv->phycr1);
+	if (ret < 0) {
+		dev_err(dev, "aldps mode  configuration failed: %pe\n",
+			ERR_PTR(ret));
+		return ret;
+	}
+
+	ret = rtl8211f_config_rgmii_delay(phydev);
+	if (ret)
+		return ret;
+
 	if (!priv->has_phycr2)
 		return 0;
 
-- 
2.51.0



