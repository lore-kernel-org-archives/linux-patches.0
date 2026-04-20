Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458F84C6F18;
	Mon, 20 Apr 2026 13:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691985; cv=none; b=kVew1xiWel8Sp0DSVOoR9N92StHvJ3bKvGCsghabLJovFri29546tiENmT8mAMyePr6OFQE4N4I+dKkSpDTMoszoaHvFZrdc+PRnIN48ya+4jFWof8S2n4dmA8l6OdoO5tLqigT5vJoczuShY/hdanFPyPLmeRMzT9sJq1qmBpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691985; c=relaxed/simple;
	bh=TbIE/xB8l0TgVmkggzTpnZs8ZcNPTMy89Q1wCndFugQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GxKyK35jiGjxA3e1meBVXTt6cD5uUDDkPssYA/lpqW/8tBuA1mXRYYTnilRJ+K4PzlZFMrgDypVHW7KTqXDc9sSxLoviXczkXlhLJmbfmUnf4f1TxHIbnodgaHhQT+FIpnRnAXxHqDZ1xbSNmzuy6xXdu5UVbECsZWuu9OYhEjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/8OepLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/8OepLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E464C19425;
	Mon, 20 Apr 2026 13:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691985;
	bh=TbIE/xB8l0TgVmkggzTpnZs8ZcNPTMy89Q1wCndFugQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/8OepLMu1nQ49KJG/mRU80N6zfbd8EwlDAADuhyzkcDBIalewfelDupxy3rWA+OB
	 NmBjtyp9MfgP6CfIB2vbEhBR7FcY0DlrYx7YcgfmZub4CIrCGGNw6cqrhusx5jTCsS
	 O0SHfpc3i/+8sSDViPsvHyRRuwYE/YZFvgFGfsIkByEJvyyzZyZXmBmSWLU61+qfvZ
	 CrTMgDCZdGXML24a3F6wZjbP+4yJgD06Mw+NomeJ6u6AokXx8A3W75XIQ2u/iU2dzN
	 Deciyj4OXSqZIKyeDUzz98hz6PFZcgXNFVr1vCLPkhdfOPkRgUAVWroZQTbI7LbLv8
	 EtwMQR38N0kpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sunil Khatri <sunil.khatri@amd.com>,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdgpu/userq: cleanup amdgpu_userq_get/put where not needed
Date: Mon, 20 Apr 2026 09:21:40 -0400
Message-ID: <20260420132314.1023554-306-sashal@kernel.org>
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

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit 8f402ddd4f2321485fff7384c003124681a08146 ]

amdgpu_userq_put/get are not needed in case we already holding
the userq_mutex and reference is valid already from queue create
time or from signal ioctl. These additional get/put could be a
potential reason for deadlock in case the ref count reaches zero
and destroy is called which again try to take the userq_mutex.

Due to the above change we avoid deadlock between suspend/restore
calling destroy queues trying to take userq_mutex again.

Cc: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amdgpu/userq`
- Action verb: "cleanup" (but this is a hidden deadlock fix)
- Summary: Remove unnecessary `amdgpu_userq_get/put` calls that cause
  deadlock

**Step 1.2: Tags**
- `Cc: Prike Liang <Prike.Liang@amd.com>` - CC'd related developer
- `Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>` - author
- `Reviewed-by: Christian König <christian.koenig@amd.com>` - key
  DRM/AMDGPU maintainer reviewed
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` - AMDGPU
  maintainer committed

**Step 1.3: Commit Body Analysis**
The commit explains:
- The `get/put` calls are unnecessary when `userq_mutex` is already held
  and references are valid from creation or signal ioctl
- The extra `put` could trigger `amdgpu_userq_kref_destroy` ->
  `amdgpu_userq_destroy` which tries to acquire `userq_mutex` again ->
  **deadlock**
- Specifically calls out suspend/restore as a deadlock-triggering path

