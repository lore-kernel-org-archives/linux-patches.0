Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06A65908B0;
	Mon, 31 Aug 2026 13:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184252; cv=none; b=ZeKsBOr05/r0tjPxp9Drpm5kZrAE3PJ2Mhh/YEjYcY3eYo0+OPK0MIkzE3HYNy844mdELVg/egOiXZrt35buujrNf7lLhKZlVn6bc24E4/dsOuuuo+Ea1hCz+Q/8wnJVWPk+pZLGYNGJre+lmA5J+4vMts+FT16gkCCGHxXP6Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184252; c=relaxed/simple;
	bh=lVnslt8ydv6pHI8L6KPAnLNvOP35iZ59rWq8EUL/C7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDyLSiHRK3ZmvYXWIazszOWIU0F/wt5Rb8hjUj4lGElRETNeNbrKAX1jUTbzPnJ3ZUVeWv1+Y4sU48ciLxU8/ygJWUahXhpabNw7aCa+EInAQ3myI8Dn+GJrpO9rpOorHPRYcE7mYxledZ80mbXt1CJl5A830jMUNqIxpq8xJlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMpgJ4qe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMpgJ4qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E521F000E9;
	Mon, 31 Aug 2026 13:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184250;
	bh=MzSapTbHbu1k4YV91lQZz1ATI21fNAQHPHdtp0nsPhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMpgJ4qe+3QrMqkL62KrjAUIl0+z14WO1UjMw8d4Kiq2hvhoxS5ImFNRtJKi75uJB
	 BgK3ut4Ry5LcUkeY0KUXfQTXwfy6alQrPvwT+TzK8O9y3rSKlB6tMRHfY5eR8VJ7MW
	 qaMENB94x+3kUS80mUW09KXWI/iOYi553hDWu6ccuDJqGJLdhv472Vf4VnbnhC4SP/
	 BUbEomm4RmQzRkd8Y1v/AWiZCH8CWlwh5uo3bAzE5sptkHudDQ9OlJWWUZKYS5zdTf
	 uc+TE1dteJbXwxDAL6bAzQmqSy5xJUCInAngYruior9j2aulpwbG/1uCEHYlrabeyy
	 89inTxayRRF+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Fix headphone output on ASUS ROG Ally X
Date: Mon, 31 Aug 2026 09:30:09 -0400
Message-ID: <20260831133314.4125787-581-sashal@kernel.org>
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

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit 335f7860846732477a9ce24f0db04dd253ba268c ]

The ASUS ROG Ally X (RC72LA, PCI SSID 0x1043:0x1eb3) with an ALC294
codec produces no sound from the headphone jack, and unplugging the
headphones can leave the speakers muted too.

The device uses ALC287_FIXUP_TAS2781_I2C, which chains into the
ThinkPad fixup chain. alc285_fixup_thinkpad_x1_gen7() makes the
headphone (pin 0x21) and speaker (pin 0x17) share DAC 0x03. That is
correct for a ThinkPad, but here the shared DAC is exposed as a
"Line Out" control that defaults to zero, so the headphones stay
silent when plugged in.

Add a dedicated fixup chain for the Ally X that sets up the TAS2781
amplifier and the headset jack without the ThinkPad DAC sharing, and
routes the speaker to DAC 0x02 so the headphone and speaker get
independent DACs.

