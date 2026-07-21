Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8A46AA93;
	Tue, 21 Jul 2026 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648491; cv=none; b=FqR13X/TdwZSHvYREMz/Z4tf7VILKRxsD7J9Rf7eLW79uZz85kBxOCMC1akZV90FR/upgZPqK+bw7pHH24hhshgImJgsiSpV9x1ZRBkqo5Fqk1yqkSaKUd1pZCY48+4zwm5fj/mSgAZzmjW64bGeOuILKUqKE/qyeRTDfVbXkQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648491; c=relaxed/simple;
	bh=v5itrhwt/+8lxApz77xbtjANDJnMdZWC/eisn+m+D54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc3qHtrcWcHyKbOAG179dXkTjsj5ZaxxljShG1fUGNONRRtEwYbuPANlhWXrPL4weTVVkPsUpbWbLCTe447/mzEmKrICK+OK0gVsTMOve+AUdd7pKi+KDqqWDU0DHubAMRE+IA/I62jJZ5pul0kiob0OHKfMztsVGxjAtqtTFp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIcCyX84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIcCyX84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210441F00A3A;
	Tue, 21 Jul 2026 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648489;
	bh=fyJQMkSxv/bZsxI3HHpqdMlBNcELdnX6Coyb96W0+Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIcCyX84tk7DRs9ExGUcpXNLmu0ZWi4EReu/0MehqDLdP720cpLRO5BbDFvmDnU2N
	 FbxOwULtpJdmazwsCl/gUaMY/XuRFW4+dKg9Ph7FzAA7WXdMSy9Fm6obhQY0O4Cevu
	 Az/3dFOgMYnbRMOEl7l1zN9p2VVL7Nsx6f9RDN8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0217/2077] net/sched: sch_dualpi2: annotate data-races in dualpi2_dump_stats()
Date: Tue, 21 Jul 2026 16:58:10 +0200
Message-ID: <20260721152557.800940615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5658bddaca41417331d2ac4b24a9b159a839ab87 ]

dualpi2_dump_stats() runs without qdisc lock held.

Add missing READ_ONCE()/WRITE_ONCE() annotations.

Fixes: d4de8bffbef4 ("sched: Dump configuration and statistics of dualpi2 qdisc")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Link: https://patch.msgid.link/20260514114713.4134674-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_dualpi2.c | 68 ++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/net/sched/sch_dualpi2.c b/net/sched/sch_dualpi2.c
index 9a6020238427c2..b81a922f5e4684 100644
--- a/net/sched/sch_dualpi2.c
+++ b/net/sched/sch_dualpi2.c
@@ -190,7 +190,7 @@ static bool skb_apply_step(struct sk_buff *skb, struct dualpi2_sched_data *q)
 static bool dualpi2_mark(struct dualpi2_sched_data *q, struct sk_buff *skb)
 {
 	if (INET_ECN_set_ce(skb)) {
-		q->ecn_mark++;
+		WRITE_ONCE(q->ecn_mark, q->ecn_mark + 1);
 		return true;
 	}
 	return false;
@@ -198,7 +198,7 @@ static bool dualpi2_mark(struct dualpi2_sched_data *q, struct sk_buff *skb)
 
 static void dualpi2_reset_c_protection(struct dualpi2_sched_data *q)
 {
-	q->c_protection_credit = q->c_protection_init;
+	WRITE_ONCE(q->c_protection_credit, q->c_protection_init);
 }
 
 /* This computes the initial credit value and WRR weight for the L queue (wl)
@@ -403,12 +403,12 @@ static int dualpi2_enqueue_skb(struct sk_buff *skb, struct Qdisc *sch,
 
 	cb = dualpi2_skb_cb(skb);
 	cb->ts = ktime_get_ns();
-	q->memory_used += skb->truesize;
+	WRITE_ONCE(q->memory_used, q->memory_used + skb->truesize);
 	if (q->memory_used > q->max_memory_used)
-		q->max_memory_used = q->memory_used;
+		WRITE_ONCE(q->max_memory_used, q->memory_used);
 
 	if (qdisc_qlen(sch) > q->maxq)
-		q->maxq = qdisc_qlen(sch);
+		WRITE_ONCE(q->maxq, qdisc_qlen(sch));
 
 	if (skb_in_l_queue(skb)) {
 		/* Apply step thresh if skb is L4S && L-queue len >= min_qlen */
@@ -417,14 +417,14 @@ static int dualpi2_enqueue_skb(struct sk_buff *skb, struct Qdisc *sch,
 		/* Keep the overall qdisc stats consistent */
 		qdisc_qlen_inc(sch);
 		qdisc_qstats_backlog_inc(sch, skb);
-		++q->packets_in_l;
+		WRITE_ONCE(q->packets_in_l, q->packets_in_l + 1);
 		if (!q->l_head_ts)
-			q->l_head_ts = cb->ts;
+			WRITE_ONCE(q->l_head_ts, cb->ts);
 		return qdisc_enqueue_tail(skb, q->l_queue);
 	}
-	++q->packets_in_c;
+	WRITE_ONCE(q->packets_in_c, q->packets_in_c + 1);
 	if (!q->c_head_ts)
-		q->c_head_ts = cb->ts;
+		WRITE_ONCE(q->c_head_ts, cb->ts);
 	return qdisc_enqueue_tail(skb, sch);
 }
 
