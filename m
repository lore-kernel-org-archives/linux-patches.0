Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2067B597F21;
	Mon, 19 Oct 2026 13:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418351; cv=none; b=oq5cCE8tA1cxuilTkvNH5rJ1XqmBVg0AS16IF42uwNzHe9ogkV4WqsYMjVBv3JDBkpMQEmF1eWQ5fEqqpGO7hK7EX5Gki6MNLUAIcFwliqWpJCzHmUepNdBwVeY9g9wvsEZAsQsH7rL/VC/AMj7pby3v8wksrGr7sGiwSdcuOZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418351; c=relaxed/simple;
	bh=dIRalYqqjAq1j+AQGFZs/wygp9TJUFsW9MlrB0rT31E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NQJgHtr/q2yHrbq8YV3QnkFqmLpJ3G3YJgbae81zjpz4KrWUsIo9QB5AgReoVkUnhUl+7zVDHN6VHFbaI+2QbLqAI61vxzbj4jzuhJy9q+mwDvjVFE6fA41D5i7mf/XJKdHIRXIaAIgYSu+aClvnly+NEzJMUkMR0+FXd1JVdw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A24rKESz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A24rKESz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BE01F000C6;
	Mon, 19 Oct 2026 13:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418347;
	bh=SDs5R6kUmE/c463ZhHNv91aizgB6/8ZW9dCitRkoaxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A24rKESz8vd/jaWz53QAMXuMbblQbnAk+FMza8GGkH8sq8AehA6cba0WIkwIzIDrp
	 h0Vi2Biypm9ex6Qx6+Vhxg6LXLiFBKyvBRSaf7ocIsx788TjL+HTImOMY7UU3etBou
	 oVKm2LieKnerWjkOaP8qY1HUXP+ixtEh2Da/Q69uQsSTxPdxqig5FSSIXTIuk98+4t
	 MWCDeOd1qtU2fPIHFYJsC2t2jVASvpqzjPhHCZZEVUZtsj1/i3pM6iUDr/o3X13m+8
	 T+MRjhloLLDqzX6V6Qk8dCLZdxce1NpYtJWCyXq0QR1/Ne3xQK8+PTJbztwiODw3bn
	 NTerkbR8EyL5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Neil Andrews <neil@androos.io>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: usb-audio: Rename the Audient iD14 monitor mix volume control
Date: Mon, 19 Oct 2026 09:47:54 -0400
Message-ID: <20261019135441.1420968-183-sashal@kernel.org>
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

From: Neil Andrews <neil@androos.io>

[ Upstream commit 9c0564fcc21aec4f5b7648f61865ce3fc2b84a7f ]

On the Audient iD14 (2708:0008), feature unit 12 is traced through to
the Speaker output terminal and is therefore exported as "Speaker
Playback Volume".  The name fits it badly.  It advertises Volume on
only four of its six logical channels, which the driver records as
cmask=0xf, channels=4 on a 6-channel playback stream, and it sits on
the monitor mixer branch rather than in the direct playback path:

  INPUT_TERMINAL 2 (USB streaming, 6ch) -> EXTENSION_UNIT 51 ->
    FEATURE_UNIT 10 (no controls) -> OUTPUT_TERMINAL 20 (Speaker)

while FU 12 hangs off MIXER_UNIT 60 and feeds back into
EXTENSION_UNIT 51.

Userspace adopts the control as the stream's hardware playback volume,
so any setting below 0 dB attenuates part of the stream and not the
rest.  Measured over the device's own digital loopback, with one
-12 dBFS tone per channel played straight to hw:, PCM channel 0 is
unaffected while channel 1 tracks the control: at 107/127 (-20 dB) the
two read -15.89 and -35.89 dBFS, a 20.00 dB imbalance, and at 127/127
both read -15.89 dBFS.

Give the unit a non-standard name so that it is no longer taken for
the stream's master volume.  Dropping the control instead also fixes
the imbalance, but FU 12 keeps its value across a module reload, so
dropping it strands a device that is already attenuated with nothing
able to reset it.  Renaming leaves the monitor gain reachable and that
recovery path intact.

