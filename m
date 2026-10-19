Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06CC5B9219;
	Mon, 19 Oct 2026 14:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418453; cv=none; b=kC8uzZ6U4PbaiffPlq42wxDly1fNCHGr2qV+EXuwTqXP+XaBtPxadmOnEMLU2INVXxlPo6kvx3rD+B6zaTiismP4MeWyjhT60cjpE26d7fOZewZn+9AFeT83RTbByOvVuaZxd6TFhK0PrZDaq+iiED+F8I9Xz/uN5B+Zfasla+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418453; c=relaxed/simple;
	bh=OOaK2xDcPKnLHz+w9XRDz6Fv9RbM/JNuJJ8P2ww92z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V/+GnvaMUnpZVqbSYhS/0LHb1HiahCWMHl3JH0+Rodsk2uXCAOpW0gMY0Y8nKFb9Qr5l3iTrHz/sJnOZ66NOb4VKs87lnW38XskR6SkpFnZWSg1Zvelm+MYVPoW5Bng0MNJyftR8QLS4qKFX818OLAfmPwTNzTysUiii2OPyyHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKJqrFKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKJqrFKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8941F000C4;
	Mon, 19 Oct 2026 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418449;
	bh=6TS/Q3pKeENFeHIQnE0m6TxBiMaSVd3lpAbnvj2BRtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKJqrFKxJ07QdubIgwCCW/GWE5/G9E2Ezrjiiv/5/MuSh3p0cLsfVD985mLI7aoqh
	 6Btlj4abgNMnk7dVFFitQXzwRkPW4dgLgjGMdJqrwLM6Irrw7EDLFQyIYu13m/7I9g
	 qeyt27RZTLGobXaGY8eMWK72XlRsrOzv7s5qJu08AlM912ss9/vC2nfFyUmSnm3W9N
	 ACgRk/49q2w0t9nxbOV6lyUENxpziyRGsV44C1+0p82tmQz7cIA6Xe6iml2lXjgNmD
	 TW0aUIInkozPxYMLMALCR3IMiUVPWaUPNctmF2yoCqX4hqB4Vgg7sxtMLImLpdCiuI
	 iAs22YEZZMSaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= <nfraprado@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda: Force resume if acomp notified during system suspend
Date: Mon, 19 Oct 2026 09:49:08 -0400
Message-ID: <20261019135441.1420968-257-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit c0933934d5d96fc641e8d0025f9099e554a7b47a ]

Currently if an HDMI cable is connected while the system is suspended,
the HDMI audio jack status stays off after resume.

This is due to the jack state not being synced by the HDA HDMI codec
device's runtime resume, as that never happens if the device was runtime
suspended before the system suspended, or by the acomp notification
triggered from the DRM side if that happens before the HDA HDMI codec
device has resumed.

To fix this, if snd_hda_hdmi_acomp_pin_eld_notify() gets called before
the HDA HDMI codec device has resumed, mark it to be forcefully runtime
resumed at the next PM complete time.

Do this using a separate acomp_requested_resume flag that can be
temporarily set without overwriting forced_resume for drivers that
always want to force resume.

Assisted-by: Copilot:claude-sonnet-4.6
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://patch.msgid.link/20260626-hda-force-resume-eld-notify-v1-1-a92cb01393e0@collabora.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.y** (`v6.18.53`). The candidate is a small HDMI
jack-sync fix for AMD/Nvidia HDA; the buggy skip-during-suspend path is
present at `v6.18.53` and the patch applies there cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ALSA: hda]` `[Force]` Force a runtime resume if the DRM audio
component (acomp) notifies HDMI pin/ELD state during system suspend.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Assisted-by: Copilot:claude-sonnet-4.6` (authoring aid; not a quality
  verdict)
- `Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>`
  (author)
- `Link: https://patch.msgid.link/20260626-hda-force-resume-eld-
  notify-v1-1-a92cb01393e0@collabora.com`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer applied
  it)
- Pipeline-added tags ignored: `[Upstream commit ...]`, `Signed-off-by:
  Sasha Levin`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence expected)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Plug an HDMI cable while the system is suspended; after
  resume the HDMI audio jack stays off.
