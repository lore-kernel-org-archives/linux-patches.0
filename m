Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521325DD54F;
	Mon, 19 Oct 2026 14:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418533; cv=none; b=Rl7qFAX2yJ3i9e6j0yaRNC/6vKfaVP+LFlMuElMgrZ4JUi46qBpYDdwjToBg7vaSdaI+LHPShf6lAzAOG1u+XswPSMnSw54xjcBuFWWsmIp0d/2T/083Q60Bq3jfGOpfD6mkQaBjoHY495kPALD/4J3IqC778ubMhRAosdcUD30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418533; c=relaxed/simple;
	bh=dxMTzlf/7ads2KRefFkWIrQo4r+OoK8UUzVnXWVncHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nbcgsBFKXUaI54I1C3kkpzmJd+4cUOWwzfP52K9br6teGNMN3milZ89dxSk3WXTRhS6qY4HqKKpKSoo/XIVcm++acUtuWPIAiPpscL5gyV2Ftx8UwnXw/rlkwW8Vd3Hu4nWVMDoglDUHtc1n4A3iiKjixdP010axR/zvyaHhF30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g3Hj8G6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g3Hj8G6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4DB1F000C8;
	Mon, 19 Oct 2026 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418530;
	bh=/YsfFDAkMlCm00h3PNsmQrtiYwc9YWb6hLAHoW/doR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3Hj8G6t1zPawCFOrjuNiD9sxKGflkKH/8ex6sYyxqL1TtEkcJSYEXuwqzx/Xnn9u
	 vFiIjntSFz+zoDPy+4y24MgiIbjYWh3trj0mBHjaKqRC31CSE75d1WhIzZU7Sm1/2L
	 GK7zqIAMYwz5PNNGwKsiGiJjGa6TSAljy9XOeaxMmGBJPHggm/wNZutiPId8I48/PZ
	 5LCAUOv+Km72xNv7iFYNGFAj3NkAYtOm+wdfKjg4yEQzTynaQR3rvsm1Oi+yxPJnSd
	 h2/aV2aUlc9u09DKacPyjJpJd7lMMq+jmZsmsYryILvyf2HzW6vjVKCOVImmCP+CXb
	 28K0SaGGHv3GA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hernan Ganzo <gp@sneemgp.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/realtek: Limit internal mic boost on HP Pavilion 15 (103c:2164)
Date: Mon, 19 Oct 2026 09:50:04 -0400
Message-ID: <20261019135441.1420968-313-sashal@kernel.org>
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

From: Hernan Ganzo <gp@sneemgp.com>

[ Upstream commit 786fb6b3f513937f712db5a9ba6a12cbc6982ba9 ]

The HP Pavilion 15 with the ALC3227 codec (SSID 103c:2164) exposes the full
four-step internal mic boost on pin 0x12: nsteps=3 with stepsize=0x2f, that is
0, 12, 24 and 36 dB. Combined with the ADC capture gain of +30 dB the analogue
cascade reaches 66 dB, and the internal microphone clips on the ambient noise of
a quiet room; the upper two steps are unusable at any useful input level. This
is the defect class ALC269_FIXUP_LIMIT_INT_MIC_BOOST exists for.

The machine matches no SSID quirk and falls through to the pin table, which
selects ALC269_FIXUP_HP_MUTE_LED_MIC1 through a pin signature shared with
several other HP models. Add an SSID entry instead, using
ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED: the existing fixup that applies
alc269_fixup_limit_int_mic_boost() and chains to the same mute LED fixup, as
already done for 103c:218b. The boost becomes 0 or 12 dB and the LED handling is
unchanged.

Tested on the affected machine by selecting the same fixup through the model
string (snd-hda-intel.model), which bypasses the SSID and pin tables, with the
driver confirming the selection:

  snd_hda_codec_alc269 hdaudioC1D0: ALC3227: picked fixup limit-mic-boost (model specified)

With that, Internal Mic Boost reports Limits 0 - 1 (0 or 12 dB) instead of 0 - 3
(0 to 36 dB), so alc269_fixup_limit_int_mic_boost() clamps this codec's internal
mic pin as intended. Note that /proc/asound/card1/codec#0 keeps printing the
unclamped hardware caps (nsteps=0x03): that file reads codec parameters uncached
by design, while the fixup overrides the driver's cached parameter that the
control is built from.

