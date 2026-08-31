Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3CF5970C4;
	Mon, 31 Aug 2026 13:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184284; cv=none; b=ZDmZt1+70KYX0uCZH3od0+XDwa1slFhcAlfQrvuhHeqOgJZirrNWB1GtEd6BGJtC2P3ByDm9zEUyUMH8rd7DyovQmYB63mWdiNeDarlruwk5dmcvPTt17zJESriBeztuojav5Xag55YJAYUBcZzF1hmNoi0M6PEbTGV+Lef96Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184284; c=relaxed/simple;
	bh=0PVHaOnKMr16wApATx6PfqxEAuxQ/LaX/pG5KqHrqW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFsUeePHgciZ/uCeQyXFzz2scqlen88sy2rf0cHyGuoO17xq8vuMm/4CEOUaqsOmuZvpsw0T5P2rXU5G7ZeTs2d4uW5nqb9vlXp0RWAkgIw8aAdEyTOHLUITYNArFPP4AzxLj7W2BU6E2jrqT27j+jBmiBqFlA7Xo9caUVTJBfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CxwlR5BP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CxwlR5BP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D161F00A3F;
	Mon, 31 Aug 2026 13:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184281;
	bh=NgqzQU3iitijG6CwHdYsSqIl/muPKnrewyIb1NE+DrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxwlR5BP/Ft9Ddb9ngqqb9OPLRYB8QwVezLCBlqBPOpb6/fljqcWxYvM8u5sYhfCO
	 6ErywSVdP9N0NULJELG0RiIlxsLczYEpbd7ZA9b5KmuV3A6HUJsFNL6EIDIVDdDpHL
	 NM+8PZd8d/IF6VZKWEbmr3REiufwU7FoNxyVD9sO/gP7QargDH9GECIOASPIzP82xm
	 B0jPWEnmts+k7Zku4p6ubTu4sMA0KcCtDeYGKeTwFPhXw4PsiEpAeGZ0sYsD7vsPbj
	 YEktMvsG1FzOzAZFERmFha2HgJKqUxF+SXRhIb1AiGRiXD3hiR2obqTkr8AVSN65vN
	 olTVlhUlrVvbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuba Piecuch <jpiecuch@google.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] sched_ext: Mark waker CPU busy when selected in WAKE_SYNC case
Date: Mon, 31 Aug 2026 09:30:27 -0400
Message-ID: <20260831133314.4125787-599-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuba Piecuch <jpiecuch@google.com>

[ Upstream commit 9591fcc95dddfd24298724f8eb5239e907980779 ]

SCX's built-in idle CPU tracking is imperfect and can be out-of-sync
with the actual idle state of CPUs, especially immediately after
enabling SCX due to scx_idle_enable() marking all online CPUs idle.

scx_select_cpu_dfl() skips marking the selected CPU as busy if
the selected CPU is the waker CPU in the SCX_WAKE_SYNC case.
If the waker CPU was marked idle by SCX, it will still be marked idle
after CPU selection and potentially even after switching to the wakee.

In the allowed_cpus selftest, this can manifest as the test failing with
the following message in dmesg:

  allowed_cpus.bpf.c:21: CPU 0 should be marked as busy

This patch explicitly marks the waker CPU as busy. With this patch,
the test failure no longer reproduces. There are still some pretty
unlikely races that could make the test fail (e.g. pick_task_idle()
marking the selected CPU idle between selection and validation), but
these can't be fixed easily.

Signed-off-by: Kuba Piecuch <jpiecuch@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `sched_ext: Mark waker CPU busy when
selected in WAKE_SYNC case`

**Local tree:** `v6.18.44` (`linux-6.18.y`, VERSION=6, PATCHLEVEL=18,
SUBLEVEL=44)

