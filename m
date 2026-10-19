Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB6E528E9E;
	Mon, 19 Oct 2026 14:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418581; cv=none; b=XTS/C61cSR6d9obMzxfy0rGi4PtpdIb/RUio1VK8eL/AxW3TncNynBJ6VP5YVha7kuRzuMgCO/0euJSujFRVH5ZEGD5QmoRAjvLQsbSG1ndYoApPwM0LCQ54ZxpRi/BeSBYYfrdlNHikJJ/dKEtWuXWK7d70FiYCNPlP8agXS8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418581; c=relaxed/simple;
	bh=nj+wWcul/WCvXb375pnTWTBUjTJDJxKvaVIaUkqBVrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kaWdy4F2Uzko327L6dvFV2eTeO7T4A7K+jcLnTli9/6DbBbB20MIu0e00SADSEcA2R3MHRbIphe5HGAav9dXamJhJc97efUAIbt2CUSv45Ojd0yqhd8kbkH2d2h19l0/2Vv6r9YbKNfWw2gLtzDaplOwjrDz72FOY02MUC+vye0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m8NZ0RX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m8NZ0RX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24451F000C6;
	Mon, 19 Oct 2026 14:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418577;
	bh=dnWm2W/fIwCHyOXqzjBdj4X+pTbiNGoc0GD3vQaJuCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8NZ0RX6LwWB/c5hgcs7UqkIKmyD5cAg0ZSV2CDqdBTEfB5mLXZ0Q/uHfsqX4NAIG
	 Gj1Uavu4IIIOk9xco1pKCxkX+HYpyDjKBicuxuOe+2aDthxZgHJl2G2KlfcxdiDzA7
	 XryKcD41q+kvp9Pxb9ssikqKAJFeN2YPrsZcWGDTpmEREEk6VYPjEP0cA/mRQ9/btf
	 MgTGmdYVIP6tF5d2yBDfnw5ksGjgqoIMh6meKwNPrtPdJYI+au+5iQzH9zYv8AL0Cj
	 7Y7pAzscNB3hKuj3TzKh92pmK7wI0GPAqzZ1tad4Z0ld2uJH5E6n6fV0MnGXY7Ixlt
	 IHhesgkD17Qew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Ortiz <letargopausado@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ASoC: amd: yc: Add DMI quirk for Lenovo V15 G6 ARP
Date: Mon, 19 Oct 2026 09:50:38 -0400
Message-ID: <20261019135441.1420968-347-sashal@kernel.org>
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

From: Daniel Ortiz <letargopausado@gmail.com>

[ Upstream commit d395e1b62d9694f2e4add9122f8d473eacd374aa ]

The Lenovo V15 G6 ARP (product name 83UU) uses the ACP6x PDM interface
for its internal digital microphone array. Its firmware exposes neither
the AcpDmicConnected _DSD property nor the _WOV method, so acp6x_probe()
falls through to the DMI check and returns -ENODEV, leaving
acp_yc_mach.0 unbound and no capture device registered.

Add a DMI quirk entry for this model. With it, the machine driver binds
and the DMIC capture device is created:

  acp_yc_mach acp_yc_mach.0: Enabling ACP DMIC support via DMI
  card 2: acp6x [acp6x], device 0: DMIC capture dmic-hifi-0

Capture was verified working with arecord and PipeWire.

Signed-off-by: Daniel Ortiz <letargopausado@gmail.com>
Link: https://patch.msgid.link/20260920011920.2482786-1-letargopausado@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.18.y** (`v6.18.57-155-gcdf239ca885b2`, `VERSION=6
PATCHLEVEL=18 SUBLEVEL=57`). Verdict is for this tree only.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ASoC/amd/yc] [Add] [DMI quirk so Lenovo V15 G6 ARP (83UU)
binds the existing ACP6x DMIC machine driver]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:`: none (expected)
- `Reported-by:`: none
- `Tested-by:`: none as a tag; body says capture was verified with
  arecord and PipeWire
- `Reviewed-by:`: none
- `Acked-by:`: none
- `Link:`: https://patch.msgid.link/20260920011920.2482786-1-
  letargopausado@gmail.com
- `Cc: stable@vger.kernel.org`: absent (expected; not a negative)
- `Signed-off-by: Daniel Ortiz <letargopausado@gmail.com>` (author)
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (ASoC maintainer)
- Pipeline tags (`[Upstream commit ...]`, `Signed-off-by: Sasha Levin`)
  ignored per instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Lenovo V15 G6 ARP firmware exposes neither `AcpDmicConnected`
  `_DSD` nor `_WOV`. `acp6x_probe()` therefore misses ACPI enablement,
  the DMI table does not match, and probe returns `-ENODEV`.
