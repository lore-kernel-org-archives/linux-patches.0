Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C8063AC4A;
	Mon, 19 Oct 2026 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418759; cv=none; b=uP1l3fueF31go846670MYRmFYXfBnF2/23NCJN3Z2sRDw8CLN+3F3ENk6382HwcIaXo84MSj2HBvtY4ak7Q2MlO+Iu1Dz8XnlRHB70Zp3fpphQqBCXr3pTTpF7a/gmsgBWjoivVJj84Q9LRF3P0ip+0r8+rGE18DgnLLNL4k3EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418759; c=relaxed/simple;
	bh=wgFAOnIfWAAtwIbMxwsX/6glIaVoKg0MB/VPPRSKcEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8EdyxJEnge/BKT/CW7cbc1xybBFa4ua1ZzyybXI+BkXpgcWNB3a22foLVkdLgtoEQwggjUpAxtxkjWhob1tDfIApq0i/DZkHj63Brqwsi2eJFv9+QLLGfe5xZzXnXnuChD+uMUdeWQ9rWZ5VOlD/Qx/zt5QAaFPRqztqnKyZUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRe5gCf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRe5gCf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2F01F000CC;
	Mon, 19 Oct 2026 14:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418755;
	bh=nwNci7lncnQZmqv+RzcO6wCyJ135mziBAxyfw2m9PZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRe5gCf605th8ZDNzPfYMkrMUwD/1KEb4G5DAy8Vfx8CylUGEYEJ3wo/+9P0mkapF
	 3KyOB7CxPzb9/Y3vCFrrLBcZ6uC52TxH2Yy1diOEMWmW3nzZda2DF3SH/jZRQ5/FjG
	 VbNplbwwzbW+OgSLDqqV2FPG52EYltVTiBl/6R4X+M/JxwsePP8u/ziauW0j82HdOX
	 CL6BFC8xi+wfPWZsg+FRmCEGJ7Jo8zoOx7t1PLOm1wDMoL8ALX7aZnkkdwkv0rm91a
	 jAtn8iePu4CUZt+NxJR9G7cEdY2j8G0Mw1aqLDmDFpi7wC0OUbukV1hnW3ZJXNksDp
	 6N46iLKnrIEEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Amber Lin <amber.lin@amd.com>,
	David Yat Sin <david.yatsin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdkfd: Fix signal reset event
Date: Mon, 19 Oct 2026 09:52:44 -0400
Message-ID: <20261019135441.1420968-473-sashal@kernel.org>
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

From: Amber Lin <amber.lin@amd.com>

[ Upstream commit b38f9b6ffdfc86d5aff36881d9e8028c79bc98c9 ]

When a mode reset happens, driver needs to notify the process on that
GPU a reset event is happening. The existing code assumes the process is
using the GPU that is getting mode reset, which is not always true. For
example, on a 8G system, the process may be only using GPU 0~4 but a
mode 2 reset is resetting the all 8 GPUs connected by XGMI. Trying to
find a process on GPU 5~7 will fail, which is fine and should skip the
event signal.

Signed-off-by: Amber Lin <amber.lin@amd.com>
Reviewed-by: David Yat Sin <david.yatsin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
The local tree is **v7.3-rc4**. The commit is a small, obviously-correct
logic fix: `kfd_signal_reset_event()` treated “process is not using this
GPU” as unexpected and fired `WARN_ONCE` during a hive-wide mode reset.
That warning is a real production issue on multi-GPU XGMI systems.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[drm/amdkfd] [Fix] [stop treating “process not on this GPU” as
an error when signaling a reset event]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Fixes: none (expected for this review)
- Reported-by: none
- Tested-by: none
- Reviewed-by: David Yat Sin `<david.yatsin@amd.com>` (author of the
  CRIU gpu_id remapping that added the `user_gpu_id` lookup)
- Acked-by: none
- Link: none in the commit; mailing-list thread found via `b4 dig`
- Cc: stable: none (expected)
- Signed-off-by: Amber Lin `<amber.lin@amd.com>` (author); Alex Deucher
  `<alexander.deucher@amd.com>` (amdgpu/amdkfd maintainer)
