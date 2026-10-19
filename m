Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D957952F98C;
	Mon, 19 Oct 2026 14:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418636; cv=none; b=X2Sz300L/LQVrLbOwoXL8Pra2FHIKkN0GCZT8DR7VznOJv01xOm6oLAmEz6/AFlmd62BjFc428c3oZubVsCI6M3EadyXQvYaXoCn5Hc/1Biat49XKzDLgEA2ELOgcL3PM1YKuq2nd0dSeixnd+OU+r/mni+TS2krRQGedeqcCCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418636; c=relaxed/simple;
	bh=bTc1qBHfgTSoYHzG7x3073cPrk6kgrauXDhkJDaA0Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CKxr30jZSG0+iZhEqPUduBahMskAZLHD+1UPCBawQUijuGQbpuTXJ/iKNQiI6mqjEYV3DO5D9ay7LLJjrLfsi1dkprJ/SENvr0miunSKAKQB882iM2aQZ3OyuwiP/p0aocUY2Af48gNVpayi63aVrZgbUGGpNFNP+2ZfEoJDRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkbAUAU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkbAUAU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03461F000C6;
	Mon, 19 Oct 2026 14:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418633;
	bh=2R+14GBXQ1xxzDa5XM9aYzE2xq95R2rakb0WYwEYDqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkbAUAU/AHUASgQJtforypprMby+AZKGCIDmfYTvycm680UpOddGgw1q7WFnUEyYX
	 IVddqDZre6YetYPttlRWzdOC0je9RFDe5NHtr06GBenWjZFU/Ow8vDmJg7ewnvz/bq
	 1uhkyAZpcz24tDrtZJQNMpFX56K+ubkuR1PgwTtZY8y1wHrkn+h6TwQhwAZ5EaWejM
	 LlfHPDdut8an5Hf4hnU8zcO1xmcVh8TGQc2PuB+wquOVO+lylmN/dFmD1cmfMyLRSX
	 DKnJNYQATPP3KlrXocADrSwwlVTJ5vZAnXaSWlj9tyUkUzGkYieZ07YurL+rUc8ZHi
	 F2DonNncb0+LA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tarun Noonemunthala <ntarun2000@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/realtek: Add quirk for HP ENVY 13-aq1xxx
Date: Mon, 19 Oct 2026 09:51:19 -0400
Message-ID: <20261019135441.1420968-388-sashal@kernel.org>
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

From: Tarun Noonemunthala <ntarun2000@gmail.com>

[ Upstream commit a01a223bd685be42e908d970de32eeb3646097f3 ]

The HP ENVY Laptop 13-aq1xxx (PCI SSID 103c:86ad) uses an ALC285 codec
with two speaker pairs: front (pin 0x14) and bottom (pin 0x17).

The BIOS leaves pin 0x14 as [N/A] ("not connected"), so the generic
parser never enables the front pair and only the bottom speakers are
audible.  The vendor driver (RTKVHD64.sys) programs that pin with the
value 0x90170150 and runs the HP amplifier initialization, which is
already implemented in the driver as ALC285_FIXUP_HP_GPIO_AMP_INIT.

Add a board fixup that applies the pin configuration for 0x14 and chains
to the existing amplifier init fixup.

The pin value was recovered from the vendor driver's own configuration
data.  The patch and this changelog were prepared with an AI coding
assistant (see the Assisted-by tag below); the change was reviewed and
tested by the submitter on the affected machine.

Tested on an HP ENVY 13-aq1xxx by rebuilding snd-hda-codec-alc269 from
the Fedora 7.1.10 source and loading it: the codec now reports
"line_outs=2 (0x14/0x17)", pin 0x14 comes up as an output (Pin-ctls
0x40) with its amplifier unmuted, and both speaker pairs play.

Assisted-by: OpenCode:deepseek-v4.1-flash checkpatch
Signed-off-by: Tarun Noonemunthala <ntarun2000@gmail.com>
Link: https://patch.msgid.link/20260923094014.58867-1-ntarun2000@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a scoped Realtek pin/amp quirk for one
HP SSID, the 6.18.57 driver already has the helpers it needs, and the
patch applies cleanly.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ALSA/hda/realtek] [Add] [PCI SSID quirk so HP ENVY 13-aq1xxx
front speakers are enabled]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Assisted-by: OpenCode:deepseek-v4.1-flash checkpatch`
- `Signed-off-by: Tarun Noonemunthala <ntarun2000@gmail.com>` (author)
- `Link:
  https://patch.msgid.link/20260923094014.58867-1-ntarun2000@gmail.com`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer)
