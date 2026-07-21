Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C80F35C69A;
	Tue, 21 Jul 2026 21:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669154; cv=none; b=Ckj4Ls0tN0zviwQK0EvG4kr0S5xPj0lSksvGqYa+gr8mAZK6EIMhzlvL+U4YkhjNJATxqIunbI0K++PITcP0htgKUK8rJ1h6iCSf4gZ4rFWmQuhSA9xGsBEWqOsSKew8uJVJFlBiDNfV0mXu2U5QFoRyX60UHO9cYHRZYlYB7+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669154; c=relaxed/simple;
	bh=VJiN9ZafiEhFbuMxxJzqDqLqdRwHzd+OimxvqjmpFwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U704+M68oAfi2m+mPAr3SzkpJssifCfa7DLc3mg2k5OcfpQmpq0z/Y5LxfuLyW1dY/Km2v+5rA8GJZad+8e3xEiWh2YiKx5ngfWAUgrDwzBsVVDTDkRXBmh0uwZAnAxU8PCMOgtQh9yb3N5DqafdPWfH6UsaChzDeHlO/ZkjE3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTRf2kVW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTRf2kVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8C51F000E9;
	Tue, 21 Jul 2026 21:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669153;
	bh=ZLlFzfEfwAiOh3UqalFNt3NYp5xZsZIWkT6uj/Lm0kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTRf2kVWZc78cYGz1J7vF/EWxi6TXuZ6uZfGH+pWkdCgEuuz1e3Mm/RpMLxttGwep
	 eGsu8ce7XYZuPxqd7ZMNqFUt6dCyojt558F+PkvHxmKaM6iNaUOpVZgnTqtxvsaW9S
	 E5Kb0rU0zb5/WAvCnIrZqJ6FuSR6ShiullCFiRJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Gupta <anirudhrudr@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0447/1067] net/sched: sch_fq_codel: Do not call qdisc_tree_reduce_backlog during peek before restoring qlen
Date: Tue, 21 Jul 2026 17:17:28 +0200
Message-ID: <20260721152434.617786237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 097f6fc7b1ae362dd7a9444b2572162fda73b284 ]

Whenever fq_codel drops packets during peek, it calls
qdisc_tree_reduce_backlog. An issue arises because it calls
qdisc_tree_reduce_backlog before it reincrements the qlen. If qlen drops
to zero, but peek returns an skb, the parent's qlen_notify callback will be
executed even though fq_codel still has 1 packet on the queue and, thus,
will mistakenly deactivate the parent's class causing issues like a recent
report [1] and a wild memory access in qfq:

[   29.371146][  T360] Oops: general protection fault, probably for non-canonical address 0xfbd59c0000000024: 0000 [#1] SMP KASAN NOPTI
[   29.371666][  T360] KASAN: maybe wild-memory-access in range [0xdead000000000120-0xdead000000000127]
[   29.371987][  T360] CPU: 6 UID: 0 PID: 360 Comm: tc Not tainted 7.1.0-rc5-00285-gc530e5b2dbc6-dirty #82 PREEMPT(full)
[   29.372384][  T360] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   29.372620][  T360] RIP: 0010:qfq_deactivate_agg (include/linux/list.h:1029 (discriminator 2) include/linux/list.h:1043 (discriminator 2) net/sched/sch_qfq.c:1369 (discriminator 2) net/sched/sch_qfq.c:1395 (discriminator 2)) sch_qfq
[   29.373544][  T360] RSP: 0018:ffff888102417370 EFLAGS: 00010216
[   29.373800][  T360] RAX: 0000000000000000 RBX: ffff88811224d568 RCX: dffffc0000000000
[   29.374079][  T360] RDX: 1ffff11021fe1543 RSI: ffff88810ff0aa00 RDI: dffffc0000000000
[   29.374368][  T360] RBP: ffff88811224c280 R08: dead000000000122 R09: 1bd5a00000000024
[   29.374649][  T360] R10: fffffbfff7940329 R11: fffffbfff7940329 R12: 0000000000000000
[   29.374926][  T360] R13: dead000000000100 R14: ffff88811224d580 R15: ffff88811224d578
[   29.375207][  T360] FS:  00007f5b794e5780(0000) GS:ffff88815d1e9000(0000) knlGS:0000000000000000
[   29.375545][  T360] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.375823][  T360] CR2: 000055ffb091f000 CR3: 000000010a305000 CR4: 0000000000750ef0
[   29.376103][  T360] PKRU: 55555554
[   29.376258][  T360] Call Trace:
[   29.376401][  T360]  <TASK>
...
[   29.376885][  T360] qfq_reset_qdisc (net/sched/sch_qfq.c:357 net/sched/sch_qfq.c:1487) sch_qfq
[   29.377074][  T360]  qdisc_reset (net/sched/sch_generic.c:1057)
[   29.377414][  T360]  __qdisc_destroy (net/sched/sch_generic.c:1096)
[   29.377600][  T360]  qdisc_graft (net/sched/sch_api.c:1062 net/sched/sch_api.c:1053 net/sched/sch_api.c:1159)
[   29.378593][  T360]  tc_get_qdisc (net/sched/sch_api.c:1528 net/sched/sch_api.c:1556)

