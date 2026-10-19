Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545665B67B7;
	Mon, 19 Oct 2026 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418449; cv=none; b=pK1JLWdB+XGvYg1zzpKIYv06JiaMYGSTmV8ktSs8mrGW9nPyinlwVsTELEWVJHJIOUQ2tkfAO2oNJrMieFVvv6GVaNNsA/CwqzSM4uTtHVAkCoQDUc41eVGFyKmQ1Ph4rzYo00itkEAVPzeCjar6RCU39Qa9gy6QmYv9D6vOS+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418449; c=relaxed/simple;
	bh=v6xrb8KAi+mydGBs7GMqwtqRhlfvL8jo+1ptqve4nFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DclSzKLALmOtw/xSC4qTmQSnK3OhyRATFKkMc3ZrpBYfSgbJoWoXBxK3nWNaYKq8WlMqewL6Gkx0zjxTFctmwFMCkVwh7mZDK+tLhagKhKhu+z9jgA/+gEZGpLy+ePUDMILz5A1Ajnwezu5cFGpCOqLY/oAhlSkk72273DkcHP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHvchVMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHvchVMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D86C1F000C7;
	Mon, 19 Oct 2026 14:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418447;
	bh=GmGXMd06ZWeR4fnuAUg89Ig7BzTtpBt4l+XJGswfwUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHvchVMYhPK/RErCLImOS6OshfOAeckB5v7Qc6GVJMIGWCfK1aIdshr1E738fH+Fr
	 8cSz/RCAlSR8Mm181HRWcNqLfvTzuCATNmqG0hSgc3D/i1HjlEaN0wg0c/SJU7hRAE
	 JTMLEhqGK8W60VzmL+LRirNApbC80a/ay9GxZKlBuwAT+kXdpnf/4RYE8+Hx4V2FDH
	 dnIz3zrawW6Iscl/LLsXlAS65zEFrKuj6mnwuiUtii8T/7/bf/t6ffXEP6amZERHf4
	 wWZDH4U244lWbdhH99T/hOS6gU+EX+2xtdkeV59KxbEgUsw/BUjS9UBRx5r5kAIbbe
	 4kkEwVcfutyBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Will Porter <mrwillporter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: usb-audio: Add iD14 MkI to monitor-mix volume quirk
Date: Mon, 19 Oct 2026 09:49:06 -0400
Message-ID: <20261019135441.1420968-255-sashal@kernel.org>
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

From: Will Porter <mrwillporter@gmail.com>

[ Upstream commit 17056a36d276a740f09dca723de1bc6aa3eb4ef9 ]

Add the iD14 MkI USB ID to the existing audient_id14_map. This
names feature unit 12 Monitor Mix Playback Volume.

Live meter A/B testing on MkI USB ID 2708:0002 reproduced the same
asymmetric attenuation seen on MkII. At ALSA value 104, the right
channel was 23.07 dB below the left. At 127, both channels were equal.

The misleading Speaker Playback Volume name causes PipeWire to adopt
FU12 as the stream master. Reuse the existing map to keep the control
available while preventing that selection.

Hardware-tested on Bazzite 7.2.0-ogc4.1.fc44.x86_64 with this change
backported. ALSA exposed Monitor Mix Playback Volume after module load
and USB reconnect. PipeWire volume changes from 100% to 35% and back
left all four FU12 values at 127. Channel-isolated left/right playback
remained balanced after reconnect.

Build-tested with CONFIG_SND_USB_AUDIO=m using the focused sound/usb
target.

Assisted-by: Codex:gpt-5
Signed-off-by: Will Porter <mrwillporter@gmail.com>
Link: https://patch.msgid.link/20260823015353.686080-1-mrwillporter@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the local-tree, prerequisite, and mailing-list evidence. Writing
the full nine-phase analysis next.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ALSA / usb-audio] [Add] Add iD14 MkI USB ID to the existing
monitor-mix volume name map**

