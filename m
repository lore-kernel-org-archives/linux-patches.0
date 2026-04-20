Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A403A758A;
	Mon, 20 Apr 2026 13:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691081; cv=none; b=pUBf3DnRDi6Wy7oGtDLPQQwX4U/mXzLLsUysXlo/kHYUnYLocfFtnkruHZ3kzmtYLWkgMT0ellkcJtp9MZIEm/2DMLnQadCwyniAgx/BERx1kKoGnT5dCOibTF/wqylnTT0GwdaJoyTAnYl29AYmW5HJ7zBLt6MEDK1UQB62lu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691081; c=relaxed/simple;
	bh=gHSdlz2rtebhoe2uY5NJV8MntLpDaDpVvBaXmU/yos8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y38fqf6AnINRPKrbBzZ0zaKMK023FDzrixccRud4zaSQxQmkMqezm5M0GD7ciFt75y6A/IOJtBqJNzWSkHIClwr9U8yp0ioMsccfoauCmmoBF3uLZqLKsnRqG2NIp+ocwLz67vryrweB/ZvlS+v4KWiOcp/dZgWnDv/uiWtxTVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0GjRfR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0GjRfR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47C5C2BCB7;
	Mon, 20 Apr 2026 13:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691081;
	bh=gHSdlz2rtebhoe2uY5NJV8MntLpDaDpVvBaXmU/yos8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0GjRfR5uZQwouzm7B7prBJMSJqveUvge8SqhcQj5czHztFi0SVKY0lqI8eTu90Sl
	 v8b73T3SvOUHYDRoTkxIYxb21ZMcgy4qz316h3r2obNa4gOaycRDNS6ubkiVfG9w3+
	 RNcyRwEAsCzD0W7uXYAymPhgAIqAz/WVfjnyGE8SQI0yEfVNGwp90g/7nveFCR7nZP
	 bulct0fu8aeZ5Ek3sOfOTCOicKVU+CTVJbmoX9I5u3IhxFYzZAxTvLhECUIQHZWqNk
	 9EfL2gksyQeF4qh4CfiCZwLZIKeZNnaCo07ocjL0qDSPEkUVEz+DbG5tUg941Fn6l7
	 HI0s+nUNmHkIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koening@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	ray.huang@amd.com,
	airlied@linux.ie,
	daniel@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/ttm: Avoid invoking the OOM killer when reading back swapped content
Date: Mon, 20 Apr 2026 09:09:08 -0400
Message-ID: <20260420131539.986432-82-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

[ Upstream commit c6135f67aa37a4a744869f726d706bda091e6dfa ]

In situations where the system is very short on RAM, the shmem
readback from swap-space may invoke the OOM killer.

However, since this might be a recoverable situation where the caller
is indicating this by setting
struct ttm_operation_ctx::gfp_retry_mayfail to true, adjust the gfp
value used by the allocation accordingly.

Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
Acked-by: Christian König <christian.koening@amd.com>
Link: https://patch.msgid.link/20260317141856.237876-3-thomas.hellstrom@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile everything.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `drm/ttm` (DRM Translation Table Manager - GPU memory
  management)
- **Action verb**: "Avoid" (implies fixing an undesirable behavior)
- **Summary**: Prevent OOM killer invocation when reading back swapped
  GPU buffer content

Record: [drm/ttm] [Avoid] [Prevents unnecessary OOM killer invocation
during shmem readback]

### Step 1.2: Tags
- **Signed-off-by**: Thomas Hellström <thomas.hellstrom@linux.intel.com>
  (author, TTM/Xe maintainer)
- **Reviewed-by**: Maarten Lankhorst <dev@lankhorst.se> (DRM subsystem
  reviewer)
- **Acked-by**: Christian König <christian.koening@amd.com> (TTM co-
  maintainer at AMD)
- **Link**: https://patch.msgid.link/20260317141856.237876-3-
  thomas.hellstrom@linux.intel.com

Record: Reviewed by Maarten Lankhorst, Acked by Christian König (TTM
maintainer). No Fixes: tag, no Reported-by tag. No syzbot link.

