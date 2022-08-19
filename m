Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0914A27
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70104C433C1
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660933042;
	bh=rcvcgJ1D9Xc9H0CggQlO4fJfPZ8hWx6ZxDvyAge8AgA=;
	h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
	b=a99cYt9ebbfBZft5TV26DDqAty9u98lPRqkK5D0HgpIBnW7nECVyquauBkIbn87Fl
	 H9FpAqpnNUuBzlLx9xX6K9DURA/p877jArvMhK8ocZKW2INRehaHRpW5uymUqVb9CC
	 Em4hAfEI6dN5AxhEltHQGC60rZdIpGjUxhAFdM4PhBoRx7TVgMIEzX+3yl5ij4i3jF
	 qHfHw4+G77IuBHDJwerErJe0vSOqR+G18eW3d2nOy1hksELlOYcmc0g96KGPSeHrgY
	 NKYlxLwSGpWIPx9RepAy7Em8U2vUN9WFNfE0hN26kMxIVbH/Jf4WIVfi07kasvg7+A
	 /GBeluPjFRjhw==
From: Konstantin Ryabitsev via B4 Web Endpoint <devnull@kernel.org>
Date: Fri, 19 Aug 2022 14:17:23 -0400
Subject: [PATCH v1 9/9] u64_stat: Remove the obsolete fetch_irq() variants
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-9-2d7c68bdbbdc@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=87242;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=wWkst9kWdo8BDbZPIpLA2l6kY3W9vBKpoqt9Q7wvJgM=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X143vZyL74611oPWWYq/E7jvBK4vclyUbeInstc11/X2
 kTqHjlIWBjEuBlkxRZayfbGbggofesil95jCzGFlAhnCwMUpABMpaGdkaKx+7y09xyD33uWUbRv3iD
 Hr5wbKPp82KUGh8bAfz2uJVIZ/9lkPf53WT3CRNosxWyp2wyDitXat/6Ifpip5vR2zhP8wAAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Original-From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reply-To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

From: Thomas Gleixner <tglx@linutronix.de>

Now that the 32bit UP oddity is gone and 32bit uses always a sequence
count, there is no need for the fetch_irq() variants anymore.

Convert all callers to the regular interface and delete the obsolete
interfaces.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/drivers/net/ethernet/alacritech/slic.h b/drivers/net/ethernet/alacritech/slic.h
index 4eecbdfff3ff..82071d0e5f7f 100644
--- a/drivers/net/ethernet/alacritech/slic.h
+++ b/drivers/net/ethernet/alacritech/slic.h
@@ -288,13 +288,13 @@ do {						\
 	u64_stats_update_end(&(st)->syncp);	\
 } while (0)
 
-#define SLIC_GET_STATS_COUNTER(newst, st, counter)			\
-{									\
-	unsigned int start;						\
+#define SLIC_GET_STATS_COUNTER(newst, st, counter)		\
+{								\
+	unsigned int start;					\
 	do {							\
-		start = u64_stats_fetch_begin_irq(&(st)->syncp);	\
-		newst = (st)->counter;					\
-	} while (u64_stats_fetch_retry_irq(&(st)->syncp, start));	\
+		start = u64_stats_fetch_begin(&(st)->syncp);	\
+		newst = (st)->counter;				\
+	} while (u64_stats_fetch_retry(&(st)->syncp, start));	\
 }
 
 struct slic_upr {
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 39242c5a1729..8f81d288c488 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -118,9 +118,9 @@ static void ena_safe_update_stat(u64 *src, u64 *dst,
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin_irq(syncp);
+		start = u64_stats_fetch_begin(syncp);
 		*(dst) = *src;
-	} while (u64_stats_fetch_retry_irq(syncp, start));
+	} while (u64_stats_fetch_retry(syncp, start));
 }
 
 static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6a356a6cee15..1c5d48299080 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3270,10 +3270,10 @@ static void ena_get_stats64(struct net_device *netdev,
 		tx_ring = &adapter->tx_ring[i];
 
 		do {
-			start = u64_stats_fetch_begin_irq(&tx_ring->syncp);
+			start = u64_stats_fetch_begin(&tx_ring->syncp);
 			packets = tx_ring->tx_stats.cnt;
 			bytes = tx_ring->tx_stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_ring->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_ring->syncp, start));
 
 		stats->tx_packets += packets;
 		stats->tx_bytes += bytes;
@@ -3281,20 +3281,20 @@ static void ena_get_stats64(struct net_device *netdev,
 		rx_ring = &adapter->rx_ring[i];
 
 		do {
-			start = u64_stats_fetch_begin_irq(&rx_ring->syncp);
+			start = u64_stats_fetch_begin(&rx_ring->syncp);
 			packets = rx_ring->rx_stats.cnt;
 			bytes = rx_ring->rx_stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&rx_ring->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_ring->syncp, start));
 
 		stats->rx_packets += packets;
 		stats->rx_bytes += bytes;
 	}
 
 	do {
-		start = u64_stats_fetch_begin_irq(&adapter->syncp);
+		start = u64_stats_fetch_begin(&adapter->syncp);
 		rx_drops = adapter->dev_stats.rx_drops;
 		tx_drops = adapter->dev_stats.tx_drops;
-	} while (u64_stats_fetch_retry_irq(&adapter->syncp, start));
+	} while (u64_stats_fetch_retry(&adapter->syncp, start));
 
 	stats->rx_dropped = rx_drops;
 	stats->tx_dropped = tx_drops;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 25129e723b57..1e8d902e1c8e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -934,7 +934,7 @@ unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data)
 		/* This data should mimic aq_ethtool_queue_rx_stat_names structure */
 		do {
 			count = 0;
-			start = u64_stats_fetch_begin_irq(&self->stats.rx.syncp);
+			start = u64_stats_fetch_begin(&self->stats.rx.syncp);
 			data[count] = self->stats.rx.packets;
 			data[++count] = self->stats.rx.jumbo_packets;
 			data[++count] = self->stats.rx.lro_packets;
@@ -951,15 +951,15 @@ unsigned int aq_ring_fill_stats_data(struct aq_ring_s *self, u64 *data)
 			data[++count] = self->stats.rx.xdp_tx;
 			data[++count] = self->stats.rx.xdp_invalid;
 			data[++count] = self->stats.rx.xdp_redirect;
-		} while (u64_stats_fetch_retry_irq(&self->stats.rx.syncp, start));
+		} while (u64_stats_fetch_retry(&self->stats.rx.syncp, start));
 	} else {
 		/* This data should mimic aq_ethtool_queue_tx_stat_names structure */
 		do {
 			count = 0;
-			start = u64_stats_fetch_begin_irq(&self->stats.tx.syncp);
+			start = u64_stats_fetch_begin(&self->stats.tx.syncp);
 			data[count] = self->stats.tx.packets;
 			data[++count] = self->stats.tx.queue_restarts;
-		} while (u64_stats_fetch_retry_irq(&self->stats.tx.syncp, start));
+		} while (u64_stats_fetch_retry(&self->stats.tx.syncp, start));
 	}
 
 	return ++count;
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 6ba5b024a7be..25e7beb68e51 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -662,12 +662,12 @@ static void ax88796c_get_stats64(struct net_device *ndev,
 		s = per_cpu_ptr(ax_local->stats, cpu);
 
 		do {
-			start = u64_stats_fetch_begin_irq(&s->syncp);
+			start = u64_stats_fetch_begin(&s->syncp);
 			rx_packets = u64_stats_read(&s->rx_packets);
 			rx_bytes   = u64_stats_read(&s->rx_bytes);
 			tx_packets = u64_stats_read(&s->tx_packets);
 			tx_bytes   = u64_stats_read(&s->tx_bytes);
-		} while (u64_stats_fetch_retry_irq(&s->syncp, start));
+		} while (u64_stats_fetch_retry(&s->syncp, start));
 
 		stats->rx_packets += rx_packets;
 		stats->rx_bytes   += rx_bytes;
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index e5857e88c207..caf1714f36a1 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1680,7 +1680,7 @@ static void b44_get_stats64(struct net_device *dev,
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&hwstat->syncp);
+		start = u64_stats_fetch_begin(&hwstat->syncp);
 
 		/* Convert HW stats into rtnl_link_stats64 stats. */
 		nstat->rx_packets = hwstat->rx_pkts;
@@ -1714,7 +1714,7 @@ static void b44_get_stats64(struct net_device *dev,
 		/* Carrier lost counter seems to be broken for some devices */
 		nstat->tx_carrier_errors = hwstat->tx_carrier_lost;
 #endif
-	} while (u64_stats_fetch_retry_irq(&hwstat->syncp, start));
+	} while (u64_stats_fetch_retry(&hwstat->syncp, start));
 
 }
 
