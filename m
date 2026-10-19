Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D83642374;
	Mon, 19 Oct 2026 14:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418779; cv=none; b=acJc7XdSfOAxMT66uRDAH2c94E9EajvfUbf7ewuTKEo14bX5HgdVveQUUZp3maxQgFXYNBi1yNDkq6QO7IZlZTSCYBGjyMUkszuOGOk4+Ksf4QhrQgKffkzeC+gIfT+AcO8I4omyiwc2sOpErbJDEVwlx7X277HszMiO1rHylyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418779; c=relaxed/simple;
	bh=BF5G46WSiSv9fzjkSKUSFd2XXqNJpStYo6VdGpfDdKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3my36So89JKeKrxqYw4OuZ2hHwUoTRBaokCVvMWDnsG/1NiCrCSkHtVLAEM0EQEyYqdSc9ETj/z4GVL3/mlUZsgv6lNRT+kQmRIulpws00lSja3kLvPblYTN+68kukwY/NOT3bYVKm5quicuuzeOXZy9RgDbVlFBa3jyFNywSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jxd4urEk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jxd4urEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693191F000C9;
	Mon, 19 Oct 2026 14:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418776;
	bh=4vVA4AOaX8gC5PaDthEN7DJ6I/qvmkIpf5JavuvZrtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxd4urEkGGM8H8BC2wPsZzcetd7GRKk0VovWtHl1NTFgY/+Lz3Z3rm+bMgrEN038c
	 WQHDyDpk05mKlT4+QDBWBFQB5H4lP8OyPsXHbnrgMc7TUSkQaF/OYowUxN+E+/u6bw
	 DH5zKa8cAsJHeQ90FY4cBfEkvnkV3HJREVd7wUSlC3Y4poJHqVZNxiFAfCNrTeTbTg
	 IRcvGLQIO/klzx3vA7qxOp8bVwLgNwDULJG3H/VjzL22j/5WeCZY4BIF90zbGBuIze
	 UNSQCFiplf6oC8auHT1OHYDBlEaGcbJE/ec8cngUK8OrlaLz4ZUAmor5yDQIOfD6Jj
	 DogbDJSa0glig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jaidheer Sirigineedi <jaidheer7@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg3xxx (103c:8bfd)
Date: Mon, 19 Oct 2026 09:52:59 -0400
Message-ID: <20261019135441.1420968-488-sashal@kernel.org>
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

From: Jaidheer Sirigineedi <jaidheer7@gmail.com>

[ Upstream commit 13dffca9043500ed6033d770b491a043fb952bc5 ]

The mute LED on the HP Pavilion Laptop 15-eg3xxx (PCI SSID 103c:8bfd,
Realtek ALC287) does not work because the machine has no entry in the
quirk table. No fixup is applied, so the mute LED is never driven, even
though the mute function itself works.

The LED is controlled via GPIO pin 4 (mask 0x10), which is exactly what
ALC287_FIXUP_HP_GPIO_LED configures. This was verified on the hardware
with hda-verb: setting the GPIO data bit lights the mute LED, and
clearing it turns the LED off.

  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_MASK 0x10
  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DIRECTION 0x10
  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DATA 0x10   # LED on
  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DATA 0x00   # LED off

Add a quirk entry for 103c:8bfd using ALC287_FIXUP_HP_GPIO_LED.

Signed-off-by: Jaidheer Sirigineedi <jaidheer7@gmail.com>
Link: https://patch.msgid.link/20261002185951.33855-1-jaidheer7@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.18.57** (`v6.18.57-155-gcdf239ca885b2`). The Realtek
HDA driver, `alc269_fixup_tbl[]`, and `ALC287_FIXUP_HP_GPIO_LED` are all
present. This is a one-line SSID quirk for an existing fixup.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ALSA: hda/realtek] [Add] [mute LED quirk for HP Pavilion
15-eg3xxx PCI SSID 103c:8bfd]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Jaidheer Sirigineedi \<jaidheer7@gmail.com\> (author)
- Link:
  https://patch.msgid.link/20261002185951.33855-1-jaidheer7@gmail.com