- **Symptom:** `acp_yc_mach.0` stays unbound; no capture PCM is
  registered (internal mic missing).
- **Root cause:** incomplete ACPI on this model; the driver already has
  a DMI fallback table for that class of firmware.
- **Fix:** add `LENOVO` / `83UU` to `yc_acp_quirk_table`. After that,
  dmesg shows `Enabling ACP DMIC support via DMI` and `DMIC capture
  dmic-hifi-0`.
- **Version info:** none in the message. Maintainer applied it to
  `for-7.3`.
- **Author explanation:** firmware gap → DMI check → `-ENODEV`; quirk
  makes the existing machine driver bind.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit hardware-quirk
addition. That is a documented stable exception (quirks/workarounds for
broken firmware), not a new driver or API.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/soc/amd/yc/acp6x-mach.c` — **+7 / -0**
- Function/object: `yc_acp_quirk_table[]` only
- Scope: **single-file surgical quirk** (one `dmi_system_id` entry)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** DMI match on this model fails; if ACPI
  `_WOV`/`AcpDmicConnected` also fail, `platform_get_drvdata()` is NULL
  and `acp6x_probe()` returns `-ENODEV`.
- **After:** `dmi_first_match()` hits `LENOVO`+`83UU`, sets drvdata to
  `&acp6x_card`, and the existing DMIC card is registered.
- Path affected: **probe/init** for this DMI identity only. Other
  machines unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Hardware workaround / DMI quirk]** Incomplete ACPI means the
existing DMI table is the only enable path. Missing table entry → probe
failure → no capture device. Same pattern as the many Lenovo/HP/ASUS
entries already in this file.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: copies the established `{ .driver_data =
  &acp6x_card, DMI_BOARD_VENDOR "LENOVO", DMI_PRODUCT_NAME "<sku>" }`
  pattern used by `83N6`/`83Q2`/`83Q3`.
- Minimal: 7 lines, no logic, locking, or API change.
- Regression risk: **very low**. Match is vendor+product SKU `83UU`.
  Wrong enablement would only hit that SKU; author confirmed capture
  works on the real machine.
- Red flags: none.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Insertion sits after Lenovo `83Q3` (from `b9a8ea185f3f8` “ASoC: acp:
  Support microphone from Lenovo Go S”, in this tree since
  **v6.14-rc1**).
- Driver file and table originated in `fa991481b8b22` (“ASoC: amd: add
  YC machine driver using dmic”, **v5.16-rc3**).
- DMI override in probe: `e521f087780d07` (2022-04-11).
- `_WOV` failure → `goto check_dmi_entry`: `984795e76def5c` (“ASoC: amd:
  yc: Fix the wrong return value”, **v6.13-rc3**).
- Bug for this laptop is **absence of a DMI row**, not a recent logic
  regression. The probe fallback this quirk uses is in 6.18.y.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. The “broken” thing is this
model’s firmware plus a missing quirk row.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: This file is a long list of the same DMI additions (HP, Lenovo,
ASUS, MSI, Acer, …). Recent examples already in this tree: ThinkPad E16
Gen 2 (`21JN`), Acer Aspire Go 15, HyperX OMEN 16-ap1xxx, HP Victus
16-e1xxx. Standalone; not patch X/Y. No prerequisites beyond the
existing table and `acp6x_probe()` DMI fallback, both present.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: `git log --author='Daniel Ortiz' -- sound/soc/amd/` shows only
this commit. Author is a hardware reporter, not the subsystem
maintainer. Weight comes from Mark Brown applying it and from the
standard quirk pattern, not from maintainer authorship.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Diff only needs `yc_acp_quirk_table`, `acp6x_card`, and
`dmi_first_match()` in `acp6x_probe()`. All exist in this checkout.
Applies standalone. Parent of the candidate already has `83Q3`
immediately before the insertion point.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c d395e1b62d9694f2e4add9122f8d473eacd374aa` → https://patch.m
  sgid.link/20260920011920.2482786-1-letargopausado@gmail.com
- `b4 dig -a`: **v1 only** (2026-09-19). No later revision.
- lore.kernel.org fetch returned **403**; thread recovered from
  Openwall/Patchew mirrors.
- Mark Brown applied it to
  `git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
  for-7.3` on 2026-09-21. No NAK, no requested respin, no reviewer
  concern in the apply mail.