@@ -2082,12 +2082,12 @@ static void b44_get_ethtool_stats(struct net_device *dev,
 	do {
 		data_src = &hwstat->tx_good_octets;
 		data_dst = data;
-		start = u64_stats_fetch_begin_irq(&hwstat->syncp);
+		start = u64_stats_fetch_begin(&hwstat->syncp);
 
 		for (i = 0; i < ARRAY_SIZE(b44_gstrings); i++)
 			*data_dst++ = *data_src++;
 
-	} while (u64_stats_fetch_retry_irq(&hwstat->syncp, start));
+	} while (u64_stats_fetch_retry(&hwstat->syncp, start));
 }
 
 static void b44_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 47fc8e6963d5..98d5bd15ee43 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -457,10 +457,10 @@ static void bcm_sysport_update_tx_stats(struct bcm_sysport_priv *priv,
 	for (q = 0; q < priv->netdev->num_tx_queues; q++) {
 		ring = &priv->tx_rings[q];
 		do {
-			start = u64_stats_fetch_begin_irq(&priv->syncp);
+			start = u64_stats_fetch_begin(&priv->syncp);
 			bytes = ring->bytes;
 			packets = ring->packets;
-		} while (u64_stats_fetch_retry_irq(&priv->syncp, start));
+		} while (u64_stats_fetch_retry(&priv->syncp, start));
 
 		*tx_bytes += bytes;
 		*tx_packets += packets;
@@ -504,9 +504,9 @@ static void bcm_sysport_get_stats(struct net_device *dev,
 		if (s->stat_sizeof == sizeof(u64) &&
 		    s->type == BCM_SYSPORT_STAT_NETDEV64) {
 			do {
-				start = u64_stats_fetch_begin_irq(syncp);
+				start = u64_stats_fetch_begin(syncp);
 				data[i] = *(u64 *)p;
-			} while (u64_stats_fetch_retry_irq(syncp, start));
+			} while (u64_stats_fetch_retry(syncp, start));
 		} else
 			data[i] = *(u32 *)p;
 		j++;
@@ -1878,10 +1878,10 @@ static void bcm_sysport_get_stats64(struct net_device *dev,
 				    &stats->tx_packets);
 
 	do {
-		start = u64_stats_fetch_begin_irq(&priv->syncp);
+		start = u64_stats_fetch_begin(&priv->syncp);
 		stats->rx_packets = stats64->rx_packets;
 		stats->rx_bytes = stats64->rx_bytes;
-	} while (u64_stats_fetch_retry_irq(&priv->syncp, start));
+	} while (u64_stats_fetch_retry(&priv->syncp, start));
 }
 
 static void bcm_sysport_netif_start(struct net_device *dev)
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index bd0df189d871..39e7a4a3c15e 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -389,10 +389,10 @@ static void be_get_ethtool_stats(struct net_device *netdev,
 		struct be_rx_stats *stats = rx_stats(rxo);
 
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->sync);
+			start = u64_stats_fetch_begin(&stats->sync);
 			data[base] = stats->rx_bytes;
 			data[base + 1] = stats->rx_pkts;
-		} while (u64_stats_fetch_retry_irq(&stats->sync, start));
+		} while (u64_stats_fetch_retry(&stats->sync, start));
 
 		for (i = 2; i < ETHTOOL_RXSTATS_NUM; i++) {
 			p = (u8 *)stats + et_rx_stats[i].offset;
@@ -405,19 +405,19 @@ static void be_get_ethtool_stats(struct net_device *netdev,
 		struct be_tx_stats *stats = tx_stats(txo);
 
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->sync_compl);
+			start = u64_stats_fetch_begin(&stats->sync_compl);
 			data[base] = stats->tx_compl;
-		} while (u64_stats_fetch_retry_irq(&stats->sync_compl, start));
+		} while (u64_stats_fetch_retry(&stats->sync_compl, start));
 
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->sync);
+			start = u64_stats_fetch_begin(&stats->sync);
 			for (i = 1; i < ETHTOOL_TXSTATS_NUM; i++) {
 				p = (u8 *)stats + et_tx_stats[i].offset;
 				data[base + i] =
 					(et_tx_stats[i].size == sizeof(u64)) ?
 						*(u64 *)p : *(u32 *)p;
 			}
-		} while (u64_stats_fetch_retry_irq(&stats->sync, start));
+		} while (u64_stats_fetch_retry(&stats->sync, start));
 		base += ETHTOOL_TXSTATS_NUM;
 	}
 }
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 414362febbb9..9350c901aa27 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -665,10 +665,10 @@ static void be_get_stats64(struct net_device *netdev,
 		const struct be_rx_stats *rx_stats = rx_stats(rxo);
 
 		do {
-			start = u64_stats_fetch_begin_irq(&rx_stats->sync);
+			start = u64_stats_fetch_begin(&rx_stats->sync);
 			pkts = rx_stats(rxo)->rx_pkts;
 			bytes = rx_stats(rxo)->rx_bytes;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->sync, start));
+		} while (u64_stats_fetch_retry(&rx_stats->sync, start));
 		stats->rx_packets += pkts;
 		stats->rx_bytes += bytes;
 		stats->multicast += rx_stats(rxo)->rx_mcast_pkts;
@@ -680,10 +680,10 @@ static void be_get_stats64(struct net_device *netdev,
 		const struct be_tx_stats *tx_stats = tx_stats(txo);
 
 		do {
-			start = u64_stats_fetch_begin_irq(&tx_stats->sync);
+			start = u64_stats_fetch_begin(&tx_stats->sync);
 			pkts = tx_stats(txo)->tx_pkts;
 			bytes = tx_stats(txo)->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->sync, start));
+		} while (u64_stats_fetch_retry(&tx_stats->sync, start));
 		stats->tx_packets += pkts;
 		stats->tx_bytes += bytes;
 	}
@@ -2155,16 +2155,16 @@ static int be_get_new_eqd(struct be_eq_obj *eqo)
 
 	for_all_rx_queues_on_eq(adapter, eqo, rxo, i) {
 		do {
-			start = u64_stats_fetch_begin_irq(&rxo->stats.sync);
+			start = u64_stats_fetch_begin(&rxo->stats.sync);
 			rx_pkts += rxo->stats.rx_pkts;
-		} while (u64_stats_fetch_retry_irq(&rxo->stats.sync, start));
+		} while (u64_stats_fetch_retry(&rxo->stats.sync, start));
 	}
 
 	for_all_tx_queues_on_eq(adapter, eqo, txo, i) {
 		do {
-			start = u64_stats_fetch_begin_irq(&txo->stats.sync);
+			start = u64_stats_fetch_begin(&txo->stats.sync);
 			tx_pkts += txo->stats.tx_reqs;
-		} while (u64_stats_fetch_retry_irq(&txo->stats.sync, start));
+		} while (u64_stats_fetch_retry(&txo->stats.sync, start));
 	}
 
 	/* Skip, if wrapped around or first calculation */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 35d70041b9e8..f82e98263307 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2486,7 +2486,7 @@ static void hns3_fetch_stats(struct rtnl_link_stats64 *stats,
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&ring->syncp);
+		start = u64_stats_fetch_begin(&ring->syncp);
 		if (is_tx) {
 			stats->tx_bytes += ring->stats.tx_bytes;
 			stats->tx_packets += ring->stats.tx_pkts;
@@ -2520,7 +2520,7 @@ static void hns3_fetch_stats(struct rtnl_link_stats64 *stats,
 			stats->multicast += ring->stats.rx_multicast;
 			stats->rx_length_errors += ring->stats.err_pkt_len;
 		}
-	} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+	} while (u64_stats_fetch_retry(&ring->syncp, start));
 }
 
 static void hns3_nic_get_stats64(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 2cca9e84e31e..34ab5ff9823b 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1229,10 +1229,10 @@ static void fm10k_get_stats64(struct net_device *netdev,
 			continue;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			start = u64_stats_fetch_begin(&ring->syncp);
 			packets = ring->stats.packets;
 			bytes   = ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 
 		stats->rx_packets += packets;
 		stats->rx_bytes   += bytes;
@@ -1245,10 +1245,10 @@ static void fm10k_get_stats64(struct net_device *netdev,
 			continue;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			start = u64_stats_fetch_begin(&ring->syncp);
 			packets = ring->stats.packets;
 			bytes   = ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 
 		stats->tx_packets += packets;
 		stats->tx_bytes   += bytes;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 156e92c43780..8dbd86465165 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -154,7 +154,7 @@ __i40e_add_ethtool_stats(u64 **data, void *pointer,
  * @ring: the ring to copy
  *
  * Queue statistics must be copied while protected by
- * u64_stats_fetch_begin_irq, so we can't directly use i40e_add_ethtool_stats.
+ * u64_stats_fetch_begin, so we can't directly use i40e_add_ethtool_stats.
  * Assumes that queue stats are defined in i40e_gstrings_queue_stats. If the
  * ring pointer is null, zero out the queue stat values and update the data
  * pointer. Otherwise safely copy the stats from the ring into the supplied
@@ -172,16 +172,16 @@ i40e_add_queue_stats(u64 **data, struct i40e_ring *ring)
 
 	/* To avoid invalid statistics values, ensure that we keep retrying
 	 * the copy until we get a consistent value according to
-	 * u64_stats_fetch_retry_irq. But first, make sure our ring is
+	 * u64_stats_fetch_retry. But first, make sure our ring is
 	 * non-null before attempting to access its syncp.
 	 */
 	do {
-		start = !ring ? 0 : u64_stats_fetch_begin_irq(&ring->syncp);
+		start = !ring ? 0 : u64_stats_fetch_begin(&ring->syncp);
 		for (i = 0; i < size; i++) {
 			i40e_add_one_ethtool_stat(&(*data)[i], ring,
 						  &stats[i]);
 		}
-	} while (ring && u64_stats_fetch_retry_irq(&ring->syncp, start));
+	} while (ring && u64_stats_fetch_retry(&ring->syncp, start));
 
 	/* Once we successfully copy the stats in, update the data pointer */
 	*data += size;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b36bf9c3e1e4..c5ba822ddb33 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -416,10 +416,10 @@ static void i40e_get_netdev_stats_struct_tx(struct i40e_ring *ring,
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&ring->syncp);
+		start = u64_stats_fetch_begin(&ring->syncp);
 		packets = ring->stats.packets;
 		bytes   = ring->stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+	} while (u64_stats_fetch_retry(&ring->syncp, start));
 
 	stats->tx_packets += packets;
 	stats->tx_bytes   += bytes;
@@ -469,10 +469,10 @@ static void i40e_get_netdev_stats_struct(struct net_device *netdev,
 		if (!ring)
 			continue;
 		do {
-			start   = u64_stats_fetch_begin_irq(&ring->syncp);
+			start   = u64_stats_fetch_begin(&ring->syncp);
 			packets = ring->stats.packets;
 			bytes   = ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 
 		stats->rx_packets += packets;
 		stats->rx_bytes   += bytes;
@@ -894,10 +894,10 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 			continue;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&p->syncp);
+			start = u64_stats_fetch_begin(&p->syncp);
 			packets = p->stats.packets;
 			bytes = p->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
 		tx_b += bytes;
 		tx_p += packets;
 		tx_restart += p->tx_stats.restart_queue;
@@ -912,10 +912,10 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 			continue;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&p->syncp);
+			start = u64_stats_fetch_begin(&p->syncp);
 			packets = p->stats.packets;
 			bytes = p->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
 		rx_b += bytes;
 		rx_p += packets;
 		rx_buf += p->rx_stats.alloc_buff_failed;
@@ -932,10 +932,10 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 				continue;
 
 			do {
-				start = u64_stats_fetch_begin_irq(&p->syncp);
+				start = u64_stats_fetch_begin(&p->syncp);
 				packets = p->stats.packets;
 				bytes = p->stats.bytes;
-			} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+			} while (u64_stats_fetch_retry(&p->syncp, start));
 			tx_b += bytes;
 			tx_p += packets;
 			tx_restart += p->tx_stats.restart_queue;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index e535d4c3da49..fafa3406e0bc 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -147,7 +147,7 @@ __iavf_add_ethtool_stats(u64 **data, void *pointer,
  * @ring: the ring to copy
  *
  * Queue statistics must be copied while protected by
- * u64_stats_fetch_begin_irq, so we can't directly use iavf_add_ethtool_stats.
+ * u64_stats_fetch_begin, so we can't directly use iavf_add_ethtool_stats.
  * Assumes that queue stats are defined in iavf_gstrings_queue_stats. If the
  * ring pointer is null, zero out the queue stat values and update the data
  * pointer. Otherwise safely copy the stats from the ring into the supplied
@@ -165,14 +165,14 @@ iavf_add_queue_stats(u64 **data, struct iavf_ring *ring)
 
 	/* To avoid invalid statistics values, ensure that we keep retrying
 	 * the copy until we get a consistent value according to
-	 * u64_stats_fetch_retry_irq. But first, make sure our ring is
+	 * u64_stats_fetch_retry. But first, make sure our ring is
 	 * non-null before attempting to access its syncp.
 	 */
 	do {
-		start = !ring ? 0 : u64_stats_fetch_begin_irq(&ring->syncp);
+		start = !ring ? 0 : u64_stats_fetch_begin(&ring->syncp);
 		for (i = 0; i < size; i++)
 			iavf_add_one_ethtool_stat(&(*data)[i], ring, &stats[i]);
-	} while (ring && u64_stats_fetch_retry_irq(&ring->syncp, start));
+	} while (ring && u64_stats_fetch_retry(&ring->syncp, start));
 
 	/* Once we successfully copy the stats in, update the data pointer */
 	*data += size;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index eb40526ee179..20caf14b06be 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6270,10 +6270,10 @@ ice_fetch_u64_stats_per_ring(struct u64_stats_sync *syncp,
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin_irq(syncp);
+		start = u64_stats_fetch_begin(syncp);
 		*pkts = stats.pkts;
 		*bytes = stats.bytes;
-	} while (u64_stats_fetch_retry_irq(syncp, start));
+	} while (u64_stats_fetch_retry(syncp, start));
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index c14fc871dd41..23c6fcfcb905 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2311,15 +2311,15 @@ static void igb_get_ethtool_stats(struct net_device *netdev,
 
 		ring = adapter->tx_ring[j];
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->tx_syncp);
+			start = u64_stats_fetch_begin(&ring->tx_syncp);
 			data[i]   = ring->tx_stats.packets;
 			data[i+1] = ring->tx_stats.bytes;
 			data[i+2] = ring->tx_stats.restart_queue;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp, start));
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->tx_syncp2);
+			start = u64_stats_fetch_begin(&ring->tx_syncp2);
 			restart2  = ring->tx_stats.restart_queue2;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp2, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp2, start));
 		data[i+2] += restart2;
 
 		i += IGB_TX_QUEUE_STATS_LEN;
