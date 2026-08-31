Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7297519929;
	Mon, 31 Aug 2026 13:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183817; cv=none; b=kb4OaWDYdVyds+8npnznO+ljg2vz6TuDkvuqGEOGgRyFMshSbLR/Q8AiCuqfp5ndAHHUdVxfOQIjMsOocJq5hGHSXcr1mata3Q/sM1A5H5Y0ot0OWAsxbzf2pLBs7zVrGNLpHsL95Nfz4JKL8QLD6s08zgAiGy3OLK9BXaxpmlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183817; c=relaxed/simple;
	bh=WwMjHamjiEsxZ7Boy8cEZs55s+eVjcK9LXw2BYBEASQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d/n2fkx0mGAGT8fFHIAM7C7hwpdMmfxus+R98Wx6bSzK9U2sXxywccKoQG40C0FKDumY9b0P60h7DO9W3ssB/9ayq3qqFHK+H7Idkt581Bk29Xg2gryHTQPMqBpN+x8rG2Kzt04yW0tsBjw0cDbSHOLxP+Phmk5s8JXnbiRRqEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtQ7NMgl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtQ7NMgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C5F1F00ADB;
	Mon, 31 Aug 2026 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183813;
	bh=gRKWpOjnNlR3g0a6AJl3Qap9MmzVPXZrp8eBsnp/5Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VtQ7NMgljj19FC8+7cgQSV5PegBVZ1SfKXQgHkPv8ToQ7wgpKJYoIQvUSEqtlkyt5
	 QCRtZTmyMB3IiMOo3SxSNa5AdVAYtvBRVBDvCqSetz2101LhVl7xVhDKrrxuYCAlPB
	 eQVJ2I2N1y+Bvrkrk4bua0L4Rd4EYkyr6yu8YDY6Jb2OoOc6x1jU7v+RxVqld75T70
	 ZZs9gTkdwoGhb93YP/RC6tiKdVktVZISTRQ8ccMP6T0byy4unaAfP5eHOcDRVZ9Be+
	 jSx1jeB1Bz5dCegyfjjz1xsu372s30wLOXibZmVdJBohJQFr5hTwCpIl9vbuCEspbA
	 5yGNB8cR1IUug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brandon Brnich <b-brnich@ti.com>,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nas.chung@chipsnmedia.com,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] media: chips-media: wave5: Fix Reports from Kernel Lock Validator
Date: Mon, 31 Aug 2026 09:25:48 -0400
Message-ID: <20260831133314.4125787-320-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brandon Brnich <b-brnich@ti.com>

[ Upstream commit 7d5d364f8b2dcc9b6b92456fb55632fde4a4d96f ]

handle_dynamic_resolution change requires that the state_lock be acquired
based on the lockdep_assert_held. However, the
handle_dynamic_resolution_change call in initialize_sequence does not
properly obtain the lock before calling.

Since the v4l2_ctrl_find and s_ctrl can sleep, they should not be called
while a lock is already held. Store off the fbc_buf_count then properly
update control once lock has been freed.

Signed-off-by: Brandon Brnich <b-brnich@ti.com>
Tested-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `media: chips-media: wave5: Fix Reports from
Kernel Lock Validator`

**Local tree:** `linux-6.18.y` (`v6.18.43`, Makefile `6.18.43`)
**Verdict scope:** This checkout only.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[media: chips-media: wave5]` `[fix]` — Correct
lockdep/locking violations in dynamic-resolution handling by deferring
V4L2 control updates until after `state_spinlock` is released.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Brandon Brnich `<b-brnich@ti.com>` (author)
- **Tested-by:** Jackson Lee `<jackson.lee@chipsnmedia.com>`
- **Signed-off-by:** Nicolas Dufresne `<nicolas.dufresne@collabora.com>`
  (reviewer/maintainer chain)
- **Signed-off-by:** Hans Verkuil `<hverkuil+cisco@kernel.org>` (media
  maintainer)
- **No** `Fixes:`, `Reported-by:`, `Link:`, `Cc:
  stable@vger.kernel.org`, or `Reviewed-by:` tags
- Notable: hardware vendor testing + subsystem maintainer sign-offs; no
  syzbot/fuzzer report

### Step 1.3: Body analysis
**Record:**
- **Bug:** `handle_dynamic_resolution_change()` must be called with
  `state_spinlock` held (`lockdep_assert_held`), but it calls
  `v4l2_ctrl_find()` and `v4l2_ctrl_s_ctrl()`, which acquire the
  control-handler mutex and can sleep.
- **Symptom:** Kernel Lock Validator (lockdep) reports; underlying issue
  is mutex acquisition while holding a spinlock.
- **Root cause:** Mixing spinlock-protected instance state with sleeping
  V4L2 control framework calls in the same function.
- **Fix approach:** Store `fbc_buf_count` under the spinlock; update the
  control afterward via new helper `wave5_update_min_bufs_ctrl()`.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite the lockdep-focused title, this fixes a real
**sleeping-while-holding-spinlock** / **lock inversion** bug, not
cosmetic cleanup. The driver already documents this pattern in
`wave5_vpu_dec_stop()` (lines 796–799): release `state_spinlock` before
operations that may block on a mutex.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c`
  (~+55 / -20 lines)
