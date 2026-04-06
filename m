Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE45334681;
	Mon,  6 Apr 2026 11:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775473559; cv=none; b=q0cRef/B/ctiKKVj/9SsINjv8yVhK7Dm0GCS2Bwji4WnAW8zkh+0gXp2TZhCl/WydY+O7NEjp+RH3HdcaBWcd6ECLnzVx3AKezHYPtZ3aufrt0rQPHtI2df/2AqrBiMebb9vP4E5xF3tVFxSR8+d8hgR5vUq8maLzTzdSlpK2yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775473559; c=relaxed/simple;
	bh=jWeUY2y70ibESK6vxa61BStZDdMuUDNZRSOnfa8Ra98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dAKynEhppZSareI9O6Amr1NMLsbAVGJi/pi1Lv0s29uudUefgcBtm/pFB5WEzsuZZG6r7up2TtpgY769XP31secU/zjuapSPAzdAhNGtyJ0NTCYCgSthqE5MFfSsApse8Pqm0/TgRG8bajBBKdlfCir6TlRlIGrsquX1tuSqm48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDSX8ZYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDSX8ZYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E82C19425;
	Mon,  6 Apr 2026 11:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775473559;
	bh=jWeUY2y70ibESK6vxa61BStZDdMuUDNZRSOnfa8Ra98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDSX8ZYTkh/NlJxxoGAd0cWMtzMGomo6b9LgNVmwu1mjYMTwy3jN1igt9EZHSX0Pe
	 nyUYkJgLG/jm++5bhOnPxBxKS7i0w79JbVBJtudVzDHyEh7HM+sqg4kxsSsIIzw3Fe
	 xn9sv32X9w1nvkWaRfS2BGv/lbL5tQZXgre8vkcZRUqdNmyFQUFDwkBzWUwIz3N1qi
	 rXCW33txp62kPI+QMWImMxKmF3qQkNW8rYypFHiBtn1+c0VwFz4IAVFb5piR9CwZGK
	 B7VFCsGCUxbvH5+hxgGKJcOUHqzm4DnK39PoYVvfnGrqLo2DNW7O4qSPhPjEMH8FRk
	 3nJWONlYUOjtw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Donet Tom <donettom@linux.ibm.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] drm/amdkfd: Fix queue preemption/eviction failures by aligning control stack size to GPU page size
Date: Mon,  6 Apr 2026 07:05:38 -0400
Message-ID: <20260406110553.3783076-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406110553.3783076-1-sashal@kernel.org>
References: <20260406110553.3783076-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.11
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 78746a474e92fc7aaed12219bec7c78ae1bd6156 ]

The control stack size is calculated based on the number of CUs and
waves, and is then aligned to PAGE_SIZE. When the resulting control
stack size is aligned to 64 KB, GPU hangs and queue preemption
failures are observed while running RCCL unit tests on systems with
more than two GPUs.

amdgpu 0048:0f:00.0: amdgpu: Queue preemption failed for queue with
doorbell_id: 80030008
amdgpu 0048:0f:00.0: amdgpu: Failed to evict process queues
amdgpu 0048:0f:00.0: amdgpu: GPU reset begin!. Source: 4
amdgpu 0048:0f:00.0: amdgpu: Queue preemption failed for queue with
doorbell_id: 80030008
amdgpu 0048:0f:00.0: amdgpu: Failed to evict process queues
amdgpu 0048:0f:00.0: amdgpu: Failed to restore process queues

This issue is observed on both 4 KB and 64 KB system page-size
configurations.

This patch fixes the issue by aligning the control stack size to
AMDGPU_GPU_PAGE_SIZE instead of PAGE_SIZE, so the control stack size
will not be 64 KB on systems with a 64 KB page size and queue
preemption works correctly.

Additionally, In the current code, wg_data_size is aligned to PAGE_SIZE,
which can waste memory if the system page size is large. In this patch,
wg_data_size is aligned to AMDGPU_GPU_PAGE_SIZE. The cwsr_size, calculated
from wg_data_size and the control stack size, is aligned to PAGE_SIZE.

Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a3e14436304392fbada359edd0f1d1659850c9b7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line Analysis
- **Subsystem**: drm/amdkfd (AMD KFD - Kernel Fusion Driver for GPU
  compute)
