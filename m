Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3605E399011;
	Thu, 15 Jan 2026 17:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497679; cv=none; b=tmKI/TVW9gy6Pm28PhhjRo4IX+wmHRjk83xjG5FrFtQ6IjP9sFsbs9avdtfhUbHLXXhLhCvI1+DcjkPk1dnIsqfaDt3ioO+CeXWyEOWaMzMcqXHTrO01cJVplBpa8crtIUcmdBX2WDz0JWVKM+1urpEdhnGmIxdO+qPpBDD+Jb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497679; c=relaxed/simple;
	bh=ngRU1y5MAzG9MryjKZrEG5yV9TE2JF7/8BisL0HekZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZBpI+i8pELTmQHAHRkC0lCseMkJCe28JBPmZyZqX0oYJANuGrvX5dwKlDjrJZMXG+TMzIjtRJ/UyJbIHLm0kSh0ZuoB+rNkoRaqu0nDL8kDASQ6c02EUvgE8MfsYnmIrBxVMQkmx6O0rwCNAZyMXetDYtz8HfCvfQnZwCfK00ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZuhkr24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZuhkr24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7510C116D0;
	Thu, 15 Jan 2026 17:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497679;
	bh=ngRU1y5MAzG9MryjKZrEG5yV9TE2JF7/8BisL0HekZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZuhkr245rzlyp170qUzN+tp1ltHnrARcWYmLSaV9k6z3swkJULA2M4bmsy3WZaSD
	 BoDb7WGjKF/7zdqOFG6tz/rNSzdmgGrnaDpIDgy2mz650kwn31iwwX+7bGhXnlfyDX
	 UDfyX5kxmCMc5n/XHPbIwzYozTg3K0oH37eeuQIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/554] net/sched: sch_cake: Fix incorrect qlen reduction in cake_drop
Date: Thu, 15 Jan 2026 17:43:50 +0100
Message-ID: <20260115164252.204502277@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 9fefc78f7f02d71810776fdeb119a05a946a27cc ]

In cake_drop(), qdisc_tree_reduce_backlog() is used to update the qlen
and backlog of the qdisc hierarchy. Its caller, cake_enqueue(), assumes
that the parent qdisc will enqueue the current packet. However, this
assumption breaks when cake_enqueue() returns NET_XMIT_CN: the parent
qdisc stops enqueuing current packet, leaving the tree qlen/backlog
accounting inconsistent. This mismatch can lead to a NULL dereference
(e.g., when the parent Qdisc is qfq_qdisc).

This patch computes the qlen/backlog delta in a more robust way by
observing the difference before and after the series of cake_drop()
calls, and then compensates the qdisc tree accounting if cake_enqueue()
returns NET_XMIT_CN.

To ensure correct compensation when ACK thinning is enabled, a new
variable is introduced to keep qlen unchanged.

Fixes: 15de71d06a40 ("net/sched: Make cake_enqueue return NET_XMIT_CN when past buffer_limit")
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20251128001415.377823-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 58 ++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 73b840762afb2..cfeda7b50cc2e 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1608,7 +1608,6 @@ static unsigned int cake_drop(struct Qdisc *sch, struct sk_buff **to_free)
 
 	__qdisc_drop(skb, to_free);
 	sch->q.qlen--;
-	qdisc_tree_reduce_backlog(sch, 1, len);
 
 	cake_heapify(q, 0);
 
@@ -1754,14 +1753,14 @@ static void cake_reconfigure(struct Qdisc *sch);
 static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			struct sk_buff **to_free)
 {
+	u32 idx, tin, prev_qlen, prev_backlog, drop_id;
 	struct cake_sched_data *q = qdisc_priv(sch);
-	int len = qdisc_pkt_len(skb);
-	int ret;
+	int len = qdisc_pkt_len(skb), ret;
 	struct sk_buff *ack = NULL;
 	ktime_t now = ktime_get();
 	struct cake_tin_data *b;
 	struct cake_flow *flow;
-	u32 idx, tin;
+	bool same_flow = false;
 
 	/* choose flow to insert into */
 	idx = cake_classify(sch, &b, skb, q->flow_mode, &ret);
@@ -1834,6 +1833,8 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		consume_skb(skb);
 	} else {
 		/* not splitting */
+		int ack_pkt_len = 0;
+
 		cobalt_set_enqueue_time(skb, now);
 		get_cobalt_cb(skb)->adjusted_len = cake_overhead(q, skb);
 		flow_queue_add(flow, skb);
@@ -1844,13 +1845,13 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		if (ack) {
 			b->ack_drops++;
 			sch->qstats.drops++;
-			b->bytes += qdisc_pkt_len(ack);
-			len -= qdisc_pkt_len(ack);
+			ack_pkt_len = qdisc_pkt_len(ack);
+			b->bytes += ack_pkt_len;
 			q->buffer_used += skb->truesize - ack->truesize;
 			if (q->rate_flags & CAKE_FLAG_INGRESS)
 				cake_advance_shaper(q, b, ack, now, true);
 
-			qdisc_tree_reduce_backlog(sch, 1, qdisc_pkt_len(ack));
+			qdisc_tree_reduce_backlog(sch, 1, ack_pkt_len);
 			consume_skb(ack);
 		} else {
 			sch->q.qlen++;
@@ -1859,11 +1860,11 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		/* stats */
 		b->packets++;
-		b->bytes	    += len;
-		b->backlogs[idx]    += len;
-		b->tin_backlog      += len;
-		sch->qstats.backlog += len;
-		q->avg_window_bytes += len;
+		b->bytes	    += len - ack_pkt_len;
+		b->backlogs[idx]    += len - ack_pkt_len;
+		b->tin_backlog      += len - ack_pkt_len;
+		sch->qstats.backlog += len - ack_pkt_len;
+		q->avg_window_bytes += len - ack_pkt_len;
 	}
 
 	if (q->overflow_timeout)
@@ -1938,24 +1939,29 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (q->buffer_used > q->buffer_max_used)
 		q->buffer_max_used = q->buffer_used;
 
-	if (q->buffer_used > q->buffer_limit) {
-		bool same_flow = false;
-		u32 dropped = 0;
-		u32 drop_id;
+	if (q->buffer_used <= q->buffer_limit)
+		return NET_XMIT_SUCCESS;
 
-		while (q->buffer_used > q->buffer_limit) {
-			dropped++;
-			drop_id = cake_drop(sch, to_free);
+	prev_qlen = sch->q.qlen;
+	prev_backlog = sch->qstats.backlog;
 
-			if ((drop_id >> 16) == tin &&
-			    (drop_id & 0xFFFF) == idx)
-				same_flow = true;
-		}
-		b->drop_overlimit += dropped;
+	while (q->buffer_used > q->buffer_limit) {
+		drop_id = cake_drop(sch, to_free);
+		if ((drop_id >> 16) == tin &&
+		    (drop_id & 0xFFFF) == idx)
+			same_flow = true;
+	}
+
+	prev_qlen -= sch->q.qlen;
+	prev_backlog -= sch->qstats.backlog;
+	b->drop_overlimit += prev_qlen;
 
-		if (same_flow)
-			return NET_XMIT_CN;
+	if (same_flow) {
+		qdisc_tree_reduce_backlog(sch, prev_qlen - 1,
+					  prev_backlog - len);
+		return NET_XMIT_CN;
 	}
+	qdisc_tree_reduce_backlog(sch, prev_qlen, prev_backlog);
 	return NET_XMIT_SUCCESS;
 }
 
-- 
2.51.0



