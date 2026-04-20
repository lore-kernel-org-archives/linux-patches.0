Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C25963B9;
	Mon, 20 Apr 2026 13:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691442; cv=none; b=ZPCNHnlRg2vPqilajuf/9EXKPqvMfEHz0T8hQHagdSCuhlKhu8qYsH0Dz13HL4Do6V1OUZYzTyQYEiIfdvuagtQkjMvl6bjZTC21VKaDmyyVDi7B0gX6i4dNhRryQYldf0PoAdQP+uzmywZzfa+nOS1q2QsCDC3XZh/D6bW/pt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691442; c=relaxed/simple;
	bh=GJALDK3NgxUrEXYG6meOs/y9B/fAwbD5dYUuAZTMqDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EfID5nY4iRhTzTQ18Ikpgx5RmoDiVBuoRWTxsiE4OCXJxiqgqGl/KFHEOqKEUNIh8YzivcJ74raitnF0uZJ+T2EoromOGzFSfCrmLQ0o/BjUHH9XNlHx3jzzHMcq2zviwb7KHw5wNzIL41bjJlwxYIbUCDddnuT+v3yRHzA9rNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o0k7Eqpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o0k7Eqpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B2AC2BCB6;
	Mon, 20 Apr 2026 13:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691442;
	bh=GJALDK3NgxUrEXYG6meOs/y9B/fAwbD5dYUuAZTMqDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0k7Eqpm/HEH59Q9CSgRHe2ogRw5VUTsKJWgmUWXqKKBYVAI0H2Q0fwfztCnc9qJj
	 vLQKf1Ib1HXsIYnpM1gX8+yfKnPUNXKJPX6/f/GAYmBQXxeECE2pEctPUEcduWModZ
	 8g82ztfClfoxhQH+gbrDjSPLwf1m6z2oqXv8XPxO9cy00ly2qRSWneacKupZG3Nibq
	 Td7qj/ICse+qIxOzzBr979yrrY2+8ZUevsqxMelatG0Z6Re6LyM2TozVhyG1B52hLM
	 6yoNGQs1rS/RvpKY53fbsaoO9LH0PHLPYzpftaZ84IaB4MaR9fj2okedGkW5QCbT6V
	 Jh0FUvEEL2U5g==
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
Subject: [PATCH AUTOSEL 7.0] drm/amdgpu/userq: unlock cancel_delayed_work_sync for hang_detect_work
Date: Mon, 20 Apr 2026 09:17:04 -0400
Message-ID: <20260420132314.1023554-30-sashal@kernel.org>
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

[ Upstream commit f802f7b0bc0917023f4b5938246fd7abf23fa5e3 ]

cancel_delayed_work_sync for work hand_detect_work should not be
locked since the amdgpu_userq_hang_detect_work also need the same
mutex and when they run together it could be a deadlock.

we do not need to hold the mutex for
cancel_delayed_work_sync(&queue->hang_detect_work). With this in place
if cancel and worker thread run at same time they will not deadlock.

Due to any failures if there is a hand detect and reset that there a
deadlock scenarios between cancel and running the main thread.

[ 243.118276] task:kworker/9:0 state:D stack:0 pid:73 tgid:73 ppid:2 task_flags:0x4208060 flags:0x00080000
[ 243.118283] Workqueue: events amdgpu_userq_hang_detect_work [amdgpu]
[ 243.118636] Call Trace:
[ 243.118639] <TASK>
[ 243.118644] __schedule+0x581/0x1810
[ 243.118649] ? srso_return_thunk+0x5/0x5f
[ 243.118656] ? srso_return_thunk+0x5/0x5f
[ 243.118659] ? wake_up_process+0x15/0x20
[ 243.118665] schedule+0x64/0xe0
[ 243.118668] schedule_preempt_disabled+0x15/0x30
[ 243.118671] __mutex_lock+0x346/0x950
[ 243.118677] __mutex_lock_slowpath+0x13/0x20
[ 243.118681] mutex_lock+0x2c/0x40
[ 243.118684] amdgpu_userq_hang_detect_work+0x63/0x90 [amdgpu]
[ 243.118888] process_scheduled_works+0x1f0/0x450
[ 243.118894] worker_thread+0x27f/0x370
[ 243.118899] kthread+0x1ed/0x210
[ 243.118903] ? __pfx_worker_thread+0x10/0x10
[ 243.118906] ? srso_return_thunk+0x5/0x5f
[ 243.118909] ? __pfx_kthread+0x10/0x10
[ 243.118913] ret_from_fork+0x10f/0x1b0
[ 243.118916] ? __pfx_kthread+0x10/0x10
[ 243.118920] ret_from_fork_asm+0x1a/0x30

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have the full picture. Here is my complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [drm/amdgpu/userq] [unlock/fix] Move `cancel_delayed_work_sync`
for `hang_detect_work` outside the mutex to prevent a deadlock.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>** - author,
  regular AMD GPU contributor
