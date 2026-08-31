Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92CA471D16;
	Mon, 31 Aug 2026 13:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183318; cv=none; b=H5YAxV84gPd40oPcoQeF4SQo9mJkpbLxVD4o3+7KdDAqIXuxLyYVAc1gKxMmfKs6ynGZgEWBOFBI0fA21GAPjq04t1cd9/Vlx6E6UlDV8bSTIx4IaXu3/JW8UPLk2x9a+VFEVk1b4lxl6nzurXX2VjREscNyipWi+1O060ClNCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183318; c=relaxed/simple;
	bh=QIq5xOs9tJx1RW+zdVX0iUSBuvf3LzBhaXiIkg8+nUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTxXg3oGE08yHry7zn2njbVW7iJrOoQzaBfeFeUszkhnchl5+5WI0tH1RPjcJB+Z26obuuntYbq/I1kJTJc1tVyGgA6t8oXALabI+LmrsrYF3COt5FAh46DF/p+IpBW8hIA655wppEQE1H+/M8oJXNqkkPyufN2VEivltEDFMVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VyQbj6NY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VyQbj6NY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82391F00A3E;
	Mon, 31 Aug 2026 13:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183315;
	bh=gkkilCCaBb/bCg04OyylRmI/xG9+oB/GrFqHSYyN5Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyQbj6NY4A2x/UnMST4J0ng8dxRuHopmGAvZklO3soqG9eaCMq/U8lrkclSEY95Zq
	 BU6JU+BHYz14oqto3xxNI/JkRauYwTkfElc2XIzqZJ60oGdk9B6wAJJQXw43L+yqVq
	 CYkbL6R2XmXgTycp6ugvOCLVL3efzez32bwIe84jfS4CtBgljFzPkDrV5kCKKwlyFd
	 4KHH/+A/YqrUJgAVSMCkDEGAXIqRCx71nITqTEtiRiXNDeQ0Yw4qaFgptMkIIYMhwy
	 jRr4CmdAZXrG7dEputRC/lpUTpJIWHOU/gWj4Fp3CihdRW0uDc6Q2jJgh3HRY7V1aP
	 zQTzmotalmdvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	maciej.wieczor-retman@intel.com,
	pawel.chmielewski@intel.com,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: Fix NULL pointer dereference in acpi_ns_custom_package()
Date: Mon, 31 Aug 2026 09:21:43 -0400
Message-ID: <20260831133314.4125787-75-sashal@kernel.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit f8d14b7bb0063bbbd86c0e4d73edb8cea7b362bc ]

acpi_ns_custom_package() unconditionally dereferences the first element
of the package to read the _BIX version number, without checking for
NULL:

    if ((*Elements)->Common.Type != ACPI_TYPE_INTEGER)

When firmware returns a _BIX package whose first element is an
unresolvable reference, ACPICA evaluates that entry to NULL.
acpi_ns_remove_null_elements() does not strip NULL entries for
ACPI_PTYPE_CUSTOM packages (fixed-position format would break if
elements were shifted), so acpi_ns_custom_package() sees the NULL
and causes a crash.

Add a NULL check for the first element (version field) before
dereferencing it. The caller then receives AE_AML_OPERAND_TYPE
instead of crashing.

Link: https://github.com/acpica/acpica/commit/f3f111b9013b
Reported-by: Xiang Mei <xmei5@asu.edu>
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5674388.Sb9uPGUboI@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ACPICA NULL Pointer Dereference in
`acpi_ns_custom_package()`