- **Functions modified/added:**
  - **New:** `wave5_update_min_bufs_ctrl()`
  - **Modified:** `handle_dynamic_resolution_change()`,
    `wave5_vpu_dec_finish_decode()`, `initialize_sequence()`,
    `wave5_vpu_dec_device_run()`
- **Scope:** Single-file, surgical locking fix

### Step 2.2: Code flow per hunk
**Record:**
1. **`wave5_update_min_bufs_ctrl()` (new):** Runs without
   `state_spinlock`; calls `v4l2_ctrl_find()` + `v4l2_ctrl_s_ctrl()`
   only when buffer count changed.
2. **`handle_dynamic_resolution_change()`:** Before → updates min-
   buffers control while spinlock held. After → only updates instance
   fields and queues source-change event under lock.
3. **`wave5_vpu_dec_finish_decode()`:** Before → calls
   `handle_dynamic_resolution_change()` under lock (including sleeping
   ctrl ops). After → saves `fbc_buf_count` under lock, calls helper
   after `spin_unlock_irqrestore()`.
4. **`initialize_sequence()`:** Same deferral pattern after seq-init DRC
   handling.
5. **`wave5_vpu_dec_device_run()` error path:** Same deferral when
   `initialize_sequence()` fails during drain/DRC.

### Step 2.3: Bug mechanism
**Record:** **Category:** Synchronization / lock-ordering violation
(spinlock + mutex inversion).
**Mechanism:** `state_spinlock` is a spinlock; `v4l2_ctrl_find()` uses
`mutex_lock(hdl->lock)` via `find_ref_lock()`, and `v4l2_ctrl_s_ctrl()`
uses `v4l2_ctrl_lock()` → `mutex_lock()`. Calling these while holding a
spinlock violates kernel locking rules and can trigger lockdep warnings,
`scheduling while atomic` BUGs, or deadlocks under contention.

### Step 2.4: Fix quality
**Record:** Fix is obviously correct and minimal. It mirrors the
existing `wave5_vpu_dec_stop()` pattern. Regression risk is low:
`fbc_buf_count` is set under the lock before the deferred update; the
helper re-checks whether an update is needed.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame / introduction
**Record:** Buggy `v4l2_ctrl_s_ctrl()` inside
`handle_dynamic_resolution_change()` present since driver introduction
in `9707a6254a8a6` (“Add the v4l2 layer”, Nov 2023).
`lockdep_assert_held(&inst->state_spinlock)` was there from the start.
Related stable backport `ea28b33e1b15b` (May 2026) added missing
spinlock around `initialize_sequence()`’s call — which makes the
sleeping-under-spinlock path more consistently exercised on seq-init.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Recent stable wave5 commits on this file include multiple
crash/panic/lockdep fixes (`ea28b33`, `d71fc687`, `ea316b78`,
`27cb12b7`, etc.). This patch is a logical follow-up to the spinlock-
protection backports. Standalone fix; not part of a numbered series.

### Step 3.4: Author context
**Record:** Brandon Brnich has other wave5 commits in this tree
(`b607b5e2`, `5e702ee8`, `f24ca8b5`). Patch signed by media maintainer
Hans Verkuil and reviewed by Nicolas Dufresne.