- Subsystem: `ALSA: usb-audio`
- Action verb: **Add** (USB ID / quirk-table entry, not a new API)
- Intent: extend `audient_id14_map` so MkI feature unit 12 is named
  “Monitor Mix Playback Volume” instead of “Speaker Playback Volume”

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none as a tag; body describes first-party hardware test
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** `https://patch.msgid.link/20260823015353.686080-1-
  mrwillporter@gmail.com`
- **Cc: stable:** none (expected; not a negative signal)
- **Assisted-by:** Codex:gpt-5
- **Signed-off-by:** Will Porter `<mrwillporter@gmail.com>`
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer;
  ignore any Sasha Levin SOB)
- **Upstream commit** markers: ignore per instructions

Notable: no syzbot, no multi-user Reported-by. Strength comes from
hardware measurement and maintainer apply.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** FU 12 is walked through to the Speaker output terminal, so
  ALSA exports it as “Speaker Playback Volume”. PipeWire then uses that
  control as the stream hardware master.
- **Symptom:** asymmetric attenuation. On MkI `2708:0002`, ALSA value
  104 → right channel **23.07 dB** below left; at 127 both channels
  match.
- **Root cause:** misleading default name, not a kernel crash path. Same
  class of bug already described for MkII.
- **Fix:** reuse `audient_id14_map` so the control is “Monitor Mix
  Playback Volume” and is no longer chosen as stream master, while
  remaining reachable.
- **Version info:** tested as a backport on Bazzite
  `7.2.0-ogc4.1.fc44.x86_64`; build-tested with
  `CONFIG_SND_USB_AUDIO=m`.
- **Hidden vs explicit:** this is an explicit hardware-quirk / name-map
  fix, not cleanup disguised as a fix.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a hidden fix.** The message states the imbalance, the
userspace trigger, and the map reuse. It is a USB mixer name-map quirk.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `sound/usb/mixer_maps.c` only
- **Scope:** +13 / −8 (comment rewrite + one `usbmix_ctl_maps[]` entry)
- **Functions / objects:** `audient_id14_map[]` comment;
  `usbmix_ctl_maps[]` (adds `USB_ID(0x2708, 0x0002)`)
- **Classification:** single-file surgical USB-ID / quirk addition

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before (mainline, MkII-only):** `audient_id14_map` remaps unit 12 →
  `"Monitor Mix Playback"` for `0x2708:0x0008` only. MkI `0x2708:0x0002`
  still gets the default “Speaker Playback Volume” name.
- **After:** same map is also bound to `0x2708:0x0002`.
  `snd_usb_create_mixer()` walks `usbmix_ctl_maps[]`, matches
  `chip->usb_id`, and `check_mapped_name()` supplies the mapped name.
  Because `mapped_name` is set, mixer.c does **not** append `"
  Playback"`; it still appends `" Volume"` → `"Monitor Mix Playback
  Volume"`.
- **Path:** mixer probe / control-creation only. Not a hot path, error
  path, or locking change.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** **(h) Hardware workaround** + **(g) logic/correctness of
  exported control name**
- **Mechanism:** default terminal-derived name makes PipeWire treat a
  monitor-mix FU as master volume. That FU does not apply equally to all
  channels (MkI: imbalance inside the stereo pair; MkII: 4 of 6
  channels). Remapping the name stops that selection without dropping
  the control (dropping it would strand a persisted attenuated FU12).

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct and matches an established
  `usbmix_name_map` pattern already used throughout this file.
- **Regression risk:** very low. The new entry is keyed by USB ID
  `0x2708:0x0002` only. Other devices are untouched. The control remains
  present under a different name.
- **Red flags:** none for APIs, locking, or size. Dependency: the commit
  **assumes** `audient_id14_map` and the MkII `0x2708:0x0008` entry
  already exist.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- In **this** 6.12 tree, `audient_id14_map` and the `0x2708:0x0008` ctl-
  map entry **do not exist**.
- The buggy *behavior* is the long-standing default in
  `__build_feature_ctl()` (`sound/usb/mixer.c`): if there is no map,
  volume is named from the output terminal (“Speaker”) + `" Playback"` +
  `" Volume"`. That logic is in this tree (verified at
  mixer.c:1740–1786).
