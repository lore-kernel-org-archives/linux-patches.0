Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FEE61455B;
	Mon, 19 Oct 2026 14:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418643; cv=none; b=CtiWplwfRPZLmDaHKZ02iu0xaHPTCcGZZK+Wq9RuZeq+i1etGH0FGTzR56eYep6ftNlu6hzUe02xQwubfxxkTivqqmvyfnlEUQ5CkOa+EWSVMT8mrifWjQiq3iDEaEOB9EnsKQiVEq0XAqhz9VKqaXyawW2YVN667uB5Q/JxnwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418643; c=relaxed/simple;
	bh=bU8nbisqP7aBrR+U/CPiOVc6eRpOHVetyvDDtp0LIWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iBg/6Ui2IIRxyejnSATdMJDZLxp9jE9YyVoBYsGVRLGeyjzOkCOSxoTx17UoUdv/ukESrXgawLJ23wiD51EVIeEuiLOWFYQdGTV3OpQY57drQoqtTal+RFyvDHFOVMlNmmuvp/qUXs1jc4tfmppM94qcmU5Fru+2gC7F1c2QBTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d0VeMBmB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0VeMBmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D801F000C4;
	Mon, 19 Oct 2026 14:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418641;
	bh=JoR/Uw8DzaN62uBMS7uJe8B2wMvAo7Agf/4iuypCCEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0VeMBmBzLKV6JroB4rApuQ00gFjBd5SA2svZoOckNIGYahij/qhcC9Rk7ngorVJ8
	 TatH1Hvb6Q/uVf5kccKsCm4orhm6Pu0mZ9UFtpE+MI5eQxjtuR1x29C//qvKycDhfG
	 QIRNSbL+Ssyo4sZ8PEV4EhUQIw7FEicLPYR6WY9ms2BZrnQL2qqiIvljWpwU06QQ+S
	 LkQT38x6F0FKpD9TeJJOQ8v9csGeoPJdBj6O8WqAkpRkeKsv9FvLk0YW4Tt7xJhSBJ
	 b+Tir4KujZjXHbOhag6660nwY/nsXpJGT+QGlsJERN6jGNr7VezN2FTtKiZLL+Kt15
	 jINm8yfaYMP5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yongqiang Sun <Yongqiang.Sun@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdkfd: use node XCC count for v9 CRIU control stack restore
Date: Mon, 19 Oct 2026 09:51:24 -0400
Message-ID: <20261019135441.1420968-393-sashal@kernel.org>
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

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 1a0aa3c4cb207fcbf7ebd2d9ed9f1cfb4560bd2c ]

set_queue_properties_from_criu() divided the checkpointed control stack
size by NUM_XCC(adev->gfx.xcc_mask) (whole GPU), while the checkpoint
size was recorded, the MQD buffer allocated, and the control stack
restored using the per-node mask NUM_XCC(mm->dev->xcc_mask). On spatially
partitioned GFX9.4.3 (CPX/QPX) these differ, so the per-XCC control stack
size used for the restore memcpy could exceed the region sized for the
MQD allocation, writing past the BO into adjacent kernel memory; it also
broke legitimate restore on partitioned parts.

Divide by the per-node XCC count so allocation and copy agree,
leaving kfd_queue_acquire_buffers() to bound the size against
the node's advertised control stack size.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Reviewed-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`Makefile` `VERSION=6 PATCHLEVEL=18
SUBLEVEL=53`, `git describe` `v6.18.53-5049-g0f0bdc2b0dffb`, branch
`autosel`). The verdict is only for this 6.18.y checkout.

Upstream `1a0aa3c4cb20` is not an ancestor of `v6.18.53`. The buggy line
is present at `v6.18.53`.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[drm/amdkfd] [use] [use node XCC count for v9 CRIU control
stack restore]**
- Subsystem: `drm/amdkfd` (AMD KFD compute)
- Verb: “use” — here it is a correctness fix (wrong XCC divisor), not a
  feature

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- No `Fixes:` tag (expected)
- No `Reported-by:`, `Tested-by:`, `Link:`, `Cc: stable`
- `Reviewed-by: David Francis <David.Francis@amd.com>`
- `Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>` (author)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- Pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  1a0aa3c4cb20...]` ignored per instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** CRIU restore divides checkpointed control-stack size by
  whole-GPU `NUM_XCC(adev->gfx.xcc_mask)`, while checkpoint, MQD
  allocation, and restore memcpy use per-node
  `NUM_XCC(mm->dev->xcc_mask)`.
- **Symptom:** On spatially partitioned GFX9.4.3 (CPX/QPX) the two
  counts differ. Restore memcpy can write past the MQD BO into adjacent
  kernel memory; legitimate restore on a partition also fails.
- **Root cause:** Wrong XCC divisor in
  `set_queue_properties_from_criu()`.
