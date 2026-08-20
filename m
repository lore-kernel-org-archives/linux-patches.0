Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA76E47D92E;
	Thu, 20 Aug 2026 16:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244647; cv=none; b=rbukQQ6l0XQ8JUZrX0ENLCfF8RN9INaLHafWOmdJyIDyEUI9Cc/HdYdUlguvQLfxbAETpGD2kPDbnTCDyCd8Wtk+RzSwo0c+f7Vt/2Q52AnfRnpfAM3v7WxzjQA2za+jPqf28HLx/gALD7tOEhPeROM95JJw1dVTHdym12Bz1/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244647; c=relaxed/simple;
	bh=TD9/SlmOGriB3ohLZpvSVzliBwp9NWuGpF5+YdwX9mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9s4PhryZ4ze/Qb+yPglN4S1OvXtyto4eSttqcYMpTykVHxT/byyGZ6x6pp51bCosdTLhvuBpq4SDREgayduMg0nd7p+r0EMfAofOeCRqgB/vc32HS5IOXsQESTVD6vDO6Mc+l9FZDh7GsnWgqoVWu/GunK0jMmY7ywul3IABek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvnWpgRG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvnWpgRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DFF1F000E9;
	Thu, 20 Aug 2026 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244645;
	bh=hkf974DkRZPPJBkVCIa0P/Mn6sMvjU0I4Znc4IV2pTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvnWpgRGpqs1RW7yXMEoYMJtwJP63X9gi0B5PfxAKOs2rA8xWXQNJigYZFb1xy2R9
	 WbtsNGG6UOtShZsAySNMAggYphw/FWwAht2SsldyXTLeknbt51UBASsBA4NHx67rn2
	 2sblQcuLOvaNURm02x7cA3znd0ctv2ZH8urTERRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/235] net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode
Date: Thu, 20 Aug 2026 16:57:43 +0200
Message-ID: <20260820145223.502519258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 84b4aa4932490c9f88f13d8f3b3cd1f3b6116991 ]

This patch adds final multi-port support to TI AM65x CPSW driver path in
preparation for adding support for multi-port devices, like Main CPSW0 on
K3 J721E SoC or future CPSW3g on K3 AM64x SoC.
- the separate netdev is created for every enabled external Port;
- DMA channels are common/shared for all external Ports and the RX/TX NAPI
and DMA processing assigned to first available netdev;
- external Ports are configured in mac-only mode, which is similar to TI
"dual-mac" mode for legacy TI CPSW - packets are sent to the Host port only
in ingress and directly to the Port on egress. No packet switching between
external ports happens.
- every port supports the same features as current AM65x CPSW on external
device.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 36a05d282007 ("net: ethernet: ti: am65-cpsw-nuss: Fix port_id extraction from SRC TAG")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 129 ++++++++++++++---------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |   1 +
 2 files changed, 82 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 0b228205d08c6..3fb87601b329c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -270,8 +270,8 @@ static int am65_cpsw_nuss_ndo_slave_kill_vid(struct net_device *ndev,
 	return ret;
 }
 
