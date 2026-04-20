Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83ED43E490;
	Mon, 20 Apr 2026 13:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691802; cv=none; b=hMzVha8BCbgFe0/OtY10MJyOphMOQsyjCsNaH6YcJ7gk0rU5pkmNqv/DV5GoLn9zcHNLMrClceBZ+DxAyr1PROy3QeXdOFhuGtyu8huZ/seDv0dbWX8LpeO3UDbK9FQ4m1fnQ7M1/EZNwl7gRelvg3EKtsnBBTh8ohWkKesgiM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691802; c=relaxed/simple;
	bh=mWRQILyU3nYc0zxb2eBK81xWcn9ZqTdyq0u0KDN1QiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzZiwMTrbHMBVXy9oyi4WgbjKwMV0j05bhNrZ8f94+Es/+bL2+MP7crcfojVe87I3eR35OPvrHNQaG1TAoKT0CKCNySMjKJEM8CXSEn+kvhLkhGSGq8o8TolYm+cJjNxWrJqS88OeqBYTjjGsaZ0dhWGSowy8Un+zhGu4f3Fhp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLrH7nsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLrH7nsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDCBC2BCB7;
	Mon, 20 Apr 2026 13:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691802;
	bh=mWRQILyU3nYc0zxb2eBK81xWcn9ZqTdyq0u0KDN1QiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLrH7nsp/mQr37UQjB5QTf0pF4V9VaxQmxtRZ7+Q/rgRvUtPSuh8KLpOo43yRRiwm
	 MLFVLlLtCoC5wPP3NyKkJ6UuJyYtfeXL8BGk2b5fwyu5IuSu6e9kamyYIeRqqtSDlE
	 8AbouXhsHzqzKsV/HjYVn8qGu0XjUANNhBrl1bZEiw2a1pgEIpg53rOzJyuZs8te3h
	 15GjJTi8j5Ec+glWxSFY0t41MoVyzyTwAJmpfb3oc+oILf6XqThnozY09sBtw0hjfk
	 yPnhKvVs37nRH2SjL24kYCLnA/iLeAlYHN3hRQoc9WNgoqvG/G3+MondSuawL/aaP3
	 v0eGSpTjH6N5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amdgpu: Check for multiplication overflow in checkpoint stack size
Date: Mon, 20 Apr 2026 09:19:56 -0400
Message-ID: <20260420132314.1023554-202-sashal@kernel.org>
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

From: David Francis <David.Francis@amd.com>

[ Upstream commit 421c0f19043337a553e802b2dfe4b56d538ef4d6 ]

get_checkpoint_info() in kfd_mqd_manager_v9.c finds 32-bit value
ctl_stack_size by multiplying two 32-bit values. This can overflow to a
lower value, which could result in copying outside the bounds of
a buffer in checkpoint_mqd() in the same file.

Put in a check for the overflow, and fail with -EINVAL if detected.

