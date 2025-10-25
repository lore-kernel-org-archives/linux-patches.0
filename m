Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13991306D57;
	Sat, 25 Oct 2025 16:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409765; cv=none; b=JwUu/hajoJ63WlLpgXMhTDa3HLo8BYQUsqRZXQ4axwcttaEv+Bh5TMm8FlyLUgfIXtaWaQKoAzjCf0HmZBOGJnzj/72ztOH6aqAhC2NtZblNgr1wFS0A02XabgPYbWqV6+N3obC7BCb3i/JKgrxFvPtGpUTDOdl2AFAe6yhDn6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409765; c=relaxed/simple;
	bh=iLEjOrePrnNCcm+EriPerBRSpxFZ8k2d7rPiTVXus0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ac/7vdmQKc+QaZLTUWMv2PeYyALD1bHp8bk4kk9PmjXqBrIGg2elUTiMr8bDWUe/ZL110gHyRBfdAmQjHFkGXfubUAEaTkLF14Dm0MxO2t0jhn1tm8vf1PvCRZZPbZi/E/RatLVTi1JwUStZn0lDZF+FIBJXVYxms/LhBa40OSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=flyR8vLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="flyR8vLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17ABC4CEFF;
	Sat, 25 Oct 2025 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409764;
	bh=iLEjOrePrnNCcm+EriPerBRSpxFZ8k2d7rPiTVXus0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flyR8vLp+RDRauEjneDWysDC2Wsl1IU4GejFHxvp6UrsDgZ2SDLSk0ECfTyU/Pukp
	 YUa+bemjeT5bFvtsEL2OyVdPnH5JaNn5V3IzApCXaxuT/sunOTU7PzzpHLU/9j/5Gc
	 3sxK5GiYfclKyHakNBXmahRRLlS74HeVnS87u+rlVXfB4p3eA5raiwQS8YmaJa4RO8
	 QJ542F6WVkL8HMAT8tF3SFQs6xICIan6bck0NZEwoFI10LvPXMtZsYDPZ+2IKrlKsM
	 9RTPUolGkkWqAelVAY/9aDo7NKC/Iylq9hvSvM2oY+8dBZ/HORwNaB7IOXx3LRNdsR
	 9Bn44ECoP6ZmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maarten Lankhorst <dev@lankhorst.se>,
	Matthew Auld <matthew.auld@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.12] drm/xe: Fix oops in xe_gem_fault when running core_hotunplug test.
Date: Sat, 25 Oct 2025 12:01:25 -0400
Message-ID: <20251025160905.3857885-454-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maarten Lankhorst <dev@lankhorst.se>

[ Upstream commit 1cda3c755bb7770be07d75949bb0f45fb88651f6 ]

I saw an oops in xe_gem_fault when running the xe-fast-feedback
testlist against the realtime kernel without debug options enabled.

The panic happens after core_hotunplug unbind-rebind finishes.
Presumably what happens is that a process mmaps, unlocks because
of the FAULT_FLAG_RETRY_NOWAIT logic, has no process memory left,
causing ttm_bo_vm_dummy_page() to return VM_FAULT_NOPAGE, since
there was nothing left to populate, and then oopses in
"mem_type_is_vram(tbo->resource->mem_type)" because tbo->resource
is NULL.

It's convoluted, but fits the data and explains the oops after
the test exits.

Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250715152057.23254-2-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**What It Fixes**
- Prevents a NULL pointer dereference in `xe_gem_fault()` that can
  trigger after a device unbind/rebind (core_hotunplug) when the VM
  fault path takes the “device absent” branch and later tries to access
  `tbo->resource->mem_type`.
- Matches the failure described in the commit message: after hot-unplug
  test, a process faults with `FAULT_FLAG_RETRY_NOWAIT`, the fallback
  `ttm_bo_vm_dummy_page()` returns `VM_FAULT_NOPAGE`, and the code
  oopses at `mem_type_is_vram(tbo->resource->mem_type)` because
  `tbo->resource` is NULL.

**Code-Level Analysis**
- Current code (pre-fix) in `xe_gem_fault`:
  - Calls the reserved fault path when the device is present, else uses
    the dummy-page fallback:
    - `drivers/gpu/drm/xe/xe_bo.c:1218` calls
      `ttm_bo_vm_fault_reserved(...)` under `drm_dev_enter`.
    - `drivers/gpu/drm/xe/xe_bo.c:1222` calls
      `ttm_bo_vm_dummy_page(...)` when `drm_dev_enter` fails (device not
      present).
  - After that, it unconditionally evaluates:
    - `if (ret == VM_FAULT_RETRY && !(vmf->flags &
      FAULT_FLAG_RETRY_NOWAIT)) goto out;` at
      `drivers/gpu/drm/xe/xe_bo.c:1225`.
    - And crucially, `if (ret == VM_FAULT_NOPAGE &&
      mem_type_is_vram(tbo->resource->mem_type)) { ... }` at
      `drivers/gpu/drm/xe/xe_bo.c:1230`.
  - This latter check runs even when `ret` came from the dummy-page
    path, where the BO’s `resource` may be NULL (device unbound),
    causing a NULL deref.
