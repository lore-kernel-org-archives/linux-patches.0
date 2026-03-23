Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7D93B19A1;
	Mon, 23 Mar 2026 14:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275375; cv=none; b=Q3ZJp0c5jmxabs/e98hMR3o/ixqcOXinOz5MgaJ3yXnOPV3Z2XyyVh5O3bHLG4cBvfsNm+ArLsYQ9TivrUfC67zY2W2kpdx1h8sGCp6+WG8z3Eyowow3YNowf7GA0xLhXUF6WwmLM9WuuheKNmmz6vAUbSyhRAx/JBeFgVhK1J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275375; c=relaxed/simple;
	bh=kOmkLSmqeo5ESaMJsVHiabUQ7iI7/y+PWl20mPD7jdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7FOqnOLH1XZZllzc13sWq8Zz+hdYBe6MJ7yrbeYlt7YTGAchRFBBLNEZFtweG49nexl90tavZr+eWZZoDy78N5hyxr2H/ambyKb9EOhqp27EFeVmg39Mfc+Zbj+pNh2U3bg1RBHn3LpURX9jx+SC9NrW3FVaWluo46MMx3OgWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9J2S7Dq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9J2S7Dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EF0C4CEF7;
	Mon, 23 Mar 2026 14:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275375;
	bh=kOmkLSmqeo5ESaMJsVHiabUQ7iI7/y+PWl20mPD7jdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9J2S7DqrauKNOFwT7HdwfJltzWajlhAukhc2tH1f8TVSTZbMzTECXJQa8/YCFqQ+
	 s0h4g0WKM2LoMcgayw06CQGzupJdZkmMs3HKLYCxvTXj3n30iOLIHewE6RIj7ni0rl
	 sENlOde6UyY0yzMqREe/8OTlb/YESzn7JA3laHmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/460] net: bcmgenet: fix broken EEE by converting to phylib-managed state
Date: Mon, 23 Mar 2026 14:41:12 +0100
Message-ID: <20260323134528.554977532@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 908c344d5cfac4160f49715da9efacdf5b6a28bd ]

The bcmgenet EEE implementation is broken in several ways.
phy_support_eee() is never called, so the PHY never advertises EEE
and phylib never sets phydev->enable_tx_lpi.  bcmgenet_mac_config()
checks priv->eee.eee_enabled to decide whether to enable the MAC
LPI logic, but that field is never initialised to true, so the MAC
never enters Low Power Idle even when EEE is negotiated - wasting
the power savings EEE is designed to provide.  The only way to get
EEE working at all is a manual 'ethtool --set-eee eth0 eee on' after
every link-up, and even then bcmgenet_get_eee() immediately clobbers
the reported state because phy_ethtool_get_eee() overwrites
eee_enabled and tx_lpi_enabled with the uninitialised PHY eee_cfg
values.  Finally, bcmgenet_mac_config() is only called on link-up,
so EEE is never disabled in hardware on link-down.

Fix all of this by removing the MAC-side EEE state tracking
(priv->eee) and aligning with the pattern used by other non-phylink
MAC drivers such as FEC.

Call phy_support_eee() in bcmgenet_mii_probe() so the PHY advertises
EEE link modes and phylib tracks negotiation state.  Move the EEE
hardware control to bcmgenet_mii_setup(), which is called on every
link event, and drive it directly from phydev->enable_tx_lpi - the
flag phylib sets when EEE is negotiated and the user has not disabled
it.  This enables EEE automatically once the link partner agrees and
disables it cleanly on link-down.

Make bcmgenet_get_eee() and bcmgenet_set_eee() pure passthroughs to
phy_ethtool_get_eee() and phy_ethtool_set_eee(), with the MAC
hardware register read/written for tx_lpi_timer.  Drop struct
ethtool_keee eee from struct bcmgenet_priv.

Fixes: fe0d4fd9285e ("net: phy: Keep track of EEE configuration")
Link: https://lore.kernel.org/netdev/d352039f-4cbb-41e6-9aeb-0b4f3941b54c@lunn.ch/
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260310054935.1238594-1-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 31 +++++++------------
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  5 +--
 drivers/net/ethernet/broadcom/genet/bcmmii.c  | 10 +++---
 3 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index f7be886570d88..49f6e83d60139 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1272,8 +1272,7 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
