Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB1F471267;
	Mon, 31 Aug 2026 13:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183315; cv=none; b=Ush3w64kSqsR88s2HPuUMgT1/ARAdikc27rlrRrCg/8fmfANbK2EpqRi0zzuUAmGIOayO7XnpgMV9IDcH2zSELVpKbkb2J3Yz5oyQTDup2sHdM41atCmFwWX8xro+GDdYBrE4Ix01woLbTrlL99P20Cv0vNvcqGj9b6WmHI9lfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183315; c=relaxed/simple;
	bh=AakF8LDHJZeo4tBbW/euG0jWc1cCwijduuKREC6b2J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qh0r/IYNAaKpf5xpbptwuGfNZxVUOp8rlmc68O3RFmhM8u+xrvG1mDDiv4I6AelPHBn9+hppq7o8OaKViLI2WoCyp4MrhTnPaUF+CcnouQgJtFDTCUvD6aEM3c0AWGmaxRcwd0GE3rIroKbQELcYJho90PBL6N+yD32oaJNEC9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nW8QvC/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nW8QvC/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD02F1F000E9;
	Mon, 31 Aug 2026 13:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183313;
	bh=M8D7M6mBkwqRnkgUEWH3JD0GscwuBauOD2KpapZTNyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nW8QvC/O2yBWJNQEW1NYWsFErxSwym1l/pZKKLxrREuPJuOwfyfBB+DhLmmQkA6EJ
	 yXvI03sbRZmu4Hix9L4A7+HEx+UnNGfRLbuUreQasrn6FRrfZmkmaPRkCAO+z8QSAf
	 V38vm7LUEnTcGEnlJr+GIqWjRnPO/dN01n5j2YDWaq+fhjitO37guAVIKVxLOLh3TD
	 +WDAgey2TxF9dUaDUKXwMBJdbunIVYYwZuYBuI2+rqSgsdIxXjoejrye45O0LbfSml
	 O0DnIUCfqsV2c+0f/+b9YOuNdJmLGwjpJ/tV56c2B0ol4WKxcStYw88h+uc5ip9YIF
	 Ey0iF5IO8IXNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Bowen <hicbowen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda/realtek: Fix speakers on MECHREVO WUJIE Series
Date: Mon, 31 Aug 2026 09:21:42 -0400
Message-ID: <20260831133314.4125787-74-sashal@kernel.org>
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

From: Chen Bowen <hicbowen@gmail.com>

[ Upstream commit 9064637fb2a80b43105900a47d414997630e5b6b ]

The internal speakers on the MECHREVO WUJIE Series are silent,
while the headphone output works correctly.

The BIOS reports NID 0x1b on the Realtek ALC233 codec as
unconnected with pin configuration 0x411111f0. However, the pin
is connected to an internal speaker.

Overriding NID 0x1b with 0x90170150 makes the HDA generic parser
detect both 0x14 and 0x1b as speaker outputs and restores internal
speaker playback.

Add a pin configuration fixup for the affected PCI SSID c011:1d05.

Tested on a MECHREVO WUJIE Series laptop with board
WUJIE Series-Lark4-LNL and firmware EM_LNL326_V1.0.23.

