Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D933D1719;
	Mon, 20 Apr 2026 13:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691844; cv=none; b=fQ6PG3p2Wjog44+XE1cOx1MjzobCs69B3elwxClQS+h9nuXu1JQ/h+OXuoTacabcnuL1EWbeLxy0qaiE0ddEBAJ3WwrzQ4GSHAtPd99EoSVsV/J5LmldpNmLjpgABMt2XNwVTlJFqU0d1NQYQ2VmijaCcIVCHU/1J4gusLpqSFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691844; c=relaxed/simple;
	bh=LDBsa2lH87nC/8hnNwfaUBqp4kitb5/tu/BziOxOUlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MD9i5tg1VoFFV5O5wFILOYrcOp2nPMTn7KoqHRIauxm8y/DkWkR3wGfjxM/4nugtS7gMgNUmfhm5o9lHS6QB91s6/yr4ZmKK/zxFLdyU2UbO7HV8gGDh+5UyvfisJnl7KCEvhJLOkomYZ3OoA3wywtWOY9eIXr8fMY+rXhdW/mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYWdt0+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYWdt0+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B90CC19425;
	Mon, 20 Apr 2026 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691844;
	bh=LDBsa2lH87nC/8hnNwfaUBqp4kitb5/tu/BziOxOUlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYWdt0+Qtt132laXdPORMRHt8zo7/aIpD82A2khBySo8QBQbYXwTpPvIEyN6BORiA
	 Tp2/P/spwpZvXwKAW810R44S/1Dd0L3mDAtWXFEafMwGMZ4yySWOS0DjuGsWarz2Vs
	 5jSsFg6vYr4f5sPs8jDMuua0ebXkkys96UiidLkTYpOLc4dTzbIDgWItg76xzESwx1
	 13PyCmKBAmmcqNQ6UmmOF5FWfIUJhnfcHKMy3RxPxY9+PVfhnSJjTQxzea9HI63Iyo
	 HAVsv0SL/CmXYIQ/WMr/qvNYNsMeeeAziS1ak+Hpf0GwC6r0h/m9yVGFuYsSUq5tFL
	 Hde/9Vz0VzQew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sunil Khatri <sunil.khatri@amd.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amdgpu/userq: fix dma_fence refcount underflow in userq path
Date: Mon, 20 Apr 2026 09:20:21 -0400
Message-ID: <20260420132314.1023554-227-sashal@kernel.org>
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

[ Upstream commit 7a14a4e9b3fda05b907d0445a3be9e7c0e887f4e ]

An extra dma_fence_put() can drop the last reference to a fence while it is
still attached to a dma_resv object. This frees the fence prematurely via
dma_fence_release() while other users still hold the pointer.

Later accesses through dma_resv iteration may then operate on the freed
fence object, leading to refcount underflow warnings and potential hangs
when walking reservation fences.

Fix this by correcting the fence lifetime so the dma_resv object retains a
valid reference until it is done with the fence.i

[   31.133803] refcount_t: underflow; use-after-free.
[   31.133805] WARNING: lib/refcount.c:28 at refcount_warn_saturate+0x58/0x90, CPU#18: kworker/u96:1/188

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
- **Subsystem**: drm/amdgpu/userq (AMD GPU user queue fence handling)
- **Action verb**: "fix" - explicitly states it's a bug fix
- **Summary**: Fixes dma_fence refcount underflow (double-put) in the
  userqueue wait ioctl path

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>** - Author, AMD
  employee, regular contributor to amdgpu
- **Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>** - Major
  DRM subsystem contributor
- **Reviewed-by: Christian König <christian.koenig@amd.com>** - AMD DRM
  maintainer, very strong endorsement
- **Signed-off-by: Alex Deucher <alexander.deucher@amd.com>** - amdgpu
  subsystem maintainer who committed it
- **No Fixes: tag** - expected for AUTOSEL candidates; the mailing list
  discussion confirmed it should be `Fixes: bea29bb0dd29
  ("drm/amdgpu/userq: Consolidate wait ioctl exit path")`
- **No explicit Cc: stable** - expected for AUTOSEL

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
- **Bug description**: An extra `dma_fence_put()` drops the last
  reference to a fence still attached to a `dma_resv` object, freeing it
  prematurely
