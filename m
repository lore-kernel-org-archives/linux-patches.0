Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7564C33D1;
	Wed, 30 Sep 2026 16:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786394; cv=none; b=OzyEFp3kPn/+023flYatutG/mitERbvxnRJgPFr4FymlidwKqt30MI53TECPjYYUTVRX5W1UesO9dytA6sy2wcz5ewV+Hdwmfdmed1QekWM9QP2hkpDj11N7pARGm7tLV8D3pPwZNmN4UWwnejwq2l0byBbq3R/rRnl0j2uTUBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786394; c=relaxed/simple;
	bh=rNGpAEkA1XxiG+Gy76SBRDS8rhz3VHtFpwrNFb9T3FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DRDaJk0WZyRdxlMmvKokgIz8ibyjTA9EDK0UI8b7rgmblBtM2o9JSA9hcbswJm+iUe12+cVGbHgnk2qfkFJyU5ck29ukW90+SwFCPyV8SGVDiCBVkQQb3Aj1/WYdNZCBbtc4OT10mUCSJgkZoy6MeeCGlGzou2H76TexVfeGhBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnEmyq1V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnEmyq1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AA01F000FF;
	Wed, 30 Sep 2026 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786392;
	bh=G+uXdQhIqNkX9bm7Z5aXlc2j/MTGhqJzFUy/4oVfnh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnEmyq1V3S4xea2wsM6fSqEhZQ7I2JxkH1xylKCfi3lswjJbp3WToHPcJFnK60awj
	 Qv2CBXg4TKOuyNuSYZdg/LzAe8uDkUlKFutSHkPH7Z3uXqJIhmrUmB77QTBvsKrFqL
	 8fv0Nnh4p676y5HG7F6o4H9Sl7q8olF7s5RekJ/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini + nipa)" <sashiko-bot@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	hybris <hybris@mojatatu.ai>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 847/982] net/sched: sch_hfsc: bound the classify inner-filter walk with a drift budget
Date: Wed, 30 Sep 2026 17:26:23 +0200
Message-ID: <20260930152434.942095345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 8a60ade2277e1f0e0d0578d565354e52292fa46d ]

hfsc_classify() applies the "filter may only point downwards" level check
only when the filter result carries no bound class. A filter created with
a flowid gets res.class set once at bind time, so the check never runs for
it during classification. hfsc_adjust_levels() can later raise a class's
level without revalidating existing bindings, leaving two binds that were
each legal at bind time pointing at each other; the classify walk then
bounces between two interior classes forever with the qdisc lock held and
BH disabled — a soft lockup from a single packet. The stuck walk trips
the watchdog:

  watchdog: BUG: soft lockup - CPU#3 stuck for 13s! [ping:444]
  RIP: 0010:u32_classify+0x542/0x17f0
  ...
  tcf_classify+0x66/0xa0
  hfsc_enqueue+0x166/0xdf0

Bound the traversal with a budget of non-descending hops, the only way a
configured walk can move without descending the class tree once levels
drift after bind time. The budget is cumulative over the whole walk and
is deliberately not reset on a descending hop: a chain that alternates a
descent with a lateral hop would return the budget every lap and never
trip. Descending hops never decrement it, so legitimately deep trees are
unaffected and a terminating lateral chain still classifies normally.
Drop the packet with a rate-limited warning once the budget is exhausted,
mirroring the merged HTB fix.

This is a follow-up to commit 729c4896ab82 ("net/sched: sch_htb: limit
htb_classify inner-class filter hops"), which bounded the same classify
loop on the HTB side but left the HFSC walk unbounded.

Conditions to recreate the bug:
- CONFIG_NET_SCHED, CONFIG_NET_SCH_HFSC, CONFIG_NET_CLS_U32,
  CONFIG_LOCKUP_DETECTOR.
- Build a cycle with two legal-at-bind-time flowid binds and a level
  drift: class X 1:1 (child of root) with leaf child 1:10; class Y 1:2
  (sibling of X) with children 1:20 and 1:200; root u32 filter flowid
  1:1; filter on X flowid 1:2 (legal when Y is a leaf); after Y's level
  rises to 2, filter on Y flowid 1:1 (legal then). Send one packet (ping
  on the device). Unfixed kernel: classify spins with the qdisc lock
  held; with softlockup_panic=1 it panics.
- Reachable from unprivileged user via unshare -Urn (CAP_NET_ADMIN).

Fixes: a2f79227138c ("net_sched: sch_hfsc: fix classification loops")
Reported-by: Sashiko (gemini + nipa) <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netdev/QDISC-CTUU.v2.20260913192614@mojatatu.com/
Link: https://sashiko.dev/#/patchset/QDISC-CTUU.v2.20260913192614@mojatatu.com
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-CTUU.v2.20260913192614%40mojatatu.com
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Tested-by: hybris <hybris@mojatatu.ai>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-CTUU.v3.20260916184908@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 2d6baf7d7b036..eb99bc1a76f6f 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -387,6 +387,15 @@ cftree_update(struct hfsc_class *cl)
 #define	SM_MASK		((1ULL << SM_SHIFT) - 1)
 #define	ISM_MASK	((1ULL << ISM_SHIFT) - 1)
 
+/*
+ * Cap on the non-descending hops a classify walk may take before its
+ * filter chain is treated as misconfigured. A flowid binding that was
+ * legal at bind time can become lateral once hfsc_adjust_levels()
+ * raises a class level; a few such hops are legitimate, an unbounded
+ * run means the chain cycles.
+ */
+#define	HFSC_CLASSIFY_MAX_DRIFT	8
+
 static inline u64
 seg_x2y(u64 x, u64 sm)
 {
@@ -1131,6 +1140,7 @@ hfsc_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	struct hfsc_class *head, *cl;
 	struct tcf_result res;
 	struct tcf_proto *tcf;
+	unsigned int drift;
 	int result;
 
 	if (TC_H_MAJ(skb->priority ^ sch->handle) == 0 &&
@@ -1140,6 +1150,7 @@ hfsc_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	head = &q->root;
+	drift = HFSC_CLASSIFY_MAX_DRIFT;
 	tcf = rcu_dereference_bh(q->root.filter_list);
 	while (tcf && (result = tcf_classify(skb, NULL, tcf, &res, false)) >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
@@ -1165,6 +1176,17 @@ hfsc_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 		if (cl->level == 0)
 			return cl; /* hit leaf class */
 
+		/*
+		 * flowid binds skip the level check above (res.class is set
+		 * at bind time and levels drift after), so a walk can follow
+		 * lateral hops without descending; a bounded number of them
+		 * is legal, more means the chain cycles.
+		 */
+		if (cl->level >= head->level && drift-- == 0) {
+			pr_warn_ratelimited("hfsc: classify hop budget exhausted, dropping packet\n");
+			return NULL;
+		}
+
 		/* apply inner filter chain */
 		tcf = rcu_dereference_bh(cl->filter_list);
 		head = cl;
-- 
2.53.0



