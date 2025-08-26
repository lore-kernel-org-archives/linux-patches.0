Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5AC341651;
	Tue, 26 Aug 2025 14:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217234; cv=none; b=Im+OxdvbW46AkXxemBIo7aBr0xasVGbQe17C9czBwFqyzCq+OXld64jyVZWhVPJeXIlikxy+yurZB9QMU/F1oqKnaa56fTBMIh2r2OmywDmwR8VZ/UIjDmYSYpBdYoQk7rcCEdsvNvDHQuDFzLwmYwznxhp15wC5z3bYrlGfHw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217234; c=relaxed/simple;
	bh=eoPLuSfPTQH2EdprkDWpTiphsH23Gp0M4mYH1Vjjexo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXRUrIGmZC86WUSTurlJmdyZo00AXr2+ogXAgbZq4aVhprMjQ6HUR5NK7g+QV5sifNeoLYAO6F3Q3lQ1yLdz3yInMbQKNsnZaeJqz1Wqcusn8Jt8aqZ3eBSMm1V+A/7SPbIbYFfP9zVNG8YiOKEtTs5+KIcYZlmjW55qjfgn+4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBmp17+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBmp17+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BEBC4CEF1;
	Tue, 26 Aug 2025 14:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217234;
	bh=eoPLuSfPTQH2EdprkDWpTiphsH23Gp0M4mYH1Vjjexo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBmp17+Z0Ke8KjylvwWeFe0PjgD6wIO+MoKnArzjaFVClCS/9nWJVzPfaY/1hytLx
	 BEx69SjySnMcaZqArIL61R+QIhWjJhAhb3cTvoZv5Ef+m2HXECm2TyhZBcLwRCOBVD
	 1AfkVxsfEjpWn7gq86AwAI+UfcCZWxX7cgr9HHuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/523] net/sched: sch_qfq: Fix race condition on qfq_aggregate
Date: Tue, 26 Aug 2025 13:04:05 +0200
Message-ID: <20250826110925.466617960@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 5e28d5a3f774f118896aec17a3a20a9c5c9dfc64 ]

A race condition can occur when 'agg' is modified in qfq_change_agg
(called during qfq_enqueue) while other threads access it
concurrently. For example, qfq_dump_class may trigger a NULL
dereference, and qfq_delete_class may cause a use-after-free.

This patch addresses the issue by:

1. Moved qfq_destroy_class into the critical section.

2. Added sch_tree_lock protection to qfq_dump_class and
qfq_dump_class_stats.

Fixes: 462dbc9101ac ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 1ee15db5fcc8c..e412340f639d2 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -414,7 +414,7 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	bool existing = false;
 	struct nlattr *tb[TCA_QFQ_MAX + 1];
 	struct qfq_aggregate *new_agg = NULL;
-	u32 weight, lmax, inv_w;
+	u32 weight, lmax, inv_w, old_weight, old_lmax;
 	int err;
 	int delta_w;
 
@@ -448,12 +448,16 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	inv_w = ONE_FP / weight;
 	weight = ONE_FP / inv_w;
 
-	if (cl != NULL &&
-	    lmax == cl->agg->lmax &&
-	    weight == cl->agg->class_weight)
-		return 0; /* nothing to change */
+	if (cl != NULL) {
+		sch_tree_lock(sch);
+		old_weight = cl->agg->class_weight;
+		old_lmax   = cl->agg->lmax;
+		sch_tree_unlock(sch);
+		if (lmax == old_lmax && weight == old_weight)
+			return 0; /* nothing to change */
+	}
 
-	delta_w = weight - (cl ? cl->agg->class_weight : 0);
+	delta_w = weight - (cl ? old_weight : 0);
 
 	if (q->wsum + delta_w > QFQ_MAX_WSUM) {
 		pr_notice("qfq: total weight out of range (%d + %u)\n",
@@ -554,10 +558,10 @@ static int qfq_delete_class(struct Qdisc *sch, unsigned long arg)
 
 	qdisc_purge_queue(cl->qdisc);
 	qdisc_class_hash_remove(&q->clhash, &cl->common);
+	qfq_destroy_class(sch, cl);
 
 	sch_tree_unlock(sch);
 
-	qfq_destroy_class(sch, cl);
 	return 0;
 }
 
@@ -624,6 +628,7 @@ static int qfq_dump_class(struct Qdisc *sch, unsigned long arg,
 {
 	struct qfq_class *cl = (struct qfq_class *)arg;
 	struct nlattr *nest;
+	u32 class_weight, lmax;
 
 	tcm->tcm_parent	= TC_H_ROOT;
 	tcm->tcm_handle	= cl->common.classid;
@@ -632,8 +637,13 @@ static int qfq_dump_class(struct Qdisc *sch, unsigned long arg,
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
-	if (nla_put_u32(skb, TCA_QFQ_WEIGHT, cl->agg->class_weight) ||
-	    nla_put_u32(skb, TCA_QFQ_LMAX, cl->agg->lmax))
+
+	sch_tree_lock(sch);
+	class_weight	= cl->agg->class_weight;
+	lmax		= cl->agg->lmax;
+	sch_tree_unlock(sch);
+	if (nla_put_u32(skb, TCA_QFQ_WEIGHT, class_weight) ||
+	    nla_put_u32(skb, TCA_QFQ_LMAX, lmax))
 		goto nla_put_failure;
 	return nla_nest_end(skb, nest);
 
@@ -650,8 +660,10 @@ static int qfq_dump_class_stats(struct Qdisc *sch, unsigned long arg,
 
 	memset(&xstats, 0, sizeof(xstats));
 
+	sch_tree_lock(sch);
 	xstats.weight = cl->agg->class_weight;
 	xstats.lmax = cl->agg->lmax;
+	sch_tree_unlock(sch);
 
 	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
 				  d, NULL, &cl->bstats) < 0 ||
-- 
2.39.5



