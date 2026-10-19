Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971594FFA5E;
	Mon, 19 Oct 2026 13:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418259; cv=none; b=A7tNpR+YqGOWFAao92DLcGD3MkaudT86gI8ekxAs+i0Or4hRrub0CcUFjd0LmC8Iok0+s3cFcZQEzWvKLlTLNwKExdI6+Qjs9U/wdc1qqMKFFNycdOExNeCshF8J0dieOVFOkJOMpxT2MvOuwgyInxM+AsO4VIi35vP0qjYj2To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418259; c=relaxed/simple;
	bh=GRa+adR9gcEu36dxBTH2LE/PC300d6J8yKkAixZ13cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EI9roHrFESdV7H3RFpJL+i0ADCKGHyKUKQfS1QADWuGUGxCpX+/X2b58U5FbyJd+q8/JQOUGUjNNEEC27jlijtVExgF6OKjGkhYv9Zb2XTEo6DpjxCIdLFPmaIIuW0TFVZESJ8p+UhFT95Ac9ic7ms4IvTpfaGld/dY0+2DuNp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnagN85g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnagN85g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AB61F000C5;
	Mon, 19 Oct 2026 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418257;
	bh=Yf4wDzeS/mnKuQFF/RJEmEwysZgxQ9lxEjWcYlcYlcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnagN85gyy5TgysYhyW5mE7kbbIhGl7UzF/GWdCmeJvB9JXOsQJqpQZdwYg1TO6Md
	 sDp73CZ8G4vU4STzwIvDKn3jexmBOBC1SZtdb6eXRXoeIWw67lsnW5CjU4Ukr+oSmn
	 cZaPtYxfgxoja/ey8Q20vinYTtA4Bs5h+JovcIwnCbSeMOJ7CGchkmUcI1jtjQ8ApR
	 fPb/RuOXx4hYXC2B8G1kydXl5vq18vYLlw9IyvFUQxBpRo3ctBpzOSErpDa7cmoOJU
	 TQPbBFSYQnDvQUcAxf5kjvBs12G7/OpDuTaYzfSXM8EjkFa0ffVzPQM/mqnWYNDzZt
	 4ETxF0KOf0+/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/xe: only resume exec queues that were actually suspended
Date: Mon, 19 Oct 2026 09:46:55 -0400
Message-ID: <20261019135441.1420968-124-sashal@kernel.org>
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

From: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

[ Upstream commit 65f40fa5022bcdb90d3a39e4948adf2aa16732a3 ]

A consumer-issued suspend() can fail (e.g. the queue is killed, banned
or wedged), leaving the queue un-suspended. The consumer must then not
issue the matching resume(): resuming a queue that was never suspended
is incorrect.

Add an lr.suspended flag to struct xe_exec_queue that records whether a
consumer suspend() succeeded and a matching resume() is still owed. Set
it on a successful suspend() in the preempt-fence path, clear it on
resume(), and only resume queues that have it set.

In resume_and_reinstall_preempt_fences() also skip queues that have
since been reset/killed/banned/wedged: such a queue's suspend may not
have completed (suspend_pending can still be set, e.g. a preempt fence
signalled with -ENOENT without waiting), so resuming it would trip the
!suspend_pending assert in the backend. Leave it marked suspended and
let teardown resolve its state.

A queue is only ever suspended by a single consumer at a time
(preempt-fence mode and hw engine group fault mode are mutually
exclusive), so a single flag is sufficient.

