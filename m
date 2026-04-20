Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB556428466;
	Mon, 20 Apr 2026 13:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691765; cv=none; b=NkZ29NQSCUrhPJtSm08PQ98ljoeCTUWElkYoBzOsWDBEkUp1h7BHGDNqm+ZzeofHwrSYN1Q7nuJi1cgD/wi+ywh7WPN5FvF4+PyPQBSMHA7cSqt4I1dXbgICLeFgkN+CzizhDSxfNY7uZNnI3YCbEzwa9Vkoc4bZtdYqPo4Hrck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691765; c=relaxed/simple;
	bh=oI99Me11juO6U/qs+YD75RChtL2ON3Jdrj6X3XBNw6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SgDtx90eAHFXBIvIrZNKvc16BCbjXNS9a/KGU1XHfX86rDZE+woyPncQL2tfOG46UB0aVDoLugswlvMw8a014LyjCR9m9gMnSnZboUHTVKfYkH/6ctfCeBOIGuXnWZbu5rCqEyPtmzNh6Nlyxru76R7m9AdtlVic6B+NRyzk/rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4z1v5v5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4z1v5v5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C36C2BCC4;
	Mon, 20 Apr 2026 13:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691765;
	bh=oI99Me11juO6U/qs+YD75RChtL2ON3Jdrj6X3XBNw6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4z1v5v51Gk+sAVs5coytH0CY/YQcNO4S8QsJD4GGFZTTmtkDcpE1+I1070t26pBb
	 nXRfiEISMPAVdENAf/lmEx56ljTNKvArd4o3RvTTYtS25M9qkeM5FIPZYKPCwgnlY8
	 iT5m9n5B3uzIXGU4Zhw1aDuz7t3ji2qtSfXE6q8ZIR4yCV5ohJgZ/DJZGbmfRwNuJe
	 9heqhXWKsfudLP402bO0FzlaZBX7dLrpBbDIu5LNMGQHvaq7jXGiUN5TOHrMiUX3Gf
	 gocqWf8+pN/8PFAmfMFxh75IN8nwvOfqoGxhiEzYAG0ePBgIigRMD48xrYj+SG69hR
	 QvJk8pbqUzOkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amdgpu: fix syncobj leak for amdgpu_gem_va_ioctl()
Date: Mon, 20 Apr 2026 09:19:34 -0400
Message-ID: <20260420132314.1023554-180-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
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

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit a0f0b6d31a53a7607ed44f7623faafc628333258 ]

It requires freeing the syncobj and chain
alloction resource.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The 7.0 tree doesn't have `(!adev->debug_vm || timeline_syncobj)` — it
has `!adev->debug_vm`. This confirms the diff was created against a
newer mainline. The fix's core logic still applies.

---

## Complete Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amdgpu`
- Action verb: "fix"
- Summary: Fix syncobj and chain allocation resource leak in
  amdgpu_gem_va_ioctl()
- Record: [drm/amdgpu] [fix] [syncobj/chain resource leak in gem VA
  ioctl]

