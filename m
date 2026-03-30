Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EC63D2FE0;
	Mon, 30 Mar 2026 12:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874339; cv=none; b=Nw68tA4pNe+TH5lj5OX5Qd5VsdgfN3pMi+2+uUL/SknWYrVvVY7CTP5h5eCNKQCIIZKxlDgvsJ8vRq9XuI1/lLMH0Z61ykG07oH10t0qYgLi5Z1R6cK8JUJVvSV+BMjUkeeU0SB85rENZ4Dc+EXbDikmF7uJhn/f57uIV5uHr+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874339; c=relaxed/simple;
	bh=tESJMBX27oDt5eJWNgWE3wG/L/mnZJEOjFSFMeL4a98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sl8w7pvHJTyOEjo6AuYMWPCo1lkFcmc+G6FN5CioJbm7q6M0cpUBhsfBofVJcrMAuxYbWmzGiFUpxDaVrfKtqvSmFfI/H9lm2t3I+yO4yQNI6FILw3AA156aml9FPLWVYfVva3KIEXv4pIvAJkfGD44hpS+kHpeWoR7hfV+6gA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z7AzdZfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z7AzdZfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1524C2BCB1;
	Mon, 30 Mar 2026 12:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874338;
	bh=tESJMBX27oDt5eJWNgWE3wG/L/mnZJEOjFSFMeL4a98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7AzdZfuQmDknOzoc4x1z6C3t6dWPdWV4BgGSEnF7kXZBcB8pCuqKjuw8WarYXK19
	 OJUKYmQHTxrpaUURWYuW1VQ5duoqD9urK847adXfti5F+x5bM2hNfhUTJ9XQI6/Jcp
	 jgR512qMN1PRISgl4UQkOuFnFCAr3awLqsRfO7rVeAMffeGs7244BgSZYQitI6HhFh
	 lnebSu2036NBmix2BEIxuehrkqv05Cdr9tueAzWssLk0s/LaWIFBKb0AHytscX/YKC
	 wShFzdbWk6h+lKTHBcN56tcyTm42Ql9CT4pGMEMH3Dm27f8XDYW+b/tjjIXjFR1hB9
	 2G1hx0edkb3Hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Donet Tom <donettom@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amdgpu: Handle GPU page faults correctly on non-4K page systems
Date: Mon, 30 Mar 2026 08:38:24 -0400
Message-ID: <20260330123842.756154-11-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Transfer-Encoding: 8bit

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 4e9597f22a3cb8600c72fc266eaac57981d834c8 ]

During a GPU page fault, the driver restores the SVM range and then maps it
into the GPU page tables. The current implementation passes a GPU-page-size
(4K-based) PFN to svm_range_restore_pages() to restore the range.

SVM ranges are tracked using system-page-size PFNs. On systems where the
system page size is larger than 4K, using GPU-page-size PFNs to restore the
range causes two problems:

Range lookup fails:
Because the restore function receives PFNs in GPU (4K) units, the SVM
range lookup does not find the existing range. This will result in a
duplicate SVM range being created.

VMA lookup failure:
The restore function also tries to locate the VMA for the faulting address.
It converts the GPU-page-size PFN into an address using the system page
size, which results in an incorrect address on non-4K page-size systems.
As a result, the VMA lookup fails with the message: "address 0xxxx VMA is
removed".

This patch passes the system-page-size PFN to svm_range_restore_pages() so
that the SVM range is restored correctly on non-4K page systems.

Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 074fe395fb13247b057f60004c7ebcca9f38ef46)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

All key facts verified. Here is the complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [drm/amdgpu] [Handle correctly] [Fix PFN unit conversion for SVM
range restore on non-4K page systems]

**Step 1.2: Tags**
- Acked-by: Christian König (verified AMDGPU co-maintainer via
  MAINTAINERS)
- Signed-off-by: Donet Tom <donettom@linux.ibm.com> (author, IBM — Power
  systems with 64K pages)