@@ -2327,13 +2327,13 @@ static void igb_get_ethtool_stats(struct net_device *netdev,
 	for (j = 0; j < adapter->num_rx_queues; j++) {
 		ring = adapter->rx_ring[j];
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->rx_syncp);
+			start = u64_stats_fetch_begin(&ring->rx_syncp);
 			data[i]   = ring->rx_stats.packets;
 			data[i+1] = ring->rx_stats.bytes;
 			data[i+2] = ring->rx_stats.drops;
 			data[i+3] = ring->rx_stats.csum_err;
 			data[i+4] = ring->rx_stats.alloc_failed;
-		} while (u64_stats_fetch_retry_irq(&ring->rx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->rx_syncp, start));
 		i += IGB_RX_QUEUE_STATS_LEN;
 	}
 	spin_unlock(&adapter->stats64_lock);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index d8b836a85cc3..b1985be57acc 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6626,10 +6626,10 @@ void igb_update_stats(struct igb_adapter *adapter)
 		}
 
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->rx_syncp);
+			start = u64_stats_fetch_begin(&ring->rx_syncp);
 			_bytes = ring->rx_stats.bytes;
 			_packets = ring->rx_stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->rx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->rx_syncp, start));
 		bytes += _bytes;
 		packets += _packets;
 	}
@@ -6642,10 +6642,10 @@ void igb_update_stats(struct igb_adapter *adapter)
 	for (i = 0; i < adapter->num_tx_queues; i++) {
 		struct igb_ring *ring = adapter->tx_ring[i];
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->tx_syncp);
+			start = u64_stats_fetch_begin(&ring->tx_syncp);
 			_bytes = ring->tx_stats.bytes;
 			_packets = ring->tx_stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp, start));
 		bytes += _bytes;
 		packets += _packets;
 	}
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 8cc077b712ad..5a26a7805ef8 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -839,15 +839,15 @@ static void igc_ethtool_get_stats(struct net_device *netdev,
 
 		ring = adapter->tx_ring[j];
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->tx_syncp);
+			start = u64_stats_fetch_begin(&ring->tx_syncp);
 			data[i]   = ring->tx_stats.packets;
 			data[i + 1] = ring->tx_stats.bytes;
 			data[i + 2] = ring->tx_stats.restart_queue;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp, start));
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->tx_syncp2);
+			start = u64_stats_fetch_begin(&ring->tx_syncp2);
 			restart2  = ring->tx_stats.restart_queue2;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp2, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp2, start));
 		data[i + 2] += restart2;
 
 		i += IGC_TX_QUEUE_STATS_LEN;
@@ -855,13 +855,13 @@ static void igc_ethtool_get_stats(struct net_device *netdev,
 	for (j = 0; j < adapter->num_rx_queues; j++) {
 		ring = adapter->rx_ring[j];
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->rx_syncp);
+			start = u64_stats_fetch_begin(&ring->rx_syncp);
 			data[i]   = ring->rx_stats.packets;
 			data[i + 1] = ring->rx_stats.bytes;
 			data[i + 2] = ring->rx_stats.drops;
 			data[i + 3] = ring->rx_stats.csum_err;
 			data[i + 4] = ring->rx_stats.alloc_failed;
-		} while (u64_stats_fetch_retry_irq(&ring->rx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->rx_syncp, start));
 		i += IGC_RX_QUEUE_STATS_LEN;
 	}
 	spin_unlock(&adapter->stats64_lock);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ebff0e04045d..944299b06cc3 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4645,10 +4645,10 @@ void igc_update_stats(struct igc_adapter *adapter)
 		}
 
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->rx_syncp);
+			start = u64_stats_fetch_begin(&ring->rx_syncp);
 			_bytes = ring->rx_stats.bytes;
 			_packets = ring->rx_stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->rx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->rx_syncp, start));
 		bytes += _bytes;
 		packets += _packets;
 	}
@@ -4662,10 +4662,10 @@ void igc_update_stats(struct igc_adapter *adapter)
 		struct igc_ring *ring = adapter->tx_ring[i];
 
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->tx_syncp);
+			start = u64_stats_fetch_begin(&ring->tx_syncp);
 			_bytes = ring->tx_stats.bytes;
 			_packets = ring->tx_stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->tx_syncp, start));
+		} while (u64_stats_fetch_retry(&ring->tx_syncp, start));
 		bytes += _bytes;
 		packets += _packets;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 04f453eabef6..51bcf0df3adc 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1335,10 +1335,10 @@ static void ixgbe_get_ethtool_stats(struct net_device *netdev,
 		}
 
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			start = u64_stats_fetch_begin(&ring->syncp);
 			data[i]   = ring->stats.packets;
 			data[i+1] = ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		i += 2;
 	}
 	for (j = 0; j < IXGBE_NUM_RX_QUEUES; j++) {
@@ -1351,10 +1351,10 @@ static void ixgbe_get_ethtool_stats(struct net_device *netdev,
 		}
 
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			start = u64_stats_fetch_begin(&ring->syncp);
 			data[i]   = ring->stats.packets;
 			data[i+1] = ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		i += 2;
 	}
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index d1e430b8c8aa..01c5548f181d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9041,10 +9041,10 @@ static void ixgbe_get_ring_stats64(struct rtnl_link_stats64 *stats,
 
 	if (ring) {
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			start = u64_stats_fetch_begin(&ring->syncp);
 			packets = ring->stats.packets;
 			bytes   = ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		stats->tx_packets += packets;
 		stats->tx_bytes   += bytes;
 	}
@@ -9064,10 +9064,10 @@ static void ixgbe_get_stats64(struct net_device *netdev,
 
 		if (ring) {
 			do {
-				start = u64_stats_fetch_begin_irq(&ring->syncp);
+				start = u64_stats_fetch_begin(&ring->syncp);
 				packets = ring->stats.packets;
 				bytes   = ring->stats.bytes;
-			} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+			} while (u64_stats_fetch_retry(&ring->syncp, start));
 			stats->rx_packets += packets;
 			stats->rx_bytes   += bytes;
 		}
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index fed46872af2b..b4632b67ab14 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -458,10 +458,10 @@ static void ixgbevf_get_ethtool_stats(struct net_device *netdev,
 		}
 
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			start = u64_stats_fetch_begin(&ring->syncp);
 			data[i]   = ring->stats.packets;
 			data[i + 1] = ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		i += 2;
 	}
 
@@ -475,10 +475,10 @@ static void ixgbevf_get_ethtool_stats(struct net_device *netdev,
 		}
 
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			start = u64_stats_fetch_begin(&ring->syncp);
 			data[i] = ring->stats.packets;
 			data[i + 1] = ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		i += 2;
 	}
 