-static void am65_cpsw_slave_set_promisc_2g(struct am65_cpsw_port *port,
-					   bool promisc)
+static void am65_cpsw_slave_set_promisc(struct am65_cpsw_port *port,
+					bool promisc)
 {
 	struct am65_cpsw_common *common = port->common;
 
@@ -296,7 +296,7 @@ static void am65_cpsw_nuss_ndo_slave_set_rx_mode(struct net_device *ndev)
 	bool promisc;
 
 	promisc = !!(ndev->flags & IFF_PROMISC);
-	am65_cpsw_slave_set_promisc_2g(port, promisc);
+	am65_cpsw_slave_set_promisc(port, promisc);
 
 	if (promisc)
 		return;
@@ -627,13 +627,13 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 
 	am65_cpsw_port_set_sl_mac(port, ndev->dev_addr);
 
-	if (port->slave.mac_only)
+	if (port->slave.mac_only) {
 		/* enable mac-only mode on port */
 		cpsw_ale_control_set(common->ale, port->port_id,
 				     ALE_PORT_MACONLY, 1);
-	if (AM65_CPSW_IS_CPSW2G(common))
 		cpsw_ale_control_set(common->ale, port->port_id,
 				     ALE_PORT_NOLEARN, 1);
+	}
 
 	port_mask = BIT(port->port_id) | ALE_PORT_HOST;
 	cpsw_ale_add_ucast(common->ale, ndev->dev_addr,
@@ -1367,7 +1367,7 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
-static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
+static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_open		= am65_cpsw_nuss_ndo_slave_open,
 	.ndo_stop		= am65_cpsw_nuss_ndo_slave_stop,
 	.ndo_start_xmit		= am65_cpsw_nuss_ndo_slave_xmit,
@@ -1389,7 +1389,6 @@ static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
 	if (!port->disabled)
 		return;
 
-	common->disabled_ports_mask |= BIT(port->port_id);
 	cpsw_ale_control_set(common->ale, port->port_id,
 			     ALE_PORT_STATE, ALE_PORT_STATE_DISABLE);
 
@@ -1754,8 +1753,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		}
 
 		port->disabled = !of_device_is_available(port_np);
-		if (port->disabled)
+		if (port->disabled) {
+			common->disabled_ports_mask |= BIT(port->port_id);
 			continue;
+		}
 
 		port->slave.ifphy = devm_of_phy_get(dev, port_np, NULL);
 		if (IS_ERR(port->slave.ifphy)) {
@@ -1810,6 +1811,12 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 	}
 	of_node_put(node);
 
+	/* is there at least one ext.port */
+	if (!(~common->disabled_ports_mask & GENMASK(common->port_num, 1))) {
+		dev_err(dev, "No Ext. port are available\n");
+		return -ENODEV;
+	}
+
 	return 0;
 
 of_node_put:
@@ -1825,14 +1832,18 @@ static void am65_cpsw_pcpu_stats_free(void *data)
 	free_percpu(stats);
 }
 
-static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
+static int
+am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 {
 	struct am65_cpsw_ndev_priv *ndev_priv;
 	struct device *dev = common->dev;
 	struct am65_cpsw_port *port;
 	int ret;
 
-	port = am65_common_get_port(common, 1);
+	port = &common->ports[port_idx];
+
+	if (port->disabled)
+		return 0;
 
 	/* alloc netdev */
 	port->ndev = devm_alloc_etherdev_mqs(common->dev,
@@ -1862,7 +1873,7 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 	port->ndev->features = port->ndev->hw_features |
 			       NETIF_F_HW_VLAN_CTAG_FILTER;
 	port->ndev->vlan_features |=  NETIF_F_SG;
-	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops_2g;
+	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
 	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
 
 	/* Disable TX checksum offload by default due to HW bug */
@@ -1875,29 +1886,41 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 
 	ret = devm_add_action_or_reset(dev, am65_cpsw_pcpu_stats_free,
 				       ndev_priv->stats);
-	if (ret) {
-		dev_err(dev, "Failed to add percpu stat free action %d\n", ret);
-		return ret;
+	if (ret)
+		dev_err(dev, "failed to add percpu stat free action %d\n", ret);
+
+	if (!common->dma_ndev)
+		common->dma_ndev = port->ndev;
+
+	return ret;
+}
+
+static int am65_cpsw_nuss_init_ndevs(struct am65_cpsw_common *common)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < common->port_num; i++) {
+		ret = am65_cpsw_nuss_init_port_ndev(common, i);
+		if (ret)
+			return ret;
 	}
 
-	netif_napi_add(port->ndev, &common->napi_rx,
+	netif_napi_add(common->dma_ndev, &common->napi_rx,
 		       am65_cpsw_nuss_rx_poll, NAPI_POLL_WEIGHT);
 
 	return ret;
 }
 
-static int am65_cpsw_nuss_ndev_add_napi_2g(struct am65_cpsw_common *common)
+static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
-	struct am65_cpsw_port *port;
 	int i, ret = 0;
 
-	port = am65_common_get_port(common, 1);
-
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		netif_tx_napi_add(port->ndev, &tx_chn->napi_tx,
+		netif_tx_napi_add(common->dma_ndev, &tx_chn->napi_tx,
 				  am65_cpsw_nuss_tx_poll, NAPI_POLL_WEIGHT);
 
 		ret = devm_request_irq(dev, tx_chn->irq,
@@ -1915,16 +1938,27 @@ static int am65_cpsw_nuss_ndev_add_napi_2g(struct am65_cpsw_common *common)
 	return ret;
 }
 
-static int am65_cpsw_nuss_ndev_reg_2g(struct am65_cpsw_common *common)
+static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_port *port;
+	int i;
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+		if (port->ndev)
+			unregister_netdev(port->ndev);
+	}
+}
+
+static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
 	struct am65_cpsw_port *port;
