Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A17383C64;
	Tue, 10 Mar 2026 11:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140788; cv=none; b=mnFiXb/RKDthTU8NiMJxiRa3FyrHlwH7moQmIiC3b+iVFm3kdKprNGw3CTEjRUts7Cmw6fQCoP4goa8QXPScsn1XGvH7Ggl8wi0obTtiDECeTQkqzoHho4snWKh1F7cWadl84DgUx23D0cEAOnvMLZVBVhzeLwwRlLVFDCDupzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140788; c=relaxed/simple;
	bh=w68fUvy8ATjh1l/PhTgsCriiSDkhTsu2/UF/Lv2IpqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/NWUAW5T0ieD+52bb1EwNxZZxLrkSPYAD/A88Hvtj6yNutLtjElUHgy8gkbEMMENvoibWvSZOKNKym8rMr8gFjPUx4n3Osfh7RnOYn+KCbdFyuUtBlDfhzOBJJw5NCx5Ufqj1CFO8Z99cmxFtNoErGclHCisPf4x/17g2l6AXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNLyrtgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNLyrtgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB6DC19423;
	Tue, 10 Mar 2026 11:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140788;
	bh=w68fUvy8ATjh1l/PhTgsCriiSDkhTsu2/UF/Lv2IpqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNLyrtgE0R0++U9ITG4GXKHLoZiBzjQd9tmvOhmpoqKa1o7Q/+ABf1IWlDfEtr42a
	 sQS9tD6yqdMaEciAleqmpturin+QJ3rqxd/FUuVFDmc/c0gxRlJI7bQEHn0wJj29G6
	 ToiUyXPxm+48pNBvCN4z3TCtft+MOgEex+VkKIvn3yBYJNk4SI6HpRCHVHtAaHXMtl
	 1AIotz3nrHDvI8OimokQPeODGk4t54sb6PULly8Z3/Pi6JoidEbOW/oFF6pMa8PiRF
	 QfnX8FImmGydFHpFp7czZFD6tLgNvGDCdAURbnKGsdhzthB8dUQVu7EYmLA0EpHWyS
	 ur25McMSZaS5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 024/311] sched/fair: Rename cfs_rq::avg_vruntime to ::sum_w_vruntime, and helper functions
Date: Tue, 10 Mar 2026 07:01:11 -0400
Message-ID: <3f7f55021433242ba031be220fa72d3746bb2d82.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

[ Upstream commit dcbc9d3f0e594223275a18f7016001889ad35eff ]

The ::avg_vruntime field is a  misnomer: it says it's an
'average vruntime', but in reality it's the momentary sum
of the weighted vruntimes of all queued tasks, which is
at least a division away from being an average.

This is clear from comments about the math of fair scheduling:

    * \Sum (v_i - v0) * w_i := cfs_rq->avg_vruntime

This confusion is increased by the cfs_avg_vruntime() function,
which does perform the division and returns a true average.

The sum of all weighted vruntimes should be named thusly,
so rename the field to ::sum_w_vruntime. (As arguably
::sum_weighted_vruntime would be a bit of a mouthful.)

Understanding the scheduler is hard enough already, without
extra layers of obfuscated naming. ;-)

Also rename related helper functions:

  sum_vruntime_add()    => sum_w_vruntime_add()
  sum_vruntime_sub()    => sum_w_vruntime_sub()
  sum_vruntime_update() => sum_w_vruntime_update()