This does not by itself make the default capture volume sane -- the remaining
12 dB on top of the +30 dB ADC gain is still hotter than this machine's usable
operating point. It removes the two unusable steps from the hardware range, which
is what a quirk of this class can do.

Signed-off-by: Hernan Ganzo <gp@sneemgp.com>
Link: https://patch.msgid.link/20260921205538.41192-1-gp@sneemgp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ALSA: hda/realtek] [Limit] [Add an SSID quirk so the HP
Pavilion 15 (103c:2164) uses the existing internal-mic boost limiter
plus mute-LED chain]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Link: https://patch.msgid.link/20260921205538.41192-1-gp@sneemgp.com
- Signed-off-by: Hernan Ganzo <gp@sneemgp.com> (author)
- Signed-off-by: Takashi Iwai <tiwai@suse.de> (ALSA maintainer)
- Signed-off-by: Sasha Levin — ignored per instructions
- `[ Upstream commit 786fb6b3f513937f712db5a9ba6a12cbc6982ba9 ]` —
  ignored per instructions
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence expected)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: HP Pavilion 15 ALC3227 (SSID 103c:2164) exposes a four-step
  internal mic boost (0/12/24/36 dB) on pin 0x12. With ADC capture gain
  of +30 dB the analogue cascade is 66 dB; the mic clips on quiet-room
  ambient noise. The top two steps are unusable.
- Symptom: Distorted/clipped internal-mic capture; Internal Mic Boost
  reports Limits 0–3.
- Root cause: No SSID quirk, so the machine falls through to the pin
  table and gets only `ALC269_FIXUP_HP_MUTE_LED_MIC1` (mute LED, no
  boost clamp). This is the class `ALC269_FIXUP_LIMIT_INT_MIC_BOOST`
  exists for.
- Fix: Add SSID 103c:2164 using existing
  `ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED` (same as 103c:218b): clamp
  boost to 0 or 12 dB, keep mute LED.
- Tested on the affected machine via `snd-hda-intel.model=limit-mic-
  boost`; driver log confirmed the pick; mixer Limits became 0–1.
- Author notes the remaining 12 dB + 30 dB ADC is still hotter than
  ideal; the quirk only removes the two unusable steps.
- No kernel-version range given.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit hardware quirk: one
`SND_PCI_QUIRK` for a known broken boost range.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `sound/hda/codecs/realtek/alc269.c` (+1 / −0)
- Function/table: `alc269_fixup_tbl[]` only
- Scope: single-file, one-line table insertion

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: PCI SSID 103c:2164 is absent from `alc269_fixup_tbl`.
  `snd_hda_pick_fixup()` does not match; `snd_hda_pick_pin_fixup()` then
  selects `ALC269_FIXUP_HP_MUTE_LED_MIC1` for a shared HP pin signature.
- After: SSID matches `ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED`. That
  fixup runs `alc269_fixup_limit_int_mic_boost()` and chains to
  `ALC269_FIXUP_HP_MUTE_LED_MIC1`.
- Path: codec probe / fixup selection. Other SSIDs unchanged.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: hardware workaround (quirk / device-ID table entry)
- Mechanism: hardware advertises nsteps=3, stepsize=0x2f.
  `alc269_fixup_limit_int_mic_boost()` calls
  `snd_hda_override_amp_caps()` on internal-mic pins so NUM_STEPS
  becomes 1 (0 or 12 dB). Without the SSID, that override never runs.

Verified in this tree (`alc269.c`):

```2371:2391:sound/hda/codecs/realtek/alc269.c
        /* The mic boosts on level 2 and 3 are too noisy
           on the internal mic input.
           Therefore limit the boost to 0 or 1. */
        ...
                snd_hda_override_amp_caps(codec, nid, HDA_INPUT,
                                          (0x00 <<
AC_AMPCAP_OFFSET_SHIFT) |
                                          (0x01 <<
AC_AMPCAP_NUM_STEPS_SHIFT) |
                                          (0x2f <<
AC_AMPCAP_STEP_SIZE_SHIFT) |
                                          (0 << AC_AMPCAP_MUTE_SHIFT));
```

