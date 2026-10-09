Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA6E207DF7;
	Fri,  9 Oct 2026 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555311; cv=none; b=H8/jo/znKLckkkjxS2oj5htukAWb/AB9gY3FA5QCMXqwD7Hq6D6aSElvtLI9F9Xb2hOZ6+LAMYmCSagXS1951ENDooskTcYLS8OoAZYfT7D0neEuJWA+N/XrLOZ+HAa3hNfkJvvZeCwBenCddvUE14vNvSKOz3qsmAbD+MmmeJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555311; c=relaxed/simple;
	bh=f1AXz1xDPXfVdn5BKZPhiLxGBcOFPBnfBEsmenefeJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7p8mUFzdyToP44f96tFrQ2r2tci6lLRtwayUmNhCb+K97ahivZIFQUDYzAg/+B0Oo8GX9pN2IoLpae6elCMfeBFBkleJrYhXs6k3SDTJ1v8dR/IDECMb98l/RxkcSTV6Y/os8eAsPTNTUQtncK9JTM6L7zJfo7CMg+5JXbnXbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SswZ6ESs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SswZ6ESs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3A81F00893;
	Fri,  9 Oct 2026 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555299;
	bh=PcOSLfgZeWpCRvylGTzqrXQNjs+jVzS0u3UDO6k3WUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SswZ6ESsmLNRdlexkBFhrtjCOlpI4pN7AnJcVh60qsWE0MziAHLwH4r/TJHmmMJRi
	 qaCOciy2vlr/6KqABLc70h11O+EBr+/6xDTWRwu+w1w3/i+5FGyKqDIwmm0Vv59ivg
	 Bbi69Kh39MGeHQdGKX2JRN+VgWUc+lLCEiIVzskQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Kayra Cizmeci <kayracizmeci@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 7.2 006/428] sched/cache: Keep nr_pref_llc_running in the runnable domain, to fix LLC mis-scheduling bug
Date: Fri,  9 Oct 2026 16:05:43 +0200
Message-ID: <20261009140946.167424079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Chen <tim.c.chen@linux.intel.com>

[ Upstream commit 0d6526f82c3cdefcca47f73f5fc08dc6f335eac6 ]

alb_break_llc() decides whether to break LLC preference during active
load balance. It does so by testing that every runnable fair task on the
source rq prefers its LLC:

	env->src_rq->nr_pref_llc_running == env->src_rq->cfs.h_nr_runnable

But the two counters cover different sets. nr_pref_llc_running is updated
in account_llc_enqueue()/account_llc_dequeue(), next to cfs_rq->nr_queued,
so it follows queued tasks. h_nr_runnable is updated in set_delayed()/
clear_delayed() and drops delay-dequeued tasks.

So under DELAY_DEQUEUE, a preferring task that goes to sleep stays counted
in nr_pref_llc_running while h_nr_runnable falls. The equality then breaks,
alb_break_llc() returns false, and active balance is free to pull a task
off its preferred LLC. Active balance only moves runnable tasks, and this
is the only LLC check it consults: once the stopper runs, LBF_ACTIVE_LB
skips the per-task test in can_migrate_task(). The runnable set is the one
we want.

Fix it on the counter side. A task should be counted in
nr_pref_llc_running exactly while it is both queued on its preferred LLC
(pref_llc_queued) and runnable (!sched_delayed). Define that membership
once in task_pref_llc_runnable(), and adjust the counter only through
pref_llc_running_inc()/pref_llc_running_dec() from the four sites that
change either input: account_llc_enqueue(), account_llc_dequeue(),
set_delayed() and clear_delayed(). Gating every update on the same
predicate keeps the delay, wake and dequeue paths from double-counting
or underflowing; see the comments at those sites for the ordering.

nr_llc_running and sd->llc_counts are not touched and stay on queued
semantics.

Fixes: 714059f79ff0 ("sched/cache: Handle moving single tasks to/from their preferred LLC")
Closes: https://lore.kernel.org/lkml/20260827135000.735138-1-zhanxusheng@xiaomi.com/
Reported-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Suggested-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
Cc: <stable@kernel.org> # v7.2.x
Link: https://patch.msgid.link/06af61afedac32e6477f57feb4d658f6c411c3af.1790035273.git.tim.c.chen@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 63 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ad560e59610f4..855ff50349f15 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1517,6 +1517,28 @@ static bool invalid_llc_nr(struct mm_struct *mm, struct task_struct *p,
 			(scale * per_cpu(sd_llc_size, cpu)));
 }
 