- Signed-off-by: Alex Deucher (verified AMDGPU co-maintainer via
  MAINTAINERS)
- Cherry-picked from: 074fe395fb13247b057f60004c7ebcca9f38ef46 (pipeline
  marker, ignored)
- No Fixes:, Reported-by:, Link:, Cc: stable, Tested-by: tags (expected
  for candidates)

Record: [Acked-by from subsystem co-maintainer; author from IBM; merged
by subsystem co-maintainer. No reporter or explicit stable nomination.]

**Step 1.3: Commit Body**
Two concrete bugs described:
1. **SVM Range lookup failure**: `svm_range_restore_pages()` receives
   PFNs in GPU (4K) units, but the SVM interval tree is indexed by
   system-page PFNs. On non-4K systems, the lookup fails and a
   **duplicate SVM range** is created.
2. **VMA lookup failure**: The restore function does `vma_lookup(mm,
   addr << PAGE_SHIFT)`, which reconstructs the byte address from a
   system-page PFN. When given a GPU-page PFN instead, the computed
   address is wrong, producing `"address 0xxxx VMA is removed"`.

Record: [Bug: wrong PFN unit passed to SVM restore] [Symptoms: duplicate
SVM range + false VMA removal] [Root cause: addr /= AMDGPU_GPU_PAGE_SIZE
gives GPU-page PFN where system-page PFN is expected] [No version info
in message]

**Step 1.4: Hidden Bug Fix Detection**
Record: [Explicit bug fix — "Handle ... correctly" is standard bug-fix
language with concrete failure modes described]

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: [1 file: `amdgpu_vm.c`, ~3 logical lines changed] [Function:
`amdgpu_vm_handle_fault()`] [Scope: single-file, single-function
surgical fix]

**Step 2.2: Code Flow Change**

Before:

```2976:2982:drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
        addr /= AMDGPU_GPU_PAGE_SIZE;

        if (is_compute_context && !svm_range_restore_pages(adev, pasid,
vmid,
            node_id, addr, ts, write_fault)) {
                amdgpu_bo_unref(&root);
                return true;
        }
```

After (from the diff): `addr >> PAGE_SHIFT` is passed to
`svm_range_restore_pages()`, and `addr /= AMDGPU_GPU_PAGE_SIZE` is moved
to after the SVM call for the GPU page-table update path.

Record: [Before: one conversion (GPU-page PFN) was reused for both SVM
restore and GPU PTE update. After: SVM restore gets system-page PFN; GPU
PTE path still gets GPU-page PFN.]

**Step 2.3: Bug Mechanism**
Category: Logic/correctness — address unit mismatch.

Verified from `kfd_svm.c`:
- `svm_range_from_addr()` documentation says `@addr: address to search
  range interval tree, in pages` (system pages)
- `vma_lookup(mm, addr << PAGE_SHIFT)` at line 3136 converts back to
  byte address using system page shift

`AMDGPU_GPU_PAGE_SIZE` is confirmed as `4096` in `amdgpu_gart.h:35`.

On 4K systems: `addr >> PAGE_SHIFT == addr / 4096` — identical, bug
invisible.
On 64K systems: `addr / 4096` gives a value 16x too large compared to
`addr >> 16`.

Record: [Logic/correctness bug. GPU-page PFN vs system-page PFN mismatch
breaks SVM range and VMA lookups on non-4K systems.]

