Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B8760FF13;
	Mon, 19 Oct 2026 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418626; cv=none; b=n82I2hkkFcRrZwcT4Ldzv4BmU1kNtZ3+9EedpDI5rWWHJPUSAPuFwuYOcixV3y1OMG7+JxzPac4Po+k0j8zhr7ibRudaZO7N2jfhVvsUxZLv97RM0AOt1hnFXRedQPr19KQ+WDa9K7GvgoEn0JXHAJ10IJB6tPR6BQkm3kZ+5NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418626; c=relaxed/simple;
	bh=ZGnTgfXqdal5DZnvrtBQ2YiyOLTR25XTTjrIwhgswps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nm1CyMDM82MB3dviva96UC/Jkx831rYWL9lCXyPPJqdFFYWSpNrbCJTRkmyJ0fYswZ1eWTfa3dUCOQ8el7u0OM1RCGyK+2IIiTeFY5TKUVxNKUn5OYogs/dWEhlQIUs6ktZhQ6JYfD8luSB7a95T6WjZCMneOkteatzzVZYCnTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVCZWA1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVCZWA1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDD01F000C7;
	Mon, 19 Oct 2026 14:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418622;
	bh=okAr1bUawofvPjILhZ5Aw4ILC5K/NCJtVAorY5sCEL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVCZWA1n4W1utnIjsBMMlPnaXWfnR5Wc8eV3RX3PZbabg1k9EQUPVQGQe0KB1cGU1
	 dwCSzreB2SWiwdlRcWOraY37+MoqZBY61NnkjVAmwWWOy38FTu8ZeZiaxm56Thi9UA
	 XoTSgGKSBi2S2DNWlb5gk998k6aoLq2kwNDHhymdwog8BOGmNiBeWcaJu8w6eYXkag
	 fZ2h7pNSbMOJAeZOUnSThG4I0QRjPzQ7CIJLHyUA5QVwZLzVm21SI0Zk3rYsLPLTSs
	 ELECbJ5oCcgwVUZAx094lKc6g5+jg4Iwl152WrCcMy/K/qt+osFNa0U0Ks6cek1dse
	 co/JUEXf3NDEA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jurison Murati <eng.juri@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] media: i2c: ov8865: Program the sensor on stream start
Date: Mon, 19 Oct 2026 09:51:11 -0400
Message-ID: <20261019135441.1420968-380-sashal@kernel.org>
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

From: Jurison Murati <eng.juri@gmail.com>

[ Upstream commit 4e1446ac169a1a621ba90502ab8db3be821fe726 ]

The sensor registers are only written in the runtime PM resume
handler; ov8865_set_fmt() merely stores the requested mode, relying on
the sensor being runtime suspended between uses so that the next
resume applies it.

