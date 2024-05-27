Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C39B17727;
	Mon, 27 May 2024 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838276; cv=none; b=r39w+9194mq8rszH33x6JnoFOtiIsAJTrOX4QpQSeChRBuri+nxBDRJf1E0RNlZOlur36PRC5Z74jbD5PooCz2qm9n8FuviYk/C58fR+B4XoPDOOeOEyp5Dg3CSg+uxWfuMYMkhfRT6+EjOmiUApZ068k8VOoQBqDf0qomdsChM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838276; c=relaxed/simple;
	bh=UtrZYvwysGE5wqz9EIHUqs2M9TxAiYDhm+HTa9+EEn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2T9TcrntNFAhjWTVviYz/ErFzaTviVDYGQmsvJIcnvIz87p7N+soXl3oyOQMBTjpJBXsYwoXumu7Np8Ov1MkxWiKbgJvwCryc5DXdzjCBUYdXdKycT4zExKI5qHk0C+KV+h0d6thiNjVb5FZPa03GlicHaM+G3Ha/lgLRaUIi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBtFnTHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBtFnTHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317B5C2BBFC;
	Mon, 27 May 2024 19:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838276;
	bh=UtrZYvwysGE5wqz9EIHUqs2M9TxAiYDhm+HTa9+EEn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBtFnTHrnqTidbpgC4kKb0eKFFs05Ve7DsrrG+/6ylbuaBA4oVFq8kjn4Uii1lnef
	 BR64HAtD1HYDfCLqK7ezJXXRMUMXKPXZ5Qya844kOZeGnSBtXGvsMtFwhEz4wEMKEC
	 bM4JEy0yacf1uPrCULCdjNYaC2/T+0YfCEeAPC0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 332/493] net: stmmac: Offload queueMaxSDU from tc-taprio
Date: Mon, 27 May 2024 20:55:34 +0200
Message-ID: <20240527185641.128958730@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Rohan G Thomas <rohan.g.thomas@intel.com>

[ Upstream commit c5c3e1bfc9e0ee72af528df8d773980f4855938a ]

Add support for configuring queueMaxSDU. As DWMAC IPs doesn't support
queueMaxSDU table handle this in the SW. The maximum 802.3 frame size
that is allowed to be transmitted by any queue is queueMaxSDU +
16 bytes (i.e. 6 bytes SA + 6 bytes DA + 4 bytes FCS).

Inspired from intel i225 driver.

Signed-off-by: Rohan G Thomas <rohan.g.thomas@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 36ac9e7f2e57 ("net: stmmac: move the EST lock to struct stmmac_priv")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22 ++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 25 +++++++++++++++++++
 include/linux/stmmac.h                        |  1 +
 4 files changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 5a1d46dcd5de0..2706761955fea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -225,6 +225,7 @@ struct stmmac_extra_stats {
 	unsigned long mtl_est_hlbf;
 	unsigned long mtl_est_btre;
 	unsigned long mtl_est_btrlm;
+	unsigned long max_sdu_txq_drop[MTL_MAX_TX_QUEUES];
 	/* per queue statistics */
 	struct stmmac_txq_stats txq_stats[MTL_MAX_TX_QUEUES];
 	struct stmmac_rxq_stats rxq_stats[MTL_MAX_RX_QUEUES];
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 83b732c30c1bb..12f4c0da838da 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2491,6 +2491,13 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		if (!xsk_tx_peek_desc(pool, &xdp_desc))
 			break;
 
+		if (priv->plat->est && priv->plat->est->enable &&
+		    priv->plat->est->max_sdu[queue] &&
+		    xdp_desc.len > priv->plat->est->max_sdu[queue]) {
+			priv->xstats.max_sdu_txq_drop[queue]++;
+			continue;
+		}
+
 		if (likely(priv->extend_desc))
 			tx_desc = (struct dma_desc *)(tx_q->dma_etx + entry);
 		else if (tx_q->tbs & STMMAC_TBS_AVAIL)
@@ -4485,6 +4492,13 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 			return stmmac_tso_xmit(skb, dev);
 	}
 