- The proposed patch moves:
  - The `VM_FAULT_RETRY` early-exit and the `VM_FAULT_NOPAGE` VRAM-
    userfault list insert into the `drm_dev_enter` branch, i.e., only
    after a successful `ttm_bo_vm_fault_reserved(...)`.
  - This prevents dereferencing `tbo->resource` in the dummy-page path
    (device absent case), eliminating the oops.
- Supporting detail: `ttm_bo_vm_dummy_page()` implementation shows it
  can return fault codes without involving BO resources, e.g.,
  `VM_FAULT_OOM/NOPAGE` paths tied to `vmf_insert_pfn_prot` prefault
  behavior, reinforcing that the post-fault `resource`-based logic must
  not run in the dummy-page branch:
  - See `drivers/gpu/drm/ttm/ttm_bo_vm.c:291` (function body around
    291–340).
- The VRAM userfault list is used on RPM suspend to release mmap offsets
  for VRAM BOs (so it’s only meaningful when the device is present and
  the BO is bound):
  - See use in `drivers/gpu/drm/xe/xe_pm.c:404`.

**Why This Is a Bugfix Suitable for Stable**
- User-visible crash: This is a kernel oops/NULL deref triggered by
  realistic sequences (hot-unplug + mmap + memory pressure), i.e.,
  affects users and CI (“xe-fast-feedback core_hotunplug”).
- Small, localized change: Only `xe_gem_fault()` is touched; logic is
  refined to run VRAM/userfault tracking only when the device is present
  and the reserved fault path was used.
- No architectural changes: No ABI/UAPI or subsystem redesign; behavior
  is strictly a correctness fix.
- Low regression risk:
  - The `VM_FAULT_RETRY` early-return remains aligned with TTM’s
    reservation-lock semantics, now gated to the only path that can
    actually return `RETRY` in practice (the reserved path). The dummy-
    page path does not reasonably return `RETRY`.
  - The VRAM userfault list manipulation is unchanged, just constrained
    to valid context (device present, `resource` reliably valid).
- Clear root cause: Unconditional deref of `tbo->resource->mem_type`
  after a dummy-page fallback when device is absent. The patch removes
  that invalid deref path.

**Historical Context**
- The problematic post-fault VRAM/userfault logic was introduced when
  adding RPM suspend handling for mmap offsets:
  - `drivers/gpu/drm/xe/xe_bo.c:1230` is attributed to commit
    “drm/xe/dgfx: Release mmap mappings on rpm suspend”
    (`fa78e188d8d1d`, 2024-01), per blame.
- The fix cleanly corrects that regression by scoping the check
  appropriately.

**Security/Impact**
- NULL pointer deref → kernel panic/DoS; user processes that mmap BOs
  can trigger the faulty path under hot-unplug and low-memory
  conditions. Fixing this improves system robustness and reliability.

**Backport Considerations**
- Patch is self-contained to `drivers/gpu/drm/xe/xe_bo.c`.
- Dependencies are already present (e.g., `vram_userfault`
  struct/lock/list, `mem_type_is_vram`, `ttm_bo_vm_*` helpers).
- Applies to stable series that include the Xe driver and the RPM/mmap
  suspend changes (post early 2024). Older LTS without Xe or without
  that change are unaffected.

Given it fixes a real crash with minimal, targeted changes and no
feature additions, this is a strong candidate for stable backport.

 drivers/gpu/drm/xe/xe_bo.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 50c79049ccea0..d07e23eb1a54d 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1711,22 +1711,26 @@ static vm_fault_t xe_gem_fault(struct vm_fault *vmf)
 		ret = ttm_bo_vm_fault_reserved(vmf, vmf->vma->vm_page_prot,
 					       TTM_BO_VM_NUM_PREFAULT);
 		drm_dev_exit(idx);
+
+		if (ret == VM_FAULT_RETRY &&
+		    !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
+			goto out;
+
+		/*
+		 * ttm_bo_vm_reserve() already has dma_resv_lock.
+		 */
+		if (ret == VM_FAULT_NOPAGE &&
+		    mem_type_is_vram(tbo->resource->mem_type)) {
+			mutex_lock(&xe->mem_access.vram_userfault.lock);
+			if (list_empty(&bo->vram_userfault_link))
+				list_add(&bo->vram_userfault_link,
+					 &xe->mem_access.vram_userfault.list);
+			mutex_unlock(&xe->mem_access.vram_userfault.lock);
+		}
 	} else {
 		ret = ttm_bo_vm_dummy_page(vmf, vmf->vma->vm_page_prot);
 	}
 
-	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
-		goto out;
-	/*
-	 * ttm_bo_vm_reserve() already has dma_resv_lock.
-	 */
-	if (ret == VM_FAULT_NOPAGE && mem_type_is_vram(tbo->resource->mem_type)) {
-		mutex_lock(&xe->mem_access.vram_userfault.lock);
-		if (list_empty(&bo->vram_userfault_link))
-			list_add(&bo->vram_userfault_link, &xe->mem_access.vram_userfault.list);
-		mutex_unlock(&xe->mem_access.vram_userfault.lock);
-	}
-
 	dma_resv_unlock(tbo->base.resv);
 out:
 	if (needs_rpm)
-- 
2.51.0