Chained fixup verified:

```4511:4516:sound/hda/codecs/realtek/alc269.c
        [ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED] = {
                .type = HDA_FIXUP_FUNC,
                .v.func = alc269_fixup_limit_int_mic_boost,
                .chained = true,
                .chain_id = ALC269_FIXUP_HP_MUTE_LED_MIC1,
        },
```

SSID lookup runs first; pin match is skipped once `fixup_id` is set
(`snd_hda_pick_pin_fixup()` returns immediately if `codec->fixup_id !=
HDA_FIXUP_ID_NOT_SET`).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: reuses a 2013 combined boost+LED fixup already used
  for 103c:218b.
- Minimal: one sorted table line; no API, no new fixup enum.
- Regression risk: very low. Only SSID 103c:2164 is affected. Mute LED
  is the same chain the pin table already applied. Boost clamp only
  touches internal-mic amp caps at probe.
- Caveat (verified): on-machine testing used model string `limit-mic-
  boost` (`ALC269_FIXUP_LIMIT_INT_MIC_BOOST`, which chains ThinkPad
  ACPI, not HP mute LED). That proves the clamp works on this codec;
  SSID selection of the MUTE_LED variant is by construction (same boost
  function + same LED chain as the pin table).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Insertion sits between 103c:18e6 (`ALC269_FIXUP_HP_GPIO_LED`) and
  103c:218b (`ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED`).
- Combined fixup and 103c:218b come from `8e35cd4ac9967` (“ALSA: HDA -
  Limit mic boost and add mute LED for an HP machine”, 2013-11-06, David
  Henningsson / Takashi Iwai). That commit exists in this tree (`git
  merge-base --is-ancestor 8e35cd4ac9967 HEAD` → 0).
- Boost-limit helper has been in the Realtek HDA driver since that era;
  file later moved (`6014e9021b28e`) and split (`aeeb85f26c3bb`).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. The “bug” is a missing per-board
quirk, not a regression from a later commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `alc269.c` history is other per-machine quirks (HP mute
LEDs, ASUS speakers, Star Labs mic boost). Same class of standalone
entries. No prerequisite refactor needed for this one line.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Only this Realtek HDA commit from Hernan Ganzo in this tree.
Signed off by Takashi Iwai, who maintains ALSA HDA and routinely merges
these quirk lines.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Standalone. Depends only on
`ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED`,
`alc269_fixup_limit_int_mic_boost()`, and `alc269_fixup_tbl[]`, all
present on v6.18.57. Neighboring 103c:18e6 / 103c:218b lines match the
hunk context, so it applies cleanly to this series.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 786fb6b3f513937f712db5a9ba6a12cbc6982ba9` →
  https://patch.msgid.link/20260921205538.41192-1-gp@sneemgp.com
- `b4 dig -a`: single v1 series, 2026-09-21, Hernan Ganzo. No v2/v3.
- Thread (via `b4 mbox`): author patch + Takashi Iwai reply 2026-09-28:
  “Applied now. Thanks.” No NAK, no requested changes, no stable
  discussion in-thread.
- lore WebFetch returned 403; thread recovered with b4 instead.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc linux-sound@vger.kernel.org, tiwai@suse.com,
perex@perex.cz. Subsystem maintainer applied it. No other reviewers.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot/Launchpad link on this patch. Evidence is the
author’s on-machine test (kmsg + mixer Limits). The 2013 sibling quirk
103c:218b had Launchpad 1248476 (same defect class: noisy internal mic +
mute LED).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone, not part of a multi-patch series. Same table already
has many `ALC269_FIXUP_LIMIT_INT_MIC_BOOST*` entries (ThinkPad, ASUS,
Positivo, VAIO, Star Labs). `56b321df2863d` “Limit Star Labs internal
mic boost” is already in v6.18.57.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED. `https://lore.kernel.org/stable/?q=...` returned
403. No evidence in the sound thread that stable was discussed or
rejected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body changed. Data only: `alc269_fixup_tbl[]`.
Runtime path: `snd_hda_pick_fixup()` → `snd_hda_apply_fixup()` →
`alc269_fixup_limit_int_mic_boost()` +
`alc269_fixup_hp_mute_led_mic1()`.

