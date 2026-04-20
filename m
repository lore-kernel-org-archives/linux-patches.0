Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DD93E51E9;
	Mon, 20 Apr 2026 13:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691491; cv=none; b=UMjLUGU+V0c6+6Ig6XfGvhXzd5AKu9VljcoWMqmCnGtxicKDe9Xc5QVWzngzOGpHvuR+TX+cw9pPN9HtXPkAA2w5ASP8/ggxwWB/o6tQHM7lkCcATbVaLIG0xLmhWDThpwzCyJBfmdUGp+POVhBYMxwppZQzFnH10fwaIyBHkF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691491; c=relaxed/simple;
	bh=KiBV/iGyjBs+vwGxJU1esMIoCY6yYQX0oecXeTUCedI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kX9bxXTG4IJpdNjLPmSAHoUvjw965TPuThUsSzknESJ2ARp+UAddG+Br5PFnLnrlCdJdTiSqjLsFzk2POarZ4RuuWH2j8Otyuer5v2u4wz9x8R9KL9e142o5zOSV+cpuyvnGJXzR46HigFutZzG39lPuPxhAYhCNClog5wQhm6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4XU4ud+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4XU4ud+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2570C19425;
	Mon, 20 Apr 2026 13:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691491;
	bh=KiBV/iGyjBs+vwGxJU1esMIoCY6yYQX0oecXeTUCedI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4XU4ud+P5EgJ6BuQYhW8GA3izHYXHlE6OnnsMWY3xLLMeL6B8LzVezdFMtMqQt9x
	 2Vw++2My3aA25/BFu9tHm6OLoVsj6llx6nNsrBoc0uFElKYNzEyfhr5v1/j/ggMOUs
	 S07IvwfmlNeLZM8BAr5xfAwgg4HmnWgYeTM0rXF2RbHJATs3KV2XqoY/0jm5eNG6Mc
	 eqZGZgtyoE2V4aeOwj6jmXHTwYGHakYJq+P/7nnq9WMgbVba+M4WKW+/vII4Fn5OZE
	 AEEuLM2zyHcj2gGCLHHZwsLgo+9k0ffDG9e2RZ4GVeE/X2qGErgcK+c7kzkxQ7qB0F
	 z35fx6khMvTsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: lynn <liulynn@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	robin.murphy@arm.com,
	joro@8bytes.org,
	will@kernel.org,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] iommu/iova: Add NULL check in iova_magazine_free()
Date: Mon, 20 Apr 2026 09:17:35 -0400
Message-ID: <20260420132314.1023554-61-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: lynn <liulynn@google.com>

[ Upstream commit fa8fb60d36375ca3166a60589a624f0d0bc9ddb5 ]

When iova_domain_init_rcaches() fails to allocate an iova_magazine
during the initialization of per-cpu rcaches, it jumps to out_err and
calls free_iova_rcaches() for cleanup.

In free_iova_rcaches(), the code iterates through all possible CPUs to
free both cpu_rcache->loaded and cpu_rcache->prev. However, if the
original allocation failed mid-way through the CPU loop, the pointers
for the remaining CPUs remain NULL.

Since kmem_cache_free() does not explicitly handle NULL pointers like
kfree() does, passing these NULL pointers leads to a kernel paging
request fault.

Add a NULL check in iova_magazine_free() to safely handle partially
initialized rcaches in error paths.

Signed-off-by: lynn <liulynn@google.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `iommu/iova`
- Action verb: "Add" (NULL check)
- Summary: Adds a NULL check in `iova_magazine_free()` to prevent crash
  on partially initialized rcaches during error cleanup.

Record: [iommu/iova] [Add NULL check] [Prevent kernel crash when
kmem_cache_free receives NULL during error cleanup]

**Step 1.2: Tags**
- `Signed-off-by: lynn <liulynn@google.com>` - Author (Google engineer)
- `Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>` - IOMMU subsystem
  maintainer (strong indicator of review)
- No Fixes: tag (expected for manually reviewed commits)
- No Reported-by, Tested-by, or Reviewed-by tags
- No Link: tags

Record: Author from Google, accepted by IOMMU subsystem maintainer
directly.

