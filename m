Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EEB44AB7B;
	Tue, 21 Jul 2026 22:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671729; cv=none; b=NS+o2Ed3vDycfc3mv0lGH7yC0KPFGOk6wmqP14Jq/8o1nt1uvOrEobKtYW3WwKZPtF26H4Ca0s0slikrEiSqooLAonh77kwcV3z4ADnlehCTaOHk5Ynh80ZMw4saLiVDKU5P256M2DDNT0JXj+3E9YPRehaHgAv3AN272LL1yJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671729; c=relaxed/simple;
	bh=nawRmdbQyWvjB5FLkGIRAJLXdkX4oXpcPqU9+db8plI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUngcaAA9Jfl8nn9+y53Ewi8zjJ2tJJkwPwHCXnzSyOCe6NIXiWm6Maiq5om1pxoONXTVegs5jtTsrqTMr/a4RxQvMMAJtF6UiBn8uHqXFjB93Cj4z+PcIAy4A/nvb0lge3A2+p91+TIUNksSOL/fsWTvVk4qccACsiaXwvvLLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odCxjnbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odCxjnbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7FE1F00A3A;
	Tue, 21 Jul 2026 22:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671727;
	bh=dWdzySUygTH8lu8QBqLcZd0jkf28L2pjYO5LmthtLks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odCxjnbqsj3eGWcAvlPdMYH354q4gMfMDsMPujU1YDs4XfS8rxjFYUCPMUIcD3P7J
	 vxhKbmBBORpuxODNmdLoEm6gL4Xse52jG1q1tZnSdKihBPqdlqUlpo9M0P2sZ047uj
	 xkCpnrNxdFX3EDwrhKsyWEgmDZGBf5WUeWq9gL+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 354/843] net/sched: sch_codel: Do not call qdisc_tree_reduce_backlog during peek before restoring qlen
Date: Tue, 21 Jul 2026 17:19:49 +0200
Message-ID: <20260721152413.997457440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 52f1da34c9f4d5bdc1e8b44242da5c7ba8db85f3 ]

Whenever codel drops packets during peek, it calls
qdisc_tree_reduce_backlog. An issue arises because it calls
qdisc_tree_reduce_backlog before it reincrements the qlen. If qlen drops
to zero, but peek returns an skb, the parent's qlen_notify callback will
be executed even though codel still has 1 packet on the queue and, thus,
will mistakenly deactivate the parent's class causing issues like a wild
memory access when qfq has codel as a child:

[   36.339843][  T370] Oops: general protection fault, probably for non-canonical address 0xfbd59c0000000024: 0000 [#1] SMP KASAN NOPTI
[   36.340408][  T370] KASAN: maybe wild-memory-access in range [0xdead000000000120-0xdead000000000127]
[   36.340737][  T370] CPU: 2 UID: 0 PID: 370 Comm: tc Not tainted 7.1.0-rc5-00287-g66e13b626592 #87 PREEMPT(full)
[   36.341113][  T370] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   36.341357][  T370] RIP: 0010:qfq_deactivate_agg (include/linux/list.h:1029 (discriminator 2) include/linux/list.h:1043 (discriminator 2) net/sched/sch_qfq.c:1369 (discriminator 2) net/sched/sch_qfq.c:1395 (discriminator 2)) sch_qfq
[   36.342221][  T370] RSP: 0018:ffff8881100ef370 EFLAGS: 00010216
[   36.342422][  T370] RAX: 0000000000000000 RBX: ffff8881058a9568 RCX: dffffc0000000000
[   36.342664][  T370] RDX: 1ffff11021064dc3 RSI: ffff888108326e00 RDI: dffffc0000000000
[   36.342905][  T370] RBP: ffff8881058a8280 R08: dead000000000122 R09: 1bd5a00000000024
[   36.343140][  T370] R10: fffffbfff2940329 R11: fffffbfff2940329 R12: 0000000000000000
[   36.343383][  T370] R13: dead000000000100 R14: ffff8881058a9580 R15: ffff8881058a9578
[   36.343631][  T370] FS:  00007fc04b0ca780(0000) GS:ffff888184fef000(0000) knlGS:0000000000000000
[   36.343911][  T370] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.344116][  T370] CR2: 0000557c02c02000 CR3: 000000010e0ba000 CR4: 0000000000750ef0
[   36.344359][  T370] PKRU: 55555554
[   36.344481][  T370] Call Trace:
...
[   36.345054][  T370] qfq_reset_qdisc (net/sched/sch_qfq.c:357 net/sched/sch_qfq.c:1487) sch_qfq
[   36.345222][  T370]  qdisc_reset (net/sched/sch_generic.c:1057)
[   36.345503][  T370]  __qdisc_destroy (net/sched/sch_generic.c:1096)
[   36.345677][  T370]  qdisc_graft (net/sched/sch_api.c:1062 net/sched/sch_api.c:1053 net/sched/sch_api.c:1159)
[   36.346335][  T370]  tc_get_qdisc (net/sched/sch_api.c:1528 net/sched/sch_api.c:1556)

Fix this by only calling qdisc_tree_reduce_backlog in peek after the
qlen is restored.

Fixes: 342debc12183 ("codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260610192855.3121513-3-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_codel.c | 48 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 0d4228bfd1a02f..1cd09d3fe5efe9 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -86,7 +86,7 @@ static void drop_func(struct sk_buff *skb, void *ctx)
 	qdisc_qstats_drop(sch);
 }
 
-static struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
+static struct sk_buff *__codel_qdisc_dequeue(struct Qdisc *sch)
 {
 	struct codel_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *skb;
@@ -95,13 +95,51 @@ static struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
 			    &q->stats, qdisc_pkt_len, codel_get_enqueue_time,
 			    drop_func, dequeue_func);
 
+	if (skb)
+		qdisc_bstats_update(sch, skb);
+	return skb;
+}
+
+static void codel_dequeue_drop(struct Qdisc *sch)
+{
+	struct codel_sched_data *q = qdisc_priv(sch);
+
 	if (q->stats.drop_count) {
-		qdisc_tree_reduce_backlog(sch, q->stats.drop_count, q->stats.drop_len);
+		qdisc_tree_reduce_backlog(sch, q->stats.drop_count,
+					  q->stats.drop_len);
 		q->stats.drop_count = 0;
 		q->stats.drop_len = 0;
 	}
-	if (skb)
-		qdisc_bstats_update(sch, skb);
+}
+
+static struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
+{
+	struct sk_buff *skb;
+
+	skb = __codel_qdisc_dequeue(sch);
+
+	codel_dequeue_drop(sch);
+
+	return skb;
+}
+
+static struct sk_buff *codel_peek(struct Qdisc *sch)
+{
+	struct sk_buff *skb = skb_peek(&sch->gso_skb);
+
+	if (!skb) {
+		skb = __codel_qdisc_dequeue(sch);
+
+		if (skb) {
+			__skb_queue_head(&sch->gso_skb, skb);
+			/* it's still part of the queue */
+			qdisc_qstats_backlog_inc(sch, skb);
+			sch->q.qlen++;
+		}
+
+		codel_dequeue_drop(sch);
+	}
+
 	return skb;
 }
 
@@ -279,7 +317,7 @@ static struct Qdisc_ops codel_qdisc_ops __read_mostly = {
 
 	.enqueue	=	codel_qdisc_enqueue,
 	.dequeue	=	codel_qdisc_dequeue,
-	.peek		=	qdisc_peek_dequeued,
+	.peek		=	codel_peek,
 	.init		=	codel_init,
 	.reset		=	codel_reset,
 	.change 	=	codel_change,
-- 
2.53.0



