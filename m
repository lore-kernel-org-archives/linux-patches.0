Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B288B2C15B2;
	Tue, 31 Mar 2026 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975839; cv=none; b=vD0t00wJxD3Caq8kXkKvvCJvOrKJkDNfiaY7PTU3DBY99jpNRhaQdtwz/eTaLJu6uBhC26zqbCizGlP86mkMs1D+MwAQvm8sp8Z52j+qBxpp/uMa5jimi0yE0v0/H4lvJERSuPIkvTZCkN8P/wg0SN5ko67o4aUY3R7JDfDzJxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975839; c=relaxed/simple;
	bh=kBLF/si8f+5kjwQhr6AikCY/Y5tHWWutIR5jupX2Z9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZVh5N1U6hEDlIq6+ccy9M//nZMU0KqSPWgV2pVbvwQ/DyQ+1eXGzd20nFf0VW4AxUa33xTvB+jfvZvzOQt2q6lIz14y4569oK7hdFFJc4lExbWXs8ccbku8se+eZxKHYsMjki/KmMtS9KkK7avsLieS9ikemx5q3Ev8Q49qOks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xl0fghHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xl0fghHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37100C19423;
	Tue, 31 Mar 2026 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975839;
	bh=kBLF/si8f+5kjwQhr6AikCY/Y5tHWWutIR5jupX2Z9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xl0fghHUHjP5xeC2XbRQSKsH6WGVXmwaV0XujDF83HPWrkqWrvUxFwsXEKkX/XktE
	 Vsg1SJE9/6px+erqv9SPLA58iGLXTZQghevzRrDz4JsKzdbcCPqguDK9maCK6X29NY
	 FE/qJ/xgKRnPzQFUo1GWbNfhsV4wYTJDURMp6lAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/244] net: bcm: asp2: convert to phylib managed EEE
Date: Tue, 31 Mar 2026 18:20:24 +0200
Message-ID: <20260331161744.420235372@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 21f56ad1b21131eb2c9c16e11ccb28f77b5addc4 ]

Convert the Broadcom ASP2 driver to use phylib managed EEE support.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/E1tXk81-000r4x-TS@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cbfa5be2bf64 ("net: bcmasp: fix double free of WoL irq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.h   |  3 --
 .../ethernet/broadcom/asp2/bcmasp_ethtool.c   | 31 -------------------
 .../net/ethernet/broadcom/asp2/bcmasp_intf.c  | 19 ++++++------
 3 files changed, 10 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.h b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
index f93cb3da44b0c..8fc75bcedb70f 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.h
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
@@ -348,8 +348,6 @@ struct bcmasp_intf {
 	/* Used if per intf wol irq */
 	int				wol_irq;
 	unsigned int			wol_irq_enabled:1;
-
-	struct ethtool_keee		eee;
 };
 
 #define NUM_NET_FILTERS				32
@@ -601,5 +599,4 @@ int bcmasp_netfilt_get_all_active(struct bcmasp_intf *intf, u32 *rule_locs,
 
 void bcmasp_netfilt_suspend(struct bcmasp_intf *intf);
 
-void bcmasp_eee_enable_set(struct bcmasp_intf *intf, bool enable);
 #endif
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
index 73334ab526136..c24107baefcfd 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
@@ -348,20 +348,6 @@ static int bcmasp_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 	return err;
 }
 
-void bcmasp_eee_enable_set(struct bcmasp_intf *intf, bool enable)
-{
-	u32 reg;
-
-	reg = umac_rl(intf, UMC_EEE_CTRL);
-	if (enable)
-		reg |= EEE_EN;
-	else
-		reg &= ~EEE_EN;
-	umac_wl(intf, reg, UMC_EEE_CTRL);
-
-	intf->eee.eee_enabled = enable;
-}
-
 static int bcmasp_get_eee(struct net_device *dev, struct ethtool_keee *e)
 {
 	if (!dev->phydev)
@@ -372,26 +358,9 @@ static int bcmasp_get_eee(struct net_device *dev, struct ethtool_keee *e)
 
 static int bcmasp_set_eee(struct net_device *dev, struct ethtool_keee *e)
 {
-	struct bcmasp_intf *intf = netdev_priv(dev);
-	struct ethtool_keee *p = &intf->eee;
-	int ret;
-
 	if (!dev->phydev)
 		return -ENODEV;
 
-	if (!p->eee_enabled) {
-		bcmasp_eee_enable_set(intf, false);
-	} else {
-		ret = phy_init_eee(dev->phydev, 0);
-		if (ret) {
-			netif_err(intf, hw, dev,
-				  "EEE initialization failed: %d\n", ret);
-			return ret;
-		}
-
-		bcmasp_eee_enable_set(intf, true);
-	}
-
 	return phy_ethtool_set_eee(dev->phydev, e);
 }
 
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 73e704352d820..acf45789d4493 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -616,7 +616,6 @@ static void bcmasp_adj_link(struct net_device *dev)
 	struct phy_device *phydev = dev->phydev;
 	u32 cmd_bits = 0, reg;
 	int changed = 0;
-	bool active;
 
 	if (intf->old_link != phydev->link) {
 		changed = 1;
@@ -675,9 +674,12 @@ static void bcmasp_adj_link(struct net_device *dev)
 		umac_wl(intf, reg, UMC_CMD);
 
 		umac_wl(intf, phydev->eee_cfg.tx_lpi_timer, UMC_EEE_LPI_TIMER);
-
-		active = phy_init_eee(phydev, 0) >= 0;
-		bcmasp_eee_enable_set(intf, active);
+		reg = umac_rl(intf, UMC_EEE_CTRL);
+		if (phydev->enable_tx_lpi)
+			reg |= EEE_EN;
+		else
+			reg &= ~EEE_EN;
+		umac_wl(intf, reg, UMC_EEE_CTRL);
 	}
 
 	reg = rgmii_rl(intf, RGMII_OOB_CNTRL);
@@ -1336,7 +1338,8 @@ static void bcmasp_suspend_to_wol(struct bcmasp_intf *intf)
 				     ASP_WAKEUP_INTR2_MASK_CLEAR);
 	}
 
-	if (intf->eee.eee_enabled && intf->parent->eee_fixup)
+	if (ndev->phydev && ndev->phydev->eee_cfg.eee_enabled &&
+	    intf->parent->eee_fixup)
 		intf->parent->eee_fixup(intf, true);
 
 	netif_dbg(intf, wol, ndev, "entered WOL mode\n");
@@ -1378,7 +1381,8 @@ static void bcmasp_resume_from_wol(struct bcmasp_intf *intf)
 {
 	u32 reg;
 
-	if (intf->eee.eee_enabled && intf->parent->eee_fixup)
+	if (intf->ndev->phydev && intf->ndev->phydev->eee_cfg.eee_enabled &&
+	    intf->parent->eee_fixup)
 		intf->parent->eee_fixup(intf, false);
 
 	reg = umac_rl(intf, UMC_MPD_CTRL);
@@ -1409,9 +1413,6 @@ int bcmasp_interface_resume(struct bcmasp_intf *intf)
 
 	bcmasp_resume_from_wol(intf);
 
-	if (intf->eee.eee_enabled)
-		bcmasp_eee_enable_set(intf, true);
-
 	netif_device_attach(dev);
 
 	return 0;
-- 
2.51.0