- No reviewer `Cc: stable` in the thread (not a negative).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Vijendar Mukunda (AMD ACP), Mark
Brown (ASoC), Liam Girdwood, Venkata Prasad Potturu, Jaroslav Kysela,
Takashi Iwai, linux-sound, linux-kernel. Maintainer applied it. No
Acked-by/Reviewed-by on the commit itself.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot link. Evidence of user impact is the author
reproducing missing capture, then verifying arecord/PipeWire after the
quirk. Web search confirms the same patch text; no independent multi-
user report found. **UNVERIFIED:** how many other 83UU owners hit this
(likely all of them given ACPI gap, but not counted).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone 1/1 patch. Not part of a multi-patch series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403 / no useful hits for
this subject. **UNVERIFIED:** no prior stable-list NAK or explicit
nomination found. Same class of ACP6x DMI quirks has historically been
AUTOSEL’d (e.g. MSI Bravo 15 C7UCX).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

semcode MCP is not available; used file reads and `git grep`.

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function body changed. Data only: `yc_acp_quirk_table[]`.
Consumer: `acp6x_probe()`.

**Step 5.2: TRACE CALLERS**
Record:
- `acp6x_mach_driver.probe = acp6x_probe` (`module_platform_driver`).
- Platform device `"acp_yc_mach"` registered from `sound/soc/amd/yc/pci-
  acp6x.c` when ACP is in `ACP6x_PDM_MODE`.
- Context: PCI probe / boot on ACP6x Yellow Carp systems with
  `CONFIG_SND_SOC_AMD_YC_MACH`. Not a hot path, IRQ, or syscall.

**Step 5.3: TRACE CALLEES**
Record: `acp6x_probe()` uses
`acpi_dev_get_property("AcpDmicConnected")`,
`acpi_evaluate_integer("_WOV")`, `dmi_first_match(yc_acp_quirk_table)`,
`devm_snd_soc_register_card()`. The quirk only changes whether
`dmi_first_match()` returns an entry.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Boot → ACP PCI driver → register `acp_yc_mach` → `acp6x_probe()`
→ ACPI miss → DMI table → with this entry, card registers. Userspace
then sees the capture PCM (arecord/PipeWire). Reachable on this laptop
without special config beyond the existing ASoC ACP6x machine driver.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: 108 `DMI_MATCH(DMI_BOARD_VENDOR` rows in this file. `83UU`
appears only once (this entry). Nearby Lenovo SKUs `83N6`/`83Q2`/`83Q3`
are Go S quirks from `b9a8ea185f3f8`, not this model.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `sound/soc/amd/yc/acp6x-mach.c` is present.
`acp6x_probe()` still returns `-ENODEV` when ACPI and DMI both miss
(lines 845–853). Parent of the candidate has no `83UU`. Without this
row, Lenovo V15 G6 ARP has no capture device on **this** 6.18.y tree.
Driver dates to v5.16; DMI fallback is long-standing.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Parent context is `83Q3` then Nitro ANV15-41;
the hunk is a pure insertion. No refactor of the table or probe vs this
tree.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Many other DMI quirks are already in this tree. None match
`83UU`. No alternate fix for this SKU.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **[ASoC AMD Yellow Carp DMIC machine driver] [PERIPHERAL /
driver-specific]** — important for owners of that laptop, not core
mm/fs. Config: `CONFIG_SND_SOC_AMD_YC_MACH` (`depends on
SND_SOC_AMD_ACP6x && ACPI`, `depends on X86 && PCI` for ACP6x).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained quirk table (many DMI additions through
2025–2026). Mechanism is mature; this commit does not change it.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver/platform-specific** — Lenovo V15 G6 ARP (DMI product
name `83UU`) with ACP6x PDM DMIC. No effect on other DMI IDs.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot/probe on that model. Not a race. Unprivileged users
do not trigger a crash; they simply have **no microphone**. Common for
anyone using this SKU on 6.18.y.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Missing audio capture device** (internal mic dead). Not
panic/UAF/corruption. Severity **MEDIUM** for that hardware, but this is
the documented **hardware quirk** exception: without the row, the
existing driver cannot bind.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for 83UU users (mic actually works); zero for
  everyone else.
- **Risk:** Very low (7-line table add, unique SKU, author-tested).
- **Ratio:** Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real user-visible bug: no DMIC capture on Lenovo V15 G6 ARP because
  firmware omits ACPI DMIC methods.
- Existing driver and DMI fallback are in 6.18.y; only the SKU row is
  missing.
- Textbook stable exception: hardware quirk / DMI table entry on an
  existing driver.
- 7 lines, copy of established pattern, ASoC maintainer applied v1
  unchanged.
