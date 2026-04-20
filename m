Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11BD3C65FF;
	Mon, 20 Apr 2026 13:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691057; cv=none; b=SSkx4J6P7WB0gTe3fnvZr+capJf08OIWRXiNvIujaBQG1gBAPUxd7GLlEI09IO0znQyg6IrNCDLObrNfyRHStUM0evWv7U3ha14iqE1ps//SGzE3exDOynyxc6cMX7ggf05t8iW2Bb6bNRA0KbPxHGWNyxSjvj3Jq8FDeUaTUMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691057; c=relaxed/simple;
	bh=DL6OvkoEDX+5B552BSy/iHSkR0WkeMYjdeHssdVlyZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BQFuiaA97nm1XSHua5op+lPnjBsjaG1VxDaWQIWD/WuJVVkStgy63stOkHlnJfRqy5B9SAfPVC6sLh2t0zQ6X/LZ1Wojs/WShiHkU35hbMzdwY2Q/cpivaBPjEnSR/WkFCxjMEELZJt1OOcjLOisAEcKlSVItaYwgwA3nDQb74g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLXwcGhg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLXwcGhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A90C19425;
	Mon, 20 Apr 2026 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691056;
	bh=DL6OvkoEDX+5B552BSy/iHSkR0WkeMYjdeHssdVlyZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLXwcGhgvHM0YqqobwEu/h8ExNS1HqLk8hwOgwSgCGAmG+vwtIKxGWhOM9HJzeuC+
	 FaGkmxxlQr44ys//4dzLVdg4nujsadTQbtRleMyqOUy8IIlwzBehGiLGxcFGEHyZxb
	 O9QGzNHd9jNCi3WDjgVKmI3pAsIGpW1KLBQ+Gc2jm556HVCo7oNB7Mvs7mWV3+o6lr
	 x3IsLfzP45/6L9UToggqh6mjDJttx+oBtAxZ+76qMxjKvm8VTpdI4MgJ+81FEfD7pj
	 laFwtAbgRjyFu9uh5iSTzc592J+G9h+mRJCvo2CujNF39BfD+qnK7+/pI46AEn+TnW
	 rcS7yWBuFN2vg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dengjun Su <dengjun.su@mediatek.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] sched: Fix incorrect schedstats for rt and dl thread
Date: Mon, 20 Apr 2026 09:08:54 -0400
Message-ID: <20260420131539.986432-68-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dengjun Su <dengjun.su@mediatek.com>

[ Upstream commit c0e1832ba6dad7057acf3f485a87e0adccc23141 ]

For RT and DL thread, only 'set_next_task_(rt/dl)' will call
'update_stats_wait_end_(rt/dl)' to update schedstats information.
However, during the migration process,
'update_stats_wait_start_(rt/dl)' will be called twice, which
will cause the values of wait_max and wait_sum to be incorrect.
The specific output as follows:
$ cat /proc/6046/task/6046/sched | grep wait
wait_start                                   :             0.000000
wait_max                                     :        496717.080029
wait_sum                                     :       7921540.776553

A complete schedstats information update flow of migrate should be
__update_stats_wait_start() [enter queue A, stage 1] ->
__update_stats_wait_end()   [leave queue A, stage 2] ->
__update_stats_wait_start() [enter queue B, stage 3] ->
__update_stats_wait_end()   [start running on queue B, stage 4]

    Stage 1: prev_wait_start is 0, and in the end, wait_start records the
    time of entering the queue.
    Stage 2: task_on_rq_migrating(p) is true, and wait_start is updated to
    the waiting time on queue A.
    Stage 3: prev_wait_start is the waiting time on queue A, wait_start is
    the time of entering queue B, and wait_start is expected to be greater
    than prev_wait_start. Under this condition, wait_start is updated to
    (the moment of entering queue B) - (the waiting time on queue A).
    Stage 4: the final wait time = (time when starting to run on queue B)
    - (time of entering queue B) + (waiting time on queue A) = waiting
    time on queue B + waiting time on queue A.

The current problem is that stage 2 does not call __update_stats_wait_end
to update wait_start, which causes the final computed wait time = waiting
time on queue B + the moment of entering queue A, leading to incorrect
wait_max and wait_sum.

Add 'update_stats_wait_end_(rt/dl)' in 'update_stats_dequeue_(rt/dl)' to
update schedstats information when dequeue_task.

Signed-off-by: Dengjun Su <dengjun.su@mediatek.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260204115959.3183567-1-dengjun.su@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `sched` (core scheduler)
- **Action verb**: "Fix"
- **Summary**: Fixes incorrect schedstats wait_max and wait_sum for RT
  and DL tasks during migration

