Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7A331354B;
	Wed,  3 Dec 2025 20:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764793786; cv=none; b=ddoFZitftksqCN93NfNnXM4Ztp7nRTOUvRqiXwRbGToPovzosnZXJpPE/satWyqKr/MUitSGsMCvNcppcwAUvpcN+9k+EhuoozsqyzANVsn1y7339kr0aDj1Z5TpDGthQMViWvCZc+OEyKE+KvSVJCksVkeShoos3PVdFjR1zEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764793786; c=relaxed/simple;
	bh=NSUJzjsQd33DgLTn4foaiEKrvWV6nMtKd2xZ7eYS15k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrL4ipBWMYaVf0+9K+aMcrzm/WZodbNURS4curwMLkfuAaxpOfMDKGb4u4TDB5VBiJ6RFSElRC5rPXtTFOvGNY2Up8zZNaMEswzpMxvG0kjNW1C4znsyh+rWTZz/oSdzu5y7x3wF4WBSI7+x5KqzQW9jtI9f56IB89taaUxKUhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFxYiChU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFxYiChU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37919C4CEF5;
	Wed,  3 Dec 2025 20:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764793785;
	bh=NSUJzjsQd33DgLTn4foaiEKrvWV6nMtKd2xZ7eYS15k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFxYiChUJc5x9Bg3ky7ZUcyGJSn08eoL1PhDyt+ObqKlro7CWzrDjAGjRfQ9cjClV
	 zjloDz6blFnAJ5dJ8FjfjmJrp0L+8ulyEUbLfTJI+LxVRKtg/5FMIfe7IdlgWIa0N2
	 13SWonydqZzLg9PCs1gpK1KBHUHgoMjFS5doQfeRqAaewq4Wn7xV8pCQxYp3Ia4PeT
	 yMgnkpN7mp3Y3043oXam4jYIwHjnTkdRA6N8z3BpY2kxVHS+rqiNlLIgY+VG+nn/1q
	 MjhTLJPnw8tA9QlvghbQmim0FfTvoXgBQBaa8dy7yanRIlOIMPvSpnj8yjVbpe4dQu
	 WGxiz2RYO/iTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Doug Berger <opendmb@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] sched/deadline: only set free_cpus for online runqueues
Date: Wed,  3 Dec 2025 15:29:30 -0500
Message-ID: <20251203202933.826777-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251203202933.826777-1-sashal@kernel.org>
References: <20251203202933.826777-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 382748c05e58a9f1935f5a653c352422375566ea ]

