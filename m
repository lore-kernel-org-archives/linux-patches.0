Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4725471250;
	Tue, 21 Jul 2026 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657785; cv=none; b=VJ740jNFPtFMi1LISmcT8k/AQpJxkrMA46eCEbUNS15pRl9hsQ2HrU14Ih91c/J+p+bdP8+aq3cO+8iXatrDS3i5oOClVJ7lXWj4r/HB1cOwFFmz4GmPeOcYouahtbBmwM0QBqrA/T6N6jDYj9p3wfPawLyUgPKsGHWBVxF6GJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657785; c=relaxed/simple;
	bh=0Y2b13c9WwNOBpv1foaw3AoPhip1ZnXjQEZyR62CJP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3w6tDqFZxBhI1GA4F8eOGugy3Y+p+o7+0IADGGwrnVFXIXEtVmm05cP+UOg3MBtvODYZ3k2K3j8dEC0v1ZxC9WUFbIvjnAKSR2eU4inFsntoEmlIFs2YOBD4FT9lKHZBxLu2vQ4xn6kxdRC9DzEwN69M8XMg/bVDZAKKZZr4t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSlMSz2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSlMSz2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E501F000E9;
	Tue, 21 Jul 2026 18:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657783;
	bh=4AwZn3l2r+DFmmZ8X0FRlWKvIpbUK4RGi4PdaQ5GkDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSlMSz2bs8VnAFACYPGnTm5940BMpsG15g0BOWHPR2YQ93UH0nZlU7dOOpJCGSM7B
	 OKyPHLiBWTXuEeI3lYTqtx2/ibp/RIqiTWQ0PmZazdwsRsQJoo+EZu5NDpxkvBdK4n
	 NOxU9QZAFQ1Y97pl4oUqEdNbzVTnizWwDHWiLVyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0897/1611] eth: bnxt: improve the timing of stats
Date: Tue, 21 Jul 2026 17:16:53 +0200
Message-ID: <20260721152535.566571770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 40529e58629baa9ce72143cb46cf1b3d2ca0d465 ]

Kernel selftests wait 1.25x of the promised stats refresh time
(as read from ethtool -c). bnxt reports 1sec by default, but
the stats update process has two steps. First device DMAs the
new values, then the service task performs update in full-width
SW counters. So the worst case delay is actually 2x.

Note that the behavior is different for ring stats and port stats.
Port stats are fetched synchronously by the service worker, so
there's no risk of doubling up the delay there.

The problem of stale stats impacts not only tests but real workloads
which monitor egress bandwidth of a NIC. The inaccuracy causes double
counting in the next cycle and spurious overload alarms.

Try to read from the DMA buffer more aggressively, to mitigate
timing issues between DMA and service task. The SW update should
be cheap.

Fixes: 51f307856b60 ("bnxt_en: Allow statistics DMA to be configurable using ethtool -C.")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260619191538.104165-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 48 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  5 ++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  1 +
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d0e37a09466499..98a911eae8eac8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10367,7 +10367,7 @@ static void bnxt_accumulate_stats(struct bnxt_stats_mem *stats)
 				stats->hw_masks, stats->len / 8, false);
 }
 
-static void bnxt_accumulate_all_stats(struct bnxt *bp)
+static void bnxt_accumulate_ring_stats(struct bnxt *bp)
 {
 	struct bnxt_stats_mem *ring0_stats;
 	bool ignore_zero = false;
@@ -10390,6 +10390,10 @@ static void bnxt_accumulate_all_stats(struct bnxt *bp)
 					ring0_stats->hw_masks,
 					ring0_stats->len / 8, ignore_zero);
 	}
+}
+
+static void bnxt_accumulate_port_stats(struct bnxt *bp)
+{
 	if (bp->flags & BNXT_FLAG_PORT_STATS) {
 		struct bnxt_stats_mem *stats = &bp->port_stats;
 		__le64 *hw_stats = stats->hw_stats;
@@ -10412,6 +10416,41 @@ static void bnxt_accumulate_all_stats(struct bnxt *bp)
 	}
 }
 