With the notable exception of cfs_avg_vruntime(), which
was named accurately.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251201064647.1851919-7-mingo@kernel.org
Stable-dep-of: b3d99f43c72b ("sched/fair: Fix zero_vruntime tracking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c  | 26 +++++++++++++-------------
 kernel/sched/sched.h |  2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index afb774c2f7bf7..f06a5d36106b4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -607,7 +607,7 @@ static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * Which we track using:
  *
  *                    v0 := cfs_rq->zero_vruntime
- * \Sum (v_i - v0) * w_i := cfs_rq->avg_vruntime
+ * \Sum (v_i - v0) * w_i := cfs_rq->sum_w_vruntime
  *              \Sum w_i := cfs_rq->sum_weight
  *
  * Since zero_vruntime closely tracks the per-task service, these
@@ -619,32 +619,32 @@ static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * As measured, the max (key * weight) value was ~44 bits for a kernel build.
  */
 static void
-avg_vruntime_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+sum_w_vruntime_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	unsigned long weight = scale_load_down(se->load.weight);
 	s64 key = entity_key(cfs_rq, se);
 
-	cfs_rq->avg_vruntime += key * weight;
+	cfs_rq->sum_w_vruntime += key * weight;
 	cfs_rq->sum_weight += weight;
 }
 
 static void
-avg_vruntime_sub(struct cfs_rq *cfs_rq, struct sched_entity *se)
+sum_w_vruntime_sub(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	unsigned long weight = scale_load_down(se->load.weight);
 	s64 key = entity_key(cfs_rq, se);
 
-	cfs_rq->avg_vruntime -= key * weight;
+	cfs_rq->sum_w_vruntime -= key * weight;
 	cfs_rq->sum_weight -= weight;
 }
 
 static inline
-void avg_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
+void sum_w_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
 {
 	/*
-	 * v' = v + d ==> avg_vruntime' = avg_runtime - d*sum_weight
+	 * v' = v + d ==> sum_w_vruntime' = sum_runtime - d*sum_weight
 	 */
-	cfs_rq->avg_vruntime -= cfs_rq->sum_weight * delta;
+	cfs_rq->sum_w_vruntime -= cfs_rq->sum_weight * delta;
 }
 
 /*
@@ -654,7 +654,7 @@ void avg_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
 u64 avg_vruntime(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	s64 avg = cfs_rq->avg_vruntime;
+	s64 avg = cfs_rq->sum_w_vruntime;
 	long load = cfs_rq->sum_weight;
 
 	if (curr && curr->on_rq) {
@@ -722,7 +722,7 @@ static void update_entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static int vruntime_eligible(struct cfs_rq *cfs_rq, u64 vruntime)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	s64 avg = cfs_rq->avg_vruntime;
+	s64 avg = cfs_rq->sum_w_vruntime;
 	long load = cfs_rq->sum_weight;
 
 	if (curr && curr->on_rq) {
@@ -745,7 +745,7 @@ static void update_zero_vruntime(struct cfs_rq *cfs_rq)
 	u64 vruntime = avg_vruntime(cfs_rq);
 	s64 delta = (s64)(vruntime - cfs_rq->zero_vruntime);
 
-	avg_vruntime_update(cfs_rq, delta);
+	sum_w_vruntime_update(cfs_rq, delta);
 
 	cfs_rq->zero_vruntime = vruntime;
 }
@@ -819,7 +819,7 @@ RB_DECLARE_CALLBACKS(static, min_vruntime_cb, struct sched_entity,
  */
 static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	avg_vruntime_add(cfs_rq, se);
+	sum_w_vruntime_add(cfs_rq, se);
 	update_zero_vruntime(cfs_rq);
 	se->min_vruntime = se->vruntime;
 	se->min_slice = se->slice;
@@ -831,7 +831,7 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	rb_erase_augmented_cached(&se->run_node, &cfs_rq->tasks_timeline,
 				  &min_vruntime_cb);
-	avg_vruntime_sub(cfs_rq, se);
+	sum_w_vruntime_sub(cfs_rq, se);
 	update_zero_vruntime(cfs_rq);
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f4e9a21cf0936..d3485d48be281 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -678,7 +678,7 @@ struct cfs_rq {
 	unsigned int		h_nr_runnable;     /* SCHED_{NORMAL,BATCH,IDLE} */
 	unsigned int		h_nr_idle; /* SCHED_IDLE */
 
-	s64			avg_vruntime;
+	s64			sum_w_vruntime;
 	u64			sum_weight;
 
 	u64			zero_vruntime;
-- 
2.51.0

