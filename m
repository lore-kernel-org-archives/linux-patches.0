Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65655501F39;
	Mon, 19 Oct 2026 13:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418163; cv=none; b=FLpGaERp5zDEc5HH/HllWzk6h/609nz9+M87nyznH/drT5CI4hQHSyv1FzKtS17x1Cmlsj1o7dBn3hjZM7QnCft+C5aLiswD0rC8OJ1AJ/18z7XaomJ+sAzCTK3tYgCl81Uv8OLMbEbY/Vkn8UuSXycABJGrAjJc2enX7V7Juyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418163; c=relaxed/simple;
	bh=4JlpX1bdi9w0cyXMHNlCCzcvZ1TTeVnNXMigX81LVpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=toGiCjgC6lWOb1asAkzdqnUz9pBydMhc62CvxtsDGhgz1Riox+SGZpea6Rjwat4U/rBXhfzrF6kF4VdEAuqQtPH7pIL5Na4EtFOw5xeCyof9fHa3LyO+RQYHvckGGLzW56uQ5/dzTU1HKbp30QXqES5ZPyEDFFZHxKy9xxQ0tA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PmcLiLY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PmcLiLY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86A51F000C8;
	Mon, 19 Oct 2026 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418160;
	bh=dxLpyMlBmuDKRoUAE5QCl/yjwfCLvwlmCgkhNXBTigM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmcLiLY9KKx7nZ4NVDGrwz1rGyZvY9fFpsbc1WPplNJVKYjLL+KWc8iDAYryui18V
	 RLLz/jZLxrhe5Onz7cMvMYwQa1i/dlACdTIkllrN9XDDiwM19TrtMQodSWABvkqhaR
	 2eSXhFIGTaa1PRBHGjonzpAHKoZO10fVbSj8Ga8oCOn3bluLs8Gfpr7SB37Cb92VM8
	 U0lyXtztScvdxVUM1IXu50RnAsKtvDVeUAPdN5EYNgklCkk4b/LDk4xF81mtZFiXG/
	 Xg6m7nNPrrtJzYrK1ONKsY4NPmRE/n+I3hLXlT2RAyC4W1t7/viBmmx/SuLYuQtX6b
	 ZZFrqwDfsFUuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jasper Firth <jasper.m.f@hotmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cezary.rojewski@intel.com,
	liam.r.girdwood@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	yung-chuan.liao@linux.intel.com,
	kai.vehmanen@linux.intel.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: Intel: bytcr_rt5651: Add quirk for Chuwi Hi8 with generic DMI strings
Date: Mon, 19 Oct 2026 09:45:45 -0400
Message-ID: <20261019135441.1420968-54-sashal@kernel.org>
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

From: Jasper Firth <jasper.m.f@hotmail.com>

[ Upstream commit c5a8fc2abe05cf6db71f57ff0177fddc59861a1a ]

Some Chuwi Hi8 tablets with model number CWI513 ship with a BIOS
(American Megatrends 5.11, dated 05/21/2016) whose DMI sys_vendor and
product_name are both "Default string". The tested unit is labelled
just "Hi8", but its model number is the same as the existing "Chuwi Hi8
Pro (CWI513)" entry, and it needs the same quirks. That entry matches on
sys_vendor "Hampoo" and product_name "X1D3_C806N", so it never applies
to these units.

Without its quirks the internal speaker, whose amplifier has a
differential input wired across LOUT left and right, cancels to a faint
distorted residual for any centred (L == R) content, and the headphone
channels are swapped.

Add an entry matching board_vendor "Hampoo" and board_name "Cherry Trail
CR", plus the BIOS date since those two are too generic on their own.
drivers/platform/x86/touchscreen_dmi.c already matches the Chuwi HiBook
the same way.

The quirks are those of the existing Hi8 Pro entry, except for the
over-current detection scale factor: 1.0 instead of the 0.75 from
BYT_RT5651_DEFAULT_QUIRKS. With 0.75 and a CTIA headset (inline mic and
one button), loud speech into the mic, and headphone playback coupling
onto the mic line, were reported as spurious KEY_PLAYPAUSE presses, one
of them held for a whole 8 second speech window. With 1.0 the same test
gave no spurious events, and 3 real button presses were reported as
exactly 3 press/release pairs.

Tested on a unit with the generic DMI strings, with a module built from
this patch and no quirk module parameter. The quirks were applied via
the new entry, the card components read "cfg-spk:1 cfg-mic:in2
cfg-hp:lrswap", and the following all work: speaker, headphone left/right
order, jack and headset-mic detection, headset button, and the internal
and headset mics.

