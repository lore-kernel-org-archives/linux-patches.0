Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730BC3876CE;
	Tue, 10 Mar 2026 11:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141655; cv=none; b=QU4cOg6gnZIqr9JhcqIqWaFYWKK5qofdk4AF+67on23VVT3jJbXZFoBmFN1fqLH0eGvhuKrUXiekN8auRR4289b9dc6D7r0EY8PGENkUvQPipCHMO/1WQLJEWRMWntJJyB3HuHiZz1XUlVBk+Ka0NA7r9iR85Ra53XGwahjevDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141655; c=relaxed/simple;
	bh=IKnToJ7JYSApAWcRQ3qPJ1Tc1pVsmftIcVmxyfKl8X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VH7va+woUkBd0cqRhbB7x/jqlAfPjTYquqTnMO34O89PBlmyghysSx/Ov6J1Gf3iigl3KmQ0nrvJgxkgJ5vi0ZqR6maC86aTLXPKzOYSpTEegmc8bpmtRYaAvVBvS2fnUtSt85gimfb1agKR1rqVqFdpIe2BrtLRRoi4nLIHXYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIVrlhKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIVrlhKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764E9C2BC86;
	Tue, 10 Mar 2026 11:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141655;
	bh=IKnToJ7JYSApAWcRQ3qPJ1Tc1pVsmftIcVmxyfKl8X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIVrlhKG6l5TX/yhu9iz4ssbNMsPZK738AkpJM+396UljUjxIP96qlI5jI09Bo2b1
	 tPy0tJd4DmFiMiI73G9TPGjbD6j7Ql4VnQZAxQEqMqZBtd5ZtnK12qZYUM6alBdWDl
	 gHX3UCvQLvQAd+JpNzMGLQgPpycQY/BQpDJ6EVJXHrsvryuaouo+dKKS62LxoyO8gX
	 zR5oK1L9P+rOUO8tIiI0EOd4tdavJKvmQ4Ra/wFzQmCgmgwnwfGkE0iZrhFNet4wSZ
	 XJGW1mHNUKp+YFEged0bDUJoWq1h8ZiprwMWssmneBF+pLZZy/Uqq/5dn9Cmx3+zb0
	 y6DyYPkArxy5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shubhang Kaushik <shubhang@os.amperecomputing.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/314] sched/fair: Fix zero_vruntime tracking
Date: Tue, 10 Mar 2026 07:14:41 -0400
Message-ID: <05467440d95c78161254bab895be5692e4f0a3f3.1773141555.git.sashal@kernel.org>
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

[ Upstream commit b3d99f43c72b56cf7a104a364e7fb34b0702828b ]

It turns out that zero_vruntime tracking is broken when there is but a single
task running. Current update paths are through __{en,de}queue_entity(), and
when there is but a single task, pick_next_task() will always return that one
task, and put_prev_set_next_task() will end up in neither function.

This can cause entity_key() to grow indefinitely large and cause overflows,
leading to much pain and suffering.

Furtermore, doing update_zero_vruntime() from __{de,en}queue_entity(), which
are called from {set_next,put_prev}_entity() has problems because:

 - set_next_entity() calls __dequeue_entity() before it does cfs_rq->curr = se.
   This means the avg_vruntime() will see the removal but not current, missing
   the entity for accounting.

 - put_prev_entity() calls __enqueue_entity() before it does cfs_rq->curr =
   NULL. This means the avg_vruntime() will see the addition *and* current,
   leading to double accounting.

Both cases are incorrect/inconsistent.

Noting that avg_vruntime is already called on each {en,de}queue, remove the
explicit avg_vruntime() calls (which removes an extra 64bit division for each
{en,de}queue) and have avg_vruntime() update zero_vruntime itself.

Additionally, have the tick call avg_vruntime() -- discarding the result, but
for the side-effect of updating zero_vruntime.

While there, optimize avg_vruntime() by noting that the average of one value is
rather trivial to compute.

Test case:
  # taskset -c -p 1 $$
  # taskset -c 2 bash -c 'while :; do :; done&'
  # cat /sys/kernel/debug/sched/debug | awk '/^cpu#/ {P=0} /^cpu#2,/ {P=1} {if (P) print $0}' | grep -e zero_vruntime -e "^>"

PRE:
    .zero_vruntime                 : 31316.407903
  >R            bash   487     50787.345112   E       50789.145972           2.800000     50780.298364        16     120         0.000000         0.000000         0.000000        /
    .zero_vruntime                 : 382548.253179
  >R            bash   487    427275.204288   E      427276.003584           2.800000    427268.157540        23     120         0.000000         0.000000         0.000000        /

POST:
    .zero_vruntime                 : 17259.709467
  >R            bash   526     17259.709467   E       17262.509467           2.800000     16915.031624         9     120         0.000000         0.000000         0.000000        /
    .zero_vruntime                 : 18702.723356
  >R            bash   526     18702.723356   E       18705.523356           2.800000     18358.045513         9     120         0.000000         0.000000         0.000000        /

Fixes: 79f3f9bedd14 ("sched/eevdf: Fix min_vruntime vs avg_vruntime")
Reported-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Link: https://patch.msgid.link/20260219080624.438854780%40infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 84 ++++++++++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 27 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f669c84c7c0e9..c3735197c6e7c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -589,6 +589,21 @@ static inline bool entity_before(const struct sched_entity *a,
 	return vruntime_cmp(a->deadline, "<", b->deadline);
 }
 
