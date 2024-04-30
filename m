Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B57128816;
	Tue, 30 Apr 2024 10:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474647; cv=none; b=bvwjD1NivXOv2CdP6qCVJO4wSyKtYfwMkZLL46zsbs1ySaaXJNZRYlIwjT8JlLiYc/UjmtqWGw2iCwBL2hGIoUyS/YxxtrhS+IDcyS83LymNEVTcoqtLzl6GoT8fAJMGL/OSE7fkaQ/Ja/1QeFXT+nIR97Hu7X3N3KmajJKiUjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474647; c=relaxed/simple;
	bh=q6OaaWp0CpFGoDKuaDFaKOAafHsUfiBWnlC2LiOVyDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxFOwa2fSCarGdu0xvDlMZJM3Zak0x7+XLQmI/4KVXq2KXwkRntkj0KY6YF95h+eN+YyrzpCoTy9RW8stmI+WCf8uMn0rgyg6tcLI0qv+DHQYdA6DOdmoZ1zHgwbVWtcIB0EH03ewRMG2DSmNSBjs09ndUsCzDhnWoMv73cOJOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtlejw7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtlejw7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0F2C2BBFC;
	Tue, 30 Apr 2024 10:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474647;
	bh=q6OaaWp0CpFGoDKuaDFaKOAafHsUfiBWnlC2LiOVyDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtlejw7euxvN6hpJ2n3w///1aTi7Gj5WGnQDwV488VQSlMDyB8vCmSL4jaZrIIhgG
	 CjXmIjgCII42N+uD48uRUWY9g4Q9MKGuRR689tSNFpq+9Iw+3l31KgPv2Y8PYWkE5k
	 kL+2V8ffHlCpMAoUkb5m81ZFF+tLXoA6ww1lL2ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 219/228] sched/eevdf: Fix miscalculation in reweight_entity() when se is not curr
Date: Tue, 30 Apr 2024 12:39:57 +0200
Message-ID: <20240430103110.123420497@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit afae8002b4fd3560c8f5f1567f3c3202c30a70fa ]

reweight_eevdf() only keeps V unchanged inside itself. When se !=
cfs_rq->curr, it would be dequeued from rb tree first. So that V is
changed and the result is wrong. Pass the original V to reweight_eevdf()
to fix this issue.

Fixes: eab03c23c2a1 ("sched/eevdf: Fix vruntime adjustment on reweight")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
[peterz: flip if() condition for clarity]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Abel Wu <wuyun.abel@bytedance.com>
Link: https://lkml.kernel.org/r/20240306022133.81008-3-dtcccc@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 69d2158873429..b9ee4397b484a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3670,11 +3670,10 @@ static inline void
 dequeue_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) { }
 #endif
 
-static void reweight_eevdf(struct cfs_rq *cfs_rq, struct sched_entity *se,
+static void reweight_eevdf(struct sched_entity *se, u64 avruntime,
 			   unsigned long weight)
 {
 	unsigned long old_weight = se->load.weight;
-	u64 avruntime = avg_vruntime(cfs_rq);
 	s64 vlag, vslice;
 
 	/*
@@ -3781,24 +3780,26 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {
 	bool curr = cfs_rq->curr == se;
+	u64 avruntime;
 
 	if (se->on_rq) {
 		/* commit outstanding execution time */
 		update_curr(cfs_rq);
+		avruntime = avg_vruntime(cfs_rq);
 		if (!curr)
 			__dequeue_entity(cfs_rq, se);
 		update_load_sub(&cfs_rq->load, se->load.weight);
 	}
 	dequeue_load_avg(cfs_rq, se);
 
-	if (!se->on_rq) {
+	if (se->on_rq) {
+		reweight_eevdf(se, avruntime, weight);
+	} else {
 		/*
 		 * Because we keep se->vlag = V - v_i, while: lag_i = w_i*(V - v_i),
 		 * we need to scale se->vlag when w_i changes.
 		 */
 		se->vlag = div_s64(se->vlag * se->load.weight, weight);
-	} else {
-		reweight_eevdf(cfs_rq, se, weight);
 	}
 
 	update_load_set(&se->load, weight);
-- 
2.43.0



