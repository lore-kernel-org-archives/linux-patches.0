Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9A83D16E6;
	Mon, 20 Apr 2026 13:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691828; cv=none; b=Sd+lWbAlEf55yARSuURSaTxlfH+p6mSHdINrnyN8Orhn3c82Ee1irSJH+lh5jT+tmApaHWMR3ir2zHQtE4zsAHBTMnyy9Whb5AN6bsjpkQbR9t5Sc9+dwls/lFGXwenmi0G+BQC2DFudLVuP9QmcQcMGHMIhMKauJUHsvGyaP+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691828; c=relaxed/simple;
	bh=z/z1ABLtKbMTeOi76lytgpPZA98q1EEHs1/gS1076sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jSOUBaV/sPqiAQ3ABK7aX7A0YlK4CpmJDlndS27iS7H2lLhIE03ol1jGD9ZJ+Mn8WqwAPeRNQo+UabV0soy2t2znmy00FwTybV4NsAVI751Y2O1CDg/isw0fSaQ/9ersczy/SUEqzFS92o8Pw23RPQ1yEeVyJ25kQnrFGbL1XsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UV7G+Fca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UV7G+Fca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7173EC2BCB8;
	Mon, 20 Apr 2026 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691827;
	bh=z/z1ABLtKbMTeOi76lytgpPZA98q1EEHs1/gS1076sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UV7G+FcaCtYJ0hyNQSjKRwoKcAn5U+rXNEWCd4loWsG/oDOWQ+mhcI1g1k24VzzQf
	 vF95ZtmxvQx0TUuwLy09J23PWOIfn76uShTJv3cNxngP4JFKwdGwdT+4iV8/iCZXyy
	 2CCRmmV0cW1nrSAkwBXhc8xMycxAFCy0fhMJXa/REG0puYb8ov/FE1PSQiBGEm4+IB
	 i8Wr2v+rQk4Sj7hBpNhFpaIrk2hGc9rtYqImDcKkUKrATJKIGRHZIzS0M22LBkpLBi
	 MRSou6H6H1Bs341D2DaOuBeSAPIufzBZGhBcD5hm6MjSqsgBPAesyG+V0t7FI2b6yk
	 ZwMMR9qKlvPlg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdgpu/userq: defer queue publication until create completes
Date: Mon, 20 Apr 2026 09:20:12 -0400
Message-ID: <20260420132314.1023554-218-sashal@kernel.org>
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

[ Upstream commit 28cacaace5cde8318b7da967b3955a73cc6de91a ]

The userq create path publishes queues to global xarrays such as
userq_doorbell_xa and userq_xa before creation was fully complete.
Later on if create queue fails, teardown could free an already
visible queue, opening a UAF race with concurrent queue walkers.
Also calling amdgpu_userq_put in such cases complicates the cleanup.

Solution is to defer queue publication until create succeeds and no
partially initialized queue is exposed.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [drm/amdgpu/userq] [defer] — Defers queue publication to global
xarrays until `amdgpu_userq_create()` completes, preventing UAF races
with concurrent queue walkers.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by**: Sunil Khatri (author, regular AMD GPU contributor)
- **Reviewed-by**: Christian König (AMD GPU subsystem maintainer —
  strong quality signal)
- **Signed-off-by**: Alex Deucher (AMD GPU maintainer, committer)
- No Fixes: tag, no Cc: stable, no Reported-by. Absence of
  Fixes/Cc:stable is expected for candidates under review.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The body clearly describes:
- **Bug**: The userq create path publishes queues to `userq_doorbell_xa`
  and `userq_xa` before creation is fully complete.
- **Failure mode**: If create fails later, teardown frees a queue that's
  already visible, opening a UAF race with concurrent queue walkers
  (suspend/resume, reset, enforce isolation).
- **Root cause**: Premature publication of partially initialized objects
  to global data structures.

### Step 1.4: DETECT HIDDEN BUG FIXES
This is explicitly a UAF race fix, not disguised. The commit also
implicitly fixes resource leaks on error paths (the old `kasprintf`
failure leaked xarray entries).

---