Commit 16b269436b72 ("sched/deadline: Modify cpudl::free_cpus
to reflect rd->online") introduced the cpudl_set/clear_freecpu
functions to allow the cpu_dl::free_cpus mask to be manipulated
by the deadline scheduler class rq_on/offline callbacks so the
mask would also reflect this state.

Commit 9659e1eeee28 ("sched/deadline: Remove cpu_active_mask
from cpudl_find()") removed the check of the cpu_active_mask to
save some processing on the premise that the cpudl::free_cpus
mask already reflected the runqueue online state.

Unfortunately, there are cases where it is possible for the
cpudl_clear function to set the free_cpus bit for a CPU when the
deadline runqueue is offline. When this occurs while a CPU is
connected to the default root domain the flag may retain the bad
state after the CPU has been unplugged. Later, a different CPU
that is transitioning through the default root domain may push a
deadline task to the powered down CPU when cpudl_find sees its
free_cpus bit is set. If this happens the task will not have the
opportunity to run.

One example is outlined here:
https://lore.kernel.org/lkml/20250110233010.2339521-1-opendmb@gmail.com

Another occurs when the last deadline task is migrated from a
CPU that has an offlined runqueue. The dequeue_task member of
the deadline scheduler class will eventually call cpudl_clear
and set the free_cpus bit for the CPU.

This commit modifies the cpudl_clear function to be aware of the
online state of the deadline runqueue so that the free_cpus mask
can be updated appropriately.

It is no longer necessary to manage the mask outside of the
cpudl_set/clear functions so the cpudl_set/clear_freecpu
functions are removed. In addition, since the free_cpus mask is
now only updated under the cpudl lock the code was changed to
use the non-atomic __cpumask functions.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
summarize:

## DETAILED ANALYSIS

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: `sched/deadline: only set free_cpus for online runqueues`

**Key points from message**:
- References two previous commits that introduced the bug:
  - `16b269436b72` ("sched/deadline: Modify cpudl::free_cpus to reflect
    rd->online") - from v4.0-rc1
  - `9659e1eeee28` ("sched/deadline: Remove cpu_active_mask from
    cpudl_find()") - from v4.0-rc1
- Describes a real bug where `cpudl_clear()` can incorrectly set
  `free_cpus` bit for an offline CPU
- **Consequence**: Tasks can be pushed to powered-down CPUs and won't
  run

**Missing tags**:
- **NO "Cc: stable@vger.kernel.org"** - maintainer didn't explicitly
  request stable backport
- **NO "Fixes:" tag** - doesn't explicitly reference the buggy commit

### 2. CODE CHANGE ANALYSIS

**The Bug Mechanism**:
1. `cpudl::free_cpus` tracks which CPUs can receive deadline tasks
2. When a CPU goes offline, `rq_offline_dl()` calls `cpudl_clear()` +
   `cpudl_clear_freecpu()` to clear its bit
3. **BUT**: If the last DL task is later migrated away from that offline
   CPU, `dec_dl_deadline()` calls `cpudl_clear()` which
   **unconditionally sets the bit** in `free_cpus`
4. Now `cpudl_find()` sees this offline CPU as available and may push
   tasks to it
5. **Result**: Tasks pushed to offline CPUs won't run - **task
   starvation**

**The Fix**:
- Adds `bool online` parameter to `cpudl_clear(struct cpudl *cp, int
  cpu, bool online)`
- `dec_dl_deadline()`: passes `rq->online` - only sets bit if CPU is
  online
- `rq_online_dl()`: passes `true`
- `rq_offline_dl()`: passes `false` - ensures bit stays cleared
- Removes now-unnecessary `cpudl_set_freecpu()` and
  `cpudl_clear_freecpu()` helpers
- Uses non-atomic `__cpumask_*` functions since operations are under
  `cp->lock`

### 3. SCOPE AND RISK ASSESSMENT

**Files changed**: 3 (cpudeadline.c, cpudeadline.h, deadline.c)
**Lines changed**: +14 / -32 (net code removal)

**Risk factors**:
- Touches scheduler core code (high impact if wrong)
- Changes function signature (API change)
- BUT: Logic is straightforward - add online state check
- BUT: Self-contained change with no dependencies

### 4. COMPATIBILITY CHECK

Verified the code structure is **identical** across all stable kernels
(v5.4, v5.10, v5.15, v6.1, v6.6):
- `rq->online` field exists in all versions
- `rq_online_dl()` / `rq_offline_dl()` functions are identical
- `cpudl_clear()` signature and callers are identical
- **Fix will apply cleanly to all stable trees**

### 5. USER IMPACT

- **Who's affected**: Users running SCHED_DEADLINE tasks with CPU
  hotplug
- **Severity**: HIGH - tasks may not run (starvation)
- **Bug age**: 10 years (since v4.0-rc1 in 2015)
- **Trigger conditions**: Requires specific timing with CPU hotplug + DL
  tasks
- **Referenced LKML report**: https://lore.kernel.org/lkml/2025011023301
  0.2339521-1-opendmb@gmail.com - shows real-world occurrence

### 6. STABILITY INDICATORS

**Positive**:
- Signed-off by Peter Zijlstra (Intel) - the main scheduler maintainer
- Logic is straightforward and correct
- Self-contained fix

**Concerning**:
- Very fresh commit (just merged to 6.18-rc cycle)
- No Tested-by or Reviewed-by tags
- No explicit stable request from maintainer

### 7. DECISION FACTORS

**FOR backporting**:
1. Fixes a real, severe bug (task starvation)
2. Bug has existed for 10 years affecting ALL stable kernels
3. Fix is small (~50 lines), surgical, and correct
4. Applies cleanly to all stable trees
5. Signed off by scheduler maintainer
6. The change is logically straightforward (add online state awareness)

**AGAINST backporting**:
1. No Cc: stable tag - maintainer didn't explicitly request it
2. No Fixes: tag
3. Brand new commit - hasn't soaked in mainline
4. Scheduler is sensitive - regressions impact all workloads
5. Bug requires specific conditions to trigger

### CONCLUSION

This is a genuine bug fix for a task starvation issue that has existed
since 2015. While the commit lacks explicit stable markers (Cc: stable,
Fixes:), the fix is:
- **Obviously correct** - adds missing online state check
- **Small and contained** - ~50 lines across 3 files
- **Applies cleanly** - code structure identical in all stable kernels
- **Signed off by the maintainer** - Peter Zijlstra reviewed and
  approved it
- **Fixes a severe bug** - tasks pushed to offline CPUs won't run

The absence of explicit stable tagging is concerning and suggests the
maintainer may want it to soak in mainline first. However, the severity
of the bug (task starvation) and the correctness of the fix make it a
reasonable candidate for stable backporting.

**YES**

 kernel/sched/cpudeadline.c | 34 +++++++++-------------------------
 kernel/sched/cpudeadline.h |  4 +---
 kernel/sched/deadline.c    |  8 ++++----
 3 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index cdd740b3f7743..37b572cc8aca2 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -166,12 +166,13 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
  * cpudl_clear - remove a CPU from the cpudl max-heap
  * @cp: the cpudl max-heap context
  * @cpu: the target CPU
+ * @online: the online state of the deadline runqueue
  *
  * Notes: assumes cpu_rq(cpu)->lock is locked
  *
  * Returns: (void)
  */
-void cpudl_clear(struct cpudl *cp, int cpu)
+void cpudl_clear(struct cpudl *cp, int cpu, bool online)
 {
 	int old_idx, new_cpu;
 	unsigned long flags;
@@ -184,7 +185,7 @@ void cpudl_clear(struct cpudl *cp, int cpu)
 	if (old_idx == IDX_INVALID) {
 		/*
 		 * Nothing to remove if old_idx was invalid.
-		 * This could happen if a rq_offline_dl is
+		 * This could happen if rq_online_dl or rq_offline_dl is
 		 * called for a CPU without -dl tasks running.
 		 */
 	} else {
@@ -195,9 +196,12 @@ void cpudl_clear(struct cpudl *cp, int cpu)
 		cp->elements[new_cpu].idx = old_idx;
 		cp->elements[cpu].idx = IDX_INVALID;
 		cpudl_heapify(cp, old_idx);
-
-		cpumask_set_cpu(cpu, cp->free_cpus);
 	}
+	if (likely(online))
+		__cpumask_set_cpu(cpu, cp->free_cpus);
+	else
+		__cpumask_clear_cpu(cpu, cp->free_cpus);
+
 	raw_spin_unlock_irqrestore(&cp->lock, flags);
 }
 
@@ -228,7 +232,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl)
 		cp->elements[new_idx].cpu = cpu;
 		cp->elements[cpu].idx = new_idx;
 		cpudl_heapify_up(cp, new_idx);
-		cpumask_clear_cpu(cpu, cp->free_cpus);
+		__cpumask_clear_cpu(cpu, cp->free_cpus);
 	} else {
 		cp->elements[old_idx].dl = dl;
 		cpudl_heapify(cp, old_idx);
@@ -237,26 +241,6 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl)
 	raw_spin_unlock_irqrestore(&cp->lock, flags);
 }
 
-/*
- * cpudl_set_freecpu - Set the cpudl.free_cpus
- * @cp: the cpudl max-heap context
- * @cpu: rd attached CPU
- */
-void cpudl_set_freecpu(struct cpudl *cp, int cpu)
-{
-	cpumask_set_cpu(cpu, cp->free_cpus);
-}
-
-/*
- * cpudl_clear_freecpu - Clear the cpudl.free_cpus
- * @cp: the cpudl max-heap context
- * @cpu: rd attached CPU
- */
-void cpudl_clear_freecpu(struct cpudl *cp, int cpu)
-{
-	cpumask_clear_cpu(cpu, cp->free_cpus);
-}
-
 /*
  * cpudl_init - initialize the cpudl structure
  * @cp: the cpudl max-heap context
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index 11c0f1faa7e11..d7699468eedd5 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -19,8 +19,6 @@ struct cpudl {
 
 int  cpudl_find(struct cpudl *cp, struct task_struct *p, struct cpumask *later_mask);
 void cpudl_set(struct cpudl *cp, int cpu, u64 dl);
-void cpudl_clear(struct cpudl *cp, int cpu);
+void cpudl_clear(struct cpudl *cp, int cpu, bool online);
 int  cpudl_init(struct cpudl *cp);
-void cpudl_set_freecpu(struct cpudl *cp, int cpu);
-void cpudl_clear_freecpu(struct cpudl *cp, int cpu);
 void cpudl_cleanup(struct cpudl *cp);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 7b7671060bf9e..19b1a8b81c76c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1811,7 +1811,7 @@ static void dec_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
 	if (!dl_rq->dl_nr_running) {
 		dl_rq->earliest_dl.curr = 0;
 		dl_rq->earliest_dl.next = 0;
-		cpudl_clear(&rq->rd->cpudl, rq->cpu);
+		cpudl_clear(&rq->rd->cpudl, rq->cpu, rq->online);
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio.curr);
 	} else {
 		struct rb_node *leftmost = rb_first_cached(&dl_rq->root);
@@ -2883,9 +2883,10 @@ static void rq_online_dl(struct rq *rq)
 	if (rq->dl.overloaded)
 		dl_set_overload(rq);
 
-	cpudl_set_freecpu(&rq->rd->cpudl, rq->cpu);
 	if (rq->dl.dl_nr_running > 0)
 		cpudl_set(&rq->rd->cpudl, rq->cpu, rq->dl.earliest_dl.curr);
+	else
+		cpudl_clear(&rq->rd->cpudl, rq->cpu, true);
 }
 
 /* Assumes rq->lock is held */
@@ -2894,8 +2895,7 @@ static void rq_offline_dl(struct rq *rq)
 	if (rq->dl.overloaded)
 		dl_clear_overload(rq);
 
-	cpudl_clear(&rq->rd->cpudl, rq->cpu);
-	cpudl_clear_freecpu(&rq->rd->cpudl, rq->cpu);
+	cpudl_clear(&rq->rd->cpudl, rq->cpu, false);
 }
 
 void __init init_sched_dl_class(void)
-- 
2.51.0