The problem was diagnosed with the help of an AI coding assistant, which
also drafted this changelog.

Assisted-by: Claude Opus 5.5
Signed-off-by: Jasper Firth <jasper.m.f@hotmail.com>
Link: https://patch.msgid.link/20260925-hi8-quirk-v1-1-ffd00b0447f9@hotmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a DMI hardware quirk for a tablet whose
audio is already broken without it, and the surrounding driver code is
present in this 6.18 tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ASoC/Intel/bytcr_rt5651] [Add] [DMI quirk so Chuwi Hi8 units
with generic BIOS strings get the existing audio workarounds]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Assisted-by: Claude Opus 5.5
- Signed-off-by: Jasper Firth \<jasper.m.f@hotmail.com\> (author)
- Link: https://patch.msgid.link/20260925-hi8-quirk-v1-1-
  ffd00b0447f9@hotmail.com
- Signed-off-by: Mark Brown \<broonie@kernel.org\> (ASoC maintainer)
- No Fixes: tag (expected)
- No Reported-by / Tested-by / Reviewed-by / Acked-by
- No Cc: stable@vger.kernel.org (expected; not a negative)
- Ignore pipeline-added "[Upstream commit ...]" and Sasha Levin SOB

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: Some Chuwi Hi8 CWI513 tablets ship AMI BIOS 5.11 dated 05/21/2016
  with DMI sys_vendor and product_name both "Default string". The
  existing "Chuwi Hi8 Pro (CWI513)" entry matches sys_vendor "Hampoo" +
  product_name "X1D3_C806N" and never applies.
- Symptom: internal speaker (differential amp across LOUT L/R) cancels
  to a faint distorted residual for centred (L==R) content; headphone
  L/R swapped. With default OVCD scale 0.75, loud speech into a CTIA
  headset mic produced spurious KEY_PLAYPAUSE events (one held for an 8s
  window).
- Root cause: missing DMI match, so DEFAULT_QUIRKS (stereo path, SF
  0.75) are used on hardware that needs mono-speaker mix, HP swap, and
  OVCD SF 1.0.
- Version info: hardware/BIOS from 2016; no kernel-version restriction
  stated.
- Author tested on a real unit without the quirk module parameter; card
  components became "cfg-spk:1 cfg-mic:in2 cfg-hp:lrswap"; speaker, HP
  order, jack/headset-mic, button, and both mics worked.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit hardware-quirk
addition. The "add" verb here is the standard form for DMI/quirk table
entries that fix broken hardware, not a new feature.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- Files: sound/soc/intel/boards/bytcr_rt5651.c only (+17 / -0)
- Functions: none modified; one new `dmi_system_id` entry in
  `byt_rt5651_quirk_table[]`
- Scope: single-file surgical table addition

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: `dmi_check_system(byt_rt5651_quirk_table)` in
  `snd_byt_rt5651_mc_probe()` never matches these units, so
  `byt_rt5651_quirk` stays `BYT_RT5651_DEFAULT_QUIRKS |
  BYT_RT5651_IN2_MAP`.
- After: units with board_vendor "Hampoo", board_name "Cherry Trail CR",
  and BIOS date "05/21/2016" set:
  MCLK_EN | JD1_1 | OVCD_TH_2000UA | OVCD_SF_1P0 | IN2_MAP |
  HP_LR_SWAPPED | MONO_SPEAKER
- That is the existing Hi8 Pro quirk set with OVCD scale 1.0 instead of
  DEFAULT_QUIRKS' 0.75.
- Path: machine-driver probe / initialization only. Callback
  `byt_rt5651_quirk_cb` still just stores `driver_data` and returns 1.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: (h) hardware workaround / DMI quirk table entry
- Mechanism: without MONO_SPEAKER the stereo DAC feeds a differential
  mono amp and centred audio cancels (this is the same failure Hans de
  Goede documented in `a0d1d867c262f`, "Add mono speaker quirk").
  Without HP_LR_SWAPPED, headphone channels are reversed. OVCD_SF_1P0
  raises the headset-button over-current scale so coupled mic audio is
  not reported as KEY_PLAYPAUSE.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: additive table entry using the same callback and
  flag bits already used by the Hi8 Pro / Vi8 Plus entries.
