Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455D23515CB;
	Sat, 12 Sep 2026 11:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212405; cv=none; b=n3e9JO7eugK7P1PAlHj9pHW4ePOl+ObPV+hP60/cOmVHfINjiSxaQ1QbPKD4t+g5q8aatY0YaAOX5LFld/hLtuKa+qW/uE6fzNTM63c5PdNRRtsSqkJ9peX0FHkgXgZNJKeY3I6cuF3xdrN6QypYflgABL1LX2R4uqB3nMxn3NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212405; c=relaxed/simple;
	bh=FOgJTJ+nlt9CTsn5BUGeYqlYLLRgNfyiqt1L12ZueOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKcmroU0H4tqtNI3jRQo/f5WFejE8T9dGgylSHyKVuaNnZnCurc4ZQ/bVQcPdVR/HK2QJQfDE2OIAFAo02YMhwj2Xzps3Qe/DP8dGxoWnN46KplK64zw9HXcBWCOUqwVwLsafSDFgQi6xhAY+nFje56cvQzU5hdV87evk4WTlfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjAxZQX9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjAxZQX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3861F000FF;
	Sat, 12 Sep 2026 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212401;
	bh=bhYrINGwUOCAWRywzr/CS6rSFRdsqNJnCH/ohx/i68E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjAxZQX9l9FXgDn5pfxKA9zUKXrF8caddZuZ2tAYVcVcdl/JLzcHFR+yy1YLsZN4t
	 QVkvIMZagITllNaYctbC8SublYaaQg1CMF2lFLofEgI98EW6NNE1ZGr5EheVP45m2Q
	 13MMRnBOXA0vOb67YfzxfX5HAxjYzQfl7nMe5Mn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1376/1518] net: wangxun: introduce WX_STATE_DOWN to serialize device shutdown state
Date: Sat, 12 Sep 2026 08:59:05 +0200
Message-ID: <20260912065654.670828124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 7116ffb48ad0af7a6d066c3e80329270920858fe ]

Replace various netif_running() checks with an explicit WX_STATE_DOWN
state bit to track whether the device datapath and interrupt handling
are operational.

