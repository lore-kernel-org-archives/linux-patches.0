Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9313A3827;
	Mon, 20 Apr 2026 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690951; cv=none; b=IHb539iNeptbVBWS7Yg9JFtX1L9UHLOujCQE9GuYOHsmmqtazxtX4Tu0UWH0TaH7QvgPKphf+/O5IilpMg9G9kY03ISfOtuCFXQ93MoL/9jrh/DjFaplqquHbCsM3AdR8FWR84FZAz2dOd1JlGfJneznzjsItiSHhHJ+xq0JYP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690951; c=relaxed/simple;
	bh=Lpyc0qcZSIS4VXioxRjcx7oG5oDRtYxZNh2ly6qWd2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdbOIlFfCVB82TZmFOgthlcvAmLeylKZfgIo7OLlYRu6qoW0O8ZDfxRshST2ZGIZWKlzPQTwJYqZiN/VIWkGBocfhLuFaS5BmiX9cyrzdL/5GlzHDqjHc7SMDfSEmYVpt3mIheJ2zBQpCYZ+7fAOXRkdTt46a3XGfNLSgd+lTo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VF51oohS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VF51oohS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C767C2BCB6;
	Mon, 20 Apr 2026 13:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690950;
	bh=Lpyc0qcZSIS4VXioxRjcx7oG5oDRtYxZNh2ly6qWd2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VF51oohShzxp0LfVZmTpE366O4g6vPlzjUQAKal5VErQLhDj9zKd4vTl84Uuav8Td
	 wV2+xPT/sFNsxHOhru0I6QghPxWp7ctUWFlPihOvEUe9g58q1+VHzW2JDkzTbMYkX6
	 6afnvaArDn/7ZlXxY7UMOV7cB0Z7T7Eyj/tH1ns9PBwifefxgnlppg/+WYT50e7bxV
	 X8jJY3YxYIgNtWoU0lM0QHAENR5jCjEceI8u6aLtwiovsCG4i1cHPYxVTeATBAaMJ+
	 0kXHw5V7bMEBx8BS/yefweAGLRhoHAHMemqqWhSEgjA45zg7W9Pf+XpF2GQMPXcIpN
	 2v9P0+6XLaR+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Leonard Lausen <leonard@lausen.nl>,
	Nicholas Wang <me@nicho1as.wang>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] ALSA: hda: cs35l41: Fix boost type for HP Dragonfly 13.5 inch G4
Date: Mon, 20 Apr 2026 09:07:53 -0400
Message-ID: <20260420131539.986432-7-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Leonard Lausen <leonard@lausen.nl>

[ Upstream commit 6389dbd5c4a2d819ec342f89bd65883ab021278e ]

The HP Dragonfly 13.5 inch G4 (SSID 103C8B63) has _DSD properties in
ACPI firmware with valid reset-gpios and cs-gpios for the four CS35L41
amplifiers on SPI.

However, the _DSD specifies cirrus,boost-type as Internal (0), while
the hardware requires External Boost. With Internal Boost configured,
the amplifiers trigger "Amp short error" when audio is played at
moderate-to-high volume, eventually shutting down entirely.

Add a configuration table entry to override the boost type to
External, similar to the existing workaround for 103C89C6. All GPIO
indices are set to -1 since the _DSD provides valid reset-gpios and
cs-gpios.

Confirmed on BIOS V90 01.11.00 (January 2026), the latest available.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219520
Originally-by: Nicholas Wang <me@nicho1as.wang>
Signed-off-by: Leonard Lausen <leonard@lausen.nl>
Link: https://patch.msgid.link/db84dcf91bc8dbd217b35572b177d967655ff903@lausen.nl
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have all the information needed for my analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** ALSA: hda: cs35l41
- **Action verb:** "Fix" - explicit bug fix
- **Summary:** Fixes incorrect ACPI boost type configuration for HP
  Dragonfly 13.5 inch G4 (SSID 103C8B63)
- Record: [ALSA/HDA/cs35l41] [fix] [Override incorrect ACPI boost type
  for specific HP laptop]

### Step 1.2: Tags
- **Link:** `https://bugzilla.kernel.org/show_bug.cgi?id=219520` - user-
  filed Bugzilla report
- **Originally-by:** Nicholas Wang `<me@nicho1as.wang>` - original
  contributor