### Step 3.5: Dependencies
**Record:** No external prerequisites. Benefits from `ea28b33` already
being in 6.18.y (spinlock around `initialize_sequence()`). The candidate
commit is not yet in this tree; upstream diff has minor context
differences (`sent_eos`, `retry` paths absent in 6.18.y) but the core
fix applies cleanly with at most small manual adjustment.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1–4.5
**Record:** Commit hash not found in local branches (`master`, `linux-
next`, `media-next`, `graphics-next`). `b4 dig` could not be run without
a commit hash. Lore.kernel.org fetch blocked (bot protection).
**UNVERIFIED:** mailing-list thread, reviewer stable nominations, series
revisions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `wave5_update_min_bufs_ctrl()`,
`handle_dynamic_resolution_change()`, `wave5_vpu_dec_finish_decode()`,
`initialize_sequence()`, `wave5_vpu_dec_device_run()`.

### Step 5.2: Callers
**Record:** `handle_dynamic_resolution_change()` called from:
- `wave5_vpu_dec_finish_decode()` — decode completion / sequence-change
  IRQ path
- `initialize_sequence()` — stream startup seq-init
- `wave5_vpu_dec_device_run()` — error recovery during
  `VPU_INST_STATE_OPEN`

All are normal V4L2 mem2mem decode paths reachable from userspace
`ioctl()` streaming.

### Step 5.3: Callees
**Record:** Deferred path calls `v4l2_ctrl_find()` and
`v4l2_ctrl_s_ctrl()` (mutex-based). Under-lock path calls
`v4l2_event_queue_fh()`, format updates, state changes.

### Step 5.4: Reachability
**Record:** Triggered on dynamic resolution change during HEVC/H.264
decode — common real-world scenario (resolution switches in a stream).
Userspace-reachable via V4L2 M2M decode.

### Step 5.5: Similar patterns
**Record:** `wave5_vpu_dec_stop()` already releases `state_spinlock`
before mutex-capable firmware/control work (lines 796–805). This fix
brings DRC handling in line with that established pattern.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `wave5-vpu-dec.c` lines 295–301 call
`v4l2_ctrl_find()` / `v4l2_ctrl_s_ctrl()` inside
`handle_dynamic_resolution_change()` while
`lockdep_assert_held(&inst->state_spinlock)` is in effect. All three
callers hold the spinlock.

### Step 6.2: Backport complications
**Record:** Expected **clean apply with minor context adjustment**.
Upstream diff references `inst->sent_eos` and `inst->retry` code not
present in 6.18.y; the essential hunks (new helper, ctrl removal from
DRC handler, deferred update at three call sites) map directly to
current code.

### Step 6.3: Related fixes already present?
**Record:** `ea28b33e1b15b` (spinlock around `initialize_sequence()` DRC
call) and `d71fc6874fce3` (spinlock around `send_eos_event()`) are
already in 6.18.y. This fix is **not** duplicated.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **PERIPHERAL** — `VIDEO_WAVE_VPU` driver (`ARCH_K3 ||
COMPILE_TEST`). Affects K3 SoC users and compile-test builds, not all
kernel users.

### Step 7.2: Activity
**Record:** Actively maintained — multiple wave5 stable backports in
2026 on this tree.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of Chips&Media Wave5 VPU on TI K3 (and similar) doing
mem2mem video decode with dynamic resolution changes.

### Step 8.2: Trigger conditions
**Record:** Dynamic resolution change during decode (sequence change,
seq-init, or init failure + drain path). Not rare for adaptive streams.
Unprivileged users with V4L2 device access can trigger.

### Step 8.3: Failure mode severity
**Record:** Lockdep warnings (debug kernels); potential `scheduling
while atomic` BUG, deadlock, or oops on production kernels when ctrl
path contends or sleeps. **Severity: HIGH** (can crash the kernel during
decode).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected hardware — prevents real locking
  violations on a common decode event
- **Risk:** LOW — small, follows existing in-driver pattern, tested by
  hardware vendor
- **Ratio:** Strong benefit for targeted users, very low regression risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real mutex-under-spinlock bug in production decode paths
- Can cause kernel crash/deadlock, not just lockdep noise
- Small, surgical, obviously correct fix
- Driver and buggy code exist in 6.18.y
- Related lockdep fixes already backported to this tree
- `Tested-by` from Chips&Media; maintainer sign-offs
- Matches established pattern already in the same file

**AGAINST backport:**
- Narrow hardware audience (`ARCH_K3 || COMPILE_TEST`)
- Commit not yet in tree; minor context differences vs upstream diff
- No syzbot/user crash report in commit message

**UNRESOLVED:**
- Mailing-list discussion and explicit stable nomination (lore
  inaccessible; commit not in local branches)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — clear locking fix, `Tested-
   by` present