**Step 1.2: Tags**
- `Reviewed-by: Christian König <christian.koenig@amd.com>` — subsystem
  co-maintainer
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` — AMD GPU
  maintainer committed it
- `Signed-off-by: Prike Liang <Prike.Liang@amd.com>` — AMD engineer,
  author
- No Fixes: tag, no Reported-by:, no Cc: stable — expected for manual
  review candidates
- Record: Reviewed by Christian König (DRM/amdgpu co-maintainer).
  Committed by Alex Deucher.

**Step 1.3: Commit Body**
- Describes: "requires freeing the syncobj and chain allocation
  resource"
- Bug: syncobj refcount and chain memory are never released after use
- Failure mode: resource/memory leak on every ioctl call with timeline
  syncobj
- Record: Clear resource leak. Every call to the ioctl with timeline
  syncobj leaks memory.

**Step 1.4: Hidden Bug Fixes**
- This is NOT hidden — it explicitly says "fix...leak"
- Record: Explicit bug fix.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files: `drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c` only
- Changes: +5 lines added (3 in ioctl cleanup, 1 NULL assignment in
  helper, 1 NULL assignment in ioctl)
- Functions modified: `amdgpu_gem_update_timeline_node()` and
  `amdgpu_gem_va_ioctl()`
- Record: Single-file surgical fix, 5 meaningful lines added.

**Step 2.2: Code Flow Changes**

Hunk 1 — `amdgpu_gem_update_timeline_node()`:
- BEFORE: When `dma_fence_chain_alloc()` fails, calls
  `drm_syncobj_put(*syncobj)` and returns -ENOMEM, leaving `*syncobj` as
  a dangling pointer.
- AFTER: Also sets `*syncobj = NULL` to prevent dangling pointer.

Hunk 2 — `amdgpu_gem_va_ioctl()`:
- BEFORE: After `drm_syncobj_add_point()` consumes `timeline_chain`,
  `timeline_chain` still points to consumed memory. The `error:` label
  never frees `timeline_chain` or puts `timeline_syncobj`.
- AFTER: Sets `timeline_chain = NULL` after consumption. Adds
  `dma_fence_chain_free(timeline_chain)` and
  `drm_syncobj_put(timeline_syncobj)` to cleanup.

**Step 2.3: Bug Mechanism**
- Category: **Resource leak** (syncobj refcount leak + memory leak)
- `drm_syncobj_find()` increments refcount — never decremented by caller
- `dma_fence_chain_alloc()` allocates memory — never freed when not
  consumed
- Record: Missing cleanup for refcounted object and allocated memory on
  both success and error paths.

**Step 2.4: Fix Quality**
- Obviously correct: adds standard cleanup patterns (NULL-after-consume,
  free/put at error label)
- Minimal and surgical: 5 meaningful lines
- No regression risk: `dma_fence_chain_free(NULL)` = `kfree(NULL)` is
  safe; `drm_syncobj_put` is guarded by NULL check
- Record: High quality, zero regression risk.

### PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- `amdgpu_gem_update_timeline_node` — introduced by `70773bef4e091f`
  (Arvind Yadav, Sep 2024)
- Timeline call moved before switch by `ad6c120f688803` (Feb 2025, "fix
  the memleak caused by fence not released")
- Inline timeline handling in ioctl by `bd8150a1b3370` (Dec 2025, v4
  refactor)
- Record: Buggy code introduced in 70773bef4e091f, worsened by
  ad6c120f688803 which moved allocation before switch but didn't add
  cleanup.

**Step 3.2: Fixes tag**
- No Fixes: tag present. Based on analysis, the bug was introduced in
  `70773bef4e091f` and never had proper cleanup.
- Record: Bug exists since original timeline code introduction.

**Step 3.3: File History**
- 31 commits since `ad6c120f688803`. Active file with many recent
  changes.
- The v4 refactor (`bd8150a1b3370`) and v7 refactor (`efdc66fe12b07`)
  touched the same code but neither added cleanup.
- Record: Standalone fix, no prerequisites beyond code already in 7.0
  tree.

**Step 3.4: Author**
- Prike Liang: AMD engineer, regular contributor to amdgpu driver with
  multiple recent fixes.
- Record: Active AMD GPU developer, credible author.

**Step 3.5: Dependencies**
- None. The fix only adds cleanup to existing code paths. All referenced
  functions exist in 7.0.
- Minor context conflict: mainline has `(!adev->debug_vm ||
  timeline_syncobj)` vs 7.0's `!adev->debug_vm`, but the fix's added
  lines don't depend on this condition.
- Record: Standalone fix, minor context adjustment needed.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.5:**
- b4 dig could not find the original patch submission (lore.kernel.org
  blocked by Anubis).
- The related commit `ad6c120f688803` explicitly described the memleak
  problem with a full stack trace showing BUG in drm_sched_fence slab
  during module unload — evidence the leak has real impact.
- Christian König (co-maintainer) reviewed the fix.
- Record: Could not access lore. However, reviewer is the subsystem co-
  maintainer, which is strong endorsement.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4:**
- `amdgpu_gem_va_ioctl()` is a DRM ioctl handler directly callable from
  userspace
- Called every time userspace maps/unmaps GPU virtual address space
- This is a HOT path for GPU applications (Mesa, AMDVLK, ROCm)
- Every call with a timeline syncobj leaks the syncobj refcount and
  potentially the chain allocation
- Record: Ioctl path reachable from any GPU userspace application. Very
  high call frequency.

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The buggy code exists in 7.0 tree. Confirmed via blame:
`70773bef4e091f` (Sep 2024) and `ad6c120f688803` (Feb 2025) are both
present.

**Step 6.2:** Minor context conflict due to condition difference in line
979. Would need a trivial backport adjustment, or `git apply --3way`
could handle it.

**Step 6.3:** No related fix already in stable for this specific leak.

### PHASE 7: SUBSYSTEM CONTEXT

- Subsystem: `drivers/gpu/drm/amd/amdgpu` — GPU driver
- Criticality: IMPORTANT — AMD GPUs are extremely common in desktops,
  servers, and workstations
- Active subsystem with frequent changes
- Record: [IMPORTANT] AMD GPU driver, widely used hardware.

### PHASE 8: IMPACT AND RISK

**Step 8.1:** Affected users: All users with AMD GPUs using
userqueue/timeline syncobj features (Mesa Vulkan, ROCm).

**Step 8.2:** Trigger: Any GPU application calling the VA ioctl with a
timeline syncobj. Repeated calls (normal GPU operation) cause cumulative
memory leak.

**Step 8.3:** Failure mode: Memory leak in hot ioctl path → eventual OOM
under sustained GPU workloads. Severity: **HIGH** (gradual resource
exhaustion).

**Step 8.4:**
- BENEFIT: High — prevents memory leak in frequently-called GPU ioctl
- RISK: Very low — 5-line fix adding standard NULL-and-free patterns,
  reviewed by subsystem maintainer
- Record: High benefit, very low risk.

### PHASE 9: SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real resource leak (syncobj refcount + chain memory) in a
  userspace-facing ioctl
- Every call with timeline syncobj leaks resources — cumulative, leads
  to OOM under sustained use
- Small, surgical fix: 5 meaningful lines in a single file
- Reviewed by Christian König (DRM/amdgpu co-maintainer)
- Obviously correct: standard cleanup patterns (NULL-after-consume,
  free/put at cleanup label)
- Bug code exists in 7.0 tree (confirmed via blame)
- Zero regression risk: `kfree(NULL)` is safe, NULL checks guard all
  puts

**Evidence AGAINST backporting:**
- Minor context conflict (condition text differs between mainline and
  7.0) — trivially resolvable
- Timeline syncobj feature is relatively new (Sep 2024) — may not affect
  all users yet

**Stable rules checklist:**
1. Obviously correct and tested? **YES** — standard cleanup pattern,
   reviewed by co-maintainer
2. Fixes a real bug? **YES** — resource leak in ioctl path
3. Important issue? **YES** — memory leak in hot path → eventual OOM
4. Small and contained? **YES** — 5 lines, single file
5. No new features? **YES** — only adds missing cleanup
6. Can apply to stable? **YES** — with minor context adjustment

### Verification

- [Phase 1] Parsed tags: Reviewed-by Christian König (co-maintainer),
  SOB Alex Deucher (maintainer)
- [Phase 2] Diff analysis: 5 lines added — NULL assignment in helper
  error path, NULL assignment after chain consumption, 3-line cleanup in
  error label (chain free + syncobj put)
- [Phase 3] git blame: timeline code introduced in 70773bef4e091f (Sep
  2024), moved by ad6c120f688803 (Feb 2025), both in 7.0 tree
- [Phase 3] git show ad6c120f688803: confirmed this commit moved
  timeline allocation before switch without adding cleanup — the root
  cause
- [Phase 3] git show bd8150a1b3370: v4 refactor inlined timeline
  handling, still no cleanup
- [Phase 3] git show efdc66fe12b07: v7 refactor, still no cleanup
- [Phase 5] amdgpu_gem_va_ioctl is DRM ioctl handler — directly callable
  from userspace, hot path for GPU apps
- [Phase 5] Confirmed drm_syncobj_add_point() consumes chain
  (dma_fence_chain_init + rcu_assign_pointer), so NULL-after-use is
  correct
- [Phase 5] Confirmed dma_fence_chain_free(NULL) is safe (just
  kfree(NULL))
- [Phase 6] Verified no drm_syncobj_put(timeline_syncobj) in current 7.0
  file — bug confirmed present
- [Phase 6] Minor context conflict: 7.0 has `!adev->debug_vm`, mainline
  has `(!adev->debug_vm || timeline_syncobj)` — needs trivial adjustment
- [Phase 8] Failure mode: cumulative memory/refcount leak → eventual
  OOM, severity HIGH
- UNVERIFIED: Could not access lore.kernel.org for original patch
  discussion (blocked by Anubis)

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index c4839cf2dce37..3f95aca700264 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -107,6 +107,7 @@ amdgpu_gem_update_timeline_node(struct drm_file *filp,
 	*chain = dma_fence_chain_alloc();
 	if (!*chain) {
 		drm_syncobj_put(*syncobj);
+		*syncobj = NULL;
 		return -ENOMEM;
 	}
 
@@ -983,6 +984,7 @@ int amdgpu_gem_va_ioctl(struct drm_device *dev, void *data,
 						      timeline_chain,
 						      fence,
 						      args->vm_timeline_point);
+				timeline_chain = NULL;
 			}
 		}
 		dma_fence_put(fence);
@@ -990,6 +992,9 @@ int amdgpu_gem_va_ioctl(struct drm_device *dev, void *data,
 	}
 
 error:
+	dma_fence_chain_free(timeline_chain);
+	if (timeline_syncobj)
+		drm_syncobj_put(timeline_syncobj);
 	drm_exec_fini(&exec);
 error_put_gobj:
 	drm_gem_object_put(gobj);
-- 
2.53.0

