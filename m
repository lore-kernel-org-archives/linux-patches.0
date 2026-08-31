Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D9549E5F9;
	Mon, 31 Aug 2026 13:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183641; cv=none; b=QEjfxSMrmZt1ZErChf+v/CYYur752vlVSpO8t7m0tV8efgsHhy7o9VtcI/Fn8ssbVMHjZ7PO0ZtbHNxjjnsUtpBMLM6rX8EAOMrAgbsSVipcXQdHYfpHmSciNhTtFpxSndWL/NhflqIn+uTuFy/uTA+E506pFQNs8hXhSjMPSRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183641; c=relaxed/simple;
	bh=yVdPVSkH6+vj17TwqiI9vyjEtAAoFiQEtA59sjzIzU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qw6OL3ZDMCbRA+MPETMX1mFWF2IjLtC+duvpF9NmVHynWuV7l93lA9vDYzo8gYxjH1XzT3AbnS1prtIYgf+EHyf/ROYEptCoXwfeZw4qroOTeGhmCoUqD8nYeE3BjQMN4wbZFMsQ8HT6Z5m1BR0YIee7G8Dqmgs6AQujg/mASlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5n6lw+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5n6lw+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5941F00A3F;
	Mon, 31 Aug 2026 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183638;
	bh=FhSqjgyWL0jEYi+GId97vcQAV/lXSVQt99tmDjDDfrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5n6lw+PUfJI86J4PcUmZHJXgx000Gt0ga98awxUkcRE80HCXTtzTSB1Xvp//ShLi
	 OEVn/FN87V8r96R0JQCATgWLEufxvcNoelhYUsTYUbBW6Ol6SFM8uCq84tX7W2JrdQ
	 1n3+vfbgqoJdGbU1VIT/dXlykfIeS1jUNlx9vASRwtrDm7rJbcTebixxCkkq3C6CpD
	 HPAgWoZOGRpKYOlqrSgD+9jNgfQop+NU3fl11aVRSl7QHiH5cHMnQtJdnKMhcwBwY6
	 H7CoIl+knAFEFUZYxXS92vfse6kc7dOMzMgIYqC0z+4E3v1l0uwXLaS+JP+qE34Wcw
	 nY+WjkAFnvdsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Troy Mitchell <troy.mitchell@linux.dev>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Drew Fustini <fustini@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] riscv: mm: fix SWIOTLB initialization for systems with DRAM above 4GB
Date: Mon, 31 Aug 2026 09:24:01 -0400
Message-ID: <20260831133314.4125787-213-sashal@kernel.org>
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

From: Troy Mitchell <troy.mitchell@linux.dev>

[ Upstream commit cfca5a48b03fbd33c8cb84cb73ee2e34467f3a33 ]

On RISC-V platforms where the entire physical memory (DRAM) resides
above the 32-bit address space (i.e., above dma32_phys_limit), the
current SWIOTLB initialization logic fails.

This patch addresses two interconnected issues on such platforms:

1. Incorrect 32-bit DMA bounce assumption:
The existing condition `max_pfn > PFN_DOWN(dma32_phys_limit)` assumes
that a 32-bit DMA bounce buffer is required simply because the maximum
PFN exceeds the 32-bit limit. However, if all DRAM starts above 4GB,
no memory exists below the limit to satisfy this allocation. Fix
this by adding a check to ensure `memblock_start_of_DRAM()` is actually
below the 32-bit limit before enforcing 32-bit SWIOTLB.

2. kmalloc() bounce buffer allocation failure on non-coherent systems:
For non-coherent DMA, kmalloc() buffers whose sizes are not
cache-line-aligned still require bouncing, even if 32-bit DMA bouncing
is skipped. Without the `SWIOTLB_ANY` flag, swiotlb_init() defaults to
allocating from low memory, which fails completely when DRAM only exists
in high memory. By appending `SWIOTLB_ANY` to swiotlb_flags, the allocator
is permitted to allocate this bounce buffer from high memory.