- Author verified arecord and PipeWire.
- Same class of ACP6x DMI quirks is already common in this tree.

AGAINST:
- Not a crash/security/corruption fix.
- Single-model, one reporter; no `Cc: stable` / `Fixes:` (expected).
- No independent second user report found.

UNRESOLVED:
- lore.kernel.org itself 403’d; discussion taken from b4 +
  Openwall/Patchew.
- No stable-list thread found.
- Population of 83UU users not counted.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — identical table pattern;
   author tested capture.
2. Fixes a real bug that affects users? **PASS** — mic never appears
   without the quirk.
3. Important issue? **PASS** under the hardware-quirk exception (broken
   firmware / missing device), not a kernel crash.
4. Small and contained? **PASS** — +7 lines, one file.
5. No new features or APIs? **PASS** — no new driver, Kconfig, or
   userspace API; enables existing DMIC machine driver for one SKU.
6. Can apply to the local tree? **PASS** — table and probe path present;
   applies cleanly.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk/workaround** (DMI match for firmware that does
not describe the DMIC). Closely analogous to device-ID additions.

**Step 9.4: MAKE YOUR DECISION**
This tree already has `acp6x_probe()`’s DMI fallback and a large
`yc_acp_quirk_table`. Adding `LENOVO`/`83UU` is the standard, low-risk
way to make the internal microphone work on the Lenovo V15 G6 ARP. It
should be backported to this 6.18.y tree.

------------------------------------------------
What the commit solves
The laptop’s ACPI does not advertise DMIC (`AcpDmicConnected` / `_WOV`).
Probe then depends on DMI, finds no match, returns `-ENODEV`, and users
get no capture device. One quirk row binds `acp_yc_mach` and registers
the existing ACP6x DMIC PCM.

Why it meets stable rules
It is a 7-line, obviously correct DMI quirk on a driver that already
exists in 6.18.y, tested on the hardware, with no API or behavioral
change except for that SKU.

Risk vs benefit
Benefit is a working microphone on this model; risk is confined to
`LENOVO`+`83UU`. That is the usual stable trade-off for ID/quirk
patches.

Concerns
None that block backport: no missing prerequisites, no apply conflicts,
no series dependency. Severity is “device missing,” not a panic, which
is still accepted for quirks.

Verification:
- [Phase 1] Subject/tags: ASoC amd yc DMI quirk; SOB Daniel Ortiz + Mark
  Brown; Link msgid 20260920011920.2482786-1; no Fixes/Reported-
  by/Cc:stable
- [Phase 1] Body: ACPI miss → DMI → -ENODEV; arecord/PipeWire
  verification quoted
- [Phase 2] `git show`: +7 lines in `yc_acp_quirk_table` only
  (`LENOVO`/`83UU` → `&acp6x_card`)
- [Phase 2] Read `acp6x_probe()` at 807–865: ACPI then
  `dmi_first_match`; NULL card → `-ENODEV`
- [Phase 3] `git describe HEAD` / Makefile: **6.18.57**
- [Phase 3] `git blame`: 83UU row is this commit; neighbors 83Q3 from
  `b9a8ea185f3f8` (v6.14-rc1)
- [Phase 3] File added `fa991481b8b22` (v5.16-rc3); DMI fallback
  `e521f087780d07`; `_WOV` goto `984795e76def5c` (v6.13-rc3)
- [Phase 3] `git grep 83UU` on parent: absent; on HEAD: only this entry
- [Phase 3] Author log on `sound/soc/amd/`: only this commit
- [Phase 4] `b4 dig -c d395e1b62d96`: lore msgid match; `-a` v1 only;
  `-w` AMD ACP + ASoC maintainers
- [Phase 4] Openwall 2026/09/20/35: original patch; 2026/09/21/1579:
  Mark Brown applied to for-7.3
- [Phase 4] lore.kernel.org WebFetch 403; stable search: no relevant
  hits
- [Phase 5] `git grep acp_yc_mach`: defined in acp6x-mach.c; registered
  in pci-acp6x.c:238
- [Phase 5] Kconfig `SND_SOC_AMD_YC_MACH` depends on `SND_SOC_AMD_ACP6x
  && ACPI`
- [Phase 6] Probe/DMI table present in this tree; insertion context 83Q3
  → ANV15-41 matches parent
- [Phase 8] Failure: no capture device on 83UU; not a crash
- UNVERIFIED: exact number of affected users; full lore.kernel.org HTML
  (403)

**YES**

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 507c07efc069b..209ac43f9e31e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -374,6 +374,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83UU"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0