- **Action verb**: "Fix" - explicitly a bug fix
- **Summary**: Fixes GPU queue preemption/eviction failures by aligning
  control stack size to GPU page size instead of system page size

Record: [drm/amdkfd] [Fix] [Queue preemption/eviction failures from
incorrect alignment to CPU page size]

### Step 1.2: Tags
- **Reviewed-by**: Felix Kuehling <felix.kuehling@amd.com> (AMD KFD
  subsystem maintainer)
- **Signed-off-by**: Donet Tom <donettom@linux.ibm.com> (author, IBM)
- **Signed-off-by**: Alex Deucher <alexander.deucher@amd.com> (AMD GPU
  maintainer)
- **Cherry-picked from**: a3e14436304392fbada359edd0f1d1659850c9b7
- No Fixes: tag (expected for manual review candidates)
- No Cc: stable (expected)

Record: Reviewed by AMD KFD maintainer. Author is from IBM (Power
systems, which commonly use 64KB page sizes). Maintainer signoff from
Alex Deucher.

### Step 1.3: Commit Body Text
The commit describes a clear, reproducible bug:
- **Bug**: When control stack size aligns to 64 KB (on systems with
  PAGE_SIZE=64KB), GPU hangs and queue preemption failures occur
- **Symptom**: Real error messages included: "Queue preemption failed",
  "Failed to evict process queues", "GPU reset begin!"
- **Trigger**: Running RCCL unit tests on systems with more than two
  GPUs
- **Root cause**: Control stack size aligned to CPU PAGE_SIZE (which can
  be 64KB) instead of AMDGPU_GPU_PAGE_SIZE (always 4KB)
- **Affected configurations**: Both 4KB and 64KB system page-size
  configurations (but the bug only manifests on 64KB page systems)

Record: GPU hang, queue preemption failures, GPU resets. Clearly
documented with error messages. IBM Power10 with AMD Instinct GPUs is
the main platform affected.

### Step 1.4: Hidden Bug Fix Detection
This is not hidden - it is explicitly labeled as a fix with clear error
messages and reproduction scenario.

Record: Not a hidden fix; explicitly a bug fix with documented failure
mode.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory of Changes
- **Files changed**: 1 (drivers/gpu/drm/amd/amdkfd/kfd_queue.c)
- **Lines changed**: ~5 lines modified in one function
- **Functions modified**: `kfd_queue_ctx_save_restore_size()`
- **Scope**: Single-file surgical fix

Record: 1 file, ~5 lines, 1 function. Very small, very contained.

### Step 2.2: Code Flow Changes

**Hunk 1**: `wg_data_size` alignment changed from `PAGE_SIZE` to
`AMDGPU_GPU_PAGE_SIZE`
- Before: `ALIGN(..., PAGE_SIZE)` → on 64KB page systems, aligns to 64KB
- After: `ALIGN(..., AMDGPU_GPU_PAGE_SIZE)` → always aligns to 4KB (GPU
  page size)

**Hunk 2**: `ctl_stack_size` alignment changed from `PAGE_SIZE` to
`AMDGPU_GPU_PAGE_SIZE`
- Before: `ALIGN(..., PAGE_SIZE)` → on 64KB page systems, could produce
  64KB
- After: `ALIGN(..., AMDGPU_GPU_PAGE_SIZE)` → always aligns to 4KB

**Hunk 3**: `cwsr_size` now aligned to `PAGE_SIZE` for final system
memory allocation
- Before: `cwsr_size = ctl_stack_size + wg_data_size` (no final
  alignment)
- After: `cwsr_size = ALIGN(ctl_stack_size + wg_data_size, PAGE_SIZE)`
  (ensures system page alignment for memory allocation)

Record: Intermediate GPU-internal sizes align to GPU page (4KB), final
allocation size aligns to CPU page. This is the correct design pattern.

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix** - wrong alignment boundary causes
hardware-incompatible control stack sizes.

On 64KB page systems, the control stack was being padded to 64KB, which
is incompatible with the GPU hardware's expectations. The GPU hardware
operates with 4KB pages, so GPU-internal structures should be aligned to
GPU page boundaries (4KB), not CPU page boundaries.

