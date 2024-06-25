Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C1B1465A8;
	Tue, 25 Jun 2024 09:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309587; cv=none; b=SnPnQtLA3+diOfc7uBa5ia/sIQZOiWf1POS9kJXBFThQ+/LxkW4LzHBgtC1KXu50iQUzQWbv0dmLsUEdcD/npaULNEoZUOYwDua8LC6p7IeApjucG1+cJA0SFxYzPYC9XGz6NZ+4nGIo5FCePQUcYpFgzJBq3Fa2OKtKGIjWoU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309587; c=relaxed/simple;
	bh=XcchsQifl6fCPoytzDD51t4cFpF/qDZ1//Kwl74zEoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3nquF1WieMNLfiGEqC+vhBX9EPDAVEGrdoq3MrHSPLnVS75rsvG6UgJSltDw0agse9poqPF/7zVdVRUhILz9BzO9Nvo5xdEzESyzWDEBTA0+EES24kZuvP1AjLjWFONP/Et2P9Bb8kyOjvxpCyc36kGO9WgAMkRENb+PqFB2xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhcHqdZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhcHqdZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38257C32781;
	Tue, 25 Jun 2024 09:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309585;
	bh=XcchsQifl6fCPoytzDD51t4cFpF/qDZ1//Kwl74zEoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhcHqdZqDO4xkp+4Julle/zla3Dza3Uf0jfyPNDgtCa+BgrrO0z4K6ZyBDLHyeElC
	 UQH4FU4/r7Tr3nue20p6tgdeAA+BY8+XaGQQrRiioDOmkhcAbGKObniUnmDXw8UhTy
	 nlCsQqwu22Rggm5lCXOgaiiaWxdNhLPw8VYMqbC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/131] net: phy: mxl-gpy: Remove interrupt mask clearing from config_init
Date: Tue, 25 Jun 2024 11:33:39 +0200
Message-ID: <20240625085528.378835527@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

[ Upstream commit c44d3ffd85db03ebcc3090e55589e10d5af9f3a9 ]

When the system resumes from sleep, the phy_init_hw() function invokes
config_init(), which clears all interrupt masks and causes wake events to be
lost in subsequent wake sequences. Remove interrupt mask clearing from
config_init() and preserve relevant masks in config_intr().

Fixes: 7d901a1e878a ("net: phy: add Maxlinear GPY115/21x/24x driver")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mxl-gpy.c | 58 +++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 1c4ad1ded2cb6..f07760e0455d5 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -95,6 +95,7 @@ struct gpy_priv {
 
 	u8 fw_major;
 	u8 fw_minor;
+	u32 wolopts;
 
 	/* It takes 3 seconds to fully switch out of loopback mode before
 	 * it can safely re-enter loopback mode. Record the time when
@@ -209,6 +210,15 @@ static int gpy_hwmon_register(struct phy_device *phydev)
 }
 #endif
 
+static int gpy_ack_interrupt(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Clear all pending interrupts */
+	ret = phy_read(phydev, PHY_ISTAT);
+	return ret < 0 ? ret : 0;
+}
+
 static int gpy_mbox_read(struct phy_device *phydev, u32 addr)
 {
 	struct gpy_priv *priv = phydev->priv;
@@ -250,16 +260,8 @@ static int gpy_mbox_read(struct phy_device *phydev, u32 addr)
 
 static int gpy_config_init(struct phy_device *phydev)
 {
-	int ret;
-
-	/* Mask all interrupts */
-	ret = phy_write(phydev, PHY_IMASK, 0);
-	if (ret)
-		return ret;
-
-	/* Clear all pending interrupts */
-	ret = phy_read(phydev, PHY_ISTAT);
-	return ret < 0 ? ret : 0;
+	/* Nothing to configure. Configuration Requirement Placeholder */
+	return 0;
 }
 
 static bool gpy_has_broken_mdint(struct phy_device *phydev)
@@ -540,11 +542,23 @@ static int gpy_read_status(struct phy_device *phydev)
 
 static int gpy_config_intr(struct phy_device *phydev)
 {
+	struct gpy_priv *priv = phydev->priv;
 	u16 mask = 0;
+	int ret;
+
+	ret = gpy_ack_interrupt(phydev);
+	if (ret)
+		return ret;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
 		mask = PHY_IMASK_MASK;
 
+	if (priv->wolopts & WAKE_MAGIC)
+		mask |= PHY_IMASK_WOL;
+
+	if (priv->wolopts & WAKE_PHY)
+		mask |= PHY_IMASK_LSTC;
+
 	return phy_write(phydev, PHY_IMASK, mask);
 }
 
@@ -593,6 +607,7 @@ static int gpy_set_wol(struct phy_device *phydev,
 		       struct ethtool_wolinfo *wol)
 {
 	struct net_device *attach_dev = phydev->attached_dev;
+	struct gpy_priv *priv = phydev->priv;
 	int ret;
 
 	if (wol->wolopts & WAKE_MAGIC) {
@@ -640,6 +655,8 @@ static int gpy_set_wol(struct phy_device *phydev,
 		ret = phy_read(phydev, PHY_ISTAT);
 		if (ret < 0)
 			return ret;
+
+		priv->wolopts |= WAKE_MAGIC;
 	} else {
 		/* Disable magic packet matching */
 		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
@@ -647,6 +664,13 @@ static int gpy_set_wol(struct phy_device *phydev,
 					 WOL_EN);
 		if (ret < 0)
 			return ret;
+
+		/* Disable the WOL interrupt */
+		ret = phy_clear_bits(phydev, PHY_IMASK, PHY_IMASK_WOL);
+		if (ret < 0)
+			return ret;
+
+		priv->wolopts &= ~WAKE_MAGIC;
 	}
 
 	if (wol->wolopts & WAKE_PHY) {
@@ -663,9 +687,11 @@ static int gpy_set_wol(struct phy_device *phydev,
 		if (ret & (PHY_IMASK_MASK & ~PHY_IMASK_LSTC))
 			phy_trigger_machine(phydev);
 
+		priv->wolopts |= WAKE_PHY;
 		return 0;
 	}
 
+	priv->wolopts &= ~WAKE_PHY;
 	/* Disable the link state change interrupt */
 	return phy_clear_bits(phydev, PHY_IMASK, PHY_IMASK_LSTC);
 }
@@ -673,18 +699,10 @@ static int gpy_set_wol(struct phy_device *phydev,
 static void gpy_get_wol(struct phy_device *phydev,
 			struct ethtool_wolinfo *wol)
 {
-	int ret;
+	struct gpy_priv *priv = phydev->priv;
 
 	wol->supported = WAKE_MAGIC | WAKE_PHY;
-	wol->wolopts = 0;
-
-	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, VPSPEC2_WOL_CTL);
-	if (ret & WOL_EN)
-		wol->wolopts |= WAKE_MAGIC;
-
-	ret = phy_read(phydev, PHY_IMASK);
-	if (ret & PHY_IMASK_LSTC)
-		wol->wolopts |= WAKE_PHY;
+	wol->wolopts = priv->wolopts;
 }
 
 static int gpy_loopback(struct phy_device *phydev, bool enable)
-- 
2.43.0



