Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522CF1D88B4;
	Tue, 28 Oct 2025 00:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612031; cv=none; b=k77rgU7lGjNXYomUJrsmKfpKkfx4+LYRAjRIRyZJgWYnX6YBjhSt/Cym8LDS8iSvfnQD3XCBpqhoWIfkjOaUyhZYfyjXdIMA78bsOwiE4zv9+g2G/7a0ZIAyRbijJG4PoRAlW//V2snzr3Q/SkZPIVFY8cd5d2LKL2nJa1PhcGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612031; c=relaxed/simple;
	bh=lpgXbS9MZIaqsP8tjC0zw1dQwPEtQ1E6gyoovqakvdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HfBVN7UBjrNfUVN179D58vldytMRa6PZNbxrsKrmfjJ0Icd2OpPLPXjo3EYde+S+CGe8fIfeclEI785u+MyWGZRwM/DAlg8Qn69Ub5ffC/3YJiR8CEGVJrA2EhPJiXBlICZVxS76NjoF4ru3AY5fMd/PE/UXm1SMQUk9wpXw6tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgpX6nLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgpX6nLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C600C4CEF1;
	Tue, 28 Oct 2025 00:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761612030;
	bh=lpgXbS9MZIaqsP8tjC0zw1dQwPEtQ1E6gyoovqakvdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgpX6nLM5DjtQzN4SKfchZhWpCEBjTOq0rzlhUvFhUj/aOwQPeDKYQUrGvTG+MvRf
	 qwr8mXxemvdCppkP9cgx7SmR+NpyH/V5owMMxK5BOISyyLX99ZUfa/iUyTSZ+OfUa5
	 A1FsHaVkCF6H1ASsve68wzU28ELfw3vG3uOkuiJjyXqLRhhvis0BmJaJFdeYf5vEzu
	 Gs2Gwg+AbaeKSQlzM3WgJ1SQqkDwmlLhQjzqStsK7b8GgF80psvbhkWOhrg30cXak9
	 yVXdotnui/bgWENtknTkmulNSX1RiVnym5TA+pT1Op6MTQE/8W6CWWEDci9TvgYl5F
	 zI4Kg/sZeCTFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Jesse.Zhang" <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	srinivasan.shanmugam@amd.com,
	sunil.khatri@amd.com,
	Arunpravin.PaneerSelvam@amd.com,
	Tong.Liu01@amd.com,
	tvrtko.ursulin@igalia.com,
	alexandre.f.demers@gmail.com,
	mario.limonciello@amd.com,
	Prike.Liang@amd.com,
	shashank.sharma@amd.com,
	vitaly.prosyak@amd.com,
	Victor.Skvortsov@amd.com,
	Hawking.Zhang@amd.com,
	Shravankumar.Gande@amd.com,
	mtodorovac69@gmail.com,
	xiang.liu@amd.com,
	shaoyun.liu@amd.com,
	Tony.Yi@amd.com
Subject: [PATCH AUTOSEL 6.17-6.1] drm/amdgpu: Fix NULL pointer dereference in VRAM logic for APU devices
Date: Mon, 27 Oct 2025 20:39:04 -0400
Message-ID: <20251028003940.884625-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028003940.884625-1-sashal@kernel.org>
References: <20251028003940.884625-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: "Jesse.Zhang" <Jesse.Zhang@amd.com>

[ Upstream commit 883f309add55060233bf11c1ea6947140372920f ]

Previously, APU platforms (and other scenarios with uninitialized VRAM managers)
triggered a NULL pointer dereference in `ttm_resource_manager_usage()`. The root
cause is not that the `struct ttm_resource_manager *man` pointer itself is NULL,
but that `man->bdev` (the backing device pointer within the manager) remains
uninitialized (NULL) on APUs—since APUs lack dedicated VRAM and do not fully
set up VRAM manager structures. When `ttm_resource_manager_usage()` attempts to
acquire `man->bdev->lru_lock`, it dereferences the NULL `man->bdev`, leading to
a kernel OOPS.

1. **amdgpu_cs.c**: Extend the existing bandwidth control check in
   `amdgpu_cs_get_threshold_for_moves()` to include a check for
   `ttm_resource_manager_used()`. If the manager is not used (uninitialized
   `bdev`), return 0 for migration thresholds immediately—skipping VRAM-specific
   logic that would trigger the NULL dereference.

2. **amdgpu_kms.c**: Update the `AMDGPU_INFO_VRAM_USAGE` ioctl and memory info
   reporting to use a conditional: if the manager is used, return the real VRAM
   usage; otherwise, return 0. This avoids accessing `man->bdev` when it is
   NULL.

3. **amdgpu_virt.c**: Modify the vf2pf (virtual function to physical function)
   data write path. Use `ttm_resource_manager_used()` to check validity: if the
   manager is usable, calculate `fb_usage` from VRAM usage; otherwise, set
   `fb_usage` to 0 (APUs have no discrete framebuffer to report).

This approach is more robust than APU-specific checks because it:
- Works for all scenarios where the VRAM manager is uninitialized (not just APUs),
- Aligns with TTM's design by using its native helper function,
- Preserves correct behavior for discrete GPUs (which have fully initialized
  `man->bdev` and pass the `ttm_resource_manager_used()` check).