**Step 1.3: Commit Body**
The message clearly describes:
- **Bug**: `iova_domain_init_rcaches()` can fail mid-way through the
  per-CPU loop
- **Mechanism**: Jumps to `out_err` which calls `free_iova_rcaches()`
- **Problem**: `free_iova_rcaches()` iterates ALL possible CPUs, but
  uninitialized CPUs have NULL `loaded`/`prev` pointers
- **Crash**: `kmem_cache_free()` does NOT handle NULL pointers (unlike
  `kfree()`)
- **Result**: "kernel paging request fault" (crash)

Record: Real bug on error path causing kernel crash (NULL pointer to
kmem_cache_free).

**Step 1.4: Hidden Bug Fix Detection**
This is explicitly described as a bug fix - no hidden meaning needed.

Record: Explicit bug fix, not hidden.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `drivers/iommu/iova.c`
- 2 lines added, 1 line removed (net +1 line)
- Function modified: `iova_magazine_free()`

Record: [drivers/iommu/iova.c: +2/-1] [iova_magazine_free()] [Single-
file surgical fix]

**Step 2.2: Code Flow Change**

```612:615:drivers/iommu/iova.c
static void iova_magazine_free(struct iova_magazine *mag)
{
        kmem_cache_free(iova_magazine_cache, mag);
}
```

Before: Unconditionally calls `kmem_cache_free()` with `mag`, which
crashes if `mag` is NULL.
After: Guards with `if (mag)` before calling `kmem_cache_free()`.

Record: Before=unconditional kmem_cache_free (crashes on NULL),
After=guarded with NULL check.

**Step 2.3: Bug Mechanism**
Category: **NULL pointer dereference** causing kernel crash.

The error path in `iova_domain_init_rcaches()`:

```737:747:drivers/iommu/iova.c
                for_each_possible_cpu(cpu) {
                        cpu_rcache = per_cpu_ptr(rcache->cpu_rcaches,
cpu);

                        spin_lock_init(&cpu_rcache->lock);
                        cpu_rcache->loaded =
iova_magazine_alloc(GFP_KERNEL);
                        cpu_rcache->prev =
iova_magazine_alloc(GFP_KERNEL);
                        if (!cpu_rcache->loaded || !cpu_rcache->prev) {
                                ret = -ENOMEM;
                                goto out_err;
                        }
                }
```

When allocation fails, `free_iova_rcaches()` is called:

```886:891:drivers/iommu/iova.c
                for_each_possible_cpu(cpu) {
                        cpu_rcache = per_cpu_ptr(rcache->cpu_rcaches,
cpu);
                        iova_magazine_free(cpu_rcache->loaded);
                        iova_magazine_free(cpu_rcache->prev);
                }
                free_percpu(rcache->cpu_rcaches);
```

I verified that `__alloc_percpu` zero-initializes memory (line 1893 in
`mm/percpu.c`: `memset(..., 0, size)`), so uninitialized CPUs have NULL
`loaded`/`prev`.

Record: [NULL pointer dereference] [kmem_cache_free(NULL) crashes,
unlike kfree(NULL)]

**Step 2.4: Fix Quality**
- Obviously correct: adding a NULL guard before a function that can't
  handle NULL
- Minimal: 2-line change
- No regression risk: the `if (mag)` guard only skips the free when the
  pointer is NULL, which is the correct behavior (nothing to free)
- Standard kernel pattern for `kmem_cache_free` wrappers

Record: Excellent quality. Obviously correct, minimal, zero regression
risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The current `iova_magazine_free()` body was last changed by commit
`84e6f56be9c68b` (Pasha Tatashin, Feb 2024), which changed `kfree(mag)`
to `kmem_cache_free(iova_magazine_cache, mag)`. The function structure
dates to `9257b4a206fc02` (Omer Peleg, April 2016).

Record: Bug introduced by `84e6f56be9c68b` (v6.9-rc1), present since
~v6.9.

**Step 3.2: The Bug Introduction Chain**
The bug is the result of two commits:
1. `a390bde707545` (v6.1 era, Sep 2022): Removed NULL checks from
   related magazine functions (but `iova_magazine_free()` was still
   using `kfree()` which handles NULL).