@@ -530,17 +530,16 @@ static struct sk_buff *dequeue_packet(struct Qdisc *sch,
 
 		/* Keep the global queue size consistent */
 		qdisc_qlen_dec(sch);
-		q->memory_used -= skb->truesize;
 	} else if (c_len) {
 		skb = __qdisc_dequeue_head(&sch->q);
 		WRITE_ONCE(q->c_head_ts, head_enqueue_time(sch));
 		if (qdisc_qlen(q->l_queue))
 			*credit_change = ~((s32)q->c_protection_wl) + 1;
-		q->memory_used -= skb->truesize;
 	} else {
 		dualpi2_reset_c_protection(q);
 		return NULL;
 	}
+	WRITE_ONCE(q->memory_used, q->memory_used - skb->truesize);
 	*credit_change *= qdisc_pkt_len(skb);
 	qdisc_qstats_backlog_dec(sch, skb);
 	return skb;
@@ -563,7 +562,7 @@ static int do_step_aqm(struct dualpi2_sched_data *q, struct sk_buff *skb,
 		}
 
 		if (dualpi2_mark(q, skb))
-			++q->step_marks;
+			WRITE_ONCE(q->step_marks, q->step_marks + 1);
 	}
 	qdisc_bstats_update(q->l_queue, skb);
 	return 0;
@@ -599,7 +598,8 @@ static struct sk_buff *dualpi2_qdisc_dequeue(struct Qdisc *sch)
 			continue;
 		}
 
-		q->c_protection_credit += credit_change;
+		WRITE_ONCE(q->c_protection_credit,
+			   q->c_protection_credit + credit_change);
 		qdisc_bstats_update(sch, skb);
 		break;
 	}
@@ -875,7 +875,7 @@ static int dualpi2_change(struct Qdisc *sch, struct nlattr *opt,
 				WARN_ON_ONCE(1);
 				break;
 			}
-			q->memory_used -= skb->truesize;
+			WRITE_ONCE(q->memory_used, q->memory_used - skb->truesize);
 			rtnl_qdisc_drop(skb, sch);
 		} else if (qdisc_qlen(q->l_queue)) {
 			skb = qdisc_dequeue_internal(q->l_queue, true);
@@ -889,7 +889,7 @@ static int dualpi2_change(struct Qdisc *sch, struct nlattr *opt,
 			 */
 			qdisc_qlen_dec(sch);
 			qdisc_qstats_backlog_dec(sch, skb);
-			q->memory_used -= skb->truesize;
+			WRITE_ONCE(q->memory_used, q->memory_used - skb->truesize);
 			rtnl_qdisc_drop(skb, q->l_queue);
 			qdisc_qstats_drop(sch);
 		} else {
@@ -1045,15 +1045,15 @@ static int dualpi2_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	struct dualpi2_sched_data *q = qdisc_priv(sch);
 	struct tc_dualpi2_xstats st = {
 		.prob			= READ_ONCE(q->pi2_prob),
-		.packets_in_c		= q->packets_in_c,
-		.packets_in_l		= q->packets_in_l,
-		.maxq			= q->maxq,
-		.ecn_mark		= q->ecn_mark,
-		.credit			= q->c_protection_credit,
-		.step_marks		= q->step_marks,
-		.memory_used		= q->memory_used,
-		.max_memory_used	= q->max_memory_used,
-		.memory_limit		= q->memory_limit,
+		.packets_in_c		= READ_ONCE(q->packets_in_c),
+		.packets_in_l		= READ_ONCE(q->packets_in_l),
+		.maxq			= READ_ONCE(q->maxq),
+		.ecn_mark		= READ_ONCE(q->ecn_mark),
+		.credit			= READ_ONCE(q->c_protection_credit),
+		.step_marks		= READ_ONCE(q->step_marks),
+		.memory_used		= READ_ONCE(q->memory_used),
+		.max_memory_used	= READ_ONCE(q->max_memory_used),
+		.memory_limit		= READ_ONCE(q->memory_limit),
 	};
 	u64 qc, ql;
 
@@ -1073,16 +1073,16 @@ static void dualpi2_reset(struct Qdisc *sch)
 
 	qdisc_reset_queue(sch);
 	qdisc_reset_queue(q->l_queue);
-	q->c_head_ts = 0;
-	q->l_head_ts = 0;
-	q->pi2_prob = 0;
-	q->packets_in_c = 0;
-	q->packets_in_l = 0;
-	q->maxq = 0;
-	q->ecn_mark = 0;
-	q->step_marks = 0;
-	q->memory_used = 0;
-	q->max_memory_used = 0;
+	WRITE_ONCE(q->c_head_ts, 0);
+	WRITE_ONCE(q->l_head_ts, 0);
+	WRITE_ONCE(q->pi2_prob, 0);
+	WRITE_ONCE(q->packets_in_c, 0);
+	WRITE_ONCE(q->packets_in_l, 0);
+	WRITE_ONCE(q->maxq, 0);
+	WRITE_ONCE(q->ecn_mark, 0);
+	WRITE_ONCE(q->step_marks, 0);
+	WRITE_ONCE(q->memory_used, 0);
+	WRITE_ONCE(q->max_memory_used, 0);
 	dualpi2_reset_c_protection(q);
 }
 
-- 
2.53.0



