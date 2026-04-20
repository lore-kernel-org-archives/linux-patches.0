Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB1C3B8BBF;
	Mon, 20 Apr 2026 13:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691450; cv=none; b=oR4zM/BjcoSFiabrzoKvECyr5BZ8+gJSl7qaBozoHzFhJQXVUYGbG6XnVtOBliPkawUy1gHORAVd0uPzrS7N2amUhSj2WOyumgMZ+6W7Hku3CdZKjwf7ryzv7JlkU+Ijd2BI5n/oYjqWO9shfW/4iCtNdzzTxVKttAmc31WUWF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691450; c=relaxed/simple;
	bh=aS3LkgAoHg9dVJ0OchQoeDO63o8ka4gMw1Q9LvUtJjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sjH53DVz8eB+TmB18/qM++NqKxyz+X247TNs9ME17GEtBtSB4q652/MlH2g+1yImZWH/MBSgPaiLarFIS3YZBVoy3n6FmeBaZnzYJkmNTOhOolPjFjthtZV325EseOTO21nQx1dDRqdOcvGSH+I2z0Ptu10fHp9kt3RIMDXXYtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=txy91itg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="txy91itg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E545C2BCB4;
	Mon, 20 Apr 2026 13:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691450;
	bh=aS3LkgAoHg9dVJ0OchQoeDO63o8ka4gMw1Q9LvUtJjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txy91itg99ppwyeTqVfTkG+63EEFnTmGnQFWWDfH1FSfAqaqUmJ9Y+Jqy40cbysLr
	 bVIR+jLaKJp0LCnuhjL28eycIpNgAukuyYf+6ycwfBkVWFeNxR9mX/J6egcPlP8hCg
	 K5ZxD0DVnIxxWwnR0vEiIbenZ1tdHC7Y5oHh0YLlGsz1InCLr0AknFZTKA8hNAuDpa
	 wceQ7xDkUGr7c5mzEiKisUXXi+ygjQW7HoA9nxc6SDzX802RKTRjy3HjzaKQIsMsOn
	 TzVydE9o0iy/MLrrjOkyqqyzSbr/jdxyQ+g9974wR56dgnWyNFhrSnBiOsyoN3FscB
	 8//xFzzu9nNxA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] sched/eevdf: Clear buddies for preempt_short
Date: Mon, 20 Apr 2026 09:17:09 -0400
Message-ID: <20260420132314.1023554-35-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
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

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 78cde54ea5f03398f1cf6656de2472068f6da966 ]

next buddy should not prevent shorter slice preemption. Don't take buddy
into account when checking if shorter slice entity can preempt and clear it
if the entity with a shorter slice can preempt current.

Test on snapdragon rb5:
hackbench -T -p -l 16000000 -g 2 1> /dev/null &
hackbench runs in cgroup /test-A
cyclictest -t 1 -i 2777 -D 63 --policy=fair --mlock  -h 20000 -q
cyclictest runs in cgroup /test-B

                     tip/sched/core  tip/sched/core    +this patch
cyclictest slice  (ms) (default)2.8             8               8
hackbench slice   (ms) (default)2.8            20              20
Total Samples          |    22679           22595           22686
Average           (us) |       84              94(-12%)        59( 37%)
Median (P50)      (us) |       56              56(  0%)        56(  0%)
90th Percentile   (us) |       64              65(- 2%)        63(  3%)
99th Percentile   (us) |     1047            1273(-22%)        74( 94%)
99.9th Percentile (us) |     2431            4751(-95%)       663( 86%)
Maximum           (us) |     4694            8655(-84%)      3934( 55%)

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260410132321.2897789-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for my final analysis. Let me compile my
findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `sched/eevdf` (scheduler, EEVDF entity-level)
- **Action verb**: "Clear" — implies removing something that shouldn't
  be there
- **Summary**: Clear buddy hints to prevent them from blocking shorter-
  slice preemption

Record: [sched/eevdf] [Clear] [Fix buddy mechanism defeating
PREEMPT_SHORT feature]

### Step 1.2: Tags
- `Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>` —
  author, scheduler maintainer
- `Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>` —
  applied by scheduler co-maintainer
- `Link: https://patch.msgid.link/20260410132321.2897789-1-
  vincent.guittot@linaro.org` — original submission
- No Fixes: tag (expected for AUTOSEL candidates)
- No Reported-by: tag
- No Cc: stable (expected)

Record: Both scheduler co-maintainers signed off. No explicit bug
reporter.