v2: use check_mul_overflow()

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amdgpu` (AMD GPU driver, KFD subsystem)
- Action verb: "Check" (adding a missing safety check)
- Summary: Add overflow check to prevent out-of-bounds copy in
  checkpoint stack size computation

**Step 1.2: Tags**
- Signed-off-by: David Francis (author)
- Reviewed-by: Alex Deucher (AMD DRM subsystem maintainer)
- Signed-off-by: Alex Deucher (committer/maintainer)
- No Fixes: tag (expected for autosel candidates)
- No Cc: stable (expected)
- No Reported-by (found by code inspection, not a crash report)

**Step 1.3: Commit Body**
- Bug: `get_checkpoint_info()` computes `ctl_stack_size` by multiplying
  two 32-bit values (`m->cp_hqd_cntl_stack_size *
  NUM_XCC(mm->dev->xcc_mask)`). This can overflow to a smaller value.
- Consequence: The overflowed smaller value is used to size a buffer
  allocation. Later, `checkpoint_mqd()` copies data using the actual
  (non-overflowed) hardware values, writing beyond the buffer boundary.
- Failure mode: Out-of-bounds memory write (buffer overflow)
- Fix: Use `check_mul_overflow()` and return -EINVAL on overflow

**Step 1.4: Hidden Bug Fix Detection**
This is explicitly a bug fix for a buffer overflow vulnerability. The v2
notation indicates the fix went through review iteration.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 6 files changed: `kfd_device_queue_manager.c`,
  `kfd_device_queue_manager.h`, `kfd_mqd_manager.h`,
  `kfd_mqd_manager_v9.c`, `kfd_mqd_manager_vi.c`,
  `kfd_process_queue_manager.c`
- Net change: +22/-8 lines
- Functions modified: `get_checkpoint_info` (v9 and vi),
  `get_queue_checkpoint_info` (dqm), `pqm_get_queue_checkpoint_info`
- Scope: Multi-file but contained - all changes serve a single purpose
  (propagating error from overflow check)

**Step 2.2: Code Flow Change**
- Core fix in `kfd_mqd_manager_v9.c`: replaces unchecked multiplication
  with `check_mul_overflow()`, returning -EINVAL on overflow
- Plumbing: `get_checkpoint_info` and `get_queue_checkpoint_info`
  signatures changed from `void` to `int` to propagate the error
- `kfd_mqd_manager_vi.c`: trivially updated to return 0 (no overflow
  risk since `*ctl_stack_size = 0`)
- `kfd_process_queue_manager.c`: now checks the return value and
  propagates errors

**Step 2.3: Bug Mechanism**
Category: **Buffer overflow / out-of-bounds write**

The flow is:
1. `get_checkpoint_info()` computes `ctl_stack_size =
   m->cp_hqd_cntl_stack_size * NUM_XCC(...)` - can overflow to a small
   value
2. `criu_checkpoint_queues_device()` uses this to allocate a buffer:
   `kzalloc(sizeof(*q_data) + mqd_size + ctl_stack_size, ...)`
3. `checkpoint_mqd_v9_4_3()` loops over each XCC and calls
   `memcpy(ctl_stack_dst, ctl_stack, m->cp_hqd_cntl_stack_size)` for
   each, writing the full actual size
4. Total bytes written = `m->cp_hqd_cntl_stack_size * NUM_XCC(...)` (the
   actual, non-overflowed product), exceeding the buffer

**Step 2.4: Fix Quality**
- Obviously correct: uses standard `check_mul_overflow()` kernel macro
- Minimal/surgical: core logic is 3 lines; rest is necessary type
  signature propagation
- No regression risk: overflow case now fails gracefully with -EINVAL
  instead of silently corrupting memory
- Reviewed by subsystem maintainer Alex Deucher

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- `get_checkpoint_info` was introduced by commit 3a9822d7bd623b (David
  Yat Sin, 2021-01-25) for CRIU checkpoint support
- The multiplication `* NUM_XCC(...)` was added by commit f6c0f3d24478a0
  / a578f2a58c3ab (David Yat Sin, 2025-07-16) "Fix checkpoint-restore on
  multi-xcc"
- The multi-xcc fix was merged in v6.18 and was cherry-picked with `Cc:
  stable@vger.kernel.org`

**Step 3.2: Fixes tag** - No Fixes: tag present, which is expected.

**Step 3.3: File History** - The file is actively developed with 30+
changes since v6.6.

**Step 3.4: Author** - David Francis is an AMD employee working on
KFD/CRIU support.

**Step 3.5: Dependencies** - This commit is standalone. It only changes
the existing code path without requiring other patches.

## PHASE 4: MAILING LIST

- Original submission found at spinics.net/lists/amd-gfx/msg138647.html
  (posted 2026-03-04)
- v2 iteration used `check_mul_overflow()` (v1 presumably used manual
  overflow checks)
- Alex Deucher provided Reviewed-by (msg138731)
- No NAKs or concerns raised
- No explicit stable nomination by reviewers, but the fix targets a bug
  in code that was itself `Cc: stable`

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
- `get_checkpoint_info()` in v9 (core fix)
- `get_queue_checkpoint_info()` in dqm (plumbing)
- `pqm_get_queue_checkpoint_info()` (plumbing)

**Step 5.2: Callers**
- `pqm_get_queue_checkpoint_info()` -> `get_queue_data_sizes()` ->
  `criu_checkpoint_queues_device()` -> `kfd_process_get_queue_info()`
- Called during CRIU checkpoint operations (process migration/save)

**Step 5.4: Reachability**
The path is reachable from userspace through the KFD ioctl interface
during CRIU operations. On multi-XCC AMD GPUs, if
`cp_hqd_cntl_stack_size` is large enough, the multiplication overflows.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy code in stable**
- The multiplication was introduced in commit a578f2a58c3ab, merged in
  v6.18
- The cherry-pick f6c0f3d24478a0 has `Cc: stable@vger.kernel.org`, so it
  was intended for backport to active stable trees
- The 7.0 tree we're evaluating definitely has this code
- Any stable tree that received the multi-xcc fix backport also has the
  bug

**Step 6.2: Backport complexity** - The patch should apply cleanly since
the code structure hasn't changed significantly.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** drm/amdgpu (KFD) - GPU compute driver. Used by ROCm.
Criticality: IMPORTANT for AMD GPU users.

**Step 7.2:** Very actively developed subsystem.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affects users of AMD multi-XCC GPUs (MI200/MI300 series)
who use CRIU checkpoint/restore.

**Step 8.2: Trigger conditions**
- Requires multi-XCC AMD GPU hardware
- Requires CRIU checkpoint operation
- Requires `cp_hqd_cntl_stack_size` large enough to overflow when
  multiplied by XCC count
- Triggerable from userspace via KFD ioctl

**Step 8.3: Failure mode** - Out-of-bounds kernel heap write. Severity:
**HIGH** (memory corruption, potential crash, potential security
vulnerability).

**Step 8.4: Risk-Benefit**
- Benefit: Prevents kernel heap buffer overflow -> HIGH
- Risk: Very low - adds a standard overflow check, graceful error return
- Ratio: Strongly favorable for backport

## PHASE 9: SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real buffer overflow (out-of-bounds heap write)
- Small and contained (+22/-8 lines, mostly plumbing)
- Uses standard kernel overflow checking macro (`check_mul_overflow`)
- Obviously correct - reviewed by subsystem maintainer Alex Deucher
- The buggy code was itself marked `Cc: stable` (the multi-xcc fix), so
  the bug exists in stable trees
- Graceful error handling (returns -EINVAL instead of corrupting memory)

**Evidence AGAINST backporting:**
- The bug requires specific hardware (multi-XCC AMD GPUs) and specific
  operation (CRIU checkpoint)
- The overflow may require unrealistic `cp_hqd_cntl_stack_size` values
  in practice
- The function signature change touches 6 files (though all changes are
  mechanical)

**Stable rules checklist:**
1. Obviously correct and tested? **YES** - uses standard
   `check_mul_overflow()`, reviewed by maintainer
2. Fixes a real bug? **YES** - buffer overflow from integer overflow
3. Important issue? **YES** - out-of-bounds heap write, potential memory
   corruption
4. Small and contained? **YES** - 30 lines total, core logic is 3 lines
5. No new features? **YES** - purely defensive overflow check
6. Applies to stable? **YES** - any tree with the multi-xcc checkpoint
   fix (6.18+, plus stable backports)

## Verification

- [Phase 1] Parsed subject: drm/amdgpu, "Check" (adding safety check),
  overflow in checkpoint stack size
- [Phase 1] Tags: Reviewed-by Alex Deucher (subsystem maintainer),
  Signed-off-by Alex Deucher
- [Phase 2] Diff: 6 files, +22/-8 lines. Core fix is
  `check_mul_overflow()` in `get_checkpoint_info()` v9
- [Phase 2] Traced overflow to buffer allocation in
  `criu_checkpoint_queues_device()` (line 895: kzalloc) and memcpy in
  `checkpoint_mqd()` (line 412) / `checkpoint_mqd_v9_4_3()` (lines
  424-430)
- [Phase 3] git blame: multiplication introduced by f6c0f3d24478a0
  (2025-07-16), cherry-pick of a578f2a58c3ab with `Cc: stable`
- [Phase 3] Original `get_checkpoint_info` introduced by 3a9822d7bd623b
  (2021-01-25)
- [Phase 3] Multi-xcc fix entered mainline in v6.18
- [Phase 4] Found original patch at spinics.net/lists/amd-
  gfx/msg138647.html, Alex Deucher reviewed at msg138731
- [Phase 4] No NAKs, no concerns raised
- [Phase 5] Traced call chain: KFD ioctl -> kfd_process_get_queue_info
  -> get_queue_data_sizes -> pqm_get_queue_checkpoint_info ->
  get_queue_checkpoint_info -> get_checkpoint_info
- [Phase 5] Confirmed overflowed value feeds into buffer allocation
  (kzalloc) but actual memcpy uses non-overflowed per-XCC size
- [Phase 6] Buggy code exists in mainline since v6.18 and in any stable
  tree that backported the multi-xcc checkpoint fix
- [Phase 8] Failure mode: heap buffer overflow (out-of-bounds write),
  severity HIGH

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 7 +++++--
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h           | 3 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c        | 7 +++++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c        | 3 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 8 +++++++-
 6 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 3ddf06c755b52..ab3b2e7be9bd0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2720,7 +2720,7 @@ static int get_wave_state(struct device_queue_manager *dqm,
 			ctl_stack, ctl_stack_used_size, save_area_used_size);
 }
 
-static void get_queue_checkpoint_info(struct device_queue_manager *dqm,
+static int get_queue_checkpoint_info(struct device_queue_manager *dqm,
 			const struct queue *q,
 			u32 *mqd_size,
 			u32 *ctl_stack_size)
@@ -2728,6 +2728,7 @@ static void get_queue_checkpoint_info(struct device_queue_manager *dqm,
 	struct mqd_manager *mqd_mgr;
 	enum KFD_MQD_TYPE mqd_type =
 			get_mqd_type_from_queue_type(q->properties.type);
+	int ret = 0;
 
 	dqm_lock(dqm);
 	mqd_mgr = dqm->mqd_mgrs[mqd_type];
@@ -2735,9 +2736,11 @@ static void get_queue_checkpoint_info(struct device_queue_manager *dqm,
 	*ctl_stack_size = 0;
 
 	if (q->properties.type == KFD_QUEUE_TYPE_COMPUTE && mqd_mgr->get_checkpoint_info)
-		mqd_mgr->get_checkpoint_info(mqd_mgr, q->mqd, ctl_stack_size);
+		ret = mqd_mgr->get_checkpoint_info(mqd_mgr, q->mqd, ctl_stack_size);
 
 	dqm_unlock(dqm);
+
+	return ret;
 }
 
 static int checkpoint_mqd(struct device_queue_manager *dqm,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
index ef07e44916f80..3272328da11f9 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
@@ -192,7 +192,7 @@ struct device_queue_manager_ops {
 
 	int (*reset_queues)(struct device_queue_manager *dqm,
 					uint16_t pasid);
-	void	(*get_queue_checkpoint_info)(struct device_queue_manager *dqm,
+	int	(*get_queue_checkpoint_info)(struct device_queue_manager *dqm,
 				  const struct queue *q, u32 *mqd_size,
 				  u32 *ctl_stack_size);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
index 2429d278ef0eb..06ca6235ff1b7 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
@@ -102,7 +102,8 @@ struct mqd_manager {
 				  u32 *ctl_stack_used_size,
 				  u32 *save_area_used_size);
 
-	void	(*get_checkpoint_info)(struct mqd_manager *mm, void *mqd, uint32_t *ctl_stack_size);
+	int	(*get_checkpoint_info)(struct mqd_manager *mm, void *mqd,
+				       uint32_t *ctl_stack_size);
 
 	void	(*checkpoint_mqd)(struct mqd_manager *mm,
 				  void *mqd,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index a535f151cb5fd..fe471a8b98095 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -393,11 +393,14 @@ static int get_wave_state(struct mqd_manager *mm, void *mqd,
 	return 0;
 }
 
-static void get_checkpoint_info(struct mqd_manager *mm, void *mqd, u32 *ctl_stack_size)
+static int get_checkpoint_info(struct mqd_manager *mm, void *mqd, u32 *ctl_stack_size)
 {
 	struct v9_mqd *m = get_mqd(mqd);
 
-	*ctl_stack_size = m->cp_hqd_cntl_stack_size * NUM_XCC(mm->dev->xcc_mask);
+	if (check_mul_overflow(m->cp_hqd_cntl_stack_size, NUM_XCC(mm->dev->xcc_mask), ctl_stack_size))
+		return -EINVAL;
+
+	return 0;
 }
 
 static void checkpoint_mqd(struct mqd_manager *mm, void *mqd, void *mqd_dst, void *ctl_stack_dst)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
index 69c1b8a690b86..5a758ed14ea50 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -275,10 +275,11 @@ static int get_wave_state(struct mqd_manager *mm, void *mqd,
 	return 0;
 }
 
-static void get_checkpoint_info(struct mqd_manager *mm, void *mqd, u32 *ctl_stack_size)
+static int get_checkpoint_info(struct mqd_manager *mm, void *mqd, u32 *ctl_stack_size)
 {
 	/* Control stack is stored in user mode */
 	*ctl_stack_size = 0;
+	return 0;
 }
 
 static void checkpoint_mqd(struct mqd_manager *mm, void *mqd, void *mqd_dst, void *ctl_stack_dst)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index f5d2847e1cbb4..cc2621ae12f9c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -1070,6 +1070,7 @@ int pqm_get_queue_checkpoint_info(struct process_queue_manager *pqm,
 				  uint32_t *ctl_stack_size)
 {
 	struct process_queue_node *pqn;
+	int ret;
 
 	pqn = get_queue_by_qid(pqm, qid);
 	if (!pqn) {
@@ -1082,9 +1083,14 @@ int pqm_get_queue_checkpoint_info(struct process_queue_manager *pqm,
 		return -EOPNOTSUPP;
 	}
 
-	pqn->q->device->dqm->ops.get_queue_checkpoint_info(pqn->q->device->dqm,
+	ret = pqn->q->device->dqm->ops.get_queue_checkpoint_info(pqn->q->device->dqm,
 						       pqn->q, mqd_size,
 						       ctl_stack_size);
+	if (ret) {
+		pr_debug("amdkfd: Overflow while computing stack size for queue %d\n", qid);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.53.0