**Commit analyzed:** `b9f6521da1907` (upstream: `9591fcc95dddf`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[sched_ext]` `[Mark]` — Mark waker CPU busy when selected
in WAKE_SYNC case. Action is a correctness/state fix (not a feature
add).

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Kuba Piecuch `<jpiecuch@google.com>` (author)
- **Signed-off-by:** Tejun Heo `<tj@kernel.org>` (sched_ext maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Link:, or Cc:
  stable tags
- `[Upstream commit 9591fcc95dddf]` marker present (pipeline artifact —
  ignored per instructions)

### Step 1.3: Body Analysis
**Record:**
- **Bug:** SCX built-in idle CPU tracking can be out of sync with real
  CPU idle state, especially right after `scx_idle_enable()` marks all
  online CPUs idle.
- **Mechanism:** In `scx_select_cpu_dfl()`, the `SCX_WAKE_SYNC` path
  selects the waker CPU but skips `scx_idle_test_and_clear_cpu()`,
  unlike every other selection path in the same function.
- **Symptom:** Selected waker CPU remains marked idle after CPU
  selection (and potentially after wakee switch).
- **Observable failure:** `allowed_cpus` selftest fails with
  `allowed_cpus.bpf.c:21: CPU 0 should be marked as busy` in dmesg.
- **Root cause (author):** Missing idle-bit clear on the WAKE_SYNC
  waker-CPU fast path.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes — despite not using "fix" in the subject, this is a
logic/correctness bug in idle tracking state management, not cleanup or
optimization.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `kernel/sched/ext_idle.c` (+3, -1 lines)
- **Function:** `scx_select_cpu_dfl()`
- **Scope:** Single-file, surgical fix in one code path

### Step 2.2: Code Flow Change
**Record:**
- **Before:** In `SCX_WAKE_SYNC` path, when waker's local DSQ is empty
  and system underutilized, if waker CPU is in `allowed` mask → `goto
  out_unlock` without updating idle tracking.
- **After:** Same path, but calls `scx_idle_test_and_clear_cpu(cpu)`
  before `goto out_unlock`, matching all other CPU selection exits in
  this function.
- **Path affected:** WAKE_SYNC synchronous wakeup CPU selection (normal
  wakeup path, not error path).

### Step 2.3: Bug Mechanism
**Record:** **Logic / correctness fix** — inconsistent idle-mask
bookkeeping. Other selection branches call
`scx_idle_test_and_clear_cpu()` when claiming a CPU; this branch was the
sole exception, leaving the waker CPU incorrectly marked idle in SCX's
built-in idle cpumask.

### Step 2.4: Fix Quality
**Record:**
- Obviously correct: mirrors existing pattern used at lines 528, 566,
  614, 937 in the same file.
- Minimal change, no API changes, no new behavior beyond fixing state.
- **Regression risk:** Very low — `scx_idle_test_and_clear_cpu()` is
  idempotent-safe for a CPU about to run a task; it's already called on
  every other selection path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- WAKE_SYNC block introduced in `48849271e66114` (Andrea Righi, Feb
  2025, "sched_ext: idle: Per-node idle cpumasks").
- The `goto out_unlock` without idle clear at lines 551–552 introduced
  in `23c63a965275ce` (Apr 2025, refactoring to pass explicit allowed
  cpumask — "pure refactoring with no functional changes", but the
  WAKE_SYNC path never had the clear call).
- Buggy code **is an ancestor of HEAD** in this tree.

### Step 3.2: Fixes: Tag
**Record:** Not applicable — no Fixes: tag present.

### Step 3.3: Related File History
**Record:** Recent stable-relevant sched_ext idle fixes already in
`linux-6.18.y`:
- `a8f4a82e5629c` — idle: Recheck prev_cpu after narrowing allowed mask
- `b49bf41b41148` — Fix inconsistent NUMA node lookup in
  scx_select_cpu_dfl()
- `72c43eb2e334f` — Fix is_bpf_migration_disabled() false negative

This fix is the same category: small sched_ext idle-selection
correctness fix.

### Step 3.4: Author Context
**Record:** Kuba Piecuch (Google). No prior commits in `kernel/sched/`
in this tree; patch went through Tejun Heo's sched_ext tree
(`for-7.2-fixes`).

### Step 3.5: Dependencies
**Record:** Standalone — no series dependencies, no prerequisite
commits. Applies cleanly to current HEAD (`git apply --check` passes).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- `b4 dig -c b9f6521da1907 -a` found v1 submission:
  https://patch.msgid.link/20260722143307.2772632-1-jpiecuch@google.com
  (2026-07-22, sched_ext/for-7.2-fixes)
- `b4 dig -c` without `-a` could not match by patch-id alone
- Lore/msgid.link fetch blocked by bot protection — could not read
  thread content

### Step 4.2: Reviewers
**Record:** `b4 dig -w` did not return recipient details (same patch-id
match failure). Commit has Tejun Heo SOB (maintainer acceptance).

### Step 4.3: Bug Report
**Record:** Failure documented in commit message via `allowed_cpus`
selftest. No syzbot, no user bugzilla report.

### Step 4.4: Related Patches
**Record:** Standalone 1-patch fix for for-7.2-fixes. No multi-patch
series dependency.

### Step 4.5: Stable List History
**Record:** Could not search lore stable list (bot protection). However,
similar sched_ext idle fixes are already present in this 6.18.y tree
(see Phase 3.3).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `scx_select_cpu_dfl()`, `scx_idle_test_and_clear_cpu()`,
`scx_bpf_select_cpu_and()` (wrapper calling `scx_select_cpu_dfl`)

### Step 5.2: Callers
**Record:**
- `scx_select_cpu_dfl()` called from `scx_bpf_select_cpu_and()` (BPF
  kfunc, line 942) and `kernel/sched/ext.c:2578` (default select_cpu
  when BPF scheduler doesn't implement `ops.select_cpu`)
- `SCX_WAKE_SYNC` originates from normal scheduler wakeups (`WF_SYNC` in
  `kernel/sched/fair.c`, `kernel/sched/core.c`)
- Reachable from syscall-driven task wakeups when sched_ext is active

### Step 5.3: Callees
**Record:** `scx_idle_test_and_clear_cpu()` clears CPU (and SMT cluster)
from per-node idle cpumasks via `cpumask_test_and_clear_cpu()`.

### Step 5.4: Call Chain / Reachability
**Record:** `wake_up_*` → CFS/SCX wakeup → `scx_select_cpu_dfl()` with
`SCX_WAKE_SYNC` → BPF kfunc `scx_bpf_select_cpu_and()` → BPF scheduler
validation. **Reachable from userspace** via normal process wakeup when
`CONFIG_SCHED_CLASS_EXT` is enabled and a BPF scheduler is loaded.

### Step 5.5: Similar Patterns
**Record:** Every other CPU-claim path in `scx_select_cpu_dfl()` calls
`scx_idle_test_and_clear_cpu()` before returning the selected CPU. The
WAKE_SYNC waker path was the only exception — systematic omission, not
an isolated quirk.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Exists?
**Record:** **Yes.** Current HEAD at `kernel/sched/ext_idle.c:551-552`:

```551:552:kernel/sched/ext_idle.c
                        if (cpumask_test_cpu(cpu, allowed))
                                goto out_unlock;
```

Missing `scx_idle_test_and_clear_cpu(cpu)` call. Fix commit
`b9f6521da1907` is **NOT** an ancestor of HEAD.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — patch targets `kernel/sched/ext_idle.c`
(user-provided diff showed `kernel/sched/ext/idle.c` from mainline post-
refactor; this tree uses the pre-refactor filename). `git apply --check`
on the actual backport commit succeeds with no conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix already in tree. Related idle-selection
fixes are present (NUMA lookup, prev_cpu recheck) but not this WAKE_SYNC
path.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **IMPORTANT** — `kernel/sched/ext_*` (sched_ext BPF
scheduler class). Not universal (requires `CONFIG_SCHED_CLASS_EXT`), but
scheduling correctness affects all tasks when enabled.

### Step 7.2: Subsystem Activity
**Record:** Highly active in 6.18.y — sched_ext merged for 6.18
(`fd95357fd8c67`), with ongoing idle-selection fixes backported to
stable.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_SCHED_CLASS_EXT` enabled running BPF
schedulers that use built-in idle CPU selection
(`SCX_OPS_KEEP_BUILTIN_IDLE` or no `ops.update_idle`). Includes
selftests and production schedulers (scx_simple, custom Google/Meta
schedulers, etc.).

### Step 8.2: Trigger Conditions
**Record:**
- Synchronous wakeup (`SCX_WAKE_SYNC` / `WF_SYNC`)
- Waker's local DSQ empty, system underutilized (idle CPUs exist)
- Waker CPU is in the allowed cpumask
- Particularly visible right after SCX enable when all CPUs are marked
  idle
- **Common enough** in normal wakeup patterns; not an obscure error path

### Step 8.3: Failure Mode Severity
**Record:**
- **Incorrect idle tracking** → BPF schedulers see CPU as idle when it's
  selected for a task
- **Selftest:** `scx_bpf_error()` → BPF scheduler disabled
  (`SCX_EXIT_ERROR_BPF`)
- **Production:** Suboptimal/wrong CPU placement, potential double-
  selection of "idle" CPUs, broken scheduler invariants for BPF code
  relying on idle mask accuracy
- **Severity: MEDIUM-HIGH** for sched_ext users (functional correctness
  / scheduler failure), not kernel oops/panic/data corruption

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Fixes real API contract violation; restores consistency
  with all other selection paths; fixes reproducible selftest failure;
  aligns with other sched_ext idle fixes already in 6.18.y
- **Risk:** Very low — 3-line addition of existing helper call
- **Ratio:** Strong benefit, minimal risk for affected users

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real bug: WAKE_SYNC path omits idle-bit clear that all sibling paths
  perform
- Bug present in v6.18.44 tree; fix not yet applied
- Patch applies cleanly
- Small, surgical, maintainer-signed (Tejun Heo)
- Breaks `scx_bpf_select_cpu_and()` API contract (returned CPU should
  not still be idle)
- Reproducible via `allowed_cpus` selftest
- Similar sched_ext idle fixes already backported to this tree
- sched_ext is a supported subsystem in 6.18.y

**AGAINST backport:**
- No production user crash report or CVE
- Only affects `CONFIG_SCHED_CLASS_EXT` users (optional config)
- Author acknowledges remaining unlikely races (fix is not complete for
  all edge cases)
- Not a kernel panic/oops — BPF scheduler error/disable at worst
- Lore discussion content unverified (bot protection)

**UNRESOLVED:**
- Full mailing list review thread content (could not fetch)
- Whether any reviewer explicitly nominated for stable

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors existing pattern;
   selftest no longer reproduces
2. Fixes a real bug affecting users? **PASS** — idle tracking
   inconsistency in sched_ext
3. Important issue? **PASS** — scheduling correctness bug; can disable
   BPF scheduler via `scx_bpf_error()`
4. Small and contained? **PASS** — 3 lines, 1 file, 1 function
5. No new features or APIs? **PASS** — state bookkeeping fix only
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception Categories
**Record:** Not applicable (not device ID, quirk, DT, build, or docs
fix).

### Step 9.4: Decision Rationale
This is a clear correctness bug in sched_ext's built-in idle CPU
tracking that exists in the 6.18.y tree. The fix is trivial, follows an
established pattern already used throughout the same function, applies
cleanly, and is consistent with other sched_ext idle-selection fixes
already backported to this stable series. While the primary documented
failure is a selftest, the underlying bug violates the
`scx_bpf_select_cpu_and()` contract and can affect real BPF scheduler
behavior on synchronous wakeups — a path reachable from normal process
activity.

---

## Verification

- **[Phase 1]** `git show b9f6521da1907 --format=fuller --no-patch`:
  parsed commit message and tags
- **[Phase 2]** `git show b9f6521da1907`: confirmed 3-line fix in
  `scx_select_cpu_dfl()` WAKE_SYNC path
- **[Phase 2]** Read `kernel/sched/ext_idle.c:519-570`: confirmed
  missing `scx_idle_test_and_clear_cpu(cpu)` on buggy path vs. present
  on other paths
- **[Phase 3]** `git blame -L 546,555 kernel/sched/ext_idle.c`:
  WAKE_SYNC block from `48849271e66114`, goto without clear from
  `23c63a965275ce`
- **[Phase 3]** `git merge-base --is-ancestor 23c63a965275ce HEAD`:
  buggy code is in tree
- **[Phase 3]** `git merge-base --is-ancestor b9f6521da1907 HEAD`: fix
  NOT in tree
- **[Phase 3]** `git log --oneline -15 stable/linux-6.18.y --
  kernel/sched/ext_idle.c`: related idle fixes already backported
- **[Phase 4]** `b4 dig -c b9f6521da1907 -a`: found v1 at
  patch.msgid.link/20260722143307.2772632-1-jpiecuch@google.com
- **[Phase 4]** WebFetch lore/msgid.link: **BLOCKED** by bot protection
  — thread content unverified
- **[Phase 5]** `Grep SCX_WAKE_SYNC, scx_select_cpu_dfl`: traced call
  paths through `scx_bpf_select_cpu_and()` and `ext.c:2578`
- **[Phase 5]** Read `allowed_cpus.bpf.c:17-27`: selftest validates CPU
  must not be idle after selection
- **[Phase 5]** Read `ext.c:6420-6431`: `scx_bpf_error()` triggers
  scheduler disable
- **[Phase 6]** `git describe HEAD`: v6.18.44 confirmed
- **[Phase 6]** `git show b9f6521da1907 -- kernel/sched/ext_idle.c | git
  apply --check`: clean apply
- **[Phase 6]** `Grep kernel/sched/ext`: directory does not exist; code
  is in `ext_idle.c` (filename differs from user's diff but same code)
- **[Phase 7]** `kernel/Kconfig.preempt:166-191`:
  `CONFIG_SCHED_CLASS_EXT` present in tree
- **[Phase 8]** Read `reset_idle_masks()` at `ext_idle.c:775-795`:
  confirms all online CPUs marked idle at SCX enable

**YES****Result:** Analysis of `sched_ext: Mark waker CPU busy when
selected in WAKE_SYNC case` (`b9f6521da1907`) for **linux-6.18.y
(v6.18.44)** is complete.

**Finding:** The bug is present in this tree — in
`scx_select_cpu_dfl()`’s `SCX_WAKE_SYNC` path, the waker CPU is selected
without calling `scx_idle_test_and_clear_cpu()`, unlike every other
selection path. That leaves SCX’s built-in idle tracking wrong and
breaks the `scx_bpf_select_cpu_and()` contract (reproducible via the
`allowed_cpus` selftest).

**Backport suitability:** The fix is 3 lines, applies cleanly to
`kernel/sched/ext_idle.c`, matches other sched_ext idle fixes already in
6.18.y, and is signed off by Tejun Heo.

**Verdict: YES** — backport to this tree.

 kernel/sched/ext_idle.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext_idle.c b/kernel/sched/ext_idle.c
index d16a1de078656..42a65a9535aef 100644
--- a/kernel/sched/ext_idle.c
+++ b/kernel/sched/ext_idle.c
@@ -548,8 +548,10 @@ s32 scx_select_cpu_dfl(struct task_struct *p, s32 prev_cpu, u64 wake_flags,
 		    cpu_rq(cpu)->scx.local_dsq.nr == 0 &&
 		    (!(flags & SCX_PICK_IDLE_IN_NODE) || (waker_node == node)) &&
 		    !cpumask_empty(idle_cpumask(waker_node)->cpu)) {
-			if (cpumask_test_cpu(cpu, allowed))
+			if (cpumask_test_cpu(cpu, allowed)) {
+				scx_idle_test_and_clear_cpu(cpu);
 				goto out_unlock;
+			}
 		}
 	}
 
-- 
2.53.0