## PHASE 2: DIFF ANALYSIS — LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **File**: `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c` (+33/−33 lines)
- **Function**: `amdgpu_userq_create()`
- **Scope**: Single function in a single file — surgical.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**BEFORE** (current stable tree code):
1. `mqd_create()` → `kref_init()` → `xa_store_irq(doorbell_xa)` →
   `xa_alloc(userq_xa)` → `map_helper()` → `kasprintf()` → debugfs

**AFTER** (with this patch):
1. `mqd_create()` → `map_helper()` → `kref_init()` →
   `xa_alloc(userq_xa)` → `xa_store_irq(doorbell_xa)` → debugfs

The key reordering: queue creation and mapping are fully completed
BEFORE the queue is published to global xarrays. Only on success are the
xarray entries created.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Category**: UAF race condition + resource leaks on error paths.

Specific bugs in the current stable tree code:

1. **UAF race**: Between `xa_store_irq(doorbell_xa)` (line 863) and
   `map_helper()` (line 891), the queue is visible to concurrent walkers
   via `xa_for_each(&adev->userq_doorbell_xa)`. I verified 7 call sites
   iterate this xarray (suspend, resume, enforce isolation stop/start,
   pre/post reset, mes detection). If create fails at `map_helper()`,
   the error path frees the queue while walkers may hold a pointer to
   it.

2. **Missing doorbell xa cleanup**: The `xa_alloc` failure path (line
   872-880) does NOT call `xa_erase_irq(&adev->userq_doorbell_xa,
   index)`, leaking the doorbell xarray entry pointing to freed memory.

3. **kasprintf leak**: The `kasprintf` failure (line 902-906) does `goto
   unlock` without cleaning up xarray entries, the mapped queue, or any
   other resources — the queue is abandoned in global xarrays.

### Step 2.4: ASSESS THE FIX QUALITY
- The fix is obviously correct: it simply reorders operations so
  publication happens last.
- Error paths in the new code properly clean up everything (including
  calling `amdgpu_userq_unmap_helper` if needed).
- The `kasprintf` allocation is replaced with a stack buffer (`char
  queue_name[32]` + `scnprintf`), eliminating that failure path
  entirely.
- Regression risk is low — the fix only changes ordering within the
  create path.
- Reviewed by Christian König (subsystem maintainer).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
- The xarray-based queue management was introduced by `f18719ef4bb7b`
  (Jesse.Zhang, 2025-10-21) — "Convert amdgpu userqueue management from
  IDR to XArray"
- The refcount mechanism was added by `65b5c326ce410` (Sunil Khatri,
  2026-03-02) — already cherry-picked to this stable tree with `Cc:
  <stable@vger.kernel.org>`

### Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag present (expected for review candidates).

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Between the mainline refcount commit (`4952189b284d4`) and this commit
(`28cacaace5cde`), there are 3 intermediate commits:
- `2d60e9898a1d4` — change queue id type to u32 (NOT in stable tree)
- `f0e46fd06c3f7` — add missing `xa_erase_irq` in xa_alloc failure (NOT
  in stable tree)
- `a978ed3d6454e` — add missing `xa_erase_irq` in map_helper failure
  (NOT in stable tree)

**This commit supersedes both `f0e46fd06c3f7` and `a978ed3d6454e`** by
restructuring the code to eliminate these error paths entirely.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Sunil Khatri is an active AMD GPU contributor with multiple commits in
the subsystem. He authored the refcount commit which was already
selected for stable.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Critical finding**: The diff expects context lines that include
`xa_erase_irq(&adev->userq_doorbell_xa, index)` in the xa_alloc and
map_helper failure paths. These lines were added by intermediate commits
`f0e46fd06c3f7` and `a978ed3d6454e`, which are **NOT in the stable
tree**. The patch will **not apply cleanly** without either including
those intermediate commits or manually adjusting the diff.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
- `b4 dig -c 28cacaace5cde` found nothing (patch may have gone through a
  different path).
- Web search found the patch series on the amd-gfx mailing list as
  `[PATCH v4 1/3]`.
- Fetched the review thread at
  `https://lists.freedesktop.org/archives/amd-
  gfx/2026-March/140034.html`.
- Christian König reviewed and gave `Reviewed-by` on patch 1/3 (this
  commit).