Record: [sched] [fix] [incorrect schedstats for RT/DL threads during
migration]

### Step 1.2: Tags
- `Signed-off-by: Dengjun Su <dengjun.su@mediatek.com>` - author from
  MediaTek
- `Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>` -
  scheduler maintainer accepted the patch
- `Link: https://patch.msgid.link/20260204115959.3183567-1-
  dengjun.su@mediatek.com` - patch submission link
- No Fixes: tag (expected for our review pipeline)
- No Cc: stable tag (expected)
- No Reported-by (author discovered it themselves)

Record: Accepted by Peter Zijlstra, the primary scheduler maintainer.
Single patch (not a series).

### Step 1.3: Commit Body Analysis
The commit provides a detailed 4-stage explanation of how wait
accounting should work during migration:
1. Enter queue A: `wait_start` = time of entering
2. Leave queue A (migration): `wait_start` should be updated to "wait
   time on A"
3. Enter queue B: `wait_start` adjusted by subtracting "wait time on A"
4. Start running on B: final wait = time on B + time on A

**The bug**: Stage 2 is missing for RT/DL — `update_stats_wait_end` is
not called during dequeue, so the raw timestamp from Stage 1 persists.
This causes `__update_stats_wait_start` in Stage 3 to compute an
absurdly large value (subtracting a timestamp from a timestamp, rather
than a delta from a timestamp), resulting in wildly incorrect `wait_max`
(496717ms) and `wait_sum` (7921540ms) values.

Record: Bug is clearly described with a concrete demonstration of
incorrect output. The root cause (missing `update_stats_wait_end` call
during dequeue) is clearly identified.

### Step 1.4: Hidden Bug Fix?
This is explicitly a bug fix, not disguised.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- `kernel/sched/rt.c`: +5 lines, -1 line (net +4)
- `kernel/sched/deadline.c`: +3 lines, 0 removed (net +3)
- Functions modified: `update_stats_dequeue_rt()`,
  `update_stats_dequeue_dl()`
- Scope: Surgical fix to two parallel functions

### Step 2.2: Code Flow Change

**RT (`update_stats_dequeue_rt`):**
- Before: Only recorded sleep/block stats on `DEQUEUE_SLEEP`
- After: Also calls `update_stats_wait_end_rt()` when `p != rq->curr`
  before the existing sleep/block handling

**DL (`update_stats_dequeue_dl`):**
- Before: Only recorded sleep/block stats on `DEQUEUE_SLEEP`
- After: Also calls `update_stats_wait_end_dl()` when `p != rq->curr`
  before the existing sleep/block handling

### Step 2.3: Bug Mechanism
This is a **logic/correctness bug** — the RT and DL scheduler classes
were missing the `update_stats_wait_end` call in their
`update_stats_dequeue` functions, which the fair scheduler class already
has. Looking at the fair scheduler reference:

```1420:1446:kernel/sched/fair.c
update_stats_dequeue_fair(struct cfs_rq *cfs_rq, struct sched_entity
*se, int flags)
{
    if (!schedstat_enabled())
        return;

    if (se != cfs_rq->curr)
        update_stats_wait_end_fair(cfs_rq, se);  // <-- THIS WAS MISSING
IN RT/DL

    if ((flags & DEQUEUE_SLEEP) && entity_is_task(se)) {
        // ... sleep/block stats
    }
}
```

The fix adds the identical pattern to RT and DL.

### Step 2.4: Fix Quality
- **Obviously correct**: Directly parallels the CFS implementation
- **Minimal/surgical**: 7 net lines added across 2 files
- **Regression risk**: Extremely low — calls
  `update_stats_wait_end_rt/dl` which is already an existing function;
  the `p != rq->curr` guard ensures it only operates on waiting tasks
  (not the running task). Furthermore, `__update_stats_wait_end` has
  built-in migration handling (sets `wait_start = delta` and returns
  early when `task_on_rq_migrating`).

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
Both `update_stats_dequeue_rt` and `update_stats_dequeue_dl` were
entirely introduced by:
- `57a5c2dafca8e` ("sched/rt: Support schedstats for RT sched class") -
  Sep 2021
