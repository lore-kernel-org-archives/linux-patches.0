Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDFE596089;
	Mon, 19 Oct 2026 13:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418343; cv=none; b=ZJfrSfFH1sK1kVLjuTu4v8Hk74gkVbYM8XoNihOkxWjeNdkmLze5e2aJVVnEp/RX0BLrPSoHVZ7+hG6NO4e8TmXFewQ3GbBH4qbW+mqObFknO46i/mtCmwqVMx4A/Pa/BUi2JyG3DVbcPIlEArOg22AbC58JiIPZRowjM8WwyNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418343; c=relaxed/simple;
	bh=eXPkSbZty3nJgx67BUK5Exqfe2uKhV5SjWL73GvIeKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gbCChLtH/zb31fotrzXGmHYRccX/TCTbul+QquQ05mRMG+OjS+XNAbz2jOWD/AUEQmlCXK+C26VcCl/MSMICktnrQxRjMvC2S4reoLcvXe+Sy7gQ4rkV5emEweLbk+f/8UjCVxMlP228YLgbXu+1DCDjKCEjt7V/siLrlsBqtTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nExBARQ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nExBARQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D8E1F000C8;
	Mon, 19 Oct 2026 13:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418340;
	bh=ydWsISwGVhAYduRngYKtRJeZzj1G2o3+akZSzVQmqWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nExBARQ7627TYLL+NmYef9ik0FN4HVzhZsVOHprdNBocvcFnxjiO+OqBzc+VHIWuD
	 ahS+b63x4qhg6qX9j9SqD2UdsLjjq5VIgcmK+msJh6Jr6Neg2IS1Jl1+o/PjoY+ORZ
	 MPXv4i20YCudYAlKZfswkW6ljkYM6nBhsjbiZxU4/MZNa3YTzuN1IBUesEL0QRJTJz
	 X8T1MgzmINMV+UjQjkq0QM3alopAL5zJjjhdqkIpyUkednkNqUv5qhj5NAFg8HzhMc
	 Y3cWXSQU+31PZB9rLBylwUBxKW5HUoWhTdXh0me264qWkksqJkQj+0KzDWpv89Rlu/
	 unGL/3nvQ+Eyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Robin Everaars <robineveraars@pm.me>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ACPI: button: Add DMI quirk for Razer Blade Pro 17 early 2020 lid switch
Date: Mon, 19 Oct 2026 09:47:49 -0400
Message-ID: <20261019135441.1420968-178-sashal@kernel.org>
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

From: Robin Everaars <robineveraars@pm.me>

[ Upstream commit 415125669c2ddc773c579a60df108f75712dfa83 ]

The lid switch reports "close" but can miss the matching "open", leaving
_LID closed after resume. systemd-logind then suspends the system again
roughly every 35 seconds.

Reading the embedded controller's PSTA byte while _LID is stale shows that
bit 0x04 is set, which the DSDT treats as open. The DSDT returns the cached
LIDS byte from _LID. Its wake path aborts in RTEC on an unhandled
SystemCMOS region before copying PSTA to LIDS.

Initialize the lid state to open on resume, matching the existing quirk
for the Razer Blade Stealth 13 late 2019. With
button.lid_init_state=open, a physical close suspended once and resume
reported open without another suspend.

Signed-off-by: Robin Everaars <robineveraars@pm.me>
Link: https://patch.msgid.link/20260817141414.213075-1-robineveraars@pm.me
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a DMI-scoped lid quirk, the buggy path
exists in 6.12, and the patch applies here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ACPI] [Add] [DMI quirk for Razer Blade Pro 17 early 2020 lid
switch]
Subsystem prefix: `ACPI: button:`. Action verb: **Add**. Claimed intent:
add a DMI match so this laptop initializes lid state as open, matching
an existing Razer quirk.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Robin Everaars <robineveraars@pm.me> (author)
- Link:
  https://patch.msgid.link/20260817141414.213075-1-robineveraars@pm.me
- Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com> (ACPI
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence expected for this review)
- Ignore any pipeline "Upstream commit" / "Signed-off-by: Sasha Levin"
  markers

Notable: ACPI maintainer applied it. No syzbot/KASAN. Hardware-quirk
report from the machine owner.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: lid reports "close" but can miss the matching "open"; `_LID`
  stays closed after resume.
- Symptom: systemd-logind re-suspends roughly every 35 seconds (suspend
  loop).
- Root cause (firmware): EC PSTA bit 0x04 is set (DSDT treats that as
  open), but `_LID` returns cached LIDS. Wake path aborts in RTEC on an
  unhandled SystemCMOS region before copying PSTA to LIDS.