- **Signed-off-by:** Leonard Lausen `<leonard@lausen.nl>` - patch author
- **Link:** `https://patch.msgid.link/db84dcf91bc8dbd217b35572b177d96765
  5ff903@lausen.nl` - mailing list submission
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` - ALSA subsystem
  maintainer applied it
- No Fixes: tag (expected for manual review candidates), no Cc: stable
  (expected).
- Record: Bugzilla link present = real user-reported issue. Applied by
  subsystem maintainer Takashi Iwai. Two contributors (Originally-by +
  Signed-off-by).

### Step 1.3: Body Text Analysis
- **Bug description:** HP Dragonfly 13.5 inch G4 ACPI _DSD specifies
  `cirrus,boost-type` as Internal (0), but hardware requires External
  Boost.
- **Symptom:** Amplifiers trigger "Amp short error" when audio is played
  at moderate-to-high volume, eventually shutting down entirely. This
  means speakers stop working.
- **Fix approach:** Add config table entry to override boost type to
  External (same pattern as 103C89C6).
- **Version info:** Confirmed on BIOS V90 01.11.00 (January 2026), the
  latest available.
- Record: Clear bug description with concrete symptom. Incorrect ACPI
  firmware causes amplifier hardware error and shutdown. Tested on
  latest BIOS.

### Step 1.4: Hidden Bug Fix Detection
- This is not a hidden bug fix - it's explicitly labeled "Fix" and
  describes a clear hardware issue.
- Record: Not a hidden fix; explicitly identified as a bug fix for
  incorrect ACPI firmware.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Changes Inventory
- **File:** `sound/hda/codecs/side-codecs/cs35l41_hda_property.c`
- **Lines added:** 6 (1 data entry + 4-line comment in
  `cs35l41_config_table`, 1 data entry in `cs35l41_prop_model_table`)
- **Lines removed:** 0
- **Functions modified:** None - only static data tables are changed
- **Scope:** Single-file, data-only, surgical addition
- Record: 1 file, +6 lines (2 table entries + 1 comment block), no
  function code changes.

### Step 2.2: Code Flow Change
- **Hunk 1:** Adds `{ "103C8B63", 4, EXTERNAL, { CS35L41_RIGHT,
  CS35L41_LEFT, CS35L41_RIGHT, CS35L41_LEFT }, -1, -1, -1, 0, 0, 0 }` to
  `cs35l41_config_table` with a 4-line comment explaining the override.
  Entry specifies 4 amps, EXTERNAL boost, all GPIO indices = -1 (use
  ACPI-provided), boost parameters = 0 (not needed for external).
- **Hunk 2:** Adds `{ "CSC3551", "103C8B63", generic_dsd_config }` to
  `cs35l41_prop_model_table`, connecting the SSID to the
  `generic_dsd_config` handler.
- Before: SSID 103C8B63 had no override entry, so ACPI _DSD values were
  used directly (Internal boost = wrong).
- After: SSID 103C8B63 matches config table, `generic_dsd_config`
  overrides boost to External.

### Step 2.3: Bug Mechanism
- **Category:** Hardware workaround (ACPI firmware quirk)
- **Mechanism:** ACPI firmware incorrectly declares Internal Boost for a
  device that requires External Boost. The driver trusts the ACPI data,
  configures the amplifier incorrectly, causing hardware protection
  errors ("Amp short error") and eventual amplifier shutdown.
- Record: Hardware quirk/workaround for incorrect ACPI firmware.
  Overrides boost type from Internal to External for specific SSID.

### Step 2.4: Fix Quality
- Obviously correct: Follows identical pattern to 103C89C6 (HP Zbook
  Fury 17 G9), which has been in the tree since December 2023.
- Minimal and surgical: Pure data-table additions, no logic changes.
- Regression risk: Zero for other devices (entries only match specific
  SSID 103C8B63). Very low for this device (same pattern as proven
  workaround).
- Record: Obviously correct, minimal, zero regression risk for other
  hardware.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- The config table was introduced by commit `8c4c216db8fb8` (December
  2023) by Stefan Binding.
- The 103C89C6 boost type override entry (same pattern) was introduced
  by commit `d110858a692582` (December 2023).
- The prop_model_table and generic_dsd_config function have been stable
  since then, with only additional SSID entries added.
- Record: Infrastructure has been stable since v6.8 era. The buggy ACPI
  firmware is in the hardware, not in kernel code.

### Step 3.2: Fixes Tag
- No Fixes: tag present (expected). The "bug" is in ACPI firmware, not a
  kernel code regression.
- Record: N/A - firmware quirk, not a kernel regression.

### Step 3.3: File History
- Recent commits: `f205ed23f0687` (Lenovo Thinkbook support),
  `6014e9021b28e` (file move).
- The file is regularly updated with new device SSID entries - this is
  standard maintenance.
- Record: Standalone change, no prerequisites. Regular table addition.

### Step 3.4: Author
- Leonard Lausen is not the subsystem maintainer but the patch was
  reviewed and applied by Takashi Iwai, the ALSA subsystem maintainer.
- Originally contributed by Nicholas Wang, suggesting multiple users
  encountered the issue.
- Record: Applied by subsystem maintainer Takashi Iwai.

### Step 3.5: Dependencies
- The `cs35l41_config_table` and `cs35l41_prop_model_table` structures
  exist in this tree.
- The `generic_dsd_config` function exists and is the standard handler
  for these entries.
- No other commits needed. Standalone.
- Record: No dependencies. Applies standalone. Only concern for older
  stable trees is the file path (`sound/pci/hda/` vs
  `sound/hda/codecs/side-codecs/`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.5
- Both lore.kernel.org and bugzilla.kernel.org are behind Anubis bot-
  protection and could not be fetched.
- b4 dig could not find the commit (it's not in this tree yet, only a
  message-id reference).
- The patch was accepted by Takashi Iwai (ALSA maintainer) via `Link:
  https://patch.msgid.link/...`, confirming it went through normal
  review.