- MkI already has a **different** quirk here since 2021: `df0380b9539b0`
  (“ALSA: usb-audio: Add quirk for Audient iD14”) adds
  `DEVICE_FLG(0x2708, 0x0002, QUIRK_FLAG_IGNORE_CTL_ERROR)` in
  `sound/usb/quirks.c:2374`. That is control-message error ignoring, not
  this name-map.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Not applicable.

The functional prerequisite is the MkII map, submitted 2026-08-13 by
Neil Andrews: “ALSA: usb-audio: Rename the Audient iD14 monitor mix
volume control” (adds `audient_id14_map` + `USB_ID(0x2708, 0x0008)`).
Takashi applied that to for-next on 2026-08-14. That commit is **not**
in this 6.12 checkout.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record (this tree, `sound/usb/mixer_maps.c`):
- Recent entries are the same class of quirk: Corsair Virtuoso later
  revision, Razer Barracuda dB map, Corsair HS80, Gigabyte B450, MSI
  boards, etc.
- This candidate is **standalone relative to a series** (not “N/M”), but
  it **depends** on the Aug 13 MkII map commit.
- Same-class commits **already backported into this 6.12 tree**:
  - `0d928648172c3` Corsair Virtuoso later revision — adds USB IDs to an
    existing mixer map
  - `c74de4e57685d` Corsair HS80 — new mixer map so PulseAudio/PipeWire
    do not grab the wrong volume

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record:
- Will Porter has **no** other usb-audio commits in this tree.
- Neil Andrews has none here either.
- Takashi Iwai is the ALSA/usb-audio maintainer and applied both the
  MkII and MkI patches immediately (“Applied now. Thanks.” / “Applied to
  for-next branch.”).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- **Prerequisite:** MkII `audient_id14_map` (Neil Andrews, 2026-08-13).
  Missing from HEAD, from `master` in this repo (tip ~7.2-rc7,
  2026-08-08), and from `linux-rolling-stable` / `linux-rolling-lts`
  mixer_maps.c.
- **Can this SHA apply standalone here?** No. Context hunks (the map
  comment and the `0x2708:0x0008` entry) are absent.
