Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906F655CE76;
	Mon, 19 Oct 2026 13:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418239; cv=none; b=VwvLgfKinU/RSfYcMfuXAW8sP2n8Kcd2olHeO4KlcSK3gydYjEJ7w7fqLwXY9S6lH7ppHikDyxBiyMKUkixLiQO4LR6vvExPmijWEoK33NQIG/iCAPfeWatNe+isT2T3WCVqZhjlKahrqk3SWnz25XtUqfJSTTERZbXDxtBDdGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418239; c=relaxed/simple;
	bh=vqFbRly23EmmxTrPZcEQkCDnXyRjQ9XD4YD4cyNdGQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2cmVZyDyltYDILK3Zkm8r0qHRr2GIZnuwl05vUL87+gURXYUeks7w/adlgsZCWt3+TkYeHL+K+VhRv0a4iaFspDVwDF0cGP/uxS298XrioRBBI9yLp/PG0yfdAAboI7ZC+VO0/+ifEqbiBhKe/DXry/zBk0Mkh1hc2KmfquHRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGCmYSQM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGCmYSQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904031F000C8;
	Mon, 19 Oct 2026 13:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418236;
	bh=FoVTH5v7nGfYL8VkLgCxJwXogVW5kfS36iI9kg5EnXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGCmYSQMeR4p1rm0XXXmahrEfvdPNaj/rVDZlaM9irOHPji89Q1FeOMItkyAzWfrb
	 RJXfaMi7+LC/qgUmuYVR18GKkOzNg5CAqdkKEGLuOSevp51N6kqzxtybpbEirmk1wS
	 FUP9p6zJ9RHWmCMDah8wwEg4A1ec/IfnmT4CumUrugwVW8qviRcuDp3l1/LbIzUOti
	 98hDVNpIk7HVHgiOLC54RQj9W1YBcdL+gxEsA+i8szgt1p1jPiHrd8j8r5tkqyMmbN
	 mTQBQBijT0TBtFBmqw/mfuC2RVJMPjDuPdzNLHM0o34G/zoXwslx+R1APagkYqqE/3
	 ccP6S/6fLpkcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: em28xx: requeue buffers if start_streaming fails
Date: Mon, 19 Oct 2026 09:46:40 -0400
Message-ID: <20261019135441.1420968-109-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 67f87b104f4ef3108607ac9d8fa2075b13ed314d ]

If start_streaming fails, then all queued buffers must be
returned to vb2 in state QUEUED.

Otherwise it will trigger a WARN_ON.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
candidate is a real videobuf2 `start_streaming` error-path bug in
`em28xx`: queued buffers were left driver-owned, which fires `WARN_ON`
and can leave stale entries on `dmaq->active`.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[media/em28xx] [requeue] [return queued vb2 buffers when
start_streaming fails]**
Subsystem `media: em28xx`. Action is “requeue” (correctness on failure,
not a feature).

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** Hans Verkuil \<hverkuil+cisco@kernel.org\> (author
  tested it)
- **Reviewed-by / Acked-by:** none on the commit
- **Link:** none in the commit; lore found via `b4 dig` (Phase 4)
- **Cc: stable:** none (expected)
- **Signed-off-by:** Hans Verkuil (author); Mauro Carvalho Chehab (media
  maintainer). Ignore any Sasha Levin SOB if present — none on this
  commit.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** If `start_streaming` fails, buffers already given to the
  driver via `buf_queue` are not returned to vb2 as
  `VB2_BUF_STATE_QUEUED`.
- **Symptom:** vb2 `WARN_ON` in `vb2_start_streaming()` when
  `owned_by_drv_count != 0`.
- **Version info:** none in the message.
- **Root cause (author):** driver violates the documented
  `start_streaming` contract.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not hidden.** Explicit contract fix. Cover letter (Phase 4)