### Step 1.3: Commit Body
The commit describes: "next buddy should not prevent shorter slice
preemption." The buddy mechanism (`cfs_rq->next`) currently overrides
PREEMPT_SHORT, preventing a shorter-slice entity from preempting the
current task. The fix: (1) don't consider buddy when `protect=false`,
(2) clear buddy when shorter-slice preemption succeeds.

Performance data from cyclictest on Snapdragon RB5 shows:
- **99th percentile**: 1273us → 74us (**94% improvement**)
- **99.9th percentile**: 4751us → 663us (**86% improvement**)
- **Maximum**: 8655us → 3934us (**55% improvement**)

Record: The bug causes the PREEMPT_SHORT feature to be effectively
broken when a buddy is set. Tail latency is dramatically worse. The
commit provides concrete benchmark data.

### Step 1.4: Hidden Bug Fix?
This IS a bug fix. The PREEMPT_SHORT feature is explicitly designed to
allow shorter-slice entities to preempt. The buddy mechanism introduced
in v6.19 (e837456fdca818) inadvertently defeats this by returning the
buddy before the `protect` parameter is even considered. The `protect`
parameter was specifically added to distinguish PREEMPT_SHORT from
normal picks, but the buddy check ignores it.

Record: This is a real functional bug where two scheduler features
interact incorrectly.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **File**: `kernel/sched/fair.c` only
- **Change 1** (line 1027): Added `&& protect` condition to PICK_BUDDY
  check in `__pick_eevdf()` — 1 line modified
- **Change 2** (lines 8935-8937): Added `clear_buddies(cfs_rq, se)` in
  the PREEMPT_WAKEUP_SHORT preemption path — 3 lines changed (added
  braces + new call)
- **Total**: ~4 lines of functional change

Record: Single file, 2 hunks, ~4 lines modified. Extremely surgical fix.

### Step 2.2: Code Flow Change
**Hunk 1**: In `__pick_eevdf()`, BEFORE: buddy always returned if
eligible. AFTER: buddy only returned if eligible AND `protect=true`.
When called for PREEMPT_SHORT (`protect=false`), the buddy is skipped
and normal EEVDF pick logic runs.

**Hunk 2**: In `wakeup_preempt_fair()` preempt path, BEFORE: only
`cancel_protect_slice(se)` called for SHORT. AFTER: also calls
`clear_buddies(cfs_rq, se)` to prevent stale buddy from interfering with
future scheduling decisions.

### Step 2.3: Bug Mechanism
**Category**: Logic/correctness fix — feature interaction bug.

The `protect` parameter was designed to differentiate PREEMPT_SHORT from
normal scheduling. The slice protection check at line 1037 correctly
uses `protect`, but the buddy check at line 1027 does not. This is an
oversight in the e837456fdca818 commit that added the `protect`
parameter.

### Step 2.4: Fix Quality
- Obviously correct — the `protect` parameter already exists and is used
  for the slice protection check; this extends it to the buddy check
- Minimal and surgical — 4 lines
- Low regression risk — `clear_buddies` is well-tested and used
  elsewhere; adding `&& protect` only narrows the buddy selection, never
  broadens it
- Normal path (`pick_eevdf`) calls `__pick_eevdf(cfs_rq, true)`, so
  buddy behavior is unchanged for all non-PREEMPT_SHORT calls