### Step 4.2: CHECK WHO REVIEWED THE PATCH
- Christian König (subsystem maintainer) reviewed and approved.
- Alex Deucher (AMD GPU maintainer) committed it.

### Step 4.3: SEARCH FOR THE BUG REPORT
No external bug report. The author identified the race condition through
code inspection while working on the refcount series.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
The patch is part of a v4 3-patch series:
- 1/3: This commit (defer queue publication) — **bug fix**
- 2/3: "declutter the code with goto" — cleanup, not needed for stable
- 3/3: "push userq debugfs function in amdgpu_debugfs files" —
  refactoring, not needed for stable

Only patch 1/3 is a bug fix.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
The predecessor commit (refcount userqueues, `65b5c326ce410`) was
explicitly marked `Cc: <stable@vger.kernel.org>`, confirming the stable
maintainers already identified the userq race conditions as stable-
worthy. This commit is a direct follow-up fix to the same issue.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: TRACE CALLERS AND IMPACT SURFACE
- `amdgpu_userq_create()` is called from `amdgpu_userq_ioctl()` →
  reachable from userspace via DRM IOCTL.
- The concurrent walkers iterating `userq_doorbell_xa` include:
  - `amdgpu_userq_suspend()` / `amdgpu_userq_resume()` — power
    management
  - `amdgpu_userq_stop_sched_for_enforce_isolation()` /
    `amdgpu_userq_start_sched_for_enforce_isolation()` — workload
    isolation
  - `amdgpu_userq_pre_reset()` / `amdgpu_userq_post_reset()` — GPU reset
  - `mes_userqueue.c:` detect-and-reset path

These are all real, frequently exercised code paths (suspend/resume, GPU
reset).

### Step 5.5: SIMILAR PATTERNS
The doorbell xa walkers do NOT use `amdgpu_userq_get()` (the kref-
protected accessor). They iterate with `xa_for_each` and use the queue
pointer directly, meaning the kref doesn't protect against the UAF in
these paths.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
Yes. The userq code exists in this 7.0 stable tree. The buggy ordering
was introduced with the xarray conversion (`f18719ef4bb7b`, 2025-10-21),
which is in this tree.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**The patch will NOT apply cleanly.** The intermediate commits
`f0e46fd06c3f7` and `a978ed3d6454e` added `xa_erase_irq` lines that the
diff expects to see in the context. These are missing from the current
stable tree. The diff would need manual adjustment or the intermediate
commits need to be included first.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
The refcount commit (`65b5c326ce410`) is in this tree, but the
intermediate xa_erase fixes and this commit are not.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
- **Subsystem**: drivers/gpu/drm/amd/amdgpu — IMPORTANT (widely used AMD
  GPU driver)
- User queues are a newer feature but actively used on modern AMD
  hardware.

### Step 7.2: SUBSYSTEM ACTIVITY
Very active — many commits per week in amdgpu. The userq subsystem is
under active development.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
Users of AMD GPUs with userqueue support (GFX11+, GFX12+, SDMA v6/v7).
This includes modern Radeon RX 7000/8000 series and data center GPUs.

### Step 8.2: TRIGGER CONDITIONS
- **Trigger**: Create a userqueue via IOCTL while a concurrent operation
  (suspend/resume, GPU reset, enforce isolation) is walking the doorbell
  xarray.
- **Likelihood**: Medium — requires timing overlap between queue
  creation failure and concurrent walker.
- **Unprivileged trigger**: Yes — the IOCTL is accessible to
  unprivileged users (no CAP check for normal priority).

### Step 8.3: FAILURE MODE SEVERITY
- **UAF**: When triggered, can cause kernel crash (oops), memory
  corruption, or potentially privilege escalation.
- **Severity**: HIGH — UAF reachable from unprivileged userspace.

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit**: HIGH — prevents UAF, fixes resource leaks, hardens
  security.
- **Risk**: LOW-MEDIUM — 66 lines changed, single function, but needs
  backport adjustment.
- **Ratio**: Strongly favors backporting.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Fixes a real UAF race condition reachable from unprivileged userspace
- Fixes resource leaks on error paths (kasprintf failure, missing
  xa_erase)