- **Fix:** Divide by per-node `NUM_XCC(pdd->dev->xcc_mask)`;
  `kfd_queue_acquire_buffers()` still checks against the node’s
  advertised control-stack size.
- No version range in the message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit buffer-overrun + broken restore. Not
cleanup/refactor.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c` (`1`
  insertion, `1` deletion)
- Function: `kfd_criu_restore_queue()`
- Scope: single-file, one-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `set_queue_properties_from_criu(&qp, q_data,
  NUM_XCC(pdd->dev->adev->gfx.xcc_mask));` → `qp.ctl_stack_size =
  q_data->ctl_stack_size / whole_GPU_xcc`
- **After:** `NUM_XCC(pdd->dev->xcc_mask)` → divide by this node’s XCC
  count
- Path: CRIU queue restore (`AMDKFD_IOC_CRIU_OP`), compute queues only
  (`KFD_QUEUE_TYPE_COMPUTE` in `set_queue_properties_from_criu`)

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Buffer overflow / OOB kernel write] + [logic/correctness]**

Verified chain:
1. Checkpoint (`get_checkpoint_info` in `kfd_mqd_manager_v9.c`):
   `*ctl_stack_size = m->cp_hqd_cntl_stack_size *
   NUM_XCC(mm->dev->xcc_mask)` (node).
2. `allocate_mqd()` sizes the GTT BO from `q->ctl_stack_size` (the
   divided per-XCC value) × `NUM_XCC(node->xcc_mask)`.
3. `create_queue_nocpsch` / `create_queue_cpsch` pass
   **`qd->ctl_stack_size`** (full user/checkpoint size) into
   `restore_mqd()`.
4. `restore_mqd_v9_4_3()` copies `ctl_stack_size /
   NUM_XCC(mm->dev->xcc_mask)` bytes per XCC with unbounded `memcpy` in
   `restore_mqd()` to `*mqd + PAGE_SIZE`.

On CPX/QPX, GPU XCC count > node XCC count. A crafted
`q_data->ctl_stack_size = node_props.ctl_stack_size * GPU_xcc` makes
`qp.ctl_stack_size` pass `kfd_queue_acquire_buffers()`’s equality check,
then restore copies `GPU_xcc/NODE_xcc` times too much → write past the
BO.

A legitimate checkpoint (`ctl_stack_size = per_xcc * NODE_xcc`) yields a
too-small `qp.ctl_stack_size`, so acquire_buffers returns `-EINVAL` and
restore is broken.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct: same `NUM_XCC(dev->xcc_mask)` as
checkpoint/allocate/restore. Minimal. No API/locking change. Regression
risk very low (only partitioned restore, which is currently wrong).
`pdd->dev->xcc_mask` exists on `struct kfd_node` in this tree.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: At `v6.18.53`, line 1065 was introduced by **`f6c0f3d24478a`**
(`drm/amdkfd: Fix checkpoint-restore on multi-xcc`, David Yat Sin,
2025-07-16). That commit added the `num_xcc` argument and used
**`adev->gfx.xcc_mask`**. It is an ancestor of `v6.18.53` and was itself
`Cc: stable@vger.kernel.org` (cherry-pick of `a578f2a58c3a`).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The introducing commit is `f6c0f3d24478a`,
present in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (file-limited `git log`):
- `c6c290e408fe3` `drm/amdkfd: Properly acquire queue buffers in CRIU
  restore` — **in v6.18.53**; this patch depends on that bound
- `fd1691ec62701` bounds on CRIU queue type/mqd size — already here
- `f6c0f3d24478a` multi-xcc CRIU — introduced the bug
- Later clamp/bound CRIU patches from the same author are **not** in
  this tree; they are extra hardening, not prerequisites

Standalone given acquire_buffers is already here.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Yongqiang Sun has other amdkfd CRIU/safety work. Not the
subsystem maintainer. Review is from David Francis; merge SOB from Alex
Deucher.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `set_queue_properties_from_criu(..., num_xcc)`
(`f6c0f3d24478a`) and `kfd_queue_acquire_buffers()` (`c6c290e408fe3`).
Both are in `v6.18.53`. `pdd->dev->xcc_mask` exists. Applies standalone
on this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 1a0aa3c4cb20` failed: lore.kernel.org returned server
  errors (UNVERIFIED via b4)
- Thread found on amd-gfx: https://ratatoskr.run/amd-
  gfx/2026/06/17177385 (2026-06-25)
- Single-patch submission, not v2/v3
- Same one-line diff as committed

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: David Francis: “Nice catch” + `Reviewed-by`. No NAK. Alex
Deucher SOB on the commit. Recipients: amd-gfx; maintainers listed
include Felix Kuehling, Alex Deucher.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Author-found mismatch. Same month as related
CRIU bound/clamp patches.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Same author, June 2026 amd-gfx:
- `clamp v9 CRIU control stack checkpoint copy to BO size`
- `bound v9 CRIU control stack restore to allocated MQD region`
- this divisor fix