also states this patch “correctly gives the vb2 buffers back … if
start_streaming fails.”

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/media/usb/em28xx/em28xx-video.c` — **+16 / −2**
- Function: `em28xx_start_analog_streaming()`
- Scope: **single-file surgical error-path fix**

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** `res_get()` failure and `em28xx_init_usb_xfer()` failure
  both `return rc` immediately. Buffers already on `vidq`/`vbiq`
  `active` stay driver-owned.
- **After:** those paths `goto exit`, which under `dev->slock` walks
  `dmaq->active`, `list_del`s each buffer, and calls
  `vb2_buffer_done(..., VB2_BUF_STATE_QUEUED)`. Success still increments
  `streaming_users` and returns 0.
- **Path affected:** STREAMON / qbuf-triggered `start_streaming`
  **error** path only.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **[Logic / vb2 contract] + memory-safety follow-on**
- vb2 calls `__enqueue_in_driver()` → `buf_queue` **before**
  `start_streaming` (`videobuf2-core.c`).
- `buffer_queue` / `vbi_buffer_queue` put buffers on `dev->vidq.active`
  / `dev->vbiq.active`.
- On failure the driver must `vb2_buffer_done(..., QUEUED)` (documented
  in `videobuf2-core.h` `@start_streaming`).
- Without that, `vb2_start_streaming()` does
  `WARN_ON(owned_by_drv_count)` and force-reclaims in vb2 **without**
  unlinking the driver’s list, so `dmaq->active` can keep dangling
  `em28xx_buffer` pointers. `get_next_buf()` later takes
  `dma_q->active.next` — **UAF** on a later successful stream.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** Matches `em28xx_stop_streaming()` and the standard V4L2
  pattern. Author is V4L2 maintainer; self-tested.
- **Minimal:** only the failure cleanup.
- **Regression risk:** low (error path, same lock as stop). Minor
  incompleteness: `stop_streaming` also completes `usb_ctl.vid_buf`;
  this path does not. `em28xx_alloc_urbs()` already NULLs those pointers
  before submit, and failed `init_usb_xfer` calls
  `em28xx_uninit_usb_xfer()`. Common failures (`res_get` -EBUSY,
  alloc/submit fail with empty in-flight slot) are covered. Incomplete
  vs. a rare in-flight URB does not make the patch wrong.
- **No API/feature changes.**

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- `em28xx_start_analog_streaming` comes from **d3829fadc461**
  (“\[media\] em28xx: convert to videobuf2”, 2013-01-05), contained in
  **v3.9-rc1**.
- Failure just `return rc` is that old. Bug is long-standing, not
  new-7.3 code.

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Closest related error-path change:
**cc20e81da6d99** (“fix missing res_free() on init_usb_xfer failure”,
2026-05) added `res_free()` before `return rc`. This commit turns that
`return` into `goto exit`. Complementary, not a substitute.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Same series (lifecycle): `288254383674b`, `de626073dfcbb`,
  `7c8bf63b79371`, `c132b07f7e585` — device lifetime/UAF, **not
  required** for this hunk.
- This is **standalone**: only the start_streaming returns change. Cover
  letter lists it as 6/6, but the diff does not use symbols those
  patches add.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Hans Verkuil is a V4L2 maintainer (not the em28xx MAINTAINERS
entry; that is Mauro Chehab, who signed this off). Same class of fix
historically: e.g. **80b0963e1698e** “\[media\] pwc: fix WARN_ON”
(QUEUED vs ERROR on start_streaming failure).

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **No hard functional dependency.** Applies against the pre-fix
function in this tree’s parent. Older stables without `cc20e81` only
need a trivial context adjust (`return rc` vs `res_free`+`return rc`).
**Standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 67f87b104f4ef`: **[PATCHv2 6/6]** https://patch.msgid.link/
  141d43a4860c6007269e9725cc717a556d22d2a4.1781615432.git.hverkuil+cisco
  @kernel.org
- `b4 dig -a`: v1 was a 3-patch lifecycle series (2026-05-19); v2 is
  **[PATCHv2 0/6] media: em28xx: fix lifecycle issues** (2026-06-16).
  Applied version is v2 patch 6.
- Cover letter: last patch returns buffers if start_streaming fails;
  **tested on author’s em28xx device**.
- **No NAK** on patch 6. Sakari Ailus only discussed patch 1
  (`v4l2-async`).
- **No reviewer Cc: stable.** WebFetch to lore returned **403**; thread
  recovered via `b4 dig -m`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc **linux-media**, Hans Verkuil, Mauricio
Faria de Oliveira, Sakari Ailus. Merged by Mauro Chehab. No separate
Reviewed-by on 6/6.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Author found it while testing the lifecycle
series. Mechanism is specified in vb2 (WARN_ON comment names this exact
driver bug class).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Series 1–5 are separate lifecycle/UAF work. **6/6 is self-
contained** and does not need 1–5 in this tree.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No “stable” in the matched mbox. WebSearch did not find a
stable-list thread for this subject (lore HTML 403). **No evidence it
was rejected for stable.**

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **`em28xx_start_analog_streaming`**. Helpers used: `res_get`,
`res_free`, `em28xx_init_usb_xfer`, `vb2_buffer_done`.

