Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8C827603A;
	Thu, 28 May 2026 20:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001538; cv=none; b=cZleaFzS1Bt1Vs74bv3bUtxGmV9HS2ZQtfWuBkM047ad0LYybl40ZsRVd0WsWsg35bPrMidvHlCS3c4KyLsDgKEFcU5Q/OR+ASeQbWIqV1CEnO3UunJgv/zkGkK7axCkkgQokhVmG9q33MwvJK1k3LIJ22CjsBlDaosQIzphxPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001538; c=relaxed/simple;
	bh=pjXOQBtiNrG+oGwsUUrbYz9H/E0OA+sUlucbzpi38VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEd7Nad+cKxan0xJqhquxv9kimAzTcXPRJbV++zwss3RkDoAkyIr48vi9d7zew5rxrf82SZiWzc7mD9Ag8C+kTNFNOBRuu9s9TvHcdC8WYPp2EuYeYTYu/ebrejRzdImuOeEJleTAiTpnFCs8U4ZIv0TSnM6ymwq6NAkipPxD5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYoErqX2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYoErqX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97B11F000E9;
	Thu, 28 May 2026 20:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001537;
	bh=KaMqL5A355LXOOtmh0iadIqs2ctMwryEEn6Oq4pXax4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYoErqX2rDDy2s2p1hIaLm8R8MqHCuNU1f22RcRylyCyud+wiRozweIpUgDg+vZtM
	 btIIrhLf+2gfFU87rFhN0lp+ym6B+k6sNBvGFoQ9//nk6ZcxCzHO4wcktfQsOdXGNT
	 46Kuun7YarLcdchzrofwv6oc6y90afimdeByGMaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/186] net: phy: c45: add genphy_c45_pma_read_ext_abilities() function
Date: Thu, 28 May 2026 21:50:26 +0200
Message-ID: <20260528194932.895010543@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 0c476157085fe2ad13b9bec70ea672e86647fa1a ]

Move part of the genphy_c45_pma_read_abilities() code to a separate
function.

Some PHYs do not implement PMA/PMD status 2 register (Register 1.8) but
do implement PMA/PMD extended ability register (Register 1.11). To make
use of it, we need to be able to access this part of code separately.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20231212054144.87527-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c78bdba7b966 ("net: phy: DP83TC811: add reading of abilities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy-c45.c | 129 ++++++++++++++++++++++----------------
 include/linux/phy.h       |   1 +
 2 files changed, 75 insertions(+), 55 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 8e6fd4962c486..747d14bf152c3 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -919,6 +919,79 @@ int genphy_c45_pma_baset1_read_abilities(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_pma_baset1_read_abilities);
 
+/**
+ * genphy_c45_pma_read_ext_abilities - read supported link modes from PMA
+ * @phydev: target phy_device struct
+ *
+ * Read the supported link modes from the PMA/PMD extended ability register
+ * (Register 1.11).
+ */
+int genphy_c45_pma_read_ext_abilities(struct phy_device *phydev)
+{
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+	if (val < 0)
+		return val;
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT,
+			 phydev->supported,
+			 val & MDIO_PMA_EXTABLE_10GBLRM);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+			 phydev->supported,
+			 val & MDIO_PMA_EXTABLE_10GBT);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+			 phydev->supported,
+			 val & MDIO_PMA_EXTABLE_10GBKX4);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+			 phydev->supported,
+			 val & MDIO_PMA_EXTABLE_10GBKR);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+			 phydev->supported,
+			 val & MDIO_PMA_EXTABLE_1000BT);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+			 phydev->supported,
+			 val & MDIO_PMA_EXTABLE_1000BKX);
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+			 phydev->supported,
+			 val & MDIO_PMA_EXTABLE_100BTX);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+			 phydev->supported,
+			 val & MDIO_PMA_EXTABLE_100BTX);
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+			 phydev->supported,
+			 val & MDIO_PMA_EXTABLE_10BT);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+			 phydev->supported,
+			 val & MDIO_PMA_EXTABLE_10BT);
+
+	if (val & MDIO_PMA_EXTABLE_NBT) {
+		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
+				   MDIO_PMA_NG_EXTABLE);
+		if (val < 0)
+			return val;
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+				 phydev->supported,
+				 val & MDIO_PMA_NG_EXTABLE_2_5GBT);
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
+				 phydev->supported,
+				 val & MDIO_PMA_NG_EXTABLE_5GBT);
+	}
+
+	if (val & MDIO_PMA_EXTABLE_BT1) {
+		val = genphy_c45_pma_baset1_read_abilities(phydev);
+		if (val < 0)
+			return val;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_pma_read_ext_abilities);
+
 /**
  * genphy_c45_pma_read_abilities - read supported link modes from PMA
  * @phydev: target phy_device struct
@@ -962,63 +1035,9 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev)
 			 val & MDIO_PMA_STAT2_10GBER);
 
 	if (val & MDIO_PMA_STAT2_EXTABLE) {
-		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+		val = genphy_c45_pma_read_ext_abilities(phydev);
 		if (val < 0)
 			return val;
-
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT,
-				 phydev->supported,
-				 val & MDIO_PMA_EXTABLE_10GBLRM);
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
-				 phydev->supported,
-				 val & MDIO_PMA_EXTABLE_10GBT);
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
-				 phydev->supported,
-				 val & MDIO_PMA_EXTABLE_10GBKX4);
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
-				 phydev->supported,
-				 val & MDIO_PMA_EXTABLE_10GBKR);
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-				 phydev->supported,
-				 val & MDIO_PMA_EXTABLE_1000BT);
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
-				 phydev->supported,
-				 val & MDIO_PMA_EXTABLE_1000BKX);
-
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
-				 phydev->supported,
-				 val & MDIO_PMA_EXTABLE_100BTX);
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
-				 phydev->supported,
-				 val & MDIO_PMA_EXTABLE_100BTX);
-
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
-				 phydev->supported,
-				 val & MDIO_PMA_EXTABLE_10BT);
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
-				 phydev->supported,
-				 val & MDIO_PMA_EXTABLE_10BT);
-
-		if (val & MDIO_PMA_EXTABLE_NBT) {
-			val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
-					   MDIO_PMA_NG_EXTABLE);
-			if (val < 0)
-				return val;
-
-			linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
-					 phydev->supported,
-					 val & MDIO_PMA_NG_EXTABLE_2_5GBT);
-
-			linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
-					 phydev->supported,
-					 val & MDIO_PMA_NG_EXTABLE_5GBT);
-		}
-
-		if (val & MDIO_PMA_EXTABLE_BT1) {
-			val = genphy_c45_pma_baset1_read_abilities(phydev);
-			if (val < 0)
-				return val;
-		}
 	}
 
 	/* This is optional functionality. If not supported, we may get an error
diff --git a/include/linux/phy.h b/include/linux/phy.h
index a57e799b1de18..586973404ad47 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1857,6 +1857,7 @@ int genphy_c45_an_config_aneg(struct phy_device *phydev);
 int genphy_c45_an_disable_aneg(struct phy_device *phydev);
 int genphy_c45_read_mdix(struct phy_device *phydev);
 int genphy_c45_pma_read_abilities(struct phy_device *phydev);
+int genphy_c45_pma_read_ext_abilities(struct phy_device *phydev);
 int genphy_c45_pma_baset1_read_abilities(struct phy_device *phydev);
 int genphy_c45_read_eee_abilities(struct phy_device *phydev);
 int genphy_c45_pma_baset1_read_master_slave(struct phy_device *phydev);
-- 
2.53.0