@@ -492,10 +492,10 @@ static void ixgbevf_get_ethtool_stats(struct net_device *netdev,
 		}
 
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			start = u64_stats_fetch_begin(&ring->syncp);
 			data[i]   = ring->stats.packets;
 			data[i + 1] = ring->stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		i += 2;
 	}
 }
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 2f12fbe229c1..1d31b8cff4f1 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4350,10 +4350,10 @@ static void ixgbevf_get_tx_ring_stats(struct rtnl_link_stats64 *stats,
 
 	if (ring) {
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			start = u64_stats_fetch_begin(&ring->syncp);
 			bytes = ring->stats.bytes;
 			packets = ring->stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		stats->tx_bytes += bytes;
 		stats->tx_packets += packets;
 	}
@@ -4376,10 +4376,10 @@ static void ixgbevf_get_stats(struct net_device *netdev,
 	for (i = 0; i < adapter->num_rx_queues; i++) {
 		ring = adapter->rx_ring[i];
 		do {
-			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			start = u64_stats_fetch_begin(&ring->syncp);
 			bytes = ring->stats.bytes;
 			packets = ring->stats.packets;
-		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		} while (u64_stats_fetch_retry(&ring->syncp, start));
 		stats->rx_bytes += bytes;
 		stats->rx_packets += packets;
 	}
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0caa2df87c04..89ea3ef0ee16 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -813,14 +813,14 @@ mvneta_get_stats64(struct net_device *dev,
 
 		cpu_stats = per_cpu_ptr(pp->stats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			rx_packets = cpu_stats->es.ps.rx_packets;
 			rx_bytes   = cpu_stats->es.ps.rx_bytes;
 			rx_dropped = cpu_stats->rx_dropped;
 			rx_errors  = cpu_stats->rx_errors;
 			tx_packets = cpu_stats->es.ps.tx_packets;
 			tx_bytes   = cpu_stats->es.ps.tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		stats->rx_packets += rx_packets;
 		stats->rx_bytes   += rx_bytes;
@@ -4762,7 +4762,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 
 		stats = per_cpu_ptr(pp->stats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			start = u64_stats_fetch_begin(&stats->syncp);
 			skb_alloc_error = stats->es.skb_alloc_error;
 			refill_error = stats->es.refill_error;
 			xdp_redirect = stats->es.ps.xdp_redirect;
@@ -4772,7 +4772,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 			xdp_xmit_err = stats->es.ps.xdp_xmit_err;
 			xdp_tx = stats->es.ps.xdp_tx;
 			xdp_tx_err = stats->es.ps.xdp_tx_err;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 		es->skb_alloc_error += skb_alloc_error;
 		es->refill_error += refill_error;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b84128b549b4..cdeea98e0b8c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2008,7 +2008,7 @@ mvpp2_get_xdp_stats(struct mvpp2_port *port, struct mvpp2_pcpu_stats *xdp_stats)
 
 		cpu_stats = per_cpu_ptr(port->stats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			xdp_redirect = cpu_stats->xdp_redirect;
 			xdp_pass   = cpu_stats->xdp_pass;
 			xdp_drop = cpu_stats->xdp_drop;
@@ -2016,7 +2016,7 @@ mvpp2_get_xdp_stats(struct mvpp2_port *port, struct mvpp2_pcpu_stats *xdp_stats)
 			xdp_xmit_err   = cpu_stats->xdp_xmit_err;
 			xdp_tx   = cpu_stats->xdp_tx;
 			xdp_tx_err   = cpu_stats->xdp_tx_err;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		xdp_stats->xdp_redirect += xdp_redirect;
 		xdp_stats->xdp_pass   += xdp_pass;
@@ -5115,12 +5115,12 @@ mvpp2_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 
 		cpu_stats = per_cpu_ptr(port->stats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			rx_packets = cpu_stats->rx_packets;
 			rx_bytes   = cpu_stats->rx_bytes;
 			tx_packets = cpu_stats->tx_packets;
 			tx_bytes   = cpu_stats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		stats->rx_packets += rx_packets;
 		stats->rx_bytes   += rx_bytes;
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index bbea5458000b..c9bb92187719 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -3894,19 +3894,19 @@ static void sky2_get_stats(struct net_device *dev,
 	u64 _bytes, _packets;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&sky2->rx_stats.syncp);
+		start = u64_stats_fetch_begin(&sky2->rx_stats.syncp);
 		_bytes = sky2->rx_stats.bytes;
 		_packets = sky2->rx_stats.packets;
-	} while (u64_stats_fetch_retry_irq(&sky2->rx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&sky2->rx_stats.syncp, start));
 
 	stats->rx_packets = _packets;
 	stats->rx_bytes = _bytes;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&sky2->tx_stats.syncp);
+		start = u64_stats_fetch_begin(&sky2->tx_stats.syncp);
 		_bytes = sky2->tx_stats.bytes;
 		_packets = sky2->tx_stats.packets;
-	} while (u64_stats_fetch_retry_irq(&sky2->tx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&sky2->tx_stats.syncp, start));
 
 	stats->tx_packets = _packets;
 	stats->tx_bytes = _bytes;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d9426b01f462..72ed53e79533 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -853,7 +853,7 @@ static void mtk_get_stats64(struct net_device *dev,
 	}
 
 	do {
-		start = u64_stats_fetch_begin_irq(&hw_stats->syncp);
+		start = u64_stats_fetch_begin(&hw_stats->syncp);
 		storage->rx_packets = hw_stats->rx_packets;
 		storage->tx_packets = hw_stats->tx_packets;
 		storage->rx_bytes = hw_stats->rx_bytes;
@@ -865,7 +865,7 @@ static void mtk_get_stats64(struct net_device *dev,
 		storage->rx_crc_errors = hw_stats->rx_fcs_errors;
 		storage->rx_errors = hw_stats->rx_checksum_errors;
 		storage->tx_aborted_errors = hw_stats->tx_skip;
-	} while (u64_stats_fetch_retry_irq(&hw_stats->syncp, start));
+	} while (u64_stats_fetch_retry(&hw_stats->syncp, start));
 
 	storage->tx_errors = dev->stats.tx_errors;
 	storage->rx_dropped = dev->stats.rx_dropped;
@@ -3662,13 +3662,13 @@ static void mtk_get_ethtool_stats(struct net_device *dev,
 
 	do {
 		data_dst = data;
-		start = u64_stats_fetch_begin_irq(&hwstats->syncp);
+		start = u64_stats_fetch_begin(&hwstats->syncp);
 
 		for (i = 0; i < ARRAY_SIZE(mtk_ethtool_stats); i++)
 			*data_dst++ = *(data_src + mtk_ethtool_stats[i].offset);
 		if (mtk_page_pool_enabled(mac->hw))
 			mtk_ethtool_pp_stats(mac->hw, data_dst);
-	} while (u64_stats_fetch_retry_irq(&hwstats->syncp, start));
+	} while (u64_stats_fetch_retry(&hwstats->syncp, start));
 }
 
 static int mtk_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1e240cdd9cbd..4a6116914882 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -827,12 +827,12 @@ mlxsw_sp_port_get_sw_stats64(const struct net_device *dev,
 	for_each_possible_cpu(i) {
 		p = per_cpu_ptr(mlxsw_sp_port->pcpu_stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&p->syncp);
+			start = u64_stats_fetch_begin(&p->syncp);
 			rx_packets	= p->rx_packets;
 			rx_bytes	= p->rx_bytes;
 			tx_packets	= p->tx_packets;
 			tx_bytes	= p->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
 
 		stats->rx_packets	+= rx_packets;
 		stats->rx_bytes		+= rx_bytes;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 9259a74eca40..318dbbb48279 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -315,10 +315,10 @@ static void mana_get_stats64(struct net_device *ndev,
 		rx_stats = &apc->rxqs[q]->stats;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start = u64_stats_fetch_begin(&rx_stats->syncp);
 			packets = rx_stats->packets;
 			bytes = rx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
 
 		st->rx_packets += packets;
 		st->rx_bytes += bytes;
@@ -328,10 +328,10 @@ static void mana_get_stats64(struct net_device *ndev,
 		tx_stats = &apc->tx_qp[q].txq.stats;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start = u64_stats_fetch_begin(&tx_stats->syncp);
 			packets = tx_stats->packets;
 			bytes = tx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
 
 		st->tx_packets += packets;
 		st->tx_bytes += bytes;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index c530db76880f..96d55c91c969 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -90,13 +90,13 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 		rx_stats = &apc->rxqs[q]->stats;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start = u64_stats_fetch_begin(&rx_stats->syncp);
 			packets = rx_stats->packets;
 			bytes = rx_stats->bytes;
 			xdp_drop = rx_stats->xdp_drop;
 			xdp_tx = rx_stats->xdp_tx;
 			xdp_redirect = rx_stats->xdp_redirect;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
 
 		data[i++] = packets;
 		data[i++] = bytes;
@@ -109,11 +109,11 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 		tx_stats = &apc->tx_qp[q].txq.stats;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start = u64_stats_fetch_begin(&tx_stats->syncp);
 			packets = tx_stats->packets;
 			bytes = tx_stats->bytes;
 			xdp_xmit = tx_stats->xdp_xmit;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
 
 		data[i++] = packets;
 		data[i++] = bytes;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 8b77582bdfa0..a6b6ca1fd55e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -134,13 +134,13 @@ nfp_repr_get_host_stats64(const struct net_device *netdev,
 
 		repr_stats = per_cpu_ptr(repr->stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&repr_stats->syncp);
+			start = u64_stats_fetch_begin(&repr_stats->syncp);
 			tbytes = repr_stats->tx_bytes;
 			tpkts = repr_stats->tx_packets;
 			tdrops = repr_stats->tx_drops;
 			rbytes = repr_stats->rx_bytes;
 			rpkts = repr_stats->rx_packets;
-		} while (u64_stats_fetch_retry_irq(&repr_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&repr_stats->syncp, start));
 
 		stats->tx_bytes += tbytes;
 		stats->tx_packets += tpkts;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 5116badaf091..50ebbd7e91c4 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1734,12 +1734,12 @@ static void nv_get_stats(int cpu, struct fe_priv *np,
 	u64 tx_packets, tx_bytes, tx_dropped;
 
 	do {
-		syncp_start = u64_stats_fetch_begin_irq(&np->swstats_rx_syncp);
+		syncp_start = u64_stats_fetch_begin(&np->swstats_rx_syncp);
 		rx_packets       = src->stat_rx_packets;
 		rx_bytes         = src->stat_rx_bytes;
 		rx_dropped       = src->stat_rx_dropped;
 		rx_missed_errors = src->stat_rx_missed_errors;
-	} while (u64_stats_fetch_retry_irq(&np->swstats_rx_syncp, syncp_start));
+	} while (u64_stats_fetch_retry(&np->swstats_rx_syncp, syncp_start));
 
 	storage->rx_packets       += rx_packets;
 	storage->rx_bytes         += rx_bytes;
@@ -1747,11 +1747,11 @@ static void nv_get_stats(int cpu, struct fe_priv *np,
 	storage->rx_missed_errors += rx_missed_errors;
 
 	do {
-		syncp_start = u64_stats_fetch_begin_irq(&np->swstats_tx_syncp);
+		syncp_start = u64_stats_fetch_begin(&np->swstats_tx_syncp);
 		tx_packets  = src->stat_tx_packets;
 		tx_bytes    = src->stat_tx_bytes;
 		tx_dropped  = src->stat_tx_dropped;
-	} while (u64_stats_fetch_retry_irq(&np->swstats_tx_syncp, syncp_start));
+	} while (u64_stats_fetch_retry(&np->swstats_tx_syncp, syncp_start));
 
 	storage->tx_packets += tx_packets;
 	storage->tx_bytes   += tx_bytes;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 1b2119b1d48a..3f5e6572d20e 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -135,9 +135,9 @@ static void rmnet_get_stats64(struct net_device *dev,
 		pcpu_ptr = per_cpu_ptr(priv->pcpu_stats, cpu);
 
 		do {
-			start = u64_stats_fetch_begin_irq(&pcpu_ptr->syncp);
+			start = u64_stats_fetch_begin(&pcpu_ptr->syncp);
 			snapshot = pcpu_ptr->stats;	/* struct assignment */
-		} while (u64_stats_fetch_retry_irq(&pcpu_ptr->syncp, start));
+		} while (u64_stats_fetch_retry(&pcpu_ptr->syncp, start));
 
 		total_stats.rx_pkts += snapshot.rx_pkts;
 		total_stats.rx_bytes += snapshot.rx_bytes;
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 15b40fd93cd2..82bd0eb61463 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -2532,16 +2532,16 @@ rtl8139_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	netdev_stats_to_stats64(stats, &dev->stats);
 
 	do {
-		start = u64_stats_fetch_begin_irq(&tp->rx_stats.syncp);
+		start = u64_stats_fetch_begin(&tp->rx_stats.syncp);
 		stats->rx_packets = tp->rx_stats.packets;
 		stats->rx_bytes = tp->rx_stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&tp->rx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&tp->rx_stats.syncp, start));
 
 	do {
-		start = u64_stats_fetch_begin_irq(&tp->tx_stats.syncp);
+		start = u64_stats_fetch_begin(&tp->tx_stats.syncp);
 		stats->tx_packets = tp->tx_stats.packets;
 		stats->tx_bytes = tp->tx_stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&tp->tx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&tp->tx_stats.syncp, start));
 }
 
 /* Set or clear the multicast filter for this adaptor.
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index f0c8de2c6075..d4f7238333bb 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1506,16 +1506,16 @@ static void ave_get_stats64(struct net_device *ndev,
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&priv->stats_rx.syncp);
+		start = u64_stats_fetch_begin(&priv->stats_rx.syncp);
 		stats->rx_packets = priv->stats_rx.packets;
 		stats->rx_bytes	  = priv->stats_rx.bytes;
-	} while (u64_stats_fetch_retry_irq(&priv->stats_rx.syncp, start));
+	} while (u64_stats_fetch_retry(&priv->stats_rx.syncp, start));
 
 	do {
-		start = u64_stats_fetch_begin_irq(&priv->stats_tx.syncp);
+		start = u64_stats_fetch_begin(&priv->stats_tx.syncp);
 		stats->tx_packets = priv->stats_tx.packets;
 		stats->tx_bytes	  = priv->stats_tx.bytes;
-	} while (u64_stats_fetch_retry_irq(&priv->stats_tx.syncp, start));
+	} while (u64_stats_fetch_retry(&priv->stats_tx.syncp, start));
 
 	stats->rx_errors      = priv->stats_rx.errors;
 	stats->tx_errors      = priv->stats_tx.errors;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index f4a6b590a1e3..1b62400c1904 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1365,12 +1365,12 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
 
 		cpu_stats = per_cpu_ptr(ndev_priv->stats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			rx_packets = cpu_stats->rx_packets;
 			rx_bytes   = cpu_stats->rx_bytes;
 			tx_packets = cpu_stats->tx_packets;
 			tx_bytes   = cpu_stats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		stats->rx_packets += rx_packets;
 		stats->rx_bytes   += rx_bytes;
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index b15d44261e76..68c7b2c05aab 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1916,16 +1916,16 @@ netcp_get_stats(struct net_device *ndev, struct rtnl_link_stats64 *stats)
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&p->syncp_rx);
+		start = u64_stats_fetch_begin(&p->syncp_rx);
 		rxpackets       = p->rx_packets;
 		rxbytes         = p->rx_bytes;
-	} while (u64_stats_fetch_retry_irq(&p->syncp_rx, start));
+	} while (u64_stats_fetch_retry(&p->syncp_rx, start));
 
 	do {
-		start = u64_stats_fetch_begin_irq(&p->syncp_tx);
+		start = u64_stats_fetch_begin(&p->syncp_tx);
 		txpackets       = p->tx_packets;
 		txbytes         = p->tx_bytes;
-	} while (u64_stats_fetch_retry_irq(&p->syncp_tx, start));
+	} while (u64_stats_fetch_retry(&p->syncp_tx, start));
 
 	stats->rx_packets = rxpackets;
 	stats->rx_bytes = rxbytes;
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 509c5e9b29df..5301c907b5ae 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -2217,16 +2217,16 @@ rhine_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	netdev_stats_to_stats64(stats, &dev->stats);
 
 	do {
-		start = u64_stats_fetch_begin_irq(&rp->rx_stats.syncp);
+		start = u64_stats_fetch_begin(&rp->rx_stats.syncp);
 		stats->rx_packets = rp->rx_stats.packets;
 		stats->rx_bytes = rp->rx_stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&rp->rx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&rp->rx_stats.syncp, start));
 
 	do {
-		start = u64_stats_fetch_begin_irq(&rp->tx_stats.syncp);
+		start = u64_stats_fetch_begin(&rp->tx_stats.syncp);
 		stats->tx_packets = rp->tx_stats.packets;
 		stats->tx_bytes = rp->tx_stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&rp->tx_stats.syncp, start));
+	} while (u64_stats_fetch_retry(&rp->tx_stats.syncp, start));
 }
 
 static void rhine_set_rx_mode(struct net_device *dev)
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 15ebd5426604..b68bed8f17da 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1264,12 +1264,12 @@ static void netvsc_get_vf_stats(struct net_device *net,
 		unsigned int start;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			start = u64_stats_fetch_begin(&stats->syncp);
 			rx_packets = stats->rx_packets;
 			tx_packets = stats->tx_packets;
 			rx_bytes = stats->rx_bytes;
 			tx_bytes = stats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 		tot->rx_packets += rx_packets;
 		tot->tx_packets += tx_packets;
@@ -1294,12 +1294,12 @@ static void netvsc_get_pcpu_stats(struct net_device *net,
 		unsigned int start;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			start = u64_stats_fetch_begin(&stats->syncp);
 			this_tot->vf_rx_packets = stats->rx_packets;
 			this_tot->vf_tx_packets = stats->tx_packets;
 			this_tot->vf_rx_bytes = stats->rx_bytes;
 			this_tot->vf_tx_bytes = stats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 		this_tot->rx_packets = this_tot->vf_rx_packets;
 		this_tot->tx_packets = this_tot->vf_tx_packets;
 		this_tot->rx_bytes   = this_tot->vf_rx_bytes;
@@ -1318,20 +1318,20 @@ static void netvsc_get_pcpu_stats(struct net_device *net,
 
 		tx_stats = &nvchan->tx_stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start = u64_stats_fetch_begin(&tx_stats->syncp);
 			packets = tx_stats->packets;
 			bytes = tx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
 
 		this_tot->tx_bytes	+= bytes;
 		this_tot->tx_packets	+= packets;
 
 		rx_stats = &nvchan->rx_stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start = u64_stats_fetch_begin(&rx_stats->syncp);
 			packets = rx_stats->packets;
 			bytes = rx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
 
 		this_tot->rx_bytes	+= bytes;
 		this_tot->rx_packets	+= packets;
@@ -1370,21 +1370,21 @@ static void netvsc_get_stats64(struct net_device *net,
 
 		tx_stats = &nvchan->tx_stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start = u64_stats_fetch_begin(&tx_stats->syncp);
 			packets = tx_stats->packets;
 			bytes = tx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
 
 		t->tx_bytes	+= bytes;
 		t->tx_packets	+= packets;
 
 		rx_stats = &nvchan->rx_stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start = u64_stats_fetch_begin(&rx_stats->syncp);
 			packets = rx_stats->packets;
 			bytes = rx_stats->bytes;
 			multicast = rx_stats->multicast + rx_stats->broadcast;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
 
 		t->rx_bytes	+= bytes;
 		t->rx_packets	+= packets;
@@ -1527,24 +1527,24 @@ static void netvsc_get_ethtool_stats(struct net_device *dev,
 		tx_stats = &nvdev->chan_table[j].tx_stats;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start = u64_stats_fetch_begin(&tx_stats->syncp);
 			packets = tx_stats->packets;
 			bytes = tx_stats->bytes;
 			xdp_xmit = tx_stats->xdp_xmit;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
 		data[i++] = packets;
 		data[i++] = bytes;
 		data[i++] = xdp_xmit;
 
 		rx_stats = &nvdev->chan_table[j].rx_stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start = u64_stats_fetch_begin(&rx_stats->syncp);
 			packets = rx_stats->packets;
 			bytes = rx_stats->bytes;
 			xdp_drop = rx_stats->xdp_drop;
 			xdp_redirect = rx_stats->xdp_redirect;
 			xdp_tx = rx_stats->xdp_tx;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
 		data[i++] = packets;
 		data[i++] = bytes;
 		data[i++] = xdp_drop;
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 1c64d5347b8e..78253ad57b2e 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -162,18 +162,18 @@ static void ifb_stats64(struct net_device *dev,
 
 	for (i = 0; i < dev->num_tx_queues; i++,txp++) {
 		do {
-			start = u64_stats_fetch_begin_irq(&txp->rx_stats.sync);
+			start = u64_stats_fetch_begin(&txp->rx_stats.sync);
 			packets = txp->rx_stats.packets;
 			bytes = txp->rx_stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&txp->rx_stats.sync, start));
+		} while (u64_stats_fetch_retry(&txp->rx_stats.sync, start));
 		stats->rx_packets += packets;
 		stats->rx_bytes += bytes;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&txp->tx_stats.sync);
+			start = u64_stats_fetch_begin(&txp->tx_stats.sync);
 			packets = txp->tx_stats.packets;
 			bytes = txp->tx_stats.bytes;
-		} while (u64_stats_fetch_retry_irq(&txp->tx_stats.sync, start));
+		} while (u64_stats_fetch_retry(&txp->tx_stats.sync, start));
 		stats->tx_packets += packets;
 		stats->tx_bytes += bytes;
 	}
@@ -245,12 +245,12 @@ static void ifb_fill_stats_data(u64 **data,
 	int j;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&q_stats->sync);
+		start = u64_stats_fetch_begin(&q_stats->sync);
 		for (j = 0; j < IFB_Q_STATS_LEN; j++) {
 			offset = ifb_q_stats_desc[j].offset;
 			(*data)[j] = *(u64 *)(stats_base + offset);
 		}
-	} while (u64_stats_fetch_retry_irq(&q_stats->sync, start));
+	} while (u64_stats_fetch_retry(&q_stats->sync, start));
 
 	*data += IFB_Q_STATS_LEN;
 }
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 49ba8a50dfb1..8a58d74638cd 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -299,13 +299,13 @@ static void ipvlan_get_stats64(struct net_device *dev,
 		for_each_possible_cpu(idx) {
 			pcptr = per_cpu_ptr(ipvlan->pcpu_stats, idx);
 			do {
-				strt= u64_stats_fetch_begin_irq(&pcptr->syncp);
+				strt = u64_stats_fetch_begin(&pcptr->syncp);
 				rx_pkts = u64_stats_read(&pcptr->rx_pkts);
 				rx_bytes = u64_stats_read(&pcptr->rx_bytes);
 				rx_mcast = u64_stats_read(&pcptr->rx_mcast);
 				tx_pkts = u64_stats_read(&pcptr->tx_pkts);
 				tx_bytes = u64_stats_read(&pcptr->tx_bytes);
-			} while (u64_stats_fetch_retry_irq(&pcptr->syncp,
+			} while (u64_stats_fetch_retry(&pcptr->syncp,
 							   strt));
 
 			s->rx_packets += rx_pkts;
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 14e8d04cb434..c4ad98d39ea6 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -106,10 +106,10 @@ void dev_lstats_read(struct net_device *dev, u64 *packets, u64 *bytes)
 
 		lb_stats = per_cpu_ptr(dev->lstats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&lb_stats->syncp);
+			start = u64_stats_fetch_begin(&lb_stats->syncp);
 			tpackets = u64_stats_read(&lb_stats->packets);
 			tbytes = u64_stats_read(&lb_stats->bytes);
-		} while (u64_stats_fetch_retry_irq(&lb_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&lb_stats->syncp, start));
 		*bytes   += tbytes;
 		*packets += tpackets;
 	}
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index ee6087e7b2bf..f4fe202b4710 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2828,9 +2828,9 @@ static void get_rx_sc_stats(struct net_device *dev,
 
 		stats = per_cpu_ptr(rx_sc->stats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			start = u64_stats_fetch_begin(&stats->syncp);
 			memcpy(&tmp, &stats->stats, sizeof(tmp));
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 		sum->InOctetsValidated += tmp.InOctetsValidated;
 		sum->InOctetsDecrypted += tmp.InOctetsDecrypted;
@@ -2909,9 +2909,9 @@ static void get_tx_sc_stats(struct net_device *dev,
 
 		stats = per_cpu_ptr(macsec_priv(dev)->secy.tx_sc.stats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			start = u64_stats_fetch_begin(&stats->syncp);
 			memcpy(&tmp, &stats->stats, sizeof(tmp));
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 		sum->OutPktsProtected   += tmp.OutPktsProtected;
 		sum->OutPktsEncrypted   += tmp.OutPktsEncrypted;
@@ -2965,9 +2965,9 @@ static void get_secy_stats(struct net_device *dev, struct macsec_dev_stats *sum)
 
 		stats = per_cpu_ptr(macsec_priv(dev)->stats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			start = u64_stats_fetch_begin(&stats->syncp);
 			memcpy(&tmp, &stats->stats, sizeof(tmp));
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 		sum->OutPktsUntagged  += tmp.OutPktsUntagged;
 		sum->InPktsUntagged   += tmp.InPktsUntagged;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 1080d6ebff63..a1c7823f0ba6 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -948,13 +948,13 @@ static void macvlan_dev_get_stats64(struct net_device *dev,
 		for_each_possible_cpu(i) {
 			p = per_cpu_ptr(vlan->pcpu_stats, i);
 			do {
-				start = u64_stats_fetch_begin_irq(&p->syncp);
+				start = u64_stats_fetch_begin(&p->syncp);
 				rx_packets	= u64_stats_read(&p->rx_packets);
 				rx_bytes	= u64_stats_read(&p->rx_bytes);
 				rx_multicast	= u64_stats_read(&p->rx_multicast);
 				tx_packets	= u64_stats_read(&p->tx_packets);
 				tx_bytes	= u64_stats_read(&p->tx_bytes);
-			} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+			} while (u64_stats_fetch_retry(&p->syncp, start));
 
 			stats->rx_packets	+= rx_packets;
 			stats->rx_bytes		+= rx_bytes;
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 0b1b6f650104..ff302144029d 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -104,19 +104,19 @@ static void mhi_ndo_get_stats64(struct net_device *ndev,
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.rx_syncp);
+		start = u64_stats_fetch_begin(&mhi_netdev->stats.rx_syncp);
 		stats->rx_packets = u64_stats_read(&mhi_netdev->stats.rx_packets);
 		stats->rx_bytes = u64_stats_read(&mhi_netdev->stats.rx_bytes);
 		stats->rx_errors = u64_stats_read(&mhi_netdev->stats.rx_errors);
-	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.rx_syncp, start));
+	} while (u64_stats_fetch_retry(&mhi_netdev->stats.rx_syncp, start));
 
 	do {
-		start = u64_stats_fetch_begin_irq(&mhi_netdev->stats.tx_syncp);
+		start = u64_stats_fetch_begin(&mhi_netdev->stats.tx_syncp);
 		stats->tx_packets = u64_stats_read(&mhi_netdev->stats.tx_packets);
 		stats->tx_bytes = u64_stats_read(&mhi_netdev->stats.tx_bytes);
 		stats->tx_errors = u64_stats_read(&mhi_netdev->stats.tx_errors);
 		stats->tx_dropped = u64_stats_read(&mhi_netdev->stats.tx_dropped);
-	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.tx_syncp, start));
+	} while (u64_stats_fetch_retry(&mhi_netdev->stats.tx_syncp, start));
 }
 
 static const struct net_device_ops mhi_netdev_ops = {
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index aac133a1e27a..d42bd3970177 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1853,13 +1853,13 @@ team_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	for_each_possible_cpu(i) {
 		p = per_cpu_ptr(team->pcpu_stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&p->syncp);
+			start = u64_stats_fetch_begin(&p->syncp);
 			rx_packets	= u64_stats_read(&p->rx_packets);
 			rx_bytes	= u64_stats_read(&p->rx_bytes);
 			rx_multicast	= u64_stats_read(&p->rx_multicast);
 			tx_packets	= u64_stats_read(&p->tx_packets);
 			tx_bytes	= u64_stats_read(&p->tx_bytes);
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
 
 		stats->rx_packets	+= rx_packets;
 		stats->rx_bytes		+= rx_bytes;
diff --git a/drivers/net/team/team_mode_loadbalance.c b/drivers/net/team/team_mode_loadbalance.c
index b095a4b4957b..18d99fda997c 100644
--- a/drivers/net/team/team_mode_loadbalance.c
+++ b/drivers/net/team/team_mode_loadbalance.c
@@ -466,9 +466,9 @@ static void __lb_one_cpu_stats_add(struct lb_stats *acc_stats,
 	struct lb_stats tmp;
 
 	do {
-		start = u64_stats_fetch_begin_irq(syncp);
+		start = u64_stats_fetch_begin(syncp);
 		tmp.tx_bytes = cpu_stats->tx_bytes;
-	} while (u64_stats_fetch_retry_irq(syncp, start));
+	} while (u64_stats_fetch_retry(syncp, start));
 	acc_stats->tx_bytes += tmp.tx_bytes;
 }
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 466da01ba2e3..2da7cfcfe1c3 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -182,12 +182,12 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 		size_t offset;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&rq_stats->syncp);
+			start = u64_stats_fetch_begin(&rq_stats->syncp);
 			for (j = 0; j < VETH_RQ_STATS_LEN; j++) {
 				offset = veth_rq_stats_desc[j].offset;
 				data[idx + j] = *(u64 *)(stats_base + offset);
 			}
-		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rq_stats->syncp, start));
 		idx += VETH_RQ_STATS_LEN;
 	}
 
@@ -203,12 +203,12 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 
 		tx_idx += (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;
 		do {
-			start = u64_stats_fetch_begin_irq(&rq_stats->syncp);
+			start = u64_stats_fetch_begin(&rq_stats->syncp);
 			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
 				offset = veth_tq_stats_desc[j].offset;
 				data[tx_idx + j] += *(u64 *)(base + offset);
 			}
-		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rq_stats->syncp, start));
 	}
 }
 
@@ -379,13 +379,13 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 		unsigned int start;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			start = u64_stats_fetch_begin(&stats->syncp);
 			peer_tq_xdp_xmit_err = stats->vs.peer_tq_xdp_xmit_err;
 			xdp_tx_err = stats->vs.xdp_tx_err;
 			packets = stats->vs.xdp_packets;
 			bytes = stats->vs.xdp_bytes;
 			drops = stats->vs.rx_drops;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 		result->peer_tq_xdp_xmit_err += peer_tq_xdp_xmit_err;
 		result->xdp_tx_err += xdp_tx_err;
 		result->xdp_packets += packets;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d934774e9733..04ff01630521 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2066,18 +2066,18 @@ static void virtnet_stats(struct net_device *dev,
 		struct send_queue *sq = &vi->sq[i];
 
 		do {
-			start = u64_stats_fetch_begin_irq(&sq->stats.syncp);
+			start = u64_stats_fetch_begin(&sq->stats.syncp);
 			tpackets = sq->stats.packets;
 			tbytes   = sq->stats.bytes;
 			terrors  = sq->stats.tx_timeouts;
-		} while (u64_stats_fetch_retry_irq(&sq->stats.syncp, start));
+		} while (u64_stats_fetch_retry(&sq->stats.syncp, start));
 
 		do {
-			start = u64_stats_fetch_begin_irq(&rq->stats.syncp);
+			start = u64_stats_fetch_begin(&rq->stats.syncp);
 			rpackets = rq->stats.packets;
 			rbytes   = rq->stats.bytes;
 			rdrops   = rq->stats.drops;
-		} while (u64_stats_fetch_retry_irq(&rq->stats.syncp, start));
+		} while (u64_stats_fetch_retry(&rq->stats.syncp, start));
 
 		tot->rx_packets += rpackets;
 		tot->tx_packets += tpackets;
@@ -2688,12 +2688,12 @@ static void virtnet_get_ethtool_stats(struct net_device *dev,
 
 		stats_base = (u8 *)&rq->stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&rq->stats.syncp);
+			start = u64_stats_fetch_begin(&rq->stats.syncp);
 			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++) {
 				offset = virtnet_rq_stats_desc[j].offset;
 				data[idx + j] = *(u64 *)(stats_base + offset);
 			}
-		} while (u64_stats_fetch_retry_irq(&rq->stats.syncp, start));
+		} while (u64_stats_fetch_retry(&rq->stats.syncp, start));
 		idx += VIRTNET_RQ_STATS_LEN;
 	}
 
@@ -2702,12 +2702,12 @@ static void virtnet_get_ethtool_stats(struct net_device *dev,
 
 		stats_base = (u8 *)&sq->stats;
 		do {
-			start = u64_stats_fetch_begin_irq(&sq->stats.syncp);
+			start = u64_stats_fetch_begin(&sq->stats.syncp);
 			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++) {
 				offset = virtnet_sq_stats_desc[j].offset;
 				data[idx + j] = *(u64 *)(stats_base + offset);
 			}
-		} while (u64_stats_fetch_retry_irq(&sq->stats.syncp, start));
+		} while (u64_stats_fetch_retry(&sq->stats.syncp, start));
 		idx += VIRTNET_SQ_STATS_LEN;
 	}
 }
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 5df7a0abc39d..191ebc482f0c 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -159,13 +159,13 @@ static void vrf_get_stats64(struct net_device *dev,
 
 		dstats = per_cpu_ptr(dev->dstats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&dstats->syncp);
+			start = u64_stats_fetch_begin(&dstats->syncp);
 			tbytes = dstats->tx_bytes;
 			tpkts = dstats->tx_pkts;
 			tdrops = dstats->tx_drps;
 			rbytes = dstats->rx_bytes;
 			rpkts = dstats->rx_pkts;
-		} while (u64_stats_fetch_retry_irq(&dstats->syncp, start));
+		} while (u64_stats_fetch_retry(&dstats->syncp, start));
 		stats->tx_bytes += tbytes;
 		stats->tx_packets += tpkts;
 		stats->tx_dropped += tdrops;
diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index 3e04af4c5daa..a3de081cda5e 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -129,9 +129,9 @@ static void vxlan_vnifilter_stats_get(const struct vxlan_vni_node *vninode,
 
 		pstats = per_cpu_ptr(vninode->stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&pstats->syncp);
+			start = u64_stats_fetch_begin(&pstats->syncp);
 			memcpy(&temp, &pstats->stats, sizeof(temp));
-		} while (u64_stats_fetch_retry_irq(&pstats->syncp, start));
+		} while (u64_stats_fetch_retry(&pstats->syncp, start));
 
 		dest->rx_packets += temp.rx_packets;
 		dest->rx_bytes += temp.rx_bytes;
diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index 6872782e8dd8..22b5939a42bb 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -456,19 +456,19 @@ static void mhi_mbim_ndo_get_stats64(struct net_device *ndev,
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin_irq(&link->rx_syncp);
+		start = u64_stats_fetch_begin(&link->rx_syncp);
 		stats->rx_packets = u64_stats_read(&link->rx_packets);
 		stats->rx_bytes = u64_stats_read(&link->rx_bytes);
 		stats->rx_errors = u64_stats_read(&link->rx_errors);
-	} while (u64_stats_fetch_retry_irq(&link->rx_syncp, start));
+	} while (u64_stats_fetch_retry(&link->rx_syncp, start));
 
 	do {
-		start = u64_stats_fetch_begin_irq(&link->tx_syncp);
+		start = u64_stats_fetch_begin(&link->tx_syncp);
 		stats->tx_packets = u64_stats_read(&link->tx_packets);
 		stats->tx_bytes = u64_stats_read(&link->tx_bytes);
 		stats->tx_errors = u64_stats_read(&link->tx_errors);
 		stats->tx_dropped = u64_stats_read(&link->tx_dropped);
-	} while (u64_stats_fetch_retry_irq(&link->tx_syncp, start));
+	} while (u64_stats_fetch_retry(&link->tx_syncp, start));
 }
 
 static void mhi_mbim_ul_callback(struct mhi_device *mhi_dev,
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 27a11cc08c61..df4dc02638a0 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1392,16 +1392,16 @@ static void xennet_get_stats64(struct net_device *dev,
 		unsigned int start;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
+			start = u64_stats_fetch_begin(&tx_stats->syncp);
 			tx_packets = tx_stats->packets;
 			tx_bytes = tx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
 
 		do {
-			start = u64_stats_fetch_begin_irq(&rx_stats->syncp);
+			start = u64_stats_fetch_begin(&rx_stats->syncp);
 			rx_packets = rx_stats->packets;
 			rx_bytes = rx_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&rx_stats->syncp, start));
 
 		tot->rx_packets += rx_packets;
 		tot->tx_packets += tx_packets;
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 8f97a3eacdea..eb1a03a44d1b 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -127,10 +127,10 @@ do {									\
 		unsigned int start;					\
 		pcpu_stats = per_cpu_ptr(in, i);			\
 		do {							\
-			start = u64_stats_fetch_begin_irq(		\
+			start = u64_stats_fetch_begin(		\
 					&pcpu_stats->syncp);		\
 			inc = u64_stats_read(&pcpu_stats->field);	\
-		} while (u64_stats_fetch_retry_irq(			\
+		} while (u64_stats_fetch_retry(			\
 					&pcpu_stats->syncp, start));	\
 		ret += inc;						\
 	}								\
diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 46040d66334a..ffe48e69b3f3 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -213,16 +213,4 @@ static inline bool u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
 	return __u64_stats_fetch_retry(syncp, start);
 }
 
-/* Obsolete interfaces */
-static inline unsigned int u64_stats_fetch_begin_irq(const struct u64_stats_sync *syncp)
-{
-	return u64_stats_fetch_begin(syncp);
-}
-
-static inline bool u64_stats_fetch_retry_irq(const struct u64_stats_sync *syncp,
-					     unsigned int start)
-{
-	return u64_stats_fetch_retry(syncp, start);
-}
-
 #endif /* _LINUX_U64_STATS_SYNC_H */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a4d40d98428a..b24612d94a12 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2107,11 +2107,11 @@ static void bpf_prog_get_stats(const struct bpf_prog *prog,
 
 		st = per_cpu_ptr(prog->stats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&st->syncp);
+			start = u64_stats_fetch_begin(&st->syncp);
 			tnsecs = u64_stats_read(&st->nsecs);
 			tcnt = u64_stats_read(&st->cnt);
 			tmisses = u64_stats_read(&st->misses);
-		} while (u64_stats_fetch_retry_irq(&st->syncp, start));
+		} while (u64_stats_fetch_retry(&st->syncp, start));
 		nsecs += tnsecs;
 		cnt += tcnt;
 		misses += tmisses;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 035812b0461c..ecdb47712d95 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -712,13 +712,13 @@ static void vlan_dev_get_stats64(struct net_device *dev,
 
 		p = per_cpu_ptr(vlan_dev_priv(dev)->vlan_pcpu_stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&p->syncp);
+			start = u64_stats_fetch_begin(&p->syncp);
 			rxpackets	= u64_stats_read(&p->rx_packets);
 			rxbytes		= u64_stats_read(&p->rx_bytes);
 			rxmulticast	= u64_stats_read(&p->rx_multicast);
 			txpackets	= u64_stats_read(&p->tx_packets);
 			txbytes		= u64_stats_read(&p->tx_bytes);
-		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
+		} while (u64_stats_fetch_retry(&p->syncp, start));
 
 		stats->rx_packets	+= rxpackets;
 		stats->rx_bytes		+= rxbytes;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index db4f2641d1cd..7e2a9fb5786c 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4899,9 +4899,9 @@ void br_multicast_get_stats(const struct net_bridge *br,
 		unsigned int start;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			memcpy(&temp, &cpu_stats->mstats, sizeof(temp));
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		mcast_stats_add_dir(tdst.igmp_v1queries, temp.igmp_v1queries);
 		mcast_stats_add_dir(tdst.igmp_v2queries, temp.igmp_v2queries);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6e53dc991409..f2fc284abab3 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1378,12 +1378,12 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 
 		cpu_stats = per_cpu_ptr(v->stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			rxpackets = u64_stats_read(&cpu_stats->rx_packets);
 			rxbytes = u64_stats_read(&cpu_stats->rx_bytes);
 			txbytes = u64_stats_read(&cpu_stats->tx_bytes);
 			txpackets = u64_stats_read(&cpu_stats->tx_packets);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		u64_stats_add(&stats->rx_packets, rxpackets);
 		u64_stats_add(&stats->rx_bytes, rxbytes);
diff --git a/net/core/dev.c b/net/core/dev.c
index 716df64fcfa5..3f741c1a60c1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10492,12 +10492,12 @@ void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
 
 		stats = per_cpu_ptr(netstats, cpu);
 		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			start = u64_stats_fetch_begin(&stats->syncp);
 			rx_packets = u64_stats_read(&stats->rx_packets);
 			rx_bytes   = u64_stats_read(&stats->rx_bytes);
 			tx_packets = u64_stats_read(&stats->tx_packets);
 			tx_bytes   = u64_stats_read(&stats->tx_bytes);
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+		} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 		s->rx_packets += rx_packets;
 		s->rx_bytes   += rx_bytes;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b50bcc18b8d9..cfa6a099457a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8268,10 +8268,10 @@ static void devlink_trap_stats_read(struct devlink_stats __percpu *trap_stats,
 
 		cpu_stats = per_cpu_ptr(trap_stats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			rx_packets = u64_stats_read(&cpu_stats->rx_packets);
 			rx_bytes = u64_stats_read(&cpu_stats->rx_bytes);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		u64_stats_add(&stats->rx_packets, rx_packets);
 		u64_stats_add(&stats->rx_bytes, rx_bytes);
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 75501e1bdd25..dfcaf61d972c 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1432,9 +1432,9 @@ static void net_dm_stats_read(struct net_dm_stats *stats)
 		u64 dropped;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			dropped = u64_stats_read(&cpu_stats->dropped);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		u64_stats_add(&stats->dropped, dropped);
 	}
@@ -1476,9 +1476,9 @@ static void net_dm_hw_stats_read(struct net_dm_stats *stats)
 		u64 dropped;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			start = u64_stats_fetch_begin(&cpu_stats->syncp);
 			dropped = u64_stats_read(&cpu_stats->dropped);
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, start));
 
 		u64_stats_add(&stats->dropped, dropped);
 	}
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index a10335b4ba2d..330db87ee667 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -135,10 +135,10 @@ static void gnet_stats_add_basic_cpu(struct gnet_stats_basic_sync *bstats,
 		u64 bytes, packets;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&bcpu->syncp);
+			start = u64_stats_fetch_begin(&bcpu->syncp);
 			bytes = u64_stats_read(&bcpu->bytes);
 			packets = u64_stats_read(&bcpu->packets);
-		} while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));
+		} while (u64_stats_fetch_retry(&bcpu->syncp, start));
 
 		t_bytes += bytes;
 		t_packets += packets;