+	if (priv->plat->est && priv->plat->est->enable &&
+	    priv->plat->est->max_sdu[queue] &&
+	    skb->len > priv->plat->est->max_sdu[queue]){
+		priv->xstats.max_sdu_txq_drop[queue]++;
+		goto max_sdu_err;
+	}
+
 	if (unlikely(stmmac_tx_avail(priv, queue) < nfrags + 1)) {
 		if (!netif_tx_queue_stopped(netdev_get_tx_queue(dev, queue))) {
 			netif_tx_stop_queue(netdev_get_tx_queue(priv->dev,
@@ -4702,6 +4716,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 dma_map_err:
 	netdev_err(priv->dev, "Tx DMA map failed\n");
+max_sdu_err:
 	dev_kfree_skb(skb);
 	priv->xstats.tx_dropped++;
 	return NETDEV_TX_OK;
@@ -4858,6 +4873,13 @@ static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 	if (stmmac_tx_avail(priv, queue) < STMMAC_TX_THRESH(priv))
 		return STMMAC_XDP_CONSUMED;
 
+	if (priv->plat->est && priv->plat->est->enable &&
+	    priv->plat->est->max_sdu[queue] &&
+	    xdpf->len > priv->plat->est->max_sdu[queue]) {
+		priv->xstats.max_sdu_txq_drop[queue]++;
+		return STMMAC_XDP_CONSUMED;
+	}
+
 	if (likely(priv->extend_desc))
 		tx_desc = (struct dma_desc *)(tx_q->dma_etx + entry);
 	else if (tx_q->tbs & STMMAC_TBS_AVAIL)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 26fa33e5ec34f..07aa3a3089dc2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -915,6 +915,28 @@ struct timespec64 stmmac_calc_tas_basetime(ktime_t old_base_time,
 	return time;
 }
 
+static void tc_taprio_map_maxsdu_txq(struct stmmac_priv *priv,
+				     struct tc_taprio_qopt_offload *qopt)
+{
+	struct plat_stmmacenet_data *plat = priv->plat;
+	u32 num_tc = qopt->mqprio.qopt.num_tc;
+	u32 offset, count, i, j;
+
+	/* QueueMaxSDU received from the driver corresponds to the Linux traffic
+	 * class. Map queueMaxSDU per Linux traffic class to DWMAC Tx queues.
+	 */
+	for (i = 0; i < num_tc; i++) {
+		if (!qopt->max_sdu[i])
+			continue;
+
+		offset = qopt->mqprio.qopt.offset[i];
+		count = qopt->mqprio.qopt.count[i];
+
+		for (j = offset; j < offset + count; j++)
+			plat->est->max_sdu[j] = qopt->max_sdu[i] + ETH_HLEN - ETH_TLEN;
+	}
+}
+
 static int tc_setup_taprio(struct stmmac_priv *priv,
 			   struct tc_taprio_qopt_offload *qopt)
 {
@@ -1045,6 +1067,8 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 
 	priv->plat->est->ter = qopt->cycle_time_extension;
 
+	tc_taprio_map_maxsdu_txq(priv, qopt);
+
 	if (fpe && !priv->dma_cap.fpesel) {
 		mutex_unlock(&priv->plat->est->lock);
 		return -EOPNOTSUPP;
@@ -1126,6 +1150,7 @@ static int tc_query_caps(struct stmmac_priv *priv,
 			return -EOPNOTSUPP;
 
 		caps->gate_mask_per_txq = true;
+		caps->supports_queue_max_sdu = true;
 
 		return 0;
 	}
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index dee5ad6e48c5a..dfa1828cd756a 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -127,6 +127,7 @@ struct stmmac_est {
 	u32 gcl_unaligned[EST_GCL];
 	u32 gcl[EST_GCL];
 	u32 gcl_size;
+	u32 max_sdu[MTL_MAX_TX_QUEUES];
 };
 
 struct stmmac_rxq_cfg {
-- 
2.43.0



