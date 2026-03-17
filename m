Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594613590B8;
	Tue, 17 Mar 2026 16:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765929; cv=none; b=PbP6N/FY46oRtVC+g+KI10XlHI3lNw/lj+qQVEjfcoSgCCTkqUkc4MyXic9A8SLZwDKt/Ed5VP84PAu6E3aeIMtwtn4AhvgOhej21uvV4Hs9zhuEKO2BFVP4I+sDQC2t3aMYEpCQVi7HRLw31t7chDGyPS62hpIElfro3fFj+0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765929; c=relaxed/simple;
	bh=ZVlXG5qwvxFDlQaBDiU84MzdMJH3YwgdqGUPHO+KJOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A36jaizvO+34jSrZ8JrwCiv39/7bWQCyOn9QOKHgU9DEljgNyUfWbqv0L8hoE3MJQWXGfQvTKeqmjsX834+77ciY8Axu5IcVDy0TOm8EeJBAHnJ9dTui+wRI2wwyHXagHRPXqFd98meksZxAJSrvt5zN8Y8jJVQWfy9o6RIBUIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RriOMEvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RriOMEvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A9BC4CEF7;
	Tue, 17 Mar 2026 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765929;
	bh=ZVlXG5qwvxFDlQaBDiU84MzdMJH3YwgdqGUPHO+KJOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RriOMEvKeDM6ireVlC69s1IrV3fP8SYk3RQfydaVjUVBbGZlHFhUZ/63E3p4yuwoD
	 f8HZhB8e1IVced9yq2pK1CZ0X6uiOFIjFRE7/yZUcrTLtO4Y8g/hMDkYxxYLYEGRzz
	 TWJkDEWxhWbSfV/DQ+GQ5LvIwxVoTvMp2HuC17DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 096/378] net: bcmgenet: fix broken EEE by converting to phylib-managed state
Date: Tue, 17 Mar 2026 17:30:53 +0100
Message-ID: <20260317163010.549589477@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 05512aa10c209..1c2fdaca14f9b 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1342,8 +1342,7 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
-void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
-			     bool tx_lpi_enabled)
+void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	u32 off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
@@ -1363,7 +1362,7 @@ void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
 
 	/* Enable EEE and switch to a 27Mhz clock automatically */
 	reg = bcmgenet_readl(priv->base + off);
-	if (tx_lpi_enabled)
+	if (enable)
 		reg |= TBUF_EEE_EN | TBUF_PM_EN;
 	else
 		reg &= ~(TBUF_EEE_EN | TBUF_PM_EN);
@@ -1382,14 +1381,12 @@ void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
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
@@ -1397,17 +1394,21 @@ static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_keee *e)
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
@@ -1415,15 +1416,7 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_keee *e)
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
index 38f854b94a799..a4e0d5a682687 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -29,7 +29,6 @@ static void bcmgenet_mac_config(struct net_device *dev)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct phy_device *phydev = dev->phydev;
 	u32 reg, cmd_bits = 0;
-	bool active;
 
 	/* speed */
 	if (phydev->speed == SPEED_1000)
@@ -90,10 +89,6 @@ static void bcmgenet_mac_config(struct net_device *dev)
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	spin_unlock_bh(&priv->reg_lock);
 
-	active = phy_init_eee(phydev, 0) >= 0;
-	bcmgenet_eee_enable_set(dev,
-				priv->eee.eee_enabled && active,
-				priv->eee.tx_lpi_enabled);
 }
 
 /* setup netdev link state when PHY link status change and
@@ -113,6 +108,8 @@ void bcmgenet_mii_setup(struct net_device *dev)
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 	}
 
+	bcmgenet_eee_enable_set(dev, phydev->enable_tx_lpi);
+
 	phy_print_status(phydev);
 }
 
@@ -412,6 +409,9 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	/* Indicate that the MAC is responsible for PHY PM */
 	dev->phydev->mac_managed_pm = true;
 
+	if (!GENET_IS_V1(priv))
+		phy_support_eee(dev->phydev);
+
 	return 0;
 }
 
-- 
2.51.0