The mapped name ends in "Playback" because a name from the map
suppresses the automatic " Playback" but still gets " Volume"
appended; the control comes out as "Monitor Mix Playback Volume".

Tested on the ACP path with PipeWire, which is where the problem
reproduces: the control now stays at 127 at every volume setting and
the imbalance is 0.00 dB, and setting it by hand to 107 and back to
127 gives 20.00 dB and 0.00 dB as before.

Link: https://lore.kernel.org/linux-sound/0102019fed22f9d3-fa294ec5-02f1-4fd3-b3fa-76efc14331cc-000000@eu-west-1.amazonses.com/T/#u
Signed-off-by: Neil Andrews <neil@androos.io>
Link: https://patch.msgid.link/0102019ffcdbb1e6-9b59d3cc-ef05-4df1-8f9f-fb2f425bcda2-000000@eu-west-1.amazonses.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). This is a device-
specific USB mixer name-map quirk for Audient iD14 MkII (`2708:0008`):
userspace treats a monitor-mix control as master volume and creates a
**20 dB channel imbalance**. That is real, measured, and already the
kind of hardware quirk 6.12.y takes.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ALSA: usb-audio] [Rename] Audient iD14 monitor mix volume
control`
Subsystem: ALSA USB audio mixer maps. Verb “Rename” is a quirk, not a
refactor: the control is misnamed so PipeWire/PulseAudio treat it as
stream master volume.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Link: https://lore.kernel.org/linux-sound/0102019fed22f9d3-...` —
  original `[BUG]` report
- `Link: https://patch.msgid.link/0102019ffcdbb1e6-...` — submitted
  patch
- `Signed-off-by: Neil Andrews <neil@androos.io>` — author
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA maintainer
- No `Fixes:` (expected: not a regression; hardware descriptor + generic
  parser)
- No `Cc: stable` (expected for this review)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:`
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** On Audient iD14 USB `2708:0008`, FU 12 is named `"Speaker
  Playback Volume"` because it traces to the Speaker OT, but it is a
  4-of-6-channel monitor-mix control (`cmask=0xf`), not stream master
  volume.
- **Symptom:** Userspace uses it as hardware playback volume. Below 0 dB
  some PCM channels are attenuated and others are not. Measured 20.00 dB
  imbalance at 107/127; 0.00 dB at 127/127.
- **Root cause:** Topology: USB streaming → EU 51 → FU 10 (no controls)
  → Speaker OT 20; FU 12 hangs off mixer unit 60 and feeds back into EU
  51.
- **Why rename not drop:** Dropping also fixes imbalance, but FU 12
  keeps its value across module reload, so hiding the control strands an
  already-attenuated device with no recovery except power cycle.
- **Versions:** Reporter: “Not a regression”; same results on 6.19.14
  and 7.1.6.
- **Tested:** ACP + PipeWire; after rename the control stays at 127 and
  imbalance is 0.00 dB.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is an explicit hardware-quirk bug fix: wrong
exported kcontrol name causes incorrect userspace volume application.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/usb/mixer_maps.c` only (~+18 lines, 0 removed)
- New `audient_id14_map[]`: `{ 12, "Monitor Mix Playback" }`
- New `usbmix_ctl_maps[]` entry: `USB_ID(0x2708, 0x0008)`
- Scope: single-file, data-only, device-ID gated

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** Generic mixer walk names FU 12 from Speaker OT → `"Speaker
  Playback Volume"` (mapped_name=0 so `" Playback"` is auto-appended,
  then `" Volume"`).
- **After:** `find_map()` hits unit 12; `check_mapped_name()` copies
  `"Monitor Mix Playback"`; auto `" Playback"` is skipped; `" Volume"`
  is still appended → `"Monitor Mix Playback Volume"`. PipeWire no
  longer selects it as master volume.
