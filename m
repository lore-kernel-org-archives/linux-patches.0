Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D616050A3;
	Mon, 19 Oct 2026 14:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418598; cv=none; b=EMj8C1kQQ9ul1qoL5QDcmNcpN1GPup26YMdhDsn/A+WC6x/6gtETFMsIVr8JuXqRYpuaLWfGJxTJY+gongjvYxbVfVxatVctlKJzR2AmkzAIefSgMiNWMeKdDOQIzmEIy8LpuI2FfSHjEOl5WlT/fSRQJv+B/l27KOEGnP+Wv6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418598; c=relaxed/simple;
	bh=k7uw0K4tIKoECCxLLfNlKCLh8dptzEKDhqhNok8A4Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJ1HtGyOLbQ1u4iwji/XSDmBBnp7C/AJy0re4DAj7u4AfM34R/dFNnEnXbHw2m7RgfahbWrRkv/nuc88+kwTIp5FusXaggPzx/1GbwIOMlVcAZicfoIaOR33sNsBvMJgzMs7vLNW/Mu3hDF2dy7ca9xFSgoqsj52vzMDuPm3wdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMdu1m0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMdu1m0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30931F000C7;
	Mon, 19 Oct 2026 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418594;
	bh=gpac75BMATzt9YGi6lrESx49XbXRDzTsYj+TX3qYF4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMdu1m0JaHfu+yrlAiXnYuOZ3TpENLw7AXj7Oq9Zs7P0cek4w1Ybavc0y9a6vL0oO
	 p1tkn6Lb3ziDYyvOdgppGnnRTzSC/+cOQUvkt6MkfDKrg7mC6kxKBRm1GfyjpBExVu
	 SeID9MFGptw5pBcA0eGfS81aCXWqao13qWJEZJ3/0BUIkO/iXoiRFj6jlb/EeqV7A0
	 zMr2edR2ik+rSDjaaxJD7LOJMoMf6o3r2GwWVYcYeQZClKjp35upjGvisl3yiuiWz7
	 eb5NeVEPTcv+3iIDHvI3wMDaeXuNIoBP7gNg9QLFQbzGG3H/MMWW1mOqXoIF/Cr6dE
	 J4Ju6yEtYvo0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Federico=20Valent=C3=ADn=20Andrade?= <fandrade@frba.utn.edu.ar>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: usb-audio: Skip mixer creation on M-Audio Venom
Date: Mon, 19 Oct 2026 09:50:50 -0400
Message-ID: <20261019135441.1420968-359-sashal@kernel.org>
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

From: Federico Valentín Andrade <fandrade@frba.utn.edu.ar>

[ Upstream commit 4c0ec35e011309bd7091053ad5bbc01420967a66 ]

The M-Audio Venom (0763:2084) does not answer any GET_CUR request
of its feature units, hanging up the USB microcontroller and
"responding" with timeouts. So the mixer building lasts around 47
seconds, and the device does not stream at all.

The same GET_CUR requests issued through libusb (with no kernel
driver bound) complete correctly and blazingly fast. So it seems
to only happen during the initial probe.

I defined an explicit composite quirk to bypass the mixer creation,
as it is not needed (the synth already comes with volume controls).

With both this and the device flag applied, the synth works
flawlessly.

Signed-off-by: Federico Valentín Andrade <fandrade@frba.utn.edu.ar>
Link: https://patch.msgid.link/20260824140211.17003-3-fandrade@frba.utn.edu.ar
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a device-specific usb-audio quirk, the
local 6.12 tree has the same table and macros, and the companion flag
patch is independent.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ALSA usb-audio] [Skip] [Do not build the mixer for M-Audio
Venom 0763:2084 because GET_CUR on feature units hangs the device]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Federico Valentín Andrade <fandrade@frba.utn.edu.ar>
  (author)
- Link: https://patch.msgid.link/20260824140211.17003-3-
  fandrade@frba.utn.edu.ar (v3 series; msgid `-3` is patch 2/2 after the
  cover)
