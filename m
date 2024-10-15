Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609AE1E764B;
	Tue, 15 Oct 2024 11:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993025; cv=none; b=IVWHDOkYNHS55pnZ+Tc5W57P9DItLPzKrOreTCw4IAA/aRxnVkhy7xI8IJZ0MhK/9QP2zm+zbbHvs07gCS4+/FETwbRl5cT2dqcWsVNkeJ0lLi8yw7Gu08Hpfitp1uyxfA7P7OzG+zxQXdY5AUJ4x3vTqAGAFmhpT73mCG2dHHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993025; c=relaxed/simple;
	bh=dwEkE+GoxqM/3WIyD06G7hcdKQPDngWxXaXv21YJkPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar+T8T2bigqCiAV0oFLm3F/JlG6ZqzAxE1+0mDL2fssDVkRfep47drqpiOuDNmwIMKBdMolYhkxMd5TnwxplSrUsYNI4RgAd6jIaNAH25XhWtVUki1GgQnAptu9lotx9Di8uCtjfuEKJDEXymNkReJJBwPYN9VMz4ZNMyNuuzXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfBCfZlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfBCfZlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC63C4CEC6;
	Tue, 15 Oct 2024 11:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993025;
	bh=dwEkE+GoxqM/3WIyD06G7hcdKQPDngWxXaXv21YJkPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfBCfZlPv+W8YT1fArt3aOVWVGGRR9R3Gr4Z3TmeIDybbJfbOdfPuMvbgaQN1Q9FJ
	 kHfsaCla2RFg7fBMupLXkWl2PHCNCX1vVBcL4Cf5D7PExGSdnG6I/FY1JRW4w+Jdxe
	 i9/5zDa0GlzO/HjVFs5wOaTSoyojXkKJLVkEOhoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/691] net: axienet: Switch to 64-bit RX/TX statistics
Date: Tue, 15 Oct 2024 13:23:57 +0200
Message-ID: <20241015112451.816333128@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit cb45a8bf4693965e89d115cd2c510f12bc127c37 ]

The RX and TX byte/packet statistics in this driver could be overflowed
relatively quickly on a 32-bit platform. Switch these stats to use the
u64_stats infrastructure to avoid this.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220829233901.3429419-1-robert.hancock@calian.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5a6caa2cfabb ("net: xilinx: axienet: Fix packet counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  | 12 ++++++
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 37 +++++++++++++++++--
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 7bf6b3def460f..54087ce1c07cd 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -402,6 +402,9 @@ struct axidma_bd {
  * @rx_bd_num:	Size of RX buffer descriptor ring
  * @rx_bd_ci:	Stores the index of the Rx buffer descriptor in the ring being
  *		accessed currently.
+ * @rx_packets: RX packet count for statistics
+ * @rx_bytes:	RX byte count for statistics
+ * @rx_stat_sync: Synchronization object for RX stats
  * @napi_tx:	NAPI TX control structure
  * @tx_dma_cr:  Nominal content of TX DMA control register
  * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
@@ -411,6 +414,9 @@ struct axidma_bd {
  *		complete. Only updated at runtime by TX NAPI poll.
  * @tx_bd_tail:	Stores the index of the next Tx buffer descriptor in the ring
  *              to be populated.
+ * @tx_packets: TX packet count for statistics
+ * @tx_bytes:	TX byte count for statistics
+ * @tx_stat_sync: Synchronization object for TX stats
  * @dma_err_task: Work structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
@@ -459,6 +465,9 @@ struct axienet_local {
 	dma_addr_t rx_bd_p;
 	u32 rx_bd_num;
 	u32 rx_bd_ci;
+	u64_stats_t rx_packets;
+	u64_stats_t rx_bytes;
+	struct u64_stats_sync rx_stat_sync;
 
 	struct napi_struct napi_tx;
 	u32 tx_dma_cr;
@@ -467,6 +476,9 @@ struct axienet_local {
 	u32 tx_bd_num;
 	u32 tx_bd_ci;
 	u32 tx_bd_tail;
+	u64_stats_t tx_packets;
+	u64_stats_t tx_bytes;
+	struct u64_stats_sync tx_stat_sync;
 
 	struct work_struct dma_err_task;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 356ae4139d262..9805b81bd490a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -777,8 +777,10 @@ static int axienet_tx_poll(struct napi_struct *napi, int budget)
 		if (lp->tx_bd_ci >= lp->tx_bd_num)
 			lp->tx_bd_ci %= lp->tx_bd_num;
 
-		ndev->stats.tx_packets += packets;
-		ndev->stats.tx_bytes += size;
+		u64_stats_update_begin(&lp->tx_stat_sync);
+		u64_stats_add(&lp->tx_packets, packets);
+		u64_stats_add(&lp->tx_bytes, size);
+		u64_stats_update_end(&lp->tx_stat_sync);
 
 		/* Matches barrier in axienet_start_xmit */
 		smp_mb();
@@ -1009,8 +1011,10 @@ static int axienet_rx_poll(struct napi_struct *napi, int budget)
 		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 	}
 
-	lp->ndev->stats.rx_packets += packets;
-	lp->ndev->stats.rx_bytes += size;
+	u64_stats_update_begin(&lp->rx_stat_sync);
+	u64_stats_add(&lp->rx_packets, packets);
+	u64_stats_add(&lp->rx_bytes, size);
+	u64_stats_update_end(&lp->rx_stat_sync);
 
 	if (tail_p)
 		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
@@ -1317,10 +1321,32 @@ static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	return phylink_mii_ioctl(lp->phylink, rq, cmd);
 }
 
+static void
+axienet_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
+{
+	struct axienet_local *lp = netdev_priv(dev);
+	unsigned int start;
+
+	netdev_stats_to_stats64(stats, &dev->stats);
+
+	do {
+		start = u64_stats_fetch_begin_irq(&lp->rx_stat_sync);
+		stats->rx_packets = u64_stats_read(&lp->rx_packets);
+		stats->rx_bytes = u64_stats_read(&lp->rx_bytes);
+	} while (u64_stats_fetch_retry_irq(&lp->rx_stat_sync, start));
+
+	do {
+		start = u64_stats_fetch_begin_irq(&lp->tx_stat_sync);
+		stats->tx_packets = u64_stats_read(&lp->tx_packets);
+		stats->tx_bytes = u64_stats_read(&lp->tx_bytes);
+	} while (u64_stats_fetch_retry_irq(&lp->tx_stat_sync, start));
+}
+
 static const struct net_device_ops axienet_netdev_ops = {
 	.ndo_open = axienet_open,
 	.ndo_stop = axienet_stop,
 	.ndo_start_xmit = axienet_start_xmit,
+	.ndo_get_stats64 = axienet_get_stats64,
 	.ndo_change_mtu	= axienet_change_mtu,
 	.ndo_set_mac_address = netdev_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
@@ -1932,6 +1958,9 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
+	u64_stats_init(&lp->rx_stat_sync);
+	u64_stats_init(&lp->tx_stat_sync);
+
 	netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll, NAPI_POLL_WEIGHT);
 	netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll, NAPI_POLL_WEIGHT);
 
-- 
2.43.0