- Signed-off-by: Takashi Iwai \<tiwai@suse.de\> (ALSA maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence expected)
- Ignore: `[ Upstream commit 13dffca9043500ed6033d770b491a043fb952bc5 ]`
  and Sasha Levin SOB (pipeline)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: HP Pavilion 15-eg3xxx (SSID 103c:8bfd, ALC287) has no quirk
  entry, so no mute-LED fixup is applied
- Symptom: mute works, mute LED stays dead
- Root cause: LED is GPIO pin 4 (mask 0x10); `ALC287_FIXUP_HP_GPIO_LED`
  already drives that GPIO
- Verification: author ran hda-verb SET_GPIO_MASK/DIRECTION/DATA 0x10 on
  the machine
- Version info: none stated; bug is “missing table entry,” not a
  regression from a recent commit

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a hidden fix. It is an explicit hardware-quirk addition for
a non-working LED.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `sound/hda/codecs/realtek/alc269.c` (+1 / -0)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file, one-line surgical addition

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: SSID 103c:8bfd matches nothing; `snd_hda_pick_fixup()` leaves
  the codec without this GPIO LED hook
- After: that SSID maps to `ALC287_FIXUP_HP_GPIO_LED`
- Path: codec probe / pre-probe only, SSID-matched

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: hardware workaround (quirk table entry)
- Mechanism: `alc287_fixup_hp_gpio_led()` calls
  `alc_fixup_hp_gpio_led(codec, action, 0x10, 0)`, which sets GPIO mask
  0x10 and registers a mute LED classdev. No mic-mute GPIO, no pin
  rewrite, no amp change.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: reuses a long-lived fixup already used by Pavilion
  15-eg0xxx (0x87cb, 0x87cc) in this tree
- Minimal: one `SND_PCI_QUIRK` line, table remains SSID-sorted (0x8bf0 →
  0x8bfd → 0x8c15)
- Regression risk: only machines with SSID 103c:8bfd; wrong GPIO would
  at worst mis-drive that LED, not other hardware. Author verified GPIO
  0x10 on-device.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Neighbor rows (0x8be5–0x8bf0, 0x8c15+) come from `aeeb85f26c3bbe`
  (“ALSA: hda: Split Realtek HD-audio codec driver”, 2025-07-09)
- `ALC287_FIXUP_HP_GPIO_LED` enum and function also exist from that
  split; they were not added by this commit
- The 8bfd line is new; parent `8fa1cfe41877d` has no `0x8bfd`

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not a regression from a specific commit; the
laptop never had a table entry.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent history is full of the same pattern already accepted
here, including:
- `8db3663d3c3e2` HP Pavilion 15-eg0xxx (same family, same
  `ALC287_FIXUP_HP_GPIO_LED`)