+static void bnxt_accumulate_all_stats(struct bnxt *bp)
+{
+	bnxt_accumulate_ring_stats(bp);
+	bnxt_accumulate_port_stats(bp);
+}
+
+/* Re-accumulate ring stats from DMA buffers if stale.
+ * uAPIs for reading sw_stats should call this first.
+ *
+ * We promise user space update frequency of bp->stats_coal_ticks but
+ * the update is a two step process - first device updates the DMA buffer,
+ * then we have to update from that buffer to driver stats in the service work.
+ * Worst case we would be 2x off from the desired frequency.
+ * Sync the stats sooner, if stale. The 20% threshold was chosen arbitrarily.
+ *
+ * Ideally we would split the user-configured time into two portions,
+ * i.e. also lower the DMA period by the 20%. But the DMA timer seems to have
+ * too coarse granularity to play such tricks.
+ */
+void bnxt_sync_ring_stats(struct bnxt *bp)
+{
+	unsigned long stale;
+
+	if (!netif_running(bp->dev) || !bp->stats_coal_ticks)
+		return;
+
+	spin_lock(&bp->stats_lock);
+	stale = usecs_to_jiffies(bp->stats_coal_ticks / 5);
+	if (time_after_eq(jiffies, bp->stats_updated_jiffies + stale)) {
+		bnxt_accumulate_ring_stats(bp);
+		bp->stats_updated_jiffies = jiffies;
+	}
+	spin_unlock(&bp->stats_lock);
+}
+
 static int bnxt_hwrm_port_qstats(struct bnxt *bp, u8 flags)
 {
 	struct hwrm_port_qstats_input *req;
@@ -13376,6 +13415,7 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		return;
 	}
 
+	bnxt_sync_ring_stats(bp);
 	bnxt_get_ring_stats(bp, stats);
 	bnxt_add_prev_stats(bp, stats);
 
@@ -14548,7 +14588,10 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event)) {
 		bnxt_hwrm_port_qstats(bp, 0);
 		bnxt_hwrm_port_qstats_ext(bp, 0);
+		spin_lock(&bp->stats_lock);
 		bnxt_accumulate_all_stats(bp);
+		bp->stats_updated_jiffies = jiffies;
+		spin_unlock(&bp->stats_lock);
 	}
 
 	if (test_and_clear_bit(BNXT_LINK_CHNG_SP_EVENT, &bp->sp_event)) {
@@ -15279,6 +15322,7 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	INIT_DELAYED_WORK(&bp->fw_reset_task, bnxt_fw_reset_task);
 
 	spin_lock_init(&bp->ntp_fltr_lock);
+	spin_lock_init(&bp->stats_lock);
 #if BITS_PER_LONG == 32
 	spin_lock_init(&bp->db_lock);
 #endif
@@ -15837,6 +15881,7 @@ static void bnxt_get_queue_stats_rx(struct net_device *dev, int i,
 	if (!bp->bnapi)
 		return;
 
+	bnxt_sync_ring_stats(bp);
 	cpr = &bp->bnapi[i]->cp_ring;
 	sw = cpr->stats.sw_stats;
 
@@ -15865,6 +15910,7 @@ static void bnxt_get_queue_stats_tx(struct net_device *dev, int i,
 	if (!bp->tx_ring)
 		return;
 
+	bnxt_sync_ring_stats(bp);
 	bnapi = bp->tx_ring[bp->tx_ring_map[i]].bnapi;
 	sw = bnapi->cp_ring.stats.sw_stats;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 9c9212ecd8c744..d55987e24ad6e4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2601,6 +2601,10 @@ struct bnxt {
 #define BNXT_MIN_STATS_COAL_TICKS	  250000
 #define BNXT_MAX_STATS_COAL_TICKS	 1000000
 
+	/* Protects stats_updated_jiffies and writes to sw_stats */
+	spinlock_t		stats_lock;
+	unsigned long		stats_updated_jiffies;
+
 	struct work_struct	sp_task;
 	unsigned long		sp_event;
 #define BNXT_RX_MASK_SP_EVENT		0
@@ -2965,6 +2969,7 @@ void bnxt_reenable_sriov(struct bnxt *bp);
 void bnxt_close_nic(struct bnxt *, bool, bool);
 void bnxt_get_ring_drv_stats(struct bnxt *bp,
 			     struct bnxt_total_ring_drv_stats *stats);
+void bnxt_sync_ring_stats(struct bnxt *bp);
 bool bnxt_rfs_capable(struct bnxt *bp, bool new_rss_ctx);
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
 			 u32 *reg_buf);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 8d10bf22480f69..a71025f51370d7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -605,6 +605,7 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 		goto skip_ring_stats;
 	}
 
+	bnxt_sync_ring_stats(bp);
 	tpa_stats = bnxt_get_num_tpa_ring_stats(bp);
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
-- 
2.53.0