- Path: USB mixer build at probe (`snd_usb_create_mixer` →
  `usbmix_ctl_maps` lookup → `__build_feature_ctl`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Hardware workaround / mixer name-map quirk.** Wrong ALSA
control name → userspace hardware-volume path → asymmetric attenuation.
Same class as existing maps (e.g. Hercules `"Master Playback"` instead
of `"Speaker Playback"`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct relative to `__build_feature_ctl()` naming rules,
  which the commit message documents.
- Surgical; no locking, alloc, or API change.
- Regression risk: only `2708:0008`. Userspace looking for `"Speaker
  Playback Volume"` on this card will miss it — that is the intended
  fix. The control remains settable for recovery.
- Maintainer chose rename over `{ 12, NULL }` after hardware tests of
  both.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Insertion is next to maps that have been there for years
(`usbmix_ctl_maps` since 2005; MAYA44 `044bddb9ca8d49` 2015; KEF
`d70a1b9893f820` 2014). Buggy *behavior* is generic USB mixer naming of
FU 12 from Speaker OT, not a recent 6.12-era commit. Device is class-
compliant; the bug exists whenever this interface is used with `snd-usb-
audio`.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. Reporter called it “Not a
regression.”

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `mixer_maps.c` changes in *this* tree are other device
maps/quirks (Corsair Virtuoso, Razer Barracuda dB map, KTMicro rename,
Corsair HS80). Same pattern. Standalone; not “patch X/Y”.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: No other Neil Andrews commits under `sound/usb/` in this tree.
Maintainer is Takashi Iwai, who applied the patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses `usbmix_name_map` / `usbmix_ctl_maps` / `find_map()` /
`check_mapped_name()` already in this tree. No new helpers. Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c` not usable: commit SHA is not in this checkout.
- `b4 mbox` on msgid found 2 messages: patch + Takashi “Applied to for-
  next branch. Thanks.”
- Bug thread (4 messages): Neil’s `[BUG]` report → Takashi suggested
  skip *or* rename → Neil tested both on 7.1.6 out-of-tree → Takashi:
  “Let's take the rename approach” → formal patch applied.
- No NAKs. No later unapplied revision.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc: `tiwai@suse.com`, `perex@perex.cz`, `linux-
sound@vger.kernel.org`. Reviewed and applied by ALSA USB maintainer
Takashi Iwai.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record:
- Lore `[BUG] snd-usb-audio: Audient iD14 (2708:0008) 20 dB channel
  imbalance` with loopback RMS numbers, descriptor dump, alsa-info.
- Independent real-world reports of L/R imbalance below 100% (AskUbuntu,
  Reddit, markwatkinson.com, GitHub `Audientid14-linux-fix`).
- UCM later qualified the userspace path: `alsa-ucm-conf` `Audient-
  iD14-HiFi-0008.conf` avoids driving FU 12; ACP (`api.alsa.use-
  ucm=false`) still hits it; alsactl restore of a value below 0 dB still
  hits it.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single standalone patch. Follow-up UCM work is userspace (`alsa-
ucm-conf` PR mentioning this kernel quirk). No kernel series dependency.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Web search of `lore.kernel.org/stable` for this subject found no
stable-list discussion. No recorded reason to skip it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No functions modified. New static data consumed by existing
mixer build.

**Step 5.2: TRACE CALLERS**
Record (verified in this tree):
- `usbmix_ctl_maps` scanned in mixer create (~line 3272 of
  `sound/usb/mixer.c`)
- `find_map()` in `__build_feature_ctl()` (~1689)
- `check_mapped_name()` then `append_ctl_name(..., " Volume")`
  (~1740–1786)
- Probe path when `2708:0008` is enumerated; not IRQ/hot-path locking

**Step 5.3: TRACE CALLEES**
Record: Data-only. Callees of the *users* of this map: `find_map`,
`check_ignored_ctl` (not taken because name is non-NULL),
`check_mapped_name`, `append_ctl_name`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Plug in device → `snd-usb-audio` probe → mixer descriptor walk →
FU 12 kcontrol registered → PipeWire/PulseAudio/alsactl. Userspace-
reachable. Unprivileged volume changes trigger the imbalance.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same file already remaps “Speaker Playback” (Hercules, Gigabyte,
ASUS, UAC3 BADD). This tree already contains `c4f7e90e66b6d` “Rename
ALSA kcontrol PCM and PCM1 for the KTMicro sound card” — a mixer_maps
rename that *was* backported with `Cc: stable`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes.
- `git describe HEAD`: `p-6.12-3-gc504cf0baa3d8`; `make kernelversion`:
  **6.12.111**
- `mixer_maps.c` and `__build_feature_ctl()` naming logic are present
- `audient_id14_map` / `USB_ID(0x2708, 0x0008)` **not** present (`git
  grep` empty)
- Existing Audient entry is MkI only: `DEVICE_FLG(0x2708, 0x0002,
  QUIRK_FLAG_IGNORE_CTL_ERROR)` in `quirks.c` (`df0380b9539b0`, 2021).
  Different product ID; does not fix MkII naming.
- Bug is descriptor + generic parser, present since this driver existed;
  reporter confirmed not a regression.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Local hunk context matches the patch (MAYA44
`0x2573:0x0008` then KEF `0x27ac:0x1000`). `usbmix_name_map` layout `{
id, name, control, dB }` matches `{ 12, "Monitor Mix Playback" }`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No Audient monitor-mix rename. No other 6.12 fix for `2708:0008`
mixer names.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `sound/usb/` (`CONFIG_SND_USB_AUDIO`). **IMPORTANT** for USB
audio interfaces; device-specific, not core mm/fs. Mixer maps are the
designed extension point (“if the mixer topology is too complicated… add
the entries in usbmixer_maps.c”).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver; this file still gets device maps regularly.
Recent 6.12 backports in the same file are other quirks/maps.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Users of Audient iD14 MkII USB `2708:0008` with `snd-usb-audio`
(class-compliant). Not universal. ACP/PipeWire without the UCM profile
is the reproducing path; alsactl restore of a low FU 12 value affects
even UCM users.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Common for desktop use: plug in, play audio, move volume below
100%. Unprivileged. Not a race. Hardware keeps attenuated FU 12 across
module reload.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Severe **audio correctness** bug: 20 dB L/R (or channel 0 vs 1)
imbalance. Not oops/UAF/corruption. HIGH for this device class
(interface unusable at typical desktop volumes). Multiple independent
user reports.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: HIGH for iD14 MkII on 6.12 (desktop/PipeWire, no or old UCM).
- Risk: VERY LOW — +18 lines, one USB ID, no behavioral change for any
  other device.
- Ratio: strongly favors backport. Same class as maps already in this
  tree.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, measured 20 dB imbalance; loopback RMS; PipeWire ACP
  reproduction
- Hardware quirk / mixer name map — explicit stable exception
- Small, data-only, device-ID gated
- Applies cleanly to this 6.12 tree; infrastructure present since 2005
- ALSA maintainer requested rename, tested both options, applied v1
- Analogous KTMicro mixer rename already in this tree via stable
- Long-standing user complaints of L/R imbalance on this hardware
- No new APIs/features/module parameters

AGAINST:
- Not a crash/security/data-corruption issue
- Newer `alsa-ucm-conf` can avoid driving the control on the HiFi
  profile
- Does not cover MkI `2708:0002` (out of scope of this patch)

UNRESOLVED:
- Exact mainline SHA (not in this checkout; `b4 dig -c` unused)
- No stable@ discussion found

Those do not outweigh the quirk: UCM is userspace and not guaranteed on
6.12 distros; MkI is a different ID.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — maintainer-approved;
   hardware loopback tests of rename vs drop
2. Fixes a real bug that affects users? **PASS** — 20 dB imbalance;
   multiple reports
3. Important issue? **PASS** — serious functional audio bug on a
   shipping USB interface (quirk exception)
4. Small and contained? **PASS** — ~18 lines, one file
5. No new features or APIs? **PASS** — existing map table only
6. Can apply to the local tree? **PASS** — clean context at MAYA44/KEF

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk / workaround** (USB mixer name map for a
misdescribed control). Same bucket as USB/PCI/codec quirks that stable
already takes.

**Step 9.4: MAKE YOUR DECISION**
Backport to this 6.12.y tree. The bug is in this kernel’s generic mixer
naming; the device works here; the fix is a one-ID table entry with
negligible regression risk.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed subject/tags/body from the provided commit and lore
  mbox; no Fixes/Cc:stable; Links to bug + patch
- [Phase 1] Bug thread: “Not a regression”; 6.19.14 and 7.1.6 identical;
  20.00 dB at 107/127
- [Phase 2] Diff: +18 lines in `sound/usb/mixer_maps.c` only;
  `audient_id14_map` + `USB_ID(0x2708, 0x0008)`
- [Phase 2] Verified `__build_feature_ctl()`: mapped name skips `"
  Playback"`, still appends `" Volume"` (`mixer.c` 1740–1786)
- [Phase 2] Verified `check_ignored_ctl()`: non-NULL name is not ignored
  (so rename keeps the control)
- [Phase 3] `git blame` insertion neighbors: MAYA44 2015, KEF 2014, maps
  table since 2005
- [Phase 3] `git log --author='Neil Andrews' -- sound/usb/`: empty in
  this tree
- [Phase 3] Existing Audient quirk `df0380b9539b0` is `2708:0002`
  IGNORE_CTL_ERROR only
- [Phase 3] KTMicro rename `c4f7e90e66b6d` is an ancestor of HEAD (same
  class, already backported)
- [Phase 4] `b4 mbox` patch msgid: 2 msgs; Takashi applied to for-next;
  no NAK
- [Phase 4] `b4 mbox` bug msgid: 4 msgs; Takashi asked for rename; Neil
  measured both options
- [Phase 4] lore WebFetch 403; used b4 + lkml.iu.edu + patchew instead
- [Phase 4] `b4 dig -c`: UNVERIFIED (SHA not in this tree)
- [Phase 4] stable@ search: no hits
- [Phase 5] Callers: mixer create map walk (~3272), `find_map` in
  `__build_feature_ctl` (~1689)
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.12.111
  `pending-6.12`
- [Phase 6] `git grep audient_id14_map` / `USB_ID(0x2708, 0x0008)`: not
  in tree (bug still present)
- [Phase 6] Insertion point in local `mixer_maps.c` 586–595 matches the
  patch (clean apply)
- [Phase 7] `CONFIG_SND_USB_AUDIO` in `sound/usb/Kconfig`
- [Phase 8] Failure mode: 20 dB channel imbalance, not oops; severity
  HIGH for this device
- UNVERIFIED: mainline commit SHA; whether every 6.12 distro ships the
  later UCM profile (kernel still should export the correct name)

This is a small, tested, device-ID-gated mixer quirk that stops PipeWire
from driving a partial-coverage monitor mix as master volume. It belongs
in this 6.12 tree.

**YES**

 sound/usb/mixer_maps.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index ce27fc871f513..8046d5987d5b1 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -505,6 +505,19 @@ static const struct usbmix_connector_map gigabyte_b450_connector_map[] = {
 	{}
 };
 
+/* Audient iD14: FU 12 advertises Volume on only 4 of its 6 logical channels
+ * and sits on the monitor mixer branch, but it is traced through to the
+ * Speaker output terminal and gets named "Speaker Playback Volume".  Userspace
+ * then adopts it as the stream's hardware volume, and any setting below 0 dB
+ * attenuates some channels but not others (20 dB imbalance at 80%).  Give it a
+ * non-standard name so that it is no longer taken for the stream's master
+ * volume, while remaining reachable for anyone who wants the monitor gain.
+ */
+static const struct usbmix_name_map audient_id14_map[] = {
+	{ 12, "Monitor Mix Playback" },	/* FU, partial coverage */
+	{}
+};
+
 /*
  * Control map entries
  */
@@ -588,6 +601,11 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x2573, 0x0008),
 		.map = maya44_map,
 	},
+	{
+		/* Audient iD14 */
+		.id = USB_ID(0x2708, 0x0008),
+		.map = audient_id14_map,
+	},
 	{
 		/* KEF X300A */
 		.id = USB_ID(0x27ac, 0x1000),
-- 
2.53.0

