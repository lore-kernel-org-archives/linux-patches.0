Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D2F14388A;
	Tue, 23 Apr 2024 21:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908479; cv=none; b=j/OS33/tRyKpPOq2zMOCgeYm9Kmx7cMRXKjLE20fP4d31l1f6ip0Vz3cIM0fJkRO856bULCKkcJCauDaQP4SvyjEiwvg7xMCC2T5lZ8s8cQye4CUeyOx5k5Zrc3SfWzh8tu8jB/8iEY0q/xSx3tK9a5EyrppBjwCD+mIAKVva3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908479; c=relaxed/simple;
	bh=Q2s7Acri3QR7Blr+w6DjLDwPMW3tbGylRn2vavqVmH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyNCRw5w15YYiZKpW4dCnFcfF5bKr9qzUPtKbb2ej0hIuoq279214pDXdtIXRmNO5i+FI8Qna78XLq4slvPRNdU4sRKw9rmIGzbz4EPyP2yUpRHhCw9PZEaQj7HZ82kaUXAkeM9KZpnsKGjMB92wfrx+KUcDQoPYpcvy5ttqgvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+OC9YhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+OC9YhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB0AC32781;
	Tue, 23 Apr 2024 21:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908479;
	bh=Q2s7Acri3QR7Blr+w6DjLDwPMW3tbGylRn2vavqVmH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+OC9YhLYa8Dapw3fRbdzF8coaOb4te7lvESuN1mBD9pTFZ7uyX7wjQKYA8qKcdfA
	 lyqUL4OKnZ4AC+s+Syvnq/kyIhCQZ+qDNE71y1ek0Qjq7pM3ZVzHjr1D+9NFhEUHN2
	 cIc7PKd3e4Zq413R6V14Yo7VijRfjOHTUCakcYkI=
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
Subject: [PATCH 6.8 048/158] net/sched: Fix mirred deadlock on device recursion
Date: Tue, 23 Apr 2024 14:37:50 -0700
Message-ID: <20240423213857.470100022@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index cefe0c4bdae34..41ca14e81d55f 100644
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
index c9b8412f1c9d3..c365aa06f886f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3791,6 +3791,10 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		return rc;
 	}
 
+	if (unlikely(READ_ONCE(q->owner) == smp_processor_id())) {
+		kfree_skb_reason(skb, SKB_DROP_REASON_TC_RECLASSIFY_LOOP);
+		return NET_XMIT_DROP;
+	}
 	/*
 	 * Heuristic to force contended enqueues to serialize on a
 	 * separate lock before trying to get qdisc main lock.
@@ -3830,7 +3834,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
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
index 9b3e9262040b6..a498b5d7c5d60 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -973,6 +973,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	sch->enqueue = ops->enqueue;
 	sch->dequeue = ops->dequeue;
 	sch->dev_queue = dev_queue;
+	sch->owner = -1;
 	netdev_hold(dev, &sch->dev_tracker, GFP_KERNEL);
 	refcount_set(&sch->refcnt, 1);
 
-- 
2.43.0