- `66ab53f7fac5a` HP Pavilion 14-dv1001TU (same GPIO 0x10 / same fixup)
- Several other “Add mute LED quirk” commits on this file
Standalone; not patch X/Y.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Only this commit by Jaidheer Sirigineedi under
`sound/hda/codecs/realtek/`. SMTP hostname on the lore mail is
`jaidheer-eg3036tu` (Pavilion 15-eg3036tu). Takashi Iwai, ALSA
maintainer, applied it.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Needs only `ALC287_FIXUP_HP_GPIO_LED` /
`alc287_fixup_hp_gpio_led()`, both already in 6.18.57. Applies
standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 13dffca9043500ed6033d770b491a043fb952bc5` →
  https://patch.msgid.link/20261002185951.33855-1-jaidheer7@gmail.com
- `b4 dig -a`: single v1 series, no later revisions
- Thread: author patch + Takashi “Applied now. Thanks.” No NAK, no
  requested changes, no stable discussion
- lore.kernel.org HTTP fetch returned 403; thread recovered via `b4 dig
  -m`

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc Jaroslav Kysela, Takashi Iwai, linux-sound,
linux-kernel. Maintainer applied next day. No other review comments.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot link. Evidence is on-hardware hda-verb plus
the author’s own 15-eg3xxx machine. Severity from reporter: mute LED
dead; mute audio works.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone v1. Sibling 15-eg0xxx quirk already in this tree
(`8db3663d3c3e2`). No series dependency.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable HTTP 403. No local `git log --grep=8bfd`
hits besides this candidate. No evidence it was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body changed. New table row consumed by
`snd_hda_pick_fixup()` in the ALC269/ALC287 probe path. Downstream:
`alc287_fixup_hp_gpio_led` → `alc_fixup_hp_gpio_led` → `alc_fixup_gpio`
/ `gpio_mute_led_set`.

Step 5.2: TRACE CALLERS
Record: `alc269_fixup_tbl` is passed at probe (`alc269.c` ~8557).
Reached when an ALC269-family Realtek codec (including ALC287) is
enumerated. Not IRQ/hot-path; once per codec init.

Step 5.3: TRACE CALLEES
Record: `alc_fixup_hp_gpio_led(..., 0x10, 0)` at PRE_PROBE sets GPIO
mask 0x10 and `snd_hda_gen_add_mute_led_cdev()`. micmute_mask is 0, so
no mic-mute LED hook.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace mute → LED classdev → GPIO data bit 0x10. Reachable on
this laptop whenever HDA mute LED is used. Unprivileged users can toggle
mute; they cannot affect other SSIDs.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same GPIO-0x10 / `ALC287_FIXUP_HP_GPIO_LED` pattern already used
for Pavilion 15-eg0xxx (0x87cb, 0x87cc), 14-dv1001TU (0x8987), Aero
13z-be200 (0x8bd6), and other HP SKUs.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `sound/hda/codecs/realtek/alc269.c` and
`alc269_fixup_tbl[]` exist. Parent of the candidate has no 0x8bfd.
Without this line, 103c:8bfd gets no mute-LED fixup. Introduced-as-
missing: the machine was never quirked; the driver/table have been in
6.18 since the Realtek split.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Context around 0x8bf0/0x8c15 matches. No rework
needed. (Mainline later grew extra nearby rows such as 0x8bc7; those are
not required here.)

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other 8bfd entry. 15-eg0xxx is already quirked with the same
fixup; that does not cover 15-eg3xxx (different SSID).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: ALSA HD-audio Realtek (`sound/hda/codecs/realtek/`). IMPORTANT
for laptop audio; PERIPHERAL in that only SSID 103c:8bfd is affected.
Config: `SND_HDA_CODEC_REALTEK` (default on typical x86
desktops/laptops).

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively receiving per-SKU quirk additions. This is the normal,
mature way this driver enables hardware.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / platform-specific: HP Pavilion 15-eg3xxx with
PCI SSID 103c:8bfd only.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot on that laptop: mute LED never driven. Mute key still
works. Unprivileged user can observe the broken LED.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Incorrect hardware behavior (mute LED stuck off). Severity LOW
versus crash/corruption, but this is a documented hardware-quirk
exception, not a crash-class bug.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: restores mute LED on a shipping HP Pavilion SKU; same class
  of fix already shipped in this 6.18.y tree many times
- Risk: very low (1 line, existing fixup, SSID-matched)
- Ratio: favorable

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Hardware quirk for a real laptop, hardware-verified with hda-verb
- Reuses existing `ALC287_FIXUP_HP_GPIO_LED` (GPIO 0x10), same as
  Pavilion 15-eg0xxx already in this tree
- 1 line, no new API, no new driver, no locking/refcount change
- ALSA maintainer applied v1 with no objections
- Applies cleanly to 6.18.57; all callees exist
- Sibling mute-LED quirks are routinely accepted in this tree

AGAINST:
- Does not fix crash, UAF, deadlock, or data corruption
- Affects one SSID only
- No Fixes:/Cc: stable (expected; not a negative)

UNRESOLVED:
- lore.kernel.org/stable HTTP search blocked (403); no sign of a prior
  rejection

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — existing fixup; hda-verb on
   hardware; maintainer applied
2. Fixes a real bug that affects users? PASS — mute LED never driven on
   this SKU
3. Important issue? PASS under the hardware-quirk exception (not a
   crash-class bug)
4. Small and contained? PASS — +1 line in one table
5. No new features or APIs? PASS — table entry only
6. Can apply to the local tree? PASS — file, table, and fixup all
   present; context matches

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware quirk / workaround (SND_PCI_QUIRK for an existing
Realtek HDA driver). This is an allowed stable exception.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.18.57 tree. It is the standard one-
line Realtek mute-LED quirk, the target fixup already exists here, and
the only users touched are those with PCI SSID 103c:8bfd.

What it solves for stable users: on HP Pavilion 15-eg3xxx the mute key
works but the LED never lights because probe never applies the GPIO-4
LED hook. Adding 103c:8bfd → `ALC287_FIXUP_HP_GPIO_LED` enables that
existing path.

Risk vs benefit: benefit is a working LED on a real laptop; risk is a
single SSID-guarded line using a well-used helper. No dependencies
beyond code already in 6.18.

Verification:
- [Phase 1] Parsed tags: author SOB, Link to msgid, Takashi Iwai SOB; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x103c, 0x8bfd, ...
  ALC287_FIXUP_HP_GPIO_LED)` in `alc269_fixup_tbl`