2. `84e6f56be9c68b` (v6.9-rc1, Feb 2024): Changed from `kfree()` to
   `kmem_cache_free()` without adding a NULL check. **This is the bug-
   introducing commit.**

The `Fixes:` tag should point to `84e6f56be9c68b`.

Record: Bug introduced by 84e6f56be9c68b (v6.9-rc1). Present in v6.9+.

**Step 3.3: Related Changes**
Recent iova.c changes since v6.9 are mostly minor (typo fix,
MODULE_DESCRIPTION, kmemleak fix, kmalloc_obj conversion). No related
fix has been applied.

Record: No prior fix for this issue. Standalone fix, no prerequisites.

**Step 3.4: Author**
Author `lynn <liulynn@google.com>` - Google engineer, not the subsystem
maintainer. However, the patch was signed off by Joerg Roedel, the IOMMU
subsystem maintainer.

Record: External contributor, accepted by IOMMU subsystem maintainer.

**Step 3.5: Dependencies**
The fix is self-contained. It only requires that `iova_magazine_free()`
exists and uses `kmem_cache_free()`, which is the case since v6.9.

Record: No dependencies. Fully standalone.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.5: Mailing List Discussion**
Web searches for the exact patch title did not find it on
lore.kernel.org (the patch may be too recent for indexing, or the bot
protection on lore blocked the search). However, web search results did
reveal relevant historical context:

- A 2023 discussion (RESEND PATCH 1/2) by Zhang Zekun proposed adding
  NULL checks in `free_iova_rcaches()` for `cpu_rcache->loaded` and
  `cpu_rcache->prev`. Maintainer Robin Murphy noted `kfree(NULL)` is
  valid. **At that time it was `kfree()`, so the concern was
  dismissed.** But the subsequent change to `kmem_cache_free()`
  reintroduced the same concern.

Record: Prior discussion acknowledged the NULL path existed but
dismissed it because kfree handles NULL. The later change to
kmem_cache_free reopened the issue.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
Only `iova_magazine_free()` is modified.

**Step 5.2: Callers**
All callers of `iova_magazine_free()` in iova.c:
1. `iova_depot_work_func()` (line 708) - depot pop, always non-NULL
2. `__iova_rcache_get()` (line 841) - swapping from depot, always non-
   NULL
3. `free_iova_rcaches()` (lines 888-889) - **CAN BE NULL on error path**
4. `free_iova_rcaches()` (line 894) - depot pop, always non-NULL
5. `free_global_cached_iovas()` (line 936) - depot pop, always non-NULL

Record: The NULL case only occurs at lines 888-889 in
`free_iova_rcaches()`, which is the error cleanup path.

**Step 5.3-5.4: Call Chain**
`iova_domain_init_rcaches()` is called during IOMMU DMA domain setup,
which happens during device probing (very common path). Error in this
path = IOMMU initialization failure = device cannot do DMA.

Record: Reachable during device probing. Triggered by memory allocation
failure (OOM or fault injection).

**Step 5.5: Similar Patterns**
The kernel widely uses NULL-guarded wrappers for `kmem_cache_free` when
a pointer can be NULL. This is a well-established pattern.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable Trees**
- `84e6f56be9c68b` first appeared in v6.9-rc1
- Active LTS/stable trees: 6.12.y has the bug. 6.6.y and older do NOT
  (they still use `kfree`).

Record: Bug exists in 6.12.y (and later). NOT in 6.6.y or older.

**Step 6.2: Backport Complications**
The patch is a trivial 2-line change to a function that hasn't changed
since v6.9. Clean apply expected for 6.12.y.

Record: Clean apply expected.

**Step 6.3: Related Fixes in Stable**
No related fixes found.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
IOMMU subsystem (`drivers/iommu/`) - IOVA allocator is used by all DMA-
capable devices when using IOMMU. This is IMPORTANT criticality (affects
all systems with IOMMUs, i.e., most modern servers and many desktops).

**Step 7.2: Activity**
Moderately active. The IOVA allocator is mature but receives periodic
improvements and fixes.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
All systems using IOMMU for DMA (most modern x86 servers, many desktops,
ARM platforms).