@@ -162,10 +162,10 @@ void gnet_stats_add_basic(struct gnet_stats_basic_sync *bstats,
 	}
 	do {
 		if (running)
-			start = u64_stats_fetch_begin_irq(&b->syncp);
+			start = u64_stats_fetch_begin(&b->syncp);
 		bytes = u64_stats_read(&b->bytes);
 		packets = u64_stats_read(&b->packets);
-	} while (running && u64_stats_fetch_retry_irq(&b->syncp, start));
+	} while (running && u64_stats_fetch_retry(&b->syncp, start));
 
 	_bstats_update(bstats, bytes, packets);
 }
@@ -187,10 +187,10 @@ static void gnet_stats_read_basic(u64 *ret_bytes, u64 *ret_packets,
 			u64 bytes, packets;
 
 			do {
-				start = u64_stats_fetch_begin_irq(&bcpu->syncp);
+				start = u64_stats_fetch_begin(&bcpu->syncp);
 				bytes = u64_stats_read(&bcpu->bytes);
 				packets = u64_stats_read(&bcpu->packets);
-			} while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));
+			} while (u64_stats_fetch_retry(&bcpu->syncp, start));
 
 			t_bytes += bytes;
 			t_packets += packets;
@@ -201,10 +201,10 @@ static void gnet_stats_read_basic(u64 *ret_bytes, u64 *ret_packets,
 	}
 	do {
 		if (running)
-			start = u64_stats_fetch_begin_irq(&b->syncp);
+			start = u64_stats_fetch_begin(&b->syncp);
 		*ret_bytes = u64_stats_read(&b->bytes);
 		*ret_packets = u64_stats_read(&b->packets);
-	} while (running && u64_stats_fetch_retry_irq(&b->syncp, start));
+	} while (running && u64_stats_fetch_retry(&b->syncp, start));
 }
 
 static int
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ad6a6663feeb..30333a211ccf 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -934,12 +934,12 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
 
 		s = per_cpu_ptr(dev->tstats, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&s->syncp);
