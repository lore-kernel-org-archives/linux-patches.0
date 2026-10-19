Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DC9592B92;
	Mon, 19 Oct 2026 14:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418428; cv=none; b=txmQCzauM66RsTb3IasDm/L+kHyd7LFl3Es5gsLNzBD9/lgdafnpx1Tc0nszkT7QFclN78iQVsc9te88wiRreraPROALvXY3XpjID19LqiruI2dWRo5DlOLCwfPmF723MSzQMFAUIWsPauD+Z0FwKcPNWpMS2AJJoL/LoyZPoV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418428; c=relaxed/simple;
	bh=4Rp/XM0BDoxxGDmgkvVnAlFwp5YJnh3unci5+esLcs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KpeSgqdwgr27vvBEiw9rvnTihlJfAUVpJ7HhRYcsbHNb1NoI79Rs4BlH9ehFTAtqtZXq2oIAy71+k/FF9CmpP9Nu0jLXurlCiIzh+zOUrDeOriswYINv2DBU3nL7QBLtax5f/dwdI99bFQYJyOXsBaThBoWj+DRQi1YECpqiRdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nfd/4S/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nfd/4S/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6981F000C8;
	Mon, 19 Oct 2026 14:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418425;
	bh=of1C+/M8BwjuAYp9FT+EIm9IrF5m8DlAapB+2n200kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nfd/4S/joHIXRf5MW3kWr62I1uJ1q/db+t0crcBZn+WZKREY+Zn3+b0cx0Xhxt90m
	 UqOzqYWOb00gg1smcMvFMSn11YdZzNNPed7IhStyv/xQVjdHn31wMUBEVai9Zgg9gt
	 UykFrU0KKqbwv1Dogi8Q5+HV6yLDed1fWY0dsZ2TuMmjfSSuQ1AvNa6Rp4ZsuCbuTY
	 2lu0daYzgSekX/xYJBIUI8QhqrrX1EuFC2mW7Jtl1XDJfBrWsVu5ZRrxEIAiSSohfj
	 9Dv5r9+6xLGbxBs3Z9Voo9VW1dhqqD05PsXBvrVR74U4f/Cn8IPNM3Y3O+30TWkgQL
	 EQgmgoGoj8ySQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yap Weei Choong <ywc8891@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shyam-sundar.S-k@amd.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] platform/x86/amd/pmc: Add T14 Gen2 AMD (20XL) to s2idle quirk list
Date: Mon, 19 Oct 2026 09:48:51 -0400
Message-ID: <20261019135441.1420968-240-sashal@kernel.org>
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

From: Yap Weei Choong <ywc8891@gmail.com>

[ Upstream commit e25fb2258bddbcf70df69d1358be3e1274bdc5f2 ]

