Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244332F6184;
	Sat, 30 May 2026 18:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166609; cv=none; b=ugtpYcL6AKyWmlIy9BJ/RKeJPB4k0PgamlGPS2tFNN/K6z+Osw963rwkt+e2b9cF+aNKqKn4cBCwJRlFDYaQynq9DCraCsm3XdZ1JPYFIYn49s7MzYpa1veP4eyuNVyG9TmSCQ04d2GGObIgtwSIAqUeEFk1hIvxtAZ0F4tjmCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166609; c=relaxed/simple;
	bh=f/QGURznALl3Et2/eBv88PWf/dGNamZzpbhjd3+DlxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyShUNr1+k5RB3bPLbDFk0VXpC9JAhvqnkjLnKTLsyEPC9jH9ns8qQwzrXDzVjkcPyxuY1YNLiYl8ofOfbDE4AKFtEt4HR62bhawE6sKJVVj5YuGUvNKuYc6Z9/mFsYu7X+QwjjTA2/Lvp9F3L1UMOcqBEhyEmkbHIrL3nVNAxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBEFuEsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBEFuEsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298111F00893;
	Sat, 30 May 2026 18:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166607;
	bh=AgedMDAmjdG7Jx6U86VE3t11YX/JaD/3+Fa3z4IhL88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nBEFuEsPKYtbbVufVMa1BUzDKhwUppaAptVRIaHCh1WOsGU8TiYehqqzmk/0Kx6db
	 ZlLhQ80DmDNSCnPZTuGUl0rLMYwkHuZcpWhyIUq8KrivFNozk9JN2I/a+8qYN+YfFC
	 mOFLnTDa+Dy4ceSx5j9eJfWV+tH0kc8mK8XvcfSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yannick Vignon <yannick.vignon@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/589] net: taprio offload: enforce qdisc to netdev queue mapping
Date: Sat, 30 May 2026 18:04:57 +0200
Message-ID: <20260530160235.683662456@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yannick Vignon <yannick.vignon@nxp.com>

[ Upstream commit 13511704f8d7591faf19fdb84f0902dff0535ccb ]

Even though the taprio qdisc is designed for multiqueue devices, all the
queues still point to the same top-level taprio qdisc. This works and is
probably required for software taprio, but at least with offload taprio,
it has an undesirable side effect: because the whole qdisc is run when a
packet has to be sent, it allows packets in a best-effort class to be
processed in the context of a task sending higher priority traffic. If
there are packets left in the qdisc after that first run, the NET_TX
softirq is raised and gets executed immediately in the same process
context. As with any other softirq, it runs up to 10 times and for up to
2ms, during which the calling process is waiting for the sendmsg call (or
similar) to return. In my use case, that calling process is a real-time
task scheduled to send a packet every 2ms, so the long sendmsg calls are
leading to missed timeslots.

By attaching each netdev queue to its own qdisc, as it is done with
the "classic" mq qdisc, each traffic class can be processed independently
without touching the other classes. A high-priority process can then send
packets without getting stuck in the sendmsg call anymore.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 105425b1969c ("net/sched: taprio: fix use-after-free in advance_sched() on schedule switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 85 ++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 40 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 66348b1083ed5..a92dab2fa6ff4 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -443,6 +443,11 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct Qdisc *child;
 	int queue;
 
+	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
+		WARN_ONCE(1, "Trying to enqueue skb into the root of a taprio qdisc configured with full offload\n");
+		return qdisc_drop(skb, sch, to_free);
+	}
+
 	queue = skb_get_queue_mapping(skb);
 
 	child = q->qdiscs[queue];
@@ -534,23 +539,7 @@ static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 
 static struct sk_buff *taprio_peek_offload(struct Qdisc *sch)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	struct sk_buff *skb;
-	int i;
-
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct Qdisc *child = q->qdiscs[i];
-
-		if (unlikely(!child))
-			continue;
-
-		skb = child->ops->peek(child);
-		if (!skb)
-			continue;
-
-		return skb;
-	}
+	WARN_ONCE(1, "Trying to peek into the root of a taprio qdisc configured with full offload\n");
 
 	return NULL;
 }
@@ -659,27 +648,7 @@ static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 
 static struct sk_buff *taprio_dequeue_offload(struct Qdisc *sch)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	struct sk_buff *skb;
-	int i;
-
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct Qdisc *child = q->qdiscs[i];
-
-		if (unlikely(!child))
-			continue;
-
-		skb = child->ops->dequeue(child);
-		if (unlikely(!skb))
-			continue;
-
-		qdisc_bstats_update(sch, skb);
-		qdisc_qstats_backlog_dec(sch, skb);
-		sch->q.qlen--;
-
-		return skb;
-	}
+	WARN_ONCE(1, "Trying to dequeue from the root of a taprio qdisc configured with full offload\n");
 
 	return NULL;
 }
@@ -1774,6 +1743,37 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	return taprio_change(sch, opt, extack);
 }
 
+static void taprio_attach(struct Qdisc *sch)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	unsigned int ntx;
+
+	/* Attach underlying qdisc */
+	for (ntx = 0; ntx < dev->num_tx_queues; ntx++) {
+		struct Qdisc *qdisc = q->qdiscs[ntx];
+		struct Qdisc *old;
+
+		if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+			qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
+			old = dev_graft_qdisc(qdisc->dev_queue, qdisc);
+			if (ntx < dev->real_num_tx_queues)
+				qdisc_hash_add(qdisc, false);
+		} else {
+			old = dev_graft_qdisc(qdisc->dev_queue, sch);
+			qdisc_refcount_inc(sch);
+		}
+		if (old)
+			qdisc_put(old);
+	}
+
+	/* access to the child qdiscs is not needed in offload mode */
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+		kfree(q->qdiscs);
+		q->qdiscs = NULL;
+	}
+}
+
 static struct netdev_queue *taprio_queue_get(struct Qdisc *sch,
 					     unsigned long cl)
 {
@@ -1800,8 +1800,12 @@ static int taprio_graft(struct Qdisc *sch, unsigned long cl,
 	if (dev->flags & IFF_UP)
 		dev_deactivate(dev);
 
-	*old = q->qdiscs[cl - 1];
-	q->qdiscs[cl - 1] = new;
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+		*old = dev_graft_qdisc(dev_queue, new);
+	} else {
+		*old = q->qdiscs[cl - 1];
+		q->qdiscs[cl - 1] = new;
+	}
 
 	if (new)
 		new->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
@@ -2035,6 +2039,7 @@ static struct Qdisc_ops taprio_qdisc_ops __read_mostly = {
 	.change		= taprio_change,
 	.destroy	= taprio_destroy,
 	.reset		= taprio_reset,
+	.attach		= taprio_attach,
 	.peek		= taprio_peek,
 	.dequeue	= taprio_dequeue,
 	.enqueue	= taprio_enqueue,
-- 
2.53.0