- `b5eb4a5f6521d` ("sched/dl: Support schedstats for deadline sched
  class") - Sep 2021

Both merged in **v5.16-rc1**. The bug has been present since v5.16.

### Step 3.2: Fixes Target
No explicit Fixes: tag, but the bug clearly traces to `57a5c2dafca8` and
`b5eb4a5f6521d`.

### Step 3.3: File History
No other commits have touched the `update_stats_dequeue_rt/dl` functions
since their introduction (the DL server schedstat fix `9c602adb799e7`
only changed `__schedstats_from_dl_se()` and the wait_start/wait_end
wrappers, not `update_stats_dequeue_dl`).

### Step 3.4: Author
Dengjun Su from MediaTek. First contribution to the scheduler subsystem.
However, the patch is accepted by Peter Zijlstra, the scheduler
maintainer, which is a strong quality signal.

### Step 3.5: Dependencies
This patch is standalone. It only adds calls to existing functions
(`update_stats_wait_end_rt`, `update_stats_wait_end_dl`) that are
already present in all stable trees since v5.16. No prerequisite patches
needed.

Note: For stable trees < v6.12, the DL side might need minor adaptation
because `9c602adb799e7` (v6.12) changed the DL schedstats wrapper
pattern. In older trees, `update_stats_wait_end_dl` takes different
parameter styles, but the fix concept is the same.

## PHASE 4: MAILING LIST

b4 dig could not find the original submission. The `Link:` tag points to
`patch.msgid.link` which serves lore content. The patch was accepted by
Peter Zijlstra, the primary scheduler maintainer, which is a strong
endorsement.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Modified Functions
- `update_stats_dequeue_rt()` — called from `dequeue_rt_entity()`
- `update_stats_dequeue_dl()` — called from `dequeue_task_dl()`
  (indirectly via `dequeue_dl_entity`)

### Step 5.2: Callers
- `update_stats_dequeue_rt` is called from `dequeue_rt_entity()`
  (rt.c:1414), which is called from `dequeue_task_rt()` — this is the
  main RT task dequeue path, triggered on every RT task dequeue
  (migration, sleep, etc.)
- `update_stats_dequeue_dl` is called from code in `deadline.c` at the
  `dequeue_dl_entity` path

### Step 5.4: Reachability
The buggy code path is triggered whenever an RT or DL task migrates
between CPUs. This is common in multi-core systems with RT workloads,
especially when using CPU affinity changes or load balancing.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The buggy code was introduced in v5.16. It exists in all active stable
trees: 6.1.y, 6.6.y, 6.12.y, etc.

### Step 6.2: Backport Complications
For the RT side: The `update_stats_dequeue_rt` function has been
unchanged since v5.16 in all stable trees. The patch should apply
cleanly.

For the DL side: Commit `9c602adb799e7` (v6.12) changed the DL schedstat
wrapper pattern. For stable trees < 6.12 (i.e., 6.6.y, 6.1.y), the
`update_stats_dequeue_dl` function has `schedstat_enabled()` check
inline rather than in the wrapper. A minor context adjustment may be
needed, but the fix is conceptually identical.

### Step 6.3: No other fix for this bug exists in stable.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- `kernel/sched/` — **CORE** subsystem (scheduler)
- Scheduler statistics (`schedstat`) are used by performance monitoring
  tools and reported via `/proc/[pid]/sched`

### Step 7.2: Activity
The scheduler is one of the most actively developed subsystems.

## PHASE 8: IMPACT AND RISK

### Step 8.1: Affected Users
- All users running RT or DL tasks on multi-core systems with
  `schedstat` enabled
- This affects monitoring/debugging workflows for real-time systems
  (embedded, audio, industrial)

### Step 8.2: Trigger Conditions
- Task migration of RT/DL tasks (common on multi-core systems)
- `schedstat` must be enabled (common for monitoring)

### Step 8.3: Failure Mode
- **Incorrect statistics**: `wait_max` and `wait_sum` report wildly
  inflated values (shown: 496717ms wait_max)
- Severity: **MEDIUM** — no crash or data corruption, but provides
  misleading scheduling statistics that could cause incorrect tuning
  decisions for real-time systems

### Step 8.4: Risk-Benefit
- **Benefit**: Corrects misleading scheduler statistics for RT/DL tasks
  during migration. Important for real-time system monitoring.
- **Risk**: Very low — 7 lines, follows exact CFS pattern, only affects
  statistics (not scheduling decisions), guarded by
  `schedstat_enabled()` and `p != rq->curr`.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real, demonstrable bug (incorrect schedstat values shown in
  commit message)
- Small, surgical fix (7 net lines)
- Obviously correct — mirrors the existing fair scheduler pattern
  exactly
- Accepted by Peter Zijlstra, the primary scheduler maintainer
- Bug has existed since v5.16 (affects all active stable trees)
- No dependencies on other patches
- Very low regression risk (statistics-only code path)
- Standalone single patch

**AGAINST backporting:**
- No crash/security/corruption — only incorrect statistics
- No Reported-by (single author, may not be widely noticed)
- Statistics correctness is a lower priority than crash fixes

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — mirrors CFS pattern, accepted
   by maintainer
2. Fixes a real bug? **YES** — incorrect schedstat values for RT/DL on
   migration
3. Important issue? **MEDIUM** — not a crash, but incorrect diagnostic
   data for real-time systems
4. Small and contained? **YES** — 7 lines across 2 files
5. No new features/APIs? **YES** — no new features
6. Can apply to stable? **YES** — standalone fix, may need minor context
   adjustment for < 6.12

### Step 9.3: Exception Categories
Not an exception category — this is a standard correctness bug fix.

### Step 9.4: Decision
This is a clear, correct bug fix that affects scheduler statistics for
RT and DL tasks. While not a crash or security fix, it corrects
meaningfully wrong data that users rely on for real-time performance
monitoring. The fix is tiny, obviously correct (mirrors CFS), accepted
by the scheduler maintainer, and has essentially zero regression risk.
It meets all stable kernel criteria.

## Verification

- [Phase 1] Parsed tags: Signed-off-by Peter Zijlstra (scheduler
  maintainer), Link to patch.msgid.link
- [Phase 2] Diff analysis: +5 lines in rt.c, +3 lines in deadline.c;
  adds `update_stats_wait_end_rt/dl()` calls matching CFS pattern
- [Phase 2] Verified CFS reference: `update_stats_dequeue_fair`
  (fair.c:1420-1446) calls `update_stats_wait_end_fair` with `se !=
  cfs_rq->curr` guard — RT/DL fix mirrors this exactly
- [Phase 2] Verified `__update_stats_wait_end` (stats.c:21-46) has
  `task_on_rq_migrating` handling that preserves delta as `wait_start` —
  the mechanism described in commit message
- [Phase 3] git blame: `update_stats_dequeue_rt` introduced by
  57a5c2dafca8 (v5.16-rc1), untouched since
- [Phase 3] git blame: `update_stats_dequeue_dl` introduced by
  b5eb4a5f6521 (v5.16-rc1), untouched since
- [Phase 3] git describe: Both original commits in v5.16-rc1 — bug
  present in all stable trees (6.1.y, 6.6.y, 6.12.y)
- [Phase 3] Author check: Dengjun Su has no prior scheduler commits, but
  patch accepted by PeterZ
- [Phase 4] b4 dig failed to find submission; lore.kernel.org blocked by
  anti-scraping
- [Phase 5] Callers: `update_stats_dequeue_rt` called from
  `dequeue_rt_entity()` (verified at rt.c:1414);
  `update_stats_dequeue_dl` called during DL dequeue path
- [Phase 6] 9c602adb799e7 (v6.12) changed DL wrapper pattern — may need
  minor backport adjustment for 6.6.y/6.1.y
- [Phase 8] Failure mode: incorrect wait_max/wait_sum in
  /proc/[pid]/sched, severity MEDIUM

**YES**

 kernel/sched/deadline.c | 4 ++++
 kernel/sched/rt.c       | 7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 674de6a48551b..4c882d1e359b5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2142,10 +2142,14 @@ update_stats_dequeue_dl(struct dl_rq *dl_rq, struct sched_dl_entity *dl_se,
 			int flags)
 {
 	struct task_struct *p = dl_task_of(dl_se);
+	struct rq *rq = rq_of_dl_rq(dl_rq);
 
 	if (!schedstat_enabled())
 		return;
 
+	if (p != rq->curr)
+		update_stats_wait_end_dl(dl_rq, dl_se);
+
 	if ((flags & DEQUEUE_SLEEP)) {
 		unsigned int state;
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index f69e1f16d9238..3d823f5ffe2c8 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1302,13 +1302,18 @@ update_stats_dequeue_rt(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se,
 			int flags)
 {
 	struct task_struct *p = NULL;
+	struct rq *rq = rq_of_rt_rq(rt_rq);
 
 	if (!schedstat_enabled())
 		return;
 
-	if (rt_entity_is_task(rt_se))
+	if (rt_entity_is_task(rt_se)) {
 		p = rt_task_of(rt_se);
 
+		if (p != rq->curr)
+			update_stats_wait_end_rt(rt_rq, rt_se);
+	}
+
 	if ((flags & DEQUEUE_SLEEP) && p) {
 		unsigned int state;
 
-- 
2.53.0

