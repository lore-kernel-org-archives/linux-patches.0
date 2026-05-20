Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C233F23A4;
	Wed, 20 May 2026 17:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299215; cv=none; b=DncrqrmFXW0wgZgyqmIbVlHZbkJrn50Pr7XU34OQFoQG6XsqksbwuwjHEI3OhyPhEjMDfSJMrdY9ww+R+CuGaVxDB/5Iu1+F0APaTepUwT3XRCgjdVaS2w5lptZYJ9811jbwCC0yYiR5i8VBtAq7jJQ37BhOjmFKkiaZ44JHHLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299215; c=relaxed/simple;
	bh=FvGTcmAokTmvOXFyHlxqJrT/gb/FNVRSANNx/GJm/jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9hfyOOM0XYeuKu5wzPuzAAL0P7ZaODZpbfXbZU6MQW2/DAMDWcLz1eTr6M/9B04lNC86XnSUK1JeYs6963JWaomswho56iQ58CQn2Xoj1lI0LU0Tan7oQDuXssuf0pKmt9wKjuqQAdOSme/eh73gHJ3gOPtr7bzYyASpozhZEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llk5WdqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llk5WdqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ED31F000E9;
	Wed, 20 May 2026 17:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299214;
	bh=LVdnAMsmAv8zIT61DSS896CZ8omwLQihNqFyIsywo70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llk5WdqHksLvac7In/E3Fkq8FxE8k1Xrizhyo7RvvwWXJdAihnKyULHbBhyzzvPde
	 z0WqFNm2NphWBBPkEnhbq9KGYTXvW5PHqYotA+DZKfId/9Z9iJRRtlPJHYinwAGuiE
	 KALnZMfi7p1QKJh2nSrQtJ3mD942+xezo4ySdY6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 704/957] net: mana: Add standard counter rx_missed_errors
Date: Wed, 20 May 2026 18:19:47 +0200
Message-ID: <20260520162149.806961119@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit be4f1d67ec56f23f37714ac73c01094e63c7ff28 ]

Report standard counter stats->rx_missed_errors
using hc_rx_discards_no_wqe from the hardware.

Add a global workqueue to periodically run
mana_query_gf_stats every 2 seconds to get the latest
info in eth_stats and define a driver capability flag
to notify hardware of the periodic queries.

