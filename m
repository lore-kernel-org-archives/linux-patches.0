Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8095335B7;
	Mon, 31 Aug 2026 13:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183910; cv=none; b=FUsaHXyeRfpnGI61Mr5IlWV82sA3TRoTwWbWf7aie/aWE+gRXKWOYE9pHUxQUHWnSv2j7tB8klyMFxFy9HqpFgFCygDPRe8VyUxtogZn1g4g0yWIVVw2q0/Tq4pAwL6LFMWmDAWNwmtm4iYIPSL0OSdMj6aUZDWbbNtY9mUSxlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183910; c=relaxed/simple;
	bh=gz91NM7X10kUT6WhWI8F+zZOXZenfI9od8SbIM7ogsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r96CrT5eL/XQRybcUP76wr904LBrVa15mBJSdLAteQWeZvsjW/HfkT2W1r7Nn8466OhZFUoRk5l0nvf0ZR+wSqtfQvwVLrJJWlk0Hl33Ws+sc5gYLcUKFiCCW6JRYvW1NktVJDzYoZwr2GkarIhVjqC52pE/XY35iBQGjfsbcfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pwa/hCiL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pwa/hCiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D2E1F00ACF;
	Mon, 31 Aug 2026 13:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183907;
	bh=M+7LVp9j9AboAfWG4h+K1vOBq4gAMxs54XHikRsrbm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pwa/hCiLOYqVLmv5pKlcWj1DGc36SU5E44TJ8MsUY906g0kWeflIPkSbBpJm/Rl7k
	 XFvCN7KyhYc2YXFdw34VoKXBSHbB9yepyb/MRRb/RB0w1FD92qwPMgLu1S+3vxYPMn
	 9ZgOQRXkh9yYHqY8zvamr4OgAvoCNsLiPLuyn2yR77pD73vZaJtXaFgYElnOYW0EPG
	 tswd7R2ZQkClKNOp5UH+5VozyyvhAIKLa4AsijV4bSb++aiGdEEJLpjkFPw/rTkNJf
	 bqhrEQ6ohxxrKYK6YF+cGO/LFQUSJFHuzVJZuNQLpZkQwUmFIKkpswetaR/zvS2Gpb
	 JEAcvTw0wGMyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gunal Seenivasagan <gunal2002@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Add quirk for Infinix INBOOK X3 Slim
Date: Mon, 31 Aug 2026 09:26:42 -0400
Message-ID: <20260831133314.4125787-374-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gunal Seenivasagan <gunal2002@gmail.com>

[ Upstream commit fd71820e876ef4b816b6305416ba5973bb6b9665 ]

The Infinix INBOOK X3 Slim (ALC269VB, subsystem 0x2782:0250) has its
internal speakers wired to pin 0x1b, but the BIOS pin configuration
table declares 0x1b as "no physical connection" (0x411111f0). It instead
declares pin 0x14 as the internal speaker, although nothing is connected
to 0x14.

As a result the internal speakers are silent under Linux while the
headphone jack works correctly. The codec output path to 0x14 is fully
open (DAC assigned and streaming, mixer and pin unmuted, EAPD asserted),
so the failure is silent with no error reported. The speakers work under
Windows, where the vendor driver supplies its own pin table.

Add a fixup that disables the unconnected pin 0x14 and declares pin
0x1b as the internal speaker.

Reusing the existing ALC269VC_FIXUP_INFINIX_Y4_MAX was tried first, since
it also remaps 0x1b to an internal speaker. It is not sufficient here: it
leaves 0x14 declared, so autoconfig finds two line_outs

  line_outs=2 (0x14/0x1b/0x0/0x0/0x0) type:speaker

and binds the primary "Speaker" control to the unconnected pin 0x14 while
demoting the working speaker at 0x1b to "Bass Speaker". Audio is audible
that way, but the volume and mute controls a desktop actually uses end up
attached to a pin that is not wired to anything. Disabling 0x14 is what
produces a single correct Speaker output.

Verified on the affected machine: with the corrected pin
configuration the driver's autoconfig reports

  line_outs=1 (0x1b/0x0/0x0/0x0/0x0) type:speaker

both channels play, headphone auto-mute switches correctly in both
directions, and audio survives codec runtime suspend (D3) and resume.

Signed-off-by: Gunal Seenivasagan <gunal2002@gmail.com>
Link: https://patch.msgid.link/20260726085715.229802-1-gunal2002@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: hda/realtek: Add quirk for Infinix
INBOOK X3 Slim