- Sasha Levin SOB: not present on this commit

Notable: maintainer SOB + review from the engineer who introduced the
original lookup. No syzbot, no user-report tags.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: on mode reset the driver notifies KFD processes of a reset. The
  loop assumes every process uses the GPU being reset.
- Symptom: looking up a process on GPUs it does not use fails. Example:
  8-GPU XGMI hive, process on GPUs 0–4, mode-2 reset of all 8 GPUs;
  lookups on GPUs 5–7 fail.
- Failure mode: those failed lookups hit `WARN_ONCE` then `continue`.
  Signaling skip is correct; the warning is not.
- Version info: none in the message.
- Root cause: expected “process not bound to this device” was coded as
  an unexpected error.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Subject is “Fix …”. It is a real logic/warning bug,
not cleanup-only.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/gpu/drm/amd/amdkfd/kfd_events.c` (+8 / −9)
- Function: `kfd_signal_reset_event()`
- Scope: single-file surgical fix, one function

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
Before (inside `hash_for_each_rcu(kfd_processes_table, …)`):
1. `user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id)`
2. `pdd = kfd_get_process_device_data(dev, p)`
3. If `user_gpu_id == -EINVAL` → `WARN_ONCE` + `continue`
4. If `!pdd` → `WARN_ONCE` + `continue`

After:
1. `pdd = kfd_get_process_device_data(dev, p)`
2. If `!pdd` → silent `continue` (process not using this device)
3. Then `user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id)`
4. If `user_gpu_id == -EINVAL` → `WARN_ONCE` + `continue` (now a real
   inconsistency, because `pdd` exists)

Also moves `user_gpu_id`/`pdd` from inner-loop locals to function
locals; format for `dev->id` changes `%x` → `%d`. Normal reset path for
processes that *do* use the GPU is unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[Logic / correctness] [false WARN_ONCE]`
`kfd_get_process_device_data()` returns NULL when the process has no pdd
for `dev`. `kfd_process_get_user_gpu_id()` returns `-EINVAL` for the
same situation. Both were treated as unexpected. On a hive-wide reset,
`kgd2kfd_pre_reset()` calls `kfd_signal_reset_event()` per node, and the
function walks **all** KFD processes, so missing pdd is normal. After
the fix, missing pdd is expected; `WARN_ONCE` remains only if pdd exists
but gpu_id lookup still fails.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. `kfd_get_process_device_data()` and
`kfd_process_get_user_gpu_id()` iterate the same `p->pdds[]`; a present
pdd implies a matching `dev->id`. Minimal, no API/locking/refcount
changes. Regression risk is very low: processes without a pdd still skip
signaling (same as before). Residual `WARN_ONCE` is strictly narrower.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Function introduced: `e42051d2133b79` (“drm/amdkfd: Implement GPU
  reset handlers in KFD”, 2018, v4.19-rc1 era)
- `user_gpu_id` + first `WARN_ONCE` on `-EINVAL`: `bef153b70c6e35`
  (“drm/amdkfd: CRIU implement gpu_id remapping”, 2021)
- `kfd_get_process_device_data` + `!pdd` path: `ee0a469cf9175a`
  (“drm/amdkfd: support per-queue reset on gfx9”, 2024, in v6.12-rc1)
- `!pdd` `WARN_ONCE` text using pid: `8544374c0f82ed` (“drm/amdkfd: Have
  kfd driver use same PASID values…”, 2025)

