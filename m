Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5904B7144;
	Mon, 31 Aug 2026 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184610; cv=none; b=ah4GoP/dP7tLC05UcUCUMV9v9JcsTUGBM6U3RFQSNcpkhNr5wFaxvyq1s2Pn2B+FQ9uV1Y2i4eCCBRFeeVPhoU8RaKmlD4vfWcHpY+eK8VQjCsQ7TmD6Qw2u6HdijRuHwHZyc4dd6WB4B9Pj86mrrBHmKKciH7dHbwHiWhqt5Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184610; c=relaxed/simple;
	bh=2D7yRZBRNVNLoT0U0tbTi8n1kNKkqUu8opqnsYw0Pf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6FXvG0dNlwd2XSb5RfGQXiGXqLXO0cHZMONdO+ZdoxAS8Ly5nJkZ6lqFTMWGyzBtALFmAXOP6RHgPRvYx2dyiAschQiTMqrkC1mEtRETtGwK/Dr+aQdU9evHz4khQ4A9umwuTFBaTg7uOP7aeanBLDdpN05RemQuUPt+UgOVv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8agqZNR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8agqZNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAEA1F000E9;
	Mon, 31 Aug 2026 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184609;
	bh=UEnBsFryS7vwJIEXB5yfbXNiNRSeMBpJ8kQqjHvV8UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8agqZNRfR9eOpidXZjnmmkBOVnazgXZk+HnoemiiBW9keeE2evOrBt02Z3R2EH/r
	 fv4J65VwAyez02+MMz0QzyoedbylQnbVqEfAff481LWy08V8iENaf59H2QFZ2IBVsG
	 DhTRAxXJxnHUA7+stTs0vhbu8eFf1rK1siU9q36s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingshuai Ren <renmingshuai@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 30/91] net/sched: Fix mirred deadlock on device recursion
Date: Mon, 31 Aug 2026 15:34:18 +0200
Message-ID: <20260831133401.285429061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0f022d32c3eca477fbf79a205243a6123ed0fe11 ]

When the mirred action is used on a classful egress qdisc and a packet is
mirrored or redirected to self we hit a qdisc lock deadlock.
See trace below.

[..... other info removed for brevity....]
[   82.890906]
[   82.890906] ============================================
[   82.890906] WARNING: possible recursive locking detected
[   82.890906] 6.8.0-05205-g77fadd89fe2d-dirty #213 Tainted: G        W
[   82.890906] --------------------------------------------
[   82.890906] ping/418 is trying to acquire lock:
[   82.890906] ffff888006994110 (&sch->q.lock){+.-.}-{3:3}, at:
__dev_queue_xmit+0x1778/0x3550
[   82.890906]
[   82.890906] but task is already holding lock:
[   82.890906] ffff888006994110 (&sch->q.lock){+.-.}-{3:3}, at:
__dev_queue_xmit+0x1778/0x3550
[   82.890906]
[   82.890906] other info that might help us debug this:
[   82.890906]  Possible unsafe locking scenario:
[   82.890906]
[   82.890906]        CPU0
[   82.890906]        ----
[   82.890906]   lock(&sch->q.lock);
[   82.890906]   lock(&sch->q.lock);
[   82.890906]
[   82.890906]  *** DEADLOCK ***
[   82.890906]
[..... other info removed for brevity....]

Example setup (eth0->eth0) to recreate
tc qdisc add dev eth0 root handle 1: htb default 30
tc filter add dev eth0 handle 1: protocol ip prio 2 matchall \
     action mirred egress redirect dev eth0

Another example(eth0->eth1->eth0) to recreate
tc qdisc add dev eth0 root handle 1: htb default 30
tc filter add dev eth0 handle 1: protocol ip prio 2 matchall \
     action mirred egress redirect dev eth1

tc qdisc add dev eth1 root handle 1: htb default 30
tc filter add dev eth1 handle 1: protocol ip prio 2 matchall \
     action mirred egress redirect dev eth0

We fix this by adding an owner field (CPU id) to struct Qdisc set after
root qdisc is entered. When the softirq enters it a second time, if the
qdisc owner is the same CPU, the packet is dropped to break the loop.

Reported-by: Mingshuai Ren <renmingshuai@huawei.com>
Closes: https://lore.kernel.org/netdev/20240314111713.5979-1-renmingshuai@huawei.com/
Fixes: 3bcb846ca4cf ("net: get rid of spin_trylock() in net_tx_action()")
Fixes: e578d9c02587 ("net: sched: use counter to break reclassify loops")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20240415210728.36949-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 1 +
 net/core/dev.c            | 6 ++++++
 net/sched/sch_generic.c   | 1 +
 3 files changed, 8 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 4a157ab9a724f..0ec685beb2fc5 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -117,6 +117,7 @@ struct Qdisc {
 	struct qdisc_skb_head	q;
 	struct gnet_stats_basic_sync bstats;
 	struct gnet_stats_queue	qstats;
+	int                     owner;
 	unsigned long		state;
 	unsigned long		state2; /* must be written under qdisc spinlock */
 	struct Qdisc            *next_sched;
diff --git a/net/core/dev.c b/net/core/dev.c
index 8b0a0d449afdf..f2c7bb0fc7f9c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3901,6 +3901,10 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		return rc;
 	}
 
+	if (unlikely(READ_ONCE(q->owner) == smp_processor_id())) {
+		kfree_skb_reason(skb, SKB_DROP_REASON_TC_RECLASSIFY_LOOP);
+		return NET_XMIT_DROP;
+	}
 	/*
 	 * Heuristic to force contended enqueues to serialize on a
 	 * separate lock before trying to get qdisc main lock.
@@ -3940,7 +3944,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		qdisc_run_end(q);
 		rc = NET_XMIT_SUCCESS;
 	} else {
+		WRITE_ONCE(q->owner, smp_processor_id());
 		rc = dev_qdisc_enqueue(skb, q, &to_free, txq);
+		WRITE_ONCE(q->owner, -1);
 		if (qdisc_run_begin(q)) {
 			if (unlikely(contended)) {
 				spin_unlock(&q->busylock);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 714e51f8d46e9..1bb8862698030 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -986,6 +986,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	sch->enqueue = ops->enqueue;
 	sch->dequeue = ops->dequeue;
 	sch->dev_queue = dev_queue;
+	sch->owner = -1;
 	netdev_hold(dev, &sch->dev_tracker, GFP_KERNEL);
 	refcount_set(&sch->refcnt, 1);
 
-- 
2.53.0