- **Can a backport stand alone?** Yes. `usbmix_name_map` /
  `usbmix_ctl_maps` / `find_map()` / `check_mapped_name()` already
  exist. A 6.12 backport is: add the 4-line map plus the MkI (and
  optionally MkII) USB ID. That is the same shape as HS80/Virtuoso maps
  already in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c <sha>`: candidate SHA is **not in this repo** (applied
  after current `master` tip). Used msgid instead.
- `b4 mbox` msgid `20260823015353.686080-1-mrwillporter@gmail.com`:
  **2-message thread**.
- Lore/LKML: https://lkml.iu.edu/2608.2/12083.html
- **Revisions:** single version (v1). `base-commit:
  7e77c09e23dae1ff8bd8598c3c96f9db6862eddd` (object exists here but is
  **not** an ancestor of this 6.12 HEAD).
- **Reviewer feedback:** Takashi Iwai, 2026-08-23: “Applied now.
  Thanks.” No NAK, no requested changes, no stable nomination in-thread.
- MkII prerequisite thread: https://lists.openwall.net/linux-
  kernel/2026/08/13/2036 — Takashi: “Applied to for-next branch.
  Thanks.”

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To/Cc on the MkI mail includes the ALSA path; Takashi (subsystem
maintainer) applied it the next morning. No other review comments.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record:
- No bugzilla/syzbot link.
- Evidence is the author’s live-meter A/B test on MkI `2708:0002`,
  reproducing the MkII imbalance (Neil Andrews measured 20.00 dB on MkII
  via digital loopback).
- **Users affected:** owners of Audient iD14 MkI (USB `2708:0002`) using
  PipeWire (default on modern desktops). MkI has been quirked in-tree
  since 2021, so this population exists on 6.12.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Not a numbered series. Follow-up to the MkII rename (different
author, 10 days later). For this tree, a useful backport is **map + MkI
ID** (MkII ID optional).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable returned 403; WebSearch on
`site:lore.kernel.org/stable` for this subject found **no** iD14
monitor-mix discussion. No recorded reason to exclude it. The 2021
IGNORE_CTL_ERROR quirk **was** sent to stable (`[PATCH 5.15 12/12]`).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS IN THE DIFF**

Record: no function bodies changed. Data only: `audient_id14_map`,
`usbmix_ctl_maps[]`.

**Step 5.2: TRACE CALLERS**

Record:
- `snd_usb_create_mixer()` (`mixer.c:3272`) walks `usbmix_ctl_maps[]`
  and sets `state.map` on USB ID match.
- `find_map()` / `check_mapped_name()` / `__build_feature_ctl()` consume
  that map when creating feature-unit kcontrols.
- Context: USB audio probe / mixer build. Not IRQ, not a syscall hot
  path.

**Step 5.3: TRACE CALLEES**

Record: map is data. Naming uses `check_mapped_name()` → `strscpy()`,
then `append_ctl_name(..., " Volume")`. No alloc/lock/I/O in the new
code.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: userspace-reachable: plug in iD14 MkI → `snd-usb-audio` probe →
mixer controls appear → PipeWire enumerates “Speaker Playback Volume” as
hardware master. **Yes, reachable from normal desktop use.**
Unprivileged users can trigger it by moving the session volume.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: this file is full of the same pattern (Corsair, Gigabyte, MSI,
Bose, …). This 6.12 tree already backported sibling “wrong mixer name →
userspace grabs the wrong volume” quirks.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- **Tree:** `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` = **6.12.111**.
- **Buggy default naming:** yes, `sound/usb/mixer.c`
  `__build_feature_ctl()`.
- **MkI device:** yes, `QUIRK_FLAG_IGNORE_CTL_ERROR` for
  `0x2708:0x0002`.
- **`audient_id14_map` / MkII ID `0x2708:0x0008`:** **no**.
- Bug is **not** “introduced after 6.12 branched”. The hardware +
  default namer have been here for years. The *fix table* is what is new
  (2026).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **needs a small backport, not a clean `git am`.** Insertion
point still exists (`MAYA44 USB+` then `KEF X300A` at
mixer_maps.c:586–595). Add `audient_id14_map` after
`gigabyte_b450_connector_map` and a `usbmix_ctl_maps[]` entry for
`0x2708:0x0002`. Line numbers differ slightly from mainline; no
structural conflict.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: no monitor-mix / `audient_id14` name map. The 2021
IGNORE_CTL_ERROR quirk is unrelated and does not fix imbalance.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **ALSA USB-audio mixer maps** (`sound/usb/mixer_maps.c`).
Criticality: **PERIPHERAL / device-specific**, but the driver is common
(`CONFIG_SND_USB_AUDIO`). Same class as USB/codec quirks that stable
accepts routinely.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: actively maintained; this 6.12 tree continues to take mixer-map
USB ID and naming quirks (Virtuoso, HS80, etc.).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **driver-specific / USB-ID-specific** — Audient iD14 MkI
(`2708:0002`). MkII (`2708:0008`) is not even listed in this tree; this
commit’s MkI ID is the one that matters here.

**Step 8.2: TRIGGER CONDITIONS**

Record:
- Trigger: PipeWire (or similar) adopts “Speaker Playback Volume” as
  stream master and the user sets volume below 0 dB / 100%.
- **How common:** every volume change below unity on a typical desktop,
  once the device is plugged in.
- **Unprivileged:** yes (session volume). Not a privilege-escalation
  issue; it is broken stereo.

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- **Failure:** large L/R imbalance (measured **23.07 dB** at ALSA 104).
  Audio is effectively wrong; not a panic/UAF.
- **Severity: HIGH for affected hardware** (serious functional/hardware
  bug), **not CRITICAL** (no crash/corruption/security).

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** high for MkI owners on 6.12 (device already quirked here
  since 2021; PipeWire is the usual stack).
- **Risk:** very low (ID-keyed name map; ~10-line backport).
- **Ratio:** strongly favors backporting, matching Virtuoso/HS80
  precedent **in this same tree**.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real, measured 23 dB channel imbalance on MkI; same class as the MkII
  bug.
- Hardware-tested, including a backport; maintainer applied v1
  immediately.
- Classic USB mixer name-map / hardware quirk (stable exception).
- This 6.12 tree already ships the same kind of mixer_maps USB-ID
  quirks.
- MkI is already a supported ID here; the namer bug is present.
- Tiny, ID-scoped, no new API, no locking.

**AGAINST:**
- `audient_id14_map` is not in this tree; the patch does not apply as-
  is.
- Depends on the Aug 2026 MkII map commit (18 lines).
- Not a crash/security/corruption bug.
- Affects one USB audio interface.

**UNRESOLVED:**
- Exact mainline SHA is not in this clone (`master` stops at
  ~2026-08-08). Thread + msgid confirm apply.
- Stable list search could not be fetched (403); no positive or negative
  stable-list signal.

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — map reuse; hardware + build
   tested; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — 23 dB imbalance under
   PipeWire.
3. Important issue? **PASS** under the hardware-quirk exception (severe
   broken output on a supported device). Not a kernel crash.
4. Small and contained? **PASS** — one file; backport is a small map +
   ID.
5. No new features or APIs? **PASS** — rename existing control via
   existing map machinery.
6. Can apply to the local tree? **PASS with backport** — not a clean
   apply; fold in `audient_id14_map` (and optionally the MkII ID).
   Infrastructure is already here.

**Step 9.3: EXCEPTION CATEGORIES**

Record: **Hardware quirk / USB ID addition** to the existing usb-audio
mixer map tables. Same exception as USB quirks and HDA `SND_PCI_QUIRK`
entries.

**Step 9.4: DECISION**

This is a device-specific name-map quirk for hardware this 6.12 tree
already supports. The missing MkII map is a packaging dependency, not a
missing subsystem: a few lines of `usbmix_name_map` plus `USB_ID(0x2708,
0x0002)` are enough. That is exactly the class of mixer_maps change this
tree already takes (HS80, Virtuoso). Benefit for MkI + PipeWire users is
large; regression risk is confined to that USB ID.

---

### What the commit solves (for this tree)

On Audient iD14 MkI, feature unit 12 is exported as “Speaker Playback
Volume”. PipeWire treats that as hardware master and, below 0 dB,
attenuates channels unequally (23 dB L/R error in the author’s test).
Remapping unit 12 to “Monitor Mix Playback Volume” stops that selection
and keeps the monitor gain usable.

### Risk vs benefit

Benefit is restoring correct stereo for an interface already quirked in
6.12 since 2021. Risk is a few ID-keyed lines in `mixer_maps.c`. The
only extra work is including `audient_id14_map` because the Aug 2026
MkII commit is not here.

### Concerns

- Do not `git am` the mainline diff as-is; add the map (and the MkI ID)
  by hand.
- MkII `0x2708:0x0008` is optional on 6.12 (that ID is not present
  here).

---

### Verification

- **[Phase 1]** Parsed subject/tags/body from the provided commit and
  the b4 mbox. Tags: Link msgid, Assisted-by Codex, SOB Will Porter +
  Takashi Iwai. No Fixes/Reported-by/Cc:stable.
- **[Phase 2]** Diff is comment rewrite + one `usbmix_ctl_maps[]` entry
  for `0x2708:0x0002` in `sound/usb/mixer_maps.c`.
- **[Phase 2]** Verified naming in this tree: `mixer.c:1740–1786` —
  mapped name suppresses `" Playback"`, still appends `" Volume"`.
- **[Phase 2]** Verified map attach: `mixer.c:3272–3278` matches
  `usbmix_ctl_maps[].id` to `chip->usb_id`.
- **[Phase 3]** `git describe HEAD` / `make kernelversion`: **6.12.111**
  (`p-6.12-3-gc504cf0baa3d8`).
- **[Phase 3]** `git grep` on `sound/usb`: no `audient_id14`, no
  `Monitor Mix`; only `DEVICE_FLG(0x2708, 0x0002)` in `quirks.c:2374`.
- **[Phase 3]** `git show df0380b9539b0`: 2021 IGNORE_CTL_ERROR quirk;
  `git merge-base --is-ancestor` → present. Different bug.
- **[Phase 3]** `git log --grep=iD14 -- sound/usb/`: only that 2021
  quirk plus an unrelated subject match. No monitor-mix map.
- **[Phase 3]** Similar 6.12 backports: `0d928648172c3` (Virtuoso USB
  IDs), `c74de4e57685d` (HS80 mixer map, `cc: stable`).
- **[Phase 3]** `git merge-base --is-ancestor 7e77c09e23dae1... HEAD` →
  **not** an ancestor; object type is `commit`.
- **[Phase 3]** `master` / `linux-rolling-stable` / `linux-rolling-lts`:
  still no `audient_id14_map` (master tip ~2026-08-08, before both
  patches).
- **[Phase 4]** `b4 mbox` MkI thread (2 msgs): submission + Takashi
  “Applied now.”
- **[Phase 4]** `b4 mbox` MkII thread (2 msgs): Neil Andrews map +
  Takashi “Applied to for-next.”
- **[Phase 4]** WebFetch LKML/openwall confirmed both diffs.
  lore.kernel.org 403; stable-list search found nothing relevant.
- **[Phase 5]** Call chain: probe → `snd_usb_create_mixer` →
  `__build_feature_ctl` → PipeWire. Userspace-reachable.
- **[Phase 6]** Insertion neighbors `MAYA44` / `KEF X300A` exist at
  mixer_maps.c:586–595; map array itself missing.
- **[Phase 8]** Failure mode verified from commit text + MkII loopback
  measurements in the prerequisite mail (20 dB MkII / 23 dB MkI).
- **UNVERIFIED:** mainline SHA of the applied MkI commit (not in this
  clone). Not used as a reason to reject; thread + maintainer apply are
  verified.

The missing MkII map is a few lines to include in the backport, not a
missing subsystem. This is a hardware quirk this tree already accepts.

**YES**

 sound/usb/mixer_maps.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 8046d5987d5b1..ace4ccad8f51c 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -505,13 +505,13 @@ static const struct usbmix_connector_map gigabyte_b450_connector_map[] = {
 	{}
 };
 
-/* Audient iD14: FU 12 advertises Volume on only 4 of its 6 logical channels
- * and sits on the monitor mixer branch, but it is traced through to the
- * Speaker output terminal and gets named "Speaker Playback Volume".  Userspace
- * then adopts it as the stream's hardware volume, and any setting below 0 dB
- * attenuates some channels but not others (20 dB imbalance at 80%).  Give it a
- * non-standard name so that it is no longer taken for the stream's master
- * volume, while remaining reachable for anyone who wants the monitor gain.
+/* Audient iD14 MkI and MkII: FU 12 sits on the monitor mixer branch but is
+ * traced through to the Speaker output terminal, so it is named "Speaker
+ * Playback Volume".  On MkII it controls only 4 of 6 playback channels.  MkI
+ * testing found asymmetric attenuation within the main stereo pair.  Userspace
+ * adopts this control as the stream's hardware volume, causing imbalance below
+ * 0 dB.  Give it a non-standard name so that userspace no longer treats it as
+ * the stream master, while keeping the monitor gain reachable.
  */
 static const struct usbmix_name_map audient_id14_map[] = {
 	{ 12, "Monitor Mix Playback" },	/* FU, partial coverage */
@@ -602,7 +602,12 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.map = maya44_map,
 	},
 	{
-		/* Audient iD14 */
+		/* Audient iD14 MkI */
+		.id = USB_ID(0x2708, 0x0002),
+		.map = audient_id14_map,
+	},
+	{
+		/* Audient iD14 MkII */
 		.id = USB_ID(0x2708, 0x0008),
 		.map = audient_id14_map,
 	},
-- 
2.53.0