To avoid repeated failures and log flooding, the workqueue
is not rescheduled if mana_query_gf_stats fails on HWC timeout
error and the stats are reset to 0. Other errors are transient
which will not need a VF reset for recovery.

Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/1763120599-6331-3-git-send-email-ernis@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a7fdaf069bd0 ("net: mana: Don't overwrite port probe error with add_adev result")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 36 +++++++++++++++++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  2 --
 include/net/mana/gdma.h                       |  6 +++-
 include/net/mana/mana.h                       |  6 +++-
 4 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 2e5efc03cacec..b0d411ab1067f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -534,6 +534,11 @@ static void mana_get_stats64(struct net_device *ndev,
 
 	netdev_stats_to_stats64(st, &ndev->stats);
 
+	if (apc->ac->hwc_timeout_occurred)
+		netdev_warn_once(ndev, "HWC timeout occurred\n");
+
+	st->rx_missed_errors = apc->ac->hc_stats.hc_rx_discards_no_wqe;
+
 	for (q = 0; q < num_queues; q++) {
 		rx_stats = &apc->rxqs[q]->stats;
 
@@ -2836,7 +2841,7 @@ int mana_config_rss(struct mana_port_context *apc, enum TRI_STATE rx,
 	return 0;
 }
 
-void mana_query_gf_stats(struct mana_context *ac)
+int mana_query_gf_stats(struct mana_context *ac)
 {
 	struct gdma_context *gc = ac->gdma_dev->gdma_context;
 	struct mana_query_gf_stat_resp resp = {};
@@ -2879,14 +2884,14 @@ void mana_query_gf_stats(struct mana_context *ac)
 				sizeof(resp));
 	if (err) {
 		dev_err(dev, "Failed to query GF stats: %d\n", err);
-		return;
+		return err;
 	}
 	err = mana_verify_resp_hdr(&resp.hdr, MANA_QUERY_GF_STAT,
 				   sizeof(resp));
 	if (err || resp.hdr.status) {
 		dev_err(dev, "Failed to query GF stats: %d, 0x%x\n", err,
 			resp.hdr.status);
-		return;
+		return err;
 	}
 
 	ac->hc_stats.hc_rx_discards_no_wqe = resp.rx_discards_nowqe;
@@ -2921,6 +2926,8 @@ void mana_query_gf_stats(struct mana_context *ac)
 	ac->hc_stats.hc_tx_mcast_pkts = resp.hc_tx_mcast_pkts;
 	ac->hc_stats.hc_tx_mcast_bytes = resp.hc_tx_mcast_bytes;
 	ac->hc_stats.hc_tx_err_gdma = resp.tx_err_gdma;
+
+	return 0;
 }
 
 void mana_query_phy_stats(struct mana_port_context *apc)
@@ -3459,6 +3466,24 @@ int mana_rdma_service_event(struct gdma_context *gc, enum gdma_service_type even
 	return 0;
 }
 
+#define MANA_GF_STATS_PERIOD (2 * HZ)
+
+static void mana_gf_stats_work_handler(struct work_struct *work)
+{
+	struct mana_context *ac =
+		container_of(to_delayed_work(work), struct mana_context, gf_stats_work);
+	int err;
+
+	err = mana_query_gf_stats(ac);
+	if (err == -ETIMEDOUT) {
+		/* HWC timeout detected - reset stats and stop rescheduling */
+		ac->hwc_timeout_occurred = true;
+		memset(&ac->hc_stats, 0, sizeof(ac->hc_stats));
+		return;
+	}
+	schedule_delayed_work(&ac->gf_stats_work, MANA_GF_STATS_PERIOD);
+}
+
 int mana_probe(struct gdma_dev *gd, bool resuming)
 {
 	struct gdma_context *gc = gd->gdma_context;
@@ -3551,6 +3576,10 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 	}
 
 	err = add_adev(gd, "eth");
+
+	INIT_DELAYED_WORK(&ac->gf_stats_work, mana_gf_stats_work_handler);
+	schedule_delayed_work(&ac->gf_stats_work, MANA_GF_STATS_PERIOD);
+
 out:
 	if (err) {
 		mana_remove(gd, false);
@@ -3580,6 +3609,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	dev = gc->dev;
 
 	disable_work_sync(&ac->link_change_work);
+	cancel_delayed_work_sync(&ac->gf_stats_work);
 
 	/* adev currently doesn't support suspending, always remove it */
 	if (gd->adev)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 3dfd96146424e..99e8112086833 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -213,8 +213,6 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 
 	if (!apc->port_is_up)
 		return;
-	/* we call mana function to update stats from GDMA */
-	mana_query_gf_stats(apc->ac);
 
 	/* We call this mana function to get the phy stats from GDMA and includes
 	 * aggregate tx/rx drop counters, Per-TC(Traffic Channel) tx/rx and pause
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 637f42485dba6..2e4f2f3175e55 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -592,6 +592,9 @@ enum {
 #define GDMA_DRV_CAP_FLAG_1_HANDLE_RECONFIG_EQE BIT(17)
 #define GDMA_DRV_CAP_FLAG_1_HW_VPORT_LINK_AWARE BIT(6)
 
+/* Driver can send HWC periodically to query stats */
+#define GDMA_DRV_CAP_FLAG_1_PERIODIC_STATS_QUERY BIT(21)
+
 #define GDMA_DRV_CAP_FLAGS1 \
 	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX | \
@@ -601,7 +604,8 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_DYNAMIC_IRQ_ALLOC_SUPPORT | \
 	 GDMA_DRV_CAP_FLAG_1_SELF_RESET_ON_EQE | \
 	 GDMA_DRV_CAP_FLAG_1_HANDLE_RECONFIG_EQE | \
-	 GDMA_DRV_CAP_FLAG_1_HW_VPORT_LINK_AWARE)
+	 GDMA_DRV_CAP_FLAG_1_HW_VPORT_LINK_AWARE | \
+	 GDMA_DRV_CAP_FLAG_1_PERIODIC_STATS_QUERY)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 265f2d90027d6..7e946239effa9 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -480,6 +480,10 @@ struct mana_context {
 	struct mana_eq *eqs;
 	struct dentry *mana_eqs_debugfs;
 
+	/* Workqueue for querying hardware stats */
+	struct delayed_work gf_stats_work;
+	bool hwc_timeout_occurred;
+
 	struct net_device *ports[MAX_PORTS_IN_MANA_DEV];
 
 	/* Link state change work */
@@ -582,7 +586,7 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 struct bpf_prog *mana_xdp_get(struct mana_port_context *apc);
 void mana_chn_setxdp(struct mana_port_context *apc, struct bpf_prog *prog);
 int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
-void mana_query_gf_stats(struct mana_context *ac);
+int mana_query_gf_stats(struct mana_context *ac);
 int mana_query_link_cfg(struct mana_port_context *apc);
 int mana_set_bw_clamp(struct mana_port_context *apc, u32 speed,
 		      int enable_clamping);
-- 
2.53.0