- **Symptom:** Userspace sees HDMI audio disconnected until a later
  unplug/replug or some other codec resume.
- **Root cause:** Two missed sync paths: (1) HDA HDMI runtime resume
  never runs if the codec was already runtime-suspended before system
  suspend (direct-complete); (2) DRM `pin_eld_notify` during that window
  is dropped because `power_state.event == PM_EVENT_SUSPEND`.
- **Fix:** Remember the notify and force `pm_request_resume()` in
  `hda_codec_pm_complete()`. Use a dedicated flag so `forced_resume` is
  not overwritten for codecs that keep it set (Intel KAE / Realtek).
- **Version info:** None in the message. Author date is 2026-06-26
  (after 6.18).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. It is an explicit functional fix for stale HDMI jack
state after suspend.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `include/sound/hda_codec.h`: +1 (`acomp_requested_resume` bitfield)
- `sound/hda/codecs/hdmi/hdmi.c`: +3/-1 in
  `snd_hda_hdmi_acomp_pin_eld_notify()`
- `sound/hda/common/codec.c`: +4/-1 in `hda_codec_pm_complete()`
- Scope: 8 insertions, 2 deletions; single-purpose surgical change
  across HDMI notifier + codec PM

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **hdmi.c:** Previously, acomp notify during system suspend returned
  immediately (comment: “state will be updated at resume”). After: same
  early return, but sets `codec->acomp_requested_resume = 1`.
- **codec.c `hda_codec_pm_complete()`:** Previously requested runtime
  resume only for jackpoll, `hda_codec_need_resume()`, or
  `forced_resume`. After: also if `acomp_requested_resume`, then clear
  the flag.
- Path: system-sleep complete of an already runtime-suspended HDMI
  codec, after DRM notified during HDA’s `PM_EVENT_SUSPEND` window.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / correctness (missed jack sync after suspend/resume).**
- HDMI acomp codecs set `relaxed_resume` when the DRM notifier is bound
  (`generic_acomp_notifier_set()`), so `hda_codec_need_resume()` is
  false.
- Direct-complete (`hda_codec_pm_prepare`/`complete`, Kai-Heng Feng
  2020) keeps a runtime-suspended codec suspended through S3.
- Notify is dropped; resume never runs `snd_hda_hdmi_generic_resume()` →
  `hdmi_present_sense()` / `sync_eld_via_acomp()`.
- Jack kcontrol stays off.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. Runtime resume already jacks-
syncs all pins (`hda_call_codec_resume()` → `ops->resume` →
`hdmi_present_sense` per pin, plus `snd_hda_jack_report_sync()`), so a
boolean “something changed” is enough. Separate flag avoids clobbering
`forced_resume`. Regression risk is low: extra `pm_request_resume()`
only when DRM notified during the suspend window; at worst a short extra
wake before runtime suspend. Does not change userspace APIs. Intel’s
`intel_pin_eld_notify()` still skips without this flag (same class of
bug, different notifier); that gap does not make this AMD/Nvidia-path
fix incorrect.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Skip-during-suspend introduced in `ade49db337a9d` (“ALSA: hda/hdmi -
  Allow audio component for AMD/ATI and Nvidia HDMI”, Takashi Iwai,
  2018; contained in v5.4-rc1).
- `hda_codec_pm_complete()` forced-resume conditions from
  `215a22ed31a13` (direct-complete, 2020) and `forced_resume` from
  `a6e7d0a4bdb02` (2020).
- Buggy combination (drop notify + stay runtime-suspended because of
  `relaxed_resume`) has been in the tree for years, including 6.18.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. Introducer of the skip is
