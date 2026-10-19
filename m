Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D50F642348;
	Mon, 19 Oct 2026 14:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418807; cv=none; b=IKOHPmZrnX3GXLaRo0n1KTbBuef68CAMo7j0MjeFIQ+12X7Y4UKZI9mMiTPl80iUlqkuOVSBup7gb8aPlCX4VE6pctdwqusYHPC7TaX209vUGpGdF9kyQLaECn8jDq5PUdLvIS8y+Ya5x9tPBfsq+oZRrb5lN5R6AWSW4iQ8RHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418807; c=relaxed/simple;
	bh=BrfpQuNnY8UhcSW7NLvGo0+YcomfJeCp2i9f0EMq5s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CF/p3ELL1bmf7mVgELgg2gBdHDiesv91PcIg6GmsZN25ZOIxiALaLJk8Dp1px5PEjNOnUczRb25Rfa9SxhbmCDXNv//QRle8UIUExiZa1XLROfACnJGGqEc5j8r9Au5cI90uJqSVga2be6veJmznGbo0UI/R9OxObIWJkQu96IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UK59zbfY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UK59zbfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8972D1F000C8;
	Mon, 19 Oct 2026 14:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418804;
	bh=G9zW7P2x/XazPvN4qmPk6DMgvTujEYME/q4y9iJUZ08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UK59zbfYTVqXtTmzBkZh22xmWtqXk/4n83TQND2aWF4NJwR0uqDwkHo3SFho3A7kP
	 WvP4A4XG1FiFlPCOgLLdXPoBlMSpGCAymMTKrQdcknE6G3qngnVCHFLsieea5BEBtD
	 ip3SHHamFMTXR2kydbrCVoRH+LByuY9qwrBVQMTyRyj5ELuvJGjyTeBBrikPYRFJp8
	 QKTywL47rFJ4SF/utdgPDKLEfUngF6ffV2LNXoYhZdstfbQsvN0ytuTbDP9cE5aeU8
	 msUcbgAXtzf5PfDq0UWo3t39sf6Aj6R8XwPscQf4qFjvpUnmou+85Jc9uzrsMnZ9Tm
	 vXJxKdFhfkUIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jurison Murati <eng.juri@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] media: i2c: ov8865: Drop the runtime PM usage count on stream failure
Date: Mon, 19 Oct 2026 09:53:19 -0400
Message-ID: <20261019135441.1420968-508-sashal@kernel.org>
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

[ Upstream commit 3fe797a12bfa9a49aa998ee722e5f25c957b9b15 ]

ov8865_s_stream() takes a runtime PM reference when enabling the
stream, but returns without releasing it if ov8865_sw_standby()
fails, leaving the reference unbalanced and the sensor powered
indefinitely. The same applies to a failure while disabling the
stream, in which case the reference acquired at stream start is
never dropped.

Drop the reference in a single place, both when disabling the
stream and on failure, and only update the streaming state on
success.

Signed-off-by: Jurison Murati <eng.juri@gmail.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
driver and the unbalanced RPM `s_stream` path exist here; this is a
real, small resource-leak fix that belongs in this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[media/i2c/ov8865] [Drop] Drop the runtime PM usage count on
stream failure.** “Drop” here is a leak fix: release a held RPM
reference, not a feature removal.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Signed-off-by:** Jurison Murati `<eng.juri@gmail.com>` (author)
- **Reviewed-by:** Daniel Scally `<dan.scally@ideasonboard.com>`
- **Signed-off-by:** Sakari Ailus `<sakari.ailus@linux.intel.com>`
  (media I2C maintainer; applied the patch)