The false-warning on “process not on this GPU” dates to the 2021 CRIU
remapping (`user_gpu_id == -EINVAL`). The later `!pdd` WARN made the
same class of miss look even more like a driver bug. This is long-lived
code on this tree, not last-month-only.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Not applicable. The buggy assumption was
introduced by `bef153b70c6e35` (and reinforced by `ee0a469cf9175a` /
`8544374c0f82ed`). All three are ancestors of HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `kfd_events.c` work is CRIU bounds checks, event mmap
cleanup, RAS poison ioctl — orthogonal. Same author also landed
`4693ade087f2e` (“drm/amdkfd: Fix reset event signal”) which guards
`kfd_signal_reset_event()` in `reset_queues_mes()` when
`detect_hang_count` is 0. Different bug (false reset *signal* vs false
*WARN* on missing pdd). This commit is standalone, not patch N/M.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Amber Lin is a regular AMD KFD/queue-reset contributor
(`drm/amdkfd: Add queue reset support…`, topology, MES). Not the
subsystem maintainer; maintainer Alex Deucher merged it. Related:
`4693ade087f2e` as above — complementary, not a prerequisite for this
diff.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Diff uses `kfd_get_process_device_data`,
`kfd_process_get_user_gpu_id`, `kfd_signal_reset_event` — all present in
this tree. No new helpers. Can apply standalone here.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c b38f9b6ffdfc86d5aff36881d9e8028c79bc98c9` →
  https://patch.msgid.link/20260728182609.672822-1-amber.lin@amd.com
- Also: https://lists.freedesktop.org/archives/amd-
  gfx/2026-July/149514.html
- `b4 dig -a`: single revision, v1 only; committed version matches v1
- Review: David Yat Sin `Reviewed-by` (~12 minutes later):
  https://lists.freedesktop.org/archives/amd-gfx/2026-July/149516.html
- No NAK, no requested respin, no reviewer `Cc: stable`
- lore.kernel.org fetches returned 403; discussion recovered from fd.o
  archives and `b4 dig`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Original To/Cc (`b4 dig -w`): Amber Lin, amd-
gfx@lists.freedesktop.org, david.yatsin@amd.com,
jinhuieric.huang@amd.com. Appropriate KFD reviewers. Merged by Alex
Deucher.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, no bugzilla/syzbot link. Description reads as
internal AMD multi-GPU/XGMI observation (“8G system”, mode 2 reset). No
public user-count. UNVERIFIED: how many field systems hit this.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[PATCH]`, not a series. Earlier similarly titled
`4693ade087f2e` is a different file/bug. No other patches required for
this hunk.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403. fd.o/mail-archive
search showed only the amd-gfx v1 + review. No evidence this was already
discussed on stable. UNVERIFIED via lore stable archive due to 403.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `kfd_signal_reset_event()` only.

**Step 5.2: TRACE CALLERS**
Record (from grep in this tree):
- `kgd2kfd_pre_reset()` in `kfd_device.c` — GPU/mode reset: loops
  `kfd->num_nodes` and signals each. Called from `amdgpu_amdkfd.c`
  during amdgpu reset. This is the hive/mode-reset path in the commit
  message.
- `reset_queues_mes()` in `kfd_device_queue_manager.c` — per-queue MES
  reset when `detect_hang_count != 0`
- other DQM hang-reset paths at lines ~2528 and ~2615 — after successful
  queue/SDMA reset

Context: GPU reset / hang recovery, not a syscall hot path. Userspace
compute (ROCm/KFD) processes receive HSA HW_EXCEPTION / MEMORY events.