Complementary, not a numbered series. drm-next 7.3 pull listed this
under CRIU fixes. This line does not need the clamp/bound patches to be
correct.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned **403**. No stable-list
discussion verified. No evidence it was rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `kfd_criu_restore_queue()` (call site);
`set_queue_properties_from_criu()` (consumer of `num_xcc`); downstream
`kfd_queue_acquire_buffers`, `pqm_create_queue` → `restore_mqd` /
`restore_mqd_v9_4_3`.

**Step 5.2: TRACE CALLERS**
Record:
- `kfd_criu_restore_queue` ← `criu_restore_objects()` ← `kfd_ioctl_criu`
  via `AMDKFD_IOC_CRIU_OP`
- Ioctl flag `KFD_IOC_FLAG_CHECKPOINT_RESTORE`: `CAP_CHECKPOINT_RESTORE`
  or `CAP_SYS_ADMIN`
- Userspace-reachable, privileged

**Step 5.3: TRACE CALLEES**
Record: `set_queue_properties_from_criu` → `kfd_queue_acquire_buffers`
(must match `node_props.ctl_stack_size`) → `pqm_create_queue` →
`allocate_mqd` + `restore_mqd(..., qd->ctl_stack_size)`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Privileged CRIU restore ioctl → kernel memcpy into MQD GTT.
Triggered by GPU container checkpoint/restore on partitioned GFX9.4.3
(MI300 family). Unprivileged users cannot call it.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Rest of KFD uses `dev->xcc_mask` / `mm->dev->xcc_mask`. This
restore call was the odd `adev->gfx.xcc_mask` user in this path.
`kfd_device.c` sets `node->xcc_mask` from XCP when partitioned, else
from whole-GPU mask — they only differ with spatial partitions.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `v6.18.53:kfd_process_queue_manager.c:1065`:
`set_queue_properties_from_criu(&qp, q_data,
NUM_XCC(pdd->dev->adev->gfx.xcc_mask));`
Introduced `f6c0f3d24478a` (2025-07-16), present in 6.18.y.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Surrounding function at 6.18.53 matches the hunk
(`kfd_queue_acquire_buffers` already there). `pdd->dev->xcc_mask` is in
`kfd_priv.h:279` at 6.18.53.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: acquire_buffers bound is already in 6.18.53. Clamp/bound memcpy
patches are not; they are extra, not a substitute. No other fix of this
divisor mismatch.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **amdkfd (AMD GPU compute)** — **IMPORTANT** for ROCm/HPC, not
core mm/VFS. CRIU restore is a real production path for GPU containers.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (many recent CRIU bound-check fixes). This is a follow-on
to the multi-xcc CRIU work already in stable.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver/config-specific: `CONFIG_HSA_AMD` + KFD CRIU restore +
GFX9.4.3 spatial partition (CPX/QPX). MI300-class HPC/AI systems.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Legitimate: CRIU restore of a compute queue on a partitioned node →
  restore fails (`-EINVAL` from acquire_buffers)
- Malicious/crafted checkpoint: size chosen so the wrong divisor equals
  `node_props.ctl_stack_size` → OOB `memcpy`
- Requires `CAP_CHECKPOINT_RESTORE` or `CAP_SYS_ADMIN`
- Unprivileged users cannot trigger it

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- OOB write past MQD BO into adjacent kernel (TTM/GTT) memory → **HIGH**
  (corruption/crash; privileged)
- Broken legitimate CRIU restore on partitioned parts → **HIGH** for
  those users (functional failure, not a panic on the happy path)

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Fixes kernel OOB write and restores CRIU on partitioned
  GFX9.4.3; the buggy multi-xcc CRIU code is already in this stable tree
- **Risk:** Very low (one identifier change, same pattern as the rest of
  KFD)
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real bug: wrong XCC divisor vs checkpoint/allocate/restore
- Kernel memory overwrite via unbounded `memcpy` in `restore_mqd()`
- Broken CRIU restore on CPX/QPX GFX9.4.3
- Introducing commit already in 6.18.y and was `Cc: stable`
- 1-line, obviously correct, reviewed by David Francis, SOB Alex Deucher
- Prerequisites (`f6c0f3d24478a`, `kfd_queue_acquire_buffers`) present
- Applies cleanly

AGAINST:
- Privileged ioctl only
- Only partitioned multi-XCC GFX9.4.3 + CRIU
- No syzbot / no `Fixes:` / no explicit stable Cc on this commit
- Complementary clamp/bound patches not in this tree (hardening, not
  required)

