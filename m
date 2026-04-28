Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8123B401A11;
	Tue, 28 Apr 2026 10:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372946; cv=none; b=QpvY7Z+qgyngwr2xcMQDBMEpNtO9234p4T53rF8zxsiyUX2BPpq9I5dFkaQnvG8c5dTknU7b14wCCNq8/hgoZ2XyNsimLfJLBjlCoXlZ7CxvMwozANPtjigXNDFqVroPUJSIeemJtdqfLopg3omJEgSJa3k3XJ+qMOGE9PPnds0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372946; c=relaxed/simple;
	bh=YYIkqQ9a4OfiF9mbQz1HCnpw6DUneyXAQGZOQZZE1VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bxaaNIK6C0bk5QJ0ZF7Y2HrC99N0wO+cO8J/tWXXYncsq6pfhgSOmv4HobEIbc132nTOapY2MOefyZ5xUR0Sf8Gs28b7wBmpjoPa9wcVllTUwTE3zBylCnIoAVBBzyjBQx5Gn0TYPCzlaLTeX3JcTv+lcsF4SY4HgJDNkkmbslg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m0ANKoGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m0ANKoGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16686C2BCB5;
	Tue, 28 Apr 2026 10:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372946;
	bh=YYIkqQ9a4OfiF9mbQz1HCnpw6DUneyXAQGZOQZZE1VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0ANKoGh+LyZJNtdfctZEjcmeg+yu4QtSdJ6HGk4oM0AChO+2VQLiuLlyR1Ohfri0
	 hD6dSmG6rS0gdYRjxS+9PLOpBBxHqtLfL9tX9ALwKz9P6xGLb/LCIlEiouwa1f0UJA
	 aMKfzHuDsEPUXEhq1pipOjrii4atz0ImIsQF+EbHdQNomDGvETO/mBdajuBSkxAK7N
	 PqwETkbtPwkfeXnELGO6c+zD2pxE1/kwcLR3n10O8UQxHZWwA+N2NUjlKO3l6ToWPH
	 mY9e4UTdsrEK6IA7CQIcInb8BTLwyz90CuIGnr3I9MFKXoaRKg3aJNns31VU5fB2/g
	 d+iTdvnMBBvPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	daniel@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amdgpu: drop userq fence driver refs out of fence process()
Date: Tue, 28 Apr 2026 06:40:48 -0400
Message-ID: <20260428104133.2858589-37-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Transfer-Encoding: 8bit

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit dd88d42d9ca0dd7a4ed327dd33f6ead76cedf726 ]

amdgpu_userq_wait_ioctl() takes extra references on waited-on fence
drivers and stores them in waitq->fence_drv_xa. When a new userq fence is
created, those references are transferred into userq_fence->fence_drv_array
so they can be released when the fence completes.

However, those inherited references are currently only dropped from
amdgpu_userq_fence_driver_process(). If a fence never reaches that path,
such as it is already signaled when created, so we need to explicitly release
those fences in that case.

v2: use a list(list_cut_before) for managing the signal userq driver fences.(Christian)
    Link: https://patchwork.freedesktop.org/patch/718078/?series=164763&rev=2
v3: Doesn't cache the userq first unsignaled fence and use the cut before list
    head directly.(Christian)

Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me write the final analysis.

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1:** Subsystem: `drm/amdgpu`. Action verb: "drop"
(release/cleanup). One-line summary: drop userq fence driver references
out of the fence-process path so they get released even when a fence is
already signaled at creation.
Record: drm/amdgpu drop - releases fence driver refs on the signaled-at-
create path.

**Step 1.2:** Tags found:
- `Cc: Alex Deucher` - co-author/maintainer notification
- `Signed-off-by: Prike Liang` - author at AMD
- `Reviewed-by: Christian König` - AMD subsystem maintainer
- `Signed-off-by: Alex Deucher` - applied via Alex's tree
- `Link:
  https://patchwork.freedesktop.org/patch/718078/?series=164763&rev=2` -
  v2 reference
- v3 noted, no Cc: stable, no Fixes:, no Reported-by

Record: Reviewed and signed by maintainers; no syzbot/stable tags;
passed through 3 review iterations.

