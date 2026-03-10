Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90CB387582;
	Tue, 10 Mar 2026 11:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141652; cv=none; b=H+APZCVDMbULlQqtLefApbJn5JFqGozWdl2vxShyaf0ZHbRS7zPo/kOWSIJnEtcoaqnJ3JWt1dXfbq+z0FIwiemA107Hds28c14EeiR0GP4qZfZEySP83h2OF4mMX6p+1qvuEgKfVbUqCGjgifHJOCY2h2E3SDtGIzfJ4wv+iUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141652; c=relaxed/simple;
	bh=P22jMN8OAVbbmeVe2SsE50/98086aJbz1tRGyuh0eqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGxWUDXOBZVC7PZNW4Zi+OnU96Vdxc3DLXErh3xwTLO/XnTQmCULcr6Qa66bER/ew4Raad5/eq5qxnlj4MlKRN+5J5GUkFwpQp8G3lCGz9vUqXMjm3xxzfpbD0ItmqTS/NQMsezCwtYxsts/m87Snp1Buyd/PC9tDzWlYZze4kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QO0+jzfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QO0+jzfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D56C2BC9E;
	Tue, 10 Mar 2026 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141652;
	bh=P22jMN8OAVbbmeVe2SsE50/98086aJbz1tRGyuh0eqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QO0+jzfotspDp80QTJlnCQDgkh8GkrrVP12+P/BV+QAPW1FxksN9J8ERfK37F2Ebz
	 GqjBfv6EdyEky9HdX2OGVQUWg0lA62bu4f+qdWEzX21ijA6+BzG0Ok/disMBGTj1gI
	 mOhs9kNeou7MBdjdOgFvJYyoLFDSFDpORyuNwa+q1KX0a6oiInhxzwUiLI+vdZ2WoC
	 EPoqkn9NKpQFC5ge8ycgKA6pp7561hwHys7HZ/Pof0xts9T6fzwLxQ0SRSd4gmMnYG
	 sHEjwK0lm3vnzCt605MpThl26VEMp+A0VCN3wQmG0aJmWXDc1LbROdUKoymM4qaBog
	 7peSdhRd0rZig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/314] sched/fair: Rename cfs_rq::avg_load to cfs_rq::sum_weight
Date: Tue, 10 Mar 2026 07:14:38 -0400
Message-ID: <9ed4add82b5c552fba3cb3c607b0f339a0b4528e.1773141555.git.sashal@kernel.org>
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

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit 4ff674fa986c27ec8a0542479258c92d361a2566 ]

The ::avg_load field is a long-standing misnomer: it says it's an
'average load', but in reality it's the momentary sum of the load
of all currently runnable tasks. We'd have to also perform a
division by nr_running (or use time-decay) to arrive at any sort
of average value.

This is clear from comments about the math of fair scheduling:

    *              \Sum w_i := cfs_rq->avg_load

The sum of all weights is ... the sum of all weights, not
the average of all weights.

To make it doubly confusing, there's also an ::avg_load
in the load-balancing struct sg_lb_stats, which *is* a
true average.

The second part of the field's name is a minor misnomer
as well: it says 'load', and it is indeed a load_weight
structure as it shares code with the load-balancer - but
it's only in an SMP load-balancing context where
load = weight, in the fair scheduling context the primary
purpose is the weighting of different nice levels.

So rename the field to ::sum_weight instead, which makes
the terminology of the EEVDF math match up with our
implementation of it:

    *              \Sum w_i := cfs_rq->sum_weight

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251201064647.1851919-6-mingo@kernel.org
Stable-dep-of: b3d99f43c72b ("sched/fair: Fix zero_vruntime tracking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c  | 16 ++++++++--------
 kernel/sched/sched.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 82038166d7b0c..e68e894b57559 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -608,7 +608,7 @@ static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
  *
  *                    v0 := cfs_rq->zero_vruntime
  * \Sum (v_i - v0) * w_i := cfs_rq->avg_vruntime
- *              \Sum w_i := cfs_rq->avg_load
+ *              \Sum w_i := cfs_rq->sum_weight
  *
  * Since zero_vruntime closely tracks the per-task service, these
  * deltas: (v_i - v), will be in the order of the maximal (virtual) lag
@@ -625,7 +625,7 @@ avg_vruntime_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	s64 key = entity_key(cfs_rq, se);
 
 	cfs_rq->avg_vruntime += key * weight;
-	cfs_rq->avg_load += weight;
+	cfs_rq->sum_weight += weight;
 }
 
 static void
@@ -635,16 +635,16 @@ avg_vruntime_sub(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	s64 key = entity_key(cfs_rq, se);
 
 	cfs_rq->avg_vruntime -= key * weight;
-	cfs_rq->avg_load -= weight;
+	cfs_rq->sum_weight -= weight;
 }
 
 static inline
 void avg_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
 {
 	/*
-	 * v' = v + d ==> avg_vruntime' = avg_runtime - d*avg_load
+	 * v' = v + d ==> avg_vruntime' = avg_runtime - d*sum_weight
 	 */
-	cfs_rq->avg_vruntime -= cfs_rq->avg_load * delta;
+	cfs_rq->avg_vruntime -= cfs_rq->sum_weight * delta;
 }
 
 /*
@@ -655,7 +655,7 @@ u64 avg_vruntime(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
 	s64 avg = cfs_rq->avg_vruntime;
-	long load = cfs_rq->avg_load;
+	long load = cfs_rq->sum_weight;
 
 	if (curr && curr->on_rq) {
 		unsigned long weight = scale_load_down(curr->load.weight);
@@ -723,7 +723,7 @@ static int vruntime_eligible(struct cfs_rq *cfs_rq, u64 vruntime)
 {
 	struct sched_entity *curr = cfs_rq->curr;
 	s64 avg = cfs_rq->avg_vruntime;
-	long load = cfs_rq->avg_load;
+	long load = cfs_rq->sum_weight;
 
 	if (curr && curr->on_rq) {
 		unsigned long weight = scale_load_down(curr->load.weight);
@@ -5164,7 +5164,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		 *
 		 *   vl_i = (W + w_i)*vl'_i / W
 		 */
-		load = cfs_rq->avg_load;
+		load = cfs_rq->sum_weight;
 		if (curr && curr->on_rq)
 			load += scale_load_down(curr->load.weight);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 2f8b06b12a98f..20b2b7746c3c7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -681,7 +681,7 @@ struct cfs_rq {
 	unsigned int		h_nr_idle; /* SCHED_IDLE */
 
 	s64			avg_vruntime;
-	u64			avg_load;
+	u64			sum_weight;
 
 	u64			zero_vruntime;
 #ifdef CONFIG_SCHED_CORE
-- 
2.51.0