- Match is deliberately narrowed with BIOS date after the author noted
  board_vendor+board_name are too generic; same comment/pattern as Chuwi
  HiBook in `drivers/platform/x86/touchscreen_dmi.c`.
- `dmi_check_system()` stops on first callback returning non-zero.
  Existing Hi8 Pro entry is earlier in the table, so units with proper
  "Hampoo"/"X1D3_C806N" strings keep the old flags.
- Residual risk: another Hampoo "Cherry Trail CR" board with BIOS date
  05/21/2016 and the RT5651 machine driver could get mono/HP-swap
  incorrectly. BIOS date plus first-match-wins makes that small. No
  locking/API/data-structure changes.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Quirk table exists since Pierre-Louis Bossart, 2016
  (`2bd5bd15a51858`).
- Existing "Chuwi Hi8 Pro (CWI513)" match (Hampoo / X1D3_C806N) from
  Hans de Goede, 2018 (`55d69c0309acea` / `8f250e7009d71`).
- MONO_SPEAKER + HP_LR_SWAPPED on that entry from 2018
  (`a0d1d867c262f4`).
- The buggy situation is long-standing: these generic-DMI units have
  never matched. Introduced with the 2016 BIOS, not by a recent kernel
  change.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. The "bug" is missing DMI
coverage, not a regression from a tagged commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent file history is unrelated (DAPM idle_bias, invalid quirk
  mapping, DPCM flags, remove() conversion).
- Original Hi8 Pro/Vi8 Plus DMI entries and all flag macros are already
  in this tree.
- Standalone; not patch X/Y.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Only this commit by Jasper Firth under
`sound/soc/intel/boards/`. Not a subsystem maintainer. Hans de Goede
(historical author of these Chuwi entries) and Intel ASoC maintainers
were on the original To/Cc. Mark Brown applied it the same day.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No extra commits needed. `BYT_RT5651_MCLK_EN`, `JD1_1`,
`OVCD_TH_2000UA`, `OVCD_SF_1P0`, `IN2_MAP`, `HP_LR_SWAPPED`,
`MONO_SPEAKER`, `byt_rt5651_quirk_cb`, and
`dmi_check_system(byt_rt5651_quirk_table)` all exist in v6.18.57. Can
apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- b4 dig -c c5a8fc2abe05cf6db71f57ff0177fddc59861a1a matched https://pat
  ch.msgid.link/20260925-hi8-quirk-v1-1-ffd00b0447f9@hotmail.com
- b4 dig -a: v1 only (2026-09-25)
- Thread has two messages: submission and Mark Brown "Applied to
  broonie/sound.git for-7.3"
- No NAKs, no requested revisions, no reviewer Cc: stable
- Author note (not in the final commit body): left the existing Hi8 Pro
  entry unchanged because they do not have an X1D3_C806N unit; that
  model may still see OVCD_SF_0P75 spurious buttons. This patch does not
  change that entry.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (b4 dig -w): linux-sound, linux-kernel, Mark Brown, Takashi Iwai,
Jaroslav Kysela, Hans de Goede, Pierre-Louis Bossart, Liam Girdwood,
Cezary Rojewski, Bard Liao, Kai Vehmanen, Peter Ujfalusi. Subsystem
maintainer applied it. No extra Reviewed-by.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla link. Evidence is the author's hardware test
in the changelog (speaker cancellation, swapped HP, spurious
KEY_PLAYPAUSE, and post-fix verification).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Single standalone patch, change-id
20260925-hi8-quirk-00ca3a49b32f. No series dependencies.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: Web search of lore.kernel.org/stable for this subject/file found
no discussion of this quirk. Nobody requested or rejected it for stable
in a thread I could verify.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function bodies changed. Data consumed by
`byt_rt5651_quirk_cb()` and `snd_byt_rt5651_mc_probe()`.

Step 5.2: TRACE CALLERS
Record:
- `byt_rt5651_quirk_cb` is only used as `.callback` in this DMI table.
- `dmi_check_system(byt_rt5651_quirk_table)` is called once from
  `snd_byt_rt5651_mc_probe()` (line 1024).
- That probe is the platform driver `bytcr_rt5651`
  (`MODULE_ALIAS("platform:bytcr_rt5651")`).
- Context: device probe, not IRQ/hot path. Userspace cannot call it
  directly; it runs when this Bay Trail / Cherry Trail RT5651 machine
  driver binds.