-	int ret = 0;
+	int ret = 0, i;
 
-	port = am65_common_get_port(common, 1);
-	ret = am65_cpsw_nuss_ndev_add_napi_2g(common);
+	ret = am65_cpsw_nuss_ndev_add_tx_napi(common);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = devm_request_irq(dev, common->rx_chns.irq,
 			       am65_cpsw_nuss_rx_irq,
@@ -1932,17 +1966,31 @@ static int am65_cpsw_nuss_ndev_reg_2g(struct am65_cpsw_common *common)
 	if (ret) {
 		dev_err(dev, "failure requesting rx irq %u, %d\n",
 			common->rx_chns.irq, ret);
-		goto err;
+		return ret;
+	}
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+
+		if (!port->ndev)
+			continue;
+
+		ret = register_netdev(port->ndev);
+		if (ret) {
+			dev_err(dev, "error registering slave net device%i %d\n",
+				i, ret);
+			goto err_cleanup_ndev;
+		}
 	}
 
-	ret = register_netdev(port->ndev);
-	if (ret)
-		dev_err(dev, "error registering slave net device %d\n", ret);
 
 	/* can't auto unregister ndev using devm_add_action() due to
 	 * devres release sequence in DD core for DMA
 	 */
-err:
+	return 0;
+
+err_cleanup_ndev:
+	am65_cpsw_nuss_cleanup_ndev(common);
 	return ret;
 }
 
@@ -1955,19 +2003,7 @@ int am65_cpsw_nuss_update_tx_chns(struct am65_cpsw_common *common, int num_tx)
 	if (ret)
 		return ret;
 
-	return am65_cpsw_nuss_ndev_add_napi_2g(common);
-}
-
-static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
-{
-	struct am65_cpsw_port *port;
-	int i;
-
-	for (i = 0; i < common->port_num; i++) {
-		port = &common->ports[i];
-		if (port->ndev)
-			unregister_netdev(port->ndev);
-	}
+	return am65_cpsw_nuss_ndev_add_tx_napi(common);
 }
 
 struct am65_cpsw_soc_pdata {
@@ -2055,9 +2091,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	if (common->port_num < 1 || common->port_num > AM65_CPSW_MAX_PORTS)
 		return -ENOENT;
 
-	if (common->port_num != 1)
-		return -EOPNOTSUPP;
-
 	common->rx_flow_id_base = -1;
 	init_completion(&common->tdown_complete);
 	common->tx_ch_num = 1;
@@ -2147,11 +2180,11 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, common);
 
-	ret = am65_cpsw_nuss_init_ndev_2g(common);
+	ret = am65_cpsw_nuss_init_ndevs(common);
 	if (ret)
 		goto err_of_clear;
 
-	ret = am65_cpsw_nuss_ndev_reg_2g(common);
+	ret = am65_cpsw_nuss_register_ndevs(common);
 	if (ret)
 		goto err_of_clear;
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index b6f228ddc3a09..b5da51bfecd85 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -94,6 +94,7 @@ struct am65_cpsw_common {
 	struct am65_cpsw_host   host;
 	struct am65_cpsw_port	*ports;
 	u32			disabled_ports_mask;
+	struct net_device	*dma_ndev;
 
 	int			usage_count; /* number of opened ports */
 	struct cpsw_ale		*ale;
-- 
2.53.0