+/*
+ * A task counts in nr_pref_llc_running while it is queued on its preferred
+ * LLC (pref_llc_queued) and runnable (!sched_delayed), keeping the counter in
+ * the runnable domain so alb_break_llc() can compare it with h_nr_runnable.
+ */
+static bool task_pref_llc_runnable(struct task_struct *p)
+{
+	return p->pref_llc_queued && !p->se.sched_delayed;
+}
+
+static void pref_llc_running_inc(struct rq *rq, struct task_struct *p)
+{
+	if (task_pref_llc_runnable(p))
+		rq->nr_pref_llc_running++;
+}
+
+static void pref_llc_running_dec(struct rq *rq, struct task_struct *p)
+{
+	if (task_pref_llc_runnable(p))
+		rq->nr_pref_llc_running--;
+}
+
 static void account_llc_enqueue(struct rq *rq, struct task_struct *p)
 {
 	int pref_llc, pref_llc_queued;
@@ -1528,7 +1550,6 @@ static void account_llc_enqueue(struct rq *rq, struct task_struct *p)
 
 	pref_llc_queued = (pref_llc == task_llc(p));
 	rq->nr_llc_running++;
-	rq->nr_pref_llc_running += pref_llc_queued;
 
 	/*
 	 * Record whether p is enqueued on its preferred
@@ -1546,6 +1567,9 @@ static void account_llc_enqueue(struct rq *rq, struct task_struct *p)
 	 */
 	p->pref_llc_queued = pref_llc_queued;
 
+	/* Skipped while delayed; clear_delayed() adds it back on wake. */
+	pref_llc_running_inc(rq, p);
+
 	sd = rcu_dereference_all(rq->sd);
 	if (sd && (unsigned int)pref_llc < sd->llc_max)
 		sd->llc_counts[pref_llc]++;
@@ -1562,7 +1586,12 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
 
 	rq->nr_llc_running--;
 	if (p->pref_llc_queued) {
-		rq->nr_pref_llc_running--;
+		/*
+		 * Skipped if still delayed (set_delayed() already removed it);
+		 * clearing pref_llc_queued below also stops clear_delayed()
+		 * from re-adding it.
+		 */
+		pref_llc_running_dec(rq, p);
 		/*
 		 * Update the status in case
 		 * other logic might query
@@ -2027,6 +2056,7 @@ void init_sched_mm(struct task_struct *p)
 	 * polluting account_llc_enqueue().
 	 */
 	p->preferred_llc = -1;
+	p->pref_llc_queued = 0;
 }
 
 #else /* CONFIG_SCHED_CACHE */
@@ -2048,6 +2078,10 @@ static void account_llc_enqueue(struct rq *rq, struct task_struct *p) {}
 
 static void account_llc_dequeue(struct rq *rq, struct task_struct *p) {}
 
+static void pref_llc_running_inc(struct rq *rq, struct task_struct *p) {}
+
+static void pref_llc_running_dec(struct rq *rq, struct task_struct *p) {}
+
 #endif /* CONFIG_SCHED_CACHE */
 
 /*
@@ -6278,15 +6312,27 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void set_delayed(struct sched_entity *se)
 {
-	se->sched_delayed = 1;
-
 	/*
 	 * Delayed se of cfs_rq have no tasks queued on them.
 	 * Do not adjust h_nr_runnable since dequeue_entities()
 	 * will account it for blocked tasks.
+	 *
+	 * This check can be removed because when flat pick
+	 * patches get merged as only task can get delayed,
+	 * same for clear_delayed().
 	 */
-	if (!entity_is_task(se))
+	if (!entity_is_task(se)) {
+		se->sched_delayed = 1;
 		return;
+	}
+
+	/*
+	 * Drop a task leaving the runnable set.
+	 * Needs to be called before sched_delayed is set.
+	 * clear_delayed() mirrors this after clearing the flag.
+	 */
+	pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
+	se->sched_delayed = 1;
 
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
@@ -6308,6 +6354,13 @@ static void clear_delayed(struct sched_entity *se)
 	if (!entity_is_task(se))
 		return;
 
+	/*
+	 * Re-add on wake, after sched_delayed is cleared. On a final delayed
+	 * dequeue account_llc_dequeue() already cleared pref_llc_queued, so
+	 * this does nothing.
+	 */
+	pref_llc_running_inc(rq_of(cfs_rq_of(se)), task_of(se));
+
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-- 
2.53.0