**Step 8.2: Trigger Conditions**
- Requires memory allocation failure during `iova_domain_init_rcaches()`
- Can happen under memory pressure
- Can be triggered by fault injection (CONFIG_FAILSLAB)
- Relatively uncommon in practice but possible

**Step 8.3: Failure Mode Severity**
When triggered: **kernel paging request fault** = kernel oops/crash.
Severity: **CRITICAL** (system crash).

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Prevents kernel crash on IOMMU initialization error path
- RISK: Extremely low. A 2-line NULL guard with zero chance of
  regression
- Ratio: **Very favorable**

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**

FOR backporting:
- Fixes a real kernel crash (NULL pointer to kmem_cache_free -> paging
  fault)
- 2-line change, obviously correct, minimal scope
- Accepted by IOMMU subsystem maintainer (Joerg Roedel)
- IOMMU subsystem affects all DMA-capable devices
- Standard NULL-guard pattern used throughout the kernel
- Zero regression risk

AGAINST backporting:
- Requires OOM during initialization to trigger (uncommon but real)
- No Reported-by tag (may not have been hit in the wild yet)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** - trivial NULL check, signed by
   maintainer
2. Fixes a real bug? **YES** - kernel crash on error path
3. Important issue? **YES** - kernel crash (paging fault)
4. Small and contained? **YES** - 2 lines, single function
5. No new features? **YES** - pure fix
6. Can apply to stable? **YES** - clean apply expected for 6.12.y

**Step 9.3: Exception Categories**
Not applicable (this is a straightforward bug fix, not an exception
case).

**Step 9.4: Decision**
This is a clear YES. The fix prevents a kernel crash caused by passing
NULL to `kmem_cache_free()` during error cleanup. It's a 2-line,
obviously correct fix with zero regression risk, accepted by the
subsystem maintainer.

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author (liulynn@google.com)
  and IOMMU maintainer (Joerg Roedel)
- [Phase 2] Diff analysis: 2 lines added to `iova_magazine_free()`, adds
  NULL guard before `kmem_cache_free()`
- [Phase 3] git blame: `kmem_cache_free` introduced by commit
  `84e6f56be9c68b` (v6.9-rc1), replacing safe `kfree()`
- [Phase 3] git show `84e6f56be9c68b`: Confirmed it changed `kfree(mag)`
  to `kmem_cache_free(iova_magazine_cache, mag)` without NULL guard
- [Phase 3] git show `a390bde707545`: Confirmed it removed NULL checks
  from related functions (but iova_magazine_free was still kfree-based
  at that time)
- [Phase 3] git describe --contains `84e6f56be9c68b`: v6.9-rc1~153 -
  confirmed bug introduced in v6.9
- [Phase 3] git log v6.6..v6.12: Confirmed 84e6f56be9c68b is between
  v6.6 and v6.12
- [Phase 4] Web search: Found 2023 discussion where same NULL concern
  was dismissed because kfree handles NULL
- [Phase 5] Grep callers: 6 call sites, only `free_iova_rcaches()` lines
  888-889 can pass NULL
- [Phase 5] Verified `__alloc_percpu` zero-initializes memory
  (mm/percpu.c line 1893: `memset(..., 0, size)`)
- [Phase 5] Traced error path: `iova_domain_init_rcaches()` -> `goto
  out_err` -> `free_iova_rcaches()` -> `iova_magazine_free(NULL)` ->
  crash
- [Phase 6] git tag --contains: Bug exists in v6.10+, active stable
  6.12.y is affected; 6.6.y not affected
- [Phase 8] Failure mode: kernel paging request fault (crash), severity
  CRITICAL
- UNVERIFIED: Could not access lore.kernel.org discussion thread
  directly (bot protection); relied on web search for historical context

**YES**

 drivers/iommu/iova.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index f9cd18316d16b..021daf6528de1 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -611,7 +611,8 @@ static struct iova_magazine *iova_magazine_alloc(gfp_t flags)
 
 static void iova_magazine_free(struct iova_magazine *mag)
 {
-	kmem_cache_free(iova_magazine_cache, mag);
+	if (mag)
+		kmem_cache_free(iova_magazine_cache, mag);
 }
 
 static void
-- 
2.53.0