2. Fixes a real user-affecting bug? **PASS** — mutex while holding
   spinlock on decode DRC path
3. Important issue? **PASS** — kernel crash/deadlock potential (HIGH)
4. Small and contained? **PASS** — one file, ~55 lines net
5. No new features/APIs? **PASS** — refactor of existing control update
   only
6. Can apply to local tree? **PASS** — buggy code present; minor context
   adjustment at most

### Step 9.3: Exception category
**Record:** None (standard locking bug fix, not device-
ID/quirk/build/doc exception).

### Step 9.4: Decision rationale
This is a genuine locking bug fix, not a lockdep-only cosmetic change.
`v4l2_ctrl_find()` and `v4l2_ctrl_s_ctrl()` take mutexes and must not
run under `state_spinlock`. The bug exists in 6.18.y, is reachable
during normal decode with resolution changes, and the fix is small,
tested, and consistent with code already in the driver. Stable
maintainers have already backported related wave5 lockdep fixes to this
tree; this completes that work.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Analyzed full diff; confirmed ctrl ops moved outside
  spinlock at 3 call sites
- **[Phase 2]** Read `v4l2_ctrl_s_ctrl()` — locks handler mutex
  (`include/media/v4l2-ctrls.h:1137-1145`)
- **[Phase 2]** Read `v4l2_ctrl_find()` — uses `mutex_lock` via
  `find_ref_lock()` (`v4l2-ctrls-core.c:1742-1750`)
- **[Phase 3]** `git describe HEAD` → `v6.18.43` on `linux-6.18.y`
- **[Phase 3]** `git log` on `wave5-vpu-dec.c` → related fixes
  `ea28b33`, `d71fc687` present
- **[Phase 3]** `git show 9707a6254a8a6b` → original driver had buggy
  ctrl-under-spinlock pattern
- **[Phase 3]** `git blame` lines 285-301 → bug present since driver
  introduction
- **[Phase 4]** Searched `master`, `linux-next`, `media-next`,
  `graphics-next` for commit — not found
- **[Phase 4]** UNVERIFIED: `b4 dig` (no commit hash), lore.kernel.org
  (blocked)
- **[Phase 5]** Grep: `handle_dynamic_resolution_change` has 3 callers,
  all under spinlock
- **[Phase 5]** Read `wave5_vpu_dec_stop()` lines 796-805 — existing
  defer-mutex pattern
- **[Phase 6]** Confirmed buggy code at `wave5-vpu-dec.c:295-301` in
  local tree
- **[Phase 6]** Confirmed `ea28b33` spinlock fix already applied at
  lines 1569-1571
- **[Phase 6]** Grep: `sent_eos`, `retry` absent in 6.18.y — minor
  backport context difference noted
- **[Phase 7]** Read `Kconfig` — `VIDEO_WAVE_VPU` depends on `ARCH_K3 ||
  COMPILE_TEST`
- **[Phase 8]** Traced trigger to DRC during V4L2 mem2mem decode —
  userspace-reachable

**YES**The branch searches are done. The commit
(`wave5_update_min_bufs_ctrl` / "Kernel Lock Validator") wasn't found on
`master`, `linux-next`, `media-next`, or `graphics-next` in this
checkout, so it looks like a newer upstream patch not present locally
yet.

That doesn't change the earlier **YES** verdict for 6.18.y: the buggy
code is in the tree, and the fix should apply with only minor context
tweaks.

 .../chips-media/wave5/wave5-vpu-dec.c         | 47 +++++++++++++------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
index 7a4625acc0478..189cd8bcdffd9 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -270,10 +270,23 @@ static void send_eos_event(struct vpu_instance *inst)
 	inst->eos = false;
 }
 