**Step 5.3: TRACE CALLEES**
Record: `kfd_get_process_device_data` (scan `p->pdds[]` for `dev`, NULL
if unused), `kfd_process_get_user_gpu_id` (same table → `user_gpu_id` or
`-EINVAL`), `set_event()`, `amdgpu_file_to_fpriv` /
`amdgpu_vm_get_task_info_vm` on the hang-count branch (unchanged).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: amdgpu GPU reset → `kgd2kfd_pre_reset` →
`kfd_signal_reset_event` → all KFD processes. Reachable on real hardware
when a GPU hang/reset or XGMI mode-2 reset runs. Not a syzbot syscall
path; it is a production compute-cluster path. Unprivileged users do not
directly call it; they can contribute to GPU hangs that trigger reset.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same `WARN_ONCE` + `kfd_process_get_user_gpu_id` pattern remains
in `kfd_signal_vm_fault_event()` and
`kfd_signal_poison_consumed_event()`. Those start from a known
pdd/pasid, so a miss is more genuinely unexpected. This reset path is
the one that walks every process against one device.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Tree is v7.3-rc4 (`f0100363d8c37`).
`kfd_signal_reset_event()` exists; `git merge-base --is-ancestor
b38f9b6ffdfc86 HEAD` is true (fix already on this branch). Pre-fix code
is the parent of that commit; `bef153b70c6e35`, `ee0a469cf9175a`, and
`8544374c0f82ed` are all ancestors. Bug introduced in this lineage in
2021 (warn on missing gpu_id), not after 7.3 branched.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply on this tree (already applied as a 17-line hunk).
Surrounding hang-count / `amdgpu_file_to_fpriv` code is present.
Expected difficulty here: clean apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact fix is commit `b38f9b6ffdfc8` on HEAD. No alternate
fix of the same warning. `4693ade087f2e` is a different reset-signal bug
and is also in this tree.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `[drm/amdkfd]` `[IMPORTANT]` — AMD compute (ROCm) on
Instinct/dGPU, not core mm/VFS. Multi-GPU XGMI hives are production
HPC/AI machines.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively developed (queue reset, SVM, CRIU, RAS). The reset-
event function itself has been stable since 2018 with incremental
lookup/warn additions.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific: KFD users on multi-GPU AMD systems, especially
XGMI hives during mode-2 reset. Single-GPU boxes typically always have a
pdd for the only device, so they would not hit the false warning.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: GPU/mode reset while KFD processes exist that do not use every
GPU in the reset set. Common on 8-GPU hives with jobs bound to a subset
of GPUs. Timing-independent. Not directly triggerable by an unprivileged
syscall; reachable after a hang/reset.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: `[false WARN_ONCE during GPU reset]` `[MEDIUM, HIGH if
panic_on_warn]`
Verified: `WARN_ONCE` → `WARN()` (`include/asm-generic/bug.h`). That
dumps a stack, taints (`TAINT_WARN`), and panics if `panic_on_warn`.
Default configs do not panic. Userspace reset events were already
skipped via `continue`; this is not data corruption or a hang. It *is* a
real kernel warning on a serious recovery path.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: medium-high for KFD multi-GPU reset (stops false
  WARN/taint/possible panic_on_warn during hive reset)
- Risk: very low (8/9 lines, reorder existing checks, no locking/API)
- Ratio: favorable

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real bug: expected “process not using this GPU” was `WARN_ONCE`
- Trigger is concrete (mode-2 XGMI hive reset; 8-GPU example in the
  message)
- `WARN_ONCE` taints and can panic with `panic_on_warn`
- GPU reset is a critical recovery path; false warnings hurt debugging
- 17-line, single-function, obviously correct
- No new APIs/features
- Reviewed by David Yat Sin; merged by Alex Deucher
- All helpers and the buggy function exist in this tree
- Standalone, no series dependency

AGAINST:
- Not a crash/corruption/deadlock on default configs
- No Fixes:/Reported-by/syzbot
- Functional skip was already correct; this mainly removes a false
  warning
- Affects multi-GPU KFD, not all kernel users

UNRESOLVED:
- lore.kernel.org 403; stable-list discussion not directly readable
- No public bugzilla/user-count

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — control-flow matches the
   described hive-reset case; reviewed and merged
2. Fixes a real bug that affects users? **PASS** — false `WARN_ONCE` on
   production multi-GPU reset
3. Important issue? **PASS** — WARN on GPU reset (taint; panic_on_warn);
   not a default oops, but this is the class of WARN_ON false positives
   that stable takes
4. Small and contained? **PASS** — one function, +8/−9
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — code is present; hunk is
   already the current text of `kfd_signal_reset_event()`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device-ID/quirk/DT/build/docs exception). Qualifies
as a normal small bugfix.

**Step 9.4: MAKE YOUR DECISION**
The local tree has the amdkfd reset-event path, the pdd/gpu_id lookups,
and the false-WARN behavior the patch corrects. The change is small,
correct, and prevents a kernel warning (and possible `panic_on_warn`
panic) during hive-wide GPU reset. That meets stable criteria for this
tree.