The previous logic relied on netif_running() to gate interrupt
reenablement, queue wakeups, statistics updates, and service task
execution. However, netif_running() only reflects the administrative
state of the netdevice and does not fully serialize against teardown
and reset paths. During device shutdown and reset flows, asynchronous
contexts such as interrupt handlers, NAPI poll, and service work could
still observe netif_running() as true while device resources were
already being disabled or freed.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260525100543.27140-2-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 7bf29145d7a9 ("net: txgbe: fix MISC interrupt unmasking in non-MSI-X mode and device shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c        |  3 ++-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c       |  9 ++++++---
 drivers/net/ethernet/wangxun/libwx/wx_sriov.c     |  2 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h      |  1 +
 drivers/net/ethernet/wangxun/libwx/wx_vf_common.c |  8 ++++++--
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c     | 12 ++++++++----
 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c    |  2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c   |  4 ++++
 8 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index e28bf4b6737ed..dece90d3469e9 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -2512,6 +2512,7 @@ int wx_sw_init(struct wx *wx)
 	mutex_init(&wx->reset_lock);
 	bitmap_zero(wx->state, WX_STATE_NBITS);
 	bitmap_zero(wx->flags, WX_PF_FLAGS_NBITS);
+	set_bit(WX_STATE_DOWN, wx->state);
 	wx->misc_irq_domain = false;
 
 	return 0;
@@ -2841,7 +2842,7 @@ void wx_update_stats(struct wx *wx)
 	u64 restart_queue = 0, tx_busy = 0;
 	u32 i;
 
-	if (!netif_running(wx->netdev) ||
+	if (test_bit(WX_STATE_DOWN, wx->state) ||
 	    test_bit(WX_STATE_RESETTING, wx->state))
 		return;
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 0408738c029b6..4a6851612368d 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -872,7 +872,7 @@ static bool wx_clean_tx_irq(struct wx_q_vector *q_vector,
 
 		if (__netif_subqueue_stopped(tx_ring->netdev,
 					     tx_ring->queue_index) &&
-		    netif_running(tx_ring->netdev)) {
+		    !test_bit(WX_STATE_DOWN, wx->state)) {
 			netif_wake_subqueue(tx_ring->netdev,
 					    tx_ring->queue_index);
 			++tx_ring->tx_stats.restart_queue;
@@ -960,7 +960,7 @@ static int wx_poll(struct napi_struct *napi, int budget)
 	if (likely(napi_complete_done(napi, work_done))) {
 		if (wx->adaptive_itr)
 			wx_update_dim_sample(q_vector);
-		if (netif_running(wx->netdev))
+		if (!test_bit(WX_STATE_DOWN, wx->state))
 			wx_intr_enable(wx, WX_INTR_Q(q_vector->v_idx));
 	}
 
@@ -2339,6 +2339,8 @@ int wx_init_interrupt_scheme(struct wx *wx)
 
 	wx_cache_ring_rss(wx);
 
+	set_bit(WX_STATE_DOWN, wx->state);
+
 	return 0;
 }
 EXPORT_SYMBOL(wx_init_interrupt_scheme);
@@ -3280,7 +3282,8 @@ EXPORT_SYMBOL(wx_set_ring);
 
 void wx_service_event_schedule(struct wx *wx)
 {
-	if (!test_and_set_bit(WX_STATE_SERVICE_SCHED, wx->state))
+	if (!test_bit(WX_STATE_DOWN, wx->state) &&
+	    !test_and_set_bit(WX_STATE_SERVICE_SCHED, wx->state))
 		queue_work(system_power_efficient_wq, &wx->service_task);
 }
 EXPORT_SYMBOL(wx_service_event_schedule);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_sriov.c b/drivers/net/ethernet/wangxun/libwx/wx_sriov.c
index 493da5fffdb6e..6ce5d5936d588 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_sriov.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_sriov.c
@@ -900,7 +900,7 @@ static void wx_set_vf_link_state(struct wx *wx, int vf, int state)
 	wx->vfinfo[vf].link_state = state;
 	switch (state) {
 	case IFLA_VF_LINK_STATE_AUTO:
-		if (netif_running(wx->netdev))
+		if (!test_bit(WX_STATE_DOWN, wx->state))
 			wx->vfinfo[vf].link_enable = true;
 		else
 			wx->vfinfo[vf].link_enable = false;
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 158a20b96960e..0788cf57e3d4a 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -1178,6 +1178,7 @@ struct wx_hw_stats {
 };
 
 enum wx_state {
+	WX_STATE_DOWN,
 	WX_STATE_RESETTING,
 	WX_STATE_SWFW_BUSY,
 	WX_STATE_PTP_RUNNING,
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c b/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
index bf3424ec43d9b..11ee2436b9c94 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
@@ -67,7 +67,7 @@ static irqreturn_t wx_msix_misc_vf(int __always_unused irq, void *data)
 
 	set_bit(WX_FLAG_NEED_UPDATE_LINK, wx->flags);
 	/* Clear the interrupt */
-	if (netif_running(wx->netdev))
+	if (!test_bit(WX_STATE_DOWN, wx->state))
 		wr32(wx, WX_VXIMC, wx->eims_other);
 
 	return IRQ_HANDLED;
@@ -277,6 +277,7 @@ static void wxvf_up_complete(struct wx *wx)
 
 	wx_configure_msix_vf(wx);
 	smp_mb__before_atomic();
+	clear_bit(WX_STATE_DOWN, wx->state);
 	wx_napi_enable_all(wx);
 
 	/* clear any pending interrupts, may auto mask */
@@ -326,6 +327,9 @@ static void wxvf_down(struct wx *wx)
 {
 	struct net_device *netdev = wx->netdev;
 
+	if (test_and_set_bit(WX_STATE_DOWN, wx->state))
+		return;
+
 	timer_delete_sync(&wx->service_timer);
 	netif_tx_stop_all_queues(netdev);
 	netif_tx_disable(netdev);
@@ -359,7 +363,7 @@ static void wxvf_reset_subtask(struct wx *wx)
 
 	rtnl_lock();
 	if (test_bit(WX_STATE_RESETTING, wx->state) ||
-	    !(netif_running(wx->netdev))) {
+	    test_bit(WX_STATE_DOWN, wx->state)) {
 		rtnl_unlock();
 		return;
 	}
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 55f52a0483554..35d7a0c76ca07 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -206,7 +206,7 @@ static irqreturn_t ngbe_intr(int __always_unused irq, void *data)
 		/* shared interrupt alert!
 		 * the interrupt that we masked before the EICR read.
 		 */
-		if (netif_running(wx->netdev))
+		if (!test_bit(WX_STATE_DOWN, wx->state))
 			ngbe_irq_enable(wx, true);
 		return IRQ_NONE;        /* Not our interrupt */
 	}
@@ -222,7 +222,7 @@ static irqreturn_t ngbe_intr(int __always_unused irq, void *data)
 	/* would disable interrupts here but it is auto disabled */
 	napi_schedule_irqoff(&q_vector->napi);
 
-	if (netif_running(wx->netdev))
+	if (!test_bit(WX_STATE_DOWN, wx->state))
 		ngbe_irq_enable(wx, false);
 
 	return IRQ_HANDLED;
@@ -237,7 +237,7 @@ static irqreturn_t __ngbe_msix_misc(struct wx *wx, u32 eicr)
 		wx_ptp_check_pps_event(wx);
 
 	/* re-enable the original interrupt state, no lsc, no queues */
-	if (netif_running(wx->netdev))
+	if (!test_bit(WX_STATE_DOWN, wx->state))
 		ngbe_irq_enable(wx, false);
 
 	return IRQ_HANDLED;
@@ -264,7 +264,7 @@ static irqreturn_t ngbe_misc_and_queue(int __always_unused irq, void *data)
 		/* queue */
 		q_vector = wx->q_vector[0];
 		napi_schedule_irqoff(&q_vector->napi);
-		if (netif_running(wx->netdev))
+		if (!test_bit(WX_STATE_DOWN, wx->state))
 			ngbe_irq_enable(wx, true);
 		return IRQ_HANDLED;
 	}
@@ -365,6 +365,9 @@ static void ngbe_disable_device(struct wx *wx)
 	struct net_device *netdev = wx->netdev;
 	u32 i;
 
+	if (test_and_set_bit(WX_STATE_DOWN, wx->state))
+		return;
+
 	if (wx->num_vfs) {
 		/* Clear EITR Select mapping */
 		wr32(wx, WX_PX_ITRSEL, 0);
@@ -430,6 +433,7 @@ void ngbe_up(struct wx *wx)
 
 	/* make sure to complete pre-operations */
 	smp_mb__before_atomic();
+	clear_bit(WX_STATE_DOWN, wx->state);
 	wx_napi_enable_all(wx);
 	/* enable transmits */
 	netif_tx_start_all_queues(wx->netdev);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
index 3885283681ec7..6f29d35b767f3 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c
@@ -141,7 +141,7 @@ static irqreturn_t txgbe_misc_irq_handle(int irq, void *data)
 		/* shared interrupt alert!
 		 * the interrupt that we masked before the ICR read.
 		 */
-		if (netif_running(wx->netdev))
+		if (!test_bit(WX_STATE_DOWN, wx->state))
 			txgbe_irq_enable(wx, true);
 		return IRQ_NONE;        /* Not our interrupt */
 	}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 8362878e4b058..9d32c4a7f1e97 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -152,6 +152,7 @@ static void txgbe_up_complete(struct wx *wx)
 
 	/* make sure to complete pre-operations */
 	smp_mb__before_atomic();
+	clear_bit(WX_STATE_DOWN, wx->state);
 	wx_napi_enable_all(wx);
 
 	switch (wx->mac.type) {
@@ -218,6 +219,9 @@ static void txgbe_disable_device(struct wx *wx)
 	struct net_device *netdev = wx->netdev;
 	u32 i;
 
+	if (test_and_set_bit(WX_STATE_DOWN, wx->state))
+		return;
+
 	wx_disable_pcie_master(wx);
 	/* disable receives */
 	wx_disable_rx(wx);
-- 
2.53.0



