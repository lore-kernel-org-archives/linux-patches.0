Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431F632D0E1;
	Mon, 27 Oct 2025 19:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592855; cv=none; b=bvsiWGEM69iujibSReoMqMoZzlKlloMfwGvdp+yfNO54DjUaVRd17M0cIPiuw2n1wj9abtDHkonTJjWMklfpg46lUSwcoK3nPe9grB7ujv9tvhxaCRgW5RzLn68lqw1oE4Q1qVgGaQ8Yz6gMybsxRbDi8hWH8ugFNr6LyIaSpM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592855; c=relaxed/simple;
	bh=WAXKDx+zs5PgQK6gB6wXkzPhl+LWU67Z6afcQVunLKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeZeym/NwCTKX8MlDzIP1y94mSwle9vyl2LQasmRzbw+SUxWp+pLtSOjRAbqxmFKRC1QHEMAK78xCUOJOSb2/je9Do+TcLuI3qMpuFuTYxzJYQafqVOjMrL+ndXXI/MzDMtcHYizE2LZhRRa1m4Q7gC5MT//uBuDbx2mqCCVlQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lW5KFjAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lW5KFjAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA53C4CEF1;
	Mon, 27 Oct 2025 19:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592854;
	bh=WAXKDx+zs5PgQK6gB6wXkzPhl+LWU67Z6afcQVunLKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lW5KFjAfHpO3npQ1oVWUCL47ueQW3QKTEaDZlc28fJuujnMGHfGsHqZQraDU9uf2F
	 zNfpv3UgFZb+hAT7/aU4KDdgDcrmPuPT/3rkRW9kHuQhG9mN9kNbJyb0ExwRXQNQWc
	 UnweyXb4p7dKrcrXY4Jwb1Lh/0hk5NdX6YLFl8Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aksh Garg <a-garg7@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/117] net: ethernet: ti: am65-cpts: fix timestamp loss due to race conditions
Date: Mon, 27 Oct 2025 19:36:04 +0100
Message-ID: <20251027183455.010876165@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Aksh Garg <a-garg7@ti.com>

[ Upstream commit 49d34f3dd8519581030547eb7543a62f9ab5fa08 ]

Resolve race conditions in timestamp events list handling between TX
and RX paths causing missed timestamps.

The current implementation uses a single events list for both TX and RX
timestamps. The am65_cpts_find_ts() function acquires the lock,
splices all events (TX as well as RX events) to a temporary list,
and releases the lock. This function performs matching of timestamps
for TX packets only. Before it acquires the lock again to put the
non-TX events back to the main events list, a concurrent RX
processing thread could acquire the lock (as observed in practice),
find an empty events list, and fail to attach timestamp to it,
even though a relevant event exists in the spliced list which is yet to
be restored to the main list.

Fix this by creating separate events lists to handle TX and RX
timestamps independently.

Fixes: c459f606f66df ("net: ethernet: ti: am65-cpts: Enable RX HW timestamp for PTP packets using CPTS FIFO")
Signed-off-by: Aksh Garg <a-garg7@ti.com>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://patch.msgid.link/20251016115755.1123646-1-a-garg7@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpts.c | 63 ++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 59d6ab989c554..8ffbfaa3ab18c 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -163,7 +163,9 @@ struct am65_cpts {
 	struct device_node *clk_mux_np;
 	struct clk *refclk;
 	u32 refclk_freq;
-	struct list_head events;
+	/* separate lists to handle TX and RX timestamp independently */
+	struct list_head events_tx;
+	struct list_head events_rx;
 	struct list_head pool;
 	struct am65_cpts_event pool_data[AM65_CPTS_MAX_EVENTS];
 	spinlock_t lock; /* protects events lists*/
@@ -227,6 +229,24 @@ static void am65_cpts_disable(struct am65_cpts *cpts)
 	am65_cpts_write32(cpts, 0, int_enable);
 }
 
+static int am65_cpts_purge_event_list(struct am65_cpts *cpts,
+				      struct list_head *events)
+{
+	struct list_head *this, *next;
+	struct am65_cpts_event *event;
+	int removed = 0;
+
+	list_for_each_safe(this, next, events) {
+		event = list_entry(this, struct am65_cpts_event, list);
+		if (time_after(jiffies, event->tmo)) {
+			list_del_init(&event->list);
+			list_add(&event->list, &cpts->pool);
+			++removed;
+		}
+	}
+	return removed;
+}
+
 static int am65_cpts_event_get_port(struct am65_cpts_event *event)
 {
 	return (event->event1 & AM65_CPTS_EVENT_1_PORT_NUMBER_MASK) >>
@@ -239,20 +259,12 @@ static int am65_cpts_event_get_type(struct am65_cpts_event *event)
 		AM65_CPTS_EVENT_1_EVENT_TYPE_SHIFT;
 }
 
