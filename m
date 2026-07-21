Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5F5470127;
	Tue, 21 Jul 2026 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656762; cv=none; b=DlD9eLH0fqHitJNajTaY3djQfKs5He7gYaP3mrbLGW79FqxEgPwmunpnaPzVHHikZnJulfFhQ41AnC8+b+tyhhaSiV/ByBwLcos3G0UIvKS6RqFxlrNWDGNTmg8u9L+DTxbzU95wp1Y42D/1cJ3uszs8R8ph7GW2id4jnMAnyl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656762; c=relaxed/simple;
	bh=3VK7UpohExurH/1Phud6jLWzeMgBzXaoZpUnEzW9OcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXOtIZiNuZt2yN4z95T9jAHSWqj1NFrareCICYg8TWQGEd6vttfl/IoQWCByPladO9X+WMr1LrrJ09yhvnzsiUOr26DSy2HAY1moul/OZeBI7qaAG4KJ2ykjPga4zpzQeffcI9jA0N+lYphrJZyo30wNJkp+VjSrdwIN3qsLp0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euxgWsuI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euxgWsuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707551F000E9;
	Tue, 21 Jul 2026 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656760;
	bh=wgMPcEjWh87CEdm1T6M5Z5ZL4w/5CmBT9j1X94Mt6gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=euxgWsuIn0ch087Xtimaja6TDUTQXrn0xn5TjCpqlR3/oIVE+vSQziExGBNlBvBAf
	 7LkLL1TZYWLBBVcZJfgQucOYAJSDn1e42SqzBh8q5WECRrj4enToMMde7sw+jpR2S5
	 8EKPEf91m+iOp9LbrcbMu8tPYgNfftlBjy23JgpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0507/1611] net/sched: sch_dualpi2: Do not call qdisc_tree_reduce_backlog during peek before restoring qlen
Date: Tue, 21 Jul 2026 17:10:23 +0200
Message-ID: <20260721152526.753220357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 15cd0c93bf4f892d66bc7a93667e2357b5673365 ]

Whenever dualpi2 drops packets during peek, it calls
qdisc_tree_reduce_backlog. An issue arises because it calls
qdisc_tree_reduce_backlog before it reincrements the qlen. If qlen drops
to zero, but peek returns an skb, the parent's qlen_notify callback will be
executed even though dualpi2 still has 1 packet on the queue and, thus,
mistakenly deactivates the parent's class which leads to a null-ptr-deref:

[  101.427314][  T599] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000009: 0000 [#1] SMP KASAN NOPTI
[  101.427755][  T599] KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
[  101.428048][  T599] CPU: 2 UID: 0 PID: 599 Comm: ping Not tainted 7.1.0-rc5-00284-gbce53c430ed7 #102 PREEMPT(full)
[  101.428400][  T599] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  101.428608][  T599] RIP: 0010:qfq_dequeue (net/sched/sch_qfq.c:1150) sch_qfq
[  101.428821][  T599] Code: 00 fc ff df 80 3c 02 00 0f 85 46 0c 00 00 4c 8d 73 48 48 89 9d b8 02 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f 85 2d 0c 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b
All code
[  101.429348][  T599] RSP: 0018:ffff8881110df4f0 EFLAGS: 00010216
[  101.429541][  T599] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: dffffc0000000000
[  101.429763][  T599] RDX: 0000000000000009 RSI: 00000024c0000000 RDI: ffff88811436c2b0
[  101.429985][  T599] RBP: ffff88811436c000 R08: ffff88811436c280 R09: 1ffff11021277523
[  101.430206][  T599] R10: 1ffff11021277526 R11: 1ffff11021277527 R12: 00000024c0000000
[  101.430423][  T599] R13: ffff88811436c2b8 R14: 0000000000000048 R15: 0000000020000000
[  101.430642][  T599] FS:  00007f61813e1c40(0000) GS:ffff8881691ef000(0000) knlGS:0000000000000000
[  101.430913][  T599] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  101.431100][  T599] CR2: 00005651650850a8 CR3: 000000010ca0b000 CR4: 0000000000750ef0
[  101.431320][  T599] PKRU: 55555554
[  101.431433][  T599] Call Trace:
[  101.431544][  T599]  <TASK>
[  101.431628][  T599]  __qdisc_run (net/sched/sch_generic.c:322 net/sched/sch_generic.c:427 net/sched/sch_generic.c:445)
[  101.431792][  T599]  ? dev_qdisc_enqueue (./include/trace/events/qdisc.h:49 (discriminator 22) net/core/dev.c:4176 (discriminator 22))
[  101.431941][  T599]  __dev_queue_xmit (./include/net/pkt_sched.h:120 ./include/net/pkt_sched.h:117 net/core/dev.c:4292 net/core/dev.c:4831)

