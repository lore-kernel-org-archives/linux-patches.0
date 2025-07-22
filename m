Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6642EA72D;
	Tue, 22 Jul 2025 13:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192441; cv=none; b=nldwfC3rjSwfYmsCs9AsSu4RRP4bn5wkZkELU+uC7G5lOqN2tUvckuVEdmPfjB5zmoTLRLNWMU+29/uIG4pN0KhvdzZneM5Qanc0m6p3Tu/EVPLfuV4UT4TNxxkXB13CiweTiiDNfbilg4/dGUdviVD9HxhaSYLqE8V4cKNOQEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192441; c=relaxed/simple;
	bh=KTgPrSTRaekS11iw00mxft74QMwaC3hjoStjawm2fcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvLuX1KODfbR0Xj4UWrt7iDyEplerykmmlOI6Y9YcFklcZwIrUfIIp7jczu6y/RIL/qBFrSAaF8vsMupMG/MbXsvzJEQjshNfmadDUsOmpna6fuj1qDMXudIqSmlH84G5rhwoxKTHRWoH9GTkhbvNnw1phs9Ym2eKbo/bUb3iRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXypjkLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXypjkLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1021DC4CEEB;
	Tue, 22 Jul 2025 13:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192441;
	bh=KTgPrSTRaekS11iw00mxft74QMwaC3hjoStjawm2fcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXypjkLNvO+FtCG0Ld4GWhQfQ3ZDpPkrg/qipxmE122r+Hob8r8fZYzkIfPzpqB1e
	 59Rs0D7Y7ORzHIjKP3okffGgG5+VE715PMgXHqGofQ+wBvci9TyI/UbLAV0GQ5gZED
	 tA1mNaUhYXaLERNZEELM/45NQMYO6JuXap72sDFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/111] net/sched: sch_qfq: Fix race condition on qfq_aggregate
Date: Tue, 22 Jul 2025 15:44:40 +0200
Message-ID: <20250722134335.801908151@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5e557b960bde3..a2b321fec13c1 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -412,7 +412,7 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	bool existing = false;
 	struct nlattr *tb[TCA_QFQ_MAX + 1];
 	struct qfq_aggregate *new_agg = NULL;
-	u32 weight, lmax, inv_w;
+	u32 weight, lmax, inv_w, old_weight, old_lmax;
 	int err;
 	int delta_w;
 
@@ -446,12 +446,16 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
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
 		NL_SET_ERR_MSG_FMT_MOD(extack,
@@ -558,10 +562,10 @@ static int qfq_delete_class(struct Qdisc *sch, unsigned long arg,
 
 	qdisc_purge_queue(cl->qdisc);
 	qdisc_class_hash_remove(&q->clhash, &cl->common);
+	qfq_destroy_class(sch, cl);
 
 	sch_tree_unlock(sch);
 
-	qfq_destroy_class(sch, cl);
 	return 0;
 }
 
@@ -628,6 +632,7 @@ static int qfq_dump_class(struct Qdisc *sch, unsigned long arg,
 {
 	struct qfq_class *cl = (struct qfq_class *)arg;
 	struct nlattr *nest;
+	u32 class_weight, lmax;
 
 	tcm->tcm_parent	= TC_H_ROOT;
 	tcm->tcm_handle	= cl->common.classid;
@@ -636,8 +641,13 @@ static int qfq_dump_class(struct Qdisc *sch, unsigned long arg,
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
 
@@ -654,8 +664,10 @@ static int qfq_dump_class_stats(struct Qdisc *sch, unsigned long arg,
 
 	memset(&xstats, 0, sizeof(xstats));
 
+	sch_tree_lock(sch);
 	xstats.weight = cl->agg->class_weight;
 	xstats.lmax = cl->agg->lmax;
+	sch_tree_unlock(sch);
 
 	if (gnet_stats_copy_basic(d, NULL, &cl->bstats, true) < 0 ||
 	    gnet_stats_copy_rate_est(d, &cl->rate_est) < 0 ||
-- 
2.39.5