What the commit solves: `kfd_signal_reset_event()` walks every KFD
process for each resetting GPU. On XGMI mode-2 reset, processes that
only use a subset of GPUs produce NULL pdd / `-EINVAL` gpu_id. That was
warned as a driver bug; it is expected and should skip. The fix checks
pdd first and only WARNs if a bound process still has no user gpu_id.

Risk vs benefit: very low risk vs stopping a false warning on a GPU-
reset path used by AMD multi-GPU compute.

Verification:
- [Phase 1] Parsed tags: Reviewed-by David Yat Sin; SOB Amber Lin + Alex
  Deucher; no Fixes/Reported-by/Link/Cc-stable
- [Phase 1] Body: mode-2 reset on 8-GPU XGMI; lookup on unused GPUs
  should skip
- [Phase 2] Diff: +8/−9 in `kfd_signal_reset_event()`; silent continue
  on `!pdd`; WARN kept only after pdd exists
- [Phase 2] Confirmed `kfd_get_process_device_data()` returns NULL when
  `dev` not in `p->pdds[]`; `kfd_process_get_user_gpu_id()` returns
  `-EINVAL` in the same case (`kfd_process.c`)
- [Phase 3] Blame: gpu_id WARN from `bef153b70c6e35` (2021); pdd from
  `ee0a469cf9175a` (v6.12-rc1); pid WARN from `8544374c0f82ed` (2025)
- [Phase 3] No Fixes: tag; all introducing commits are ancestors of HEAD
- [Phase 3] Related `4693ade087f2e` is a different reset-signal bug in
  DQM, not a prerequisite
- [Phase 4] `b4 dig -c b38f9b6ffdfc86`:
  https://patch.msgid.link/20260728182609.672822-1-amber.lin@amd.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: amd-gfx, Yat Sin, Eric Huang
- [Phase 4] fd.o thread: review-only reply, no NAK, no Cc: stable
- [Phase 4] lore.kernel.org and lore stable: 403 — UNVERIFIED on lore
  itself
- [Phase 5] Callers: `kgd2kfd_pre_reset` + three DQM hang-reset sites
- [Phase 5] `kgd2kfd_pre_reset` signals every node — matches hive-reset
  description
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor b38f9b6ffdfc86 HEAD`: yes;
  buggy function present
- [Phase 8] Failure mode: WARN_ONCE → WARN (stack + taint; panic if
  panic_on_warn); signaling skip already correct
- UNVERIFIED: field incidence beyond the commit’s 8-GPU example; stable
  ML archives (403)

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_events.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index b033c3a9ce545..aac5bc4d13fdb 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -1287,6 +1287,8 @@ void kfd_signal_reset_event(struct kfd_node *dev)
 	struct kfd_event *ev;
 	unsigned int temp;
 	uint32_t id, idx;
+	int user_gpu_id;
+	struct kfd_process_device *pdd;
 	int reset_cause = atomic_read(&dev->sram_ecc_flag) ?
 			KFD_HW_EXCEPTION_ECC :
 			KFD_HW_EXCEPTION_GPU_HANG;
@@ -1302,17 +1304,14 @@ void kfd_signal_reset_event(struct kfd_node *dev)
 
 	idx = srcu_read_lock(&kfd_processes_srcu);
 	hash_for_each_rcu(kfd_processes_table, temp, p, kfd_processes) {
-		int user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id);
-		struct kfd_process_device *pdd = kfd_get_process_device_data(dev, p);
-
-		if (unlikely(user_gpu_id == -EINVAL)) {
-			WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%x\n", dev->id);
+		pdd = kfd_get_process_device_data(dev, p);
+		if (!pdd)
+			/* no process is using this device */
 			continue;
-		}
+		user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id);
 
-		if (unlikely(!pdd)) {
-			WARN_ONCE(1, "Could not get device data from process pid:%d\n",
-				  p->lead_thread->pid);
+		if (unlikely(user_gpu_id == -EINVAL)) {
+			WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%d\n", dev->id);
 			continue;
 		}
 
-- 
2.53.0