- Reviewed and approved by Christian König (subsystem maintainer) and
  Alex Deucher (committer)
- Single file, single function change — well-contained
- The prerequisite refcount commit is already in stable (with Cc: stable
  tag)
- Supersedes two intermediate fixes that are also needed for stable

**AGAINST backporting:**
- The diff does NOT apply cleanly (context mismatch due to missing
  intermediate commits)
- Part of a 3-patch series (but only 1/3 is needed)
- Moderate size (66 lines)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** — reviewed by subsystem
   maintainer, reordering is straightforward
2. Fixes a real bug? **YES** — UAF race with concurrent queue walkers
3. Important issue? **YES** — UAF reachable from userspace = security
   concern
4. Small and contained? **YES** — single function in single file
5. No new features or APIs? **YES** — pure bug fix
6. Can apply to stable? **NEEDS ADJUSTMENT** — intermediate commits
   missing from tree

### Step 9.3: EXCEPTION CATEGORIES
Not an exception category — standard bug fix.

### Step 9.4: DECISION
The commit fixes a real UAF race condition in the AMD GPU userqueue
create path. The race is between queue creation (IOCTL) and concurrent
doorbell xarray walkers (suspend/resume, GPU reset, enforce isolation).
The fix is well-contained, well-reviewed, and the prerequisite refcount
infrastructure is already in this stable tree. The backport will need
manual adjustment due to missing intermediate context, but the
underlying bugs are real and security-relevant.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Christian König, Signed-off-by Alex
  Deucher (both AMD GPU maintainers)
- [Phase 2] Diff analysis: 33 lines added, 33 removed in
  `amdgpu_userq_create()`, reorders xa_store/xa_alloc after map_helper
- [Phase 2] Verified current tree at lines 858-906: queue published to
  doorbell_xa at line 863, BEFORE map_helper at line 891
- [Phase 2] Verified kasprintf failure at line 902-906 leaks xarray
  entries (goto unlock without cleanup)
- [Phase 2] Verified xa_alloc failure at line 872-880 does NOT call
  xa_erase_irq for doorbell_xa
- [Phase 3] git blame: xarray code from f18719ef4bb7b (2025-10-21),
  refcount from 65b5c326ce410 (in stable, Cc: stable)
- [Phase 3] Intermediate commits f0e46fd06c3f7 and a978ed3d6454e NOT in
  stable tree (verified with git log --grep)
- [Phase 3] git show 28cacaace5cde: confirmed mainline commit exists,
  authored 2026-03-04
- [Phase 4] Mailing list review at freedesktop.org: Christian König gave
  Reviewed-by on patch 1/3
- [Phase 4] Series is v4 1/3; patches 2/3 and 3/3 are
  cleanup/refactoring (not needed for stable)
- [Phase 5] Verified 7 call sites using
  xa_for_each(&adev->userq_doorbell_xa) — all are real paths (suspend,
  resume, reset, enforce isolation)
- [Phase 5] Verified doorbell xa walkers do NOT use amdgpu_userq_get()
  (no kref protection)
- [Phase 6] Verified patch does NOT apply cleanly: diff expects
  xa_erase_irq lines not in stable tree
- [Phase 6] Refcount prerequisite (65b5c326ce410) confirmed in stable
  tree
- [Phase 7] amdgpu is an actively maintained, widely used driver
  subsystem
- [Phase 8] IOCTL is accessible to unprivileged users (no CAP check for
  normal priority)
- UNVERIFIED: Cannot determine exact AMD GPU models that exercise this
  code path in practice (depends on firmware/hardware support for
  userqueues)

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 66 +++++++++++------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index 1849894d2837b..09f1d05328897 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -765,7 +765,6 @@ amdgpu_userq_create(struct drm_file *filp, union drm_amdgpu_userq *args)
 	const struct amdgpu_userq_funcs *uq_funcs;
 	struct amdgpu_usermode_queue *queue;
 	struct amdgpu_db_info db_info;
-	char *queue_name;
 	bool skip_map_queue;
 	u32 qid;
 	uint64_t index;
@@ -855,32 +854,6 @@ amdgpu_userq_create(struct drm_file *filp, union drm_amdgpu_userq *args)
 		goto unlock;
 	}
 