- Bugzilla bug 219520 exists, confirming this is a user-reported real-
  world issue.
- Record: UNVERIFIED: Could not access lore or bugzilla due to Anubis
  protection. However, the patch was applied by the ALSA subsystem
  maintainer and references a Bugzilla report, both strong signals.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4
- No functions are modified - only static const data tables.
- `generic_dsd_config` is the handler that consumes these entries.
  Verified by reading lines 237-364.
- The lookup path: `cs35l41_prop_model_table` -> matched by SSID ->
  calls `generic_dsd_config` -> searches `cs35l41_config_table` ->
  applies boost type override to `hw_cfg`.
- Lines 344-358 show how boost type determines amplifier configuration
  (Internal vs External boost, GPIO settings).
- Record: Data-only change. No code logic changes. The consumption path
  (`generic_dsd_config`) is well-established and handles dozens of other
  SSIDs identically.

### Step 5.5: Similar Patterns
- 103C89C6 is the exact same pattern: HP laptop with incorrect ACPI
  boost type, overridden via config table entry. This has been in the
  tree since v6.8.
- Dozens of other SSID entries follow the same pattern.
- Record: Well-established pattern with many precedents.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1
- The config table infrastructure was introduced in December 2023 (v6.8
  era). It exists in stable trees 6.6.y (likely backported), 6.12.y,
  7.0.y.
- The file was moved to a new path in July 2025 for v7.0. For older
  stable trees, the file is at `sound/pci/hda/cs35l41_hda_property.c`.
- Record: Infrastructure exists in stable trees >= 6.6.y. File path
  differs in older trees.

### Step 6.2
- For v7.0: Should apply cleanly (file exists at new path, tables
  present).
- For older trees (6.6.y, 6.12.y): Minor path adjustment needed
  (`sound/pci/hda/cs35l41_hda_property.c`), and the insertion point
  after 103C8A6E must exist.
- Record: Clean apply for 7.0. Path adjustment needed for older trees
  but otherwise trivial.

### Step 6.3
- No related fixes for this specific SSID (103C8B63) exist in any tree.
- Record: No duplicate fixes found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1
- **Subsystem:** ALSA (Advanced Linux Sound Architecture) / HDA (High
  Definition Audio) / CS35L41 amplifier driver
- **Criticality:** IMPORTANT - audio is a core laptop feature, and HP
  Dragonfly is a popular business laptop
- Record: IMPORTANT subsystem, affects users of a specific HP laptop
  model.

### Step 7.2
- Active subsystem: Regular SSID additions and quirks. Actively
  maintained by Takashi Iwai.
- Record: Actively maintained subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1
- **Affected users:** Owners of HP Dragonfly 13.5 inch G4 (SSID
  103C8B63)
- Record: Device-specific (HP Dragonfly 13.5 G4).

### Step 8.2
- **Trigger:** Playing audio at moderate-to-high volume on the affected
  laptop
- **How common:** Extremely common - basic audio playback
- **Unprivileged trigger:** Yes, any user playing audio
- Record: Very common trigger (normal audio playback).

### Step 8.3
- **Failure mode:** "Amp short error" -> amplifier shutdown -> no audio
  output
- **Severity:** HIGH - speakers fail during normal use. Not a security
  issue but major functionality loss.
- Record: HIGH severity - speakers stop working during normal audio
  playback.

### Step 8.4
- **Benefit:** HIGH - restores working audio for HP Dragonfly 13.5 G4
  users on stable kernels
- **Risk:** VERY LOW - 2 data-table entries, only affects SSID 103C8B63,
  follows proven pattern