**Local tree:** Linux **6.18.44** (`v6.18.44`, `stable/linux-6.18.y`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
**Record:** `[ACPICA] [fix] NULL pointer dereference in
acpi_ns_custom_package()` — ACPI namespace package validation for
predefined methods.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Link:** https://github.com/acpica/acpica/commit/f3f111b9013b
  (upstream ACPICA commit)
- **Reported-by:** Xiang Mei \<xmei5@asu.edu\>
- **Reported-by:** Weiming Shi \<bestswngs@gmail.com\> (two independent
  reporters)
- **Signed-off-by:** Rafael J. Wysocki \<rafael.j.wysocki@intel.com\>
  (ACPI maintainer)
- **Link:** https://patch.msgid.link/5674388.Sb9uPGUboI@rafael.j.wysocki
- No `Fixes:` tag (expected for manual review)
- No `Cc: stable@vger.kernel.org` (expected)
- Notable: two real-world reporters; no syzbot

### Step 1.3: Analyze the Commit Body Text
**Record:**
- **Bug:** `acpi_ns_custom_package()` dereferences `(*elements)` to read
  the `_BIX` version field without checking for NULL.
- **Trigger:** Firmware returns a `_BIX` package whose first element is
  an unresolvable reference → evaluates to NULL.
  `acpi_ns_remove_null_elements()` intentionally does not strip NULLs
  from `ACPI_PTYPE_CUSTOM` packages (fixed-position semantics).
- **Symptom:** Kernel crash (NULL pointer dereference) instead of a
  controlled validation error.
- **Fix behavior:** Return `AE_AML_OPERAND_TYPE` with a warning,
  matching existing invalid-type handling.
- **Version info:** None specified; bug is in long-standing code.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not hidden — explicitly labeled as a NULL pointer
dereference fix. Clear bug-fix commit.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `drivers/acpi/acpica/nsprepkg.c` (+7 lines, 0 removed)
- **Function modified:** `acpi_ns_custom_package()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Understand the Code Flow Change
**Record:**
- **Hunk (before):** Immediately dereferences `(*elements)->common.type`
  to validate the version integer.
- **Hunk (after):** Adds `if (!(*elements))` guard with
  `ACPI_WARN_PREDEFINED` and early return of `AE_AML_OPERAND_TYPE`
  before any dereference.
- **Path affected:** Predefined-method package validation for `_BIX`
  (`ACPI_PTYPE_CUSTOM`).

### Step 2.3: Identify the Bug Mechanism
**Record:**
- **Category:** NULL pointer dereference (memory safety)
- **Mechanism:** Missing NULL check before pointer dereference on
  package element array; NULL elements are intentionally preserved for
  custom fixed-position packages.

### Step 2.4: Assess the Fix Quality
**Record:**
- **Quality:** Obviously correct — mirrors the existing invalid-type
  error path directly below it.
- **Minimal:** 7 lines, no unrelated changes.
- **Regression risk:** Very low — converts a crash into the same error
  status (`AE_AML_OPERAND_TYPE`) already used for wrong element types;
  caller already handles this status for repair/fallback.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
**Record:** Buggy dereference introduced in commit `7952d40240855` (Bob
Moore, 2016-05-05): "ACPICA: ACPI 6.0: Update _BIX support for new
package element". Present in this tree since at least 2016.

### Step 3.2: Follow the Fixes: Tag
**Record:** No `Fixes:` tag present — not applicable.

### Step 3.3: Check File History for Related Changes
**Record:** Recent `nsprepkg.c` history is mostly copyright updates. No
related NULL-check fixes for this function. Fix commit on mainline:
`f8d14b7bb0063` (May 27, 2026). Standalone — not part of a dependent
series for this specific fix (appeared as patch 21/27 in a larger ACPICA
merge, but the diff is self-contained).

### Step 3.4: Check the Author's Other Commits
**Record:** Author Weiming Shi reported the bug; commit committed by
Rafael J. Wysocki (ACPI subsystem maintainer). Strong subsystem
ownership signal.

### Step 3.5: Check for Dependent/Prerequisite Commits
**Record:** No dependencies. `acpi_ns_custom_package()`,
`acpi_ns_remove_null_elements()`, and `_BIX`/`ACPI_PTYPE_CUSTOM`
definitions all exist in this tree. `git apply --check` confirms clean
apply.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Find the Original Patch Discussion
**Record:**
- `b4 dig -c f8d14b7bb0063`: Found at
  https://patch.msgid.link/5674388.Sb9uPGUboI@rafael.j.wysocki
- `b4 dig -a`: Two submission contexts — standalone v1 from Weiming Shi
  (2026-03-22) and inclusion in Rafael's ACPICA v1 27-patch series
  (2026-05-27). Committed version matches the latter.
- Lore thread content could not be fetched (Anubis bot protection on
  lore.kernel.org).

### Step 4.2: Check Who Reviewed the Patch
**Record:** `b4 dig -w` recipients: Rafael J. Wysocki, linux-
acpi@vger.kernel.org, LKML, Saket Dumbre, Pawel Chmielewski (Intel ACPI
team). Appropriate maintainer coverage.

### Step 4.3: Search for the Bug Report
**Record:** Two `Reported-by` tags from researchers who found the crash
with broken `_BIX` firmware. GitHub ACPICA commit confirms same
mechanism. No syzbot report.

### Step 4.4: Check for Related Patches and Series
**Record:** Fix is standalone (7-line diff). Being patch 21/27 in a
merge series does not create a functional dependency on the other 26
patches.

### Step 4.5: Check Stable Mailing List History
**Record:** Could not search lore stable list (bot protection). No
evidence found that this was explicitly rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Identify Key Functions in the Diff
**Record:** `acpi_ns_custom_package()` (modified)

### Step 5.2: Trace Callers
**Record:**
- `acpi_ns_check_package()` → case `ACPI_PTYPE_CUSTOM` →
  `acpi_ns_custom_package()` (`nsprepkg.c:108-110`)
- `acpi_ns_check_package()` called from `acpi_ns_check_return_value()`
  (`nspredef.c:136`)
- `acpi_ns_check_return_value()` called from `acpi_ns_evaluate()`
  (`nseval.c:261`)
- Reaches `acpi_evaluate_object()` — used by `drivers/acpi/battery.c`
  for `_BIX` evaluation (`battery.c:546-548`)

### Step 5.3: Trace Callees
**Record:** After version check, calls
`acpi_ns_check_package_elements()` which uses
`acpi_ns_check_object_type()` — that function already handles NULL
objects safely at `type_error_exit` (`nspredef.c:248-252`). The bug is
specifically in the direct dereference before that path.

### Step 5.4: Follow the Call Chain (Bug Reachability)
**Record:**
```
acpi_battery_get_info()
  → acpi_evaluate_object("_BIX")
    → acpi_ns_evaluate()
      → acpi_ns_check_return_value()
        → acpi_ns_check_package()
          → acpi_ns_custom_package()  [CRASH without fix]
```
Reachable during normal battery driver operation on any system with
`_BIX` and broken firmware. Not config-obscure — ACPI battery is
standard on laptops.

### Step 5.5: Search for Similar Patterns
**Record:** `acpi_ns_remove_null_elements()` explicitly excludes
`ACPI_PTYPE_CUSTOM` from NULL stripping (`nsrepair.c:457-472`, default
case returns without modification). This design choice makes the NULL
check in `acpi_ns_custom_package()` necessary and consistent.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: Does the Buggy Code Exist in This Tree?
**Record:** **YES.** `drivers/acpi/acpica/nsprepkg.c:634` still has `if
((*elements)->common.type != ACPI_TYPE_INTEGER)` without a prior NULL
check. Fix commit `f8d14b7bb0063` is **NOT** an ancestor of HEAD (`fix
NOT in tree`).

### Step 6.2: Check for Backport Complications
**Record:** `git apply --check` on the mainline patch: **APPLIES
CLEANLY**. No conflicts expected. File has not been structurally
refactored around this function.

### Step 6.3: Check if Related Fixes Are Already Here
**Record:** No prior fix for this specific bug. Other ACPICA NULL-deref
fixes exist in the tree (e.g., `acpi_ev_address_space_dispatch`) but not
for `acpi_ns_custom_package`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Identify the Subsystem and Its Criticality
**Record:** **ACPI/ACPICA** — core firmware interface subsystem.
**Criticality: CORE** — affects all ACPI-enabled x86/ARM systems during
method evaluation.

### Step 7.2: Assess Subsystem Activity
**Record:** Actively maintained; ACPICA regularly synced. The bug
predates recent churn — present since 2016 `_BIX` support was added.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Determine Who Is Affected
**Record:** Systems with ACPI battery support and firmware exposing
`_BIX` with a broken/unresolvable first package element. Affects
laptop/desktop users with ACPI batteries — a large population, though
trigger requires specific broken firmware.

### Step 8.2: Determine the Trigger Conditions
**Record:** Evaluating `_BIX` when firmware returns a package whose
version field (element 0) is an unresolvable reference → NULL. Triggered
during battery info queries (boot and periodic updates). Does not
require privileged user action beyond normal system operation.

### Step 8.3: Determine the Failure Mode Severity
**Record:** **CRITICAL** — NULL pointer dereference in kernel context →
kernel oops/panic. With the fix: controlled `AE_AML_OPERAND_TYPE` return
→ battery driver falls back to `_BIF` (`battery.c:541-567`).

### Step 8.4: Calculate Risk-Benefit Ratio
**Record:**
- **Benefit:** HIGH — prevents kernel crash on broken firmware; enables
  graceful degradation to `_BIF`.
- **Risk:** VERY LOW — 7-line NULL guard using existing error-return
  pattern.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Compile the Evidence

**FOR backporting:**
- Real NULL pointer dereference → kernel crash
- Two independent reporters
- Small (7 lines), obviously correct fix
- Applies cleanly to 6.18.y
- Bug present since 2016 in this tree
- ACPI maintainer committed the fix
- Graceful error path already exists in callers (`AE_AML_OPERAND_TYPE`
  handled in `nspredef.c:141-144`; battery driver falls back to `_BIF`)
- No new APIs or features

**AGAINST backporting:**
- Requires specific broken `_BIX` firmware (not universal)
- No syzbot/fuzzer confirmation
- Lore review thread not readable (bot protection)

**Unresolved:** Exact crash stack traces from reporters not available;
lore discussion content unverified.

### Step 9.2: Apply the Stable Rules Checklist
1. Obviously correct and tested? **PASS** — minimal NULL guard;
   committed by maintainer; two reporters.
2. Fixes a real bug affecting users? **PASS** — NULL deref on `_BIX`
   evaluation with broken firmware.
3. Important issue? **PASS** — kernel crash (CRITICAL severity).
4. Small and contained? **PASS** — 7 lines, one function, one file.
5. No new features or APIs? **PASS** — defensive check only.
6. Can apply to the local tree? **PASS** — buggy code present; patch
   applies cleanly.

### Step 9.3: Check for Exception Categories
**Record:** Not a device-ID/quirk/DT/build/doc exception — standard bug
fix.

### Step 9.4: Decision Rationale
This is a textbook stable backport: a long-standing NULL pointer
dereference in core ACPI validation code, triggered by real broken
firmware on a common code path (battery `_BIX` evaluation), fixed with a
minimal guard that converts a crash into an error code the callers
already handle. The fix is absent from Linux 6.18.44 and applies without
modification.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; identified two Reported-by,
  maintainer SOB, ACPICA upstream link
- **[Phase 2]** Diff: +7 lines in `acpi_ns_custom_package()`, adds NULL
  check before dereference
- **[Phase 3]** `git blame`: buggy line from `7952d40240855` (2016);
  `git show 7952d40240855`: introduced `_BIX` custom package validation
- **[Phase 3]** `git log -20 -- nsprepkg.c`: no prior fix for this issue
- **[Phase 3]** `git show f8d14b7bb0063`: confirmed mainline fix commit
- **[Phase 3]** `git apply --check`: patch applies cleanly to 6.18.44
- **[Phase 3]** `git merge-base --is-ancestor f8d14b7bb0063 HEAD`: fix
  NOT in tree
- **[Phase 4]** `b4 dig -c f8d14b7bb0063`: lore URL found
- **[Phase 4]** `b4 dig -a`: v1 standalone + v1 21/27 in ACPICA series
- **[Phase 4]** `b4 dig -w`: Rafael Wysocki, linux-acpi, Intel team CC'd
- **[Phase 4]** WebFetch lore/GitHub: GitHub ACPICA commit readable;
  lore blocked by Anubis
- **[Phase 5]** Grep call chain: `acpi_ns_custom_package` →
  `acpi_ns_check_package` → `acpi_ns_check_return_value` →
  `acpi_ns_evaluate`
- **[Phase 5]** Read `battery.c:546-567`: `_BIX` evaluation and `_BIF`
  fallback confirmed
- **[Phase 5]** Read `nsrepair.c:457-472`: `ACPI_PTYPE_CUSTOM` excluded
  from NULL stripping (confirms commit message)
- **[Phase 5]** Read `nspredef.c:248-252`: `acpi_ns_check_object_type`
  already handles NULL safely elsewhere
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** Read `nsprepkg.c:634`: buggy code confirmed present
- **[Phase 8]** Failure mode: NULL deref → kernel oops; with fix →
  `AE_AML_OPERAND_TYPE` → battery `_BIF` fallback

**YES**The background search finished: the fix (`f8d14b7bb0063`) is on
mainline but **not** in this **6.18.44** tree, and `git apply --check`
applies it cleanly.

**Verdict: YES** — backport this to stable. It’s a 7-line NULL guard in
`acpi_ns_custom_package()` that stops a kernel oops when broken firmware
returns a `_BIX` package with a NULL version element; callers already
handle the returned `AE_AML_OPERAND_TYPE` and the battery driver can
fall back to `_BIF`.

 drivers/acpi/acpica/nsprepkg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/acpica/nsprepkg.c b/drivers/acpi/acpica/nsprepkg.c
index ca137ce5674fb..c32770570120a 100644
--- a/drivers/acpi/acpica/nsprepkg.c
+++ b/drivers/acpi/acpica/nsprepkg.c
@@ -631,6 +631,13 @@ acpi_ns_custom_package(struct acpi_evaluate_info *info,
 
 	/* Get version number, must be Integer */
 
+	if (!(*elements)) {
+		ACPI_WARN_PREDEFINED((AE_INFO, info->full_pathname,
+				      info->node_flags,
+				      "Return Package has a NULL version element"));
+		return_ACPI_STATUS(AE_AML_OPERAND_TYPE);
+	}
+
 	if ((*elements)->common.type != ACPI_TYPE_INTEGER) {
 		ACPI_WARN_PREDEFINED((AE_INFO, info->full_pathname,
 				      info->node_flags,
-- 
2.53.0

