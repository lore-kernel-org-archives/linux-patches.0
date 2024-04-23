Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD42120B3E;
	Tue, 23 Apr 2024 21:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908485; cv=none; b=KzLxx5d5E6UvpR/7eV96uXSI8nCaLHOw+nC4CIIr9OQxwF3diWZlkoGAwLNLstypUNUKm4HVlr6sKT4q/lGf6gzW0GnWSA08EzgmWQPGCTkncrASwugJ4dFC/GfEOGe6ZIbpNjWEPcTgfUBkfCguL2R+8x28N/Cw9D+m256XQgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908485; c=relaxed/simple;
	bh=e9U/p3vzpN6SfYmAunwZYSFZtnG5T8PeH+tdclcncEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVDYM18twKwy7Tg59tdZAponxPKfowve+WLLBIzQLwG2h+aOE5IjKQ2mX/XSLlF9em9pycglSFC/EjIZpun7HcltzSVMu+g5XCsidUEOZl+st9BWWbZKgAdZ+KlaJ1/Ru0cycpy9H7Zhc/mCJ5shCa/dvIur34KrPJcJAwSbbTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKtP/5En; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKtP/5En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8210AC32783;
	Tue, 23 Apr 2024 21:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908485;
	bh=e9U/p3vzpN6SfYmAunwZYSFZtnG5T8PeH+tdclcncEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKtP/5EntVf5nPEfylF/pziFQOf0mQ0uPvXteM3VaSB3NkJhkOX4F0Lilj9/nxgjr
	 VhmE+IH9ZFkEGRurJ3eeACtJfYHD/4a8c0jMHsDH+39WU5IBFWXgkcR2PTKuebar7o
	 C+5/8yYi4KmHHHUPn/kEta8qfj4Q0oMO+BuXjE8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 034/158] net: stmmac: Apply half-duplex-less constraint for DW QoS Eth only
Date: Tue, 23 Apr 2024 14:37:36 -0700
Message-ID: <20240423213857.004554182@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit 0ebd96f5da4410c0cb8fc75e44f1009530b2f90b ]

There are three DW MAC IP-cores which can have the multiple Tx/Rx queues
enabled:
DW GMAC v3.7+ with AV feature,
DW QoS Eth v4.x/v5.x,
DW XGMAC/XLGMAC
Based on the respective HW databooks, only the DW QoS Eth IP-core doesn't
support the half-duplex link mode in case if more than one queues enabled:

"In multiple queue/channel configurations, for half-duplex operation,
enable only the Q0/CH0 on Tx and Rx. For single queue/channel in
full-duplex operation, any queue/channel can be enabled."

The rest of the IP-cores don't have such constraint. Thus in order to have
the constraint applied for the DW QoS Eth MACs only, let's move the it'
implementation to the respective MAC-capabilities getter and make sure the
getter is called in the queues re-init procedure.

Fixes: b6cfffa7ad92 ("stmmac: fix DMA channel hang in half-duplex mode")
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Romain Gantois <romain.gantois@bootlin.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  7 +++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 19 +++----------------
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index cef25efbdff99..ec6a13e644b36 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -71,6 +71,13 @@ static void dwmac4_core_init(struct mac_device_info *hw,
 static void dwmac4_phylink_get_caps(struct stmmac_priv *priv)
 {
 	priv->phylink_config.mac_capabilities |= MAC_2500FD;
+
+	if (priv->plat->tx_queues_to_use > 1)
+		priv->phylink_config.mac_capabilities &=
+			~(MAC_10HD | MAC_100HD | MAC_1000HD);
+	else
+		priv->phylink_config.mac_capabilities |=
+			(MAC_10HD | MAC_100HD | MAC_1000HD);
 }
 
 static void dwmac4_rx_queue_enable(struct mac_device_info *hw,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7c6aef033a456..cbb00ca23a7c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1198,17 +1198,6 @@ static int stmmac_init_phy(struct net_device *dev)
 	return ret;
 }
 
-static void stmmac_set_half_duplex(struct stmmac_priv *priv)
-{
-	/* Half-Duplex can only work with single tx queue */
-	if (priv->plat->tx_queues_to_use > 1)
-		priv->phylink_config.mac_capabilities &=
-			~(MAC_10HD | MAC_100HD | MAC_1000HD);
-	else
-		priv->phylink_config.mac_capabilities |=
-			(MAC_10HD | MAC_100HD | MAC_1000HD);
-}
-
 static int stmmac_phy_setup(struct stmmac_priv *priv)
 {
 	struct stmmac_mdio_bus_data *mdio_bus_data;
@@ -1237,10 +1226,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 				    priv->phylink_config.supported_interfaces);
 
 	priv->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
-						MAC_10FD | MAC_100FD |
-						MAC_1000FD;
-
-	stmmac_set_half_duplex(priv);
+						MAC_10 | MAC_100 | MAC_1000;
 
 	/* Get the MAC specific capabilities */
 	stmmac_mac_phylink_get_caps(priv);
@@ -7299,7 +7285,8 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 			priv->rss.table[i] = ethtool_rxfh_indir_default(i,
 									rx_cnt);
 
-	stmmac_set_half_duplex(priv);
+	stmmac_mac_phylink_get_caps(priv);
+
 	stmmac_napi_add(dev);
 
 	if (netif_running(dev))
-- 
2.43.0



