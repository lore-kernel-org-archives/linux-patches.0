Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A5D3AAF6D;
	Mon, 17 Aug 2026 15:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979661; cv=none; b=LNGp40tA43SY6j1+ewQ4mpPHql1cstNgIogb6p94+gGvo7ydsC5nAiq2YrAzvjRCnCHfPSLJOF7Gf3I2Bmr9Jd1mgWi4Xcfb4Cihojr40MbbYw/R9eQBRQhKWSZJN9r9mt+mIGrFb6rVFib4b2ksO6ewaUijBvH27QYVuyQC26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979661; c=relaxed/simple;
	bh=Ltg4bekqPBmdeDsatwu7rrWej6xnI1ViMqbMyAVo+jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTz4z9szbmrP74pGjx19pPx6XfCTC5hQQ6MY6+s5zhZvfrSHZP6LFRkM07avQ0fCvDT8Syz3OijsmXY7XcXJapaXTH2Q5+lbaGVJp8OpMKGMNB7JxZ7A0AZrxEo+FvTlTnzyPtKNiKhksuunxmxiK/XAVMoAB/+0kVPM5843Cpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVgpJqNo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVgpJqNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0A61F000E9;
	Mon, 17 Aug 2026 15:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979659;
	bh=9Ko1D2wSrCog8/IscIiM9J/aNKFJIytswxzny9ahvzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVgpJqNojCmE0IdTnE0H0iohN4vGVBxuZP9/GaoNIQ1qaSkAcuA5mboir61yDtpSg
	 zJUvFX7j0DCehRflXZWTArTO619wcHHZHSOY2BY3dEpWF1deZigKc+O+5ksk8/Ks48
	 xzsEQwO5AgczaLu+N8ZqidiZQBMdl5BoeOauO4C8=
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
Subject: [PATCH 6.1 303/609] gve: fix Rx queue stall on alloc failure
Date: Mon, 17 Aug 2026 15:29:59 +0200
Message-ID: <20260817132554.379053740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
 drivers/net/ethernet/google/gve/gve_main.c   |  3 ++
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 33 ++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index c5e1312b9283..7de492b0d361 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -10,6 +10,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
+#include <linux/timer.h>
 #include <linux/u64_stats_sync.h>
 
 #include "gve_desc.h"
@@ -35,6 +36,7 @@
 
 /* Interval to schedule a stats report update, 20000ms. */
 #define GVE_STATS_REPORT_TIMER_PERIOD	20000
+#define GVE_RX_NAPI_RESCHED_MS 20 /* msecs */
 
 /* Numbers of NIC tx/rx stats in stats report. */
 #define NIC_TX_STATS_REPORT_NUM	0
@@ -226,6 +228,7 @@ struct gve_rx_ring {
 	struct u64_stats_sync statss; /* sync stats for 32bit archs */
 
 	struct gve_rx_ctx ctx; /* Info for packet currently being processed in this ring. */
+	struct timer_list starvation_timer; /* for queue starvation recovery */
 };
 
 /* A TX desc ring entry */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 209e9526a6fd..fc2a516a3bee 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -529,6 +529,9 @@ static void gve_remove_napi(struct gve_priv *priv, int ntfy_idx)
 {
 	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
+	if (block->rx && !gve_is_gqi(priv))
+		timer_shutdown_sync(&block->rx->starvation_timer);
+
 	netif_napi_del(&block->napi);
 	disable_irq(block->irq);
 }
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 0a36b284de10..adae0f5181ea 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -16,6 +16,16 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 
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
 static int gve_buf_ref_cnt(struct gve_rx_buf_state_dqo *bs)
 {
 	return page_count(bs->page_info.page) - bs->page_info.pagecnt_bias;
@@ -185,6 +195,7 @@ static void gve_rx_free_ring_dqo(struct gve_priv *priv, int idx)
 	completion_queue_slots = rx->dqo.complq.mask + 1;
 	buffer_queue_slots = rx->dqo.bufq.mask + 1;
 
+	timer_shutdown_sync(&rx->starvation_timer);
 	gve_rx_remove_from_block(priv, idx);
 
 	if (rx->q_resources) {
@@ -237,6 +248,7 @@ static int gve_rx_alloc_ring_dqo(struct gve_priv *priv, int idx)
 	memset(rx, 0, sizeof(*rx));
 	rx->gve = priv;
 	rx->q_num = idx;
+	timer_setup(&rx->starvation_timer, gve_rx_starvation_timer, 0);
 	rx->dqo.bufq.mask = buffer_queue_slots - 1;
 	rx->dqo.complq.num_free_slots = completion_queue_slots;
 	rx->dqo.complq.mask = completion_queue_slots - 1;
@@ -337,6 +349,7 @@ void gve_rx_post_buffers_dqo(struct gve_rx_ring *rx)
 	u32 num_avail_slots;
 	u32 num_full_slots;
 	u32 num_posted = 0;
+	u32 num_bufs_avail_to_hw;
 
 	num_full_slots = (bufq->tail - bufq->head) & bufq->mask;
 	num_avail_slots = bufq->mask - num_full_slots;
@@ -374,6 +387,26 @@ void gve_rx_post_buffers_dqo(struct gve_rx_ring *rx)
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