The ThinkPad T14 Gen 2 AMD was sold under two machine types, 20XK and
20XL, but only 20XK has been in the s2idle quirk list since the quirk
was introduced in commit 455cd867b85b ("platform/x86: thinkpad_acpi:
Add a s2idle resume quirk for a number of laptops").

On 20XL machines the firmware SMI handler therefore still runs on the
NVMe D3->D0 transition when exiting suspend-to-idle. With IOMMU
translation enabled (the default), this intermittently stalls resume
for ~10.25 seconds: seven devices across three root ports (nvme, both
xhci_hcd functions, xhci-pci-renesas, snd_hda_intel x2, snd_rn_pci_acp3x)
block in pci_pm_resume_noirq and are released simultaneously, consistent
with all cores being held in SMM.

Add the missing 20XL machine type, mirroring the existing 20XK entry.
This is the same class of omission fixed by commit 9a469c6dfab3
("platform/x86: thinkpad_acpi: Add missing T14s Gen1 type to s2idle
quirk list").

Verified on a ThinkPad T14 Gen 2a (type 20XLS41C00, BIOS R1MET62W 1.32,
kernel 6.12.95): with this entry the quirk message appears at probe and
a 14-hour suspend resumes in ~1s with no noirq stalls, where previously
even short suspends could hit the ~10s delay. A further two-day soak
(short naps and two ~14-hour suspends) showed every resume clean.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221755
Signed-off-by: Yap Weei Choong <ywc8891@gmail.com>
Tested-by: Yap Weei Choong <ywc8891@gmail.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260717060744.1252065-2-ywc8891@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **Linux 7.3.0-rc4**
(`v7.3-rc4-27-gf0100363d8c37`). The candidate is `e25fb2258bddb`
(`platform/x86/amd/pmc: Add T14 Gen2 AMD (20XL) to s2idle quirk list`).
It is an 8-line DMI hardware-quirk addition: the sibling machine type
20XK has been quirked since 2022; 20XL was omitted, and that omission
causes ~10s s2idle resume stalls on T14 Gen 2 AMD.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[platform/x86/amd/pmc] [Add] [T14 Gen2 AMD machine type 20XL to
the existing s2idle DMI quirk list]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Link: https://bugzilla.kernel.org/show_bug.cgi?id=221755` — user-
  filed kernel bug
- `Link:
  https://patch.msgid.link/20260717060744.1252065-2-ywc8891@gmail.com` —
  lore submission
- `Signed-off-by: Yap Weei Choong <ywc8891@gmail.com>` (author)
- `Tested-by: Yap Weei Choong <ywc8891@gmail.com>` (author verified on
  hardware)
- `Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>` (AMD PMC
  author of the original quirk)
- `Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>`
  (platform-drivers-x86 maintainer)
- `Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>`
  (applied)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- No `Reported-by:` (bugzilla Link instead)
- Ignore any Sasha Levin SOB (none on the real commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** ThinkPad T14 Gen 2 AMD shipped as machine types 20XK and
  20XL. Only 20XK was listed when the quirk was added in `455cd867b85b`.
- **Symptom:** On 20XL, the firmware SMI still runs on NVMe D3→D0 at
  s2idle exit. With IOMMU on (default), resume stalls ~10.25s; seven
  devices on three root ports (`nvme`, both `xhci_hcd`, `xhci-pci-
  renesas`, `snd_hda_intel` x2, `snd_rn_pci_acp3x`) block in
  `pci_pm_resume_noirq` and wake together — consistent with all cores
  stuck in SMM.
- **Fix:** Add DMI entry 20XL mirroring 20XK. Same class of omission as
  `9a469c6dfab3` (missing T14s Gen1 type).
- **Versions:** Reproduced on kernel 6.12.95, BIOS R1MET62W 1.32, type
  20XLS41C00. After the quirk: 14-hour suspend resumes in ~1s; two-day
  soak was clean.
- **Root cause:** Incomplete DMI coverage of a known Lenovo firmware SMI
  bug, not a new kernel logic bug.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. Explicit hardware quirk for a
documented firmware bug. The verb is "Add" because that is how DMI quirk
tables are extended.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/platform/x86/amd/pmc/pmc-quirks.c` — **+8 / −0**
- Function: none; static `fwbug_list[]` table only
- Scope: single-file surgical DMI addition

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** DMI match for LENOVO/`20XK` applies
  `quirk_s2idle_spurious_8042`. LENOVO/`20XL` does not match, so
  `amd_pmc_quirks_init()` leaves `dev->quirks` unset for 20XL.
- **After:** 20XL matches the same quirk. Probe logs the s2idle quirk;
  `amd_pmc_process_restore_quirks()` runs
  `amd_pmc_skip_nvme_smi_handler()` on s2idle restore;
  `disable_8042_wakeup` is also set (same as 20XK).
- Path: probe (`amd_pmc_quirks_init`) and s2idle restore
  (`amd_pmc_s2idle_restore` → `amd_pmc_process_restore_quirks`). DMI-
  gated; other machines unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** Hardware workaround (DMI quirk table entry)
- **Mechanism:** Skip the Lenovo BIOS SMI on NVMe D3→D0 by clearing bit
  0 at `FCH_PM_BASE + FCH_PM_SCRATCH` (`0xFED80380` / SI3R) before the
  D0 transition. 20XL never got that skip.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: identical copy of the adjacent 20XK entry with
  product name `20XL`.
- Minimal: 8 lines, no API/locking/refactor.
- Regression risk: very low. Only DMI-matched 20XL machines. False-
  positive would require another Lenovo product whose DMI product name
  contains `20XL`; Lenovo machine types are 4-character prefixes and
  existing entries (`20XK`, `20XF`, `20XH`, …) use the same pattern.
- Red flags: none.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- 20XK block: `e8ef8dd28c4c4` (Mario Limonciello, 2023-07-10) — moved
  the quirk from `thinkpad_acpi` into amd-pmc.
- 20XK `driver_data`: later `5b9e07551faa7` (2025-07-24) switched it to
  `&quirk_s2idle_spurious_8042`.
- 20XL block: `e25fb2258bddb` (Yap Weei Choong, 2026-07-17) — this
  candidate.
- Original 20XK-only list: `455cd867b85b` (2022-04-28, `thinkpad_acpi`).
  `git show 455cd867b85b` contains `20XK` and **not** `20XL`.
- Bug present since v5.18-era quirk introduction; still present after
  the 2023 move into amd-pmc.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Referenced history:
- `455cd867b85b` — **is an ancestor of HEAD** (`git merge-base --is-
  ancestor` exit 0). Introduced the quirk; listed T14 Gen2 as 20XK only.
- `9a469c6dfab3` — **is an ancestor of HEAD**. Precedent: add the
  missing second Lenovo machine type (T14s Gen1 20UJ beside 20UH). Same
  8-line DMI pattern.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `pmc-quirks.c` work is more DMI quirk rows (Legion Go 2,
Yoga 6, MECHREVO, TUXEDO, L14 Gen3, suspend delay). No refactor that
this depends on. `git log e25fb2258bddb..HEAD -- pmc-quirks.c` shows no
later edits of the 20XL entry. Standalone, not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Yap Weei Choong has this single commit under
`drivers/platform/x86/amd/`. Mario Limonciello (reviewer) originated the
quirk and maintains this table. Ilpo Järvinen applied it as platform-
drivers-x86 maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: On this tree the patch assumes `fwbug_list[]` and
`quirk_s2idle_spurious_8042` in `pmc-quirks.c`. Both exist.
`amd_pmc_quirks_init()` / `amd_pmc_process_restore_quirks()` exist in
`pmc.c`. Applies standalone here.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c e25fb2258bddb` →
  https://patch.msgid.link/20260717060744.1252065-2-ywc8891@gmail.com
- `b4 dig -a`: **v1 only**; committed version is that v1.
- Thread (mbox): (1) author submission, (2) Mario `Reviewed-by` with no
  requests, (3) Ilpo applied as `[1/1]` to `review-ilpo-next`.
- No NAK. No reviewer `Cc: stable`. Ilpo’s boilerplate: fixes usually go
  via for-next unless they are this-cycle or a clear regression — that
  explains missing `Cc: stable`, not unsuitability for later stable
  backport.
- Lore HTTP 403 from this environment; thread recovered via `b4 dig -m`
  and Openwall/Patchew mirrors.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To `platform-driver-x86@vger.kernel.org`; Cc Hans,
Ilpo, Shyam-sundar.S-k@amd.com (MAINTAINERS for AMD PMC), Mario, linux-
kernel. Right lists and both AMD PMC and PDx86 maintainers.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Bugzilla 221755 linked; HTTP 403, so **bugzilla comments are
UNVERIFIED**. Commit body itself is a first-hand report: machine type
20XLS41C00, BIOS, 6.12.95, 10.25s stall, soak test. Patchew lists a
single-patch series.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: msgid `…-2` is git-send-email numbering. Ilpo applied `[1/1]`;
Patchew: “posted 1 patch”. Standalone.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: WebSearch of lore stable for this subject found **no**
discussion of 20XL / this commit. No recorded reason to keep it out of
stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function body edited. Table consumers:
`amd_pmc_quirks_init()`, `amd_pmc_process_restore_quirks()`,
`amd_pmc_skip_nvme_smi_handler()`. semcode MCP: not available; used `git
grep`.

**Step 5.2: TRACE CALLERS**
Record:
- `amd_pmc_quirks_init(dev)` from `amd_pmc_probe()` in `pmc.c` when
  `CONFIG_SUSPEND` and `!disable_workarounds`.
- `amd_pmc_process_restore_quirks(pdev)` from
  `amd_pmc_s2idle_restore()`, the LPS0 `.restore` callback
  (`acpi_register_lps0_dev`).
- Impact: AMD notebook s2idle resume, DMI-limited to 20XL.

**Step 5.3: TRACE CALLEES**
Record: `dmi_first_match(fwbug_list)`; on match, skip SMI via
`request_mem_region_muxed` / `ioremap` / `iowrite8(val & ~BIT(0))` at
FCH PM scratch. Same path 20XK already uses.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace suspend (s2idle, default on modern AMD laptops) → ACPI
LPS0 restore → skip SMI. Reachable on every suspend/resume of a 20XL T14
Gen 2 AMD. Unprivileged users typically can suspend.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same file already pairs Gen1 T14 as 20UD+20UE and T14s as
20UH+20UJ. T14 Gen2 was 20XK only until this commit — same hole
`9a469c6dfab3` fixed for T14s Gen1.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: **7.3.0-rc4** (mainline).
- File and `fwbug_list` exist. 20XK exists. 20XL **is present** because
  `e25fb2258bddb` is already an ancestor of HEAD (`git merge-base --is-
  ancestor` exit 0). That is the mainline landing, not a reason to
  reject the fix on technical merit.
- Pre-commit state (20XK without 20XL) is what this patch corrects. The
  omission dates to `455cd867b85b` (2022).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: On this tree the hunk applies cleanly against the 20XK block.
Expected difficulty: **clean apply**. (Older stables that still keep the
table in `thinkpad_acpi.c` would need the same 8 lines next to 20XK
there; that is not this checkout.)

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No alternate 20XL fix. `git grep 20XL` hits only this new `pmc-
quirks.c` entry. `9a469c6dfab3` is the analogous T14s fix, already here.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/platform/x86/amd/pmc/` — AMD PMC s2idle. **IMPORTANT**
for AMD Ryzen notebooks (`CONFIG_AMD_PMC`, depends on ACPI/PCI/SUSPEND).
Not core mm/VFS, but suspend/resume on a current ThinkPad SKU.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained; frequent DMI quirk additions. Table is the
supported way to fix firmware s2idle bugs. MAINTAINERS: Shyam Sundar S
K; Mario is the quirk author and reviewed this patch.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / DMI-specific: Lenovo ThinkPad T14 Gen 2 AMD
machine type **20XL** (e.g. 20XLS41C00). 20XK already quirked.
CONFIG_AMD_PMC + s2idle.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: s2idle suspend/resume with IOMMU (default). Intermittent but
seen on short suspends; 10s stall. Users who close the lid trigger it.
Not a theoretical race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Failure: ~10s resume hang; PCI noirq waiters; all cores in SMM.
  Original quirk commit also documented IOMMU page faults and post-
  resume instability on this firmware SMI.
- Severity: **HIGH** (multi-second system hang on resume; possible IOMMU
  faults). Not a panic on every resume, but a serious production laptop
  bug.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: **high** for 20XL owners (resume ~1s vs ~10s; matches 20XK).
- Risk: **very low** (8 lines, DMI-gated, copies a years-old entry).
- Ratio: strongly favors backport. Hardware-quirk exception category.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real firmware bug; missing second machine type of a known model
- ~10s s2idle resume stall, PCI noirq pileup, SMM hold; original class
  also caused IOMMU page faults
- Hardware quirk / DMI ID — explicit stable exception
- 8 lines, copy of 20XK, no new API
- Tested on hardware (6.12.95, 14h suspend, two-day soak)
- Reviewed by Mario Limonciello and Ilpo Järvinen
- Precedent: `9a469c6dfab3` did the same for T14s Gen1
- Bugzilla 221755; infrastructure present in this tree since 2023
  (`e8ef8dd28c4c4`)
- Applies cleanly beside 20XK

AGAINST:
- No `Cc: stable` (expected; Ilpo routed via for-next)
- Affects one ThinkPad SKU, not all users
- Bugzilla page itself could not be fetched (403)

UNRESOLVED:
- Full bugzilla 221755 comment thread (403)
- Direct lore.kernel.org HTML (403); mbox + mirrors were enough

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — identical 20XK entry; author
   soak-tested; AMD + PDx86 review
2. Fixes a real bug that affects users? **PASS** — 20XL s2idle stall,
   bugzilla, hardware verification
3. Important issue? **PASS** — HIGH: resume hang / SMM stall; original
   bug class includes IOMMU faults
4. Small and contained? **PASS** — +8 lines, one table
5. No new features or APIs? **PASS** — DMI row for existing quirk
6. Can apply to the local tree? **PASS** — `pmc-quirks.c` + 20XK +
   `quirk_s2idle_spurious_8042` present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk/workaround** (DMI s2idle quirk), same class as
USB/PCI/codec quirk table additions. Automatically stable-appropriate.

**Step 9.4: MAKE YOUR DECISION**
This is a textbook stable backport: a missing DMI match for a known
firmware SMI bug on a shipping ThinkPad, eight lines, already reviewed
and tested. It belongs in this tree’s stable lineage.

===============================================================
DETAILED EXPLANATION
===============================================================

**Problem:** T14 Gen 2 AMD has two Lenovo machine types. The kernel has
skipped a resume-time NVMe SMI on 20XK since 2022. 20XL never matched,
so firmware still traps into SMM on s2idle resume, stalling the machine
~10 seconds (and historically this SMI also caused IOMMU page faults).

**Stable rules:** Obviously correct, user-visible, small, no new API.
Hardware-quirk exception applies.

**Risk vs benefit:** Benefit is restoring normal ~1s resume on 20XL.
Risk is a DMI match that can only fire on 20XL-like product names. No
locking or core-path change.

**Concerns:** None material on this 7.3-rc4 tree. The patch does not
need other series members. Older stables that still keep the list in
`thinkpad_acpi.c` would place the same row next to 20XK; that does not
apply here.

===============================================================
VERIFICATION
===============================================================

Verification:
- [Phase 1] Subject/tags parsed from `git log -1 e25fb2258bddb`: Add DMI
  quirk; Links bugzilla 221755 and msgid; Tested-by author; Reviewed-by
  Mario Limonciello and Ilpo Järvinen; no Fixes/Cc-stable
- [Phase 1] Body: 10.25s s2idle stall on 20XL; verified 20XLS41C00 /
  BIOS R1MET62W / 6.12.95
- [Phase 2] `git show e25fb2258bddb`: +8 lines in `fwbug_list[]` only;
  LENOVO/`20XL` → `quirk_s2idle_spurious_8042`
- [Phase 2] Read `pmc-quirks.c`: skip SMI in
  `amd_pmc_skip_nvme_smi_handler()`; 20XK block immediately above
- [Phase 3] `git blame -L 66,82 pmc-quirks.c`: 20XK from `e8ef8dd28c4c4`
  (2023); 20XL from `e25fb2258bddb`
- [Phase 3] `git merge-base --is-ancestor 455cd867b85b HEAD` → 0; `git
  show` confirms original list has 20XK, not 20XL
- [Phase 3] `git merge-base --is-ancestor 9a469c6dfab3 HEAD` → 0; same
  8-line missing-type pattern for T14s 20UJ
- [Phase 3] Author log: only this amd/pmc commit; no later 20XL edits
- [Phase 4] `b4 dig -c e25fb2258bddb`: lore msgid
  20260717060744.1252065-2
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: PDx86 list, Hans, Ilpo, Shyam, Mario
- [Phase 4] `b4 dig -m /tmp/thread.mbox`: Mario Reviewed-by; Ilpo
  applied [1/1]; no NAK; for-next routing note
- [Phase 4] Openwall/Patchew mirrors confirm the same thread; Patchew “1
  patch”
- [Phase 4] lore.kernel.org HTTP 403; bugzilla 221755 HTTP 403
- [Phase 4] Stable-list search: no hits for this subject
- [Phase 5] `git grep amd_pmc_quirks_init`: probe in `pmc.c:938`;
  restore via `amd_pmc_s2idle_restore` →
  `amd_pmc_process_restore_quirks`
- [Phase 5] semcode unavailable; callers from grep/read
- [Phase 6] `make kernelversion` / `git describe HEAD`: 7.3.0-rc4 /
  v7.3-rc4-27-gf0100363d8c37
- [Phase 6] `git merge-base --is-ancestor e25fb2258bddb HEAD` → 0
  (commit already in this mainline checkout)
- [Phase 6] File and 20XK entry present; hunk would apply cleanly to the
  pre-commit 20XK block
- [Phase 7] Kconfig AMD_PMC: AMD Ryzen notebook s2idle; MAINTAINERS
  Shyam / PDx86
- [Phase 8] Failure mode from commit + `455cd867b85b`: SMM resume stall
  / possible IOMMU faults; HIGH; DMI-limited
- UNVERIFIED: bugzilla 221755 comment text (403)
- UNVERIFIED: live lore HTML (403); mbox used instead

The patch is a contained hardware quirk for a real s2idle hang on T14
Gen 2 AMD 20XL and meets stable criteria on this tree.

**YES**

 drivers/platform/x86/amd/pmc/pmc-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 74ddf1d8289a9..09a30f3337596 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -71,6 +71,14 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "20XK"),
 		}
 	},
+	{
+		.ident = "T14 Gen2 AMD",
+		.driver_data = &quirk_s2idle_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "20XL"),
+		}
+	},
 	{
 		.ident = "T14 Gen1 AMD",
 		.driver_data = &quirk_s2idle_spurious_8042,
-- 
2.53.0

