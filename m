Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E708B69D3B;
	Wed, 21 Feb 2024 14:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525789; cv=none; b=rGpKoP+FPjmypIHY4AjULvksQjDNlwUA+5iQ/hMf8pBNfzi584Smegn0ejumBrhUjuG9BKDwO1U3jxg2bdidS7rG2HXPsm2t7D6zTSoFSgl4/oEMgVzWu19g8Z6SFaqdyLvcgV+MbIuB9otilhS9ceXoIRJlInEXgUxtu01QJ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525789; c=relaxed/simple;
	bh=gPEy8kIXSItW9Uha/r54BTGALmVYYGr16/lM+vELGi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuegoW0nSBLCzYG/WDpAD57WBSdsxrOFbBAQGbWFa8i5rMionbDFeCnHrzj/eYOa2jriYmG77sNEoVUzIEeAzuUqpkW0YIxYtoqy7hr85zFHxmdpP6P56phGoOE/LR3ajS3VPQT619CvxECv+5B78qj1hS4/r2WFVpGyr53IETk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVd3W1QP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVd3W1QP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1116C433C7;
	Wed, 21 Feb 2024 14:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525788;
	bh=gPEy8kIXSItW9Uha/r54BTGALmVYYGr16/lM+vELGi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVd3W1QPZKpV4M2Bb7zx4oCK5L81VgYM6Ea6oacDpljvQQyjaz4M5vy46pAPalgpT
	 gpkHcfg68DHlBaSYpeFwOcCylelPBwVA2dK3BzSYjlIBWqvzGhPj0SwzW1BRWdh0Rn
	 GxoXRqykOBfH3sQ0sDRUNRQpgVvInyJ57BegSlP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 265/267] net: bcmgenet: Fix EEE implementation
Date: Wed, 21 Feb 2024 14:10:06 +0100
Message-ID: <20240221125948.557217244@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

commit a9f31047baca57d47440c879cf259b86f900260c upstream.

We had a number of short comings:

- EEE must be re-evaluated whenever the state machine detects a link
  change as wight be switching from a link partner with EEE
  enabled/disabled

- tx_lpi_enabled controls whether EEE should be enabled/disabled for the
  transmit path, which applies to the TBUF block

- We do not need to forcibly enable EEE upon system resume, as the PHY
  state machine will trigger a link event that will do that, too

Fixes: 6ef398ea60d9 ("net: bcmgenet: add EEE support")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20230606214348.2408018-1-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |   22 ++++++++--------------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |    3 +++
 drivers/net/ethernet/broadcom/genet/bcmmii.c   |    6 ++++++
 3 files changed, 17 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1018,7 +1018,8 @@ static void bcmgenet_get_ethtool_stats(s
 	}
 }
 
-static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
+void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
+			     bool tx_lpi_enabled)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	u32 off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
@@ -1038,7 +1039,7 @@ static void bcmgenet_eee_enable_set(stru
 
 	/* Enable EEE and switch to a 27Mhz clock automatically */
 	reg = bcmgenet_readl(priv->base + off);
-	if (enable)
+	if (tx_lpi_enabled)
 		reg |= TBUF_EEE_EN | TBUF_PM_EN;
 	else
 		reg &= ~(TBUF_EEE_EN | TBUF_PM_EN);
@@ -1059,6 +1060,7 @@ static void bcmgenet_eee_enable_set(stru
 
 	priv->eee.eee_enabled = enable;
 	priv->eee.eee_active = enable;
+	priv->eee.tx_lpi_enabled = tx_lpi_enabled;
 }
 
 static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
@@ -1074,6 +1076,7 @@ static int bcmgenet_get_eee(struct net_d
 
 	e->eee_enabled = p->eee_enabled;
 	e->eee_active = p->eee_active;
+	e->tx_lpi_enabled = p->tx_lpi_enabled;
 	e->tx_lpi_timer = bcmgenet_umac_readl(priv, UMAC_EEE_LPI_TIMER);
 
 	return phy_ethtool_get_eee(dev->phydev, e);
@@ -1083,7 +1086,6 @@ static int bcmgenet_set_eee(struct net_d
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct ethtool_eee *p = &priv->eee;
-	int ret = 0;
 
 	if (GENET_IS_V1(priv))
 		return -EOPNOTSUPP;
@@ -1094,16 +1096,11 @@ static int bcmgenet_set_eee(struct net_d
 	p->eee_enabled = e->eee_enabled;
 
 	if (!p->eee_enabled) {
-		bcmgenet_eee_enable_set(dev, false);
+		bcmgenet_eee_enable_set(dev, false, false);
 	} else {
-		ret = phy_init_eee(dev->phydev, 0);
-		if (ret) {
-			netif_err(priv, hw, dev, "EEE initialization failed\n");
-			return ret;
-		}
-
+		p->eee_active = phy_init_eee(dev->phydev, false) >= 0;
 		bcmgenet_umac_writel(priv, e->tx_lpi_timer, UMAC_EEE_LPI_TIMER);
-		bcmgenet_eee_enable_set(dev, true);
+		bcmgenet_eee_enable_set(dev, p->eee_active, e->tx_lpi_enabled);
 	}
 
 	return phy_ethtool_set_eee(dev->phydev, e);
@@ -3688,9 +3685,6 @@ static int bcmgenet_resume(struct device
 	if (!device_may_wakeup(d))
 		phy_resume(dev->phydev);
 
-	if (priv->eee.eee_enabled)
-		bcmgenet_eee_enable_set(dev, true);
-
 	bcmgenet_netif_start(dev);
 
 	netif_device_attach(dev);
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -736,4 +736,7 @@ int bcmgenet_wol_power_down_cfg(struct b
 void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 			       enum bcmgenet_power_mode mode);
 
+void bcmgenet_eee_enable_set(struct net_device *dev, bool enable,
+			     bool tx_lpi_enabled);
+
 #endif /* __BCMGENET_H__ */
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -25,6 +25,7 @@
 
 #include "bcmgenet.h"
 
+
 /* setup netdev link state when PHY link status change and
  * update UMAC and RGMII block when link up
  */
@@ -96,6 +97,11 @@ void bcmgenet_mii_setup(struct net_devic
 			       CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE);
 		reg |= cmd_bits;
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+
+		priv->eee.eee_active = phy_init_eee(phydev, 0) >= 0;
+		bcmgenet_eee_enable_set(dev,
+					priv->eee.eee_enabled && priv->eee.eee_active,
+					priv->eee.tx_lpi_enabled);
 	} else {
 		/* done if nothing has changed */
 		if (!status_changed)