### Step 1.3: Commit Body
The commit explains that when the system is very short on RAM, the shmem
readback from swap-space may invoke the OOM killer. Since the caller may
be indicating a recoverable situation via `gfp_retry_mayfail = true`,
the GFP value used by the shmem allocation should be adjusted to include
`__GFP_RETRY_MAYFAIL` (try hard but don't OOM-kill) and `__GFP_NOWARN`
(don't log warnings).

Record: Bug: OOM killer can be triggered during TTM swap readback even
when the operation context indicates the situation is recoverable.
Symptom: Random processes killed by OOM killer unnecessarily. Root
cause: `ttm_backup_copy_page()` used `shmem_read_folio()` with default
GFP flags that don't include `__GFP_RETRY_MAYFAIL`.

### Step 1.4: Hidden Bug Fix Detection
This is explicitly described as avoiding OOM killer invocation, which is
a real behavioral bug. The `gfp_retry_mayfail` flag was already
respected in the page allocation path (`__ttm_pool_alloc`) and in the
restore structure allocation (`ttm_pool_restore_and_alloc`), but NOT in
the swap readback path - an inconsistency that results in incorrect
behavior.

Record: Yes, this is a genuine bug fix - the swap readback path was not
honoring the `gfp_retry_mayfail` flag that other paths already
respected.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **`drivers/gpu/drm/ttm/ttm_backup.c`**: +4/-2 (function signature +
  shmem_read_folio_gfp call)
- **`drivers/gpu/drm/ttm/ttm_pool.c`**: +5/-2 (building additional_gfp
  and passing it)
- **`include/drm/ttm/ttm_backup.h`**: +1/-1 (header declaration update)
- **Total**: ~10 lines changed
- **Functions modified**: `ttm_backup_copy_page()`,
  `ttm_pool_restore_commit()`

Record: 3 files, ~10 net lines. Single-purpose surgical fix. Scope: very
small.

### Step 2.2: Code Flow Change
**Hunk 1** (`ttm_backup.c`): `ttm_backup_copy_page()` gains an
`additional_gfp` parameter. The call changes from
`shmem_read_folio(mapping, idx)` to `shmem_read_folio_gfp(mapping, idx,
mapping_gfp_mask(mapping) | additional_gfp)`. When `additional_gfp` is
0, behavior is identical to before (since `shmem_read_folio()` is a
wrapper that calls `shmem_read_folio_gfp()` with
`mapping_gfp_mask(mapping)`).

**Hunk 2** (`ttm_pool.c`): In `ttm_pool_restore_commit()`, when
`ctx->gfp_retry_mayfail` is true, `additional_gfp` is set to
`__GFP_RETRY_MAYFAIL | __GFP_NOWARN`; otherwise 0.

**Hunk 3** (`ttm_backup.h`): Declaration updated.

Record: Before: swap readback always used default GFP (may invoke OOM).
After: when caller opts into retry_mayfail, swap readback also respects
it. Unchanged when flag is false.

### Step 2.3: Bug Mechanism
This is a **logic/correctness fix**: an existing flag
(`gfp_retry_mayfail`) was inconsistently applied. The page allocation
path already honored it, but the swap readback path did not. The
consequence is unnecessary OOM killer invocation, which kills user
processes.

Record: [Logic/correctness fix] The `gfp_retry_mayfail` flag was not
propagated to the shmem readback path in `ttm_backup_copy_page()`. When
the system was low on RAM and GPU content needed to be restored from
swap, the OOM killer could fire instead of returning an error to the
caller.

### Step 2.4: Fix Quality
- Obviously correct: uses the same pattern already present in other TTM
  paths
- Minimal and surgical: only 10 lines changed
- No regression risk: when `gfp_retry_mayfail` is false, `additional_gfp
  = 0`, making the behavior identical to before
- The `shmem_read_folio_gfp()` function already exists and is used by
  `ttm_backup_backup_page()` in the same file (line 105)

Record: Fix quality: excellent. Minimal, obviously correct, follows
existing pattern, reviewed by maintainer. Regression risk: very low.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy code in `ttm_backup_copy_page()` was introduced in
`e7b5d23e5d470` ("drm/ttm: Provide a shmem backup implementation") by
Thomas Hellström on 2025-03-05. This first appeared in v6.15-rc1.

Record: Buggy code introduced in e7b5d23e5d470, first in v6.15-rc1.

### Step 3.2: Fixes Tag
No Fixes: tag present (expected for candidates needing manual review).

Record: No Fixes: tag. The implicit fix target is e7b5d23e5d470
(introduced the backup code).

### Step 3.3: File History
The ttm_backup.c file has had 8 changes since its introduction (mostly
restructuring, export fixes, mm API changes). The core
`ttm_backup_copy_page()` function has remained stable since
introduction.

Record: File is relatively new (v6.15), stable code. No conflicting
changes found.

### Step 3.4: Author Context
Thomas Hellström is the Intel TTM/Xe maintainer and the original author
of the backup implementation. He wrote both the buggy code and the fix.
This is the highest possible trust level for a patch author.

Record: Author is the subsystem maintainer and original code author.

### Step 3.5: Dependencies
This is patch 2/3 of a 3-patch series:
- Patch 1/3: Adds `__GFP_NOWARN` in `__ttm_pool_alloc` (different code
  path, independent)
- Patch 2/3: This commit (swap readback path)
- Patch 3/3: Kerneldoc update (independent)

Patch 2/3 is fully self-contained and applies independently.

Record: No dependencies on other patches in the series. Can apply
standalone.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Discussion
Found via b4 mbox. The series was submitted as v2 on 2026-03-17. The
cover letter describes it as "two small patches around the
gfp_retry_mayfail behaviour." The author described the changes as
"completely non-controversial."

### Step 4.2: Reviewers
- **Reviewed-by**: Maarten Lankhorst (DRM developer)
- **Acked-by**: Christian König (TTM maintainer at AMD)
- CI passed: Xe.CI.BAT success, Xe.CI.FULL success, CI.KUnit success

### Step 4.3: Bug Report
No specific bug report linked. This appears to be a code-review-
identified issue where the author noticed the inconsistency between the
page allocation path and the swap readback path.

### Step 4.4: Related Patches
Patch 1/3 is a related but independent fix. Patch 3/3 is documentation
only.

Record: [Lore thread found] [v2 is the applied version] [Reviewed by
Maarten Lankhorst, Acked by Christian König] [No specific stable
nomination in discussion] [No concerns raised]

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- `ttm_backup_copy_page()` - modified to accept additional GFP flags
- `ttm_pool_restore_commit()` - modified to compute and pass additional
  GFP flags

### Step 5.2: Callers
`ttm_backup_copy_page()` is called only from
`ttm_pool_restore_commit()`. `ttm_pool_restore_commit()` is called from
`ttm_pool_restore_and_alloc()` and `__ttm_pool_alloc()`.
`ttm_pool_restore_and_alloc()` is called from `ttm_tt_restore()`, which
is called from `xe_tt_populate()` (Intel Xe driver).

The call chain: GPU buffer access -> page fault -> xe_tt_populate ->
ttm_tt_restore -> ttm_pool_restore_and_alloc -> ttm_pool_restore_commit
-> ttm_backup_copy_page -> shmem_read_folio

### Step 5.3-5.4: Call Chain Reachability
This path is triggered when GPU buffer objects that were previously
swapped out need to be restored - a normal operation when the system is
under memory pressure. It's reachable during any GPU workload after swap
has occurred.

Record: The buggy path is reachable during normal GPU operations (page
fault handling for restored buffer objects). Users of Intel Xe and
potentially AMD/Nouveau drivers are affected.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence in Stable
The `ttm_backup.c` file was introduced in v6.15-rc1. The buggy code
exists in stable trees v6.15.y and later. For this 7.0 tree, the
relevant stable trees are 6.15.y, 6.16.y, 6.17.y, 6.18.y, 6.19.y.

Record: Buggy code exists in 6.15.y+ stable trees.

### Step 6.2: Backport Complications
The patch should apply cleanly to 6.15.y+ trees since the code has been
relatively stable. The `d4ad53adfe21d` ("Remove the struct ttm_backup
abstraction") commit changed the function signatures in 6.15, so stable
trees should have the same code structure.

Record: Expected clean apply for 6.15.y+.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
DRM/TTM is the memory manager for GPU drivers (AMD, Intel, Nouveau).
It's used by virtually all desktop/laptop Linux users with discrete or
integrated GPUs.

Record: [DRM/TTM] [IMPORTANT - affects all GPU users]

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All users with DRM/TTM GPU drivers (Intel Xe, AMD, Nouveau) who
experience memory pressure during GPU workloads.

### Step 8.2: Trigger Conditions
- System must be under significant memory pressure
- GPU buffer objects must have been swapped out to shmem
- Application then needs those buffer objects restored
- This is a realistic scenario: heavy GPU workload + many applications =
  memory pressure

### Step 8.3: Failure Mode Severity
**OOM killer invocation** - kills user processes. This is a **HIGH**
severity issue. The OOM killer is one of the most disruptive events in
Linux - it selects and kills a process to free memory. Here, it fires
unnecessarily because the caller indicated the situation is recoverable.

Record: Severity: HIGH (unnecessary OOM killer invocation killing user
processes)

### Step 8.4: Risk-Benefit
- **Benefit**: HIGH - prevents unnecessary OOM kills during GPU memory
  restoration
- **Risk**: VERY LOW - 10 lines, follows existing pattern, zero behavior
  change when flag is false
- **Ratio**: Strongly favorable for backport

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Fixes unnecessary OOM killer invocation (HIGH severity)
- Small, surgical fix (10 lines across 3 files)
- Follows existing pattern in the same codebase
- Written by subsystem maintainer
- Reviewed by DRM developer, Acked by TTM co-maintainer
- CI passed fully
- No dependencies on other patches
- Affects real users with GPU hardware under memory pressure

**AGAINST backporting:**
- No explicit Fixes: tag or Cc: stable (expected for manual review
  candidates)
- No specific user bug report (code-review identified)
- Only affects relatively new code (v6.15+)

### Step 9.2: Stable Rules Checklist
1. Obviously correct? **YES** - follows existing pattern, reviewed by
   maintainers
2. Fixes a real bug? **YES** - OOM killer invoked unnecessarily
3. Important issue? **YES** - OOM killer kills user processes
4. Small and contained? **YES** - 10 lines, single purpose
5. No new features? **YES** - extends existing flag handling to a
   missing code path
6. Applies to stable? **YES** - code exists in 6.15.y+

### Step 9.3: Exception Categories
Not an exception category - this is a straightforward bug fix.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Maarten Lankhorst, Acked-by
  Christian König, Link to lore
- [Phase 2] Diff analysis: ~10 lines across 3 files; changes
  `shmem_read_folio()` to `shmem_read_folio_gfp()` with optional GFP
  flags
- [Phase 2] Verified `shmem_read_folio()` is wrapper for
  `shmem_read_folio_gfp(mapping, idx, mapping_gfp_mask(mapping))` at
  include/linux/shmem_fs.h:179-182
- [Phase 3] git blame: buggy code in `ttm_backup_copy_page()` introduced
  in e7b5d23e5d470 (v6.15-rc1)
- [Phase 3] Verified existing `gfp_retry_mayfail` handling in
  `__ttm_pool_alloc()` at line 728-729 and
  `ttm_pool_restore_and_alloc()` at line 858-859 - confirms
  inconsistency
- [Phase 3] git describe: TTM backup code first appeared in v6.15-rc1
- [Phase 4] b4 mbox retrieved 12-message thread; cover letter describes
  "two small patches around gfp_retry_mayfail behaviour"
- [Phase 4] Christian König acked the series; Thomas Hellström called
  changes "completely non-controversial"
- [Phase 4] Patch 1/3 modifies different code path (independent); patch
  3/3 is kerneldoc only
- [Phase 5] `ttm_backup_copy_page()` called from
  `ttm_pool_restore_commit()` -> `ttm_pool_restore_and_alloc()` ->
  `ttm_tt_restore()` -> `xe_tt_populate()`
- [Phase 5] Verified `gfp_retry_mayfail = true` is set by Intel Xe (6
  call sites), AMD amdgpu (2 call sites), Nouveau (1 call site)
- [Phase 6] Code exists in 6.15.y+ stable trees
- [Phase 8] Failure mode: OOM killer invocation, severity HIGH

**YES**

 drivers/gpu/drm/ttm/ttm_backup.c | 6 ++++--
 drivers/gpu/drm/ttm/ttm_pool.c   | 5 ++++-
 include/drm/ttm/ttm_backup.h     | 2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
index 6bd4c123d94cd..81df4cb5606b4 100644
--- a/drivers/gpu/drm/ttm/ttm_backup.c
+++ b/drivers/gpu/drm/ttm/ttm_backup.c
@@ -44,18 +44,20 @@ void ttm_backup_drop(struct file *backup, pgoff_t handle)
  * @dst: The struct page to copy into.
  * @handle: The handle returned when the page was backed up.
  * @intr: Try to perform waits interruptible or at least killable.
+ * @additional_gfp: GFP mask to add to the default GFP mask if any.
  *
  * Return: 0 on success, Negative error code on failure, notably
  * -EINTR if @intr was set to true and a signal is pending.
  */
 int ttm_backup_copy_page(struct file *backup, struct page *dst,
-			 pgoff_t handle, bool intr)
+			 pgoff_t handle, bool intr, gfp_t additional_gfp)
 {
 	struct address_space *mapping = backup->f_mapping;
 	struct folio *from_folio;
 	pgoff_t idx = ttm_backup_handle_to_shmem_idx(handle);
 
-	from_folio = shmem_read_folio(mapping, idx);
+	from_folio = shmem_read_folio_gfp(mapping, idx, mapping_gfp_mask(mapping)
+					  | additional_gfp);
 	if (IS_ERR(from_folio))
 		return PTR_ERR(from_folio);
 
diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index c0d95559197c6..4912ab53f6f92 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -530,6 +530,8 @@ static int ttm_pool_restore_commit(struct ttm_pool_tt_restore *restore,
 		p = first_page[i];
 		if (ttm_backup_page_ptr_is_handle(p)) {
 			unsigned long handle = ttm_backup_page_ptr_to_handle(p);
+			gfp_t additional_gfp = ctx->gfp_retry_mayfail ?
+				__GFP_RETRY_MAYFAIL | __GFP_NOWARN : 0;
 
 			if (IS_ENABLED(CONFIG_FAULT_INJECTION) && ctx->interruptible &&
 			    should_fail(&backup_fault_inject, 1)) {
@@ -543,7 +545,8 @@ static int ttm_pool_restore_commit(struct ttm_pool_tt_restore *restore,
 			}
 
 			ret = ttm_backup_copy_page(backup, restore->alloced_page + i,
-						   handle, ctx->interruptible);
+						   handle, ctx->interruptible,
+						   additional_gfp);
 			if (ret)
 				break;
 
diff --git a/include/drm/ttm/ttm_backup.h b/include/drm/ttm/ttm_backup.h
index c33cba111171f..29b9c855af779 100644
--- a/include/drm/ttm/ttm_backup.h
+++ b/include/drm/ttm/ttm_backup.h
@@ -56,7 +56,7 @@ ttm_backup_page_ptr_to_handle(const struct page *page)
 void ttm_backup_drop(struct file *backup, pgoff_t handle);
 
 int ttm_backup_copy_page(struct file *backup, struct page *dst,
-			 pgoff_t handle, bool intr);
+			 pgoff_t handle, bool intr, gfp_t additional_gfp);
 
 s64
 ttm_backup_backup_page(struct file *backup, struct page *page,
-- 
2.53.0