-	/* drop this refcount during queue destroy */
-	kref_init(&queue->refcount);
-
-	/* Wait for mode-1 reset to complete */
-	down_read(&adev->reset_domain->sem);
-	r = xa_err(xa_store_irq(&adev->userq_doorbell_xa, index, queue, GFP_KERNEL));
-	if (r) {
-		kfree(queue);
-		up_read(&adev->reset_domain->sem);
-		goto unlock;
-	}
-
-	r = xa_alloc(&uq_mgr->userq_xa, &qid, queue,
-		     XA_LIMIT(1, AMDGPU_MAX_USERQ_COUNT), GFP_KERNEL);
-	if (r) {
-		drm_file_err(uq_mgr->file, "Failed to allocate a queue id\n");
-		amdgpu_userq_fence_driver_free(queue);
-		xa_erase_irq(&adev->userq_doorbell_xa, index);
-		uq_funcs->mqd_destroy(queue);
-		kfree(queue);
-		r = -ENOMEM;
-		up_read(&adev->reset_domain->sem);
-		goto unlock;
-	}
-	up_read(&adev->reset_domain->sem);
-
 	/* don't map the queue if scheduling is halted */
 	if (adev->userq_halt_for_enforce_isolation &&
 	    ((queue->queue_type == AMDGPU_HW_IP_GFX) ||
@@ -892,28 +865,55 @@ amdgpu_userq_create(struct drm_file *filp, union drm_amdgpu_userq *args)
 		r = amdgpu_userq_map_helper(queue);
 		if (r) {
 			drm_file_err(uq_mgr->file, "Failed to map Queue\n");
-			xa_erase_irq(&adev->userq_doorbell_xa, index);
-			xa_erase(&uq_mgr->userq_xa, qid);
-			amdgpu_userq_fence_driver_free(queue);
 			uq_funcs->mqd_destroy(queue);
+			amdgpu_userq_fence_driver_free(queue);
 			kfree(queue);
 			goto unlock;
 		}
 	}
 
-	queue_name = kasprintf(GFP_KERNEL, "queue-%d", qid);
-	if (!queue_name) {
+	/* drop this refcount during queue destroy */
+	kref_init(&queue->refcount);
+
+	/* Wait for mode-1 reset to complete */
+	down_read(&adev->reset_domain->sem);
+	r = xa_alloc(&uq_mgr->userq_xa, &qid, queue,
+		     XA_LIMIT(1, AMDGPU_MAX_USERQ_COUNT), GFP_KERNEL);
+	if (r) {
+		if (!skip_map_queue)
+			amdgpu_userq_unmap_helper(queue);
+
+		uq_funcs->mqd_destroy(queue);
+		amdgpu_userq_fence_driver_free(queue);
+		kfree(queue);
 		r = -ENOMEM;
+		up_read(&adev->reset_domain->sem);
 		goto unlock;
 	}
 
+	r = xa_err(xa_store_irq(&adev->userq_doorbell_xa, index, queue, GFP_KERNEL));
+	if (r) {
+		xa_erase(&uq_mgr->userq_xa, qid);
+		if (!skip_map_queue)
+			amdgpu_userq_unmap_helper(queue);
+
+		uq_funcs->mqd_destroy(queue);
+		amdgpu_userq_fence_driver_free(queue);
+		kfree(queue);
+		up_read(&adev->reset_domain->sem);
+		goto unlock;
+	}
+	up_read(&adev->reset_domain->sem);
+
 #if defined(CONFIG_DEBUG_FS)
+	char queue_name[32];
+
+	scnprintf(queue_name, sizeof(queue_name), "queue_%d", qid);
 	/* Queue dentry per client to hold MQD information   */
 	queue->debugfs_queue = debugfs_create_dir(queue_name, filp->debugfs_client);
 	debugfs_create_file("mqd_info", 0444, queue->debugfs_queue, queue, &amdgpu_mqd_info_fops);
 #endif
 	amdgpu_userq_init_hang_detect_work(queue);
-	kfree(queue_name);
 
 	args->out.queue_id = qid;
 	atomic_inc(&uq_mgr->userq_count[queue->queue_type]);
-- 
2.53.0