Step 5.2: TRACE CALLERS
Record:
- `alc269` probe (`alc269.c` ~8557) calls `snd_hda_pick_fixup(codec,
  alc269_fixup_models, alc269_fixup_tbl, alc269_fixups)`.
- Then pin-table pick, which is a no-op once SSID matched.
- Probe/init path only, not IRQ or syscall hot path.

Step 5.3: TRACE CALLEES
Record: `alc269_fixup_limit_int_mic_boost()` uses
`snd_hda_codec_get_pincfg()`, `snd_hda_get_input_pin_attr()`,
`snd_hda_override_amp_caps()`. Mute LED helper registers LED cdev /
power filter. All already used by other HP SSIDs.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable when this laptop enumerates HDA (boot / resume /
module load). Not a userspace-exploit path; userspace mixer sees a
smaller boost range. Unprivileged users benefit because capture is
usable without a model= module option.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same table already maps 103c:218b to this exact fixup. Many
other boards use `ALC269_FIXUP_LIMIT_INT_MIC_BOOST`. Systematic, well-
worn pattern.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: `v6.18.57-155-gcdf239ca885b2`, `make kernelversion` =
  6.18.57.
- Baseline v6.18.57: `sound/hda/codecs/realtek/alc269.c` exists;
  `ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED` exists; 103c:218b exists;
  **103c:2164 does not**.
- Without the line, this HP falls through to the pin table
  (`ALC269_FIXUP_HP_MUTE_LED_MIC1` entries for codec 0x10ec0282 / vendor
  0x103c are present). ALC3227 is the HP OEM name for 0x10ec0282
  (`realtek.c`: `{ 0x10ec0282, 0x103c, 0, "ALC3227" }`).
- Hardware defect is as old as the machine; software has never limited
  this SSID.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. v6.18.57 context is identical to the hunk (`0x18e6`
then `0x218b`). File path is already `sound/hda/codecs/realtek/alc269.c`
on 6.18.y (move/split already landed).

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other 103c:2164 quirk. Sibling boost+LED fixup and Star Labs
boost limit are already in v6.18.57. This SSID is the missing piece.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: ALSA HD-audio Realtek codec (`sound/hda/codecs/realtek/`).
IMPORTANT for laptop audio, not core mm/fs. Still a long-lived
production driver.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: High activity: frequent one-line `SND_PCI_QUIRK` additions,
routinely taken by Iwai. Mature quirk table; this is not new-subsystem
code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / SSID-specific. Only HP Pavilion 15 with PCI
SSID 103c:2164 (ALC3227). Other machines unchanged.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Always on that hardware: every probe, default mixer range
includes 24/36 dB boost. No race. An unprivileged user using the
internal mic hits it. Workaround today is `snd-hda-intel.model=limit-
mic-boost`.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Internal microphone clips / is unusable at the two highest boost
steps (and noisy even at ambient). Not oops/deadlock/corruption.
Severity: MEDIUM for that machine, but it is a documented hardware quirk
class that stable-kernel-rules explicitly include.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for owners of this SKU (usable capture range without a
  module option); zero for everyone else.
- Risk: very low (1 line, SSID-gated, existing fixup, maintainer-
  applied, tested).
- Ratio: strongly favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- One-line PCI/SSID quirk on an existing driver — stable-kernel-rules:
  “fix a real bug that bothers people or just add a device ID”;
  “hardware quirk” is listed as in-scope.
- Real user-visible defect: 66 dB analogue cascade, clipping on quiet-
  room noise; author tested on the machine.
- Reuses `ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED` already in 6.18.y
  (103c:218b since 2013).
- Mute LED preserved via chain to the same pin-table fixup.
- Applies cleanly to v6.18.57; no new APIs; ALSA maintainer applied v1
  with no objections.
- Same class as other boost-limit quirks already in this tree (e.g. Star
  Labs).

AGAINST:
- Not a crash/security/data-corruption fix; one laptop SKU.
- Author says remaining 12 dB + 30 dB ADC is still hotter than ideal
  (partial mitigation by design of this quirk class).