- **Reviewed-by: Christian Konig <christian.koenig@amd.com>** - key
  DRM/AMDGPU maintainer/reviewer
- **Signed-off-by: Alex Deucher <alexander.deucher@amd.com>** - AMDGPU
  subsystem maintainer who committed it
- No Fixes: tag (expected for candidates under review)
- No Cc: stable (expected)
- No Reported-by tag, but includes a stack trace showing the actual
  deadlock

Record: Reviewed by Christian Konig (senior AMDGPU developer), committed
by Alex Deucher (subsystem maintainer). Stack trace provided.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit describes a classic AB-BA deadlock:
- `amdgpu_userq_destroy()` holds `userq_mutex` and calls
  `cancel_delayed_work_sync(&queue->hang_detect_work)`
- `amdgpu_userq_hang_detect_work()` tries to acquire `userq_mutex`
- When both run concurrently, deadlock occurs: destroy waits for work to
  finish, work waits for mutex

The commit includes a full kernel stack trace showing the deadlock in
action (task stuck in `D` state waiting on `__mutex_lock` inside the
workqueue worker for `amdgpu_userq_hang_detect_work`).

Record: Classic deadlock. Symptom is system hang (task in D state).
Triggered when queue destruction races with pending hang detection work.

### Step 1.4: DETECT HIDDEN BUG FIXES
This is explicitly a deadlock fix, not disguised at all. The title says
"unlock" and the body describes the deadlock mechanism clearly.

Record: Not hidden. Explicit deadlock fix.

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **File**: `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c`
- **Function modified**: `amdgpu_userq_destroy()`
- **Lines added**: ~4 (cancel + NULL assignment moved)
- **Lines removed**: ~4 (old placement removed)
- **Scope**: Single-file, single-function surgical fix

Record: 1 file, 1 function, net change ~0 lines (code reorganization).
Surgical fix.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Before**: `cancel_delayed_work_sync(&queue->hang_detect_work)` was
called INSIDE `mutex_lock(&uq_mgr->userq_mutex)`, conditionally (only if
`hang_detect_fence` is set).

**After**: `cancel_delayed_work_sync(&queue->hang_detect_work)` is
called BEFORE `mutex_lock(&uq_mgr->userq_mutex)`, unconditionally. Then
`queue->hang_detect_fence = NULL` is set after acquiring the mutex.

Record: cancel_delayed_work_sync moved outside mutex scope; conditional
removed (cancel is safe to call unconditionally).

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Category**: Deadlock (ABBA lock ordering)

The deadlock path:
1. Thread A (destroy path): `mutex_lock(&uq_mgr->userq_mutex)` ->
   `cancel_delayed_work_sync(&queue->hang_detect_work)` [waits for work
   to finish]
2. Thread B (worker): `amdgpu_userq_hang_detect_work()` ->
   `mutex_lock(&uq_mgr->userq_mutex)` [waits for mutex]

Thread A holds the mutex and waits for the work to complete. The work
holds the CPU and waits for the mutex. Classic deadlock.