- No `Fixes:` tag (expected; this is a BIOS/hardware workaround, not a
  regression from a prior kernel commit)
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc:
  stable@vger.kernel.org`
- Pipeline markers (`[Upstream commit
  a01a223bd685be42e908d970de32eeb3646097f3]`, `Signed-off-by: Sasha
  Levin`) ignored per instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** HP ENVY Laptop 13-aq1xxx, PCI SSID `103c:86ad`, ALC285, two
  speaker pairs (front pin `0x14`, bottom pin `0x17`). BIOS marks pin
  `0x14` as `[N/A]` / not connected.
- **Symptom:** Generic parser never enables the front pair; only bottom
  speakers play.
- **Root cause:** Broken BIOS pin config. Vendor Windows driver
  (`RTKVHD64.sys`) programs pin `0x14` as `0x90170150` and runs HP amp
  init already present as `ALC285_FIXUP_HP_GPIO_AMP_INIT`.
- **Fix:** New board fixup applying that pin config and chaining to the
  existing amp-init fixup.
- **Version info:** Tested by rebuilding `snd-hda-codec-alc269` from
  Fedora 7.1.10 source on the affected machine; codec then reports
  `line_outs=2 (0x14/0x17)`, pin `0x14` output (`Pin-ctls 0x40`), amp
  unmuted, both pairs play.
- No stack traces (not a crash). No kernel-version range beyond “this
  laptop + this codec driver”.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit hardware quirk: pin
override plus existing amp-init chain. That is the documented Realtek
HDA workaround pattern.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/hda/codecs/realtek/alc269.c` (`+11` lines, 0 removed)
- Functions/tables: `enum { ... }` (add `ALC285_FIXUP_HP_ENVY_13AQ`),
  `alc269_fixups[]`, `alc269_fixup_tbl[]`
- Scope: single-file surgical hardware quirk

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
1. Enum: add `ALC285_FIXUP_HP_ENVY_13AQ` after
   `ALC285_FIXUP_HP_ENVY_X360`.
2. `alc269_fixups[]`: new `HDA_FIXUP_PINS` entry `{ 0x14, 0x90170150 }`,
   chained to `ALC285_FIXUP_HP_GPIO_AMP_INIT`.
3. `alc269_fixup_tbl[]`: `SND_PCI_QUIRK(0x103c, 0x86ad, "HP ENVY
   13-aq1xxx", ALC285_FIXUP_HP_ENVY_13AQ)` between `0x869d` and
   `0x86c1`.

Before: SSID `103c:86ad` has no match; generic parser skips unused pin
`0x14`.
After: probe applies the speaker pin and the existing HP GPIO amp-init
(and its existing LED chain).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Hardware workaround (category h)** plus pin-config
correctness. `0x90170150` decodes as fixed-function internal speaker
(`AC_JACK_PORT_FIXED` + `AC_JACK_SPEAKER` + analog +
`AC_DEFCFG_MISC_NO_PRESENCE`, assoc 5). Same speaker pincfg already used
for HP Envy x360 pin `0x14` (`B&O soundbar speakers`) in
`alc285_fixup_hp_envy_x360()`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Minimal, table-driven, SSID-scoped. Uses existing
`HDA_FIXUP_PINS` and `ALC285_FIXUP_HP_GPIO_AMP_INIT`. Regression risk is
low and confined to PCI SSID `103c:86ad`. Chain to
`ALC285_FIXUP_HP_GPIO_AMP_INIT` also chains to
`ALC285_FIXUP_HP_GPIO_LED` (`alc_fixup_hp_gpio_led(..., 0x04, 0x01)`);
that is the established HP ALC285 amp-init pattern (same as Envy x360).
Submitter tested both speaker pairs on the machine. No public API or
data-structure change.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Insertion points sit next to HP ALC285 fixups from
`aeeb85f26c3bb` (“ALSA: hda: Split Realtek HD-audio codec driver”,
Takashi Iwai, 2025-07-09). No prior `0x86ad` entry; the “bug” is a
missing quirk for BIOS-broken pin config, not a later regression. SSID
`0x86ad` is absent from `v6.18.57`.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. This does not revert or patch a
specific earlier commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: `alc269.c` regularly gets SSID quirks. Nearby HP entries already
use `ALC285_FIXUP_HP_GPIO_AMP_INIT` (ZBook 17 G6 `0x860c`, ZBook 15 G6
`0x860f`, Elite Dragonfly G1 `0x861f`). Standalone, not `patch X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Only this Realtek commit from Tarun Noonemunthala in this tree.
Maintainer Takashi Iwai applied it (`Signed-off-by` + “Applied now.
Thanks.”).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Depends on `ALC285_FIXUP_HP_GPIO_AMP_INIT` /
`alc285_fixup_hp_gpio_amp_init()`, `alc269_fixups[]`,
`alc269_fixup_tbl[]`, and `snd_hda_pick_fixup()`. All present in
`v6.18.57`. Applies standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c a01a223bd685be42e908d970de32eeb3646097f3` matched patch-id
  `273d83204a2340faba5eada8e1765ed331574a12`