- Signed-off-by: Takashi Iwai <tiwai@suse.de> (ALSA maintainer; applied)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence expected)
- Ignore pipeline markers (Upstream commit / Sasha Levin) if present

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: Venom does not answer GET_CUR on feature units during probe; the
  USB microcontroller hangs and later transfers time out.
- Symptom: mixer build ~47 seconds; device does not stream.
- Contrast: same GET_CUR via libusb with no kernel driver is fast — hang
  is probe-path specific.
- Fix: composite quirk ignores interface 0 (AudioControl/mixer);
  interfaces 1–2 stay standard audio; 3 stays standard MIDI. Hardware
  already has volume knobs.
- Author: “With both this and the device flag applied, the synth works
  flawlessly.”
- Cover letter (v1 0/2): device has never worked over USB on Linux;
  users reported the port useless for years. dmesg without quirks:
  `cannot get freq at ep 0x2`, then many `failed to get current value` /
  `cannot get min/max` with `-110` (ETIMEDOUT), then looping
  `usb_set_interface failed (-110)`. Flags alone list the card but
  produce no sound. Mixer skip is what made audio work.
- Tested on 7.1.8-arch1-3 xHCI (Intel PCH); alsa-info linked from v1.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. Explicit hardware workaround: skip mixer creation so
probe does not issue the GET_CUR sequence that wedges the MCU.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `sound/usb/quirks-table.h` only (+22 lines, 0 removed)
- Function: none; one `usb_device_id` / `snd_usb_audio_quirk` table
  entry
- Scope: single-file surgical hardware quirk

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: 0763:2084 is not in the quirk table. Generic class match in
  `usb_audio_ids` (`USB_CLASS_AUDIO` / `USB_SUBCLASS_AUDIOCONTROL`,
  `card.c` 1171–1173) claims it. Probe calls `snd_usb_create_streams()`
  then `snd_usb_create_mixer()` (`card.c` 899–903). Mixer build issues
  GET_MIN/GET_MAX/GET_CUR (`get_min_max_with_quirks`, `init_cur_mix_raw`
  in `mixer.c`).
- After: `USB_DEVICE_VENDOR_SPEC(0x0763, 0x2084)` + composite:
  `QUIRK_DATA_IGNORE(0)` → `ignore_interface_quirk()` returns 0 (no
  mixer); `QUIRK_DATA_STANDARD_AUDIO(1/2)` →
  `create_standard_audio_quirk()` → `snd_usb_parse_audio_interface()`;
  `QUIRK_DATA_STANDARD_MIDI(3)`. Because `snd_usb_create_quirk()`
  returns 0, `card.c` does not take the generic `snd_usb_create_mixer()`
  path.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Hardware workaround] Feature-unit GET_CUR during mixer init
hangs the device MCU; skipping AudioControl interface 0 avoids those
control messages. Same pattern as existing M-Audio entries (e.g. Quattro
`QUIRK_DATA_IGNORE(0)` at ~1496).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: VID/PID-scoped; uses macros already in this tree;
  ignore-iface-0 is a long-standing pattern.
- Minimal: one table entry, no API/data-structure change.
- Regression risk: very low — only 0763:2084. Worst case if matching
  were wrong: that one device stays broken (current behavior).
- Companion: patch 1/2 adds `DEVICE_FLG(0x0763, 0x2084,
  QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_DISABLE_AUTOSUSPEND)`. Parse
  still calls `snd_usb_init_sample_rate()` (`stream.c:1255` →
  `set_sample_rate_v1` GET_CUR). Full device function needs both; this
  patch still compiles and is safe alone.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Insertion is after M-Audio Fast Track Ultra 8R `0x2081` (Felix Homann,
  2010, `fca5bca48759c`) and before Casio (2006).
- Buggy path is generic mixer creation, not a recent regression. Class
  match dates to `e5779998bf8b70` (2010).