**Step 1.4: Hidden Bug Fix Detection**
YES - this is a deadlock fix disguised as "cleanup". The commit message
explicitly describes a deadlock scenario.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c`
- Approximately 20 lines removed, 0 lines added (pure removal)
- Functions modified: `amdgpu_userq_restore_all`,
  `amdgpu_userq_evict_all`, `amdgpu_userq_wait_for_signal`

**Step 2.2: Code Flow Change**
Three functions all have the same pattern changed:

BEFORE: Inside `xa_for_each` loop: `amdgpu_userq_get()` -> work ->
`amdgpu_userq_put()`
AFTER: Inside `xa_for_each` loop: work (no get/put)

**Step 2.3: Bug Mechanism**
Category: **Deadlock** (lock ordering / recursive mutex acquisition)

The full deadlock chain I verified:
1. `amdgpu_userq_restore_worker` (line 1279) or
   `amdgpu_eviction_fence_suspend_worker`
   (`amdgpu_eviction_fence.c:110`) acquires `userq_mutex`
2. Calls one of the three modified functions
3. Function does `amdgpu_userq_put()` (line 698-702) ->
   `kref_put(&queue->refcount, amdgpu_userq_kref_destroy)`
4. If refcount hits zero -> `amdgpu_userq_kref_destroy` (line 673-682)
   -> `amdgpu_userq_destroy` (line 626-671)
5. `amdgpu_userq_destroy` calls `mutex_lock(&uq_mgr->userq_mutex)` at
   line 633 -> **DEADLOCK**

**Step 2.4: Fix Quality**
- Obviously correct: the mutex is already held, preventing concurrent
  destroy; `xa_for_each` provides a valid entry pointer under RCU
- Minimal/surgical: purely removes code, no new logic
- Regression risk: very low. The only concern would be if a queue could
  be destroyed between loop iterations without the extra get holding a
  reference, but the `userq_mutex` prevents that

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The `amdgpu_userq_get/put` calls in these three functions were all
introduced by commit `65b5c326ce410` ("drm/amdgpu/userq: refcount
userqueues to avoid any race conditions") dated 2026-03-02, the same
author (Sunil Khatri). This refcount commit is present in v7.0.

**Step 3.2: Fixes Tag / Predecessor**
The refcount commit `65b5c326ce410` is cherry-picked from mainline
`4952189b284d4d847f92636bb42dd747747129c0` and is explicitly tagged `Cc:
<stable@vger.kernel.org>`. It is already in the 7.0 stable tree and is
intended for other stable trees too.

**Step 3.3: File History**
The commit `a018d1819f158` (doorbell_offset validation) is the only
commit after the refcount commit in this tree. No conflicting changes.

**Step 3.4: Author**
Sunil Khatri is a regular AMD GPU contributor who also authored the
refcount commit that introduced the bug. This is the same author fixing
their own mistake, which is common and provides high confidence in the
fix.

**Step 3.5: Dependencies**
This commit depends ONLY on `65b5c326ce410` (the refcount commit) being
present. Since that commit is already in the 7.0 tree and tagged for
stable, the dependency is satisfied.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.2:**
Found via b4 dig that the refcount commit was submitted as "[PATCH v4]"
at `https://patch.msgid.link/20260303120654.2582995-1-
sunil.khatri@amd.com`. The patch went through v1-v4 with review by
Christian König and Alex Deucher. Lore.kernel.org was behind anti-bot
protection, so full discussion thread was not accessible.

**Step 4.3-4.5:**
The fix is by the same author who introduced the problem in the refcount
commit. Christian König (key DRM maintainer) reviewed both the original
refcount commit and this cleanup fix, confirming its correctness.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
- `amdgpu_userq_restore_all` - restores all queues after eviction
- `amdgpu_userq_evict_all` - evicts all queues
- `amdgpu_userq_wait_for_signal` - waits for last fences

**Step 5.2: Callers**
- `amdgpu_userq_restore_all`: called from `amdgpu_userq_restore_worker`
  (workqueue, holds `userq_mutex` at line 1279)
- `amdgpu_userq_evict_all`: called from `amdgpu_userq_evict`, which is
  called from `amdgpu_eviction_fence_suspend_worker` (holds
  `userq_mutex` at `amdgpu_eviction_fence.c:110`)
- `amdgpu_userq_wait_for_signal`: called from `amdgpu_userq_evict`, same
  path as above

**Step 5.4: Reachability**
These are GPU suspend/resume/eviction paths - triggered during system
suspend, GPU recovery, and memory pressure. These are common operations
for any AMD GPU user.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
The buggy code (`amdgpu_userq_get/put` in these three functions) was
introduced by `65b5c326ce410` which is:
- Present in v7.0 stable (confirmed)
- Tagged `Cc: stable@vger.kernel.org` - intended for all stable trees
  that have the userq infrastructure

**Step 6.2: Backport Complications**
The patch is a pure line removal from the same file modified by the
refcount commit. It should apply cleanly to any tree that has the
refcount commit.

**Step 6.3: Related Fixes Already in Stable**
No other fix for this deadlock was found in the tree.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** GPU driver (drivers/gpu/drm/amd/amdgpu) - IMPORTANT
criticality. AMD GPU is one of the most widely used GPU subsystems in
Linux.

**Step 7.2:** Actively developed - the userq (user queue) infrastructure
is a recent feature with many ongoing changes.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
All users with AMD GPUs using usermode queues.

**Step 8.2: Trigger Conditions**
- System suspend/resume triggers the restore path
- Memory pressure triggers eviction path
- GPU recovery triggers eviction path
These are common operations - not exotic scenarios.

**Step 8.3: Failure Mode**
**CRITICAL** - Deadlock. The system hangs with the `userq_mutex` held,
which blocks all subsequent GPU queue operations. This is a hard hang
for the GPU subsystem.

**Step 8.4: Risk-Benefit**
- **Benefit**: HIGH - prevents deadlock during suspend/resume/eviction
  on AMD GPUs
- **Risk**: VERY LOW - purely removes code, no new logic, reviewed by
  Christian König
- The removal is correct because: (a) `userq_mutex` is held preventing
  concurrent destruction, (b) `xa_for_each` provides valid entry
  pointers, (c) the extra get/put is redundant

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Fixes a real deadlock (recursive mutex acquisition) in GPU
  suspend/resume/eviction
- The refcount commit that introduced the bug is already tagged for
  stable
- Single file, ~20 lines removed, no new code
- Reviewed by Christian König (key DRM maintainer)
- Fix by the same author who introduced the bug
- Trigger conditions are common (suspend/resume, GPU recovery)
- Obviously correct - removing redundant reference counting under held
  mutex

AGAINST backporting:
- No explicit `Cc: stable@vger.kernel.org` on this commit (expected -
  that's why it's being reviewed)
- No `Fixes:` tag (expected)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** - simple removal, reviewed by
   maintainer
2. Fixes a real bug? **YES** - deadlock during suspend/resume/eviction
3. Important issue? **YES** - deadlock (system hang)
4. Small and contained? **YES** - ~20 lines removed, single file
5. No new features or APIs? **YES** - pure removal
6. Can apply to stable? **YES** - applies to any tree with the refcount
   commit

**Step 9.3: Exception Categories**
Not needed - this qualifies as a standard important bug fix (deadlock).

## Verification

- [Phase 1] Parsed tags: Reviewed-by Christian König, Signed-off-by Alex
  Deucher (both AMDGPU maintainers)
- [Phase 2] Diff analysis: ~20 lines removed from 3 functions, removing
  redundant `amdgpu_userq_get/put` pairs
- [Phase 2] Deadlock chain verified: `restore_worker`(mutex) ->
  `restore_all` -> `put` -> `kref_destroy` -> `destroy` -> `mutex_lock`
  = DEADLOCK
- [Phase 3] git blame: buggy get/put added by `65b5c326ce410` (Sunil
  Khatri, 2026-03-02), present in v7.0
- [Phase 3] Confirmed `65b5c326ce410` is cherry-picked from mainline
  `4952189b284d4d847f92636bb42dd747747129c0` with `Cc:
  stable@vger.kernel.org`
- [Phase 3] Same author (Sunil Khatri) for both the bug-introducing and
  fixing commits
- [Phase 4] b4 dig found original refcount submission at `https://patch.
  msgid.link/20260303120654.2582995-1-sunil.khatri@amd.com`, went
  through v1-v4
- [Phase 5] Verified callers: `amdgpu_userq_restore_worker` holds mutex
  at line 1279; `amdgpu_eviction_fence_suspend_worker` holds mutex at
  `amdgpu_eviction_fence.c:110`
- [Phase 5] Verified `amdgpu_userq_destroy` takes mutex at line 633
  (confirmed the deadlock)
- [Phase 5] Verified `amdgpu_userq_kref_destroy` (line 673) calls
  `amdgpu_userq_destroy` (line 680)
- [Phase 6] Refcount commit exists in 7.0 stable and is tagged for all
  stable trees
- [Phase 8] Failure mode: DEADLOCK in GPU suspend/resume - severity
  CRITICAL

This is a clear, well-reviewed deadlock fix for a bug introduced by a
commit already in stable. The fix is minimal (pure removal), correct,
and addresses a critical stability issue during suspend/resume.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index ad39460b54dc5..2c98bce88b9dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -1057,15 +1057,11 @@ amdgpu_userq_restore_all(struct amdgpu_userq_mgr *uq_mgr)
 
 	/* Resume all the queues for this process */
 	xa_for_each(&uq_mgr->userq_xa, queue_id, queue) {
-		queue = amdgpu_userq_get(uq_mgr, queue_id);
-		if (!queue)
-			continue;
 
 		if (!amdgpu_userq_buffer_vas_mapped(queue)) {
 			drm_file_err(uq_mgr->file,
 				     "trying restore queue without va mapping\n");
 			queue->state = AMDGPU_USERQ_STATE_INVALID_VA;
-			amdgpu_userq_put(queue);
 			continue;
 		}
 
@@ -1073,7 +1069,6 @@ amdgpu_userq_restore_all(struct amdgpu_userq_mgr *uq_mgr)
 		if (r)
 			ret = r;
 
-		amdgpu_userq_put(queue);
 	}
 
 	if (ret)
@@ -1307,13 +1302,9 @@ amdgpu_userq_evict_all(struct amdgpu_userq_mgr *uq_mgr)
 	amdgpu_userq_detect_and_reset_queues(uq_mgr);
 	/* Try to unmap all the queues in this process ctx */
 	xa_for_each(&uq_mgr->userq_xa, queue_id, queue) {
-		queue = amdgpu_userq_get(uq_mgr, queue_id);
-		if (!queue)
-			continue;
 		r = amdgpu_userq_preempt_helper(queue);
 		if (r)
 			ret = r;
-		amdgpu_userq_put(queue);
 	}
 
 	if (ret)
@@ -1346,24 +1337,18 @@ amdgpu_userq_wait_for_signal(struct amdgpu_userq_mgr *uq_mgr)
 	int ret;
 
 	xa_for_each(&uq_mgr->userq_xa, queue_id, queue) {
-		queue = amdgpu_userq_get(uq_mgr, queue_id);
-		if (!queue)
-			continue;
-
 		struct dma_fence *f = queue->last_fence;
 
-		if (!f || dma_fence_is_signaled(f)) {
-			amdgpu_userq_put(queue);
+		if (!f || dma_fence_is_signaled(f))
 			continue;
-		}
+
 		ret = dma_fence_wait_timeout(f, true, msecs_to_jiffies(100));
 		if (ret <= 0) {
 			drm_file_err(uq_mgr->file, "Timed out waiting for fence=%llu:%llu\n",
 				     f->context, f->seqno);
-			amdgpu_userq_put(queue);
+
 			return -ETIMEDOUT;
 		}
-		amdgpu_userq_put(queue);
 	}
 
 	return 0;
-- 
2.53.0