Record: ABBA deadlock between userq_mutex and cancel_delayed_work_sync.

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct**: Yes. Moving `cancel_delayed_work_sync` outside
  the mutex breaks the deadlock cycle. `cancel_delayed_work_sync` is
  documented as safe to call on uninitialized or never-scheduled work
  items.
- **Minimal/surgical**: Yes. Only reorders existing operations in one
  function.
- **Regression risk**: Very low. Removing the conditional `if
  (queue->hang_detect_fence)` check is safe because
  `cancel_delayed_work_sync` on a work that hasn't been scheduled is a
  no-op. Setting `hang_detect_fence = NULL` after the mutex is acquired
  is still correct as it's protecting the shared state.

Record: Obviously correct, minimal, very low regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The buggy code was introduced by commit `fc3336be9c629` (Jesse.Zhang,
2026-01-13) which first appeared in v7.0-rc1. This commit added the
`hang_detect_work` mechanism and placed the `cancel_delayed_work_sync`
call inside the mutex lock in `amdgpu_userq_destroy`.

Record: Buggy code introduced in fc3336be9c629, first present in
v7.0-rc1.

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag present. However, the implicit Fixes target is
`fc3336be9c629` which added the hang_detect_work feature with the
deadlock bug.

Record: Implicitly fixes fc3336be9c629 (v7.0-rc1).

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
The file has been heavily modified. Notable: commit `65b5c326ce410`
(refcount userqueues, 2026-03-02) also touches `amdgpu_userq_destroy()`
but did NOT fix this deadlock. That refcount commit has `Cc:
stable@vger.kernel.org`.

Record: The refcount commit (already marked for stable) still has this
deadlock. The fix is standalone.

### Step 3.4: CHECK THE AUTHOR
Sunil Khatri is a regular AMD GPU driver contributor with 10+ commits in
this subsystem. The fix was reviewed by Christian Konig, a key AMDGPU
maintainer.

Record: Experienced contributor; reviewed by subsystem expert.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
The fix applies to the code as it exists in v7.0 (post-fc3336be9c629).
The refcount rework (`65b5c326ce410`) changed the function signature but
did not change the deadlock pattern. The fix needs to be checked for
whether it applies to the pre- or post-refcount version of the code. In
v7.0, the code has the old (non-refcount) signature. The fix targets the
post-refcount version (based on the diff showing
`amdgpu_userq_destroy(struct amdgpu_userq_mgr *uq_mgr, struct
amdgpu_usermode_queue *queue)` instead of `amdgpu_userq_destroy(struct
drm_file *filp, int queue_id)`).