- Lore/msgid:
  https://patch.msgid.link/20260923094014.58867-1-ntarun2000@gmail.com
- `b4 dig -a`: single **v1**, no later revisions
- Takashi Iwai, 2026-09-28: “Applied now. Thanks.” No NAK, no requested
  changes, no `Cc: stable` in the thread
- `lore.kernel.org` WebFetch returned 403; thread confirmed via `b4
  dig`, openwall, and IU LKML mirrors

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Takashi Iwai; Cc Jaroslav Kysela, `linux-
sound@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Subsystem
maintainer received and applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot link. Evidence is the submitter’s hardware
test (codec dump + both speaker pairs). Web search did not find a
separate public user-report thread beyond this patch.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Not part of a multi-patch series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No stable-list discussion of this SSID/quirk found. Unverified
whether anyone previously declined it; no evidence of a NAK.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: No new functions. Tables: `alc269_fixups[]`,
`alc269_fixup_tbl[]`. Runtime path uses `snd_hda_pick_fixup()`,
`__snd_hda_apply_fixup()`, `snd_hda_apply_pincfgs()`,
`alc285_fixup_hp_gpio_amp_init()`, `alc285_fixup_hp_gpio_led()`.

**Step 5.2: TRACE CALLERS**
Record: Codec probe in `alc269.c` (~line 8557) calls
`snd_hda_pick_fixup(codec, alc269_fixup_models, alc269_fixup_tbl,
alc269_fixups)`. Match is PCI subsystem ID via `SND_PCI_QUIRK`.
`HDA_FIXUP_PINS` runs at `HDA_FIXUP_ACT_PRE_PROBE` (`auto_parser.c`).
Amp init runs at `HDA_FIXUP_ACT_INIT` (`msleep(100)` then
`alc_write_coef_idx(codec, 0x65, 0x0)`). Path is module/codec probe, not
a hot syscall.

**Step 5.3: TRACE CALLEES**
Record: `snd_hda_codec_set_pincfg()` for pin `0x14`; coef write `0x65`;
GPIO LED helper. No allocations, no new locks.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Boot / `snd-hda-codec-realtek` load → ALC269/ALC285 probe → SSID
match `103c:86ad` → pin override → generic parser sees a speaker at
`0x14` → amp init. Reachable on that laptop without special userspace.
Unprivileged users cannot trigger it on other machines (SSID match).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same `0x90170150` speaker pincfg appears multiple times in
`alc269.c`. Envy x360 uses it on pin `0x14` and also chains
`ALC285_FIXUP_HP_GPIO_AMP_INIT`. This patch is the same class of fix,
smaller (one pin, no extra coef/headset logic).

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: `git describe HEAD` = `v6.18.57-155-gcdf239ca885b2`; `make
  kernelversion` = `6.18.57`
- `sound/hda/codecs/realtek/alc269.c` exists (split is in `v6.18.57`)
- `v6.18.57` has no `0x86ad` / `ALC285_FIXUP_HP_ENVY_13AQ`; BIOS-broken
  pin path is unquirked there
- Candidate overlay on current HEAD is ignored as selection evidence;
  the 6.18.57 baseline still needs the quirk

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: `git apply --check` of this diff onto the `v6.18.57` copy of
`alc269.c` succeeded (exit 0). Insertion context (enum after
`ALC285_FIXUP_HP_ENVY_X360`, fixup after that entry, quirk between
`0x869d` and `0x86c1`) matches. Expected backport difficulty: **clean
apply**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other `0x86ad` quirk. `ALC285_FIXUP_HP_ENVY_X360` is a
different SSID (`0x85de`) with extra pin/coef work. No alternate fix for
13-aq1xxx.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: ALSA HD-audio Realtek codec (`sound/hda/codecs/realtek/`).
**IMPORTANT** for laptop audio; **PERIPHERAL** in blast radius (one PCI
SSID). Driver is common; this table entry is model-specific.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained; frequent `Add quirk` commits. Pattern is
mature: append enum + fixup + `SND_PCI_QUIRK`.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: Driver-specific / platform-specific: HP ENVY 13-aq1xxx with HDA
SSID `103c:86ad` (vendor `0x103c` = HP). No other `0x86ad` uses in this
tree.

**Step 8.2: TRIGGER CONDITIONS**
Record: Every codec probe on that laptop. Common for owners of that
model; impossible for everyone else. Not a race. Not an unprivileged
attack path.

**Step 8.3: FAILURE MODE SEVERITY**
Record: Front speakers stay silent; bottom pair still works. Not a
panic/UAF. User-visible broken audio on shipping hardware. Severity
**MEDIUM** as a crash, **HIGH** as a hardware-quirk enablement (laptop
audio half-dead). Stable rules list “hardware quirk” as an accepted
class.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** Restores front speakers on a real ALC285 HP laptop;
  tested on hardware; maintainer-applied.
- **Risk:** Very low — 11 lines, SSID-scoped, existing helpers only.
- **Ratio:** Strongly favors backport.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

For:
- Hardware quirk / pin override for existing Realtek HDA driver (stable-
  rules exception)
- Real user-visible bug: BIOS leaves pin `0x14` disconnected; front
  speakers silent
- Pin value taken from vendor driver; same `0x90170150` already used as
  HP internal speaker
- Chains to existing `ALC285_FIXUP_HP_GPIO_AMP_INIT` already in 6.18.57
- 11 lines, one file, SSID-scoped
- Tested on the affected machine (codec state + playback)
- Applied by Takashi Iwai after v1; no NAK
- Applies cleanly to this tree’s `alc269.c`

Against:
- Not a crash, UAF, or security fix
- Affects one laptop SSID
- Changelog mentions AI assistance (mitigated by maintainer apply +
  hardware test)
- No independent second reporter / bugzilla (unverified beyond
  submitter)

Unresolved:
- Direct `lore.kernel.org` fetch 403 (thread recovered via `b4` and
  mirrors)
- No stable-list discussion found
- GPIO LED chain side-effect on this exact SKU not independently
  documented; same chain as other HP ALC285 amp-init boards, and the
  submitter tested playback

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard pin table +
   existing chain; hardware-tested; maintainer applied
2. Fixes a real bug that affects users? **PASS** — silent front speakers
   on HP ENVY 13-aq1xxx
3. Important issue? **PASS** — hardware quirk (explicitly allowed);
   broken onboard speakers
4. Small and contained? **PASS** — +11 lines, one file
5. No new features or APIs? **PASS** — SSID quirk only; no new UAPI
6. Can apply to the local tree? **PASS** — file, enum, tables, and
   `ALC285_FIXUP_HP_GPIO_AMP_INIT` exist in 6.18.57; `git apply --check`
   clean

**Step 9.3: EXCEPTION CATEGORIES**
Record: **Hardware quirk / audio codec quirk** (and effectively a
device-ID table addition to an existing driver). Automatic yes-class for
stable.

**Step 9.4: DECISION**
This tree is 6.18.57. The Realtek ALC269/ALC285 quirk tables are
present; SSID `103c:86ad` is not. The patch is the usual HP pin+amp
workaround, scoped to one subsystem ID, already used elsewhere in this
driver. That is exactly the class of change stable is meant to take.

### What it solves for stable users
On HP ENVY 13-aq1xxx, BIOS marks the front-speaker pin unused, so Linux
only drives the bottom pair. The quirk programs pin `0x14` as an
internal speaker and runs the existing HP amp init so both pairs work.
Without it, 6.18.y users of that laptop keep broken speaker output for
the life of the LTS tree.

### Risk vs benefit
Benefit is real, hardware-tested audio on a shipping laptop. Risk is a
11-line SSID-local table addition with no locking, allocation, or API
change.

### Concerns
None that block backport. GPIO LED chaining is inherited from
`ALC285_FIXUP_HP_GPIO_AMP_INIT` and is the existing HP ALC285 pattern.
No extra prerequisite commits are required.

Verification:
- [Phase 1] Parsed tags: author SOB, Takashi Iwai SOB, msgid Link; no
  Fixes/Reported-by/Cc: stable
- [Phase 1] Body: BIOS pin 0x14 N/A; vendor pincfg 0x90170150; tested
  line_outs=2 on HP ENVY 13-aq1xxx
- [Phase 2] Diff: +11 lines in `alc269.c` — enum, `alc269_fixups[]` pin
  table, `SND_PCI_QUIRK(0x103c, 0x86ad, ...)`
- [Phase 2] Pin 0x90170150 verified as fixed internal speaker via
  `include/sound/hda_verbs.h`; same value at Envy x360 pin 0x14
- [Phase 2] Chain target `ALC285_FIXUP_HP_GPIO_AMP_INIT` at lines
  5704–5708; func `alc285_fixup_hp_gpio_amp_init` at 2827–2835
- [Phase 3] `git describe HEAD` = `v6.18.57-155-gcdf239ca885b2`; `make
  kernelversion` = 6.18.57
- [Phase 3] `git merge-base --is-ancestor 2c9247c1739db v6.18.57` — not
  in v6.18.57 baseline
- [Phase 3] `git grep 0x86ad v6.18.57 -- alc269.c` — absent;
  `ALC285_FIXUP_HP_GPIO_AMP_INIT` present
- [Phase 3] Blame insertion neighbors: `aeeb85f26c3bb` (Realtek split),
  ancestor of v6.18.57
- [Phase 4] `b4 dig -c a01a223bd685...`: v1 only; maintainer To/Cc;
  Takashi “Applied now”
- [Phase 4] lore WebFetch 403; IU/openwall used instead
- [Phase 4] No stable-list hit for this model
- [Phase 5] Probe calls `snd_hda_pick_fixup(..., alc269_fixup_tbl,
  alc269_fixups)` ~line 8557; `HDA_FIXUP_PINS` in
  `auto_parser.c:841-847`
- [Phase 5] `0x86ad` unique in tree
- [Phase 6] `git apply --check` of this diff onto v6.18.57 `alc269.c`:
  exit 0
- [Phase 8] Failure mode: silent front speakers on one HP SSID, not a
  kernel oops
- UNVERIFIED: GPIO mute-LED wiring on this exact SKU (same inherited
  chain as other HP ALC285 amp-init boards; playback was tested)

This is a small, maintainer-applied hardware quirk that restores
speakers on an existing Realtek codec in this 6.18.57 tree, with clean
apply and SSID-local risk.

**YES**

 sound/hda/codecs/realtek/alc269.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 1fcf2ba795e8a..0a3df8b78aae6 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3774,6 +3774,7 @@ enum {
 	ALC285_FIXUP_HP_SPECTRE_X360_EB1,
 	ALC285_FIXUP_HP_SPECTRE_X360_DF1,
 	ALC285_FIXUP_HP_ENVY_X360,
+	ALC285_FIXUP_HP_ENVY_13AQ,
 	ALC288_FIXUP_DELL_HEADSET_MODE,
 	ALC288_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC288_FIXUP_DELL_XPS_13,
@@ -5981,6 +5982,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_GPIO_AMP_INIT,
 	},
+	[ALC285_FIXUP_HP_ENVY_13AQ] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x90170150 }, /* front speakers */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC285_FIXUP_HP_GPIO_AMP_INIT,
+	},
 	[ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_ideapad_s740_coef,
@@ -6794,6 +6804,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x86ad, "HP ENVY 13-aq1xxx", ALC285_FIXUP_HP_ENVY_13AQ),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x86c8, "HP Laptop 14s-dr1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0