Assisted-by: Github-Copilot:Claude-opus-4.8
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260713202317.2187787-9-niranjana.vishwanathapura@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **v7.3-rc4** (mainline). The Xe preempt-fence path this
patch touches is present, and the change is a small, self-contained
pairing fix for a real GuC suspend/resume protocol bug.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[drm/xe] [only resume] only resume exec queues that were
  actually suspended`
- Subsystem: Intel Xe DRM. Verb “only resume” is a restriction/guard: do
  not resume a queue that was never successfully suspended.

**Step 1.2: Tags**
- Record:
  - `Assisted-by: Github-Copilot:Claude-opus-4.8`
  - `Signed-off-by: Niranjana Vishwanathapura` (author)
  - `Reviewed-by: Matthew Brost` (Xe maintainer)
  - `Link: https://patch.msgid.link/20260713202317.2187787-9-
    niranjana.vishwanathapura@intel.com`
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable` (absence is
    expected)
  - Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
    …]` markers; none were on the real commit

**Step 1.3: Body**
- Record: `[Bug] Consumer `suspend()` can fail (killed/banned/wedged)
  leaving the queue un-suspended; the matching `resume()` was still
  issued. A second case: suspend started but the preempt fence was
  signalled `-ENOENT` without `suspend_wait()`, so `suspend_pending` can
  still be set; `resume()` then trips the backend `!suspend_pending`
  assert.`
- `[Symptom]` Incorrect resume pairing; GuC backend assert; scheduling
  state left inconsistent.
- `[Version]` None stated. Series title: “balance exec queue
  suspend/resume”.
- `[Root cause]` Resume was unconditional. Fix: `lr.suspended` set only
  on successful `suspend()`, cleared on `resume()`, and skip
  reset/killed/banned/wedged queues.

**Step 1.4: Hidden bug fix?**
- Record: Not disguised. Explicit correctness fix. Covering letter also
  calls the series “fixes and hardens”; this patch is the pairing fix,
  not a pure cleanup.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: 3 files, **+36 / -1**
  - `xe_exec_queue_types.h`: add `bool lr.suspended` (+12)
  - `xe_preempt_fence.c`: `preempt_fence_enable_signaling()` (+7)
  - `xe_vm.c`: `resume_and_reinstall_preempt_fences()` (+17 / -1)
- Scope: single-subsystem surgical fix.

**Step 2.2: Code flow**
- Record:
  - **Before:** `suspend()` return stored in `pfence->error`;
    `resume_and_reinstall_preempt_fences()` always called
    `q->ops->resume(q)` for every queue on `vm->preempt.exec_queues`.
  - **After:** successful `suspend()` does `WRITE_ONCE(q->lr.suspended,
    true)`; resume only if `READ_ONCE(q->lr.suspended) &&
    !q->ops->reset_status(q)`, then clears the flag.
- Path: compute/long-running VM rebind worker (preempt-fence mode), not
  probe/init.

**Step 2.3: Bug mechanism**
- Record: `[Logic / state-machine pairing]` plus `[debug assert]`
- At the parent of this commit, GuC resume was:

```2248:2254:drivers/gpu/drm/xe/xe_guc_submit.c
// parent: 65f40fa5022bc^
xe_gt_assert(guc_to_gt(guc), !q->guc->suspend_pending);
guc_exec_queue_try_add_msg(q, msg, RESUME);
```

- Failed `suspend()` returns `-EINVAL` *before* setting
  `suspend_pending`. Unconditional `resume()` still queues a GuC RESUME.
- `preempt_fence_work_func()` on `reset_status()` signals `-ENOENT`
  without `suspend_wait()`, so `suspend_pending` can still be true when
  resume runs.
- `guc_exec_queue_allowed_to_change_state()` is `!killed/banned/wedged
  && registered` — it does **not** check RESET. A reset-but-not-yet-
  killed queue can take the resume path and call `enable_scheduling()`.

**Step 2.4: Fix quality**
- Record: Obviously correct pairing (resume only if suspend succeeded
  and queue is not in reset/kill). Minimal. Adds an internal flag only.
  WRITE_ONCE/READ_ONCE match the comment that only one consumer suspends
  at a time (preempt-fence vs hw-engine-group fault mode). Regression
  risk: low; skipping resume is limited to queues already failing, which
  the commit says teardown owns.

## Phase 3: Git history

**Step 3.1: Blame / introduction**
- Record: Unconditional `q->ops->resume(q)` in
  `resume_and_reinstall_preempt_fences()` dates to `dd08ebf6c3525`
  (“drm/xe: Introduce a new DRM driver for Intel GPUs”), i.e. Xe’s
  introduction (v6.8-era). Long-standing, not last-month code.

**Step 3.2: Fixes: tag**
- Record: No `Fixes:` tag. Buggy resume site is original Xe code, not a
  recent regression-only commit.

**Step 3.3: Related file history**
- Record: This is **patch 1/6** of “drm/xe: balance exec queue
  suspend/resume”. Later commits in this tree that use `lr.suspended` /
  continue the series:
  - `dad2af2da9ead` ban on suspend timeout
  - `412c885692cad` uninterruptible suspend wait
  - `c373eaaada2fe` hw_engine_group propagate suspend failures (sets
    `lr.suspended` there)
  - `3c316b09072c2` suspend refcount
  - `5d5a729cc9780` multi-queue preempt primary
- Patch 1 is standalone for the preempt-fence path. Later patches are
  not required for this hunk to be correct.

**Step 3.4: Author**
- Record: Niranjana Vishwanathapura, regular Xe contributor. Reviewed by
  Matthew Brost, Xe maintainer (`MAINTAINERS`: INTEL DRM XE DRIVER).

**Step 3.5: Dependencies**
- Record: Needs existing `q->ops->suspend`, `resume`, `reset_status`,
  and `struct xe_exec_queue` `lr` — all present here. No new helper from
  later series patches. Can apply standalone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: `b4 dig -c 65f40fa5022bc` → https://patch.msgid.link/202607132
  02317.2187787-9-niranjana.vishwanathapura@intel.com
- Revisions: v1 (2026-06-24, 1/5) → v2 → v3 (1/6) → v5 covering letter
  2026-07-13. Applied version is v5 1/6.
- Covering letter: consumers issued resume even when suspend never took
  effect; “with the GuC backend it can trip the `!suspend_pending`
  assertion or leave scheduling state inconsistent.”
- No NAKs in the saved thread mbox (series posts only; `Reviewed-by` was
  already on the submission).

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: `intel-xe@lists.freedesktop.org`, Matthew Brost, Thomas
  Hellström (both Xe maintainers). Right list and maintainers.

**Step 4.3: Bug report**
- Record: No syzbot, bugzilla, or user `Reported-by`. Author-driven
  correctness fix.

**Step 4.4: Series**
- Record: 6 patches. Patch 1 = this commit (preempt-fence pairing).
  Patch 4 applies the same flag to hw engine group. Patch 6 is multi-
  queue GuC preempt behavior. This commit does not depend on 2–6.

**Step 4.5: Stable list**
- Record: lore.kernel.org/stable search for this subject did not show a
  dedicated stable request or rejection (unrelated 7.2/6.18 review mails
  matched generic words).

## Phase 5: Semantic / call-chain

**Step 5.1: Functions**
- Record: `preempt_fence_enable_signaling`,
  `resume_and_reinstall_preempt_fences`. New field
  `xe_exec_queue.lr.suspended`.

**Step 5.2: Callers**
- Record: `resume_and_reinstall_preempt_fences()` is called once from
  the preempt rebind worker after `arm_preempt_fences()` (“point of no
  return”). `preempt_fence_enable_signaling` is the dma-fence
  `enable_signaling` callback for Xe preempt fences.

**Step 5.3: Callees**
- Record: `q->ops->suspend` / `resume` / `reset_status` (GuC backend is
  the real one; execlist ops are NIY stubs).

**Step 5.4: Reachability**
- Record: Yes from userspace. `xe_vm_in_preempt_fence_mode()` is long-
  running compute VMs (`XE_VM_FLAG_LR_MODE` and not fault mode).
  Triggered when the VM rebind worker runs (BO moves, userptr
  invalidation, eviction) while compute exec queues are attached.
  Concurrent GPU reset/kill of a queue during that window is the bad
  path.

**Step 5.5: Similar patterns**
- Record: Same `lr.suspended` discipline later in `xe_hw_engine_group.c`
  (series patch 4). Confirms this is the intended pairing primitive, not
  a one-off hack.

## Phase 6: This tree

**Step 6.1: Buggy code in this tree?**
- Record: Yes. Tree is `v7.3-rc4-27-gf0100363d8c37`, `VERSION=7
  PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4`. Xe files exist. Parent of
  `65f40fa5022bc` still has unconditional `q->ops->resume(q)`. Bug
  introduced with Xe (`dd08ebf6c3525`), well before 7.3.

**Step 6.2: Backport difficulty**
- Record: For this tree, the surrounding structs/ops match the diff:
  clean apply. (This commit is already an ancestor of HEAD; that is used
  only to inspect the code, not as a “already selected” reason.)

**Step 6.3: Related fixes already here**
- Record: No earlier alternate fix of this pairing. Later series patches
  extend the same flag to other callers; they do not replace this
  preempt-fence fix.

## Phase 7: Subsystem context

**Step 7.1**
- Record: `[drivers/gpu/drm/xe] [IMPORTANT]` — Intel Xe (Lunar Lake and
  newer). Not core mm/net, but a supported production GPU driver.

**Step 7.2**
- Record: High activity (many Xe commits in this tree). The bug itself
  is old pairing, not a brand-new subsystem.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Xe users with long-running/compute exec queues in preempt-
  fence mode (Intel compute / Level Zero style workloads), during VM
  rebind plus queue reset/kill/ban/wedge.

**Step 8.2: Trigger**
- Record: Not every boot. Concurrent rebind + queue failure/reset.
  Userspace-reachable via compute VM + memory movement + hang/reset or
  queue destroy. Timing-dependent.

**Step 8.3: Failure mode**
- Record: `xe_gt_assert` is **debug-only** (`CONFIG_DRM_XE_DEBUG`);
  production distro kernels will not WARN there. Production still queues
  GuC RESUME without a completed suspend. For killed queues,
  `allowed_to_change_state` makes the resume handler mostly a no-op. For
  **RESET but not yet killed** queues, resume can `enable_scheduling()`
  on a context hang recovery is tearing down — GPU scheduling
  inconsistency / possible hang of that engine, not a kernel oops.
- Severity: **HIGH** for the reset-window GuC protocol break; **MEDIUM**
  if only dead queues are poked (mostly no-op + debug WARN).

**Step 8.4: Risk-benefit**
- Record: Benefit: medium-high for Xe compute (prevents illegal resume /
  enable on reset queues). Risk: low (36 lines, error/teardown path, no
  UAPI). Ratio favors taking it.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real pairing bug: resume of never-suspended or still-pending-suspend
  queues.
- Concrete backend contract: `guc_exec_queue_resume()` asserts
  `!suspend_pending` and (in production) still submits RESUME.
- Reset vs kill mismatch: `reset_status` includes RESET;
  `allowed_to_change_state` does not — so old resume can re-enable a
  reset context.
- Small, obviously correct, maintainer-reviewed (Matthew Brost).
- Self-contained for preempt-fence; this tree has the code.
- No new userspace API.

AGAINST:
- Series 1/6; later patches continue related hardening (not required
  here).
- No `Reported-by` / syzbot.
- Healthy queues on the success path are unchanged; the skip is for
  already-failing queues.
- Primary wording in the commit is the debug assert.

UNRESOLVED:
- No public user crash report proving a full-device GPU hang in the
  wild.
- Stable list had no explicit ACK/NAK for this subject.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — pairing is straightforward;
   v1–v5 review; maintainer `Reviewed-by`.
2. Real bug affecting users? **PASS** — reachable compute rebind +
   reset/kill path; illegal GuC RESUME.
3. Important (crash/security/corruption/deadlock)? **PASS** — not a
   kernel oops in production, but GuC protocol violation and
   `enable_scheduling()` on a reset queue is a serious GPU-driver
   failure (hang / inconsistent scheduling), which is in the “etc.”
   class for driver stability.
4. Small and contained? **PASS** — 36 lines, 3 Xe files.
5. No new features/APIs? **PASS** — internal flag only. (Series patch 6
   is a feature; this patch is not.)
6. Can apply to this tree? **PASS** — Xe preempt-fence path and ops
   exist; hunk is against the local structures.

**Step 9.3: Exception category**
- Record: None (not a device ID, quirk, DT, build, or docs fix).
  Qualifies as a normal bugfix.

**Step 9.4: Decision**
This is a small, reviewed correctness fix for a real suspend/resume
imbalance on a supported Intel GPU compute path. It does not add
features, applies to this tree’s Xe code, and the production risk of the
bug is illegal GuC resume (including re-enabling a reset context), not
merely a debug WARN. That meets stable rules for this checkout.

### What it solves for users of this tree
On Xe long-running (preempt-fence) VMs, the rebind worker always resumed
every attached exec queue. If `suspend()` had failed or the queue was
reset before suspend finished, that resume violated the GuC backend
contract. This patch records a successful suspend and only resumes those
queues, so already-failed queues are left to teardown instead of getting
a spurious RESUME.

### Risk vs benefit
Benefit is avoiding GuC protocol errors and possible engine re-enable
during reset. Risk is low: one flag, two call sites, no UAPI, skip
limited to reset/killed queues.

### Concerns
It is patch 1/6; hw-engine-group pairing is a later commit and is not
required for this hunk. No in-the-wild report. Debug asserts are
compiled out of production, so the user-visible production issue is the
protocol/state bug, not a WARN.

### Verification
- [Phase 1] Parsed commit `65f40fa5022bc`: tags as listed; no
  Fixes/Reported-by/Cc-stable.
- [Phase 2] Diff: +36/-1 in three Xe files; resume became conditional on
  `lr.suspended && !reset_status()`.
- [Phase 2] Parent `guc_exec_queue_suspend` returns `-EINVAL` for
  killed/banned/wedged without setting `suspend_pending`; parent
  `guc_exec_queue_resume` asserts `!suspend_pending` then
  `try_add_msg(RESUME)`.
- [Phase 2] `xe_assert.h`: `xe_gt_assert` effective only with
  `CONFIG_DRM_XE_DEBUG`.
- [Phase 2] `guc_exec_queue_allowed_to_change_state()` ignores RESET;
  `guc_exec_queue_reset_status()` includes RESET;
  `xe_guc_exec_queue_reset_handler()` sets reset then `trigger_cleanup`
  — window verified in `xe_guc_submit.c`.
- [Phase 3] `git log -S 'resume_and_reinstall_preempt_fences' --
  drivers/gpu/drm/xe/xe_vm.c` → `dd08ebf6c3525`.
- [Phase 3] Series neighbors confirmed via `git log --author=Niranjana
  Vishwanathapura -- drivers/gpu/drm/xe/`.
- [Phase 3] `git merge-base --is-ancestor 65f40fa5022bc HEAD` succeeds
  (used to inspect, not as a selection argument). `git merge-base --is-
  ancestor 65f40fa5022bc v7.2` fails; present since `v7.3-rc1`.
- [Phase 4] `b4 dig -c 65f40fa5022bc` / `-a` / `-w` / `-m /tmp/xe-
  suspend.mbox`: v5 1/6, maintainers CC’d, covering letter quoted above;
  mbox had no NAK replies.
- [Phase 4] lore.kernel.org/stable search: no dedicated discussion of
  this patch.
- [Phase 5] Only caller of `resume_and_reinstall_preempt_fences` is the
  rebind worker in `xe_vm.c` (~line 569).
- [Phase 6] `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` → `7.3.0-rc4`.
- [Phase 7] `MAINTAINERS`: Matthew Brost is Xe maintainer; he reviewed
  the patch.
- [Phase 8] Failure mode: production GuC RESUME without completed
  suspend; debug WARN only if `CONFIG_DRM_XE_DEBUG`.
- UNVERIFIED: no public user GPU-hang log for this exact race.

**YES**

 drivers/gpu/drm/xe/xe_exec_queue_types.h | 12 ++++++++++++
 drivers/gpu/drm/xe/xe_preempt_fence.c    |  7 +++++++
 drivers/gpu/drm/xe/xe_vm.c               | 18 +++++++++++++++++-
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue_types.h b/drivers/gpu/drm/xe/xe_exec_queue_types.h
index 38906cb7608ca..c5024acf4aaf0 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_exec_queue_types.h
@@ -139,6 +139,18 @@ struct xe_exec_queue {
 		u32 seqno;
 		/** @lr.link: link into VM's list of exec queues */
 		struct list_head link;
+		/**
+		 * @lr.suspended: Tracks whether the consumer-issued suspend()
+		 * succeeded and a matching resume() is still owed. suspend() can
+		 * fail (e.g. killed/banned/wedged), leaving the queue
+		 * un-suspended, so consumers must only resume() queues that were
+		 * actually suspended. Set by the suspend caller on success and
+		 * cleared by the resume caller. A queue is only ever suspended by
+		 * a single consumer at a time (preempt-fence mode and hw engine
+		 * group fault mode are mutually exclusive), so a single flag is
+		 * sufficient.
+		 */
+		bool suspended;
 	} lr;
 
 #define XE_EXEC_QUEUE_TLB_INVAL_PRIMARY_GT	0
diff --git a/drivers/gpu/drm/xe/xe_preempt_fence.c b/drivers/gpu/drm/xe/xe_preempt_fence.c
index 83fbeea5aa201..014a5980febd0 100644
--- a/drivers/gpu/drm/xe/xe_preempt_fence.c
+++ b/drivers/gpu/drm/xe/xe_preempt_fence.c
@@ -63,6 +63,13 @@ static bool preempt_fence_enable_signaling(struct dma_fence *fence)
 	struct xe_exec_queue *q = pfence->q;
 
 	pfence->error = q->ops->suspend(q);
+	/*
+	 * Record a successful suspend so the rebind worker only resumes queues
+	 * that were actually suspended; a failed suspend() leaves the queue
+	 * un-suspended and must not be paired with a resume().
+	 */
+	if (!pfence->error)
+		WRITE_ONCE(q->lr.suspended, true);
 	queue_work(q->vm->xe->preempt_fence_wq, &pfence->preempt_work);
 	return true;
 }
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index a4272bc248ec7..b139ee46208ad 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -195,7 +195,23 @@ static void resume_and_reinstall_preempt_fences(struct xe_vm *vm,
 	xe_vm_assert_held(vm);
 
 	list_for_each_entry(q, &vm->preempt.exec_queues, lr.link) {
-		q->ops->resume(q);
+		/*
+		 * Only resume queues whose suspend() actually succeeded. A
+		 * failed suspend() (e.g. killed/banned/wedged) leaves the queue
+		 * un-suspended, so it must not be resumed.
+		 *
+		 * Also skip queues that have since been reset/killed/banned/
+		 * wedged: their suspend may not have completed (suspend_pending
+		 * can still be set, e.g. a preempt fence signalled with -ENOENT
+		 * without waiting), so resuming would trip the !suspend_pending
+		 * assert in the backend. Such queues are being torn down anyway,
+		 * so leave them marked suspended and let teardown resolve their
+		 * state.
+		 */
+		if (READ_ONCE(q->lr.suspended) && !q->ops->reset_status(q)) {
+			WRITE_ONCE(q->lr.suspended, false);
+			q->ops->resume(q);
+		}
 
 		drm_gpuvm_resv_add_fence(&vm->gpuvm, exec, q->lr.pfence,
 					 DMA_RESV_USAGE_BOOKKEEP, DMA_RESV_USAGE_BOOKKEEP);
-- 
2.53.0