Step 5.2: TRACE CALLERS
Record: Wired as `.start_streaming` in:
- `em28xx_video_qops` (`em28xx-video.c`)
- `em28xx_vbi_qops` (`em28xx-vbi.c`)
Callers are vb2 (`vb2_start_streaming` ← `vb2_core_streamon` /
`vb2_core_qbuf`). **Userspace V4L2 STREAMON/QBUF.**

Step 5.3: TRACE CALLEES
Record: `res_get` can return **-EBUSY**. `em28xx_init_usb_xfer` can fail
on URB alloc, `usb_clear_halt`, or `usb_submit_urb` (and then
`em28xx_uninit_usb_xfer`). Those are realistic (disconnect, ENOMEM, USB
error).

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace ioctl → vb2 enqueues via `buf_queue` →
`start_streaming` → on failure, buffers must be returned. **Reachable
from userspace** with `CONFIG_VIDEO_EM28XX` / `CONFIG_VIDEO_EM28XX_V4L2`
and a device node.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Many drivers return `VB2_BUF_STATE_QUEUED` on start_streaming
failure (uvc, pwc, gspca, hackrf, platform capture drivers). em28xx was
missing that. Historical media commits: pwc, coda, cal, am437x-vpfe.

semcode MCP: **not available** in this session (only `cursor` dynamic
tools). Used grep/read instead.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** This checkout is **7.3.0-rc4**. Commit
**67f87b104f4ef** **is an ancestor of HEAD** (in since v7.3-rc1). Parent
of the commit still has the bare `return rc` paths. Driver and
`em28xx_start_analog_streaming` have been here since the vb2 conversion
(**v3.9**). The bug is not “new after this branch.”

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: For **this** tree the patch is already applied and matches
current `em28xx-video.c`. Against the pre-fix function it is a clean,
18-line change. No conflicting refactor in the start_streaming body
itself.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `cc20e81da6d99` (res_free on USB-init failure) is in this tree.
It does **not** requeue buffers. No other equivalent fix for this
WARN_ON.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **drivers/media/usb/em28xx** — USB analog/VBI capture (Empia,
Hauppauge, etc.). **IMPORTANT** for users of that hardware,
**PERIPHERAL** vs core mm/net. Not staging.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained (lifecycle series, device IDs, UAFs in
2026). Mature driver, old bug. MAINTAINERS: Mauro Chehab; linux-media.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific** (`CONFIG_VIDEO_EM28XX` / V4L2). Empia USB
capture sticks and several Hauppauge devices. Not universal, but real
hardware.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: `VIDIOC_STREAMON` (or qbuf that starts streaming) when
  `res_get` fails or USB xfer init fails.
- Commonness: error path, not every boot. USB submit/alloc failure and
  unplug-during-start are realistic.
- Unprivileged: yes if the user can open `/dev/video*` (typical `video`
  group).

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Immediate: **WARN_ON** in vb2 (`videobuf2-core.c` around the “driver
  isn’t cleaning up properly after a failed start_streaming()” comment).
  `panic_on_warn` → panic.
- Follow-on: leftover `dmaq->active` entries after vb2 force-reclaim →
  **UAF** in `get_next_buf()` on retry.
- **Severity: HIGH** (WARN_ON + UAF on retry). Not a silent style issue.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** high for em28xx users (stops WARN_ON and dangling DMA
  list).
- **Risk:** very low (~16 lines, error path, same locking as stop).
- **Ratio:** favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR:**
- Real vb2 contract violation; documented WARN_ON.
- Dangling `active` list can UAF on the next STREAMON.
- Small, obviously correct, matches driver stop path and many other V4L2
  drivers.
- V4L2 maintainer authored and tested on real em28xx hardware; media
  maintainer merged it.
- Bug in code since ~v3.9; present in this tree’s pre-fix function.
- Standalone; no new API.

**AGAINST:**
- USB capture driver, not core; only hits failed STREAMON.
- No syzbot / external Reported-by.
- Patch 6/6 of a larger series (but this hunk does not depend on 1–5).
- Does not also complete `usb_ctl.vid_buf` (stop_streaming does); common
  fail paths still fixed.

**UNRESOLVED:**
- lore.kernel.org HTTP 403 for WebFetch; thread read via `b4` mbox
  instead.
- No stable@ discussion found.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — contract match + Tested-by
   author on hardware.
2. Fixes a real bug that affects users? **PASS** — STREAMON failure on a
   used USB capture driver.
3. Important issue? **PASS** — WARN_ON; UAF on retry. HIGH, not
   cosmetic.