- [Phase 2] Read `alc287_fixup_hp_gpio_led()` at alc269.c:1386 — calls
  `alc_fixup_hp_gpio_led(..., 0x10, 0)`
- [Phase 2] Read `alc_fixup_hp_gpio_led()` in realtek.c:2223 — GPIO
  setup + mute LED cdev only
- [Phase 3] `git describe HEAD` / `make kernelversion`:
  v6.18.57-155-gcdf239ca885b2 / 6.18.57
- [Phase 3] `git grep 0x8bfd` on parent `8fa1cfe41877d`: not present
  (bug exists without this commit)
- [Phase 3] Blame: `ALC287_FIXUP_HP_GPIO_LED` from `aeeb85f26c3bbe` (in
  this tree)
- [Phase 3] Sibling 15-eg0xxx entries at alc269.c:6823–6824 use the same
  fixup
- [Phase 3] `git merge-base --is-ancestor
  13dffca9043500ed6033d770b491a043fb952bc5 HEAD`: not an ancestor
  (upstream SHA not in this history; expected)
- [Phase 4] `b4 dig -c 13dffca9…`: lore thread found; v1 only
- [Phase 4] `b4 dig -w`: To Takashi Iwai, Jaroslav Kysela, linux-sound
- [Phase 4] `b4 dig -m`: Takashi reply “Applied now. Thanks.” No NAK
- [Phase 4] WebFetch/curl of lore.kernel.org: 403 — used b4 mbox instead
- [Phase 5] Probe path: `snd_hda_pick_fixup(..., alc269_fixup_tbl, ...)`
  at alc269.c:8557
- [Phase 6] File path `sound/hda/codecs/realtek/alc269.c` exists; apply
  context matches 0x8bf0/0x8c15
- [Phase 8] Failure mode: mute LED inert on one HP SKU; severity LOW,
  exception category applies
- UNVERIFIED: stable@ lore search (HTTP 403)

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0bfa64bee9d3b..a25c92834e722 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7010,6 +7010,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be9, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8bfd, "HP Pavilion 15-eg3xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c15, "HP Spectre x360 2-in-1 Laptop 14-eu0xxx", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
-- 
2.53.0