- **Symptom**: refcount underflow warnings (`refcount_t: underflow; use-
  after-free`) followed by soft lockup (`watchdog: BUG: soft lockup -
  CPU#9 stuck for 26s!`)
- **Root cause**: After the "Consolidate wait ioctl exit path" commit
  merged both exit paths into one, fences get double-put: once inside
  the processing loop and once in the shared cleanup path
- **Stack traces**: Two crash traces provided - the refcount underflow
  in `drm_sched_entity_pop_job` and a 26s soft lockup in
  `dma_resv_iter_walk_unlocked` from `amdgpu_bo_kmap`

### Step 1.4: DETECT HIDDEN BUG FIXES
This is a clear, explicit bug fix, not a hidden one.

Record: This is a direct fix for a use-after-free / refcount underflow
caused by double `dma_fence_put()`.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **Files changed**: 1
  (`drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c`)
- **Lines removed**: 5 (three `dma_fence_put(fences[i])` calls and
  associated braces)
- **Lines added**: 1 (reformatting `if (r)` to single line)
- **Net change**: -4 lines
- **Functions modified**: `amdgpu_userq_wait_ioctl()`
- **Scope**: Single-file, single-function surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Hunk 1 (non-userq fence path)**: Removes `dma_fence_put(fences[i])` on
both the error and success branches of the `dma_fence_wait()` call for
non-userq fences.

**Hunk 2 (userq fence path)**: Removes `dma_fence_put(fences[i])` after
extracting fence_info for userq fences.

**Cleanup path** (unchanged): The `free_fences:` label at the end
already iterates through ALL fences and puts them:
```c
while (num_fences-- > 0)
    dma_fence_put(fences[num_fences]);
```

**Before**: Fences were put inside the loop (3 locations) AND again in
the cleanup loop = double-put.
**After**: Fences are only put in the cleanup loop = correct single put.

### Step 2.3: IDENTIFY THE BUG MECHANISM
- **Category**: Reference counting bug / double-free / use-after-free
- **Mechanism**: The `fences[]` array holds references obtained via
  `dma_fence_get()`. After the exit path consolidation (commit
  bea29bb0dd29), all exits go through `free_fences` which puts every
  fence. But the loop was also putting fences individually, resulting in
  each processed fence getting put twice. This drops the refcount below
  zero, triggering `refcount_warn_saturate()`, and may free the fence
  while `dma_resv` still holds the pointer, leading to use-after-free
  and hangs.

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct**: Yes. The cleanup loop handles all fence puts
  correctly. Removing the in-loop puts ensures exactly one put per get.
- **Minimal/surgical**: Yes, -4 net lines, only removing erroneous calls
- **Regression risk**: Extremely low - this purely removes double-puts.
  No new logic introduced.
- **Red flags**: None

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
- The in-loop `dma_fence_put` calls originated in commit
  `15e30a6e479282` (Arunpravin Paneer Selvam, 2024-10-30) - "Add wait
  IOCTL timeline syncobj support"
- The cleanup loop `free_fences` was modified by commit `048c1c4e51715`
  (Tvrtko Ursulin, 2026-02-23) - "Consolidate wait ioctl exit path",
  cherry-picked from mainline `bea29bb0dd29`
- The consolidation commit merged the success and error exit paths into
  one, creating the double-put

### Step 3.2: FOLLOW THE FIXES: TAG
The mailing list discussion confirms `Fixes: bea29bb0dd29
("drm/amdgpu/userq: Consolidate wait ioctl exit path")`. This commit is
present in the 7.0 stable tree as `048c1c4e51715`.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Only one commit after the consolidation: `65b5c326ce410` (refcount
userqueues), which modifies different parts of the function (queue
lookup, not the fence loop). The fix is standalone.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Sunil Khatri is a regular AMD contributor with multiple commits to the
amdgpu userq subsystem. He authored the refcount userqueues commit and
multiple input validation fixes.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
This is patch 3/3 in a series, but it is self-contained. Patch 1/3 deals
with gem object lookup optimization and patch 2/3 with kvfree usage -
neither affects the same code or is needed for this fix.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Found at: https://lists.freedesktop.org/archives/amd-
gfx/2026-March/140504.html