Step 5.3: TRACE CALLEES
Record: Callback only assigns `byt_rt5651_quirk`. Probe later uses those
bits for codec device properties, card `components` (`cfg-spk:1`, `cfg-
hp:lrswap`), long_name, and jack OVCD settings. No new allocations or
locks.

Step 5.4: FOLLOW THE CALL CHAIN
Record: ACPI/platform match → `snd_byt_rt5651_mc_probe` →
`dmi_check_system` → quirk flags → ALSA card registration / UCM profile
selection. Reachable on this tablet at every boot if
`CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH` is enabled (recommended in
Kconfig for such devices). Not a syscall-triggered crash path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same Hampoo + "Cherry Trail CR" + BIOS-date pattern already used
for Chuwi HiBook in `touchscreen_dmi.c` (BIOS date 05/07/2016, different
from 05/21/2016). Sibling Hi8 Pro / Vi8 Plus audio entries already exist
in this same table. VIOS LTH17 already uses `BYT_RT5651_OVCD_SF_1P0`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: `git describe HEAD` = v6.18.57-155-gcdf239ca885b2; `make
  kernelversion` = 6.18.57.
- File and quirk table exist at v6.18.57. Existing Hi8 Pro entry is
  present; generic-DMI units still miss it.
- Bug is missing coverage, present for as long as this driver has been
  used on these 2016 tablets.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Against v6.18.57 the hunk applied with a 1-line offset (`Hunk #1
succeeded at 409`). Context around the Hi8 Pro entry is identical.
Expected difficulty: clean apply / trivial offset. All flag macros exist
unchanged.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `git log v6.18..v6.18.57 --
sound/soc/intel/boards/bytcr_rt5651.c` is empty; 6.18.y has not already
taken a different fix for this. No "generic DMI" match exists without
this entry. Existing Hi8 Pro match does not cover "Default string"
vendor/product.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [sound/soc/intel/boards – Intel Baytrail/Cherry Trail ASoC
machine driver] [PERIPHERAL / driver-specific, but a supported in-tree
board driver, not staging]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature. Quirk table dates to 2016–2018; recent commits are small
maintenance. This is a late hardware-coverage add, not a rewrite of new
code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / DMI-specific. Only Chuwi Hi8 CWI513-class
units with board_vendor Hampoo, board_name "Cherry Trail CR", BIOS date
05/21/2016, using this RT5651 machine driver. Other users are unchanged
unless they share that exact triple (unverified but constrained).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every probe/boot on matching hardware. No race. Unprivileged
users do not trigger a kernel bug; they just get broken audio / spurious
KEY_PLAYPAUSE until the quirk is applied.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure: internal speaker effectively unusable for typical centred
  content; swapped headphones; false headset-button events.
- Severity: MEDIUM for the affected device (real functional break, not a
  panic). Not CRITICAL in the crash/corruption sense, but it is the
  class of hardware-quirk issue stable trees routinely take.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for owners of this tablet (speaker/headphones/jack
  actually work); zero for everyone else if the DMI triple is unique.
- Risk: very low — 17-line table add, existing flags, probe-time only,
  first-match preserves the older Hi8 Pro entry.
- Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real hardware bug: differential mono speaker cancellation, swapped HP,
  spurious KEY_PLAYPAUSE
- Author tested on the affected unit; quirks applied without module-
  parameter override
- Textbook stable exception: DMI/hardware quirk on an existing driver
- Small (+17), contained, no new API
- All consumed flags and the table hook exist in this 6.18.57 tree
- Applies with a trivial offset
- Same matching strategy already used for Chuwi HiBook
- ASoC maintainer applied v1 the same day; Intel ASoC and Hans de Goede
  were CC'd
- Existing more-specific Hi8 Pro entry remains first and still wins for
  X1D3_C806N units

AGAINST:
- Niche 2016 tablet, one reporter/tester
- Not a crash, security hole, or data-corruption bug
- Theoretical false match on another Hampoo Cherry Trail CR board with
  the same BIOS date
- No Fixes:/Cc: stable; Mark Brown queued it for the 7.3 merge window
  rather than as an urgent fix

UNRESOLVED:
- Could not fetch lore.kernel.org HTML (403); thread reconstructed via
  b4 dig + Patchew + LKML archive
- Could not prove no other product shares Hampoo + "Cherry Trail CR" +
  BIOS 05/21/2016
- No stable-list thread found

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — additive DMI entry, author
   hardware test, maintainer applied
2. Fixes a real bug that affects users? PASS — broken speaker/HP/jack on
   a shipping tablet