Signed-off-by: Chen Bowen <hicbowen@gmail.com>
Link: https://patch.msgid.link/20260710133409.16641-1-hicbowen@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: hda/realtek: Fix speakers on MECHREVO
WUJIE Series

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ALSA: hda/realtek]` `[Fix]` — Restore internal speaker
playback on MECHREVO WUJIE Series laptops with Realtek ALC233 codec.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Chen Bowen \<hicbowen@gmail.com\> (author) |
| Link |
https://patch.msgid.link/20260710133409.16641-1-hicbowen@gmail.com |
| Signed-off-by | Takashi Iwai \<tiwai@suse.de\> (ALSA/HDA maintainer) |

**Notable absences (expected, not negative):** No `Fixes:`, no `Cc:
stable@vger.kernel.org`, no `Reported-by:`, no syzbot link.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** BIOS reports NID 0x1b on ALC233 as unconnected
  (`0x411111f0`), but pin is wired to internal speakers.
- **Symptom:** Internal speakers silent; headphone output works.
- **Root cause:** HDA generic parser skips misreported pin; speaker
  outputs not detected.
- **Fix:** Override NID 0x1b with `0x90170150` via PCI SSID quirk
  `c011:1d05`.
- **Testing:** Verified on MECHREVO WUJIE Series, board `WUJIE Series-
  Lark4-LNL`, firmware `EM_LNL326_V1.0.23`.

### Step 1.4: Hidden Bug Fix?
**Record:** Not disguised — this is an explicit hardware/BIOS quirk fix.
Same class as other "Fix speakers on …" commits in this file.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `sound/hda/codecs/realtek/alc269.c` only
- **Scope:** ~15 lines added, 0 removed — single-file surgical quirk
- **Changes:**
  1. New enum `ALC233_FIXUP_WUJIE_SPEAKERS`
  2. New `hda_fixup` entry (`HDA_FIXUP_PINS`, pin 0x1b → `0x90170150`)
  3. New `SND_PCI_QUIRK(0xc011, 0x1d05, …)` table entry

### Step 2.2: Code Flow
**Record:**
- **Before:** On SSID `c011:1d05`, codec probe uses BIOS pin config; NID
  0x1b treated as disconnected → no internal speaker PCM device.
- **After:** Quirk table match applies pin override at probe; parser
  detects 0x14 and 0x1b as speaker outputs → internal speaker playback
  works.
- **Path:** Normal device probe / initialization only.

### Step 2.3: Bug Mechanism
**Record:** **Category (h): Hardware workaround / codec quirk.**
Incorrect BIOS pin configuration prevents speaker detection. Pin-table
override is the standard Realtek HDA fix pattern.

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Yes — identical mechanism to existing quirks in
  this file.
- **Minimal:** Yes — enum + fixup struct + one quirk line.
- **Regression risk:** Very low — quirk matches only PCI SSID
  `0xc011:0x1d05`; no global behavior change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Insertion point (`ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY`
area) dates to v6.18 merge base (Nov 2025). The "bug" is BIOS
misconfiguration, not a kernel regression — present since hardware
shipped.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag. Bug is firmware/BIOS reporting error,
not introduced by a specific kernel commit.

### Step 3.3: Related File History
**Record:** Recent analogous stable commits in this tree:
- `2ec8f95a08fed` — "Fix speakers on Lunnen Ground 14" — **same pin** `{
  0x1b, 0x90170150 }`, backported (`Cc: stable`, Greg K-H SOB)
- `6b2c0cd5f9689` — Legion Pro 7 speaker fix
- `6441` area — `ALC233_FIXUP_MEDION_MTL_SPK` — ALC233 speaker pin
  override on 0x1b

Standalone fix; not part of a series.

### Step 3.4: Author Context
**Record:** Chen Bowen — no prior commits in this tree's `sound/hda/`.
Patch carries Takashi Iwai's maintainer `Signed-off-by`, indicating ALSA
maintainer acceptance.

### Step 3.5: Dependencies
**Record:** **None.** Uses existing `HDA_FIXUP_PINS`, `hda_pintbl`, and
`SND_PCI_QUIRK` infrastructure. No prerequisite commits required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Commit provides Link to patch.msgid.link thread
(`20260710133409.16641-1-hicbowen@gmail.com`). `b4 dig -c` could not
match — commit not present in local tree. lore.kernel.org fetch blocked
by bot protection. **UNVERIFIED:** Full review thread content.

### Step 4.2: Reviewers
**Record:** Takashi Iwai (ALSA/HDA maintainer) signed off.
**UNVERIFIED:** Full recipient list via `b4 dig -w`.

### Step 4.3: Bug Report
**Record:** No external bug report links. Author tested on physical
hardware (strong signal for hardware quirks).

### Step 4.4: Related Patches
**Record:** Related MECHREVO Wujie fix exists for **Conexant** codec
(`06d929be11327`, SSID `0x1d05:0x3012`) — different hardware variant,
same product line pattern.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** — could not search lore stable list.
Precedent: nearly identical Lunnen Ground 14 fix was explicitly
nominated and backported to this tree.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions/Structures
**Record:** `alc269_fixups[]`, `alc269_fixup_tbl[]`, enum fixup IDs. No
function body changes — data-table only.

### Step 5.2: Callers
**Record:** `alc269_fixup_tbl` consumed during HDA codec probe
(`snd_hda_pick_fixup` / `snd_hda_apply_fixup` path). Runs once per
matching codec at driver bind.

### Step 5.3: Callees
**Record:** `HDA_FIXUP_PINS` applies pin configuration verbs during
codec initialization.

### Step 5.4: Reachability
**Record:** Triggered at boot/module load when PCI audio device with
SSID `c011:1d05` is enumerated. Affects laptop owners with this hardware
— not userspace-triggerable, but affects every boot.

### Step 5.5: Similar Patterns
**Record:** Pin `0x1b` → `0x90170150` already used in this tree for:
- `ALC269VC_FIXUP_LUNNEN_GROUND_14` (line 4190) — **identical fix**
- `ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO` (line 4198)
- Multiple other speaker fixups

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Generic HDA Realtek parser and ALC233 support
exist. Without this quirk, affected hardware gets silent speakers.
`ALC233_FIXUP_WUJIE_SPEAKERS` and `0xc011:0x1d05` quirk are **not yet**
in this tree (confirmed by grep).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Enum insertion point
(`ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY` at line 3784), fixup table
structure, and quirk table position (after `0x8086:0x3038`, before
`0xf111:0x0001` at lines 7591–7592) all match the patch context.

### Step 6.3: Related Fixes Already Present?
**Record:** No duplicate WUJIE/MECHREVO Realtek quirk. Lunnen Ground 14
fix (same pin value, same bug class) already backported.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `sound/hda/codecs/realtek` — **IMPORTANT** (audio subsystem,
laptop users). Device-specific quirk, not core kernel.

### Step 7.2: Subsystem Activity
**Record:** **Highly active** — frequent speaker/quirk commits in
`alc269.c` (20+ recent entries). Hardware quirk additions are routine
stable material for this file.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Owners of MECHREVO WUJIE Series laptops with Realtek ALC233
and PCI SSID `c011:1d05`. Narrow hardware scope, but complete audio
failure (speakers) for those users.

### Step 8.2: Trigger Conditions
**Record:** Every boot/probe on matching hardware. Deterministic — not a
race. Unprivileged users cannot trigger on non-matching hardware.

### Step 8.3: Failure Mode Severity
**Record:** **MEDIUM** — silent internal speakers (functional
impairment, not crash/corruption/security). Headphones still work.
Significant UX impact for affected laptop owners.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores speaker audio on affected laptops; proven quirk
  pattern.
- **Risk:** Minimal — SSID-scoped, ~15 lines, no logic changes.
- **Ratio:** Strong benefit for affected users, negligible risk to
  others. Matches established stable practice for HDA codec quirks.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real hardware bug (silent speakers) with author hardware testing
- Textbook HDA codec quirk — explicit stable exception category
- Identical pattern to `ALC269VC_FIXUP_LUNNEN_GROUND_14` already
  backported to this 6.18.y tree
- Small, single-file, SSID-scoped change
- ALSA maintainer (Takashi Iwai) signed off
- Applies cleanly to current `alc269.c`
- No dependencies

**AGAINST backport:**
- Device-specific — narrow user base
- Not crash/security/data-corruption (functional audio only)
- No `Cc: stable` nomination (not a negative per review rules)

**UNRESOLVED:**
- Full lore review thread (bot protection)
- Whether maintainer explicitly nominated for stable

### Step 9.2: Stable Rules Checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — maintainer merged;
hardware tested; proven pin value |
| 2. Fixes real bug affecting users? | **PASS** — silent speakers on
specific laptop |
| 3. Important issue? | **PASS** (hardware quirk exception) — functional
audio failure for affected hardware |
| 4. Small and contained? | **PASS** — ~15 lines, one file |
| 5. No new features/APIs? | **PASS** — quirk table entry only |
| 6. Can apply to local tree? | **PASS** — infrastructure present, clean
apply |

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** — PCI SSID-matched pin
configuration fix for broken BIOS reporting. This is one of the most
common and accepted stable backport categories for
`sound/hda/realtek/alc269.c`.

### Step 9.4: Decision Rationale

This commit fixes a real, user-visible problem (no internal speaker
audio) caused by incorrect BIOS pin reporting on MECHREVO WUJIE Series
laptops. The fix is a minimal, SSID-scoped pin override using the exact
same mechanism and pin value (`0x1b` → `0x90170150`) as the Lunnen
Ground 14 fix already backported to this 6.18.y tree. It requires no
prerequisites, poses negligible regression risk, and falls squarely
within the hardware-quirk exception for stable kernels.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed no syzbot/Reported-by; Takashi Iwai maintainer
  SOB present
- **[Phase 2]** Diff analysis: 3 hunks in `alc269.c` — enum, fixup
  struct, quirk table entry
- **[Phase 2]** Pin override `0x1b → 0x90170150` matches Lunnen Ground
  fix pattern
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9 (6.18.y
  stable tree)
- **[Phase 3]** `git show 2ec8f95a08fed`: Lunnen Ground 14 — identical
  pin fix, backported with `Cc: stable`
- **[Phase 3]** `git log --oneline -20 -- alc269.c`: multiple recent
  speaker quirk commits
- **[Phase 3]** `git blame -L 3784,3786`: enum area present since v6.18
  merge
- **[Phase 3]** `git show 06d929be11327`: related MECHREVO Wujie
  conexant quirk (different codec/SSID)
- **[Phase 4]** `b4 dig -c HEAD`: no match (commit not in tree) —
  UNVERIFIED lore thread
- **[Phase 4]** WebFetch patch.msgid.link and lore.kernel.org: blocked
  by bot protection — UNVERIFIED
- **[Phase 5]** `grep 0x90170150 alc269.c`: 8 existing uses, including
  Lunnen Ground at line 4190
- **[Phase 5]** `grep alc269_fixup_tbl`: standard HDA quirk application
  path confirmed
- **[Phase 6]** `grep WUJIE|0xc011|ALC233_FIXUP_WUJIE`: no matches — fix
  not yet in tree
- **[Phase 6]** Verified insertion points at lines 3784–3785 (enum) and
  7591–7592 (quirk table) match patch context
- **[Phase 6]** `ALC233_FIXUP_MEDION_MTL_SPK` at line 6441: precedent
  for ALC233 speaker pin fixup
- **[Phase 6]** `grep 0xc011 sound/hda`: no existing quirks for this
  vendor — no conflict
- **[Phase 7]** `git log --oneline -5 --grep=speaker -- alc269.c`:
  active quirk maintenance
- **[Phase 8]** Failure mode assessed: silent speakers, MEDIUM severity;
  SSID-scoped, low risk

**YES**

 sound/hda/codecs/realtek/alc269.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 1bbaabbe99263..df2d597bcf95e 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3782,6 +3782,7 @@ enum {
 	ALC275_FIXUP_DELL_XPS,
 	ALC293_FIXUP_LENOVO_SPK_NOISE,
 	ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY,
+	ALC233_FIXUP_WUJIE_SPEAKERS,
 	ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED,
 	ALC255_FIXUP_DELL_SPK_NOISE,
 	ALC225_FIXUP_DISABLE_MIC_VREF,
@@ -4034,6 +4035,13 @@ static void alc287_fixup_lenovo_yoga_book_9i(struct hda_codec *codec,
 }
 
 static const struct hda_fixup alc269_fixups[] = {
+	[ALC233_FIXUP_WUJIE_SPEAKERS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1b, 0x90170150 }, /* internal speaker */
+			{ }
+		},
+	},
 	[ALC269_FIXUP_GPIO2] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_gpio2,
@@ -7615,6 +7623,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0xc011, 0x1d05, "MECHREVO WUJIE Series", ALC233_FIXUP_WUJIE_SPEAKERS),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
-- 
2.53.0