UNRESOLVED:
- `b4 dig` / lore.kernel.org stable search failed (server 403/error)
- No public reproducer beyond code inspection (commit describes the
  mechanism)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 1-line mask fix; Reviewed-by
   + maintainer SOB
2. Fixes a real bug that affects users? **PASS** — partitioned CRIU
   restore wrong; OOB on crafted size
3. Important issue? **PASS** — kernel OOB write + failed restore (HIGH,
   privileged)
4. Small and contained? **PASS** — 1 line, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy line and
   `dev->xcc_mask` exist at 6.18.53

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not an ID/quirk/DT/build/docs exception. Ordinary important
bugfix.

**Step 9.4: MAKE YOUR DECISION**
This belongs on 6.18.y. The bug is in this tree because multi-xcc CRIU
was already backported with the wrong divisor. The fix is minimal and
matches every other XCC user in the restore path.

---

### What the commit solves for stable users
On 6.18.53, KFD CRIU restore still divides by the whole-GPU XCC mask.
Checkpoint, MQD BO size, and `restore_mqd_v9_4_3()` use the **node**
mask. On GFX9.4.3 CPX/QPX those differ, so restore either fails or (with
a crafted privileged checkpoint) `memcpy`s past the MQD BO into kernel
GTT. Switching to `pdd->dev->xcc_mask` makes allocation and copy agree;
acquire_buffers already pins the per-XCC size to the node’s advertised
control-stack size.

### Risk vs benefit
Benefit is high for MI300 CRIU/partition users and closes an OOB write.
Risk is a one-token change with no locking/API impact.

### Concerns
Clamp/bound memcpy patches are not required for this to be correct. CRIU
is privileged, which lowers exploitability but does not make the
overflow or the broken restore acceptable on stable.

---

Verification:
- [Phase 1] Tags: Reviewed-by David Francis; SOB Yongqiang Sun, Alex
  Deucher; no Fixes/Reported-by/Cc:stable
- [Phase 1] Body: OOB write past MQD BO + broken partitioned restore;
  wrong GPU vs node XCC divisor
- [Phase 2] Diff: 1 line in `kfd_criu_restore_queue()`:
  `adev->gfx.xcc_mask` → `dev->xcc_mask`
- [Phase 2] `allocate_mqd` uses `q->ctl_stack_size *
  NUM_XCC(node->xcc_mask)`; `restore_mqd` uses `qd->ctl_stack_size`;
  `restore_mqd_v9_4_3` divides by `mm->dev->xcc_mask`; memcpy unbounded
- [Phase 2] `kfd_queue_acquire_buffers` requires `ctl_stack_size ==
  node_props.ctl_stack_size` (present at 6.18.53)
- [Phase 3] Blame at v6.18.53: `f6c0f3d24478a` introduced
  `NUM_XCC(pdd->dev->adev->gfx.xcc_mask)`; `Cc: stable`; ancestor of
  v6.18.53
- [Phase 3] `git merge-base --is-ancestor 1a0aa3c4cb20 v6.18.53` → not
  present; buggy code is present
- [Phase 3] Prerequisites `f6c0f3d24478a` and `c6c290e408fe3` are in
  v6.18.53
- [Phase 4] b4 dig: lore server error — UNVERIFIED via b4
- [Phase 4] amd-gfx thread 2026-06-25; David Francis “Nice catch” +
  Reviewed-by; no NAK
- [Phase 4] lore.kernel.org/stable: 403 — UNVERIFIED
- [Phase 5] Caller: `AMDKFD_IOC_CRIU_OP` with CAP_CHECKPOINT_RESTORE or
  CAP_SYS_ADMIN
- [Phase 5] `kfd_device.c`: `node->xcc_mask` from XCP vs
  `adev->gfx.xcc_mask` when unpartitioned
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.18.53; line
  1065 at v6.18.53 is the buggy call; `kfd_node.xcc_mask` exists
- [Phase 6] Clean apply: surrounding code at v6.18.53 matches the hunk
- [Phase 8] Failure: kernel OOB write (HIGH) + CRIU restore failure on
  CPX/QPX; privileged trigger
- UNVERIFIED: b4/lore.kernel.org availability; no runtime reproducer
  executed

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 912c4ebd30405..99a47f2a45e7a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -1062,7 +1062,7 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 	ctl_stack = mqd + q_data->mqd_size;
 
 	memset(&qp, 0, sizeof(qp));
-	set_queue_properties_from_criu(&qp, q_data, NUM_XCC(pdd->dev->adev->gfx.xcc_mask));
+	set_queue_properties_from_criu(&qp, q_data, NUM_XCC(pdd->dev->xcc_mask));
 
 	ret = kfd_queue_acquire_buffers(pdd, &qp);
 	if (ret) {
-- 
2.53.0