- Venom has been broken on Linux since USB support was expected; not a
  new-subsystem bug.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. N/A. Bug is device firmware vs generic UAC mixer,
not a specific introducing commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent same-file quirks already in this tree: YAMAHA CDS3000, Novation
  Mininova, RME Digiface, Pioneer DDJ-800, M-Audio Micro, etc.
- This entry is not present (`rg` found no `0x2084` / Venom).
- Series is standalone 2/2: this file vs `quirks.c` flags. No refactor
  prerequisite.
- Macros (`QUIRK_DATA_IGNORE`, `QUIRK_DATA_COMPOSITE`,
  `USB_DEVICE_VENDOR_SPEC`) from `0c3ad39b791c2` / `d79e13f8e8abb`,
  already here.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: No Andrade commits in `sound/` on this tree. First-time ALSA
contributor (cover: “first ever patch”). Weight is the maintainer apply,
not author history.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Code dependency: none. Applies without patch 1/2.
- Functional dependency: patch 1/2 recommended so sample-rate GET_CUR /
  autosuspend do not hang the device. Flags used there
  (`QUIRK_FLAG_GET_SAMPLE_RATE`, `QUIRK_FLAG_DISABLE_AUTOSUSPEND`)
  already exist in `usbaudio.h` on this tree. Nearby mainline context
  uses `QUIRK_FLAG_MIXER_GET_CUR_BROKEN` (not in 6.12) — that is only a
  context line for patch 1, not this patch.
