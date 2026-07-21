Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136B2385D67;
	Tue, 21 Jul 2026 19:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662955; cv=none; b=lATb5EWmy1kFLl0k0vBvuyF6Yum1WhjHItef+wKMHVJg2r0ROHEF3ehqHlX7thhbOL8UoSpjINUjgarY2QQK+Tb1AuCiGe3fC6SoZSvWpQfbmHAHcvQHgaTs7SGhJcPcxClmrhivjY8FhXfhzN7tGdCzZMMToxRiC+uweiJGSb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662955; c=relaxed/simple;
	bh=boP8L0hcNNBdzjv5uaKf4fOsjNHlMohoh1Z0cqwGAsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKZmmjaF1YToCZ4kQ2XFLCCbb8JoIzsJ4dATKYg/l4rP2/OPIVv6aMCrH+uoqVxxaVIDjmqe1sq3LByzeAuPGDrmyO1KS97n1OxXhG5dLvy5Ox6MPm5I2FTPLjx0pgeLFicBB/s9pCD34dW8d4HfO+C2nt2ig1pfXIKPmzddpEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzowt00C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzowt00C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FDD1F000E9;
	Tue, 21 Jul 2026 19:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662954;
	bh=JpfnQFAisoiaULgLX9vzydoYdzdha/6xQ97T3kyqHrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzowt00CfiJU5KCABXZ1KTPmqPazJiX8FCNjLUIyAHZmdRD4jXcnhde1JQuYzfrUc
	 v9k1WeO1Wukr9QSlhO4Gc12AnZtRMhxkXkR6fUgFsUAI8HbTktbGALVaS33tmJA8ev
	 gNeMbw7MpZzPm/KoNOmawuB6ym1aYDP6rGEDCxqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0638/1276] eth: bnxt: improve the timing of stats
Date: Tue, 21 Jul 2026 17:18:01 +0200
Message-ID: <20260721152500.388103976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 68f338815ff9ca..835162d949465d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9963,7 +9963,7 @@ static void bnxt_accumulate_stats(struct bnxt_stats_mem *stats)
 				stats->hw_masks, stats->len / 8, false);
 }
 
-static void bnxt_accumulate_all_stats(struct bnxt *bp)
+static void bnxt_accumulate_ring_stats(struct bnxt *bp)
 {
 	struct bnxt_stats_mem *ring0_stats;
 	bool ignore_zero = false;
@@ -9986,6 +9986,10 @@ static void bnxt_accumulate_all_stats(struct bnxt *bp)
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
@@ -10008,6 +10012,41 @@ static void bnxt_accumulate_all_stats(struct bnxt *bp)
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
@@ -12779,6 +12818,7 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		return;
 	}
 
+	bnxt_sync_ring_stats(bp);
 	bnxt_get_ring_stats(bp, stats);
 	bnxt_add_prev_stats(bp, stats);
 
@@ -13948,7 +13988,10 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event)) {
 		bnxt_hwrm_port_qstats(bp, 0);
 		bnxt_hwrm_port_qstats_ext(bp, 0);
+		spin_lock(&bp->stats_lock);
 		bnxt_accumulate_all_stats(bp);
+		bp->stats_updated_jiffies = jiffies;
+		spin_unlock(&bp->stats_lock);
 	}
 
 	if (test_and_clear_bit(BNXT_LINK_CHNG_SP_EVENT, &bp->sp_event)) {
@@ -14661,6 +14704,7 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	INIT_DELAYED_WORK(&bp->fw_reset_task, bnxt_fw_reset_task);
 
 	spin_lock_init(&bp->ntp_fltr_lock);
+	spin_lock_init(&bp->stats_lock);
 #if BITS_PER_LONG == 32
 	spin_lock_init(&bp->db_lock);
 #endif
@@ -15217,6 +15261,7 @@ static void bnxt_get_queue_stats_rx(struct net_device *dev, int i,
 	if (!bp->bnapi)
 		return;
 
+	bnxt_sync_ring_stats(bp);
 	cpr = &bp->bnapi[i]->cp_ring;
 	sw = cpr->stats.sw_stats;
 
@@ -15245,6 +15290,7 @@ static void bnxt_get_queue_stats_tx(struct net_device *dev, int i,
 	if (!bp->tx_ring)
 		return;
 
+	bnxt_sync_ring_stats(bp);
 	bnapi = bp->tx_ring[bp->tx_ring_map[i]].bnapi;
 	sw = bnapi->cp_ring.stats.sw_stats;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 2cd96fe055a6e6..37fb74f18eeeca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2518,6 +2518,10 @@ struct bnxt {
 #define BNXT_MIN_STATS_COAL_TICKS	  250000
 #define BNXT_MAX_STATS_COAL_TICKS	 1000000
 
+	/* Protects stats_updated_jiffies and writes to sw_stats */
+	spinlock_t		stats_lock;
+	unsigned long		stats_updated_jiffies;
+
 	struct work_struct	sp_task;
 	unsigned long		sp_event;
 #define BNXT_RX_MASK_SP_EVENT		0
@@ -2866,6 +2870,7 @@ void bnxt_reenable_sriov(struct bnxt *bp);
 void bnxt_close_nic(struct bnxt *, bool, bool);
 void bnxt_get_ring_drv_stats(struct bnxt *bp,
 			     struct bnxt_total_ring_drv_stats *stats);
+void bnxt_sync_ring_stats(struct bnxt *bp);
 bool bnxt_rfs_capable(struct bnxt *bp, bool new_rss_ctx);
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
 			 u32 *reg_buf);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 4c18a310cf00c9..d883e2e57da09e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -604,6 +604,7 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 		goto skip_ring_stats;
 	}
 
+	bnxt_sync_ring_stats(bp);
 	tpa_stats = bnxt_get_num_tpa_ring_stats(bp);
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
-- 
2.53.0