Record: The fix targets the post-refcount version. For v7.0.y, the
refcount commit (`65b5c326ce410`) would need to be applied first (it's
already marked Cc: stable).

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.5
b4 dig could not find the specific commit because it hasn't been
committed to mainline yet (it's a candidate). The refcount commit series
was found on lore. Web search for the deadlock fix patch was blocked by
Anubis bot protection on lore.kernel.org.

Record: Lore investigation limited by anti-scraping measures. Based on
code analysis alone, the deadlock is verified.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
- `amdgpu_userq_destroy()` - the function being fixed
- `amdgpu_userq_hang_detect_work()` - the work handler that creates the
  deadlock

### Step 5.2: TRACE CALLERS
`amdgpu_userq_destroy()` is called from `amdgpu_userq_kref_destroy()`
(line 680), which is the kref release callback. This is triggered via
`amdgpu_userq_put()` (line 701), called when the last reference to a
userqueue is dropped. This happens during:
- Queue destruction IOCTL (user-initiated)
- fini path (cleanup on file descriptor close)

Record: Called during normal queue teardown - common user-triggered
operation.

### Step 5.3-5.4: CALL CHAIN
User -> IOCTL -> `amdgpu_userq_put()` -> `kref_put()` ->
`amdgpu_userq_kref_destroy()` -> `amdgpu_userq_destroy()` [holds mutex]
-> `cancel_delayed_work_sync()` [deadlocks if work is running].

The hang detect work is scheduled during normal fence operations via
`amdgpu_userq_start_hang_detect_work()`, called from
`amdgpu_userq_fence.c`.

Record: Both paths are reachable from normal userspace operations. The
race window is between submitting GPU work (which schedules hang
detection) and destroying a queue.

### Step 5.5: SIMILAR PATTERNS
The `cancel_delayed_work_sync(&uq_mgr->resume_work)` calls throughout
the file are already placed OUTSIDE the mutex (e.g., lines 632, 1391,
1447, etc.), demonstrating the correct pattern. The `hang_detect_work`
cancellation was the only instance that violated this pattern.

Record: All other cancel_delayed_work_sync calls in this file follow the
correct pattern (outside mutex).

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
- **v6.19.y**: `hang_detect_work` does NOT exist. The file exists but
  the feature was not added until v7.0-rc1.
- **v7.0.y**: The bug EXISTS. The `hang_detect_work` was introduced in
  v7.0-rc1 by `fc3336be9c629`.
- No earlier stable trees (6.12.y, 6.6.y, etc.) are affected.

Record: Bug exists ONLY in 7.0.y.

### Step 6.2: BACKPORT COMPLICATIONS
The fix's diff shows the post-refcount function signature
(`amdgpu_userq_destroy(struct amdgpu_userq_mgr *uq_mgr, struct
amdgpu_usermode_queue *queue)`). The v7.0 release has the OLD signature.
The refcount commit (`65b5c326ce410`) is already marked `Cc: stable` and
must be applied first for this fix to apply cleanly.

Record: Needs refcount commit as prerequisite. Minor conflicts possible
if refcount is not applied.

### Step 6.3: RELATED FIXES ALREADY IN STABLE
No related fix for this specific deadlock has been found.

Record: No alternative fix exists.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM AND CRITICALITY
- **Subsystem**: DRM/AMDGPU (GPU drivers)
- **Criticality**: IMPORTANT - AMD GPUs are widely used in desktops,
  laptops, and workstations. Userqueues are a new feature in 7.0 for
  user-mode GPU scheduling.

Record: IMPORTANT subsystem. Affects AMD GPU users with userqueue-
enabled hardware.

### Step 7.2: SUBSYSTEM ACTIVITY
The file has 59 commits between v6.19 and v7.0 - extremely active
development. Userqueue support is new infrastructure being actively
developed.

Record: Very active subsystem. New feature code.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
Users with AMD GPUs that use the new userqueue feature
(AMDGPU_CAP_USERQ). This is new GPU scheduling infrastructure.

Record: AMD GPU users with userqueue support enabled.

### Step 8.2: TRIGGER CONDITIONS
The deadlock is triggered when:
1. A delayed `hang_detect_work` is pending (scheduled after a fence
   submission)
2. The user destroys the queue (via IOCTL or process exit)
3. The work fires and tries to acquire the mutex at the same time

This is a realistic race window, especially during error scenarios (the
hang detection work has a timeout-based delay).

Record: Triggered during queue destruction with pending hang detection.
Realistic race window.

### Step 8.3: FAILURE MODE SEVERITY
**CRITICAL**: System deadlock. Tasks enter D state (uninterruptible
sleep) and cannot be killed. The stack trace in the commit message
confirms this - the system hangs.

Record: System deadlock/hang. Severity: CRITICAL.

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit**: Prevents a deadlock that hangs the system. HIGH benefit.
- **Risk**: Minimal. Reordering a cancel_delayed_work_sync before a
  mutex_lock is obviously correct. The pattern matches all other similar
  calls in the same file. VERY LOW risk.

Record: Benefit HIGH, Risk VERY LOW. Strongly favorable ratio.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**Evidence FOR backporting:**
- Fixes a real, reproducible deadlock (stack trace provided)
- Deadlock leads to system hang (CRITICAL severity)
- Small, surgical fix (reordering ~4 lines in one function)
- Obviously correct (matches the pattern used everywhere else in the
  file)
- Reviewed by Christian Konig (key AMDGPU maintainer)
- Committed by Alex Deucher (subsystem maintainer)
- The bug exists in v7.0 release

**Evidence AGAINST backporting:**
- No Fixes: tag (expected, not a negative signal)
- The feature (`hang_detect_work`) is new in v7.0, so only affects 7.0.y
  stable
- May require the refcount prerequisite commit (`65b5c326ce410`, already
  Cc: stable) to apply cleanly

**UNRESOLVED:**
- Could not verify if the exact commit SHA exists in mainline (the fix
  may be pending in a subsystem tree)
- Mailing list discussion not accessible due to lore anti-scraping

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES - stack trace demonstrates the
   bug, fix is logically obvious
2. **Fixes a real bug?** YES - deadlock
3. **Important issue?** YES - system deadlock/hang (CRITICAL)
4. **Small and contained?** YES - ~8 line change in one function
5. **No new features or APIs?** YES - just reorders existing code
6. **Can apply to stable trees?** YES (7.0.y), with refcount commit
   prerequisite

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not an exception category - this is a standard bug fix (deadlock).

### Step 9.4: MAKE YOUR DECISION
This is a clear deadlock fix for code in v7.0. The fix is small,
obviously correct, reviewed by the right people, and prevents a system
hang. It meets all stable kernel criteria.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Christian Konig, Signed-off-by Alex
  Deucher (subsystem maintainer). Stack trace in commit message.
- [Phase 2] Diff analysis: ~8 lines changed in `amdgpu_userq_destroy()`,
  moves `cancel_delayed_work_sync` before `mutex_lock`
- [Phase 2] Verified `amdgpu_userq_hang_detect_work()` acquires
  `uq_mgr->userq_mutex` at line 168
- [Phase 2] Verified `amdgpu_userq_destroy()` acquires same mutex at
  line 633, then calls `cancel_delayed_work_sync` at line 637 while
  holding it
- [Phase 3] git blame: buggy code introduced by `fc3336be9c629`
  (Jesse.Zhang, 2026-01-13), first in v7.0-rc1
- [Phase 3] `git tag --contains fc3336be9c629`: confirmed present in
  v7.0-rc1 and v7.0
- [Phase 3] Author Sunil Khatri has 10+ commits in amdgpu subsystem
- [Phase 5] Verified all other `cancel_delayed_work_sync` calls in the
  file are placed OUTSIDE the mutex (correct pattern)
- [Phase 5] Traced call chain: IOCTL -> `amdgpu_userq_put()` ->
  `kref_put()` -> `amdgpu_userq_kref_destroy()` ->
  `amdgpu_userq_destroy()`
- [Phase 6] Verified `hang_detect_work` does NOT exist in v6.19.12 (grep
  returned 0 matches)
- [Phase 6] Bug exists ONLY in v7.0.y
- [Phase 6] Prerequisite: refcount commit `65b5c326ce410` (already Cc:
  stable) may be needed for clean apply
- UNVERIFIED: Could not access lore.kernel.org discussion due to anti-
  scraping protection
- UNVERIFIED: Could not confirm the mainline commit SHA (the fix is not
  yet in this tree's git log)

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index e8d12556d690a..ad39460b54dc5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -630,13 +630,14 @@ amdgpu_userq_destroy(struct amdgpu_userq_mgr *uq_mgr, struct amdgpu_usermode_que
 	int r = 0;
 
 	cancel_delayed_work_sync(&uq_mgr->resume_work);
+
+	/* Cancel any pending hang detection work and cleanup */
+	cancel_delayed_work_sync(&queue->hang_detect_work);
+
 	mutex_lock(&uq_mgr->userq_mutex);
+	queue->hang_detect_fence = NULL;
 	amdgpu_userq_wait_for_last_fence(queue);
-	/* Cancel any pending hang detection work and cleanup */
-	if (queue->hang_detect_fence) {
-		cancel_delayed_work_sync(&queue->hang_detect_work);
-		queue->hang_detect_fence = NULL;
-	}
+
 	r = amdgpu_bo_reserve(queue->db_obj.obj, true);
 	if (!r) {
 		amdgpu_bo_unpin(queue->db_obj.obj);
-- 
2.53.0