4. Small and contained? **PASS** — 16 insertions / 2 deletions, one
   function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — code is this driver; patch
   already applies here (it is in 7.3-rc1+). No missing prerequisites
   for *this* hunk.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **None** (not an ID/quirk/DT/build/docs exception). It is a
normal small bugfix.

Step 9.4: MAKE YOUR DECISION
This tree has the em28xx analog/VBI vb2 path. The fix is a classic,
surgical start_streaming cleanup that prevents WARN_ON and leftover
driver-owned buffers. It meets stable rules for this checkout.

What it solves for users of this tree: failed `VIDIOC_STREAMON` no
longer trips vb2’s `WARN_ON` and no longer leaves capture buffers on
`dmaq->active` for a later UAF.

Risk vs benefit: error-path only, low regression risk, meaningful
correctness fix.

Concerns: none that block a backport here; series membership is
packaging, not a code dependency.

Verification:
- \[Phase 1\] Parsed tags: Tested-by Hans Verkuil; SOB Hans + Mauro; no
  Fixes/Reported-by/Cc stable
- \[Phase 2\] Diff: +16/-2 in `em28xx_start_analog_streaming`; `return
  rc` → `goto exit` + `vb2_buffer_done(QUEUED)`
- \[Phase 2\] Confirmed vb2 contract and WARN_ON in
  `vb2_start_streaming()` (`videobuf2-core.c` ~1769–1815)
- \[Phase 2\] Confirmed `buf_queue` adds to `vidq`/`vbiq` active before
  start_streaming
- \[Phase 2\] Confirmed `get_next_buf()` uses `dma_q->active.next` (UAF
  if list not cleared)
- \[Phase 3\] `git blame`: function from d3829fadc461 (v3.9-rc1)
- \[Phase 3\] `git merge-base --is-ancestor 67f87b104f4ef HEAD` → yes
  (exit 0)
- \[Phase 3\] `git describe HEAD` → v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` → 7.3.0-rc4
- \[Phase 3\] Related: cc20e81da6d99 only adds res_free; does not
  requeue
- \[Phase 4\] `b4 dig -c 67f87b104f4ef`: PATCHv2 6/6; cover letter
  describes this exact fix; tested on em28xx
- \[Phase 4\] `b4 dig -a`: v1 3-patch → v2 6-patch lifecycle series; 6/6
  standalone
- \[Phase 4\] `b4 dig -w`: linux-media, Sakari Ailus, Mauricio Faria de
  Oliveira
- \[Phase 4\] WebFetch lore/msgid.link: 403; used mbox instead
- \[Phase 5\] Callers: `em28xx_video_qops` and `em28xx_vbi_qops`
  `.start_streaming`
- \[Phase 5\] Failures: `res_get` -EBUSY; `em28xx_init_usb_xfer`
  alloc/halt/submit
- \[Phase 6\] Pre-fix parent still has bare `return rc`; this tree
  includes the fix
- \[Phase 7\] MAINTAINERS: EM28XX VIDEO4LINUX DRIVER, Mauro Chehab
- \[Phase 8\] Failure: WARN_ON + dangling list UAF; severity HIGH
- UNVERIFIED: stable@ mailing list (lore HTTP 403; no hit in matched
  mbox)

The patch is small, correct, and fixes a real WARN_ON/UAF class bug in
code this tree carries.

**YES**

 drivers/media/usb/em28xx/em28xx-video.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index c8514682bccda..e0a69309687b0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1070,6 +1070,9 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	struct em28xx_dmaqueue *dmaq = vq->type == V4L2_BUF_TYPE_VBI_CAPTURE ?
+		&dev->vbiq : &dev->vidq;
+	unsigned long flags = 0;
 	struct v4l2_frequency f;
 	struct v4l2_fh *owner;
 	int rc = 0;
@@ -1084,7 +1087,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	 */
 	rc = res_get(dev, vq->type);
 	if (rc)
-		return rc;
+		goto exit;
 
 	if (v4l2->streaming_users == 0) {
 		/* First active streaming user, so allocate all the URBs */
@@ -1107,7 +1110,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 					  em28xx_urb_data_copy);
 		if (rc < 0) {
 			res_free(dev, vq->type);
-			return rc;
+			goto exit;
 		}
 
 		/*
@@ -1132,7 +1135,18 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	v4l2->streaming_users++;
+	return 0;
 
+exit:
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&dmaq->active)) {
+		struct em28xx_buffer *buf;
+
+		buf = list_entry(dmaq->active.next, struct em28xx_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
 	return rc;
 }
 
-- 
2.53.0