**Tvrtko Ursulin** (the author of the commit that introduced the bug)
reviewed the fix, confirmed it's correct, and acknowledged he introduced
the bug:
> "I have to say the commit message confused me a bit, but the fix looks
correct. I say confused because isn't it a simple case of
amdgpu_userq_wait_ioctl() doing a potential double put? First one when
the dma_fence_wait() above fails or succeeds, and the second one in the
unwind loop. Which means it was me who broke it yet again."

He provided: `Fixes: bea29bb0dd29 ("drm/amdgpu/userq: Consolidate wait
ioctl exit path")` and added his `Reviewed-by`.

### Step 4.2: REVIEWER ANALYSIS
- **Tvrtko Ursulin** (Reviewed-by) - major DRM contributor and the
  author of the bug-introducing commit
- **Christian König** (Reviewed-by) - AMD DRM co-maintainer
- **Alex Deucher** (Signed-off-by) - amdgpu maintainer who applied the
  fix
- All key stakeholders reviewed and approved

### Step 4.3: BUG REPORT
The commit message includes a full kernel stack trace showing the actual
crash on real hardware (X570 AORUS ELITE with AMD GPU, running
6.19.0-amd-staging-drm-next). The bug was found through actual testing,
not just code review.

### Step 4.4/4.5: SERIES AND STABLE CONTEXT
The other patches in the series (1/3 and 2/3) are unrelated
optimizations. This patch is fully standalone.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: FUNCTION AND CALL CHAIN ANALYSIS
- **Modified function**: `amdgpu_userq_wait_ioctl()` - a DRM ioctl
  handler
- **Call chain**: `__se_sys_ioctl` -> `drm_ioctl` -> `amdgpu_drm_ioctl`
  -> `amdgpu_userq_wait_ioctl`
- **Reachability**: Directly reachable from userspace via ioctl syscall
  - any userspace GPU application using userqueues can trigger this
- **Impact**: The crash occurs in the GPU scheduler workqueue
  (`drm_sched_run_job_work`) when it encounters the freed fence, and
  causes a 26-second soft lockup

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
Yes. The buggy "Consolidate wait ioctl exit path" commit was cherry-
picked into the 7.0 stable tree as `048c1c4e51715`. The double-put is
confirmed present in the current code at lines 949-977 and 991-995.

### Step 6.2: BACKPORT COMPLICATIONS
The diff should apply cleanly or with minimal offset. The code context
matches the current tree state. The intervening `65b5c326ce410` commit
modifies different parts of the function.

### Step 6.3: RELATED FIXES IN STABLE
No other fix for this specific double-put issue exists in the stable
tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
- **Subsystem**: drm/amdgpu (AMD GPU driver) - IMPORTANT
- **Sub-component**: userqueue fence handling - used by userspace GPU
  workloads
- **Impact scope**: All AMD GPU users running userqueue-enabled
  applications

### Step 7.2: SUBSYSTEM ACTIVITY
The file has 48 commits and is actively developed. The userqueue feature
is relatively new (introduced late 2024), so this is actively used by
new GPU workloads.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
All users with AMD GPUs that use the userqueue IOCTL path (driver-
specific, but a major driver).

### Step 8.2: TRIGGER CONDITIONS
The bug triggers during normal GPU operations - the stack trace shows it
happening during `glxgears:cs0` workload via the signal ioctl path
walking reservation fences. Any userspace application exercising the
wait/signal ioctl path can trigger this.

### Step 8.3: FAILURE MODE SEVERITY
- **Primary**: `refcount_t: underflow; use-after-free` WARNING
- **Secondary**: Soft lockup (CPU stuck for 26s) in
  `dma_resv_iter_walk_unlocked`
- **Severity**: CRITICAL - system hang/lockup, potential data corruption
  from use-after-free

### Step 8.4: RISK-BENEFIT RATIO
- **BENEFIT**: Very high - prevents use-after-free, refcount underflow,
  and system hangs for AMD GPU users
- **RISK**: Very low - 4 net lines removed, no new logic, obviously
  correct, reviewed by the person who introduced the bug and by the
  subsystem maintainer
- **Ratio**: Extremely favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILATION

**FOR backporting:**
- Fixes a real, reproducible use-after-free and refcount underflow
- Causes system soft lockup (26 seconds) - CRITICAL severity
- Triggered via normal GPU ioctl usage path
- Extremely small and surgical (-4 net lines)
- Reviewed by 2 DRM experts (Tvrtko Ursulin, Christian König)
- Applied by subsystem maintainer (Alex Deucher)
- Bug-introducing commit (bea29bb0dd29/048c1c4e51715) is already in this
  stable tree
- Full stack trace demonstrating the crash on real hardware
- Standalone fix with no dependencies on other patches

**AGAINST backporting:**
- None identified

### Step 9.2: STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES - confirmed by author,
   reviewers, and the person who introduced the bug; tested on real
   hardware
2. **Fixes a real bug?** YES - double dma_fence_put causing use-after-
   free and soft lockup
3. **Important issue?** YES - system hang (soft lockup), use-after-free,
   refcount underflow
4. **Small and contained?** YES - 4 net lines removed in a single
   file/function
5. **No new features or APIs?** CORRECT - purely removes erroneous calls
6. **Can apply to stable trees?** YES - the buggy commit is present in
   this tree

### Step 9.3: EXCEPTION CATEGORIES
Not applicable - this is a standard critical bug fix.

### Step 9.4: DECISION
This is a textbook stable backport candidate: a small, obviously correct
fix for a critical bug (use-after-free + system hang) that was
introduced by a commit already present in the stable tree.

---

## Verification

- [Phase 1] Parsed commit message: explicit "fix" in subject, refcount
  underflow description, stack traces showing soft lockup and use-after-
  free warning
- [Phase 1] Tags: Reviewed-by Tvrtko Ursulin and Christian König;
  Signed-off-by Alex Deucher (maintainer)
- [Phase 2] Diff: removes 3 `dma_fence_put(fences[i])` calls from loop
  in `amdgpu_userq_wait_ioctl()`, -4 net lines
- [Phase 2] Cleanup path at `free_fences:` already calls
  `dma_fence_put()` on all fences, confirmed at lines 991-995
- [Phase 3] git blame: in-loop puts from commit 15e30a6e479282
  (2024-10-30); cleanup loop modified by 048c1c4e51715 (consolidation)
- [Phase 3] Consolidation commit `048c1c4e51715` confirmed present in
  7.0 tree (cherry-picked from bea29bb0dd29)
- [Phase 3] Current code at lines 949-977 confirmed still has the
  double-put (fix not yet applied)
- [Phase 3] Only one intervening commit (65b5c326ce410, refcount
  userqueues) which touches different code areas
- [Phase 4] Mailing list discussion found at
  https://lists.freedesktop.org/archives/amd-gfx/2026-March/140504.html
- [Phase 4] Tvrtko Ursulin confirmed the fix is correct and acknowledged
  he introduced the bug
- [Phase 4] Tvrtko provided the Fixes tag: `Fixes: bea29bb0dd29`
- [Phase 4] No NAKs, no objections; unanimous approval from reviewers
- [Phase 5] `amdgpu_userq_wait_ioctl()` is reachable from userspace
  ioctl syscall path
- [Phase 6] Bug-introducing commit IS in this stable tree
  (048c1c4e51715)
- [Phase 6] Fix should apply cleanly - code context matches
- [Phase 7] amdgpu is an IMPORTANT subsystem; userqueue fence code is
  actively developed
- [Phase 8] Failure: use-after-free + 26s soft lockup; severity
  CRITICAL; triggered during normal GPU operations

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index 5239b06b9ab03..bb390067c26ef 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -947,12 +947,9 @@ int amdgpu_userq_wait_ioctl(struct drm_device *dev, void *data,
 				 * be good for now
 				 */
 				r = dma_fence_wait(fences[i], true);
-				if (r) {
-					dma_fence_put(fences[i]);
+				if (r)
 					goto free_fences;
-				}
 
-				dma_fence_put(fences[i]);
 				continue;
 			}
 
@@ -974,7 +971,6 @@ int amdgpu_userq_wait_ioctl(struct drm_device *dev, void *data,
 			fence_info[cnt].va = fence_drv->va;
 			fence_info[cnt].value = fences[i]->seqno;
 
-			dma_fence_put(fences[i]);
 			/* Increment the actual userq fence count */
 			cnt++;
 		}
-- 
2.53.0