Fix this by only calling qdisc_tree_reduce_backlog in peek after the
qlen is restored.

[1] http://lore.kernel.org/netdev/CAN2cbVe79oj0O9==m4+4x3v+O+qzRagA=2=wkrp9i9=CqYvyZA@mail.gmail.com/

Fixes: 342debc12183 ("codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()")
Reported-by: Anirudh Gupta <anirudhrudr@gmail.com>
Closes: https://lore.kernel.org/netdev/CAN2cbVe79oj0O9==m4+4x3v+O+qzRagA=2=wkrp9i9=CqYvyZA@mail.gmail.com/
Tested-by: Anirudh Gupta <anirudhrudr@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260610192855.3121513-2-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_codel.c | 41 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 056895df178541..e059d6c145741b 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -278,7 +278,7 @@ static void drop_func(struct sk_buff *skb, void *ctx)
 	qdisc_qstats_drop(sch);
 }
 
-static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
+static struct sk_buff *__fq_codel_dequeue(struct Qdisc *sch)
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *skb;
@@ -315,12 +315,49 @@ static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
 	qdisc_bstats_update(sch, skb);
 	flow->deficit -= qdisc_pkt_len(skb);
 
+	return skb;
+}
+
+static void fq_codel_dequeue_drop(struct Qdisc *sch)
+{
+	struct fq_codel_sched_data *q = qdisc_priv(sch);
+
 	if (q->cstats.drop_count) {
 		qdisc_tree_reduce_backlog(sch, q->cstats.drop_count,
 					  q->cstats.drop_len);
 		q->cstats.drop_count = 0;
 		q->cstats.drop_len = 0;
 	}
+}
+
+static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
+{
+	struct sk_buff *skb;
+
+	skb =  __fq_codel_dequeue(sch);
+
+	fq_codel_dequeue_drop(sch);
+
+	return skb;
+}
+
+static struct sk_buff *fq_codel_peek(struct Qdisc *sch)
+{
+	struct sk_buff *skb = skb_peek(&sch->gso_skb);
+
+	if (!skb) {
+		skb = __fq_codel_dequeue(sch);
+
+		if (skb) {
+			__skb_queue_head(&sch->gso_skb, skb);
+			/* it's still part of the queue */
+			qdisc_qstats_backlog_inc(sch, skb);
+			sch->q.qlen++;
+		}
+
+		fq_codel_dequeue_drop(sch);
+	}
+
 	return skb;
 }
 
@@ -707,7 +744,7 @@ static struct Qdisc_ops fq_codel_qdisc_ops __read_mostly = {
 	.priv_size	=	sizeof(struct fq_codel_sched_data),
 	.enqueue	=	fq_codel_enqueue,
 	.dequeue	=	fq_codel_dequeue,
-	.peek		=	qdisc_peek_dequeued,
+	.peek		=	fq_codel_peek,
 	.init		=	fq_codel_init,
 	.reset		=	fq_codel_reset,
 	.destroy	=	fq_codel_destroy,
-- 
2.53.0



