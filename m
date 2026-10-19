Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ED0533589;
	Mon, 19 Oct 2026 13:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418121; cv=none; b=sgb83vZUFlZZWvd9/O5q1bH4RKSAO+CJ7qQv2sWQ0AdnFSP0N2olmac2wiEUgtkiznqv/fLsvW4Pbsy+ImNMX2TCYkJOAEqXEidfivtRdBIi0aPFb2jTJ0TShoECGQvGvaxdL1WYXnhbJCEFJvpAVFFXQpY/tF70RiWQerKyrMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418121; c=relaxed/simple;
	bh=SnwDmaGbB/8D8fMnHoOLc+J87zXg6C8AhzDsyavSZ4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ax/Pa0v682tDBQsGFtKHRMVuSnef8nQK8dDR2+qoIfjhTDoG6bFTqkFZAq/wWkdQPlTaYYCg0hH16dQ7TcHm7wKMT1t/ucC5pNBGVPG8yH9ti3pBHnHFKZ4rXbcPeQVi4W/FtRq+tOM0rreyCz0k0gGeL5+slLo7YoOa6cF4JDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmhg3X6/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmhg3X6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F341F000C9;
	Mon, 19 Oct 2026 13:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418118;
	bh=DzXpLSCmKSDxDzNcGxTReR6rG9pLC1ND/bBlnj/rcEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmhg3X6/+iTiATNI7B5njoEp4ZfGl3sip4C9L77GcA+7leQ1ZcV8aYqdbnQgbK4LI
	 LzrngKYlN2cbVglRzaofwK35bQTo46mldKeRUTB5Kw2N5RFRQzoq/y++XPRYYdFZsM
	 B/Ymgw8WQCFch27cuTUySsT48r+n7BWNj0BQo7TQlrRAxiPJHMIMskyRjz0hp3YDKu
	 eOwEqHqTbNOiEBL/e57WAjYQGTmQqQ6Jq0BVZYnx1p1sOfqa/VB/Wo+btfwdGMeWPN
	 HtyxdSGlMOEBcVCCB/laCfzuPTfxPruG8eYoZ6PO+8iBAbsCiRt3pfOTsHyXEyw2DY
	 /oEAtOafHzHlA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] sched_ext/scx_flatcg: expire cached hweights on weight changes
Date: Mon, 19 Oct 2026 09:45:15 -0400
Message-ID: <20261019135441.1420968-24-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 94c20e1fb334c2082b443c4470a86ad982f67282 ]

fcg_cgroup_set_weight() updates cgc->weight and the parent's
child_weight_sum but doesn't bump hweight_gen, so the hweights cached by
cgrp_refresh_hweight() stay stale until some task activation bumps the
generation. For cgroups whose tasks never go through a 0->n runnable
transition (e.g. persistently busy ones), a cpu.weight change never
propagates to scheduling at all.

Bump hweight_gen on weight changes so the next refresh recomputes with
the new weight.

Verified on a flatcg VM: a live cpu.weight 100->800 change on a busy
cgroup leaves HWT update at 0 and the distribution unchanged; with it,
hweight_gen increments and the refresh recomputes.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the buggy path is in this 6.12 tree, the patch
is a three-line cache-invalidation fix, and it applies here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [sched_ext/scx_flatcg] [expire] [invalidate cached hierarchical
weights when cpu.weight changes]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Tao Cui <cuitao@kylinos.cn> (author)
- Signed-off-by: Tejun Heo <tj@kernel.org> (sched_ext maintainer;
  applied the patch)
- No Fixes: tag on the committed version (expected for this review
  pipeline)