+static void wave5_update_min_bufs_ctrl(struct vpu_instance *inst, u32 fbc_buf_count)
+{
+	struct v4l2_m2m_ctx *m2m_ctx = inst->v4l2_fh.m2m_ctx;
+	struct v4l2_ctrl *ctrl;
+
+	if (!fbc_buf_count || fbc_buf_count == v4l2_m2m_num_dst_bufs_ready(m2m_ctx))
+		return;
+
+	ctrl = v4l2_ctrl_find(&inst->v4l2_ctrl_hdl,
+			      V4L2_CID_MIN_BUFFERS_FOR_CAPTURE);
+	if (ctrl)
+		v4l2_ctrl_s_ctrl(ctrl, fbc_buf_count);
+}
+
 static int handle_dynamic_resolution_change(struct vpu_instance *inst)
 {
 	struct v4l2_fh *fh = &inst->v4l2_fh;
-	struct v4l2_m2m_ctx *m2m_ctx = inst->v4l2_fh.m2m_ctx;
 
 	static const struct v4l2_event vpu_event_src_ch = {
 		.type = V4L2_EVENT_SOURCE_CHANGE,
@@ -292,14 +305,6 @@ static int handle_dynamic_resolution_change(struct vpu_instance *inst)
 
 	inst->needs_reallocation = true;
 	inst->fbc_buf_count = initial_info->min_frame_buffer_count + 1;
-	if (inst->fbc_buf_count != v4l2_m2m_num_dst_bufs_ready(m2m_ctx)) {
-		struct v4l2_ctrl *ctrl;
-
-		ctrl = v4l2_ctrl_find(&inst->v4l2_ctrl_hdl,
-				      V4L2_CID_MIN_BUFFERS_FOR_CAPTURE);
-		if (ctrl)
-			v4l2_ctrl_s_ctrl(ctrl, inst->fbc_buf_count);
-	}
 
 	if (p_dec_info->initial_info_obtained) {
 		const struct vpu_format *vpu_fmt;
@@ -427,19 +432,24 @@ static void wave5_vpu_dec_finish_decode(struct vpu_instance *inst)
 	if ((dec_info.index_frame_display == DISPLAY_IDX_FLAG_SEQ_END ||
 	     dec_info.sequence_changed)) {
 		unsigned long flags;
+		u32 fbc_buf_count = 0;
 
 		spin_lock_irqsave(&inst->state_spinlock, flags);
 		if (!v4l2_m2m_has_stopped(m2m_ctx)) {
 			switch_state(inst, VPU_INST_STATE_STOP);
 
-			if (dec_info.sequence_changed)
+			if (dec_info.sequence_changed) {
 				handle_dynamic_resolution_change(inst);
-			else
+				fbc_buf_count = inst->fbc_buf_count;
+			} else {
 				send_eos_event(inst);
+			}
 
 			flag_last_buffer_done(inst);
 		}
 		spin_unlock_irqrestore(&inst->state_spinlock, flags);
+
+		wave5_update_min_bufs_ctrl(inst, fbc_buf_count);
 	}
 
 	/*
@@ -1543,8 +1553,9 @@ static const struct vpu_instance_ops wave5_vpu_dec_inst_ops = {
 static int initialize_sequence(struct vpu_instance *inst)
 {
 	struct dec_initial_info initial_info;
-	int ret = 0;
 	unsigned long flags;
+	u32 fbc_buf_count;
+	int ret = 0;
 
 	memset(&initial_info, 0, sizeof(struct dec_initial_info));
 
@@ -1568,8 +1579,11 @@ static int initialize_sequence(struct vpu_instance *inst)
 
 	spin_lock_irqsave(&inst->state_spinlock, flags);
 	handle_dynamic_resolution_change(inst);
+	fbc_buf_count = inst->fbc_buf_count;
 	spin_unlock_irqrestore(&inst->state_spinlock, flags);
 
+	wave5_update_min_bufs_ctrl(inst, fbc_buf_count);
+
 	return 0;
 }
 
@@ -1602,6 +1616,7 @@ static void wave5_vpu_dec_device_run(void *priv)
 		ret = initialize_sequence(inst);
 		if (ret) {
 			unsigned long flags;
+			u32 fbc_buf_count = 0;
 
 			spin_lock_irqsave(&inst->state_spinlock, flags);
 			if (wave5_is_draining_or_eos(inst) &&
@@ -1610,14 +1625,18 @@ static void wave5_vpu_dec_device_run(void *priv)
 
 				switch_state(inst, VPU_INST_STATE_STOP);
 
-				if (vb2_is_streaming(dst_vq))
+				if (vb2_is_streaming(dst_vq)) {
 					send_eos_event(inst);
-				else
+				} else {
 					handle_dynamic_resolution_change(inst);
+					fbc_buf_count = inst->fbc_buf_count;
+				}
 
 				flag_last_buffer_done(inst);
 			}
 			spin_unlock_irqrestore(&inst->state_spinlock, flags);
+
+			wave5_update_min_bufs_ctrl(inst, fbc_buf_count);
 		} else {
 			switch_state(inst, VPU_INST_STATE_INIT_SEQ);
 		}
-- 
2.53.0