-void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
-			     bool tx_lpi_enabled)
+void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	u32 off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
@@ -1293,7 +1292,7 @@ void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
 
 	/* Enable EEE and switch to a 27Mhz clock automatically */
 	reg = bcmgenet_readl(priv->base + off);
-	if (tx_lpi_enabled)
+	if (enable)
 		reg |= TBUF_EEE_EN | TBUF_PM_EN;
 	else
 		reg &= ~(TBUF_EEE_EN | TBUF_PM_EN);
@@ -1312,14 +1311,12 @@ void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
 		priv->clk_eee_enabled = false;
 	}
 
-	priv->eee.eee_enabled = enable;
-	priv->eee.tx_lpi_enabled = tx_lpi_enabled;
 }
 
 static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_keee *e)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	struct ethtool_keee *p = &priv->eee;
+	int ret;
 
 	if (GENET_IS_V1(priv))
 		return -EOPNOTSUPP;
@@ -1327,17 +1324,21 @@ static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_keee *e)
 	if (!dev->phydev)
 		return -ENODEV;
 
-	e->tx_lpi_enabled = p->tx_lpi_enabled;
+	ret = phy_ethtool_get_eee(dev->phydev, e);
+	if (ret)
+		return ret;
+
+	/* tx_lpi_timer is maintained by the MAC hardware register; the
+	 * PHY-level eee_cfg timer is not set for GENET.
+	 */
 	e->tx_lpi_timer = bcmgenet_umac_readl(priv, UMAC_EEE_LPI_TIMER);
 
-	return phy_ethtool_get_eee(dev->phydev, e);
+	return 0;
 }
 
 static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_keee *e)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	struct ethtool_keee *p = &priv->eee;
-	bool active;
 
 	if (GENET_IS_V1(priv))
 		return -EOPNOTSUPP;
@@ -1345,15 +1346,7 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_keee *e)
 	if (!dev->phydev)
 		return -ENODEV;
 
-	p->eee_enabled = e->eee_enabled;
-
-	if (!p->eee_enabled) {
-		bcmgenet_eee_enable_set(dev, false, false);
-	} else {
-		active = phy_init_eee(dev->phydev, false) >= 0;
-		bcmgenet_umac_writel(priv, e->tx_lpi_timer, UMAC_EEE_LPI_TIMER);
-		bcmgenet_eee_enable_set(dev, active, e->tx_lpi_enabled);
-	}
+	bcmgenet_umac_writel(priv, e->tx_lpi_timer, UMAC_EEE_LPI_TIMER);
 
 	return phy_ethtool_set_eee(dev->phydev, e);
 }
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 43b923c48b14f..c0005a0fff567 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -646,8 +646,6 @@ struct bcmgenet_priv {
 	bool wol_active;
 
 	struct bcmgenet_mib_counters mib;
-
-	struct ethtool_keee eee;
 };
 
 #define GENET_IO_MACRO(name, offset)					\
@@ -705,7 +703,6 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 			       enum bcmgenet_power_mode mode);
 
-void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
-			     bool tx_lpi_enabled);
+void bcmgenet_eee_enable_set(struct net_device *dev, bool enable);
 
 #endif /* __BCMGENET_H__ */
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index c4a3698cef66f..9beb65e6d0a96 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -30,7 +30,6 @@ static void bcmgenet_mac_config(struct net_device *dev)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct phy_device *phydev = dev->phydev;
 	u32 reg, cmd_bits = 0;
-	bool active;
 
 	/* speed */
 	if (phydev->speed == SPEED_1000)
@@ -91,10 +90,6 @@ static void bcmgenet_mac_config(struct net_device *dev)
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	spin_unlock_bh(&priv->reg_lock);
 
-	active = phy_init_eee(phydev, 0) >= 0;
-	bcmgenet_eee_enable_set(dev,
-				priv->eee.eee_enabled && active,
-				priv->eee.tx_lpi_enabled);
 }
 
 /* setup netdev link state when PHY link status change and
@@ -114,6 +109,8 @@ void bcmgenet_mii_setup(struct net_device *dev)
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 	}
 
+	bcmgenet_eee_enable_set(dev, phydev->enable_tx_lpi);
+
 	phy_print_status(phydev);
 }
 
@@ -408,6 +405,9 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	/* Indicate that the MAC is responsible for PHY PM */
 	dev->phydev->mac_managed_pm = true;
 
+	if (!GENET_IS_V1(priv))
+		phy_support_eee(dev->phydev);
+
 	return 0;
 }
 
-- 
2.51.0