- Fix: DMI quirk `ACPI_BUTTON_LID_INIT_OPEN`, same as Razer Blade
  Stealth 13 late 2019.
- Test: with `button.lid_init_state=open`, a physical close suspended
  once; resume reported open; no second suspend.
- Version info: none in the message. Commit is in v7.3-rc1 (`git
  describe --contains` → `v7.3-rc1~39^2^3`).

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit hardware quirk for a
firmware lid bug. The "Add" verb here is the standard DMI-quirk
exception, not a new feature.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/acpi/button.c` (+11 / -0)
- Function/data: `dmi_lid_quirks[]` only
- Scope: single-file surgical DMI table addition
- Commit: `415125669c2ddc773c579a60df108f75712dfa83`

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: this DMI identity is unmatched;
  `acpi_button_register_driver()` sets `lid_init_state =
  ACPI_BUTTON_LID_INIT_METHOD` (evaluate `_LID`).
- After: match vendor `"Razer"` + product `"Blade Pro 17 (Early 2020) -
  RZ09-0329"` → `ACPI_BUTTON_LID_INIT_OPEN`.
- Affected path: lid init on first userspace open
  (`acpi_lid_input_open`) and on resume (`acpi_button_resume` →
  `acpi_lid_initialize_state` → `acpi_lid_notify_state(device, 1)`).
- Other machines: unchanged (`dmi_first_match` is exact).

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Hardware workaround / DMI quirk]
Broken: firmware `_LID` stuck closed after resume; userspace treats that
as lid-closed and suspends again.
Fix: report lid open on init/resume for this DMI ID, same as existing
Razer/Medion/Samsung entries.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct and minimal. Regression risk is confined to
this DMI string. If the lid is truly closed at resume from another
wakeup source, init-open can delay one close report until the next close
notify; that is the established tradeoff for this quirk class (Stealth
13 late 2019, Medion, Samsung). No API/locking/refcount changes.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Insertion is between:
- `0528904926aab` (2020-01-02) Razer Blade Stealth 13 late 2019, same
  `ACPI_BUTTON_LID_INIT_OPEN` pattern
- `8fa73ee44daef` (2024-10-20) Samsung Galaxy Book2, same pattern, `Cc:
  All applicable <stable@vger.kernel.org>`