**Local tree:** Linux **6.18.44** (`v6.18.44-2-g1b9e1abadee04`,
`VERSION=6 PATCHLEVEL=18 SUBLEVEL=44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ALSA: hda/realtek]` `[Add]` — Add a Realtek HDA codec pin-
configuration quirk for a specific laptop model.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Gunal Seenivasagan `<gunal2002@gmail.com>` (author)
- **Link:**
  `https://patch.msgid.link/20260726085715.229802-1-gunal2002@gmail.com`
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA/HDA
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer SOB from Takashi Iwai; no syzbot/fuzzer
  involvement

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** Infinix INBOOK X3 Slim (ALC269VB, PCI SSID `0x2782:0x0250`)
  has internal speakers wired to pin `0x1b`, but BIOS declares `0x1b` as
  disconnected (`0x411111f0`) and falsely declares pin `0x14` as the
  internal speaker.
- **Symptom:** Internal speakers are completely silent under Linux;
  headphone jack works. No kernel error is reported — audio is routed to
  the unconnected pin.
- **Root cause:** Incorrect BIOS pin configuration table; Windows works
  because the vendor driver overrides it.
- **Fix approach:** Disable phantom pin `0x14`, declare pin `0x1b` as
  internal speaker.
- **Author testing:** Verified on hardware — `line_outs=1`, both
  channels play, headphone auto-mute works, survives D3 suspend/resume.
- **Version info:** None stated; hardware is a current laptop model.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit hardware pin-
configuration bug fix. Reusing `ALC269VC_FIXUP_INFINIX_Y4_MAX` partially
works (audio audible via "Bass Speaker") but leaves volume/mute controls
bound to the dead pin `0x14`; the dedicated fixup is required for
correct UX.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `sound/hda/codecs/realtek/alc269.c` only
- **Scope:** ~15 lines added, 0 removed
- **Functions/areas modified:**
  - Fixup enum (`ALC269VB_FIXUP_INFINIX_INBOOK_X3_SLIM`)
  - `alc269_fixups[]` pin table entry
  - `alc269_fixup_tbl[]` PCI quirk entry
- **Classification:** Single-file, surgical hardware quirk addition

### Step 2.2: Code flow change per hunk
**Record:**
1. **Enum hunk:** Adds new fixup ID between `INFINIX_Y4_MAX` and
   `LUNNEN_GROUND_14`.
2. **Fixup table hunk:** Before — no override for this SSID; driver
   trusts BIOS pins → silent speakers. After — applies `HDA_FIXUP_PINS`
   setting `0x14` to disabled (`0x411111f0`) and `0x1b` to internal
   speaker (`0x90170110`).
3. **Quirk table hunk:** Before — SSID `0x2782:0x0250` unmatched. After
   — matched to new fixup at codec probe time via
   `snd_hda_pick_fixup()`.

### Step 2.3: Bug mechanism
**Record:** **Category (h): Hardware workaround / audio codec quirk.**
BIOS provides incorrect HDA pin configuration; autoconfig routes DAC
output to unconnected pin `0x14`. Fix overrides pin config before probe
autoconfig runs.

### Step 2.4: Fix quality assessment
**Record:** Fix is obviously correct — follows dozens of identical
patterns in the same file (e.g. `LUNNEN_GROUND_14`,
`CHUWI_COREBOOK_XPRO`). Minimal, SSID-scoped, no API changes. Regression
risk is very low: only affects `0x2782:0x0250` devices.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed area
**Record:** Insertion point sits between `ALC269VC_FIXUP_INFINIX_Y4_MAX`
(from merge `5d324e5159d9e`, Nov 2025) and
`ALC269VC_FIXUP_LUNNEN_GROUND_14` (commit `2ec8f95a08fed`, Jul 2026,
already in this tree). The "buggy" state is the **absence** of this
quirk — the generic Realtek driver has been present for years; this
specific laptop model is unsupported without the patch.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: Related file history
**Record:** Recent related commits in this tree:
- `2ec8f95a08fed` — "Fix speakers on Lunnen Ground 14" (same vendor
  `0x2782`, same pin `0x1b` speaker issue, **already backported to
  stable** with `Cc: stable@vger.kernel.org`)
- `7484669d1fbab`, `302eb87651326`, `12e43f99242b0` — other recent HDA
  quirk additions
- Standalone fix, not part of a multi-patch series.

### Step 3.4: Author's other commits
**Record:** No commits from Gunal Seenivasagan found in this tree (`git
log --author` returned empty). First-time contributor; patch reviewed
and applied by maintainer Takashi Iwai.

### Step 3.5: Prerequisites
**Record:** No dependencies. Required infrastructure exists in this
tree:
- `ALC269VC_FIXUP_INFINIX_Y4_MAX` ✓
- `ALC269VC_FIXUP_LUNNEN_GROUND_14` ✓ (insertion anchor)
- `snd_hda_pick_fixup()` / `HDA_FIXUP_PINS` mechanism ✓
- Patch applies cleanly (`git apply --check` exit 0).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **Lore URL:** `https://lore.kernel.org/all/20260726085715.229802-1-
  gunal2002@gmail.com/`
- **Series revisions:** v1 → maintainer feedback → v2 (author name/SOB
  correction only, no functional change)
- **Maintainer response:** Takashi Iwai: "Applied now. Thanks." on v2
- No NAKs; no explicit `Cc: stable` nomination in thread

### Step 4.2: Reviewers
**Record:** CC'd: Takashi Iwai, Jaroslav Kysela, `linux-
sound@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Takashi Iwai
(maintainer) reviewed and merged.

### Step 4.3: Bug report
**Record:** No external bug tracker; author-reported hardware issue with
detailed autoconfig analysis and on-machine verification.

### Step 4.4: Related patches
**Record:** Closely related to `2ec8f95a08fed` (Lunnen Ground 14, same
ODM vendor ID `0x2782`, pin `0x1b` speaker remap). That fix was stable-
nominated and backported to this tree.

### Step 4.5: Stable mailing list
**Record:** No stable-list discussion found for this specific patch.
Precedent: sibling Infinix/Lunnen quirk was stable-nominated.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** No functions modified — only data tables (`enum`,
`alc269_fixups[]`, `alc269_fixup_tbl[]`). Consumed at probe via existing
`alc269_probe()` path.

### Step 5.2: Callers
**Record:** `snd_hda_pick_fixup(codec, alc269_fixup_models,
alc269_fixup_tbl, alc269_fixups)` at line ~8471 in `alc269.c`, called
from `alc269_probe()` during HDA codec initialization on every boot for
matching hardware.

### Step 5.3: Callees
**Record:** Fixup applied via `snd_hda_apply_fixup(codec,
HDA_FIXUP_ACT_PRE_PROBE)` — standard pin override before autoconfig.

### Step 5.4: Reachability
**Record:** Triggered at boot when PCI subsystem ID matches
`0x2782:0x0250`. Affects all users of this laptop model running this
kernel. Not userspace-triggerable; not a security issue, but a
guaranteed broken-audio path for affected hardware.

### Step 5.5: Similar patterns
**Record:** `0x411111f0` ("disable, not connected") used extensively in
same file (10+ instances). Same vendor `0x2782` has 8+ existing quirks
in this tree.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **YES** — the commit is not yet in this tree (no
`INFINIX_INBOOK_X3_SLIM` / `0x0250` entry found), but the Realtek driver
and all prerequisite fixups exist. Users with this laptop on 6.18.44
currently get silent internal speakers — the bug is live in this tree.

### Step 6.2: Backport complications
**Record:** **Clean apply** verified with `git apply --check`. Insertion
point between `INFINIX_Y4_MAX` and `LUNNEN_GROUND_14` matches current
file layout exactly.

### Step 6.3: Related fixes already present?
**Record:** `ALC269VC_FIXUP_INFINIX_Y4_MAX` exists but is insufficient
(author documented why). No duplicate fix for `0x2782:0x0250` present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **sound/hda/realtek** — IMPORTANT (affects laptop audio for
specific hardware; driver is widely used).

### Step 7.2: Subsystem activity
**Record:** Actively maintained — multiple quirk commits in `alc269.c`
within recent history in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Driver-specific** — owners of Infinix INBOOK X3 Slim
(`0x2782:0x0250`, ALC269VB). No impact on other hardware.

### Step 8.2: Trigger conditions
**Record:** Every boot on affected hardware. Deterministic, not a race.
Unprivileged users cannot trigger; hardware ownership required.

### Step 8.3: Failure mode severity
**Record:** **Silent internal speakers** (functional hardware failure
from user perspective). Headphones work. No crash, corruption, or
security impact. Severity: **MEDIUM** for affected users (core laptop
functionality broken), **LOW** for the fleet overall.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores internal speaker audio with correct volume/mute
  controls on a real laptop; tested on hardware; maintainer-merged.
- **Risk:** Very low — SSID-scoped, established quirk pattern, 15-line
  diff.
- **Ratio:** Strong benefit for affected users, negligible risk for
  everyone else.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real hardware bug — silent internal speakers on Infinix INBOOK X3 Slim
- Hardware quirk exception category (explicitly stable-appropriate)
- Small, surgical, single-file change
- Verified on affected machine by author
- Reviewed and applied by ALSA maintainer Takashi Iwai
- Applies cleanly to Linux 6.18.44
- Direct precedent: `2ec8f95a08fed` (Lunnen Ground 14, same `0x2782`
  vendor, same pin `0x1b` issue) already backported to this stable tree
- Uses well-established `0x411111f0` disable-pin pattern

**AGAINST backport:**
- Not a crash, security, or data-corruption issue
- Affects only one laptop model (narrow audience)
- No explicit `Cc: stable@vger.kernel.org` from author
- Commit not yet merged into this tree (forward-port candidate)

**Unresolved:** None affecting the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard quirk pattern;
   hardware-verified; maintainer merged
2. Fixes a real bug affecting users? **PASS** — silent speakers on real
   hardware
3. Important issue? **PASS** (via hardware-quirk exception) — functional
   audio failure on affected laptop; same class as already-stable-
   backported Lunnen Ground 14 fix
4. Small and contained? **PASS** — ~15 lines, one file
5. No new features or APIs? **PASS** — PCI quirk table entry only
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception category
**Record:** **Hardware quirk / audio codec quirk** (`SND_PCI_QUIRK` +
`HDA_FIXUP_PINS`) — automatic stable qualification per stable-kernel-
rules exceptions.

### Step 9.4: Decision rationale

This commit fixes a deterministic BIOS pin-configuration bug that leaves
internal speakers completely silent on the Infinix INBOOK X3 Slim. It is
a textbook stable hardware quirk: small, SSID-scoped, tested,
maintainer-reviewed, and structurally identical to the Lunnen Ground 14
speaker fix already present in Linux 6.18.44 stable. The patch applies
cleanly and has no dependencies.

---

## Verification

- **[Phase 1]** Parsed commit message tags: Signed-off-by (author +
  Takashi Iwai), Link tag; no Fixes/Reported-by/Cc:stable
- **[Phase 1]** Identified bug: BIOS misroutes speaker to unconnected
  pin 0x14; pin 0x1b actually wired
- **[Phase 2]** Diff: 1 file, ~15 lines, enum + fixup table + quirk
  entry; hardware pin override
- **[Phase 2]** Confirmed `0x411111f0` is standard disable-pin value
  (10+ uses in same file)
- **[Phase 3]** `git describe HEAD`: v6.18.44-2-g1b9e1abadee04; kernel
  6.18.44
- **[Phase 3]** `git blame`: insertion point between Y4_MAX
  (5d324e5159d9e) and LUNNEN_GROUND_14 (2ec8f95a08fed)
- **[Phase 3]** `git log -S INFINIX_Y4_MAX`: prerequisite fixup present
  since 5d324e5159d9e
- **[Phase 3]** `git log --author Gunal`: no prior commits in tree
- **[Phase 3]** `git apply --check`: patch applies cleanly (exit 0)
- **[Phase 4]** curl lore mbox: found v1/v2 thread; Takashi Iwai
  "Applied now. Thanks." on v2
- **[Phase 4]** curl lore: v2 had no functional changes; no stable Cc in
  thread
- **[Phase 4]** `git show 2ec8f95a08fed`: sibling Lunnen Ground 14 fix
  has Cc: stable, Greg K-H SOB, already in 6.18.44
- **[Phase 5]** grep call path: `snd_hda_pick_fixup()` at alc269.c:8471
  in probe path
- **[Phase 6]** grep: `INFINIX_INBOOK_X3_SLIM` and `0x2782, 0x0250`
  absent — bug present, fix not yet applied
- **[Phase 6]** grep: prerequisites `INFINIX_Y4_MAX`,
  `LUNNEN_GROUND_14`, `CHUWI_COREBOOK_XPRO` all present
- **[Phase 6]** `b4 shazam`: message-id not in b4 cache (used curl lore
  instead)
- **[Phase 8]** Failure mode: silent internal speakers, MEDIUM severity
  for affected hardware

**YES**

 sound/hda/codecs/realtek/alc269.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index aabd701eb1d28..a010c444b9f10 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3742,6 +3742,7 @@ enum {
 	ALC269_FIXUP_DMIC_THINKPAD_ACPI,
 	ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13,
 	ALC269VC_FIXUP_INFINIX_Y4_MAX,
+	ALC269VB_FIXUP_INFINIX_INBOOK_X3_SLIM,
 	ALC269VC_FIXUP_LUNNEN_GROUND_14,
 	ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO,
 	ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
@@ -4195,6 +4196,14 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_LIMIT_INT_MIC_BOOST
 	},
+	[ALC269VB_FIXUP_INFINIX_INBOOK_X3_SLIM] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x411111f0 }, /* disable, not connected */
+			{ 0x1b, 0x90170110 }, /* use as internal speaker */
+			{ }
+		},
+	},
 	[ALC269VC_FIXUP_LUNNEN_GROUND_14] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7631,6 +7640,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
+	SND_PCI_QUIRK(0x2782, 0x0250, "Infinix INBOOK X3 Slim", ALC269VB_FIXUP_INFINIX_INBOOK_X3_SLIM),
 	SND_PCI_QUIRK(0x2782, 0x1407, "Positivo P15X", ALC269_FIXUP_POSITIVO_P15X_HEADSET_MIC),
 	SND_PCI_QUIRK(0x2782, 0x1409, "Positivo K116J", ALC269_FIXUP_POSITIVO_P15X_HEADSET_MIC),
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
-- 
2.53.0

