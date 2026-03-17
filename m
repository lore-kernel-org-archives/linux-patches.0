Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603E93F65E5;
	Tue, 17 Mar 2026 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767443; cv=none; b=joBXSNEkMIqzuTnuuENfwZvgsSl67OJjcFp5SlKiBqLQCfUQwaYsRizRNpcnVBMAxRcWvfoI39s8mZ7DugaLUbiieqM+lRfggg7HZMesxa7kDPFOVoWoc/Amki675XuMaEQJI32luwby6zYyr9IGkM13LeYnpf10+h14BrOjRfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767443; c=relaxed/simple;
	bh=dDCBOAMCCbnbjK8DbIGgcbDID9/7jYG21uvX6OIgveM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alBwfNWFIekr6wAkx3yYkhQ+8POu/K8adcBZRFT7ycDMdirCFaVKAkWCoZ3Etk8qlJ5P1ilkvzlnzBSfVkAWKaWudsyG5+2SsPD8bbwEQihAqGEDNFKlLHj67+o7DijuGBWnmyag7IxT2s8wp1aAZg6k2myX7Lvm9Zr04ZAWP5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJy6Xcnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJy6Xcnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0855C4CEF7;
	Tue, 17 Mar 2026 17:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767443;
	bh=dDCBOAMCCbnbjK8DbIGgcbDID9/7jYG21uvX6OIgveM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJy6Xcnwap9JHsrvdC9YpI/vOvZv5eXleq3w0YRfWdHl9h85QqNBf8ISyUvCpGR4y
	 80/AU4Lcz9LsGe7plCcpCu09xuUC0r1zK+q0Od4hWVuTnJDe6ekI4C0sfmpN29Tv8T
	 Z74YrFJRV6IXiKPNmfcKnR6GvLAZEhlb7Q2zVVB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/333] net: bcmgenet: fix broken EEE by converting to phylib-managed state
Date: Tue, 17 Mar 2026 17:31:56 +0100
Message-ID: <20260317163002.599587196@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
index 98971ae4f87df..e142939d87cbe 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1343,8 +1343,7 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
-void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
-			     bool tx_lpi_enabled)
+void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	u32 off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
@@ -1364,7 +1363,7 @@ void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
 
 	/* Enable EEE and switch to a 27Mhz clock automatically */
 	reg = bcmgenet_readl(priv->base + off);
-	if (tx_lpi_enabled)
+	if (enable)
 		reg |= TBUF_EEE_EN | TBUF_PM_EN;
 	else
 		reg &= ~(TBUF_EEE_EN | TBUF_PM_EN);
@@ -1383,14 +1382,12 @@ void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
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
@@ -1398,17 +1395,21 @@ static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_keee *e)
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
@@ -1416,15 +1417,7 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_keee *e)
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
index 5ec3979779ece..9e4110c7fdf6f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -665,8 +665,6 @@ struct bcmgenet_priv {
 	u8 sopass[SOPASS_MAX];
 
 	struct bcmgenet_mib_counters mib;
-
-	struct ethtool_keee eee;
 };
 
 static inline bool bcmgenet_has_40bits(struct bcmgenet_priv *priv)
@@ -749,7 +747,6 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 int bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 			      enum bcmgenet_power_mode mode);
 
-void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
-			     bool tx_lpi_enabled);
+void bcmgenet_eee_enable_set(struct net_device *dev, bool enable);
 
 #endif /* __BCMGENET_H__ */
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 573e8b279e52f..33e3eec31cc9e 100644
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
 
@@ -413,6 +410,9 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	/* Indicate that the MAC is responsible for PHY PM */
 	dev->phydev->mac_managed_pm = true;
 
+	if (!GENET_IS_V1(priv))
+		phy_support_eee(dev->phydev);
+
 	return 0;
 }
 
-- 
2.51.0