**Step 2.4: Fix Quality**
Record: [Obviously correct — callee contract verified in code. Minimal —
~3 lines. No regression risk on 4K systems (mathematically identical).
Very low risk overall.]

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Verified via `git blame`: The buggy `addr /= AMDGPU_GPU_PAGE_SIZE`
before the SVM call was introduced by `ea53af8a59c89b` ("drm/amdkfd: SVM
API call to restore page tables") by Alex Sierra (2020-05-11). First
appeared in `v5.14-rc1`.

Record: [Buggy code introduced in ea53af8a59c89b, first in v5.14-rc1.
Present in all stable trees 5.15+.]

**Step 3.2: Fixes Tag**
Record: [No Fixes: tag — expected for candidates under review.]

**Step 3.3: File History**
Verified via `git log -20`: Recent `amdgpu_vm.c` changes are TLB/VM
maintenance and unrelated. No conflicting fix for this PFN issue exists.

Record: [No related prior fix found. Standalone change.]

**Step 3.4: Author**
Donet Tom (IBM) has 2 AMD-tree commits in local history, including
`daea2e81c1804` ("drm/amdkfd: Fix GART PTE for non-4K pagesize in
svm_migrate_gart_map()") — a closely related non-4K fix. Acked by
Christian König and merged by Alex Deucher, both confirmed as listed
AMDGPU maintainers in `MAINTAINERS`.

Record: [Author is domain expert for non-4K page issues. Fix endorsed by
both subsystem maintainers.]

**Step 3.5: Dependencies**
Record: [No dependencies. Only reorders unit conversions within one
function. Standalone fix.]

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.4**: Lore.kernel.org was inaccessible due to Anubis bot
protection. The commit has strong maintainer endorsement (Acked-by +
Signed-off-by from both AMDGPU co-maintainers). The related patch series
context (non-4K page support for AMDGPU on Power10/MI210 platforms) is
documented in public archives.

Record: [Lore inaccessible. Maintainer ack and signoff confirmed from
tags. UNVERIFIED: detailed reply-thread discussion on lore.]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
Record: [`amdgpu_vm_handle_fault()`]

**Step 5.2: Callers**
Verified callers in: `gmc_v9_0.c`, `gmc_v10_0.c`, `gmc_v11_0.c`,
`gmc_v12_0.c` — GPU page fault interrupt handlers for all AMD GPU
generations 9+.

Confirmed in `gmc_v10_0.c:114`: `addr = (u64)entry->src_data[0] << 12` —
the fault address is constructed as a **byte address** from hardware
interrupt data.

Record: [Called from GPU page fault interrupt handlers. addr is byte
address from hardware.]

**Step 5.3: Callees**
`svm_range_restore_pages()` (verified at `kfd_svm.c:3000`) calls:
- `svm_range_from_addr()` — interval tree lookup using system-page PFN
- `vma_lookup(mm, addr << PAGE_SHIFT)` at line 3136 — reconstructs byte
  address from system-page PFN

Record: [Both callees confirmed to expect system-page PFNs.]

**Step 5.4: Call Chain**
GPU fault interrupt → `gmc_v*_process_interrupt()` →
`amdgpu_vm_handle_fault()` → `svm_range_restore_pages()`. Triggered by
any GPU memory access fault in compute contexts (ROCm/HSA workloads).

Record: [Reachable from normal GPU compute workloads. Not theoretical —
triggered by SVM retry faults.]

**Step 5.5: Similar Patterns**
Record: [Related non-4K fix exists: `daea2e81c1804` by the same author.
No duplicate of this exact wrong-unit call found.]

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Bug Existence in Stable Trees**
Verified the identical bug pattern (`addr /= AMDGPU_GPU_PAGE_SIZE`
before `svm_range_restore_pages()`) exists in:
- **v5.15**: line 3376 (`svm_range_restore_pages(adev, pasid, addr,
  write_fault)`)
- **v6.1**: line 2476 (same pattern, 4-param signature)
- **v6.6**: line 2574 (`svm_range_restore_pages(adev, pasid, vmid,
  node_id, addr, write_fault)`)

Record: [Bug confirmed in v5.15, v6.1, v6.6 stable trees. All share the
same `addr /= AMDGPU_GPU_PAGE_SIZE` before SVM call.]

**Step 6.2: Backport Complications**
Function signatures differ across versions:
- v5.15/v6.1: `svm_range_restore_pages(adev, pasid, addr, write_fault)`
  — 4 params
- v6.6: `svm_range_restore_pages(adev, pasid, vmid, node_id, addr,
  write_fault)` — 6 params
- v6.12+: `svm_range_restore_pages(adev, pasid, vmid, node_id, addr, ts,
  write_fault)` — 7 params

The core fix (move `addr /= AMDGPU_GPU_PAGE_SIZE` after SVM call, pass
`addr >> PAGE_SHIFT`) applies identically, but the SVM call arguments
differ.

Record: [Clean apply on v6.12+. Minor trivial context adaptation needed
for v6.6 and v5.15/v6.1. Fix concept is identical across all versions.]

**Step 6.3: Related Fixes in Stable**
Record: [No alternative fix for this specific issue found in any stable
tree.]

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
Record: [`drivers/gpu/drm/amd/amdgpu` — AMD GPU VM fault handling / KFD
SVM. Criticality: IMPORTANT (common GPU driver, compute/AI workloads)]

**Step 7.2: Activity**
Record: [Highly active subsystem with 20+ recent commits.]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Users of AMD GPUs on systems with non-4K page sizes:
- Power (ppc64le) with 64K pages — common in HPC/AI (IBM systems with
  AMD Instinct GPUs)
- ARM64 systems configured with 16K or 64K pages
- Not x86_64 (always 4K pages)

Record: [Platform-specific: Power and ARM64 with non-4K pages using
AMDGPU compute (SVM/XNACK)]

**Step 8.2: Trigger Conditions**
Any GPU page fault during compute (ROCm/KFD) workloads on non-4K page
systems.

Record: [Triggered during normal GPU compute workloads on affected
platforms. Common for those users.]

**Step 8.3: Failure Mode Severity**
- SVM range lookup fails → duplicate range created (memory
  corruption/inconsistency in GPU VM state)
- VMA lookup fails → fault recovery does not happen, workload broken
  with "VMA is removed" error
- This is functional breakage: GPU compute workloads are broken on
  affected platforms

Record: [Severity: HIGH — GPU compute fault recovery is broken on non-4K
page systems, leading to functional failure]

**Step 8.4: Risk-Benefit Ratio**
- **Benefit**: HIGH for affected platforms — fixes completely broken SVM
  fault recovery
- **Risk**: VERY LOW — ~3 lines, no behavior change on 4K systems
  (mathematically identical), obviously correct unit conversion
- **Ratio**: Extremely favorable

Record: [Benefit: HIGH. Risk: VERY LOW. Extremely favorable.]

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Verified wrong-unit bug in code: `svm_range_from_addr` expects system-
  page PFN ("in pages" in documentation), `vma_lookup(mm, addr <<
  PAGE_SHIFT)` expects system-page PFN
- Callers pass byte addresses from hardware; fix correctly separates
  system-page and GPU-page conversions
- Small, surgical fix (~3 lines in 1 file, 1 function)
- On 4K systems behavior is mathematically identical (no regression
  risk)
- Acked by Christian König, merged by Alex Deucher (both verified AMDGPU
  maintainers)
- Bug introduced in v5.14-rc1, confirmed present in v5.15, v6.1, v6.6
- Related non-4K fix by same author already in tree
- No dependencies; standalone fix

AGAINST backporting:
- Affects only non-4K page platforms (niche but real user base: Power +
  ARM64 with non-4K pages)
- Minor signature adaptation needed for older stable trees
- No Reported-by or syzbot report (expected; this is platform-specific,
  not fuzzable)

UNRESOLVED:
- Could not access lore.kernel.org discussion threads

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — verified by code inspection;
   Acked by subsystem maintainer
2. Fixes a real bug? **YES** — SVM fault recovery broken on non-4K
   systems
3. Important issue? **YES** — functional failure (GPU compute broken) on
   affected platforms
4. Small and contained? **YES** — ~3 lines in 1 file
5. No new features or APIs? **YES** — pure correctness fix
6. Can apply to stable? **YES** — with trivial adaptation for older call
   signatures

**Step 9.3: Exception Categories**
Record: [Not applicable — standard bug fix]

**Step 9.4: Decision**
This is a clear, small, obviously correct bug fix that resolves a real
functional failure on non-4K page systems. The fix gives
`svm_range_restore_pages()` a system-page PFN (which it expects) instead
of a GPU-page PFN (which it cannot use correctly on non-4K page
systems). It has no behavior change on the dominant 4K-page x86_64
platforms, and is endorsed by both AMDGPU subsystem maintainers. The bug
exists in all active stable trees from v5.15 onward. This meets all
stable kernel criteria with an extremely favorable risk-benefit ratio.

---

## Verification

- [Phase 1] Parsed tags from supplied commit: Acked-by Christian König,
  SOB Donet Tom (IBM), SOB Alex Deucher
- [Phase 2] Read current `amdgpu_vm.c` lines 2976-2982: confirmed `addr
  /= AMDGPU_GPU_PAGE_SIZE` before `svm_range_restore_pages()` (pre-fix
  code)
- [Phase 2] Read `kfd_svm.c` line 2657: confirmed `svm_range_from_addr`
  documents `@addr` as "in pages" (system pages)
- [Phase 2] Grep on `kfd_svm.c`: confirmed `vma_lookup(mm, addr <<
  PAGE_SHIFT)` at line 3136
- [Phase 2] Grep on `amdgpu_gart.h:35`: confirmed `AMDGPU_GPU_PAGE_SIZE`
  is `4096`
- [Phase 3] `git blame -L 2976,2982`: confirmed buggy conversion
  introduced by `ea53af8a59c89b` (Alex Sierra, 2020-05-11)
- [Phase 3] `git describe --contains ea53af8a59c89b`: confirmed first in
  `v5.14-rc1`
- [Phase 3] `git log --author='Donet Tom' -- drivers/gpu/drm/amd/`:
  found related `daea2e81c1804` non-4K fix
- [Phase 3] Verified Christian König and Alex Deucher are listed AMDGPU
  maintainers in `MAINTAINERS`
- [Phase 5] Grep confirmed callers in `gmc_v9_0.c`, `gmc_v10_0.c`,
  `gmc_v11_0.c`, `gmc_v12_0.c`
- [Phase 5] Grep on `gmc_v10_0.c:114`: confirmed `addr =
  (u64)entry->src_data[0] << 12` (byte address from HW)
- [Phase 5] Read `kfd_svm.c:3000-3003`: confirmed
  `svm_range_restore_pages()` signature with `uint64_t addr`
- [Phase 6] `git show v5.15:amdgpu_vm.c`: confirmed same `addr /=
  AMDGPU_GPU_PAGE_SIZE` before SVM call at line 3376
- [Phase 6] `git show v6.1:amdgpu_vm.c`: confirmed same bug pattern at
  line 2476
- [Phase 6] `git show v6.6:amdgpu_vm.c`: confirmed same bug pattern at
  lines 2574-2577 (with 6-param signature)
- [Phase 6] Confirmed function signatures differ: v5.15/v6.1 use 4
  params, v6.6 uses 6 params, mainline uses 7 params
- UNVERIFIED: Could not access lore.kernel.org mailing list discussion
  (Anubis bot protection)

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index da25ba1578b4a..1194326e66f5d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2973,14 +2973,14 @@ bool amdgpu_vm_handle_fault(struct amdgpu_device *adev, u32 pasid,
 	if (!root)
 		return false;
 
-	addr /= AMDGPU_GPU_PAGE_SIZE;
-
 	if (is_compute_context && !svm_range_restore_pages(adev, pasid, vmid,
-	    node_id, addr, ts, write_fault)) {
+	    node_id, addr >> PAGE_SHIFT, ts, write_fault)) {
 		amdgpu_bo_unref(&root);
 		return true;
 	}
 
+	addr /= AMDGPU_GPU_PAGE_SIZE;
+
 	r = amdgpu_bo_reserve(root, true);
 	if (r)
 		goto error_unref;
-- 
2.53.0