-static int am65_cpts_cpts_purge_events(struct am65_cpts *cpts)
+static int am65_cpts_purge_events(struct am65_cpts *cpts)
 {
-	struct list_head *this, *next;
-	struct am65_cpts_event *event;
 	int removed = 0;
 
-	list_for_each_safe(this, next, &cpts->events) {
-		event = list_entry(this, struct am65_cpts_event, list);
-		if (time_after(jiffies, event->tmo)) {
-			list_del_init(&event->list);
-			list_add(&event->list, &cpts->pool);
-			++removed;
-		}
-	}
+	removed += am65_cpts_purge_event_list(cpts, &cpts->events_tx);
+	removed += am65_cpts_purge_event_list(cpts, &cpts->events_rx);
 
 	if (removed)
 		dev_dbg(cpts->dev, "event pool cleaned up %d\n", removed);
@@ -287,7 +299,7 @@ static int __am65_cpts_fifo_read(struct am65_cpts *cpts)
 						 struct am65_cpts_event, list);
 
 		if (!event) {
-			if (am65_cpts_cpts_purge_events(cpts)) {
+			if (am65_cpts_purge_events(cpts)) {
 				dev_err(cpts->dev, "cpts: event pool empty\n");
 				ret = -1;
 				goto out;
@@ -306,11 +318,21 @@ static int __am65_cpts_fifo_read(struct am65_cpts *cpts)
 				cpts->timestamp);
 			break;
 		case AM65_CPTS_EV_RX:
+			event->tmo = jiffies +
+				msecs_to_jiffies(AM65_CPTS_EVENT_RX_TX_TIMEOUT);
+
+			list_move_tail(&event->list, &cpts->events_rx);
+
+			dev_dbg(cpts->dev,
+				"AM65_CPTS_EV_RX e1:%08x e2:%08x t:%lld\n",
+				event->event1, event->event2,
+				event->timestamp);
+			break;
 		case AM65_CPTS_EV_TX:
 			event->tmo = jiffies +
 				msecs_to_jiffies(AM65_CPTS_EVENT_RX_TX_TIMEOUT);
 
-			list_move_tail(&event->list, &cpts->events);
+			list_move_tail(&event->list, &cpts->events_tx);
 
 			dev_dbg(cpts->dev,
 				"AM65_CPTS_EV_TX e1:%08x e2:%08x t:%lld\n",
@@ -828,7 +850,7 @@ static bool am65_cpts_match_tx_ts(struct am65_cpts *cpts,
 	return found;
 }
 
-static void am65_cpts_find_ts(struct am65_cpts *cpts)
+static void am65_cpts_find_tx_ts(struct am65_cpts *cpts)
 {
 	struct am65_cpts_event *event;
 	struct list_head *this, *next;
@@ -837,7 +859,7 @@ static void am65_cpts_find_ts(struct am65_cpts *cpts)
 	LIST_HEAD(events);
 
 	spin_lock_irqsave(&cpts->lock, flags);
-	list_splice_init(&cpts->events, &events);
+	list_splice_init(&cpts->events_tx, &events);
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
 	list_for_each_safe(this, next, &events) {
@@ -850,7 +872,7 @@ static void am65_cpts_find_ts(struct am65_cpts *cpts)
 	}
 
 	spin_lock_irqsave(&cpts->lock, flags);
-	list_splice_tail(&events, &cpts->events);
+	list_splice_tail(&events, &cpts->events_tx);
 	list_splice_tail(&events_free, &cpts->pool);
 	spin_unlock_irqrestore(&cpts->lock, flags);
 }
@@ -861,7 +883,7 @@ static long am65_cpts_ts_work(struct ptp_clock_info *ptp)
 	unsigned long flags;
 	long delay = -1;
 
-	am65_cpts_find_ts(cpts);
+	am65_cpts_find_tx_ts(cpts);
 
 	spin_lock_irqsave(&cpts->txq.lock, flags);
 	if (!skb_queue_empty(&cpts->txq))
@@ -905,7 +927,7 @@ static u64 am65_cpts_find_rx_ts(struct am65_cpts *cpts, u32 skb_mtype_seqid)
 
 	spin_lock_irqsave(&cpts->lock, flags);
 	__am65_cpts_fifo_read(cpts);
-	list_for_each_safe(this, next, &cpts->events) {
+	list_for_each_safe(this, next, &cpts->events_rx) {
 		event = list_entry(this, struct am65_cpts_event, list);
 		if (time_after(jiffies, event->tmo)) {
 			list_move(&event->list, &cpts->pool);
@@ -1155,7 +1177,8 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 		return ERR_PTR(ret);
 
 	mutex_init(&cpts->ptp_clk_lock);
-	INIT_LIST_HEAD(&cpts->events);
+	INIT_LIST_HEAD(&cpts->events_tx);
+	INIT_LIST_HEAD(&cpts->events_rx);
 	INIT_LIST_HEAD(&cpts->pool);
 	spin_lock_init(&cpts->lock);
 	skb_queue_head_init(&cpts->txq);
-- 
2.51.0