- Can apply standalone: yes.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c` not run: commit is not in this checkout (no SHA to give
  b4).
- Thread via msgid `20260824140211.17003-3-fandrade@frba.utn.edu.ar`:
  - Cover: https://lists.openwall.net/linux-kernel/2026/08/24/1347
  - 1/2 flags: https://lists.openwall.net/linux-kernel/2026/08/24/1354
  - 2/2 this patch: https://lists.openwall.net/linux-
    kernel/2026/08/24/1356
  - v1 cover: https://lists.openwall.net/linux-kernel/2026/08/22/126
- Revisions: v1 (22 Aug) → v2 (23 Aug, extra SOB) → v3 (24 Aug, drop
  duplicate SOB). Diff of this hunk unchanged across versions.
- Takashi Iwai on v3 1/2 (25 Aug 2026): “Applied both patches now.
  Thanks.” (https://lkml.iu.edu/2608.3/02561.html)
- No NAK. v2 comment was only “a single Signed-off-by is enough.”
- No reviewer Cc: stable; hardware quirks are still the documented
  exception.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To/Cc: linux-sound, linux-kernel, perex@perex.cz, tiwai@suse.com
(maintainer, applied), plus unrelated Ccs (kuba, deucher). No extra
Reviewed-by; maintainer apply is the review.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot. Author is the reporter; cover cites years of
“USB useless on Linux.” dmesg + USBPcap + pyusb repro. Severity from
reporter: device never streams.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Two-patch series, both hardware quirks, independent files. This
commit is 2/2 (mixer). 1/2 is the flags entry. Both needed for a working
synth; neither is a code prerequisite of the other.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search for this VID/subject returned no
Venom discussion. Not previously rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function bodies edited. Runtime path uses
`create_composite_quirk`, `ignore_interface_quirk`,
`create_standard_audio_quirk`, `create_any_midi_quirk` (`quirks.c`).

Step 5.2: TRACE CALLERS
Record:
- `usb_audio_ids[]` includes `quirks-table.h` (`card.c:1169–1170`).
- Match → `usb_audio_probe` → `snd_usb_create_quirk` → composite walk.
- Context: USB enumeration / driver probe, not IRQ/hot path.

Step 5.3: TRACE CALLEES
Record: IGNORE: no I/O. STANDARD_AUDIO: `snd_usb_parse_audio_interface`
(may `snd_usb_init_sample_rate`). STANDARD_MIDI:
`snd_usb_midi_v2_create`. No new alloc/lock.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Plug in Venom → snd-usb-audio probe. Userspace not required.
Reachable on any machine with CONFIG_SND_USB_AUDIO and this hardware.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Many `QUIRK_DATA_IGNORE(0)` entries (19+), including other
M-Audio 0x0763 devices. Established, not a new mechanism.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Tree: `p-6.12-3-gc504cf0baa3d8`, `make kernelversion` = 6.12.111.
- Generic mixer/probe path is present (`card.c`, `mixer.c`).
- No Venom / 0x2084 entry (`rg` over `sound/usb`).
- Bug is the generic UAC path vs this firmware, present for many years.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Local `quirks-table.h` 1816–1818 is the same Fast
Track Ultra 8R end / Casio start as the diff. All macros exist. Expected
difficulty: clean apply.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No Venom mixer or flags entry. No alternate fix.
`QUIRK_FLAG_MIXER_GET_CUR_BROKEN` is not in 6.12 (unused by this patch).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [sound/usb / ALSA usb-audio] [IMPORTANT] — common USB audio
stack; this change is one VID/PID.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Active (recent CDS3000/Mininova quirks, resume cleanup). Quirk-
table additions are routine and already land in this 6.12 tree.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific — M-Audio Venom (0763:2084) owners.
CONFIG_SND_USB_AUDIO. No effect on other devices.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Plug in / probe. Certain. Unprivileged user can trigger by
attaching the USB synth. Not a race.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure: MCU hang, ~47s probe, ETIMEDOUT, no PCM/MIDI stream, repeated
  `usb_set_interface` failures.
- Severity: HIGH for those users (device unusable). Not a kernel
  panic/UAF. USB control timeout is 5000 ms (`USB_CTRL_GET_TIMEOUT`);
  many GET_CUR/GET_MIN/GET_MAX calls match the ~47s story.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for Venom owners (first working Linux USB audio/MIDI).
  Matches “hardware quirk” exception. Cover letter: flags alone were not
  enough; this skip is what produced sound.
- Risk: very low (22 lines, one ID, existing macros).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real hardware bug: GET_CUR during mixer init hangs the MCU; no
  streaming.
- Author dmesg, USBPcap, libusb/pyusb, and “works with both quirks.”
- Device never worked on Linux; users have asked for years.
- Small VID/PID table entry; same pattern as other M-Audio quirks
  already in this tree.
- Maintainer Takashi Iwai applied v3.
- All macros and insertion context exist in 6.12.111.
- Hardware quirks / workarounds are an explicit stable exception.
- Does not change APIs or other devices.

AGAINST:
- Part of a 2/2 series; sample-rate + autosuspend flags are also needed
  for a fully working device.
- Niche synth, not a core-path crash.
- First-time contributor (offset by maintainer apply).

UNRESOLVED:
- Could not run `b4 dig -c` (commit not in this repo). Threads recovered
  from msgid/openwall/lkml.
- Did not independently attach a Venom (author + maintainer evidence
  used).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — table-only, existing macros,
   author tested, maintainer applied.
2. Fixes a real bug that affects users? PASS — probe hang and
   silent/broken USB audio.
3. Important issue? PASS — HIGH: device freeze and total loss of
   function (not panic).
4. Small and contained? PASS — +22 lines, one file, one ID.
5. No new features or APIs? PASS — quirk for existing snd-usb-audio.
6. Can apply to the local tree? PASS — clean apply on 6.12.111.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware quirk/workaround (ALSA usb-audio quirk table).
Qualifies on that exception alone.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.12 tree. It is a contained, VID/PID-
scoped workaround that stops mixer GET_CUR from wedging the Venom so the
existing driver can stream. The companion flags patch is a separate two-
line quirk and is not a apply/compile dependency.

What it solves for stable users: without it, plugging in 0763:2084 runs
generic mixer init, burns ~47s of USB timeouts, hangs the MCU, and never
streams. With it, AudioControl is ignored and standard PCM/MIDI
interfaces are used — the path the author verified.

Risk vs benefit: benefit is a working device for Venom owners; risk is
limited to that ID. 6.12 already has the same table style and macros, so
no rework.

Concerns: take the sample-rate/autosuspend flags patch too for full
function; this commit is still correct and safe on its own.

Verification:
- [Phase 1] Parsed subject/tags/body: Skip mixer; SOB Andrade + Iwai;
  msgid 17003-3; no Fixes/stable Cc
- [Phase 1] Cover letter: never worked on Linux; dmesg -110; flags
  insufficient; mixer skip enabled sound
- [Phase 2] Diff: +22 in `sound/usb/quirks-table.h`;
  IGNORE(0)+STANDARD_AUDIO(1,2)+STANDARD_MIDI(3)
- [Phase 2] `card.c` 899–903: generic path creates mixer; quirk return 0
  skips it
- [Phase 2] `mixer.c` `get_min_max_with_quirks` / `init_cur_mix_raw`:
  GET_CUR/GET_MIN/GET_MAX on probe
- [Phase 2] `ignore_interface_quirk` returns 0;
  `create_standard_audio_quirk` parses then returns 0
- [Phase 3] Blame: insert after 0x2081 (2010) / before Casio (2006)
- [Phase 3] `rg` 0x2084/Venom: absent in this tree
- [Phase 3] Macros present (`quirks-table.h` 20–81)
- [Phase 3] No Andrade history in `sound/` here
- [Phase 3] Companion flags: GET_SAMPLE_RATE + DISABLE_AUTOSUSPEND
  exist; MIXER_GET_CUR_BROKEN does not (irrelevant to this hunk)
- [Phase 4] lore/openwall v1–v3; technical diff unchanged; Iwai “Applied
  both patches”
- [Phase 4] v2 feedback: duplicate SOB only
- [Phase 4] stable list: no prior Venom discussion found
- [Phase 4] UNVERIFIED: `b4 dig -c` (no local SHA)
- [Phase 5] Call chain: `usb_audio_ids` → probe →
  `create_composite_quirk`
- [Phase 5] `stream.c:1255` `snd_usb_init_sample_rate` on parse (why
  flags patch also matters)
- [Phase 5] 19+ existing `QUIRK_DATA_IGNORE(0)` including M-Audio
  Quattro
- [Phase 6] `git describe` p-6.12-3-gc504cf0baa3d8; `make kernelversion`
  6.12.111
- [Phase 6] Insertion context matches; clean apply
- [Phase 7] SOUND maintainers Iwai/Kysela; quirk additions already in
  this 6.12 tree
- [Phase 8] Trigger: USB plug-in; timeout 5000 ms; severity HIGH for
  that device
- UNVERIFIED: live Venom reproduce

This is a small, tested hardware quirk for existing snd-usb-audio. It
belongs on this 6.12 tree.

**YES**

 sound/usb/quirks-table.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index d783dae1850a0..061d21da91fbe 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -1814,6 +1814,28 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	/*
+	 * M-Audio Venom
+	 *
+	 * The AudioControl interface times out on every GET_CUR request,
+	 * which adds around 47 seconds to the card registration and
+	 * freezes the device, blocking streaming.
+	 * Using an explicit composite quirk to skip the mixer entirely.
+	 */
+	USB_DEVICE_VENDOR_SPEC(0x0763, 0x2084),
+	QUIRK_DRIVER_INFO {
+		.vendor_name = "M-Audio",
+		.product_name = "Venom",
+		QUIRK_DATA_COMPOSITE {
+			{ QUIRK_DATA_IGNORE(0) },
+			{ QUIRK_DATA_STANDARD_AUDIO(1) },
+			{ QUIRK_DATA_STANDARD_AUDIO(2) },
+			{ QUIRK_DATA_STANDARD_MIDI(3) },
+			QUIRK_COMPOSITE_END
+		}
+	}
+},
 
 /* Casio devices */
 {
-- 
2.53.0