+			start = u64_stats_fetch_begin(&s->syncp);
 			tx_packets = u64_stats_read(&s->tx_packets);
 			tx_bytes = u64_stats_read(&s->tx_bytes);
 			rx_packets = u64_stats_read(&s->rx_packets);
 			rx_bytes = u64_stats_read(&s->rx_bytes);
-		} while (u64_stats_fetch_retry_irq(&s->syncp, start));
+		} while (u64_stats_fetch_retry(&s->syncp, start));
 		data[0] += tx_packets;
 		data[1] += tx_bytes;
 		data[2] += rx_packets;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 3ca0cc467886..dbae0c79d5cf 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1684,9 +1684,9 @@ u64 snmp_get_cpu_field64(void __percpu *mib, int cpu, int offt,
 	bhptr = per_cpu_ptr(mib, cpu);
 	syncp = (struct u64_stats_sync *)(bhptr + syncp_offset);
 	do {
-		start = u64_stats_fetch_begin_irq(syncp);
+		start = u64_stats_fetch_begin(syncp);
 		v = *(((u64 *)bhptr) + offt);
-	} while (u64_stats_fetch_retry_irq(syncp, start));
+	} while (u64_stats_fetch_retry(syncp, start));
 
 	return v;
 }
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index b7de5e46fdd8..f84da849819c 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1508,13 +1508,13 @@ static int put_nla_counters(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 
 		pcounters = per_cpu_ptr(slwt->pcpu_counters, i);
 		do {
-			start = u64_stats_fetch_begin_irq(&pcounters->syncp);
+			start = u64_stats_fetch_begin(&pcounters->syncp);
 
 			packets = u64_stats_read(&pcounters->packets);
 			bytes = u64_stats_read(&pcounters->bytes);
 			errors = u64_stats_read(&pcounters->errors);
 
-		} while (u64_stats_fetch_retry_irq(&pcounters->syncp, start));
+		} while (u64_stats_fetch_retry(&pcounters->syncp, start));
 
 		counters.packets += packets;
 		counters.bytes += bytes;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index efab2b06d373..5a7349002508 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2296,13 +2296,13 @@ static int ip_vs_stats_percpu_show(struct seq_file *seq, void *v)
 		u64 conns, inpkts, outpkts, inbytes, outbytes;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&u->syncp);