Fix this by only calling qdisc_tree_reduce_backlog in peek after the
qlen is restored.

Fixes: 8f9516daedd6 ("sched: Add enqueue/dequeue of dualpi2 qdisc")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260610192855.3121513-4-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_dualpi2.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_dualpi2.c b/net/sched/sch_dualpi2.c
index 6beb6f5bbff1a1..b4a57e1d9513a6 100644
--- a/net/sched/sch_dualpi2.c
+++ b/net/sched/sch_dualpi2.c
@@ -579,7 +579,7 @@ static void drop_and_retry(struct dualpi2_sched_data *q, struct sk_buff *skb,
 	qdisc_qstats_drop(sch);
 }
 
-static struct sk_buff *dualpi2_qdisc_dequeue(struct Qdisc *sch)
+static struct sk_buff *__dualpi2_qdisc_dequeue(struct Qdisc *sch)
 {
 	struct dualpi2_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *skb;
@@ -607,12 +607,49 @@ static struct sk_buff *dualpi2_qdisc_dequeue(struct Qdisc *sch)
 		break;
 	}
 
+	return skb;
+}
+
+static void dualpi2_dequeue_drop(struct Qdisc *sch)
+{
+	struct dualpi2_sched_data *q = qdisc_priv(sch);
+
 	if (q->deferred_drops_cnt) {
 		qdisc_tree_reduce_backlog(sch, q->deferred_drops_cnt,
 					  q->deferred_drops_len);
 		q->deferred_drops_cnt = 0;
 		q->deferred_drops_len = 0;
 	}
+}
+
+static struct sk_buff *dualpi2_qdisc_dequeue(struct Qdisc *sch)
+{
+	struct sk_buff *skb;
+
+	skb = __dualpi2_qdisc_dequeue(sch);
+
+	dualpi2_dequeue_drop(sch);
+
+	return skb;
+}
+
+static struct sk_buff *dualpi2_peek(struct Qdisc *sch)
+{
+	struct sk_buff *skb = skb_peek(&sch->gso_skb);
+
+	if (!skb) {
+		skb = __dualpi2_qdisc_dequeue(sch);
+
+		if (skb) {
+			__skb_queue_head(&sch->gso_skb, skb);
+			/* it's still part of the queue */
+			qdisc_qstats_backlog_inc(sch, skb);
+			sch->q.qlen++;
+		}
+
+		dualpi2_dequeue_drop(sch);
+	}
+
 	return skb;
 }
 
@@ -1165,7 +1202,7 @@ static struct Qdisc_ops dualpi2_qdisc_ops __read_mostly = {
 	.priv_size	= sizeof(struct dualpi2_sched_data),
 	.enqueue	= dualpi2_qdisc_enqueue,
 	.dequeue	= dualpi2_qdisc_dequeue,
-	.peek		= qdisc_peek_dequeued,
+	.peek		= dualpi2_peek,
 	.init		= dualpi2_init,
 	.destroy	= dualpi2_destroy,
 	.reset		= dualpi2_reset,
-- 
2.53.0