- **No Fixes:** (expected for this review)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Link / Acked-by**
- Ignore any pipeline-added Sasha Levin SOB / `[Upstream commit]`
  markers (none in the real commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `ov8865_s_stream()` calls `pm_runtime_resume_and_get()` on
  stream-on, then returns early if `ov8865_sw_standby()` fails, without
  `pm_runtime_put()`.
- **Symptom:** RPM usage count stays elevated; the sensor stays powered
  indefinitely. Same leak on failed stream-off (the get from stream-on
  is never dropped).
- **Root cause:** error returns skip the put that is only done on
  successful stream-off.
- **Fix:** put on `ret || !enable`; only set `state->streaming` on
  success; return the real `ret`.
- **Version info in the message:** none.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** It is an explicit RPM reference-count leak fix
(error-path resource leak).

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/media/i2c/ov8865.c` — **+5 / −7** (12 lines
  touched)
- **Function:** `ov8865_s_stream()` only
- **Scope:** single-file, surgical

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before (parent of `3fe797a12bfa9`):

```c
if (enable) {
    ret = pm_runtime_resume_and_get(sensor->dev);
    if (ret < 0)
        return ret;
}
mutex_lock(&sensor->mutex);
ret = ov8865_sw_standby(sensor, !enable);
mutex_unlock(&sensor->mutex);
if (ret)
    return ret;                 /* leak: no put */
state->streaming = !!enable;
if (!enable)
    pm_runtime_put(sensor->dev);
return 0;
```

After:

```c
if (ret || !enable)
    pm_runtime_put(sensor->dev);
if (!ret)
    state->streaming = enable;
return ret;
```

Record:
- Stream-on success: no put, `streaming = 1` (unchanged).
- Stream-on failure: **put** (was leaked).
- Stream-off success: put, `streaming = 0` (unchanged).
- Stream-off failure: **put** (was leaked); `streaming` left unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Error path / resource leak — runtime PM usage count]**
`pm_runtime_resume_and_get()` increments the usage count.
`ov8865_sw_standby()` is a single I2C write and can fail. Early `return
ret` skipped the matching `pm_runtime_put()`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct and minimal.** Same pattern suggested by
Sakari Ailus on v1 and used by sibling OmniVision drivers (e.g.
`ov8856_set_stream()`).
**Regression risk: very low.**

Verified against `call_s_stream()` in this tree:

```475:503:drivers/media/v4l2-core/v4l2-subdev.c
static int call_s_stream(struct v4l2_subdev *sd, int enable)
{
        ...
        if (WARN_ON(sd->s_stream_enabled == !!enable))
                return 0;
        ret = sd->ops->video->s_stream(sd, enable);
        if (!enable && ret < 0) {
                dev_warn(sd->dev, "disabling streaming failed (%d)\n",
ret);
                ret = 0;
        }
        if (!ret)
                sd->s_stream_enabled = enable;
        ...
}
```

Disable is never retried by the core (failure is treated as success,
`s_stream_enabled` becomes 0). Enable failure keeps `s_stream_enabled ==
0`, so a retry does a fresh get. No double-put on the core path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Buggy `if (ret) return ret;` / put-only-on-success:
  **`11c0d8fdccc56`** — “media: i2c: Add support for the OV8865 image
  sensor” (2020-12-31), first in **v5.12-rc1**.
- `pm_runtime_resume_and_get()` rename: **`586ee057ba6b01`**
  (2021-04-23). The leak was already present with the original get.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Bug dates to driver introduction, not a later
regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- This is **patch 1/2**. Follow-up **`4e1446ac169a1`** (“Program the
  sensor on stream start”) depends on this unified error handling (v2
  changelog).
- This commit is **standalone**; it does not need patch 2.
- Both are already in this 7.3-rc4 checkout via `media/v7.3-1`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Author Jurison Murati has exactly these two ov8865 commits in
`drivers/media/i2c/`. Not the subsystem maintainer. Weight comes from
**Daniel Scally’s Reviewed-by** and **Sakari Ailus applying it**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None.** Touches only `ov8865_s_stream()`, `pm_runtime_put()`,
and `state->streaming`, all present since the driver was added.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore (via `b4 dig -c 3fe797a12bfa9`):
  https://patch.msgid.link/6b764b77a7d78b8ae2cfb8a213a1e844a329db26.1781
  085860.git.eng.juri@gmail.com
- **v1:** `[PATCH 2/2] Drop PM runtime reference if stream start fails`
  — put only on enable failure.
- **v2:** unified `if (ret || !enable)` as Sakari asked; also covers
  disable failure; reordered to 1/2.
- **No NAKs.** Dan Scally: “I think this is ok” + Reviewed-by on v2.
- **No Cc: stable** in the thread (`grep stable` on the saved mbox: no
  matches).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Jurison Murati; **Sakari Ailus**; **Daniel
Scally**; Hans de Goede; Mauro Carvalho Chehab; **linux-
media@vger.kernel.org**. Right maintainers/lists.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No user/syzbot report** of this leak. Found by inspection
while fixing IPU3/Surface Book 2 stream-on programming (sibling patch).
Still a real, reachable leak.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 2-patch series. This patch is self-contained. Patch 2 is a
separate functional fix (program mode on stream start).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — `lore.kernel.org/stable/` fetch returned 403.
The linux-media mbox has no stable discussion.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: **`ov8865_s_stream()`** only.

**Step 5.2: TRACE CALLERS**
Record: Registered as `.s_stream` in `ov8865_subdev_video_ops`. Invoked
from **`call_s_stream()`** / `v4l2_subdev_call(..., s_stream, ...)` when
userspace starts/stops the camera pipeline (VIDIOC_STREAMON/OFF).
**Userspace-reachable.** Not IRQ context.

**Step 5.3: TRACE CALLEES**
Record: `pm_runtime_resume_and_get()`, `ov8865_sw_standby()` →
`ov8865_write()` (I2C), `pm_runtime_put()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Camera app → V4L2 STREAMON → subdev `.s_stream(1)` → get + I2C
standby-off. Fail that I2C write → leak on old code. **Yes, reachable
from userspace** on hardware that uses this sensor
(`CONFIG_VIDEO_OV8865`).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same class of fix exists elsewhere (`media: smiapp: Fix runtime
PM imbalance on error`, `media: s5k6a3: Fix runtime PM imbalance on
error`). `ov8856_set_stream()` already puts on start failure.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Driver is `drivers/media/i2c/ov8865.c`. Buggy
`s_stream` was in this lineage from **v5.12** until **`3fe797a12bfa9`**.
This 7.3-rc4 tree already contains that commit (plus follow-up
`4e1446ac169a1`, which kept `if (ret || !enable) pm_runtime_put()`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Against the pre-fix blob, the provided diff matches **exactly**.
**Clean apply** to the buggy function. No structural prerequisites.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This *is* the RPM-leak fix in this tree. No earlier alternate
fix. Follow-up `4e1446ac169a1` is a different bug (stale mode when RPM
is pinned).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **[media / i2c camera sensor] [PERIPHERAL]** — OmniVision OV8865
(`CONFIG_VIDEO_OV8865`, depends on `PM`). Real products: sibling commit
documents Surface Book 2 (IPU3 + ov8865).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver (since v5.12), occasional fixes. Not a new/staging
driver.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific** (`CONFIG_VIDEO_OV8865`).
Laptop/embedded camera users (e.g. IPU3/Surface).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Stream on/off when `ov8865_sw_standby()` I2C write fails. Not
every boot; **error path**. Unprivileged camera users can hit STREAMON.
Repeated failed starts **stack** usage counts on the old code.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **[RPM usage leak → sensor never runtime-suspends, extra power]
[HIGH for that device, not a kernel oops].** Not panic/UAF/corruption.
Persistent until reboot.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium-high for ov8865 users (device otherwise stays
  powered after a failed stream).
- **Risk:** very low (5/7 lines, error/stream-off path only, reviewed).
- **Ratio:** strongly favors applying it.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real unbalanced `pm_runtime_resume_and_get()` / missing
  `pm_runtime_put()` on I2C failure.
- Sensor can remain runtime-active indefinitely; retries worsen the
  count.
- Tiny, obviously correct; maintainer-suggested form; Reviewed-by Daniel
  Scally; applied by Sakari Ailus.
- Bug present since v5.12; code exists in this tree.
- Standalone; no new API/feature.
- Same class as other media “runtime PM imbalance” fixes.

**AGAINST:**
- Peripheral sensor, not core mm/net/fs.
- Error path (I2C failure), no syzbot/user report of *this* leak.
- No crash/UAF/CVE.

**UNRESOLVED:**
- Could not query lore.kernel.org/stable (HTTP 403).
- WebFetch of lore HTML also 403; discussion recovered via `b4 dig -m`.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — reviewed, maintainer-
   applied, logic matches V4L2 `s_stream` pairing.
2. Fixes a real bug that affects users? **PASS** — RPM leak on stream
   start/stop failure.
3. Important issue? **PASS** — persistent device power / RPM imbalance
   (HIGH for this driver, not a panic).
4. Small and contained? **PASS** — one function, +5/−7.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy `ov8865_s_stream()` is
   this driver’s historical code; diff matches that blob.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **None** (not a device ID/quirk/DT/build/doc exception). It is a
normal bugfix.

**Step 9.4: MAKE YOUR DECISION**
This is a surgical RPM reference leak fix in a driver this tree actually
ships. Benefit outweighs risk.

---

What it solves for this tree: if `ov8865_sw_standby()` fails after
`pm_runtime_resume_and_get()`, the usage count was never dropped, so the
OV8865 stayed powered. The patch puts in one place on failure and on
stream-off, and only updates `state->streaming` on success.

It meets stable rules: real leak, small, no new API, applies to this
`ov8865.c`. Risk is negligible versus leaving the sensor runtime-pinned
after a failed stream.

### Verification
- [Phase 1] Tags: author SOB Jurison Murati; Reviewed-by Daniel Scally;
  SOB Sakari Ailus; no Fixes/Cc:stable/Reported-by
- [Phase 2] Diff: `ov8865_s_stream()` only, +5/−7; put on `ret ||
  !enable`
- [Phase 2] `call_s_stream()` swallows disable errors and will not
  double-call disable (verified in `v4l2-subdev.c`)
- [Phase 3] `git blame` on parent: leak from `11c0d8fdccc56` (v5.12-rc1)
- [Phase 3] `git merge-base --is-ancestor 3fe797a12bfa9 HEAD` → in this
  tree
- [Phase 3] Follow-up `4e1446ac169a1` is a separate series patch; this
  commit is standalone
- [Phase 4] `b4 dig -c 3fe797a12bfa9` → v2 1/2 lore URL; `b4 dig -a` →
  v1 then v2; `b4 dig -w` → Sakari, Scally, Chehab, linux-media
- [Phase 4] mbox: Sakari proposed the unified put; Scally re-reviewed;
  no NAK; no “stable” string
- [Phase 4] lore.kernel.org HTML/stable search: 403 — UNVERIFIED on
  stable@ thread
- [Phase 5] Callers: V4L2 subdev `.s_stream` from STREAMON/OFF;
  `ov8865_sw_standby()` is an I2C write that can fail
- [Phase 6] `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` → 7.3.0-rc4; pre-fix function matches the candidate
  diff
- [Phase 8] Failure mode: RPM usage leak, sensor stays powered; severity
  HIGH for this device, not oops
- UNVERIFIED: whether this was already discussed on stable@ (fetch
  blocked)

**YES**

 drivers/media/i2c/ov8865.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov8865.c b/drivers/media/i2c/ov8865.c
index a8586df14f777..5b909a8561287 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2621,15 +2621,13 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
 	ret = ov8865_sw_standby(sensor, !enable);
 	mutex_unlock(&sensor->mutex);
 
-	if (ret)
-		return ret;
-
-	state->streaming = !!enable;
-
-	if (!enable)
+	if (ret || !enable)
 		pm_runtime_put(sensor->dev);
 
-	return 0;
+	if (!ret)
+		state->streaming = enable;
+
+	return ret;
 }
 
 static const struct v4l2_subdev_video_ops ov8865_subdev_video_ops = {
-- 
2.53.0