**Step 1.3:** Bug description: `amdgpu_userq_wait_ioctl()` takes
references on each waited-on fence driver and stores them in
`waitq->fence_drv_xa`. When a new fence is later created via
`amdgpu_userq_fence_create()`, those references are transferred into
`userq_fence->fence_drv_array`. The releases of those refs happen
exclusively in `amdgpu_userq_fence_driver_process()`. If the fence is
already signaled at creation time (HW already advanced past wptr), the
fence is never linked into `fence_drv->fences` and therefore never goes
through `amdgpu_userq_fence_driver_process()`, so the inherited
`fence_drv` references are leaked.

**Step 1.4:** This is clearly described as a leak fix; not disguised as
cleanup.

### PHASE 2: DIFF ANALYSIS

**Step 2.1:** Single file:
`drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c`, +33/-14. Functions
changed: new helper `amdgpu_userq_fence_put_fence_drv_array()`, modifies
`amdgpu_userq_fence_driver_process()` and `amdgpu_userq_fence_create()`.
Surgical single-file fix.

**Step 2.2:** Three change clusters:
1. New helper `amdgpu_userq_fence_put_fence_drv_array()` to put each
   entry of the inherited fence_drv array.
2. `amdgpu_userq_fence_driver_process()` reworked to: walk under
   spinlock to find the boundary, `list_cut_before()` to splice signaled
   entries to a local `to_be_signaled` list, drop the spinlock, then
   signal & put refs outside the lock. This avoids dropping `fence_drv`
   refs (which can call destroy → take various locks) while holding
   `fence_list_lock`.
3. `amdgpu_userq_fence_create()`: when the fence is already signaled at
   creation, set a `signaled = true` flag and call the new helper after
   releasing the spinlock to drop the inherited refs.

**Step 2.3:** Bug category: (b) reference counting / resource leak fix.
Specific mechanism: The inherited `fence_drv` references in
`userq_fence->fence_drv_array` were only released in the fence-list
processing path (signal+remove). When the fence was already signaled at
creation, the inherited refs leaked. Each leaked ref pins an
`amdgpu_userq_fence_driver` (which holds GPU memory via seq64). Plus a
structural improvement: putting refs outside `fence_list_lock` is needed
because the put can chain into destroy callbacks.

**Step 2.4:** Fix is logically correct (verified `list_cut_before`
semantics: when iterator points at head after the loop completes,
`cut_before(head)` moves all entries; when iterator is the first non-
signaled entry, `cut_before(entry)` moves correct prefix; empty list is
no-op). Minor risk: changes locking discipline in
`fence_driver_process()` - now releases & signals outside the lock. This
is safer wrt deadlock but is a behavioral change that could expose new
races if any caller assumes the function holds the lock through signal.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1:** The buggy mechanism (`fence_drv_array` transfer + only-
release-in-process) was introduced in `e7cf21fbb2773` (Oct 2024) and the
userq feature itself in `a292fdecd7283` (Oct 2024), both first appearing
in v6.16. Bug present in all v6.16+ kernels.

**Step 3.2:** No `Fixes:` tag. Underlying buggy code is in v6.16,
present in stable trees 6.18.y and 7.0.y (6.16/6.17 are EOL).

**Step 3.3:** Many related fixes recently:
- `8e051e38a8d45 drm/amdgpu/userq: Fix fence reference leak on queue
  teardown v2` — already in 6.18.y/7.0.y stable
- `48c33af0b62d8 drm/amdgpu: make userq fence_drv drop explicit in queue
  destroy` — Mar 2026, NOT in stable
- `34f31fe40f3a1 drm/amdgpu: rework userq fence driver alloc/destroy` —
  Mar 2026, NOT in stable
- `a1371d9f0e611 drm/amdgpu: rework amdgpu_userq_wait_ioctl v4` — 582
  lines, NOT in stable
20 commits to this file have landed in master since the 7.0.y branch
point.

**Step 3.4:** Author Prike Liang is an AMD engineer with multiple recent
userq commits. Reviewer Christian König is the dma-fence/amdgpu
maintainer.