Also, fixup the wrong product code (it's RC72LA, not RCLA72).

Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Link: https://patch.msgid.link/20260707005615.52889-1-matthew.schwartz@linux.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA HDA Realtek — ASUS ROG Ally X Headphone
Fix

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ALSA: hda/realtek]` `[Fix]` — Fix headphone output on ASUS
ROG Ally X (RC72LA, PCI SSID 0x1043:0x1eb3).

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Matthew Schwartz \<matthew.schwartz@linux.dev\>
(author) |
| Link | https://patch.msgid.link/20260707005615.52889-1-
matthew.schwartz@linux.dev |
| Signed-off-by | Takashi Iwai \<tiwai@suse.de\> (ALSA maintainer merge)
|
| Fixes: | **Absent** (expected for manual review) |
| Cc: stable | **Absent** (expected) |
| Reported-by | **Absent** |
| Reviewed-by | **Absent** |

Notable: maintainer (Iwai) Signed-off-by is a quality signal. No
syzbot/fuzzer involvement.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** ASUS ROG Ally X (RC72LA, ALC294 codec, SSID 0x1043:0x1eb3)
  has no headphone jack audio; unplugging headphones can leave speakers
  muted.
- **Symptom:** Silent headphones; speakers stuck muted after headphone
  unplug.
- **Root cause:** Device matched to `ALC287_FIXUP_TAS2781_I2C`, which
  chains into the ThinkPad fixup (`alc285_fixup_thinkpad_x1_gen7()`).
  That fixup makes headphone pin 0x21 and speaker pin 0x17 share DAC
  0x03 — correct for ThinkPads, wrong here. The shared DAC appears as a
  "Line Out" control defaulting to zero, silencing headphones.
- **Fix approach:** Dedicated fixup chain routing speaker to DAC 0x02
  (independent DACs), TAS2781 I2C amp setup, and generic headset jack
  (not ThinkPad chain). Also corrects product name (RC72LA, not RCLA72).

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit hardware audio routing bug fix, not
disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `sound/hda/codecs/realtek/alc269.c` only
- **Scope:** ~20 lines added/changed; 2 new enum entries, 2 new fixup
  table entries, 1 quirk table entry modified
- **Functions referenced (not modified):**
  `alc285_fixup_speaker2_to_dac1`, `tas2781_fixup_tias_i2c`,
  `alc_fixup_headset_jack` (via `ALC225_FIXUP_HEADSET_JACK`)
- **Classification:** Single-file, surgical hardware quirk fix

### Step 2.2: Code Flow Change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Enum | No `ALC287_FIXUP_ASUS_ALLY_X*` entries | Two new fixup IDs
added |
| Fixup table | `ALC287_FIXUP_TAS2781_I2C` → ThinkPad headset chain |
New chain: `ALC287_FIXUP_ASUS_ALLY_X` → `alc285_fixup_speaker2_to_dac1`
→ `ALC287_FIXUP_ASUS_ALLY_X_I2C` → `tas2781_fixup_tias_i2c` →
`ALC225_FIXUP_HEADSET_JACK` |
| Quirk table | `0x1eb3` → `ALC287_FIXUP_TAS2781_I2C` ("ASUS Ally
RCLA72") | `0x1eb3` → `ALC287_FIXUP_ASUS_ALLY_X` ("ASUS Ally RC72LA") |

**Execution path:** Codec probe → PCI quirk match → fixup chain during
`HDA_FIXUP_ACT_PRE_PROBE` / build.

### Step 2.3: Bug Mechanism
**Record:** **Category (h): Hardware workaround / audio codec quirk.**
Wrong DAC routing from an inappropriate ThinkPad-derived fixup chain
causes zero-volume headphone output and broken speaker automute
behavior.

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Yes — mirrors established patterns in the same
  file (e.g., `ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1` uses
  `alc285_fixup_speaker2_to_dac1` + separate headset chain).
- **Minimal:** Yes — reuses existing fixup functions, no new logic.
- **Regression risk:** Very low — only affects PCI SSID 0x1043:0x1eb3;
  other `ALC287_FIXUP_TAS2781_I2C` devices unchanged.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame` on line 7162 shows the quirk was introduced in
commit `5d324e5159d9e` (2025-11-28, merge bringing in `alc269.c` for
6.18-rc8). Buggy assignment `0x1eb3 → ALC287_FIXUP_TAS2781_I2C` has been
present since `alc269.c` entered this tree.

### Step 3.2: Fixes: Tag
**Record:** No `Fixes:` tag. The buggy quirk assignment dates to initial
`alc269.c` import in 6.18. Not applicable to follow a Fixes: SHA.