- Table exists since `d7cd08231a7fa` (2019-10-28)
The "bug" is firmware on a 2020 laptop; the kernel quirk table has been
in this driver for years.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. Firmware defect, not a kernel
regression from a specific SHA.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record (this tree, last 20 on `drivers/acpi/button.c`): other DMI lid
quirks (Lenovo Yoga 9, Medion E2228T, Nextbook Ares 8A, Samsung Galaxy
Book2) plus unrelated notify/input_free_device changes. No prerequisite
refactor required for this table entry.
Standalone, not patch X/Y.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: `git log --author='Robin Everaars' -- drivers/acpi/` is empty in
this tree. Author is a hardware reporter, not the ACPI maintainer.
Weight comes from Rafael applying it and from matching an existing
quirk.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Depends only on `dmi_lid_quirks[]` and
`ACPI_BUTTON_LID_INIT_OPEN`, both present. Later mainline converted
`acpi_button_add` → `acpi_button_probe`; that is after 6.12 and not
required. A later mailing-list patch for Blade Stealth 13 Early 2020
(RZ09-0310) is a sibling quirk, not a dependency. Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 415125669c2dd`:
  https://patch.msgid.link/20260817141414.213075-1-robineveraars@pm.me
- `b4 dig -a`: v1 msgid `20260817133259.195548-1-robineveraars@pm.me`,
  v2 same code; v1 was unapplicable because Proton OpenPGP/MIME inserted
  line breaks. No logic review changes.
- Rafael: "Applied as 7.3-rc material, thanks!" No NAK, no stable
  discussion in-thread.
- lore.kernel.org WebFetch returned 403; discussion recovered via b4,
  Patchew, and openwall.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc Rafael J. Wysocki, Len Brown, linux-acpi,
linux-kernel. Maintainer applied it. No extra Reviewed-by.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot Link. Evidence is the author's firmware
analysis (PSTA vs LIDS/RTEC) and the `lid_init_state=open` test. Same
class as the 2020 Stealth 13 quirk ("systemd continuously re-suspend the
laptop every 30s"). UserBenchmark/Geekbench and linux-hardware.org Razer
probes support the product-name form `Blade … - RZ09-xxxx` with vendor
`Razer`.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone v2. Related later proposal: Ian Gallagher, Blade
Stealth 13 Early 2020 RZ09-0310, which cites this Pro 17 entry as
already in tree. Not required for this backport.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: WebSearch of lore.kernel.org/stable for this model found no
prior stable request or rejection. UNVERIFIED at the individual-message
level because lore WebFetch is 403.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body changed. Data: `dmi_lid_quirks[]`. Consumers:
`acpi_button_register_driver()`, `acpi_lid_initialize_state()`.

Step 5.2: TRACE CALLERS
Record:
- `acpi_button_register_driver()`: module/driver init;
  `dmi_first_match(dmi_lid_quirks)` if `lid_init_state == -1`.
- `acpi_lid_initialize_state()`: from `acpi_button_resume()`
  (CONFIG_PM_SLEEP) and `acpi_lid_input_open()` (userspace opens
  `/dev/input` lid switch).
- Not IRQ/hot-path; boot and resume/open.

Step 5.3: TRACE CALLEES
Record: `ACPI_BUTTON_LID_INIT_OPEN` → `acpi_lid_notify_state(device, 1)`
reports SW_LID open. No alloc/new locks.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace-reachable: logind/systemd reads the lid input device
and acts on SW_LID. Trigger is close-lid suspend then resume with lid
open — normal laptop use. Unprivileged user can trigger by closing the
lid.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same `ACPI_BUTTON_LID_INIT_OPEN` DMI entries already in this
tree for Lenovo 82BG, Medion E2215T/E2228T, Razer Stealth 13 Late 2019,
Samsung 750XED. This is another instance of a known firmware class, not
a new mechanism.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Tree: `pending-6.12`, `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`,
  `make kernelversion` = **6.12.111**
- `dmi_lid_quirks[]` present; Stealth 13 quirk present; **no**
  `RZ09-0329` / Blade Pro 17 entry
- `git merge-base --is-ancestor 415125669c2dd HEAD` → not an ancestor
  (not in this tree)
- Quirk infrastructure since 2019; bug is firmware on 2020 hardware,
  relevant to 6.12

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: `git show 415125669c2dd | git apply --check` succeeded (hunk at
line 130, offset -3). Difference vs mainline is later
`acpi_button_probe` conversion, not the DMI table. Expected: **clean
apply**.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No RZ09-0329 match. No other 6.12 commit with this subject (`git
log --grep='Razer Blade Pro 17' -- drivers/acpi/button.c` empty).
Samsung/Stealth 13 quirks are related pattern, not a substitute for this
DMI ID.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [ACPI button / laptop lid] [IMPORTANT]
`CONFIG_ACPI_BUTTON` default y. Lid events drive suspend on essentially
all ACPI laptops. Not mm/core, but suspend-loop is user-visible
stability.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: This 6.12 file is mature (quirks since 2019). Mainline later did
a large button.c rework (platform device, devres); that churn is **not**
in this tree. The DMI table is the stable part.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / DMI-specific: Razer Blade Pro 17 Early 2020
(RZ09-0329) only. ACPI button is default-y, so those laptops on 6.12 are
in scope.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Close lid → suspend → open lid/resume. Common laptop path.
Unprivileged user can trigger. Not a narrow error path.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [Suspend loop ~every 35s] [HIGH]
Not a panic, but the machine cannot stay awake after lid-wake. Matches
historical "systemd re-suspend every 30s" reports. Data-loss risk if
unsaved work is interrupted by repeated suspend.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: HIGH for that model (fixes unusable suspend/resume)
- Risk: VERY LOW (11-line DMI entry, no other machines)
- Ratio: strongly favors backport

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real user-visible bug: lid stuck closed → logind suspend loop
- Hardware quirk exception (DMI table), explicitly allowed in stable
- Same mechanism as Stealth 13 late 2019 (in this tree since 2020) and
  Samsung Galaxy Book2 (`Cc: stable`)
- 11 lines, one file, no APIs
- Applies cleanly to 6.12.111
- ACPI maintainer applied as 7.3-rc
- Author tested `lid_init_state=open`
- DMI product string matches later Razer naming (`Blade … - RZ09-xxxx`)

AGAINST:
- Affects one laptop model, not all users
- No Fixes:/Cc: stable in the commit (expected; not a negative)
- Author tested the module param; DMI match correctness is inferred from
  the string they submitted (if wrong, quirk is a no-op, not a
  regression)

UNRESOLVED:
- lore.kernel.org HTTP 403; thread recovered via b4/Patchew/openwall
- No independent kernel bugzilla duplicate found
- Stable list not confirmed message-by-message (search found nothing)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — copy of existing quirk;
   author + maintainer
2. Fixes a real bug that affects users? **PASS** — suspend loop after
   resume
3. Important issue? **PASS** — HIGH: system re-suspends every ~35s
   (hang/unusable, not a panic)
4. Small and contained? **PASS** — +11 lines, one DMI entry
5. No new features or APIs? **PASS** — quirk table only
6. Can apply to the local tree? **PASS** — `git apply --check` clean;
   table present

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk/workaround** (DMI lid_init_state). Automatic
stable-qualifier.

Step 9.4: MAKE YOUR DECISION
This tree is 6.12.111. The quirk table and `ACPI_BUTTON_LID_INIT_OPEN`
exist; the RZ09-0329 entry does not. The patch is a small, model-scoped
workaround for a firmware lid bug that leaves the laptop in a suspend
loop. That is exactly the class of DMI quirk stable already carries for
this driver.

What it solves for 6.12 users: after closing the lid, resume can leave
`_LID` closed while the lid is open; systemd-logind then suspends again.
The quirk reports open on resume for this DMI ID only.

Risk vs benefit: benefit is restoring normal lid/suspend on this 2020
Razer; risk is a no-op on every other machine.

No dependencies, no backport rework, no new API.

Verification:
- [Phase 1] Parsed tags: author SOB, Rafael SOB, Link msgid
  `20260817141414.213075-1-robineveraars@pm.me`; no Fixes/Reported-
  by/Cc: stable
- [Phase 1] Body: `_LID` stale closed after resume; logind re-suspend
  ~35s; PSTA/LIDS/RTEC firmware explanation; tested
  `button.lid_init_state=open`
- [Phase 2] Diff: +11 lines in `dmi_lid_quirks[]` only;
  `ACPI_BUTTON_LID_INIT_OPEN` for Razer / `Blade Pro 17 (Early 2020) -
  RZ09-0329`
- [Phase 2] Local `acpi_lid_initialize_state()` OPEN case calls
  `acpi_lid_notify_state(device, 1)`; resume and `acpi_lid_input_open`
  both call it
- [Phase 3] Blame: Stealth 13 quirk `0528904926aab` (2020); Samsung
  `8fa73ee44daef` (2024, Cc: stable); table from `d7cd08231a7fa` (2019)
- [Phase 3] No Fixes: tag; standalone; no Robin Everaars history in this
  ACPI tree
- [Phase 4] `b4 dig -c 415125669c2dd`: v2 URL; `b4 dig -a`: v1→v2, PGP
  wrapping only; `b4 dig -w`: Rafael, Len Brown, linux-acpi
- [Phase 4] Patchew: Rafael "Applied as 7.3-rc material, thanks!"; no
  NAK
- [Phase 4] lore WebFetch 403; UNVERIFIED raw lore HTML
- [Phase 5] Callers: `acpi_button_register_driver` (init),
  `acpi_button_resume`, `acpi_lid_input_open`; userspace lid/logind path
- [Phase 5] Similar OPEN quirks already in this file for
  Lenovo/Medion/Razer/Samsung
- [Phase 6] `git describe HEAD` p-6.12-3-gc504cf0baa3d8; kernelversion
  6.12.111; `merge-base --is-ancestor 415125669c2dd HEAD` false
- [Phase 6] `git apply --check` succeeded at offset -3
- [Phase 6] Grep: no RZ09-0329 in this tree
- [Phase 7] MAINTAINERS ACPI: Rafael Wysocki; `CONFIG_ACPI_BUTTON`
  default y
- [Phase 8] Failure mode: suspend loop; severity HIGH; DMI-scoped; risk
  very low
- [Phase 3/4] Commit `415125669c2dd` is `v7.3-rc1~39^2^3` on
  origin/master
- UNVERIFIED: individual stable@ thread bodies (lore 403); exact
  dmidecode dump of the author's machine (string is consistent with
  other 2020+ Razer DMI names)

**YES**

 drivers/acpi/button.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 384caea90ce5f..4ddaee8955c30 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -132,6 +132,17 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
+	{
+		/*
+		 * Razer Blade Pro 17 early 2020, notification of the LID device
+		 * only happens on close, not on open and _LID keeps returning closed.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade Pro 17 (Early 2020) - RZ09-0329"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{
 		/*
 		 * Samsung galaxybook2 ,initial _LID device notification returns
-- 
2.53.0