`ade49db337a9d`; it is in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent HDMI/codec PM work is unrelated (Lisuan IDs, `__force`
cleanup, power-pm error check). No series (`v1-1` standalone). No
follow-up on these three files that extends this flag.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Only this HDA commit from Nícolas Prado in this tree. ALSA
maintainer Takashi Iwai applied it. Author is a regular kernel
contributor (Collabora), not the HDA maintainer; maintainer SOB is the
stronger signal.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing `forced_resume` / `hda_codec_pm_complete()` /
`snd_hda_hdmi_acomp_pin_eld_notify()`. All present at `v6.18.53`.
Standalone. File layout `sound/hda/codecs/hdmi/hdmi.c` exists in 6.18
(`6014e9021b28e` reorg is already in this tree).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c c0933934d5d96…` → https://patch.msgid.link/20260626-hda-
  force-resume-eld-notify-v1-1-a92cb01393e0@collabora.com
- `b4 dig -a`: **v1 only**, no later revisions.
- Thread (mbox): submission + Takashi Iwai “Applied to for-next branch
  now. Thanks.” No NAKs, no requested changes, no reviewer `Cc: stable`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Jaroslav Kysela, Takashi Iwai; Cc `linux-
sound`, `linux-kernel`, Collabora. Maintainer applied v1 as-is.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. Description is a concrete
user-visible HDMI jack failure. Severity from the author: HDMI audio
jack stays off after a plug-during-S3. User count unverified beyond the
author.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Intel `intel_pin_eld_notify()` still has the old
skip; no sibling Intel patch in this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403; web search did not
find a stable-list thread for this subject. UNVERIFIED whether anyone
already nominated or rejected it for stable. That absence is not used as
a NO.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `snd_hda_hdmi_acomp_pin_eld_notify()`,
`hda_codec_pm_complete()`. Struct field
`hda_codec.acomp_requested_resume`.

**Step 5.2: TRACE CALLERS**
Record:
- `snd_hda_hdmi_acomp_pin_eld_notify` is the `.pin_eld_notify` op for
  AMD (`atihdmi.c`) and Nvidia (`nvhdmi.c`). DRM calls it via
  `amdgpu_dm_audio_eld_notify()`, `radeon_audio`, `nouveau dispnv50`.
  Typical context: display modeset / connector ELD change (hotplug or
  resume modeset), not a syscall on the ALSA side.
- `hda_codec_pm_complete` is `.complete` in `hda_codec_driver_pm`
  (system sleep complete for every HDA codec).
- Intel uses a separate `intel_pin_eld_notify()` and is **not** covered.

**Step 5.3: TRACE CALLEES**
Record: Notify still returns during suspend (no verbs). Complete path
calls existing `pm_request_resume()`. Runtime resume →
`hda_call_codec_resume()` → HDMI `snd_hda_hdmi_generic_resume()` →
`hdmi_present_sense()` (`sync_eld_via_acomp` when acomp is bound).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable without privilege: physical HDMI/DP plug while the
machine is suspended, then resume. Common laptop/dock path. Not a
fuzzer/syscall crash path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same skip remains in `sound/hda/codecs/hdmi/intelhdmi.c`
`intel_pin_eld_notify()`. Same `forced_resume` pattern already used for
jack/KAE. This patch copies that idea for acomp.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `git describe HEAD` / `make kernelversion` →
**6.18.53**. At `v6.18.53`:
- `snd_hda_hdmi_acomp_pin_eld_notify()` still returns on
  `PM_EVENT_SUSPEND` with no flag.
- `hda_codec_pm_complete()` has no `acomp_requested_resume`.
- `hda_codec` has `forced_resume` but not the new bit.
Bug introduced ~2018/2020; present in 6.18. Upstream SHA `c0933934d5d96`
is **not** an ancestor of `v6.18.53`.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** `git diff v6.18.53 6a484c2d8404d` on the three
files is exactly this patch. Context lines match.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other 6.18 fix for “acomp notify during suspend” / this jack-
stays-off sequence. Intel skip is still unfixed; not a substitute.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: ALSA HD-audio HDMI (AMD/Nvidia acomp). **IMPORTANT** (common
dGPU/APU HDMI audio), not core mm/vfs. Affects AMD/Nvidia HDMI jack
kcontrols/PCM availability after S3.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (quirks, HDMI, PM). The skip itself has been stable since
2018; this is a late correctness fix, not churn for new infrastructure.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific: AMD ATI HDMI (`atihdmi`) and Nvidia HDMI
(`nvhdmi`) with DRM audio-component binding. Intel HDMI notifier is
unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: HDMI/DP cable (or dock) attached while the system is in S3, then
resume, **and** the HDMI codec was runtime-suspended before suspend
(normal with `relaxed_resume`). Unprivileged physical hotplug; not a
syscall exploit. Timing: DRM notify before HDA `complete()`.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: HDMI audio jack stays reported off; HDMI PCM/jack userspace does
not see the display. No oops, deadlock, or filesystem corruption.
**MEDIUM** functional suspend/resume bug (audio device missing until
another resume/replug).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for AMD/Nvidia HDMI users who dock/plug during
  suspend (common). Jack state is restored via the existing resume path.
- **Risk:** Very low (8 lines, existing PM helper, 1-bit flag still
  inside the same `unsigned int` bitfield group of 26 bits). Possible
  extra runtime resume if DRM notifies on every GPU resume while HDA is
  still `PM_EVENT_SUSPEND`; that is transient power, not a functional
  break.
- **Ratio:** Benefit outweighs risk for 6.18.y.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real user-visible bug: HDMI audio jack stays off after plug-during-
  suspend.
- Mechanism verified in 6.18 code: skip notify + `relaxed_resume` +
  direct-complete.
- Tiny, obviously correct, maintainer-applied v1 with no NAKs.
- Applies cleanly to this tree; all helpers exist.
- Existing resume path already resyncs ELD/jacks; this only ensures that
  path runs.
- Same class of PM/jack workaround already used (`forced_resume`).

AGAINST:
- Not a crash, UAF, or security issue.
- No independent `Reported-by` / `Tested-by`.
- Intel HDMI notifier still has the skip (incomplete coverage, not a
  regression of this patch).
- Possible extra runtime resume after S3 if DRM notifies during the HDA
  suspend window.

UNRESOLVED:
- Could not fetch lore.kernel.org/stable (403); no verified stable-list
  discussion.
- Could not quantify how often AMD/Nvidia DRM notifies during HDA’s
  suspend window on every resume vs only on true hotplug.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — logic matches the resume
   path; maintainer applied v1. No extra Tested-by, but the change is
   reviewable from the code.
2. Fixes a real bug that affects users? **PASS** — stale HDMI jack after
   a common plug-during-S3.
3. Important issue? **PASS** — not panic/corruption, but a
   suspend/resume hardware-functional bug that leaves HDMI audio
   unavailable; this class is routinely taken in stable.
4. Small and contained? **PASS** — 8 insertions / 2 deletions, three
   files, one flag.
5. No new features or APIs? **PASS** — internal bitfield; no UAPI.
6. Can apply to the local tree? **PASS** — identical context at
   `v6.18.53`.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
small functional PM/jack fix.

**Step 9.4: MAKE YOUR DECISION**
This should be backported to this 6.18.y tree. The buggy skip and
complete-path exist here, the fix is surgical, and the user impact (HDMI
audio missing after docking/plugging in suspend) is real.

### What the commit solves and why it matters here
On 6.18, AMD/Nvidia HDMI codecs using acomp set `relaxed_resume` and can
stay runtime-suspended across system sleep. DRM may notify pin/ELD while
the codec is still `PM_EVENT_SUSPEND`; that notify is dropped, and
`hda_codec_pm_complete()` does not wake the codec. HDMI jack kcontrols
stay off after resume. Forcing a one-shot runtime resume when such a
notify arrived restores the existing ELD/jack sync in
`hda_call_codec_resume()`.

### Stable rules / risk vs benefit
Meets the stable bar: real bug, small, no new API, clean apply, low
regression risk. Benefit is restoring HDMI audio after a common suspend
hotplug; risk is an extra runtime resume in that window.

### Concerns
Intel HDMI still skips notify during suspend (separate function). No
`Fixes:`/`Cc: stable` (expected). No third-party test tag. Neither is a
reason to withhold this AMD/Nvidia-path fix from 6.18.y.

Verification:
- [Phase 1] Parsed tags: author SOB, Takashi Iwai SOB, msgid Link; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] Body: HDMI jack stays off after plug-during-suspend; skipped
  acomp notify + no runtime resume
- [Phase 2] Diff: +1 bitfield, set flag in
  `snd_hda_hdmi_acomp_pin_eld_notify`, test/clear in
  `hda_codec_pm_complete` (8+/2-)
- [Phase 2] `hda_codec_need_resume()` is `!relaxed_resume &&
  jacktbl.used`; acomp sets `relaxed_resume`
- [Phase 3] blame: skip from `ade49db337a9d` (v5.4-rc1); complete path
  from `215a22ed31a13` (2020)
- [Phase 3] `git merge-base --is-ancestor c0933934d5d96 HEAD` → not in
  v6.18.53; buggy code is
- [Phase 3] No series/prereqs; files exist at 6.18 paths
- [Phase 4] `b4 dig -c`: lore msgid; `b4 dig -a`: v1 only; mbox: Takashi
  “Applied to for-next”; no NAK
- [Phase 4] `b4 dig -w`: To Iwai/Kysela, Cc linux-sound
- [Phase 4] UNVERIFIED: stable@ discussion (lore 403)
- [Phase 5] Callers: atihdmi/nvhdmi ops; DRM amdgpu/radeon/nouveau
  pin_eld_notify; Intel uses different function
- [Phase 5] Resume callee chain verified: `hda_codec_runtime_resume` →
  `hda_call_codec_resume` → HDMI generic_resume → `hdmi_present_sense`
- [Phase 6] `git describe HEAD` / Makefile: 6.18.53; `git show
  v6.18.53:...` has pre-fix code; diff vs candidate is this patch only
- [Phase 7] ALSA HDA HDMI, important, AMD/Nvidia
- [Phase 8] Trigger: HDMI plug in S3 then resume; failure: jack stays
  off; severity MEDIUM; risk very low
- UNVERIFIED: how often DRM notifies on every GPU resume vs only
  hotplug; Intel still buggy (out of scope of this commit)

**YES**

 include/sound/hda_codec.h    | 1 +
 sound/hda/codecs/hdmi/hdmi.c | 4 +++-
 sound/hda/common/codec.c     | 5 ++++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 3c9e64dc02524..b801943f0667f 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -257,6 +257,7 @@ struct hda_codec {
 	unsigned int link_down_at_suspend:1; /* link down at runtime suspend */
 	unsigned int relaxed_resume:1;	/* don't resume forcibly for jack */
 	unsigned int forced_resume:1; /* forced resume for jack */
+	unsigned int acomp_requested_resume:1; /* resume requested by acomp */
 	unsigned int no_stream_clean_at_suspend:1; /* do not clean streams at suspend */
 	unsigned int ctl_dev_id:1; /* old control element id build behaviour */
 	unsigned int eld_jack_detect:1;	/* Machine jack-detection by ELD */
diff --git a/sound/hda/codecs/hdmi/hdmi.c b/sound/hda/codecs/hdmi/hdmi.c
index f427d04176e92..42e4dc0949ec9 100644
--- a/sound/hda/codecs/hdmi/hdmi.c
+++ b/sound/hda/codecs/hdmi/hdmi.c
@@ -2236,8 +2236,10 @@ void snd_hda_hdmi_acomp_pin_eld_notify(void *audio_ptr, int port, int dev_id)
 	/* skip notification during system suspend (but not in runtime PM);
 	 * the state will be updated at resume
 	 */
-	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND)
+	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND) {
+		codec->acomp_requested_resume = 1;
 		return;
+	}
 
 	snd_hda_hdmi_check_presence_and_report(codec, pin_nid, dev_id);
 }
diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index 164906e2f00f4..8cab932177194 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -2949,8 +2949,11 @@ static void hda_codec_pm_complete(struct device *dev)
 		dev->power.power_state = PMSG_RESUME;
 
 	if (pm_runtime_suspended(dev) && (codec->jackpoll_interval ||
-	    hda_codec_need_resume(codec) || codec->forced_resume))
+	    hda_codec_need_resume(codec) || codec->forced_resume ||
+	    codec->acomp_requested_resume)) {
+		codec->acomp_requested_resume = 0;
 		pm_request_resume(dev);
+	}
 }
 
 static int hda_codec_pm_suspend(struct device *dev)
-- 
2.53.0