- Model-string test used `limit-mic-boost`, not the MUTE_LED SSID id
  (boost path still verified on hardware).

UNRESOLVED:
- Stable mailing-list search blocked (HTTP 403).
- lore WebFetch 403; discussion recovered via b4 mbox.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — one table line, existing fixup,
   on-machine test, maintainer “Applied now.”
2. Fixes a real bug that affects users? PASS — unusable internal-mic
   boost steps on this HP.
3. Important issue? PASS as hardware quirk (explicitly allowed); not
   CRITICAL crash.
4. Small and contained? PASS — +1 line, one file.
5. No new features or APIs? PASS — existing fixup ID only.
6. Can apply to the local tree? PASS — v6.18.57 has the file, fixup, and
   identical hunk context; 103c:2164 is missing on the 6.18.57 baseline.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware quirk / device-ID addition to an existing driver.
Automatic stable-qualifier.

Step 9.4: MAKE YOUR DECISION
This is a textbook stable HDA quirk: SSID-matched, one line, existing
helper, real capture breakage on a shipping laptop, clean apply on
6.18.y. Include it.

What it solves for stable users: on HP Pavilion 15 103c:2164, Internal
Mic Boost is clamped to 0/12 dB instead of 0–36 dB, so the mic no longer
clips at the two hardware steps that this codec cannot use. Mute LED
behavior stays the pin-table path.

Risk vs benefit: benefit is localized and real; risk is confined to that
SSID and the helper has been in-tree for years.

Verification:
- [Phase 1] Parsed tags: Link msgid, SOB Ganzo + Iwai; no
  Fixes/Reported-by/Cc-stable
- [Phase 1] Body: 66 dB cascade, pin-table fallback to HP_MUTE_LED_MIC1,
  reuse of LIMIT_INT_MIC_BOOST_MUTE_LED
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x103c, 0x2164, ...
  LIMIT_INT_MIC_BOOST_MUTE_LED)` in `alc269_fixup_tbl`
- [Phase 2] Read `alc269_fixup_limit_int_mic_boost()` and chained fixup
  in this tree
- [Phase 2] Read `snd_hda_pick_fixup()` / `snd_hda_pick_pin_fixup()`:
  SSID wins over pin table
- [Phase 3] `git blame` around insertion; `git show 8e35cd4ac9967` (2013
  218b/combined fixup); ancestor of HEAD
- [Phase 3] `git log -S 'ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED'`
  traces to 8e35cd4ac9967 via file moves
- [Phase 3] Author history: only this Realtek commit in-tree
- [Phase 4] `b4 dig -c 786fb6b3...`: lore URL; `-a` v1 only; `-w` linux-
  sound/tiwai/perex
- [Phase 4] `b4 mbox`: Iwai “Applied now. Thanks.”; no NAK
- [Phase 4] UNVERIFIED: lore WebFetch 403; stable list 403
- [Phase 5] Callers: alc269 probe → pick_fixup; clamp at
  HDA_FIXUP_ACT_PROBE
- [Phase 5] ALC3227 = 0x10ec0282 + HP 0x103c in `realtek.c`
- [Phase 6] `git describe HEAD` = v6.18.57-155-gcdf239ca885b2; `make
  kernelversion` = 6.18.57
- [Phase 6] `git grep 0x2164 v6.18.57 -- alc269.c`: absent; fixup and
  218b present
- [Phase 6] Context at v6.18.57 matches the hunk (18e6 then 218b)
- [Phase 6] Star Labs boost-limit `56b321df2863d` is ancestor of
  v6.18.57
- [Phase 7] ALSA HDA Realtek; quirk table still actively extended
- [Phase 8] Failure mode: clipped/unusable internal mic on one SSID;
  severity MEDIUM; hardware-quirk exception
- [Phase 9] `Documentation/process/stable-kernel-rules.rst` lines 15–20:
  device ID / hardware quirk allowed

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index bc87062f86da7..10d930d8fed72 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6707,6 +6707,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x18e6, "HP", ALC269_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x2164, "HP Pavilion 15 Notebook PC", ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x218b, "HP", ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x21f9, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2210, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
-- 
2.53.0

