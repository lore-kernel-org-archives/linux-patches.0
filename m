Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E042F8EB5;
	Sat, 30 May 2026 16:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159238; cv=none; b=fblk6BbQd9o/WAOBCaUP4l5RVd2TerUKeQgtHzxDl6Xyvg8H2XuDhnK751GXGcKHjEgXMyI3VMIDjwVAo5cPkSU395aiLG1xgpR4qkxuwcVZgbz8JxkK9DGet9lJ66G2bMpyM87/P4B6j+BBiwtRTyOp0vGwHn6kTYLSUTs1Xvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159238; c=relaxed/simple;
	bh=fcN116/G3648b16ILvnjcB/M+amZRbw71cX+w2LaI/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYAddp4gvkay1OQewxQGz2CkpfjssCwFigqFyTS/HbLznR9/F44q1Qk0vhiehFOce/uoR5IncQO2hiD6aLGrG1cn15f5zKmKqF+hZoU6esezbgR5xNeHE2twEBTT4VJt3nT2M5TYV23iJ4KrfJ47q7aOXFc92KoeoZRUiMXSC4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oF3707r4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oF3707r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E60A1F00893;
	Sat, 30 May 2026 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159237;
	bh=VY6cWUKIwpqcLG1VxgIV/jtsnrAj9c8hCCxZTdloJA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oF3707r41ntW6/SKyZ4WM0sA5TVPXLVzdyQD2rhnL+qYMrWB9KtOrZvWpYj47AzxC
	 1j65zAPSBYKYshO/q5xhXL7M4XmkkZ88LtcY8fEs9rN6gU6/ESClhqfKBe1AFclDXn
	 WS/l3Epmtq34kvTqztEFOkk1iVWlcy4Oy82RMnmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/969] Revert "net: ixp4xx_eth: convert to ndo_hwtstamp_get() and ndo_hwtstamp_set()"
Date: Sat, 30 May 2026 17:53:55 +0200
Message-ID: <20260530160303.378764110@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit a94d5447f6bf827bc29be2520ca636685bbc29e6.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 61 +++++++++++++-----------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index a5e03e66cfd38..3b0c5f177447b 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -386,20 +386,16 @@ static void ixp_tx_timestamp(struct port *port, struct sk_buff *skb)
 	__raw_writel(TX_SNAPSHOT_LOCKED, &regs->channel[ch].ch_event);
 }
 
-static int ixp4xx_hwtstamp_set(struct net_device *netdev,
-			       struct kernel_hwtstamp_config *cfg,
-			       struct netlink_ext_ack *extack)
+static int hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
 {
+	struct hwtstamp_config cfg;
 	struct ixp46x_ts_regs *regs;
 	struct port *port = netdev_priv(netdev);
 	int ret;
 	int ch;
 
-	if (!cpu_is_ixp46x())
-		return -EOPNOTSUPP;
-
-	if (!netif_running(netdev))
-		return -EINVAL;
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
 
 	ret = ixp46x_ptp_find(&port->timesync_regs, &port->phc_index);
 	if (ret)
@@ -408,10 +404,10 @@ static int ixp4xx_hwtstamp_set(struct net_device *netdev,
 	ch = PORT2CHANNEL(port);
 	regs = port->timesync_regs;
 
-	if (cfg->tx_type != HWTSTAMP_TX_OFF && cfg->tx_type != HWTSTAMP_TX_ON)
+	if (cfg.tx_type != HWTSTAMP_TX_OFF && cfg.tx_type != HWTSTAMP_TX_ON)
 		return -ERANGE;
 
-	switch (cfg->rx_filter) {
+	switch (cfg.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
 		port->hwts_rx_en = 0;
 		break;
@@ -427,45 +423,39 @@ static int ixp4xx_hwtstamp_set(struct net_device *netdev,
 		return -ERANGE;
 	}
 
-	port->hwts_tx_en = cfg->tx_type == HWTSTAMP_TX_ON;
+	port->hwts_tx_en = cfg.tx_type == HWTSTAMP_TX_ON;
 
 	/* Clear out any old time stamps. */
 	__raw_writel(TX_SNAPSHOT_LOCKED | RX_SNAPSHOT_LOCKED,
 		     &regs->channel[ch].ch_event);
 
-	return 0;
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
 }
 
-static int ixp4xx_hwtstamp_get(struct net_device *netdev,
-			       struct kernel_hwtstamp_config *cfg)
+static int hwtstamp_get(struct net_device *netdev, struct ifreq *ifr)
 {
+	struct hwtstamp_config cfg;
 	struct port *port = netdev_priv(netdev);
 
-	if (!cpu_is_ixp46x())
-		return -EOPNOTSUPP;
-
-	if (!netif_running(netdev))
-		return -EINVAL;
-
-	cfg->flags = 0;
-	cfg->tx_type = port->hwts_tx_en ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
+	cfg.flags = 0;
+	cfg.tx_type = port->hwts_tx_en ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
 
 	switch (port->hwts_rx_en) {
 	case 0:
-		cfg->rx_filter = HWTSTAMP_FILTER_NONE;
+		cfg.rx_filter = HWTSTAMP_FILTER_NONE;
 		break;
 	case PTP_SLAVE_MODE:
-		cfg->rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_SYNC;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_SYNC;
 		break;
 	case PTP_MASTER_MODE:
-		cfg->rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ;
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		return -ERANGE;
 	}
 
-	return 0;
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
 }
 
 static int ixp4xx_mdio_cmd(struct mii_bus *bus, int phy_id, int location,
@@ -987,6 +977,21 @@ static void eth_set_mcast_list(struct net_device *dev)
 }
 
 
+static int eth_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
+{
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	if (cpu_is_ixp46x()) {
+		if (cmd == SIOCSHWTSTAMP)
+			return hwtstamp_set(dev, req);
+		if (cmd == SIOCGHWTSTAMP)
+			return hwtstamp_get(dev, req);
+	}
+
+	return phy_mii_ioctl(dev->phydev, req, cmd);
+}
+
 /* ethtool support */
 
 static void ixp4xx_get_drvinfo(struct net_device *dev,
@@ -1371,11 +1376,9 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 	.ndo_stop = eth_close,
 	.ndo_start_xmit = eth_xmit,
 	.ndo_set_rx_mode = eth_set_mcast_list,
-	.ndo_eth_ioctl = phy_do_ioctl_running,
+	.ndo_eth_ioctl = eth_ioctl,
 	.ndo_set_mac_address = eth_mac_addr,
 	.ndo_validate_addr = eth_validate_addr,
-	.ndo_hwtstamp_get = ixp4xx_hwtstamp_get,
-	.ndo_hwtstamp_set = ixp4xx_hwtstamp_set,
 };
 
 static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
-- 
2.53.0



