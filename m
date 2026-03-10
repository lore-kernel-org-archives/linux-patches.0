Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D580386C02;
	Tue, 10 Mar 2026 11:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141658; cv=none; b=dZmzGgj/z/v9nyJYVh8dOENLl06YSoo76jC16sVelbkQxN+9YhRit0hZ6xFp4whERS8RXCbsEDHHvBs4NdSSf9SsK3ZeSeyzhpxBEKkHYv0V77hL6qNy4UTpCTuSAMQETTGGkoimWRiuy59tPUGSjfOB//BYQ3ubIlj4WItECAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141658; c=relaxed/simple;
	bh=zJbbNLhrG2SLwPOb/m71gyLEXQslXA8Z+ijTAazrd/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqCCJtm/GbJx83ghwK1VbTgavXEE0085sAK7MmkexaSzO6srxR618yOVMK8RYr3vI+3yDBftd/5GFL1B4DXCir7cU/qGhY2w+ZXIx11VslsaST5foGhhIe0ItMFV1cs2PN7IcVCyR439zwhrjnN76GDrRhkJlKE95OdjJd5hrbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imC+jJi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imC+jJi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09C3C2BCAF;
	Tue, 10 Mar 2026 11:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141658;
	bh=zJbbNLhrG2SLwPOb/m71gyLEXQslXA8Z+ijTAazrd/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imC+jJi0VVAjYQQv2ASPTQlFq5M17JgKZ227jQqy9AH1ItXz83Z45M5Tld6nbYzBi
	 sBheCU2RyUCD+zoORtTqrvRpSoYz9Ren3NwqUhJhgKQK4yS2XuPwhlh0NlqgbE+nfO
	 hCwC5lRP3pQ6VYKL1vRUm7B+CQSZuJuykjLKSCmTS6fwUBwWaEV9UV+NH5jtyJd491
	 NPubqjKGYS/l5987t05KNZhwIvnQB5EPsmBKrGF6aUHFIlpDEu2+icA70SJOEjV/SD
	 l+T4/kAFAELOkt9g+/yNtwrrBRA7J/mZ9k+xg4aEfwgIN19jvOZsPJesCfWWEUqkH+
	 BvICcuYHQsS3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shubhang Kaushik <shubhang@os.amperecomputing.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/314] sched/fair: Fix lag clamp
Date: Tue, 10 Mar 2026 07:14:44 -0400
Message-ID: <5c138c996029f207c25fdf19db8cd2c0520a917f.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 6e3c0a4e1ad1e0455b7880fad02b3ee179f56c09 ]

Vincent reported that he was seeing undue lag clamping in a mixed
slice workload. Implement the max_slice tracking as per the todo
comment.

Fixes: 147f3efaa241 ("sched/fair: Implement an EEVDF-like scheduling policy")
Reported-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Link: https://patch.msgid.link/20250422101628.GA33555@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/fair.c   | 39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6ad294330c0b6..3e2005e9e2f0b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -574,6 +574,7 @@ struct sched_entity {
 	u64				deadline;
 	u64				min_vruntime;
 	u64				min_slice;
+	u64				max_slice;
 
 	struct list_head		group_node;
 	unsigned char			on_rq;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8587218ee9073..292141f4aaa54 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -748,6 +748,8 @@ u64 avg_vruntime(struct cfs_rq *cfs_rq)
 	return cfs_rq->zero_vruntime;
 }
 
+static inline u64 cfs_rq_max_slice(struct cfs_rq *cfs_rq);
+
 /*
  * lag_i = S - s_i = w_i * (V - v_i)
  *
@@ -761,17 +763,16 @@ u64 avg_vruntime(struct cfs_rq *cfs_rq)
  * EEVDF gives the following limit for a steady state system:
  *
  *   -r_max < lag < max(r_max, q)
- *
- * XXX could add max_slice to the augmented data to track this.
  */
 static void update_entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
+	u64 max_slice = cfs_rq_max_slice(cfs_rq) + TICK_NSEC;
 	s64 vlag, limit;
 
 	WARN_ON_ONCE(!se->on_rq);
 
 	vlag = avg_vruntime(cfs_rq) - se->vruntime;
-	limit = calc_delta_fair(max_t(u64, 2*se->slice, TICK_NSEC), se);
+	limit = calc_delta_fair(max_slice, se);
 
 	se->vlag = clamp(vlag, -limit, limit);
 }
@@ -829,6 +830,21 @@ static inline u64 cfs_rq_min_slice(struct cfs_rq *cfs_rq)
 	return min_slice;
 }
 
+static inline u64 cfs_rq_max_slice(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *root = __pick_root_entity(cfs_rq);
+	struct sched_entity *curr = cfs_rq->curr;
+	u64 max_slice = 0ULL;
+
+	if (curr && curr->on_rq)
+		max_slice = curr->slice;
+
+	if (root)
+		max_slice = max(max_slice, root->max_slice);
+
+	return max_slice;
+}
+
 static inline bool __entity_less(struct rb_node *a, const struct rb_node *b)
 {
 	return entity_before(__node_2_se(a), __node_2_se(b));
@@ -853,6 +869,15 @@ static inline void __min_slice_update(struct sched_entity *se, struct rb_node *n
 	}
 }
 
+static inline void __max_slice_update(struct sched_entity *se, struct rb_node *node)
+{
+	if (node) {
+		struct sched_entity *rse = __node_2_se(node);
+		if (rse->max_slice > se->max_slice)
+			se->max_slice = rse->max_slice;
+	}
+}
+
 /*
  * se->min_vruntime = min(se->vruntime, {left,right}->min_vruntime)
  */
@@ -860,6 +885,7 @@ static inline bool min_vruntime_update(struct sched_entity *se, bool exit)
 {
 	u64 old_min_vruntime = se->min_vruntime;
 	u64 old_min_slice = se->min_slice;
+	u64 old_max_slice = se->max_slice;
 	struct rb_node *node = &se->run_node;
 
 	se->min_vruntime = se->vruntime;
@@ -870,8 +896,13 @@ static inline bool min_vruntime_update(struct sched_entity *se, bool exit)
 	__min_slice_update(se, node->rb_right);
 	__min_slice_update(se, node->rb_left);
 
+	se->max_slice = se->slice;
+	__max_slice_update(se, node->rb_right);
+	__max_slice_update(se, node->rb_left);
+
 	return se->min_vruntime == old_min_vruntime &&
-	       se->min_slice == old_min_slice;
+	       se->min_slice == old_min_slice &&
+	       se->max_slice == old_max_slice;
 }
 
 RB_DECLARE_CALLBACKS(static, min_vruntime_cb, struct sched_entity,
-- 
2.51.0

