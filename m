Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFF73839B2;
	Thu, 30 Jul 2026 15:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426562; cv=none; b=qnaSRmuSRLtVpqQenHjgG8kNxpVIDhcIJhyrXY47G4uYhRIQR0Pki+uwzDB2TcChe1tmdIVl/VRe/kNXJ4v+F8lnfnDoFXJ/nKsC7TwpzXXraK9g/2/QfuNF28lAhdN/tTOkf5RgqTdJ7ZNqIlyrVIK9x+X/TnNe4/ErQ+VymT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426562; c=relaxed/simple;
	bh=ZhdwxmGhUl2i6LA+lTUa9KTdovMj2ID/P4CmjLBsh3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiLPGnb60W20Vwfg9ZieSWvPd5KiIjO/Ybg6vxJxLN59RzDK0mOACSyZsf61ty++4z4ep4YHMDW3ZJjoiWWPQUoBy4Nd1kaOttFLr/PVGWxKvPHXawzWKg0m4K/XFjSQRNJA+L7Ekly5QMqu8Ujzj5vnQWXOlkxVMW/v19jJyWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1ORepkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1ORepkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED00C1F000E9;
	Thu, 30 Jul 2026 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426561;
	bh=TRjOr+gZVbc//ti/vX9dJepp8BT1RO46sbez6fu4iFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1ORepkOPuMUYt3c1MBECUu+ILTUS8CRYs1a+6K1RVJaF7M1pTVawNoX8lJljDHN7
	 mk5h8ytpg8TJcq9KO51pWrZJQU+JDiTVbxd1twaK8Xe3ZpJwJX/Y/aPvTXEWDDOOMe
	 tmVdVjteZAN7SZtYAKnxcpz/sebkgZS4FUap/aCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rhee <jordanrhee@google.com>,
	Eddie Phillips <eddiephillips@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 461/602] gve: fix Rx queue stall on alloc failure
Date: Thu, 30 Jul 2026 16:14:13 +0200
Message-ID: <20260730141445.646041045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Eddie Phillips <eddiephillips@google.com>

commit b65352a1bac64442ad95e64f385b40ccb9f1b0db upstream.

When the system is under extreme memory pressure, page allocations can
fail during the Rx buffer refill loop. If the number of buffers posted
to hardware falls below a critical low threshold and the refill loop
exits due to allocation failures, the queue can stall:

1. The device drops incoming packets because there are no descriptors.
2. Since no packets are processed, no Rx completions are generated.
3. Because no completions occur, NAPI is never scheduled, preventing
   the refill loop from running again even after memory is freed.

This results in a permanent queue stall.

Resolve this by introducing a starvation recovery timer for each Rx queue.
If the number of buffers posted to hardware falls below a critical low
threshold, start a timer to periodically reschedule NAPI. Once NAPI runs
and successfully refills the queue above the threshold, the timer is
not rescheduled.

The threshold is set to 32 because a single maximum-sized Receive Segment
Coalescing (RSC) packet can consume up to 19 descriptors in the Rx path.
Lower thresholds (such as 8 or 16) would be insufficient to process a
complete maximum-sized RSC packet, risking packet drops or unexpected
hardware behavior under memory pressure. Setting the threshold to 32
guarantees a safe margin to handle at least one full RSC packet.

Cc: stable@vger.kernel.org
Fixes: 9b8dd5e5ea48 ("gve: DQO: Add RX path")
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Signed-off-by: Eddie Phillips <eddiephillips@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://patch.msgid.link/20260709211906.3322883-1-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve.h        |  3 ++
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 36 ++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 8ddd366d9fde54..e19d722e8e9a18 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -12,6 +12,7 @@
 #include <linux/ethtool_netlink.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
+#include <linux/timer.h>
 #include <linux/u64_stats_sync.h>
 #include <net/xdp.h>
 
@@ -38,6 +39,7 @@
 
 /* Interval to schedule a stats report update, 20000ms. */
 #define GVE_STATS_REPORT_TIMER_PERIOD	20000
+#define GVE_RX_NAPI_RESCHED_MS 20 /* msecs */
 
 /* Numbers of NIC tx/rx stats in stats report. */
 #define NIC_TX_STATS_REPORT_NUM	0