With this patch, systems with non-coherent DMA and DRAM entirely above
4GB can successfully map the software IO TLB in high memory and boot
normally.

Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Signed-off-by: Troy Mitchell <troy.mitchell@linux.dev>
Link: https://patch.msgid.link/20260727-fix-riscv-swiotlb-v3-1-59479b23736c@linux.dev
Reviewed-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[riscv: mm]` `[fix]` — SWIOTLB initialization fails on RISC-V
systems whose DRAM is entirely above 4GB.

**Step 1.2 — Tags**
Record:
- **Tested-by:** Anirudh Srinivasan `<asrinivasan@oss.tenstorrent.com>`
  (real hardware validation)
- **Reviewed-by:** Drew Fustini `<fustini@kernel.org>` (RISC-V
  maintainer)
- **Signed-off-by:** Troy Mitchell, Paul Walmsley
- **Link:** https://patch.msgid.link/20260727-fix-riscv-
  swiotlb-v3-1-59479b23736c@linux.dev
- No `Fixes:`, `Cc: stable@vger.kernel.org`, or `Reported-by:` tags
- Notable: hardware-tested on Tenstorrent; reviewed by maintainer

**Step 1.3 — Body analysis**
Record:
- **Bug:** `arch_mm_preinit()` SWIOTLB setup is wrong when all physical
  DRAM sits above `dma32_phys_limit` (4GB).
- **Symptom:** SWIOTLB init fails; affected systems cannot boot
  normally.
- **Root cause (two parts):**
  1. `max_pfn > PFN_DOWN(dma32_phys_limit)` wrongly forces 32-bit bounce
     SWIOTLB even when no memory exists below 4GB;
     `memblock_alloc_low()` then fails.
  2. On non-coherent DMA systems, kmalloc bounce still needs SWIOTLB,
     but without `SWIOTLB_ANY` the allocator is restricted to low memory
     and also fails when DRAM is only in high memory.
- **Version info:** None explicit; reviewer ties regression to
  `dcb2743d1e701`.

**Step 1.4 — Hidden bug fix?**
Record: No — this is an explicit boot/DMA initialization bug fix, not
disguised cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- **Files:** `arch/riscv/mm/init.c` (+12 / −5)
- **Function:** `arch_mm_preinit()`
- **Scope:** Single-file, surgical fix

**Step 2.2 — Code flow changes**

| Hunk | Before | After |
|------|--------|-------|
| SWIOTLB enable test | `swiotlb = max_pfn > PFN_DOWN(dma32_phys_limit)`
| Also requires `memblock_start_of_DRAM() < dma32_phys_limit` |
| Flags | Always `SWIOTLB_VERBOSE` | `swiotlb_flags` variable; adds
`SWIOTLB_ANY` on kmalloc-bounce path |
| `swiotlb_init()` call | `swiotlb_init(swiotlb, SWIOTLB_VERBOSE)` |
`swiotlb_init(swiotlb, swiotlb_flags)` |

Record: Normal boot path in early MM init; affects all boots on matching
RISC-V configs.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Logic/correctness + memory allocation failure on error-
  free path
- **Mechanism:** `swiotlb_memblock_alloc()` uses `memblock_alloc_low()`
  unless `SWIOTLB_ANY` is set (verified in
  `kernel/dma/swiotlb.c:331-334`). On high-memory-only platforms, low-
  memory allocation fails; `swiotlb_init_remap()` eventually gives up at
  `IO_TLB_MIN_SLABS` and returns without initializing SWIOTLB
  (`kernel/dma/swiotlb.c:386-388`).

**Step 2.4 — Fix quality**
Record:
- Minimal, obviously correct: only enable 32-bit bounce when DRAM
  actually spans below 4GB; allow high-memory allocation when needed.
- Same `SWIOTLB_ANY` pattern already used on x86 and PowerPC.
- Low regression risk: narrow conditions, no API changes.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Current buggy lines in `arch_mm_preinit()` are present in this
tree at lines 175–193. `swiotlb_adjust_size` kmalloc-bounce logic dates
to `dcb2743d1e701` (Mar 2024). Original SWIOTLB init logic dates to
`ce3aca0465e31` (2021). Bug present since at least v6.10 in equivalent
code.

**Step 3.2 — Fixes: tag**
Record: N/A in commit message. Reviewer suggested `Fixes: dcb2743d1e701`
in lore thread.

**Step 3.3 — Related file history**
Record:
- v6.12: same buggy logic lived in `mem_init()`
- v6.18/HEAD: logic moved to `arch_mm_preinit()`
- Fix commit `cfca5a48b03fb` is **not** in this tree (`merge-base --is-
  ancestor` → not ancestor of HEAD)
- Standalone one-patch fix; v1→v3 series on lore, v3 is final

**Step 3.4 — Author context**
Record: Troy Mitchell; Tested-by from Tenstorrent. Paul Walmsley (RISC-V
maintainer) committed. Drew Fustini reviewed.

**Step 3.5 — Dependencies**
Record: No prerequisites. Uses `memblock_start_of_DRAM()`,
`dma32_phys_limit`, `SWIOTLB_ANY` — all present in this tree. `git apply
--check` on upstream patch succeeds cleanly.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- **URL:** https://patch.msgid.link/20260727-fix-riscv-
  swiotlb-v3-1-59479b23736c@linux.dev
- **Series:** v1 (2026-03-31), v3 (2026-07-27); v3 is applied upstream
- **Key feedback:** Drew Fustini: "LGTM and resolves the issue for Linux
  running on the X280 clusters in the Tenstorrent Blackhole"; suggested
  `Fixes: dcb2743d1e701`
- Paul Walmsley: "Thanks, queued for v7.2-rc"
- No NAKs; no explicit stable nomination

**Step 4.2 — Reviewers**
Record: CC'd Paul Walmsley, Palmer Dabbelt, Alexandre Ghiti, linux-
riscv, linux-kernel, spacemit list.

**Step 4.3 — Bug report**
Record: No formal bugzilla/syzbot report. Real-world impact confirmed by
Tenstorrent tester on Blackhole X280 clusters.

**Step 4.4 — Related patches**
Record: Regression partially from `dcb2743d1e701` ("still create swiotlb
buffer for kmalloc() bouncing if required"). Fix is self-contained.

**Step 4.5 — Stable list history**
Record: Not searched separately; no stable nomination found in thread.
Absence is not a negative signal per review rules.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `arch_mm_preinit()` modified.

**Step 5.2 — Callers**
Record: Called from `mm/mm_init.c:2699` during `start_kernel()` →
`mm_core_init()` → `arch_mm_preinit()`. Every boot on MMU-enabled
kernels.

**Step 5.3 — Callees**
Record: `memblock_start_of_DRAM()`, `swiotlb_adjust_size()`,
`swiotlb_init()` → `swiotlb_memblock_alloc()`.

**Step 5.4 — Reachability**
Record: Always executed at boot. Triggered on RISC-V 64-bit
(`CONFIG_ZONE_DMA32`), especially with `CONFIG_RISCV_DMA_NONCOHERENT`
(selected by T-Head/Andes errata Kconfig) and DRAM base ≥ 4GB.

**Step 5.5 — Similar patterns**
Record: `arch/arm64/mm/init.c` has analogous kmalloc-bounce logic but
different DMA limit handling. x86/PowerPC already use `SWIOTLB_ANY` for
high-memory SWIOTLB allocation.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code exists?**
Record: **YES.** Local tree is **v6.18.44** (`git describe HEAD` →
`v6.18.44-2-g1b9e1abadee04`). Buggy code confirmed at
`arch/riscv/mm/init.c:175-193`. Fix is not present.

**Step 6.2 — Backport complications**
Record: **Clean apply.** `git apply --check` on upstream patch passes.
No conflicts expected.

**Step 6.3 — Related fixes already present?**
Record: **No.** `cfca5a48b03fb` / `e6709c80ce3b8` not in HEAD.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
Record: `arch/riscv/mm` — **IMPORTANT** (platform-specific boot path,
but boot-blocking for affected hardware).

**Step 7.2 — Activity**
Record: RISC-V MM actively developed; `arch_mm_preinit()` is a recent
refactor from `mem_init()` between 6.12 and 6.18.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: RISC-V 64-bit systems with:
- `CONFIG_SWIOTLB` + `CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC` (selected via
  `RISCV_DMA_NONCOHERENT`)
- All DRAM above 4GB
- Examples: Tenstorrent Blackhole X280 clusters

**Step 8.2 — Trigger conditions**
Record: Every boot on matching hardware. Not userspace-triggered;
platform configuration dependent. Uncommon globally, but deterministic
on affected SoCs.

**Step 8.3 — Failure mode severity**
Record: SWIOTLB fails to initialize → boot failure or broken non-
coherent DMA (data corruption risk). **Severity: CRITICAL** for affected
platforms.

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** HIGH for affected RISC-V hardware (enables boot)
- **Risk:** LOW (17-line change, reviewed, tested, existing flags/APIs)
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real boot blocker on production RISC-V hardware (Tenstorrent
  Blackhole)
- Small, surgical, reviewed, hardware-tested fix
- Buggy code present in v6.18.44
- Applies cleanly
- Fixes logic error + allocation failure using existing `SWIOTLB_ANY`
- Non-coherent DMA without SWIOTLB risks data corruption

**AGAINST backport:**
- Affects a narrow hardware subset (non-coherent RISC-V with DRAM > 4GB
  only)
- No syzbot/CVE report

**Unresolved:** None material to the decision.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** (reviewed, Tenstorrent Tested-
   by)
2. Fixes a real bug affecting users? **PASS** (boot failure on real
   hardware)
3. Important issue? **PASS** (boot blocker / broken DMA on affected
   systems)
4. Small and contained? **PASS** (1 file, ~17 lines)
5. No new features or APIs? **PASS** (uses existing `SWIOTLB_ANY`,
   `memblock_start_of_DRAM()`)
6. Can apply to local tree? **PASS** (`git apply --check` succeeds)

**Step 9.3 — Exception category**
Record: N/A (hardware quirk/workaround exception does not apply; this is
a boot-path bug fix).

**Step 9.4 — Decision rationale**
On this **6.18.y** tree, the buggy SWIOTLB initialization code is
present and the fix is absent. For RISC-V platforms with non-coherent
DMA and DRAM entirely above 4GB, the kernel cannot reliably initialize
SWIOTLB, preventing normal boot on hardware such as Tenstorrent
Blackhole. The fix is minimal, well-reviewed, hardware-tested, and
applies cleanly. This is appropriate stable material despite the narrow
hardware scope, because it is a deterministic boot blocker with no
practical workaround.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified Tenstorrent Tested-by
  and Drew Fustini Reviewed-by
- [Phase 2] Diff analysis: 1 file, `arch_mm_preinit()`, +12/−5;
  `SWIOTLB_ANY` + `memblock_start_of_DRAM()` check
- [Phase 3] `git describe HEAD`: v6.18.44; buggy code at
  `arch/riscv/mm/init.c:175-193`
- [Phase 3] `merge-base --is-ancestor cfca5a48b03fb HEAD`: not in tree
  (exit 1)
- [Phase 3] `swiotlb_adjust_size` present since v6.10; reviewer linked
  regression to `dcb2743d1e701`
- [Phase 4] `b4 dig -c e6709c80ce3b8`: found v3 thread; v1 and v3
  revisions
- [Phase 4] `b4 dig -w`: Paul Walmsley, Palmer Dabbelt, linux-riscv CC'd
- [Phase 4] Mbox: Drew Fustini confirmed fix for Tenstorrent Blackhole
  X280; suggested Fixes tag; no NAKs
- [Phase 5] `arch_mm_preinit()` called from `mm/mm_init.c:2699` on every
  boot
- [Phase 5] `swiotlb_memblock_alloc()` uses `memblock_alloc_low()`
  without `SWIOTLB_ANY` (`kernel/dma/swiotlb.c:331-334`)
- [Phase 5] Failed allocation path returns without init
  (`kernel/dma/swiotlb.c:386-388`)
- [Phase 6] `git show v6.18:arch/riscv/mm/init.c`: same buggy code in
  v6.18 base
- [Phase 6] `git apply --check` on upstream patch: clean apply (exit 0)
- [Phase 6] `memblock_start_of_DRAM()` and `SWIOTLB_ANY` exist in tree
- [Phase 6] `CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC` selected for RISC-V
  non-coherent (`arch/riscv/Kconfig:361`)
- [Phase 8] Failure mode: SWIOTLB init failure → boot failure / broken
  DMA; severity CRITICAL for affected platforms

**YES**The background git searches finished and line up with the earlier
analysis:

- The fix exists in the repo as `cfca5a48b03fb` / `e6709c80ce3b8`, but
  it is **not** in this **6.18.44** tree.
- The buggy SWIOTLB logic **is** present here (including the kmalloc-
  bounce path from `dcb2743d1e701`).
- The regression has been in place since at least **v6.10**; **v6.18**
  still has the bug.
- The upstream patch applies cleanly to the current tree.

**Verdict for 6.18.y: YES** — this is a boot-blocking fix for non-
coherent RISC-V systems with DRAM entirely above 4GB (e.g. Tenstorrent
Blackhole), and it is appropriate for stable backport.The search for
`memblock_start_of_DRAM() < dma32_phys_limit` found no matches in this
tree, which confirms the fix is **not** already present in **6.18.44**.
That supports the earlier **YES** backport recommendation.

 arch/riscv/mm/init.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 557bf160b503a..59f9bf2fdd300 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -172,7 +172,9 @@ static void print_vm_layout(void) { }
 
 void __init arch_mm_preinit(void)
 {
-	bool swiotlb = max_pfn > PFN_DOWN(dma32_phys_limit);
+	bool swiotlb = max_pfn > PFN_DOWN(dma32_phys_limit) &&
+		       memblock_start_of_DRAM() < dma32_phys_limit;
+	unsigned int swiotlb_flags = SWIOTLB_VERBOSE;
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif /* CONFIG_FLATMEM */
@@ -180,17 +182,22 @@ void __init arch_mm_preinit(void)
 	if (IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) && !swiotlb &&
 	    dma_cache_alignment != 1) {
 		/*
-		 * If no bouncing needed for ZONE_DMA, allocate 1MB swiotlb
-		 * buffer per 1GB of RAM for kmalloc() bouncing on
-		 * non-coherent platforms.
+		 * No 32-bit DMA bouncing needed (either all DRAM is within
+		 * the 32-bit limit, or it all starts above it), but
+		 * kmalloc() buffers whose sizes are not cache-line-aligned
+		 * still require bouncing for non-coherent DMA.  Use
+		 * SWIOTLB_ANY so that the buffer can be allocated from high
+		 * memory when DRAM starts above dma32_phys_limit.  Allocate
+		 * ~1 MB per 1 GB of RAM.
 		 */
 		unsigned long size =
 			DIV_ROUND_UP(memblock_phys_mem_size(), 1024);
 		swiotlb_adjust_size(min(swiotlb_size_or_default(), size));
 		swiotlb = true;
+		swiotlb_flags |= SWIOTLB_ANY;
 	}
 
-	swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
+	swiotlb_init(swiotlb, swiotlb_flags);
 
 	print_vm_layout();
 }
-- 
2.53.0

