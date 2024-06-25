Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D043613C90B;
	Tue, 25 Jun 2024 09:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308450; cv=none; b=FHnjAB+utgKtcaayvr7icbEE1c2WQgM1u1v1i6Qjzw7LkBHTPStbIgs+0Wu7ZsHUbvf1Ul98KdeQGp0Ne5aNaMj4Kg5sYrho3fWXqZCglAMDQmvlyso5ldw3bj2PLTOsUNPZh+xNHSvEAZWHgB9FgBvPushfZ/Im2TBcQJ2BaGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308450; c=relaxed/simple;
	bh=owkS7UeNGZPc8NrpAduaa2yLsmcaT+JBwYHCuiymt8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9hg1G5NfnwXrtGhgRvFVMasD4s1PO7K1JZR2zyaoxMxesIYdk2GTHJLsiNeT/cW7Y2+I6gMZrArlajOz+om5dy/r1ggMkUSzBhPSXkOGK3e+Tt2Qlj/fHcAIuoFZ7B1D49/epw4Zde75Dg+5LgzkgAt3Z4Rc2O8VGy8nHF1JCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwBGr4zF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwBGr4zF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55025C32781;
	Tue, 25 Jun 2024 09:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308450;
	bh=owkS7UeNGZPc8NrpAduaa2yLsmcaT+JBwYHCuiymt8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwBGr4zF6EvgkMCnCEpBkC4xRrN9eEG+RWVxjdVXn18DS1chz+U3plfs8WYWXADM5
	 Neelzk7Cl1xEejfg/e0DhBWoxATxcMW9IDFpFn6nJA9kcSkW747hrBF9LZitdsMwOt
	 yLynxKGyl0m5y+q/Qn9ehZUKa7ijwk0fUZIe1RPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 124/250] net: lan743x: Support WOL at both the PHY and MAC appropriately
Date: Tue, 25 Jun 2024 11:31:22 +0200
Message-ID: <20240625085552.826834736@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

[ Upstream commit 8c248cd836014339498486f14f435c0e344183a7 ]

Prevent options not supported by the PHY from being requested to it by the MAC
Whenever a WOL option is supported by both, the PHY is given priority
since that usually leads to better power savings.

Fixes: e9e13b6adc33 ("lan743x: fix for potential NULL pointer dereference with bare card")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/lan743x_ethtool.c  | 44 +++++++++++++++++--
 drivers/net/ethernet/microchip/lan743x_main.c | 18 ++++++--
 drivers/net/ethernet/microchip/lan743x_main.h |  4 ++
 3 files changed, 58 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index 8a6ae171e375b..def932035cba4 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -1148,8 +1148,12 @@ static void lan743x_ethtool_get_wol(struct net_device *netdev,
 	if (netdev->phydev)
 		phy_ethtool_get_wol(netdev->phydev, wol);
 
-	wol->supported |= WAKE_BCAST | WAKE_UCAST | WAKE_MCAST |
-		WAKE_MAGIC | WAKE_PHY | WAKE_ARP;
+	if (wol->supported != adapter->phy_wol_supported)
+		netif_warn(adapter, drv, adapter->netdev,
+			   "PHY changed its supported WOL! old=%x, new=%x\n",
+			   adapter->phy_wol_supported, wol->supported);
+
+	wol->supported |= MAC_SUPPORTED_WAKES;
 
 	if (adapter->is_pci11x1x)
 		wol->supported |= WAKE_MAGICSECURE;
@@ -1164,7 +1168,39 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 
+	/* WAKE_MAGICSEGURE is a modifier of and only valid together with
+	 * WAKE_MAGIC
+	 */
+	if ((wol->wolopts & WAKE_MAGICSECURE) && !(wol->wolopts & WAKE_MAGIC))
+		return -EINVAL;
+
+	if (netdev->phydev) {
+		struct ethtool_wolinfo phy_wol;
+		int ret;
+
+		phy_wol.wolopts = wol->wolopts & adapter->phy_wol_supported;
+
+		/* If WAKE_MAGICSECURE was requested, filter out WAKE_MAGIC
+		 * for PHYs that do not support WAKE_MAGICSECURE
+		 */
+		if (wol->wolopts & WAKE_MAGICSECURE &&
+		    !(adapter->phy_wol_supported & WAKE_MAGICSECURE))
+			phy_wol.wolopts &= ~WAKE_MAGIC;
+
+		ret = phy_ethtool_set_wol(netdev->phydev, &phy_wol);
+		if (ret && (ret != -EOPNOTSUPP))
+			return ret;
+
+		if (ret == -EOPNOTSUPP)
+			adapter->phy_wolopts = 0;
+		else
+			adapter->phy_wolopts = phy_wol.wolopts;
+	} else {
+		adapter->phy_wolopts = 0;
+	}
+
 	adapter->wolopts = 0;
+	wol->wolopts &= ~adapter->phy_wolopts;
 	if (wol->wolopts & WAKE_UCAST)
 		adapter->wolopts |= WAKE_UCAST;
 	if (wol->wolopts & WAKE_MCAST)
@@ -1185,10 +1221,10 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 		memset(adapter->sopass, 0, sizeof(u8) * SOPASS_MAX);
 	}
 