**Step 3.5:** The diff context shows references to `userq->last_fence =
NULL;` and a comment "Drop the queue's ownership reference to fence_drv
explicitly" that come from earlier reworks NOT in stable, but those are
*context lines* only - the actual hunks don't depend on them.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1:** `b4 dig -c dd88d42d9ca0d` could not find the patch on lore
(likely hosted on amd-gfx archives at lists.freedesktop.org rather than
indexed on lore). The commit message points to patchwork.freedesktop.org
(Anubis-protected from automated fetches). Web searches didn't surface
explicit stable nominations or NAKs for v3.

**Step 4.2/4.3/4.4/4.5:** Could not directly fetch the discussion due to
access restrictions. The commit went through 3 revisions with explicit
review feedback from Christian König incorporated each iteration.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1:** Functions: `amdgpu_userq_fence_driver_process`,
`amdgpu_userq_fence_create`, new
`amdgpu_userq_fence_put_fence_drv_array`.

**Step 5.2:** Callers:
- `amdgpu_userq_fence_driver_process` — called from interrupt handlers
  (`gfx_v11_0_eop_irq`, `gfx_v12_0_eop_irq`) and from
  `amdgpu_userq_fence_driver_force_completion` (process context). Hot
  path.
- `amdgpu_userq_fence_create` — called from `amdgpu_userq_signal_ioctl`
  (userspace ioctl).

**Step 5.3:** The functions interact with `dma_fence`, the per-userq
fence list, and the per-userq `fence_drv_xa` xarray.

**Step 5.4:** Reachable from userspace via
`DRM_IOCTL_AMDGPU_USERQ_SIGNAL` and `DRM_IOCTL_AMDGPU_USERQ_WAIT`
ioctls. Any application using user-mode queues on RDNA3+/Navi3X+ AMD
GPUs can hit it.