- No Reported-by, Tested-by, Reviewed-by, Acked-by, Link, or Cc: stable
- BPF CI bot later suggested Fixes: a4103eacc2ab4 ("sched_ext: Add a
  cgroup scheduler which uses flattened hierarchy")

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `fcg_cgroup_set_weight()` writes `cgc->weight` and the parent's
  `child_weight_sum` but does not bump `hweight_gen`. Cached hweights in
  `cgrp_refresh_hweight()` stay valid until some task activation changes
  the active set.
- Symptom: for cgroups that never go through a 0→n runnable transition
  (persistently busy ones), a live `cpu.weight` write never affects
  scheduling.
- Author verification: on a flatcg VM, `cpu.weight` 100→800 on a busy
  cgroup left HWT updates at 0 and the distribution unchanged; with the
  bump, `hweight_gen` increments and refresh recomputes.
- Root cause: generation counter used as a cache key is not invalidated
  on the weight-change path, even though the file comment says it "gets
  inc'd on weight tree changes".

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. This is an explicit correctness fix: a control knob
is updated but the derived cached state is not expired.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `tools/sched_ext/scx_flatcg.bpf.c` (+3 / -0)
- Function: `fcg_cgroup_set_weight()`
- Scope: single-file surgical fix (blank line, comment, one atomic
  increment)

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: lock; if the cgroup is active, adjust parent
  `child_weight_sum`; store new `cgc->weight`; unlock; return. Cached
  `cgc->hweight` is left tagged with the old `hweight_gen`.
- After: same updates, then `__sync_fetch_and_add(&hweight_gen, 1)` so
  the next `cgrp_refresh_hweight()` (called from
  `try_pick_next_cgroup()` / dispatch) misses the cache and recomputes
  `hweight` from the new weight.
- Path affected: cgroup `cpu.weight` write while scx_flatcg is loaded.
  Normal (not error) path.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: logic / correctness (stale cache)
- Mechanism: `cgrp_refresh_hweight()` returns early when
  `cgc->hweight_gen == hweight_gen`. `hweight_gen` is only bumped in
  `update_active_weight_sums()` when a cgroup's active membership
  actually changes. A weight write on an already-active cgroup never
  does that, so dispatch keeps charging with the old hierarchical share.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: it reuses the exact invalidation already used on
  the active-set path (`__sync_fetch_and_add(&hweight_gen, 1)` at the
  existing line 504).
- Minimal; no unrelated edits.
- Regression risk is very low: extra generation bumps only force more
  hweight refreshes, which the code already treats as the slow-but-
  correct path. No new locks, no API change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: The whole of `fcg_cgroup_set_weight()`,
`cgrp_refresh_hweight()`, `hweight_gen`, and the existing bump in
`update_active_weight_sums()` come from a4103eacc2ab4 (Tejun Heo,
2024-09-04), first contained in v6.12-rc1. The bug is as old as the
example scheduler itself.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag on the commit. The introducing commit is
a4103eacc2ab4, which is an ancestor of this tree (`git merge-base --is-
ancestor` exit 0). No later in-tree commit already expires hweights on
set_weight.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record (this tree, `tools/sched_ext/scx_flatcg.bpf.c`):
- 65e72372d5282 sched_ext/scx_flatcg: Fix cvtime true-up on slice expiry
  (already here; same author/thread)
- ab3d9439475a2 sched_ext/scx_flatcg: Fix cvtime_delta race and add
  hweight scaling to bypass charging
- c9c809f4137c3 scx_flatcg: Use a user DSQ for fallback instead of
  SCX_DSQ_GLOBAL
- a4103eacc2ab4 original addition
Standalone: one-line generation bump. Not patch N/M. The related cvtime
true-up was discovered in the same mailing-list thread but is already in
this tree.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Tao Cui has two origin/master commits on this file (this one and
the cvtime true-up). Tejun Heo is the sched_ext maintainer and applied
both. This tree already contains the cvtime true-up (65e72372d5282).

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. `hweight_gen`, `__sync_fetch_and_add`, and
`fcg_cgroup_set_weight()` all exist unchanged in this checkout. `git
apply --check` of 94c20e1fb334c succeeded (hunk offset 1 line from the
already-backported cvtime fix).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 94c20e1fb334c`:
  https://patch.msgid.link/20260814144116.2767304-1-cui.tao@linux.dev
- `b4 dig -a`: single v1 series; no later unapplied revision
- lore.kernel.org fetches returned 403; discussion recovered from
  patchew and openwall mirrors
- Tejun Heo: "Applied to sched_ext/for-7.3." No NAK
- BPF CI bot: "This looks like a bug fix. Should this include a Fixes:
  tag..." suggesting a4103eacc2ab4
- No reviewer asked to keep it out of stable; no Cc: stable either
  (expected)

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc included tj@kernel.org, void@manifault.com,
arighi@nvidia.com, changwoo@igalia.com, sched-ext@lists.linux.dev,
linux-kernel@vger.kernel.org, bpf@vger.kernel.org. Maintainer Tejun
applied it.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Author follow-up: VM with A(100)→A1/A2(100)
and D(varying weight), 3 busy tasks per leaf, 4 vCPUs. D=200 ≈ 47% CPU,
D=800 ≈ 46% — weight changes did nothing. That is how the missing
`hweight_gen` bump was found.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone v1. Same thread spawned the cvtime true-up fix
(already in this tree as 65e72372d5282). Tejun noted that even after
this cache fix, runnable-task limits still cap shares; that is a
documented example-scheduler limitation, not a dependency of this patch.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. Local `git log
--grep='expire cached hweights'` on this file is empty — not already in
this tree. No local evidence of a prior rejection.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `fcg_cgroup_set_weight()` (modified). Related:
`cgrp_refresh_hweight()`, `update_active_weight_sums()`,
`try_pick_next_cgroup()`.

Step 5.2: TRACE CALLERS
Record:
- `fcg_cgroup_set_weight` is registered as `.cgroup_set_weight` in the
  BPF struct_ops (line 959).
- Kernel calls it from `scx_group_set_weight()` in `kernel/sched/ext.c`
  when `cpu.weight` / `cpu.weight.nice` changes and scx_flatcg is loaded
  (`SCX_CALL_OP(..., cgroup_set_weight, ...)`).
- Reachable from a privileged cgroupfs write, not from an unprivileged
  syscall.

Step 5.3: TRACE CALLEES
Record: `find_cgrp_ctx`, `find_ancestor_cgrp_ctx`,
`bpf_spin_lock/unlock(&cgv_tree_lock)`, and after the patch
`__sync_fetch_and_add(&hweight_gen, 1)`. No allocation.

Step 5.4: FOLLOW THE CALL CHAIN
Record: userspace writes `cpu.weight` → `cpu_weight_write_u64` →
`scx_group_set_weight` → BPF `fcg_cgroup_set_weight`. Dispatch later
calls `try_pick_next_cgroup()` → `cgrp_refresh_hweight()`. If
`hweight_gen` was not bumped, that refresh hits `FCG_STAT_HWT_CACHE` and
keeps the old share. Users who load scx_flatcg and change cgroup weights
can trigger this; busy cgroups are the common case where weights matter.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: The only other `hweight_gen` bump is in
`update_active_weight_sums()` when `nr_active` crosses 0. That is the
missing counterpart this patch adds on the weight-write path. No other
copy of the same omission in this file.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is pending-6.12, `make kernelversion` =
6.12.111, `git describe HEAD` = p-6.12-3-gc504cf0baa3d8.
`fcg_cgroup_set_weight()` at lines 590–609 has the weight update and no
`hweight_gen` bump. Introduced by a4103eacc2ab4 (in this tree).
94c20e1fb334c is not an ancestor (`merge-base --is-ancestor` exit 1).

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. `git show 94c20e1fb334c | git apply --check`
succeeded with hunk offset 1 (from the already-present cvtime true-up).
No refactor of this function here.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No alternate hweight-expiry fix. Related accounting fixes
(cvtime true-up, cvtime_delta race) are present and independent.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: tools/sched_ext example BPF scheduler (scx_flatcg), used only
when `CONFIG_SCHED_CLASS_EXT` is enabled and this program is loaded.
Criticality: PERIPHERAL relative to core CFS, but IMPORTANT for anyone
actually running this shipped scheduler — its whole job is hierarchical
weight control. Not staging.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: sched_ext was new in 6.12; this file has a handful of later
correctness backports in this tree. Mature enough that the bug is
original, not from post-branch churn.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Config- and userspace-specific: `CONFIG_SCHED_CLASS_EXT=y` plus
loading `scx_flatcg`. Not universal. This tree already ships that
example and has been taking its correctness fixes.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Write `cpu.weight` on a cgroup whose tasks stay runnable. Common
for exactly the workload the scheduler is meant to manage (competing
busy cgroups). Requires privilege to write the cgroup knob. Not a race;
it fails every time until some sibling goes idle.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Failure mode = live cgroup CPU shares do not follow `cpu.weight`
for busy groups (author: 100→800 left HWT updates at 0). No oops,
deadlock, or corruption. Severity: MEDIUM–HIGH functional/fairness bug
for that scheduler; LOW for the rest of the kernel.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: makes the primary fairness knob work for persistently busy
  cgroups on a scheduler this tree already ships and already patches.
- Risk: very low (3 lines, existing atomic, no lock/API change).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real, reproduced bug: busy-cgroup `cpu.weight` changes never reach
  scheduling.
- Matches the file's own cache-invalidation design; the set_weight path
  simply omitted the bump.
- 3-line, obviously correct, same primitive as the existing active-set
  path.
- Bug present since v6.12-rc1 in this tree; patch not yet here; applies
  cleanly.
- Maintainer applied it; author and maintainer both tested.
- Companion scx_flatcg correctness fixes are already in this 6.12 tree.

AGAINST:
- Example BPF scheduler in `tools/`, not CFS/core.
- No crash, UAF, deadlock, or CVE.
- Optional config; production SCX users often load schedulers from the
  out-of-tree scx repo.
- Residual share compression from window granting remains even after
  this fix (separate example-scheduler limit).

UNRESOLVED:
- lore.kernel.org and lore stable search returned 403; discussion taken
  from patchew/openwall. No evidence of a stable NAK.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — same generation bump as the
   other path; author + maintainer verified on a VM.
2. Fixes a real bug that affects users? PASS — `cpu.weight` ignored for
   busy cgroups; measured.
3. Important issue? PASS — fairness/control-knob failure of this
   scheduler (not a panic, but the feature is broken in the case that
   matters).
4. Small and contained? PASS — +3 lines, one function.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — `--check` succeeded.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID, quirk, DT, build, or docs fix). Qualifies
as a normal small correctness fix.

Step 9.4: MAKE YOUR DECISION
This tree is 6.12.y. The buggy example scheduler is here, the one-line
invalidation is the intended cache protocol, and the only cost is extra
hweight refreshes. That is a YES for this checkout.

What the commit solves for stable users:
Anyone on this 6.12 tree who loads the shipped `scx_flatcg` scheduler
currently cannot change CPU shares of persistently busy cgroups through
`cpu.weight`. That is the main knob the scheduler advertises. The patch
expires the hweight cache so the next dispatch refresh uses the new
weights.

Risk vs benefit:
Benefit is restoring advertised cgroup fairness for that scheduler; risk
is a generation bump that already exists on another path. No
prerequisites beyond code already in this tree.

Verification:
- [Phase 1] Parsed subject/body/tags from `git log origin/master` / `git
  show 94c20e1fb334c`; no Fixes:/Reported-by; Tejun SOB
- [Phase 2] Diff is +3 lines in `fcg_cgroup_set_weight()`; local
  function at lines 590–609 lacks the bump
- [Phase 2] Confirmed `cgrp_refresh_hweight()` cache test at lines
  206–208 and existing bump at 503–504
- [Phase 3] `git blame -L 590,609`: a4103eacc2ab4; `git describe
  --contains a4103eacc2ab4` = v6.12-rc1~111^2~20
- [Phase 3] `git merge-base --is-ancestor a4103eacc2ab4 HEAD` → 0 (bug
  in this tree)
- [Phase 3] `git merge-base --is-ancestor 94c20e1fb334c HEAD` → 1 (fix
  not in this tree)
- [Phase 3] `git apply --check` of 94c20e1fb334c succeeded (offset 1)
- [Phase 3] Author history on path: this commit + cvtime true-up
  (already 65e72372d5282 here)
- [Phase 4] `b4 dig -c 94c20e1fb334c`: msgid
  20260814144116.2767304-1-cui.tao@linux.dev; v1 only
- [Phase 4] `b4 dig -w`: Tejun and sched-ext/bpf lists on CC
- [Phase 4] patchew: Tejun applied to sched_ext/for-7.3; BPF CI asked
  for Fixes: a4103eacc2ab4
- [Phase 4] Author measurements: D=200 ~47% vs D=800 ~46% before the
  bump
- [Phase 4] lore.kernel.org 403 — UNVERIFIED on lore itself; recovered
  from patchew/openwall
- [Phase 5] Call path: `scx_group_set_weight()` in
  kernel/sched/ext.c:4113 → BPF `cgroup_set_weight`; refresh from
  `try_pick_next_cgroup()` line 677
- [Phase 6] `git describe HEAD` = p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` = 6.12.111
- [Phase 7] README: scx_flatcg is the flattened hierarchical weight
  example
- [Phase 8] Failure: stale hweights → cpu.weight ignored for busy
  cgroups; severity MEDIUM–HIGH for that scheduler
- UNVERIFIED: whether this SHA was discussed on lore.kernel.org/stable
  (HTTP 403)

**YES**

 tools/sched_ext/scx_flatcg.bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/sched_ext/scx_flatcg.bpf.c b/tools/sched_ext/scx_flatcg.bpf.c
index d1fc6cb8206c0..3f01441731b7e 100644
--- a/tools/sched_ext/scx_flatcg.bpf.c
+++ b/tools/sched_ext/scx_flatcg.bpf.c
@@ -605,6 +605,9 @@ void BPF_STRUCT_OPS(fcg_cgroup_set_weight, struct cgroup *cgrp, u32 weight)
 		pcgc->child_weight_sum += (s64)weight - cgc->weight;
 	cgc->weight = weight;
 	bpf_spin_unlock(&cgv_tree_lock);
+
+	/* expire cached hweights so the new weight propagates */
+	__sync_fetch_and_add(&hweight_gen, 1);
 }
 
 static bool try_pick_next_cgroup(u64 *cgidp)
-- 
2.53.0