Record: Fix is obviously correct, minimal, and low-risk.

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
The buggy code (PICK_BUDDY check without `protect`) was introduced in
e837456fdca818 ("sched/fair: Reimplement NEXT_BUDDY to align with EEVDF
goals") by Mel Gorman, dated 2025-11-12, first appeared in v6.19.

Record: Bug introduced in v6.19 by e837456fdca818.

### Step 3.2: Fixes Target
No explicit Fixes: tag, but the implicit fix target is e837456fdca818
which added the `protect` parameter but failed to apply it to the buddy
check.

Record: e837456fdca818 is in v6.19 and v7.0.

### Step 3.3: Related Changes
- 15257cc2f905d ("sched/fair: Revert force wakeup preemption") — Vincent
  Guittot's previous fix for e837456fdca818, already in v6.19-rc7. This
  confirms the NEXT_BUDDY reimplementation had issues.
- 493afbd187c4c ("sched/fair: Fix NEXT_BUDDY") — earlier buddy fix for
  delayed dequeue interaction

Record: There is a pattern of fixes for the NEXT_BUDDY reimplementation.
This is a standalone fix, no prerequisites needed.

### Step 3.4: Author
Vincent Guittot is the primary CFS/EEVDF scheduler maintainer at Linaro.
He has extensive commit history in `kernel/sched/fair.c` (20+ recent
commits). He also authored the previous fix for the same NEXT_BUDDY
reimplementation.

Record: Author is the subsystem maintainer. Maximum credibility.

### Step 3.5: Dependencies
The fix requires:
- `protect` parameter in `__pick_eevdf()` (from e837456fdca818, v6.19)
- `PREEMPT_WAKEUP_SHORT` enum (from e837456fdca818, v6.19)
- `clear_buddies()` function (present since early CFS, well-established)
- `cancel_protect_slice()` (from 9de74a9850b94, v6.17)

All prerequisites exist in v6.19 and v7.0.

Record: Standalone fix, applies cleanly to v6.19+ and v7.0.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
Lore is behind anti-bot protection. b4 dig could not match the exact
message ID. However:
- The Link: tag confirms it was submitted via LKML
- Peter Zijlstra's SOB confirms it was accepted by the scheduler
  maintainer
- No NAKs mentioned
- No multi-version series (single patch)

Record: Could not access full mailing list discussion due to anti-bot
protection. UNVERIFIED: Whether reviewers discussed stable suitability.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
- `__pick_eevdf()` — core EEVDF entity pick function
- `wakeup_preempt_fair()` — wakeup preemption decision function

### Step 5.2: Callers
- `__pick_eevdf()` is called by:
  - `pick_eevdf()` (with `protect=true`) — normal scheduling pick
  - `wakeup_preempt_fair()` (with `protect=false` for PREEMPT_SHORT) —
    this is the affected path
- `wakeup_preempt_fair()` is called on every task wakeup for fair-class
  tasks

Record: The bug is in the wakeup preemption hot path, triggered on every
CFS wakeup when PREEMPT_SHORT conditions are met.

### Step 5.3-5.4: Call Chain
Userspace → syscall → wake_up_process → try_to_wake_up → wakeup_preempt
→ wakeup_preempt_fair → `__pick_eevdf(cfs_rq, false)`

Record: Bug is reachable from any task wakeup path. Very common code
path.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code in Stable Trees
- The buggy code (`protect` parameter + PICK_BUDDY without protect
  check) was introduced in e837456fdca818 which is in v6.19 and v7.0
- v6.12 and earlier do NOT have this code (no `protect` parameter,
  different buddy mechanism)

Record: Bug exists in v6.19.y and v7.0.y stable trees only.

### Step 6.2: Backport Complications
The code in v6.19 and v7.0 is identical to HEAD for these specific
lines. The patch would apply cleanly.

Record: Clean apply expected for v6.19.y and v7.0.y.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
- Subsystem: `kernel/sched/fair.c` — CFS/EEVDF scheduler
- Criticality: **CORE** — affects all users running the fair scheduler
  (virtually everyone)

### Step 7.2: Activity
Very actively developed. Many recent changes from multiple maintainers.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Population
All users of the CFS scheduler with `PREEMPT_SHORT` enabled (which is
the default since 85e511df3cec46). This means virtually all users on
v6.19+.

### Step 8.2: Trigger Conditions
The bug triggers whenever:
1. A task with a shorter slice wakes up and could preempt the current
   task
2. AND there is a `cfs_rq->next` buddy set (from a previous wakeup or
   yield_to)
3. AND the buddy is eligible

The buddy is set via `set_next_buddy()` which is called from
`yield_to_task_fair()`, `dequeue_task_fair()`, and
`set_preempt_buddy()`. This is a common scenario in multi-task
workloads.

### Step 8.3: Failure Mode Severity
This is not a crash or corruption — it's a **latency regression**. The
PREEMPT_SHORT feature effectively doesn't work when a buddy is set. The
test data shows:
- 99th percentile latency: **17x worse** (74us → 1273us)
- 99.9th percentile latency: **7x worse** (663us → 4751us)

For real-time-ish workloads (cyclictest), audio applications,
interactive applications, this is a significant degradation. However, it
doesn't cause crashes, data corruption, or security issues.

Severity: **MEDIUM-HIGH** — feature completely broken, significant
latency regression for latency-sensitive workloads.

### Step 8.4: Risk-Benefit Ratio
- **BENEFIT**: HIGH — Restores PREEMPT_SHORT functionality, dramatically
  improves tail latency for all CFS users
- **RISK**: VERY LOW — 4-line change, obviously correct, from the
  scheduler maintainer, only narrows buddy selection (never broadens),
  `clear_buddies` is a well-tested function

## PHASE 9: SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Fixes a real functional bug where PREEMPT_SHORT is defeated by the
  buddy mechanism
- Dramatic improvement in tail latency (94% improvement in p99)
- Small, surgical fix (4 lines)
- Authored by scheduler maintainer (Vincent Guittot)
- Applied by scheduler co-maintainer (Peter Zijlstra)
- Bug introduced in v6.19 by e837456fdca818, present in v7.0
- The `protect` parameter was specifically designed for PREEMPT_SHORT,
  but the buddy check ignores it — clear oversight
- Previous fix from same author for same commit (15257cc2f905d) confirms
  NEXT_BUDDY rewrite had issues
- Clean apply to v6.19 and v7.0

**AGAINST backporting:**
- No crash, data corruption, or security impact
- This is a latency/performance issue, not a hard bug
- No Fixes: tag
- No user reports (Reported-by)
- Primarily benefits latency-sensitive workloads

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — clearly extends existing
   `protect` logic, tested with cyclictest/hackbench
2. Fixes a real bug? **YES** — PREEMPT_SHORT feature is broken when
   buddy is set
3. Important issue? **MEDIUM-HIGH** — not a crash but significant
   latency regression for common workloads
4. Small and contained? **YES** — 4 lines, single file
5. No new features? **CORRECT** — no new features, fixes existing
   feature interaction
6. Applies to stable? **YES** — clean apply to v6.19 and v7.0

### Step 9.3: Exception Categories
Not an exception category (not a device ID, quirk, DT, build fix, or
docs fix).

### Step 9.4: Decision
This is borderline. It's a real bug fix — the PREEMPT_SHORT feature is
broken when a buddy exists — but it manifests as a performance/latency
issue rather than a crash. The fix is extremely small, obviously
correct, and from the scheduler maintainer. The regression in tail
latency is severe (17x worse p99). However, stable rules generally
prefer crash/corruption/security fixes.

On balance, the severity of the latency regression (p99 going from 74us
to 1273us is extreme), the small scope, the obvious correctness, and the
fact that it fixes a feature that is essentially completely broken in
certain common scenarios tips this toward YES. This is not mere
optimization — it's restoring intended functionality that was broken by
a recent commit.

## Verification

- [Phase 1] Parsed tags: Author is Vincent Guittot (scheduler
  maintainer), applied by Peter Zijlstra
- [Phase 2] Diff analysis: 4 lines changed in 2 hunks of
  `kernel/sched/fair.c` — adds `&& protect` to buddy check, adds
  `clear_buddies()` call
- [Phase 3] git blame: Buggy code introduced by e837456fdca818 (Mel
  Gorman, 2025-11-12, v6.19)
- [Phase 3] git tag --contains: e837456fdca818 first in v6.19,
  85e511df3cec46 (PREEMPT_SHORT) first in v6.12
- [Phase 3] Related fix 15257cc2f905d confirms NEXT_BUDDY
  reimplementation had issues (Fixes: e837456fdca818)
- [Phase 3] Author Vincent Guittot has 20+ recent commits to
  kernel/sched/fair.c
- [Phase 4] b4 dig failed to match message ID; lore protected by anti-
  bot
- UNVERIFIED: Full mailing list discussion details, whether reviewers
  nominated for stable
- [Phase 5] `__pick_eevdf()` called from `pick_eevdf()` and
  `wakeup_preempt_fair()` — confirmed via grep
- [Phase 5] `wakeup_preempt_fair()` is on every CFS wakeup path —
  confirmed via code analysis
- [Phase 6] Verified v6.19 has identical buggy code via `git show
  v6.19:kernel/sched/fair.c`
- [Phase 6] v6.12 does NOT have this code (no PICK_BUDDY in
  `__pick_eevdf`)
- [Phase 8] Latency regression quantified from commit message: p99
  1273us→74us, p99.9 4751us→663us

**YES**

 kernel/sched/fair.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 42051bdea3f17..1d89db9498fed 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1024,7 +1024,7 @@ static struct sched_entity *__pick_eevdf(struct cfs_rq *cfs_rq, bool protect)
 	/*
 	 * Picking the ->next buddy will affect latency but not fairness.
 	 */
-	if (sched_feat(PICK_BUDDY) &&
+	if (sched_feat(PICK_BUDDY) && protect &&
 	    cfs_rq->next && entity_eligible(cfs_rq, cfs_rq->next)) {
 		/* ->next will never be delayed */
 		WARN_ON_ONCE(cfs_rq->next->sched_delayed);
@@ -8932,8 +8932,10 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
 	return;
 
 preempt:
-	if (preempt_action == PREEMPT_WAKEUP_SHORT)
+	if (preempt_action == PREEMPT_WAKEUP_SHORT) {
 		cancel_protect_slice(se);
+		clear_buddies(cfs_rq, se);
+	}
 
 	resched_curr_lazy(rq);
 }
-- 
2.53.0