Record: Logic/correctness bug. Wrong alignment boundary (CPU vs GPU page
size) causes GPU hardware to fail during queue preemption.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes. GPU internal structures should align to
  GPU page size, not CPU page size. The final allocation aligns to CPU
  page size for system memory.
- **Minimal/surgical**: Yes. Only 3 alignment changes in one function.
- **Regression risk**: Very low. On 4KB page systems (majority), this is
  a no-op since `AMDGPU_GPU_PAGE_SIZE == PAGE_SIZE == 4096`. The
  `ALIGN(cwsr_size, PAGE_SIZE)` addition only rounds up, never down.
- **Red flags**: None.

Record: Obviously correct, minimal, very low regression risk. No-op on
4KB page systems.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
The buggy code was introduced in commit `517fff221c1e6` ("drm/amdkfd:
Store queue cwsr area size to node properties") by Philip Yang, which
first appeared in v6.12.

Record: Buggy code introduced in v6.12 (commit 517fff221c1e6). Present
in stable trees v6.12.y and later.

### Step 3.2: Fixes Tag
No explicit Fixes: tag present. However, the buggy commit is clearly
`517fff221c1e6` which introduced this function with PAGE_SIZE alignment.

Record: No Fixes: tag, but root cause commit identified as 517fff221c1e6
(v6.12).

### Step 3.3: File History
Recent changes to kfd_queue.c include relaxing size checks, bumping vgpr
sizes, and GFX7/8 queue validation fixes. Several changes have occurred
since v6.12 (7 commits) that modified the function and surrounding code.

Record: 7 commits changed this file since v6.12. The function has had
some macro changes (WG_CONTEXT_DATA_SIZE_PER_CU now takes props
parameter). Minor backport adjustment may be needed.

### Step 3.4: Author's Commits
Donet Tom from IBM has authored related non-4K page size fixes:
- "Fix GART PTE for non-4K pagesize in svm_migrate_gart_map()"
- "Relax size checking during queue buffer get"
- Companion patch: "drm/amd: Fix MQD and control stack alignment for
  non-4K"

Record: Author is actively fixing non-4K page size issues in AMD GPU
drivers. Specialized domain knowledge from IBM Power platform.

### Step 3.5: Dependencies
The companion MQD alignment patch (`6caeace0d1471`) touches different
files (amdgpu_gart.c, amdgpu_ttm.c, kfd_mqd_manager_v9.c) and is NOT in
HEAD. It addresses a separate issue (memory type assignment for MQD vs
control stack on gfx9). The commit under review is self-contained - it
only changes size calculations.

On stable 6.12.y, the `WG_CONTEXT_DATA_SIZE_PER_CU` macro takes only
`(gfxv)` not `(gfxv, props)`. This means the patch will need a trivial
context adjustment for clean application to 6.12.y.

Record: Self-contained fix. Minor context adjustment needed for 6.12.y
due to macro signature difference. Companion MQD patch is independent.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Patch Discussion
The patch went through three RFC versions and a final PATCH v2:
- **Christian König** initially raised concerns about debugger CPU-side
  alignment, but later gave **Acked-by** after the fix was demonstrated
  to resolve GPU hangs
- **Felix Kuehling** gave formal **Reviewed-by** and stated "The series
  looks good to me"
- **Alex Deucher** confirmed inclusion for mainline
- No NAKs
- No explicit stable nomination found in discussion

Record: Positive review from two AMD maintainers. Initial concern from
König was addressed and resolved.

### Step 4.2: Bug Report
The bug was found during RCCL (AMD's collective communications library)
unit testing on Power10 systems with multiple AMD GPUs. Real error
messages in the commit show reproducible GPU hangs.

Record: Real, reproducible bug found in multi-GPU compute testing on IBM
Power systems.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
Modified function: `kfd_queue_ctx_save_restore_size()`

### Step 5.2: Callers
Called from `kfd_topology.c:2193` during topology device initialization.
This runs during GPU driver initialization for every AMD GPU, affecting
all KFD-capable AMD GPU users.

### Step 5.3-5.4: Call Chain
The computed values (`ctl_stack_size`, `cwsr_size`) are stored in node
properties and used during queue creation/validation in
`kfd_queue_acquire_buffers()`. This is a critical path for any GPU
compute workload.

Record: Called during GPU initialization. Values used for all compute
queue operations. High impact surface.

### Step 5.5: Similar Patterns
The companion MQD fix addresses the same root cause (CPU vs GPU page
alignment mismatch) in different code paths, confirming this is a
systematic issue for non-4K page systems.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
The function `kfd_queue_ctx_save_restore_size` was introduced in v6.12
(commit 517fff221c1e6). It exists in stable trees v6.12.y and later.

Record: Bug exists in v6.12.y, v6.13.y, v6.14.y stable trees.

### Step 6.2: Backport Complications
The `WG_CONTEXT_DATA_SIZE_PER_CU` macro signature changed (added `props`
parameter) since v6.12. The patch will need a trivial context adjustment
for 6.12.y (use `WG_CONTEXT_DATA_SIZE_PER_CU(gfxv)` instead of
`WG_CONTEXT_DATA_SIZE_PER_CU(gfxv, props)`).

Record: Minor context adjustment needed for 6.12.y. Should apply more
cleanly to 6.13.y+.

### Step 6.3: Related Fixes in Stable
No related fix for this specific issue found in stable trees.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: drm/amdkfd (GPU compute driver)
- **Criticality**: IMPORTANT - affects users of AMD GPUs for compute
  workloads (HPC, AI/ML, scientific computing)

### Step 7.2: Subsystem Activity
Very active subsystem with frequent commits (20+ in recent history on
kfd_queue.c alone).

Record: Active, important subsystem for GPU compute users.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Population
Systems with non-4K CPU page sizes using AMD GPUs for compute.
Primarily:
- IBM Power systems (ppc64le, 64KB page size) with AMD Instinct GPUs
- ARM64 systems with 64KB page configurations
- Any system where PAGE_SIZE > 4096

Record: Platform-specific but affects all GPU compute workloads on those
platforms.

### Step 8.2: Trigger Conditions
- Multi-GPU compute workloads (RCCL unit tests with >2 GPUs)
- Queue preemption/eviction (normal GPU scheduling operations)
- Trigger is common during real compute workloads

Record: Common trigger during normal GPU compute operations on affected
platforms.

### Step 8.3: Failure Mode Severity
- **GPU hang** → CRITICAL
- **Queue preemption failure** → CRITICAL (GPU becomes unusable)
- **GPU reset** → CRITICAL (interrupts all GPU work)
- **Failed to restore process queues** → Data loss for running GPU
  workloads

Record: CRITICAL severity - GPU hangs, forced resets, compute workload
failures.

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: HIGH - prevents GPU hangs and resets on non-4K page
  systems
- **Risk**: VERY LOW -
  - Only 3 alignment changes in one function
  - No-op on 4KB page systems (the majority)
  - Obviously correct - GPU internal structures should use GPU page
    alignment
  - Reviewed by AMD KFD maintainer

Record: HIGH benefit, VERY LOW risk. Excellent ratio.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Fixes GPU hangs and forced GPU resets (CRITICAL severity)
- Small, surgical fix (3 alignment changes in 1 function)
- Obviously correct (GPU structures align to GPU page size)
- Reviewed by AMD KFD maintainer (Felix Kuehling)
- Acked by Christian König after initial concerns resolved
- Real, reproducible bug with documented error messages
- Self-contained - no dependencies on other patches
- No-op on 4KB page systems - zero regression risk for majority of users

**AGAINST backporting:**
- No Fixes: tag or Cc: stable (expected for manual review candidates)
- Minor context adjustment needed for 6.12.y backport
- Affects only non-4K page size systems (smaller population)

**UNRESOLVED:**
- Exact impact on ARM64 with 64KB pages (only documented on Power10)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES - Reviewed by maintainer,
   tested on real hardware
2. **Fixes a real bug?** YES - GPU hangs, queue preemption failures, GPU
   resets
3. **Important issue?** YES - GPU hangs are CRITICAL
4. **Small and contained?** YES - 3 lines in 1 function
5. **No new features or APIs?** YES - pure bugfix
6. **Can apply to stable trees?** YES with minor context adjustment for
   6.12.y

### Step 9.3: Exception Categories
Not an exception category - this is a straightforward bug fix that
qualifies on its own merit.

### Step 9.4: Decision
The evidence overwhelmingly supports backporting. This is a small,
obviously correct fix for a CRITICAL GPU hang issue. The fix is self-
contained, reviewed by the subsystem maintainer, and carries effectively
zero regression risk for the majority of systems.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Felix Kuehling (AMD KFD
  maintainer), SOB from Alex Deucher (AMD GPU maintainer), author from
  IBM
- [Phase 2] Diff analysis: 3 alignment changes in
  kfd_queue_ctx_save_restore_size(): wg_data_size and ctl_stack_size
  changed from PAGE_SIZE to AMDGPU_GPU_PAGE_SIZE alignment, cwsr_size
  gets ALIGN(PAGE_SIZE)
- [Phase 2] Verified AMDGPU_GPU_PAGE_SIZE = 4096 (constant) defined in
  amdgpu_gart.h:35
- [Phase 3] git log: function introduced in commit 517fff221c1e6 ("Store
  queue cwsr area size to node properties"), first in v6.12
- [Phase 3] git merge-base: confirmed code is in v6.12 but NOT in v6.11
- [Phase 3] git diff v6.12..HEAD: confirmed 7 commits changed the file
  since v6.12, including macro signature change for
  WG_CONTEXT_DATA_SIZE_PER_CU
- [Phase 3] git log --author="Donet Tom": confirmed 2 other AMD non-4K
  page fixes
- [Phase 3] Confirmed companion MQD patch (6caeace0d) is NOT in HEAD and
  touches different files (independent)
- [Phase 4] Lore/mailing list research: patch went through RFC v1-v3 and
  PATCH v2, received Reviewed-by and Acked-by, no NAKs
- [Phase 5] Grep callers: kfd_queue_ctx_save_restore_size called from
  kfd_topology.c during device init
- [Phase 5] Grep cwsr_size: used in kfd_queue_acquire_buffers for queue
  validation and allocation
- [Phase 6] Confirmed buggy code exists in v6.12.y stable tree
- [Phase 6] Minor context adjustment needed for v6.12.y (macro signature
  difference)
- [Phase 8] Failure mode: GPU hang, forced GPU reset → CRITICAL severity
- [Phase 8] On 4KB page systems: AMDGPU_GPU_PAGE_SIZE == PAGE_SIZE ==
  4096, so fix is a no-op → zero regression risk

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_queue.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
index 2822c90bd7be4..b97f4a51db6e3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -444,10 +444,11 @@ void kfd_queue_ctx_save_restore_size(struct kfd_topology_device *dev)
 		    min(cu_num * 40, props->array_count / props->simd_arrays_per_engine * 512)
 		    : cu_num * 32;
 
-	wg_data_size = ALIGN(cu_num * WG_CONTEXT_DATA_SIZE_PER_CU(gfxv, props), PAGE_SIZE);
+	wg_data_size = ALIGN(cu_num * WG_CONTEXT_DATA_SIZE_PER_CU(gfxv, props),
+				AMDGPU_GPU_PAGE_SIZE);
 	ctl_stack_size = wave_num * CNTL_STACK_BYTES_PER_WAVE(gfxv) + 8;
 	ctl_stack_size = ALIGN(SIZEOF_HSA_USER_CONTEXT_SAVE_AREA_HEADER + ctl_stack_size,
-			       PAGE_SIZE);
+			       AMDGPU_GPU_PAGE_SIZE);
 
 	if ((gfxv / 10000 * 10000) == 100000) {
 		/* HW design limits control stack size to 0x7000.
@@ -459,7 +460,7 @@ void kfd_queue_ctx_save_restore_size(struct kfd_topology_device *dev)
 
 	props->ctl_stack_size = ctl_stack_size;
 	props->debug_memory_size = ALIGN(wave_num * DEBUGGER_BYTES_PER_WAVE, DEBUGGER_BYTES_ALIGN);
-	props->cwsr_size = ctl_stack_size + wg_data_size;
+	props->cwsr_size = ALIGN(ctl_stack_size + wg_data_size, PAGE_SIZE);
 
 	if (gfxv == 80002)	/* GFX_VERSION_TONGA */
 		props->eop_buffer_size = 0x8000;
-- 
2.53.0