+			start = u64_stats_fetch_begin(&u->syncp);
 			conns = u->cnt.conns;
 			inpkts = u->cnt.inpkts;
 			outpkts = u->cnt.outpkts;
 			inbytes = u->cnt.inbytes;
 			outbytes = u->cnt.outbytes;
-		} while (u64_stats_fetch_retry_irq(&u->syncp, start));
+		} while (u64_stats_fetch_retry(&u->syncp, start));
 
 		seq_printf(seq, "%3X %8LX %8LX %8LX %16LX %16LX\n",
 			   i, (u64)conns, (u64)inpkts,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3cc88998b879..9366556e7393 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1535,10 +1535,10 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	for_each_possible_cpu(cpu) {
 		cpu_stats = per_cpu_ptr(stats, cpu);
 		do {
-			seq = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			seq = u64_stats_fetch_begin(&cpu_stats->syncp);
 			pkts = cpu_stats->pkts;
 			bytes = cpu_stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, seq));
+		} while (u64_stats_fetch_retry(&cpu_stats->syncp, seq));
 		total.pkts += pkts;
 		total.bytes += bytes;
 	}
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 7e8a39a35627..40c4218db429 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -707,9 +707,9 @@ static void get_dp_stats(const struct datapath *dp, struct ovs_dp_stats *stats,
 		percpu_stats = per_cpu_ptr(dp->stats_percpu, i);
 
 		do {
-			start = u64_stats_fetch_begin_irq(&percpu_stats->syncp);
+			start = u64_stats_fetch_begin(&percpu_stats->syncp);
 			local_stats = *percpu_stats;
-		} while (u64_stats_fetch_retry_irq(&percpu_stats->syncp, start));
+		} while (u64_stats_fetch_retry(&percpu_stats->syncp, start));
 
 		stats->n_hit += local_stats.n_hit;
 		stats->n_missed += local_stats.n_missed;
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index d4a2db0b2299..0a0e4c283f02 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -205,9 +205,9 @@ static void tbl_mask_array_reset_counters(struct mask_array *ma)
 
 			stats = per_cpu_ptr(ma->masks_usage_stats, cpu);
 			do {
-				start = u64_stats_fetch_begin_irq(&stats->syncp);
+				start = u64_stats_fetch_begin(&stats->syncp);
 				counter = stats->usage_cntrs[i];
-			} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+			} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 			ma->masks_usage_zero_cntr[i] += counter;
 		}
@@ -1136,10 +1136,9 @@ void ovs_flow_masks_rebalance(struct flow_table *table)
 
 			stats = per_cpu_ptr(ma->masks_usage_stats, cpu);
 			do {
-				start = u64_stats_fetch_begin_irq(&stats->syncp);
+				start = u64_stats_fetch_begin(&stats->syncp);
 				counter = stats->usage_cntrs[i];
-			} while (u64_stats_fetch_retry_irq(&stats->syncp,
-							   start));
+			} while (u64_stats_fetch_retry(&stats->syncp, start));
 
 			masks_and_count[i].counter += counter;
 		}

-- 
b4 0.10.0-dev-c53d8