3. Important issue? PASS under the hardware-quirk exception (device
   unusable audio, not a panic)
4. Small and contained? PASS — +17 lines, one table entry
5. No new features or APIs? PASS — existing quirk flags only
6. Can apply to the local tree? PASS — driver + flags present; hunk
   applies to v6.18.57

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware quirk / DMI workaround on an existing driver. This is
an allowed stable exception.

Step 9.4: MAKE YOUR DECISION
This is a small, tested DMI quirk that makes existing Chuwi Hi8 hardware
work on this 6.18 tree. Benefit is real for those units; regression
surface is limited to an already-narrow DMI triple. It should be
backported.

Verification:
- [Phase 1] Parsed subject/tags/body from `git show 80c7d7ab1fe03` /
  upstream `c5a8fc2abe05`; no Fixes:/syzbot/Cc: stable; Link to msgid
- [Phase 2] Diff is +17 lines in `byt_rt5651_quirk_table[]` only;
  compared flags to `BYT_RT5651_DEFAULT_QUIRKS` (diff is OVCD_SF_1P0 vs
  0.75)
- [Phase 2] Confirmed `dmi_check_system()` stops when callback returns
  non-zero (`drivers/firmware/dmi_scan.c`)
- [Phase 3] `git blame -L 399,423 v6.18.57 --
  sound/soc/intel/boards/bytcr_rt5651.c`: Hi8 Pro entry from 2018 Hans
  de Goede
- [Phase 3] `git show a0d1d867c262f`: MONO_SPEAKER exists because stereo
  mix on a mono amp garbles centred audio
- [Phase 3] `git log --oneline --author='Jasper Firth' --
  sound/soc/intel/boards/`: only this commit
- [Phase 3] Flag macros present in `git show
  v6.18.57:sound/soc/intel/boards/bytcr_rt5651.c`
- [Phase 4] `b4 dig -c c5a8fc2abe05...` → lore msgid; `-a` v1 only; `-w`
  ASoC/Intel/Hans de Goede CCs; `-m` two-message thread, Mark Brown
  applied, no NAK
- [Phase 4] Patchew and LKML copies of the patch and apply mail
- [Phase 4] Stable-list search did not find this subject
- [Phase 5] `dmi_check_system` call at line 1024 of
  `snd_byt_rt5651_mc_probe`; platform driver `bytcr_rt5651`
- [Phase 5] HiBook analog in `touchscreen_dmi.c` lines 1197–1204 (Hampoo
  + Cherry Trail CR + BIOS date)
- [Phase 6] `git describe HEAD` v6.18.57-155-gcdf239ca885b2; `make
  kernelversion` 6.18.57
- [Phase 6] `git show v6.18.57:...` has Hi8 Pro then Vi8 Plus; patch
  dry-run succeeded at line 409 (offset -1)
- [Phase 6] `git log v6.18..v6.18.57 --
  sound/soc/intel/boards/bytcr_rt5651.c` empty — no prior alternate fix
- [Phase 8] Failure mode from commit text + MONO_SPEAKER history: broken
  speaker/HP/button, not oops
- UNVERIFIED: uniqueness of the DMI triple across all Hampoo Cherry
  Trail products; lore.kernel.org HTML (403)

**YES**

 sound/soc/intel/boards/bytcr_rt5651.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index ca540a66f22ce..723acb58e248e 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -409,6 +409,23 @@ static const struct dmi_system_id byt_rt5651_quirk_table[] = {
 					BYT_RT5651_HP_LR_SWAPPED |
 					BYT_RT5651_MONO_SPEAKER),
 	},
+	{
+		/* Chuwi Hi8 (CWI513) with a BIOS using generic DMI strings */
+		.callback = byt_rt5651_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hampoo"),
+			DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+			/* Above matches are too generic, add bios-date match */
+			DMI_MATCH(DMI_BIOS_DATE, "05/21/2016"),
+		},
+		.driver_data = (void *)(BYT_RT5651_MCLK_EN |
+					BYT_RT5651_JD1_1 |
+					BYT_RT5651_OVCD_TH_2000UA |
+					BYT_RT5651_OVCD_SF_1P0 |
+					BYT_RT5651_IN2_MAP |
+					BYT_RT5651_HP_LR_SWAPPED |
+					BYT_RT5651_MONO_SPEAKER),
+	},
 	{
 		/* Chuwi Vi8 Plus (CWI519) */
 		.callback = byt_rt5651_quirk_cb,
-- 
2.53.0