+/*
+ * Per avg_vruntime() below, cfs_rq::zero_vruntime is only slightly stale
+ * and this value should be no more than two lag bounds. Which puts it in the
+ * general order of:
+ *
+ *	(slice + TICK_NSEC) << NICE_0_LOAD_SHIFT
+ *
+ * which is around 44 bits in size (on 64bit); that is 20 for
+ * NICE_0_LOAD_SHIFT, another 20 for NSEC_PER_MSEC and then a handful for
+ * however many msec the actual slice+tick ends up begin.
+ *
+ * (disregarding the actual divide-by-weight part makes for the worst case
+ * weight of 2, which nicely cancels vs the fuzz in zero_vruntime not actually
+ * being the zero-lag point).
+ */
 static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	return vruntime_op(se->vruntime, "-", cfs_rq->zero_vruntime);
@@ -676,39 +691,61 @@ sum_w_vruntime_sub(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 static inline
-void sum_w_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
+void update_zero_vruntime(struct cfs_rq *cfs_rq, s64 delta)
 {
 	/*
-	 * v' = v + d ==> sum_w_vruntime' = sum_runtime - d*sum_weight
+	 * v' = v + d ==> sum_w_vruntime' = sum_w_vruntime - d*sum_weight
 	 */
 	cfs_rq->sum_w_vruntime -= cfs_rq->sum_weight * delta;
+	cfs_rq->zero_vruntime += delta;
 }
 
 /*
- * Specifically: avg_runtime() + 0 must result in entity_eligible() := true
+ * Specifically: avg_vruntime() + 0 must result in entity_eligible() := true
  * For this to be so, the result of this function must have a left bias.
+ *
+ * Called in:
+ *  - place_entity()      -- before enqueue
+ *  - update_entity_lag() -- before dequeue
+ *  - entity_tick()
+ *
+ * This means it is one entry 'behind' but that puts it close enough to where
+ * the bound on entity_key() is at most two lag bounds.
  */
 u64 avg_vruntime(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	s64 avg = cfs_rq->sum_w_vruntime;
-	long load = cfs_rq->sum_weight;
+	long weight = cfs_rq->sum_weight;
+	s64 delta = 0;
 
-	if (curr && curr->on_rq) {
-		unsigned long weight = scale_load_down(curr->load.weight);
+	if (curr && !curr->on_rq)
+		curr = NULL;
 
-		avg += entity_key(cfs_rq, curr) * weight;
-		load += weight;
-	}
+	if (weight) {
+		s64 runtime = cfs_rq->sum_w_vruntime;
+
+		if (curr) {
+			unsigned long w = scale_load_down(curr->load.weight);
+
+			runtime += entity_key(cfs_rq, curr) * w;
+			weight += w;
+		}
 
-	if (load) {
 		/* sign flips effective floor / ceiling */
-		if (avg < 0)
-			avg -= (load - 1);
-		avg = div_s64(avg, load);
+		if (runtime < 0)
+			runtime -= (weight - 1);
+
+		delta = div_s64(runtime, weight);
+	} else if (curr) {
+		/*
+		 * When there is but one element, it is the average.
+		 */
+		delta = curr->vruntime - cfs_rq->zero_vruntime;
 	}
 
-	return cfs_rq->zero_vruntime + avg;
+	update_zero_vruntime(cfs_rq, delta);
+
+	return cfs_rq->zero_vruntime;
 }
 
 /*
@@ -777,16 +814,6 @@ int entity_eligible(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return vruntime_eligible(cfs_rq, se->vruntime);
 }
 
-static void update_zero_vruntime(struct cfs_rq *cfs_rq)
-{
-	u64 vruntime = avg_vruntime(cfs_rq);
-	s64 delta = vruntime_op(vruntime, "-", cfs_rq->zero_vruntime);
-
-	sum_w_vruntime_update(cfs_rq, delta);
-
-	cfs_rq->zero_vruntime = vruntime;
-}
-
 static inline u64 cfs_rq_min_slice(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *root = __pick_root_entity(cfs_rq);
@@ -856,7 +883,6 @@ RB_DECLARE_CALLBACKS(static, min_vruntime_cb, struct sched_entity,
 static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	sum_w_vruntime_add(cfs_rq, se);
-	update_zero_vruntime(cfs_rq);
 	se->min_vruntime = se->vruntime;
 	se->min_slice = se->slice;
 	rb_add_augmented_cached(&se->run_node, &cfs_rq->tasks_timeline,
@@ -868,7 +894,6 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	rb_erase_augmented_cached(&se->run_node, &cfs_rq->tasks_timeline,
 				  &min_vruntime_cb);
 	sum_w_vruntime_sub(cfs_rq, se);
-	update_zero_vruntime(cfs_rq);
 }
 
 struct sched_entity *__pick_root_entity(struct cfs_rq *cfs_rq)
@@ -5566,6 +5591,11 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	update_load_avg(cfs_rq, curr, UPDATE_TG);
 	update_cfs_group(curr);
 
+	/*
+	 * Pulls along cfs_rq::zero_vruntime.
+	 */
+	avg_vruntime(cfs_rq);
+
 #ifdef CONFIG_SCHED_HRTICK
 	/*
 	 * queued ticks are scheduled to match the slice, so don't bother
-- 
2.51.0