@@ -311,6 +313,7 @@ struct gve_rx_ring {
 	struct xdp_rxq_info xsk_rxq;
 	struct xsk_buff_pool *xsk_pool;
 	struct page_frag_cache page_cache; /* Page cache to allocate XDP frames */
+	struct timer_list starvation_timer; /* for queue starvation recovery */
 };
 
 /* A TX desc ring entry */
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 1154c1d8f66f05..2f7f31e4797cd2 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -199,6 +199,16 @@ static int gve_alloc_page_dqo(struct gve_rx_ring *rx,
 	return 0;
 }
 
+static void gve_rx_starvation_timer(struct timer_list *t)
+{
+	struct gve_rx_ring *rx = from_timer(rx, t, starvation_timer);
+	struct gve_priv *priv = rx->gve;
+	struct gve_notify_block *block;
+
+	block = &priv->ntfy_blocks[rx->ntfy_id];
+	napi_schedule(&block->napi);
+}
+
 static void gve_rx_free_hdr_bufs(struct gve_priv *priv, struct gve_rx_ring *rx)
 {
 	struct device *hdev = &priv->pdev->dev;
@@ -290,10 +300,13 @@ static void gve_rx_reset_ring_dqo(struct gve_priv *priv, int idx)
 void gve_rx_stop_ring_dqo(struct gve_priv *priv, int idx)
 {
 	int ntfy_idx = gve_rx_idx_to_ntfy(priv, idx);
+	struct gve_rx_ring *rx = &priv->rx[idx];
 
 	if (!gve_rx_was_added_to_block(priv, idx))
 		return;
 
+	timer_shutdown_sync(&rx->starvation_timer);
+
 	gve_remove_napi(priv, ntfy_idx);
 	gve_rx_remove_from_block(priv, idx);
 	gve_rx_reset_ring_dqo(priv, idx);
@@ -371,8 +384,10 @@ static int gve_rx_alloc_hdr_bufs(struct gve_priv *priv, struct gve_rx_ring *rx,
 void gve_rx_start_ring_dqo(struct gve_priv *priv, int idx)
 {
 	int ntfy_idx = gve_rx_idx_to_ntfy(priv, idx);
+	struct gve_rx_ring *rx = &priv->rx[idx];
 
 	gve_rx_add_to_block(priv, idx);
+	timer_setup(&rx->starvation_timer, gve_rx_starvation_timer, 0);
 	gve_add_napi(priv, ntfy_idx, gve_napi_poll_dqo);
 }
 
@@ -511,6 +526,7 @@ void gve_rx_post_buffers_dqo(struct gve_rx_ring *rx)
 	struct gve_rx_compl_queue_dqo *complq = &rx->dqo.complq;
 	struct gve_rx_buf_queue_dqo *bufq = &rx->dqo.bufq;
 	struct gve_priv *priv = rx->gve;
+	u32 num_bufs_avail_to_hw;
 	u32 num_avail_slots;
 	u32 num_full_slots;
 	u32 num_posted = 0;
@@ -555,6 +571,26 @@ void gve_rx_post_buffers_dqo(struct gve_rx_ring *rx)
 	}
 
 	rx->fill_cnt += num_posted;
+
+	/* If the queue has fewer than GVE_RX_BUF_THRESH_DQO descriptors
+	 * visible to the hardware, the hardware is in danger of starving
+	 * and cannot trigger interrupts.
+	 *
+	 * We use a threshold of 32 because a single maximum-sized RSC
+	 * packet can consume up to 19 descriptors in the Rx path. Lower
+	 * thresholds (e.g., 8 or 16) would be unsafe as they could cause
+	 * the device to drop/stall on a maximum-sized RSC packet.
+	 *
+	 * Start the timer to periodically reschedule NAPI and recover.
+	 */
+	num_bufs_avail_to_hw =
+		((bufq->tail & ~(GVE_RX_BUF_THRESH_DQO - 1)) -
+		 bufq->head) & bufq->mask;
+
+	if (num_bufs_avail_to_hw < GVE_RX_BUF_THRESH_DQO) {
+		mod_timer(&rx->starvation_timer,
+			  jiffies + msecs_to_jiffies(GVE_RX_NAPI_RESCHED_MS));
+	}
 }
 
 static void gve_try_recycle_buf(struct gve_priv *priv, struct gve_rx_ring *rx,
-- 
2.53.0