- **Ratio:** Excellent benefit-to-risk ratio
- Record: High benefit, very low risk. Excellent ratio.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Fixes real hardware issue reported by users (Bugzilla 219520, two
  contributors)
- Pure hardware quirk addition - 2 table entries, no logic changes
- Follows exact same proven pattern as existing 103C89C6 workaround
- Applied by ALSA subsystem maintainer Takashi Iwai
- Without the fix, speakers fail during normal audio playback (Amp short
  error + shutdown)
- Zero regression risk for any other hardware
- Standalone change with no dependencies

**AGAINST backporting:**
- None identified. This is a textbook stable candidate.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - Confirmed on BIOS V90,
   follows identical proven pattern
2. Fixes a real bug? **YES** - User-reported Bugzilla, speakers fail
   during audio playback
3. Important issue? **YES** - Complete speaker failure on a popular
   business laptop
4. Small and contained? **YES** - 2 table entries in 1 file (+6 lines
   total)
5. No new features or APIs? **YES** - Data-only quirk, no new
   functionality
6. Can apply to stable? **YES** - Clean for 7.0; minor path adjustment
   for older trees

### Step 9.3: Exception Category
This is a **hardware quirk/workaround** - one of the explicitly allowed
exception categories for stable. These are automatically strong YES
candidates.

### Step 9.4: Decision
This is a textbook hardware quirk that fixes broken audio on a specific
HP laptop. It's minimal, zero-risk, follows a proven pattern, was
reported by real users, and was applied by the subsystem maintainer.

---

## Verification

- [Phase 1] Parsed tags: Link to bugzilla.kernel.org/219520, Originally-
  by + Signed-off-by, applied by maintainer Takashi Iwai
- [Phase 2] Diff analysis: 2 table entries added (+6 lines with
  comment), no logic changes, single file
- [Phase 2] Verified entry format matches existing entries (e.g.,
  103C89C6 at line 47, 103C8A6E at line 57)
- [Phase 3] git blame: Config table infrastructure from commit
  8c4c216db8fb8 (Dec 2023), present since v6.8
- [Phase 3] git show 581523ee3652e: Confirmed identical pattern for HP
  Zbook 103C89C6 boost type override
- [Phase 3] git log: No prerequisites needed, standalone change
- [Phase 4] UNVERIFIED: Could not access lore.kernel.org or
  bugzilla.kernel.org due to Anubis bot protection
- [Phase 5] Read generic_dsd_config (lines 237-364): Verified
  consumption path - table lookup by SSID, boost type applied at lines
  344-358
- [Phase 6] git tag: Infrastructure present in tree (v7.0), file at new
  path since July 2025
- [Phase 6] git log old path: confirmed file was at sound/pci/hda/ for
  older stable trees
- [Phase 8] Failure mode: "Amp short error" and amplifier shutdown
  during audio playback = HIGH severity

**YES**

 sound/hda/codecs/side-codecs/cs35l41_hda_property.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/hda/codecs/side-codecs/cs35l41_hda_property.c b/sound/hda/codecs/side-codecs/cs35l41_hda_property.c
index 16d5ea77192f0..732ae534db360 100644
--- a/sound/hda/codecs/side-codecs/cs35l41_hda_property.c
+++ b/sound/hda/codecs/side-codecs/cs35l41_hda_property.c
@@ -55,6 +55,11 @@ static const struct cs35l41_config cs35l41_config_table[] = {
 	{ "103C8A30", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
 	{ "103C8A31", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
 	{ "103C8A6E", 4, EXTERNAL, { CS35L41_LEFT, CS35L41_LEFT, CS35L41_RIGHT, CS35L41_RIGHT }, 0, -1, -1, 0, 0, 0 },
+/*
+ * Device 103C8B63 has _DSD with valid reset-gpios and cs-gpios, however the
+ * boost type is incorrectly set to Internal. Override to External Boost.
+ */
+	{ "103C8B63", 4, EXTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, CS35L41_RIGHT, CS35L41_LEFT }, -1, -1, -1, 0, 0, 0 },
 	{ "103C8BB3", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
 	{ "103C8BB4", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
 	{ "103C8BDD", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
@@ -475,6 +480,7 @@ static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
 	{ "CSC3551", "103C8A30", generic_dsd_config },
 	{ "CSC3551", "103C8A31", generic_dsd_config },
 	{ "CSC3551", "103C8A6E", generic_dsd_config },
+	{ "CSC3551", "103C8B63", generic_dsd_config },
 	{ "CSC3551", "103C8BB3", generic_dsd_config },
 	{ "CSC3551", "103C8BB4", generic_dsd_config },
 	{ "CSC3551", "103C8BDD", generic_dsd_config },
-- 
2.53.0