**Step 5.5:** The leak pattern — only releasing inherited refs in one
specific path — is unique to this code; no sibling pattern needs the
same fix.

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1:** Buggy code in 6.18.y, 6.19.y, 7.0.y. Not in 6.12.y or
earlier (userq feature didn't exist).

**Step 6.2:** Verified the patch applies cleanly with a 4-line offset to
both `stable/linux-6.18.y` and `stable/linux-7.0.y`:

```text
Hunk #1 succeeded at 151 (offset 6 lines).
Hunk #2 succeeded at 174 (offset 6 lines).
Hunk #3 succeeded at 256 (offset 14 lines).
Hunk #4 succeeded at 303-304 (offset 14-15 lines).
```

**Step 6.3:** No earlier/different fix for this exact leak in stable.
Related leak fix `8e051e38a8d45` (last_fence leak on teardown) is
already in stable.

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** drm/amdgpu, IMPORTANT level - widely deployed driver, but
the userq feature is gated to specific newer GPUs.

**Step 7.2:** Highly active subsystem; userq is in heavy flux (over 20
commits to this file since the 7.0 branch point).

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected: users of AMD RDNA3+ GPUs (Navi3X family and
newer) using user-mode queues - this includes Mesa with the new UMD
path. CONFIG_DRM_AMDGPU_NAVI3X_USERQ was removed in v6.16, so it's
unconditionally available.

**Step 8.2:** Trigger conditions:
- App uses userq wait+signal ioctl pattern (typical of Mesa with UMD)
- HW completes the new fence's seqno before the create path checks
  `dma_fence_is_signaled()`
- This is realistic for fast HW - the wptr is read, then a fence is
  constructed, and HW can advance during that window.
- Each occurrence leaks one or more fence_drv references (depending on
  how many fences the wait-on set had).

**Step 8.3:** Failure mode: kernel + GPU memory leak. Not a crash, not a
security issue. Severity MEDIUM — accumulates over long-running graphics
workloads. Each leaked `fence_drv` retains:
- The fence_drv struct itself
- A seq64 GPU memory allocation
- An entry in `adev->userq_xa`

**Step 8.4:** Benefit: MEDIUM (real leak in user-reachable path on
common workloads for this hardware). Risk: MEDIUM-LOW — 47-line change
but well-contained, reviewed through 3 iterations, applies cleanly. The
locking restructure also fixes a latent concern (dropping refs inside
the spinlock could chain into destroy callbacks).

### PHASE 9: FINAL SYNTHESIS

**Step 9.1:** Evidence FOR: real reachable memory leak (kernel + GPU
memory), reviewed by subsystem maintainer through v1/v2/v3, applies
cleanly to active stable trees containing the bug, sibling fix
`8e051e38a8d45` was backported, the affected feature ships
unconditionally in 6.18+. Evidence AGAINST: no `Fixes:` or `Cc: stable`
tag, structural change rather than minimal one-liner, userq feature
still in heavy flux.

**Step 9.2:** Stable rules:
1. Obviously correct/tested — Yes, reviewed by maintainer, multi-version
2. Real bug — Yes, reference/memory leak
3. Important — Medium: accumulating leak, not crash
4. Small — Borderline: 47 lines, single file, three logical changes
5. No new features — Correct
6. Apply cleanly — Yes, verified for 6.18 and 7.0

**Step 9.3:** No exception category needed - this is a straightforward
bug fix.

**Step 9.4:** Decision: The fix targets a real leak in user-reachable
code (userq signal/wait ioctl on AMD GPUs), is properly reviewed,
applies cleanly to active stable trees, and follows the same pattern as
previously-backported sibling fixes. The structural rework is necessary
to drop refs safely outside the spinlock. The userq subsystem is
volatile, but this change is self-contained and addresses an unambiguous
defect. Tilts toward backport-worthy.

### Verification

- [Phase 1] Parsed tags: Reviewed-by Christian König (subsystem
  maintainer), no Cc:stable, no Fixes:, v1→v3 evolution noted in commit
  message.
- [Phase 2] Diff inspected with `git show dd88d42d9ca0d`: 4 hunks, 33
  added / 14 removed, single file. Manually traced `list_cut_before`
  semantics including empty list and full-iterate-without-break corner
  cases - logic correct.
- [Phase 3] `git tag --contains
  a292fdecd72834b3bec380baa5db1e69e7f70679` — userq feature first in
  v6.16. `git tag --contains e7cf21fbb2773` — fence_drv_array transfer
  mechanism first in v6.16.
- [Phase 3] `git log --oneline stable/linux-7.0.y..origin/master --
  drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c` shows 20 commits not
  in 7.0.y stable; surveyed 8e051e38a8d45 (sibling backported fix),
  48c33af0b62d8, 34f31fe40f3a1 (not yet in stable, but our patch's hunks
  don't depend on them).
- [Phase 4] `b4 dig -c dd88d42d9ca0d` - no lore match (commit was on
  amd-gfx fdo list, points to patchwork). Web searches confirmed there's
  a v2 and v3 with Christian's review feedback.
- [Phase 5] Verified callers via Grep on the file:
  `amdgpu_userq_fence_driver_process` is called from
  `gfx_v11_0_eop_irq`/`gfx_v12_0_eop_irq` (irq) and
  `amdgpu_userq_fence_driver_force_completion`.
  `amdgpu_userq_fence_create` only from `amdgpu_userq_signal_ioctl`.
- [Phase 6] Read content of file in `stable/linux-7.0.y` and
  `stable/linux-6.18.y`: same vulnerable pattern
  (`fence_drv_array_count` only released in `fence_driver_process`).
- [Phase 6] `git apply --check` against stable 7.0.y and 6.18.y file
  contents - applies cleanly with offsets 6/6/14/14-15.
- [Phase 8] Failure mode: persistent memory leak (kernel struct + GPU
  seq64 + userq_xa entry) per occurrence. Not crash; not security.
- UNVERIFIED: Could not directly fetch the original lore/freedesktop
  discussion due to Anubis bot protection; relied on patchwork link in
  commit message and prior commits' patterns.
- UNVERIFIED: Could not run the patched code; correctness of the rework
  was reasoned from kernel `list_cut_before` semantics in source.

The fix addresses a real, user-reachable, ongoing GPU+kernel memory leak
with proper review, applies cleanly to active stable trees with the bug,
and matches the pattern of previously-backported sibling fixes in the
same file.

**YES**

 .../gpu/drm/amd/amdgpu/amdgpu_userq_fence.c   | 47 +++++++++++++------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index 5239b06b9ab03..147d3cbab7a88 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -151,13 +151,22 @@ amdgpu_userq_fence_driver_free(struct amdgpu_usermode_queue *userq)
 	amdgpu_userq_fence_driver_put(userq->fence_drv);
 }
 
+static void
+amdgpu_userq_fence_put_fence_drv_array(struct amdgpu_userq_fence *userq_fence)
+{
+	unsigned long i;
+	for (i = 0; i < userq_fence->fence_drv_array_count; i++)
+		amdgpu_userq_fence_driver_put(userq_fence->fence_drv_array[i]);
+	userq_fence->fence_drv_array_count = 0;
+}
+
 void amdgpu_userq_fence_driver_process(struct amdgpu_userq_fence_driver *fence_drv)
 {
 	struct amdgpu_userq_fence *userq_fence, *tmp;
+	LIST_HEAD(to_be_signaled);
 	struct dma_fence *fence;
 	unsigned long flags;
 	u64 rptr;
-	int i;
 
 	if (!fence_drv)
 		return;
@@ -165,21 +174,26 @@ void amdgpu_userq_fence_driver_process(struct amdgpu_userq_fence_driver *fence_d
 	spin_lock_irqsave(&fence_drv->fence_list_lock, flags);
 	rptr = amdgpu_userq_fence_read(fence_drv);
 
-	list_for_each_entry_safe(userq_fence, tmp, &fence_drv->fences, link) {
-		fence = &userq_fence->base;
-
-		if (rptr < fence->seqno)
+	list_for_each_entry(userq_fence, &fence_drv->fences, link) {
+		if (rptr < userq_fence->base.seqno)
 			break;
+	}
 
-		dma_fence_signal(fence);
-
-		for (i = 0; i < userq_fence->fence_drv_array_count; i++)
-			amdgpu_userq_fence_driver_put(userq_fence->fence_drv_array[i]);
+	list_cut_before(&to_be_signaled, &fence_drv->fences,
+				&userq_fence->link);
+	spin_unlock_irqrestore(&fence_drv->fence_list_lock, flags);
 
-		list_del(&userq_fence->link);
+	list_for_each_entry_safe(userq_fence, tmp, &to_be_signaled, link) {
+		fence = &userq_fence->base;
+		list_del_init(&userq_fence->link);
+		dma_fence_signal(fence);
+		/* Drop fence_drv_array outside fence_list_lock
+		 * to avoid the recursion lock.
+		 */
+		amdgpu_userq_fence_put_fence_drv_array(userq_fence);
 		dma_fence_put(fence);
 	}
-	spin_unlock_irqrestore(&fence_drv->fence_list_lock, flags);
+
 }
 
 void amdgpu_userq_fence_driver_destroy(struct kref *ref)
@@ -242,6 +256,7 @@ static int amdgpu_userq_fence_create(struct amdgpu_usermode_queue *userq,
 	struct amdgpu_userq_fence_driver *fence_drv;
 	struct dma_fence *fence;
 	unsigned long flags;
+	bool signaled = false;
 
 	fence_drv = userq->fence_drv;
 	if (!fence_drv)
@@ -288,13 +303,17 @@ static int amdgpu_userq_fence_create(struct amdgpu_usermode_queue *userq,
 
 	/* Check if hardware has already processed the job */
 	spin_lock_irqsave(&fence_drv->fence_list_lock, flags);
-	if (!dma_fence_is_signaled(fence))
+	if (!dma_fence_is_signaled(fence)) {
 		list_add_tail(&userq_fence->link, &fence_drv->fences);
-	else
+	} else {
+		signaled = true;
 		dma_fence_put(fence);
-
+	}
 	spin_unlock_irqrestore(&fence_drv->fence_list_lock, flags);
 
+	if (signaled)
+		amdgpu_userq_fence_put_fence_drv_array(userq_fence);
+
 	*f = fence;
 
 	return 0;
-- 
2.53.0