v4: use ttm_resource_manager_used(&adev->mman.vram_mgr.manager) instead of checking the adev->gmc.is_app_apu flag (Christian)

Reviewed-by: Christian König <christian.koenig@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## BACKPORT RECOMMENDATION: **YES**

### Analysis Summary

I performed comprehensive semantic code analysis using the available MCP
tools to evaluate this NULL pointer dereference fix for APU devices.

---

### 1. SEMANTIC TOOLS USED

**Function Analysis:**
- `mcp__semcode__find_function`: Located all 3 affected functions and
  `ttm_resource_manager_usage()`
- `mcp__semcode__find_callers`: Traced call graphs to determine user-
  space exposure
- `mcp__semcode__find_type`: Examined `ttm_resource_manager` structure
  to understand the root cause

**Call Graph Analysis Results:**
- `amdgpu_info_ioctl`: **0 callers** (it's a top-level ioctl handler) →
  **DIRECTLY USER-SPACE EXPOSED**
  (drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c:613)
- `amdgpu_cs_get_threshold_for_moves`: Called by `amdgpu_cs_parser_bos`
  → called by `amdgpu_cs_ioctl` → **USER-SPACE EXPOSED** via command
  submission ioctl (drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c:702)
- `amdgpu_virt_write_vf2pf_data`: Called by SRIOV virtualization code →
  potentially **USER-SPACE TRIGGERABLE** in virtualized environments
  (drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c:576)
- `ttm_resource_manager_usage`: **18 callers across multiple drivers**
  (amdgpu, radeon, nouveau, xe)

---

### 2. ROOT CAUSE ANALYSIS

The bug occurs in `ttm_resource_manager_usage()` at
drivers/gpu/drm/ttm/ttm_resource.c:586-594:

```c
uint64_t ttm_resource_manager_usage(struct ttm_resource_manager *man)
{
    uint64_t usage;
    spin_lock(&man->bdev->lru_lock);  // ← NULL DEREFERENCE HERE
    usage = man->usage;
    spin_unlock(&man->bdev->lru_lock);
    return usage;
}
```

**Why it happens:** On APU devices, the VRAM manager structure exists
but `man->bdev` (backing device pointer) is **NULL** because APUs don't
have dedicated VRAM and don't fully initialize VRAM manager structures.
The `ttm_resource_manager_used()` check returns false when
`man->use_type` is false, indicating the manager is not actually in use.

---

### 3. USER-SPACE EXPOSURE & IMPACT SCOPE

**CRITICAL FINDING:** All three affected code paths are user-space
triggerable:

1. **amdgpu_kms.c:760** (`AMDGPU_INFO_VRAM_USAGE` ioctl case):
   - Any userspace program can call this ioctl to query VRAM usage
   - On APUs, this triggers NULL deref → **KERNEL CRASH**

2. **amdgpu_cs.c:711** (command submission path):
   - Called during GPU command buffer submission
   - Normal GPU applications (games, compute workloads) trigger this
   - On APUs, attempting to use GPU triggers NULL deref → **KERNEL
     CRASH**

3. **amdgpu_virt.c:601** (SRIOV path):
   - Affects virtualized APU environments
   - Less common but still user-triggerable

**Affected Platforms:** All AMD APU devices (Ryzen with integrated
graphics, etc.) - **widely deployed hardware**

---

### 4. FIX COMPLEXITY & DEPENDENCIES

**Fix Complexity:** **VERY SIMPLE**
- Only adds conditional checks:
  `ttm_resource_manager_used(&adev->mman.vram_mgr.manager) ? ... : 0`
- No behavioral changes for discrete GPUs
- No new functions or data structures
- Changes span only 3 files, 3 locations

**Dependency Analysis:**
```c
static inline bool ttm_resource_manager_used(struct ttm_resource_manager
*man)
{
    return man->use_type;
}
```
This function has existed since **August 2020** (commit b2458726b38cb)
when TTM resource management was refactored. It's available in all
stable kernels that would be backport candidates.

---

### 5. SEMANTIC CHANGE ASSESSMENT

**Code Changes Analysis:**

1. **amdgpu_cs.c:711** - Extends existing early-return check:
  ```c
   - if (!adev->mm_stats.log2_max_MBps) {
   + if ((!adev->mm_stats.log2_max_MBps) ||
!ttm_resource_manager_used(&adev->mman.vram_mgr.manager)) {
   ```
   **Effect:** Returns 0 for migration thresholds on APUs (correct
behavior - no VRAM to migrate)

2. **amdgpu_kms.c:760 & 807** - Conditional usage query:
  ```c
   - ui64 = ttm_resource_manager_usage(&adev->mman.vram_mgr.manager);
   + ui64 = ttm_resource_manager_used(&adev->mman.vram_mgr.manager) ?
   +     ttm_resource_manager_usage(&adev->mman.vram_mgr.manager) : 0;
   ```
   **Effect:** Reports 0 VRAM usage for APUs (correct - APUs have no
dedicated VRAM)

3. **amdgpu_virt.c:601** - Similar conditional for fb_usage reporting

**Side Effects:** NONE for discrete GPUs. APUs now correctly report 0
instead of crashing.

---

### 6. BACKPORT SUITABILITY CRITERIA

✅ **Fixes important bug:** NULL pointer dereference → kernel crash
✅ **Affects users:** All AMD APU users (widespread hardware)
✅ **User-space triggerable:** Via standard ioctl calls
✅ **Small and contained:** 3 files, simple conditional checks
✅ **No architectural changes:** Uses existing TTM infrastructure
✅ **Low regression risk:** Only affects APUs, changes are defensive
✅ **No new features:** Pure bug fix
✅ **Dependencies satisfied:** Helper function available since 2020
✅ **Confined to subsystem:** Only affects amdgpu driver

---

### 7. STABLE TREE COMPLIANCE

**Bug Fix:** ✅ YES - Fixes NULL pointer dereference
**New Feature:** ❌ NO - Only defensive checks
**Security Fix:** ⚠️ POTENTIAL - DoS via user-triggerable kernel crash
**Performance Optimization:** ❌ NO
**Architectural Change:** ❌ NO

---

### 8. MISSING TAGS OBSERVATION

**Notable:** This commit lacks standard stable tree indicators:
- No `Fixes:` tag (should reference when the bug was introduced)
- No `Cc: stable@vger.kernel.org` tag

However, the commit message clearly describes a NULL pointer dereference
fix, which is a critical bug that warrants backporting regardless of
missing tags.

---

### FINAL RECOMMENDATION

**BACKPORT: YES** - This is a **HIGH PRIORITY** backport candidate
because:

1. **Severity:** Kernel crash (NULL pointer dereference) affecting all
   APU users
2. **Exposure:** User-space triggerable via common ioctl paths
3. **Risk:** Low - simple defensive checks with no behavioral changes
   for working systems
4. **Scope:** Affects widely-deployed AMD APU hardware
5. **Fix Quality:** Clean, minimal, uses existing TTM infrastructure

The fix should be backported to all active stable kernel trees
supporting AMD APU devices (likely 5.10+).

 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c   | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c  | 7 ++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index d3f220be2ef9a..2a142e9e97384 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -714,7 +714,7 @@ static void amdgpu_cs_get_threshold_for_moves(struct amdgpu_device *adev,
 	 */
 	const s64 us_upper_bound = 200000;
 
-	if (!adev->mm_stats.log2_max_MBps) {
+	if ((!adev->mm_stats.log2_max_MBps) || !ttm_resource_manager_used(&adev->mman.vram_mgr.manager)) {
 		*max_bytes = 0;
 		*max_vis_bytes = 0;
 		return;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 8a76960803c65..8162f7f625a86 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -758,7 +758,8 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 		ui64 = atomic64_read(&adev->num_vram_cpu_page_faults);
 		return copy_to_user(out, &ui64, min(size, 8u)) ? -EFAULT : 0;
 	case AMDGPU_INFO_VRAM_USAGE:
-		ui64 = ttm_resource_manager_usage(&adev->mman.vram_mgr.manager);
+		ui64 = ttm_resource_manager_used(&adev->mman.vram_mgr.manager) ?
+			ttm_resource_manager_usage(&adev->mman.vram_mgr.manager) : 0;
 		return copy_to_user(out, &ui64, min(size, 8u)) ? -EFAULT : 0;
 	case AMDGPU_INFO_VIS_VRAM_USAGE:
 		ui64 = amdgpu_vram_mgr_vis_usage(&adev->mman.vram_mgr);
@@ -804,8 +805,8 @@ int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 		mem.vram.usable_heap_size = adev->gmc.real_vram_size -
 			atomic64_read(&adev->vram_pin_size) -
 			AMDGPU_VM_RESERVED_VRAM;
-		mem.vram.heap_usage =
-			ttm_resource_manager_usage(vram_man);
+		mem.vram.heap_usage = ttm_resource_manager_used(&adev->mman.vram_mgr.manager) ?
+				ttm_resource_manager_usage(vram_man) : 0;
 		mem.vram.max_allocation = mem.vram.usable_heap_size * 3 / 4;
 
 		mem.cpu_accessible_vram.total_heap_size =
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 13f0cdeb59c46..e13bf2345ef5c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -598,8 +598,8 @@ static int amdgpu_virt_write_vf2pf_data(struct amdgpu_device *adev)
 	vf2pf_info->driver_cert = 0;
 	vf2pf_info->os_info.all = 0;
 
-	vf2pf_info->fb_usage =
-		ttm_resource_manager_usage(&adev->mman.vram_mgr.manager) >> 20;
+	vf2pf_info->fb_usage = ttm_resource_manager_used(&adev->mman.vram_mgr.manager) ?
+		 ttm_resource_manager_usage(&adev->mman.vram_mgr.manager) >> 20 : 0;
 	vf2pf_info->fb_vis_usage =
 		amdgpu_vram_mgr_vis_usage(&adev->mman.vram_mgr) >> 20;
 	vf2pf_info->fb_size = adev->gmc.real_vram_size >> 20;
-- 
2.51.0