### Step 3.3: Related File History
**Record:** Recent related commits in this tree:
- `5060592025103` — Fixed headphone jack on ASUS Xbox Ally
  (RC73XA/RC73YA) by introducing `ALC287_FIXUP_TXNW2781_I2C_ASUS` (Cc:
  stable)
- `819268882628f` — TAS2781 UEFI calibration skip for Xbox Ally X (Cc:
  stable # 6.18)
- `acacb5b7109ac` — Initial Xbox Ally TAS2781 binding (Cc: stable #
  6.17)

Same author (Matthew Schwartz) has prior Ally-family audio fixes.
Standalone fix, not part of a multi-patch series.

### Step 3.4: Author Context
**Record:** Matthew Schwartz is an active ALSA/HDA contributor with
multiple Ally-related fixes. Takashi Iwai (subsystem maintainer) merged
the patch.

### Step 3.5: Dependencies
**Record:** All required symbols exist in this tree:
- `alc285_fixup_speaker2_to_dac1` (line 2533)
- `tas2781_fixup_tias_i2c` (line 3245)
- `ALC225_FIXUP_HEADSET_JACK` (line 5214)
- `ALC287_FIXUP_TAS2781_I2C` (unchanged, still used by other devices)

**Can apply standalone:** Yes.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c <sha>` could not be run — commit hash is not
present as a commit object in this tree (only provided as candidate
diff). Link in commit message: https://patch.msgid.link/20260707005615.5
2889-1-matthew.schwartz@linux.dev. Lore.kernel.org and patch.msgid.link
both blocked by Anubis bot protection — **could not retrieve thread
content.**

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not fetch mailing list thread. Commit
message shows Iwai merge SOB only; no explicit Reviewed-by in provided
message.

### Step 4.3: Bug Report
**Record:** No external bug report links. Bug described in commit
message from hardware testing on the device itself.

### Step 4.4: Related Patches
**Record:** Related but independent Ally-family fixes exist in tree
(RC73XA calibration, RC73XA/YA TAS quirk). This patch targets RC72LA
(ROG Ally X), a different SSID.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — lore.kernel.org inaccessible. Prior Ally fixes
in this tree were explicitly nominated for stable (Cc: stable tags on
`acacb5b7109ac`, `5060592025103`, `819268882628f`).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** Modified: fixup enum, `alc269_fixups[]`,
`alc269_fixup_tbl[]`. Called (unchanged):
`alc285_fixup_speaker2_to_dac1`, `tas2781_fixup_tias_i2c`,
`alc_fixup_headset_jack`.

### Step 5.2: Callers
**Record:** Fixup chain invoked during HDA codec probe/initialization
for matched PCI device 0x1043:0x1eb3 only. Triggered at boot/module load
on affected hardware.

### Step 5.3: Callees
**Record:**
- `alc285_fixup_speaker2_to_dac1` — overrides NID 0x17 connection list
  to DAC 0x02 only
- `tas2781_fixup_tias_i2c` — binds TAS2781 I2C amplifier component
- `alc_fixup_headset_jack` — standard headset jack detection setup

### Step 5.4: Reachability
**Record:** Triggered automatically on every boot for ASUS ROG Ally X
users with this PCI SSID. Not userspace-triggerable, but affects all
users of this device.

### Step 5.5: Similar Patterns
**Record:** Identical pattern used for other ASUS devices:
- `ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1` →
  `alc285_fixup_speaker2_to_dac1` + separate headset chain
- `ALC287_FIXUP_TXNW2781_I2C_ASUS` → TAS amp + `ALC294_FIXUP_ASUS_SPK`
  (fix for Xbox Ally headphone breakage, commit `5060592025103`)

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Current tree at line 7162:
```
SND_PCI_QUIRK(0x1043, 0x1eb3, "ASUS Ally RCLA72",
ALC287_FIXUP_TAS2781_I2C),
```
`ALC287_FIXUP_ASUS_ALLY_X` does **not** exist. Fix is needed in this
tree.

### Step 6.2: Backport Complications
**Record:** Expected **clean apply**. Enum/fixup/quirk context in this
tree matches the provided diff (line numbers differ but content aligns).
No conflicting recent changes to the `0x1eb3` entry.

### Step 6.3: Related Fixes Already Present?
**Record:** `git log --grep="ASUS_ALLY_X"` — no match. Fix not yet
applied. Related Xbox Ally fixes (`5060592025103`, `819268882628f`) are
present but address different SSIDs/issues.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `sound/hda/codecs/realtek` — ALSA HDA Realtek codec driver.
**Criticality: PERIPHERAL** (device-specific), but HDA quirks are high-
value for affected hardware users.

### Step 7.2: Activity
**Record:** Actively maintained — multiple quirk additions/fixes in 2026
(Legion Pro 7, Lunnen Ground 14, TongFang, HP Dragonfly, etc.).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of **ASUS ROG Ally X** (RC72LA, PCI SSID
0x1043:0x1eb3) running kernel 6.18.x with HDA Realtek support enabled.
Narrow hardware scope, but 100% of those users have broken headphone
audio with current quirk.

### Step 8.2: Trigger Conditions
**Record:** Every boot / codec initialization on this device.
Plugging/unplugging headphones triggers the speaker-mute side effect.
Common, deterministic usage pattern.

### Step 8.3: Failure Mode Severity
**Record:** **MEDIUM** — No kernel crash, no data corruption, no
security issue. Complete loss of headphone audio; speakers can remain
muted after unplug. Significant functional impairment for a gaming
handheld where headphone use is common.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores headphone and speaker audio on Ally X — real
  user-visible fix for a popular device.
- **Risk:** Very low — ~20 lines, single PCI ID, reuses proven fixup
  functions, no API changes.
- **Ratio:** Strong benefit, minimal risk. Falls squarely in the
  **hardware quirk exception** category for stable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real, reproducible hardware audio bug (silent headphones, stuck
  speaker mute)
- Small, surgical, obviously correct fix reusing established patterns
- All prerequisites present in 6.18.44 tree
- Buggy code confirmed present in this tree since `alc269.c` import
- ALSA maintainer (Iwai) merged; author has track record on Ally audio
- Same class of fix as `5060592025103` (Xbox Ally headphone fix, Cc:
  stable)
- Explicit hardware quirk/workaround — stable exception category

**AGAINST backport:**
- Not a crash, security, or corruption issue
- Affects only one PCI ID (narrow scope)
- No external bug report or syzbot validation
- Mailing list review discussion unverified

**UNRESOLVED:**
- Full lore review thread content
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable Rules Checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — pattern proven on other
ASUS devices; commit describes hardware testing |
| 2. Fixes real bug affecting users? | **PASS** — broken headphone audio
on Ally X |
| 3. Important issue? | **PASS** (as hardware quirk) — complete audio
loss on affected device; not crash-level but functionally critical for
users |
| 4. Small and contained? | **PASS** — ~20 lines, one file, one PCI ID |
| 5. No new features/APIs? | **PASS** — quirk table entries only, no
userspace-visible API |
| 6. Can apply to local tree? | **PASS** — prerequisites present, clean
expected apply |

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** (audio codec quirk) —
explicitly listed as stable-appropriate.

### Step 9.4: Decision Rationale

For Linux **6.18.44**, the buggy quirk assignment exists and causes
broken headphone output on the ASUS ROG Ally X. The fix is minimal,
self-contained, follows established patterns in the same driver, and
addresses a real functional defect on consumer hardware. While not a
crash or security issue, audio codec hardware quirks are routinely and
appropriately backported to stable — precedent exists in this very tree
for Ally-family audio fixes. Benefit clearly outweighs risk.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
- **[Phase 1]** Confirmed no Fixes:, Reported-by, Cc: stable, or
  Reviewed-by tags
- **[Phase 2]** Diff analysis: 1 file, ~20 lines, enum + fixup table +
  quirk table changes
- **[Phase 2]** Read `alc285_fixup_speaker2_to_dac1` at line 2533 —
  routes NID 0x17 to DAC 0x02
- **[Phase 2]** Read `alc285_fixup_thinkpad_x1_gen7` at line 2605 —
  shares DAC 0x03 for pins 0x17 and 0x21
- **[Phase 2]** Read current `ALC287_FIXUP_TAS2781_I2C` chain at lines
  6285–6289 — chains to ThinkPad headset jack
- **[Phase 3]** `git describe HEAD` → v6.18.44-1-g2736c32da98b9; `make
  kernelversion` → 6.18.44
- **[Phase 3]** `git blame -L 7162,7162` → quirk introduced in
  5d324e5159d9e (2025-11-28)
- **[Phase 3]** `git log -S '0x1eb3'` → only in alc269.c since tree
  import
- **[Phase 3]** `git show 5060592025103` — prior Xbox Ally headphone fix
  with Cc: stable
- **[Phase 3]** `git show 819268882628f` — related Ally X TAS2781 fix by
  same author
- **[Phase 3]** `git log --author="Matthew Schwartz"` — author has Ally
  audio commits in tree
- **[Phase 4]** `b4 dig` — commit not in tree as commit object; could
  not run
- **[Phase 4]** UNVERIFIED: lore.kernel.org and patch.msgid.link blocked
  by Anubis
- **[Phase 5]** `grep` confirmed all prerequisite fixup functions and
  enum values exist
- **[Phase 5]** Verified `ALC225_FIXUP_HEADSET_JACK` at line 5214 —
  standalone headset jack, no ThinkPad chain
- **[Phase 6]** `grep 0x1eb3` — buggy quirk present at line 7162;
  `ALC287_FIXUP_ASUS_ALLY_X` absent
- **[Phase 6]** `git log --grep="ASUS_ALLY_X"` — fix not yet applied
- **[Phase 7]** `git log --oneline -5 -- sound/hda/codecs/realtek/` —
  active subsystem
- **[Phase 8]** Assessed failure mode as functional audio loss (MEDIUM),
  not crash (CRITICAL)

**YES**

 sound/hda/codecs/realtek/alc269.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a07f40e9541ee..1bbaabbe99263 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3955,6 +3955,8 @@ enum {
 	ALC236_FIXUP_DELL_DUAL_CODECS,
 	ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
 	ALC287_FIXUP_TAS2781_I2C,
+	ALC287_FIXUP_ASUS_ALLY_X,
+	ALC287_FIXUP_ASUS_ALLY_X_I2C,
 	ALC295_FIXUP_DELL_TAS2781_I2C,
 	ALC245_FIXUP_TAS2781_SPI_2,
 	ALC287_FIXUP_TXNW2781_I2C,
@@ -6288,6 +6290,18 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	},
+	[ALC287_FIXUP_ASUS_ALLY_X] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_speaker2_to_dac1,
+		.chained = true,
+		.chain_id = ALC287_FIXUP_ASUS_ALLY_X_I2C,
+	},
+	[ALC287_FIXUP_ASUS_ALLY_X_I2C] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = tas2781_fixup_tias_i2c,
+		.chained = true,
+		.chain_id = ALC225_FIXUP_HEADSET_JACK,
+	},
 	[ALC245_FIXUP_TAS2781_SPI_2] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = tas2781_fixup_spi,
@@ -7164,7 +7178,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e83, "ASUS GA605W", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1e93, "ASUS ExpertBook B9403CVAR", ALC294_FIXUP_ASUS_HPE),
-	SND_PCI_QUIRK(0x1043, 0x1eb3, "ASUS Ally RCLA72", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x1eb3, "ASUS Ally RC72LA", ALC287_FIXUP_ASUS_ALLY_X),
 	SND_PCI_QUIRK(0x1043, 0x1ed3, "ASUS HN7306W", ALC287_FIXUP_CS35L41_I2C_2),
 	HDA_CODEC_QUIRK(0x1043, 0x1ee2, "ASUS UM6702RA/RC", ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x1ee2, "ASUS UM6702RA/RC", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0