That assumption breaks when something keeps the sensor powered. On
IPU3 platforms, ipu_bridge instantiates the VCM device with a
DL_FLAG_PM_RUNTIME device link to the sensor, so a userspace process
holding the VCM subdev open (e.g. wireplumber's camera monitor) pins
the sensor runtime-active. A subsequent set_fmt() then never reaches
the hardware: the sensor keeps streaming the mode programmed on the
last resume while the CSI-2 receiver expects the newly negotiated
format.

On a Surface Book 2 (IPU3, ov8865 + dw9719 VCM), requesting the
3264x2448 mode while the hardware was left programmed for the
1632x1224 binned mode makes ipu3-cio2 report "frame sync error" and
"payload length is 10340352, received 2585088" (exactly one binned
frame) for every frame, and the inverse case stalls the stream after
a single frame. Camera applications end up displaying one bogus frame
forever.

Program the sensor configuration and apply the control values on
stream start instead, where the negotiated mode is always current,
and only write the configuration in the runtime PM resume handler
when resuming with the stream already started.

Signed-off-by: Jurison Murati <eng.juri@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
verdict is whether this ov8865 programming fix belongs **here**, not in
other series.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[media: i2c: ov8865] [Program] Program the sensor on stream
start` — “Program” here is a correctness change: write the negotiated
mode at `s_stream`, not only on runtime resume.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Jurison Murati <eng.juri@gmail.com>` (author)
- `Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>`
  (media/I2C sensor maintainer; merger)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable`, `Link:`, or syzbot tags (absence expected)
- Mailing-list thread (Phase 4) has `Reviewed-by: Daniel Scally` on
  series patch 1/2 only, not on this 2/2 as merged

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `set_fmt()` only stores the mode; registers are written in the
  runtime-PM resume handler. That assumes the sensor suspends between
  uses.
- Trigger: IPU3 `ipu_bridge` VCM device link (`DL_FLAG_PM_RUNTIME`) plus
  userspace holding the VCM subdev open (wireplumber camera monitor)
  keeps the sensor runtime-active, so resume never runs after
  `set_fmt()`.
- Symptom: CSI-2 receiver (`ipu3-cio2`) sees a format mismatch. Full
  3264×2448 vs leftover 1632×1224 binned mode → `"frame sync error"` and
  `"payload length is 10340352, received 2585088"`; the inverse stalls
  after one frame. Camera apps show one bogus frame forever.
- Hardware: Surface Book 2 (IPU3, ov8865 + dw9719 VCM).
- Fix: program + apply controls on stream start; resume only reprograms
  if already streaming (mid-stream suspend).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit functional bug: hardware left in the
previous mode.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/media/i2c/ov8865.c` (+25 / −9)
- Functions: `ov8865_s_stream()`, `ov8865_resume()`
- Scope: single-file, surgical

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- `ov8865_s_stream(enable=1)` before: `pm_runtime_resume_and_get()` then
  only `ov8865_sw_standby(false)`. After: still resume_and_get, then
  always `ov8865_sensor_init()` + `__v4l2_ctrl_handler_setup()` then
  standby off. Stream-start path.
- `ov8865_resume()` before: always `sensor_init` + ctrl setup, then
  standby off if streaming. After: those writes only if
  `state->streaming`. Runtime-resume path; skipped when VCM merely pins
  power.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[Logic / correctness]` Mode was applied only on RPM resume.
With an external RPM pin, `set_fmt()` never reached the sensor. Fix
writes the current software mode at stream start. Category is not
UAF/leak/race; it is a hardware/software format desync.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. Matches the usual sensor pattern (configure
at stream on). Extra I2C on every start is harmless (same work resume
used to do). Resume still covers mid-stream suspend. `int ret = 0` is
required because disable no longer assigned `ret` before the new `if
(!ret)` guard. Regression risk low; no API/lock change. Depends on
sibling 1/2 (`3fe797a12bfa9`) for unified `pm_runtime_put` on
`sensor_init` failure — that commit **is** in this tree.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Driver added in `11c0d8fdccc56` (“Add support for the OV8865 image
  sensor”, 2020-12-31, first in **v5.12-rc1**). Original `s_stream` only
  toggled standby after RPM get; resume always called `sensor_init`.
- Original `ov8865_state_configure()` **did** call
  `ov8865_mode_configure()` when the device was already runtime-active
  (`!pm_runtime_suspended`). That covered the VCM-pin case at
  `set_fmt()`.
- `da8f23e359166` (“move mode_configure out of state_configure”,
  2025-09-09, contained in **v6.18-rc1**) removed that powered-path
  `mode_configure`. That is the regression this commit repairs. Present
  in this 7.3 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The introducing commit is `da8f23e359166`. `git
merge-base --is-ancestor da8f23e359166 HEAD` succeeded.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `3fe797a12bfa9` — same author, same second, series 1/2: drop RPM count
  on stream failure. v2 changelog says 2/2 was rebased on that unified
  error path.
- `8e3e916e23f5a` (2023-08-10) — `ipu-bridge` VCM `DL_FLAG_PM_RUNTIME`
  link (the pin).
- No follow-up/revert of `4e1446ac169a1` on this file after it landed.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Jurison Murati has these two ov8865 commits in-tree. Not the
subsystem maintainer. Sakari Ailus merged both. Dan Scally (Intel
IPU3/libcamera) reviewed the series.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Soft prerequisite: `3fe797a12bfa9` (already in HEAD). Without
it, `sensor_init` failure after `resume_and_get` would leak the RPM ref.
No new helpers. Standalone on this tree.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 4e1446ac169a1`: https://patch.msgid.link/fa341298dfd2ba9ce4
  31e21c2cf45002efacf2cf.1781085860.git.eng.juri@gmail.com
- Series: v1 then v2 (2 patches).
  - v1 1/2: “Program the mode on stream start if needed” — extra
    `hw_mode`/`hw_mbus_code` state
  - v1 2/2: RPM put on stream-start failure
  - v2 1/2: RPM leak fix (reordered)
  - v2 2/2: this commit (unconditional program at start; resume gated on
    streaming)
- Applied version is v2, latest. No NAK. Sakari: do not add more driver
  state; Dan: program unconditionally at `s_stream` and gate resume —
  that is what landed. Author retested on Surface Book 2 with the sensor
  held runtime-active; both modes worked; mid-stream resume still
  reprogrammed.
- No `Cc: stable` in the thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w` recipients: Sakari Ailus, Daniel Scally, Hans de
Goede, Mauro Carvalho Chehab, linux-media. Right audience (sensor
maintainer, IPU3/VCM authors).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot. Concrete user-visible failure on Surface
Book 2 with exact cio2 log lines. Author is the reporter; not a
theoretical race.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 2/2 of a two-patch series. 1/2 is `3fe797a12bfa9`, already in
this tree. This hunk does not need other media patches.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: WebFetch of lore.kernel.org/stable returned 403. `b4` mbox has
no “stable” mention. UNVERIFIED whether stable@ discussed this later.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `ov8865_s_stream` (modified), `ov8865_resume` (modified).
Callees used: `ov8865_sensor_init`, `__v4l2_ctrl_handler_setup`,
`ov8865_sw_standby`. `ov8865_set_fmt` → `ov8865_state_configure` is the
path that only stores `state->mode`.

**Step 5.2: TRACE CALLERS**
Record: `ov8865_s_stream` is `.s_stream` on the V4L2 subdev. Called from
the media pipeline when userspace starts/stops capture (libcamera /
camera apps), not IRQ. `ov8865_resume` is `SET_RUNTIME_PM_OPS` runtime
resume.

**Step 5.3: TRACE CALLEES**
Record: `ov8865_sensor_init` does sw reset, standby, chip-id, init
sequence, then `ov8865_mode_configure(sensor->state.mode, …)` — so it
programs the **currently negotiated** mode. That is why calling it from
`s_stream` after `set_fmt()` is the right place.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace opens VCM (wireplumber) → `ipu_bridge`
`device_link_add(..., DL_FLAG_PM_RUNTIME)` keeps sensor RPM-active →
`VIDIOC_S_FMT`/`set_fmt` updates software mode only → `s_stream(1)` used
to only leave standby, leaving old registers → `ipu3-cio2` receives the
wrong frame size. Unprivileged user with camera access can trigger it;
wireplumber makes it the common case.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `ov5648_s_stream` still only does standby after RPM get and
always inits in resume — sibling still has the old pattern. Not a reason
to reject this ov8865 fix. `ipu-bridge.c:714` still has the VCM PM link.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: VERSION=7 PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4
- `drivers/media/i2c/ov8865.c`, `VIDEO_OV8865`, ipu3-cio2,
  `ipu_bridge_instantiate_vcm_work` + `DL_FLAG_PM_RUNTIME` all exist
- Regression `da8f23e359166` is an ancestor of HEAD
- Pre-fix `s_stream` (parent of `4e1446ac169a1`) only called
  `ov8865_sw_standby`; pre-fix `resume` always inited
- cio2 strings `"frame sync error"` and `"payload length is %lu,
  received %u"` match the report (`ipu3-cio2.c`)

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply on this tree. Prerequisite `3fe797a12bfa9` already
present. Difficulty: clean.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other fix for “wrong mode while RPM-pinned.” `git merge-base
--is-ancestor 4e1446ac169a1 HEAD` is true — used only to confirm file
state, not as “already selected for stable.”

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/media/i2c` OmniVision OV8865. **IMPORTANT** for IPU3
laptops that use this sensor (Surface Book 2 and similar); not core
mm/fs/net. Camera capture is a primary function of that hardware.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Driver is mature (v5.12). Recent changes are targeted fixes, not
a rewrite. Bug is a 2025 regression in a long-lived driver.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Users of ov8865 with a VCM RPM device link (IPU3 +
`ipu_bridge`), especially when wireplumber/PipeWire keeps the VCM open.
Driver-specific / platform-specific, but real shipping laptops.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Common on affected machines: camera monitor holds VCM, then a
capture app sets format and streams. Not a rare race. Unprivileged users
with camera access can hit it.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Not oops/UAF/deadlock. Camera stream is wrong or stuck: cio2
frame-sync/payload errors, one frozen bogus frame, or stall after one
frame. **HIGH** for those users (device unusable), **MEDIUM–HIGH**
overall.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit: restores working capture after a v6.18 regression.
Risk: low (~34-line, one driver, reviewed, retested). Ratio favors
including the fix.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real, reproduced bug on Surface Book 2 with exact cio2 logs present in
  this tree
- Regression from `da8f23e359166` (v6.18), which is in this tree; that
  commit removed the only powered-path `mode_configure` on `set_fmt`
- Trigger is ordinary (wireplumber + IPU3 VCM PM link, also in this
  tree)
- Small, obviously correct, no new API
- v2 matches maintainer (Sakari) and IPU3 reviewer (Dan Scally)
  feedback; retested
- Prerequisite RPM error-path fix is already here

AGAINST backporting:
- Not a kernel crash, UAF, or security hole
- Affects one sensor + IPU3/VCM, not all users
- No explicit `Cc: stable` (not a negative by itself)
- Merged 2/2 has no in-commit `Reviewed-by` (review happened on the
  list)

UNRESOLVED:
- lore.kernel.org WebFetch 403; thread recovered via `b4 dig -m`
- Whether stable@ later discussed this (no hit in the patch mbox)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — v2 as Dan/Sakari asked;
   author retested both modes and mid-stream resume on SB2
2. Fixes a real bug that affects users? **PASS** — camera unusable when
   VCM pins the sensor
3. Important issue? **PASS** — serious functional failure of the laptop
   camera (wrong CSI-2 format / stuck frame), not cosmetic
4. Small and contained? **PASS** — +25/−9, one file, two functions
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same functions;
   `3fe797a12bfa9` present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None of ID/quirk/DT/build/docs. It is a normal driver
correctness fix (plus the spirit of a hardware-path workaround for the
VCM PM link).

**Step 9.4: MAKE YOUR DECISION**
This tree has the ov8865 driver, the v6.18 `mode_configure` removal that
dropped the powered `set_fmt` path, and the IPU3 VCM RPM pin that makes
that path the default with wireplumber. The result is a format mismatch
that breaks capture. The fix is small, reviewed, and tested. It meets
stable rules for this checkout.

Verification:
- [Phase 1] Parsed tags: author + Sakari SOB only; no Fixes/Reported-
  by/syzbot/Cc:stable
- [Phase 2] Diff: `ov8865_s_stream` always inits+ctrl setup on enable;
  `ov8865_resume` inits only if `state->streaming`
- [Phase 3] Blame: `s_stream`/resume from `11c0d8fdccc56` (v5.12);
  powered `set_fmt` `mode_configure` removed by `da8f23e359166`
  (v6.18-rc1)
- [Phase 3] `git merge-base --is-ancestor da8f23e359166 HEAD` succeeded;
  `3fe797a12bfa9` also ancestor
- [Phase 3] `git show da8f23e359166`: removed `if
  (!pm_runtime_suspended) ov8865_mode_configure()` from
  `ov8865_state_configure`
- [Phase 4] `b4 dig -c 4e1446ac169a1`: v2 2/2 at
  patch.msgid.link/fa341298…; v1 added hw_mode state; Sakari objected;
  Dan proposed this design
- [Phase 4] Author reply: retested SB2 with sensor held runtime-active
- [Phase 4] `b4 dig -w`: Sakari, Dan Scally, Hans de Goede, Mauro,
  linux-media
- [Phase 4] lore/stable WebFetch: 403; mbox has no “stable”
- [Phase 5] `ov8865_set_fmt` → `ov8865_state_configure` only stores
  `state->mode`; `sensor_init` calls
  `ov8865_mode_configure(state->mode)`
- [Phase 5] `ipu-bridge.c:714` `device_link_add(...,
  DL_FLAG_PM_RUNTIME)`
- [Phase 6] Makefile/describe: 7.3.0-rc4; `VIDEO_OV8865` present
- [Phase 6] cio2: `"frame sync error"` and `"payload length is %lu,
  received %u"` in `ipu3-cio2.c`
- [Phase 8] Failure: wrong/stalled camera frames, not oops; HIGH for
  affected IPU3+ov8865 users
- UNVERIFIED: later stable@ discussion (lore 403)

The patch is a real, tested regression fix for this tree’s ov8865 + IPU3
VCM PM link path.

**YES**

 drivers/media/i2c/ov8865.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ov8865.c b/drivers/media/i2c/ov8865.c
index 5b909a8561287..c6d53c3d55caa 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2609,7 +2609,7 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct ov8865_sensor *sensor = ov8865_subdev_sensor(subdev);
 	struct ov8865_state *state = &sensor->state;
-	int ret;
+	int ret = 0;
 
 	if (enable) {
 		ret = pm_runtime_resume_and_get(sensor->dev);
@@ -2618,7 +2618,23 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
 	}
 
 	mutex_lock(&sensor->mutex);
-	ret = ov8865_sw_standby(sensor, !enable);
+
+	/*
+	 * The sensor may have been kept powered by something else (e.g. the
+	 * VCM's runtime PM device link on IPU3 platforms), in which case
+	 * runtime resume did not run and the hardware may still be
+	 * configured for a previous mode. Always program the negotiated
+	 * configuration on stream start.
+	 */
+	if (enable) {
+		ret = ov8865_sensor_init(sensor);
+		if (!ret)
+			ret = __v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
+	}
+
+	if (!ret)
+		ret = ov8865_sw_standby(sensor, !enable);
+
 	mutex_unlock(&sensor->mutex);
 
 	if (ret || !enable)
@@ -2914,15 +2930,15 @@ static int ov8865_resume(struct device *dev)
 	if (ret)
 		goto complete;
 
-	ret = ov8865_sensor_init(sensor);
-	if (ret)
-		goto error_power;
+	if (state->streaming) {
+		ret = ov8865_sensor_init(sensor);
+		if (ret)
+			goto error_power;
 
-	ret = __v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
-	if (ret)
-		goto error_power;
+		ret = __v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
+		if (ret)
+			goto error_power;
 
-	if (state->streaming) {
 		ret = ov8865_sw_standby(sensor, false);
 		if (ret)
 			goto error_power;
-- 
2.53.0