+	wol->wolopts = adapter->wolopts | adapter->phy_wolopts;
 	device_set_wakeup_enable(&adapter->pdev->dev, (bool)wol->wolopts);
 
-	return netdev->phydev ? phy_ethtool_set_wol(netdev->phydev, wol)
-			: -ENETDOWN;
+	return 0;
 }
 #endif /* CONFIG_PM */
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index b88d99239a183..ecde3582e3dee 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3111,6 +3111,17 @@ static int lan743x_netdev_open(struct net_device *netdev)
 		if (ret)
 			goto close_tx;
 	}
+
+#ifdef CONFIG_PM
+	if (adapter->netdev->phydev) {
+		struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
+
+		phy_ethtool_get_wol(netdev->phydev, &wol);
+		adapter->phy_wol_supported = wol.supported;
+		adapter->phy_wolopts = wol.wolopts;
+	}
+#endif
+
 	return 0;
 
 close_tx:
@@ -3580,10 +3591,9 @@ static void lan743x_pm_set_wol(struct lan743x_adapter *adapter)
 
 	pmtctl |= PMT_CTL_ETH_PHY_D3_COLD_OVR_ | PMT_CTL_ETH_PHY_D3_OVR_;
 
-	if (adapter->wolopts & WAKE_PHY) {
-		pmtctl |= PMT_CTL_ETH_PHY_EDPD_PLL_CTL_;
+	if (adapter->phy_wolopts)
 		pmtctl |= PMT_CTL_ETH_PHY_WAKE_EN_;
-	}
+
 	if (adapter->wolopts & WAKE_MAGIC) {
 		wucsr |= MAC_WUCSR_MPEN_;
 		macrx |= MAC_RX_RXEN_;
@@ -3679,7 +3689,7 @@ static int lan743x_pm_suspend(struct device *dev)
 	lan743x_csr_write(adapter, MAC_WUCSR2, 0);
 	lan743x_csr_write(adapter, MAC_WK_SRC, 0xFFFFFFFF);
 
-	if (adapter->wolopts)
+	if (adapter->wolopts || adapter->phy_wolopts)
 		lan743x_pm_set_wol(adapter);
 
 	if (adapter->is_pci11x1x) {
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index fac0f33d10b2e..3b2585a384e2c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -1042,6 +1042,8 @@ enum lan743x_sgmii_lsd {
 	LINK_2500_SLAVE
 };
 
+#define MAC_SUPPORTED_WAKES  (WAKE_BCAST | WAKE_UCAST | WAKE_MCAST | \
+			      WAKE_MAGIC | WAKE_ARP)
 struct lan743x_adapter {
 	struct net_device       *netdev;
 	struct mii_bus		*mdiobus;
@@ -1049,6 +1051,8 @@ struct lan743x_adapter {
 #ifdef CONFIG_PM
 	u32			wolopts;
 	u8			sopass[SOPASS_MAX];
+	u32			phy_wolopts;
+	u32			phy_wol_supported;
 #endif
 	struct pci_dev		*pdev;
 	struct lan743x_csr      csr;
-- 
2.43.0



