Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F715187E4;
	Mon, 19 Oct 2026 13:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418244; cv=none; b=J6kduHkXEzq1qLgvSZSvtz/lFc46BfQlH98otL8BUSs/XU5j5CUZRJVvtV5+xH9bRPvwDHdFhP3gFmFcMbpdNZMtB+Lr77yxxpko6ZrkAGr7pLl5e43yrbOHvtBAGIuV9nHTS4fnBxmwQ4+8G/j9C9nIxIIlOK94HaOk6Cf7R7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418244; c=relaxed/simple;
	bh=jUztPm7uRIP0iS8KOShw58cKzKvgh4GCAlFQpSpBT2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kCdlkGSf8AkALHrLiB2C+dGCeES47b/1t+8UrtPs2Pdb1uEiiRBKKJ7bUhm1Ceyjr1YrEKnCNeaCErY+u/qQlFjy3a51N/c/kCphf7SQ3OItG3kyHMP1FTudPijcEnKeXaK5QFocDdRgyqxXYReApKSyoJj0aXF3CzZ7hAYs3/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DkzAPO9o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkzAPO9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE5D1F000C6;
	Mon, 19 Oct 2026 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418242;
	bh=3niE0IEl9FIKpMw7hfLbJ8+0tI0fo/18nEVzpD2/Y60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkzAPO9ov196v2n7rWlFpw+TCtUx8Lp76oV2WK7GPYnEwFR2JbJ+DW/gfeonlC9ME
	 M7tun86WKiyZl0/nXSBDzg+0cYixHFDo2MhdQe3gpBpymuwhm8gQrfeJjQWSbZ/A+H
	 9+Ozqg53jrguvmSbfmoNAyS9d7SB2PhDWxykeV6B3Ha/Z6YtOBYe3ECoom7/Rucm4p
	 qdHW62od5aU4CHtX7FSQwhPxKWlUcnj+pvkAifJP3+qQslSZgNT0+Zx4T2O4oI3yhz
	 VGyVgMpmWysGS2SB0W20C+9lMkjQMGsA7taGmP7y0Ef+nGQ8qMHyOQclMdUw/2hB0L
	 YUYuhQZGec24g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrew Onyshchuk <andryk.rv@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	derekjohn.clark@gmail.com,
	hmh@hmh.eng.br,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	ibm-acpi-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] platform/x86: thinkpad_acpi: Fix fan speed reporting on Edge E330
Date: Mon, 19 Oct 2026 09:46:44 -0400
Message-ID: <20261019135441.1420968-113-sashal@kernel.org>
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

From: Andrew Onyshchuk <andryk.rv@gmail.com>

[ Upstream commit 8d840dad456f88374d8a3b03851452a280d6ee50 ]

The ThinkPad Edge E330 with H3 firmware uses the non-standard EC fan
register block. Without a matching quirk, thinkpad_acpi reads the legacy
tachometer registers and reports 0 RPM.

Add the H3 BIOS family to TPACPI_FAN_NS so the driver reads the fan
period from EC register 0x95 using the existing non-standard reporting
path.

Tested on a ThinkPad Edge E330 with BIOS H3ET77WW and EC H3EC35WW.

Signed-off-by: Andrew Onyshchuk <andryk.rv@gmail.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20260806154417.618575-1-andryk.rv@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Local tree

This checkout is **pending-6.12** (`p-6.12-3-gc504cf0baa3d8`), kernel
**6.12.111**. The verdict is only for this tree.

The driver is still `drivers/platform/x86/thinkpad_acpi.c` (not yet
moved to `drivers/platform/x86/lenovo/`). The H3 `TPACPI_FAN_NS` quirk
is **not** present. The non-standard fan path that the quirk selects
**is** present.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[platform/x86 thinkpad_acpi] [Fix] [fan speed reporting on
ThinkPad Edge E330]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>` (Lenovo
  thinkpad_acpi reviewer)
- `Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>`
  (platform/x86 maintainer)
- `Signed-off-by: Andrew Onyshchuk <andryk.rv@gmail.com>` (author)
- `Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>`
  (maintainer)
- `Link:
  https://patch.msgid.link/20260806154417.618575-1-andryk.rv@gmail.com`
- No `Fixes:` tag (expected)
- No `Reported-by:` / `Tested-by:` tags (testing is described in the
  body instead)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  if present

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Edge E330 with H3 firmware uses the non-standard EC fan
  register block.
- **Symptom:** without a quirk, the driver reads the legacy tachometer
  registers and reports **0 RPM**.
- **Root cause:** missing BIOS-family match in `fan_quirk_table`.
- **Fix:** add `TPACPI_Q_LNV('H', '3', TPACPI_FAN_NS)` so the existing
  NS path reads period from EC **0x95**.
- **Version info:** tested on BIOS **H3ET77WW**, EC **H3EC35WW**. No
  kernel-version range given.
- **Failure mode:** wrong hwmon/procfs fan speed (always 0), not a
  crash.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit hardware-quirk bug
fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- One file: `drivers/platform/x86/lenovo/thinkpad_acpi.c` in the
  submitted patch; local equivalent is
  `drivers/platform/x86/thinkpad_acpi.c`.
- **+1 line**, 0 removed.
- Function/data: `fan_quirk_table[]`.
- Scope: **single-file surgical hardware quirk**.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `tpacpi_check_quirks(fan_quirk_table)` does not match BIOS
  family `H3`. `fan_init()` uses `TPACPI_FAN_RD_TPEC` and reads
  `fan_rpm_offset` **0x84/0x85**. On this EC those registers are unused,
  so speed is 0.
- **After:** BIOS `H3` matches `TPACPI_FAN_NS`. `fan_init()` sets
  `fan_with_ns_addr`, selects `TPACPI_FAN_RD_TPEC_NS`, and
  `fan_get_speed()` reads `fan_rpm_status_ns` (**0x95**) and converts
  period to RPM via `FAN_RPM_CAL_CONST / lo`.

Verified in this tree:

```8156:8162:drivers/platform/x86/thinkpad_acpi.c
        case TPACPI_FAN_RD_TPEC_NS:
                if (!acpi_ec_read(fan_rpm_status_ns, &lo))
                        return -EIO;

                if (speed)
                        *speed = lo ? FAN_RPM_CAL_CONST / lo : 0;
                break;
```

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **(h) Hardware workaround** — quirk-table entry enabling an
existing EC register path. Same class as the X120e TPR and L13/X13 Yoga
NS fan quirks already in this file.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: one table entry, existing matcher, existing NS
  reader.
- BIOS matching is right: `H3ET77WW` is the 8-char `xxyTkkWW` form, so
  `tpacpi_parse_fw_id()` stores `TPID('H','3')`, which is exactly what
  `TPACPI_Q_LNV('H','3', ...)` matches (`ec = TPACPI_MATCH_ANY`).
- Minimal; no API/data-structure change.
- Regression risk is limited to H3-family machines. FAN_NS also marks
  host fan control as undefined (`fan_ctrl_status_undef = 1`) and uses
  NS status register 0x93. That is the same behavior already used for
  L13/X13 Yoga, L380/L390, 11e Gen5. Mark Pearson noted the platform is
  ~14 years old and he could not independently confirm; the author
  tested it. Overmatch of unrelated H3 BIOS families is possible in
  theory but H3ET is the E330/E335 firmware family.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: The insertion sits among NS quirks added by:
- `66e92e23a7276` (2023-12-14) Vishnu Sankar — introduced
  `TPACPI_FAN_NS` (L13 Yoga Gen 2, X13 Yoga Gen 2)
- `a6dcd3f1725e0` (2024-02-29) Vishnu Sankar — more NS models (L380,
  L390, 11e Gen5, …)

Both **are ancestors of this HEAD**. The E330 bug is the missing table
row, not a newly introduced regression. This machine has been mis-
reported for as long as the default 0x84/0x85 path has been used.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Related fan quirks already in this 6.12 tree:
- `f92324135f09e` — X120e TPR fan-speed quirk (stable-style backport
  already here)
- `1be765b292577` — L480 `TPACPI_FAN_DECRPM` incorrect RPM
- `a6dcd3f1725e0` / `66e92e23a7276` — NS fan register path
- `48792ab445529` — T495/E560 ACPI fan quirk

Standalone one-line table add; not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: `git log --author='Onyshchuk'` on `drivers/platform/x86/` in
this tree is empty. Author is an outside contributor with Lenovo +
maintainer review, not the subsystem maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Depends only on `TPACPI_FAN_NS` / `fan_rpm_status_ns` /
`TPACPI_Q_LNV`, all present here. Can apply standalone (path tweak
only).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 051292bf7697e72a760401b6883c55a98beecc5b` failed: SHA is
  not in this tree (`Not a valid commit name`).
- `b4 mbox` for msgid `20260806154417.618575-1-andryk.rv@gmail.com`
  returned 404.
- lore.kernel.org fetches returned 403.
- Recovered the thread from Patchew and LKML mirrors:
  - https://patchew.org/linux/20260806154417.618575-1-
    andryk.rv@gmail.com/
  - https://lkml.iu.edu/2608.0/11369.html
- Single `[PATCH]`, not a series. Applied by Ilpo as
  `051292bf7697e72a760401b6883c55a98beecc5b`.
- No NAK. Ilpo noted Linus’s policy that even fixes usually go via for-
  next unless they are current-cycle regressions — that is merge-window
  routing, not a stable NAK.
- No reviewer asked for `Cc: stable`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Mark Pearson (Lenovo) Reviewed-by; Ilpo Järvinen applied it.
Recipients from Openwall copy: platform-driver-x86, ibm-acpi-devel,
linux-kernel, plus Pearson / Clark / Holschuh / Hans.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Evidence is the author’s hardware test
(H3ET77WW / H3EC35WW). Mark Pearson: platform is ~14 years old; he could
not confirm but was glad the author figured it out.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Same pattern as earlier NS fan quirk additions.
E330/E335 share the H3ET BIOS family; the 2-char `H3` match is the
driver’s normal family match.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403. No evidence this was
already requested or rejected on stable. UNVERIFIED beyond that.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

semcode MCP is not available; used grep/read.

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function body change. Touches `fan_quirk_table`, consumed by
`fan_init()`. Downstream: `fan_get_speed()`, `fan_get_status()`,
`fan_read()`, sysfs `fan1_input`.

**Step 5.2: TRACE CALLERS**
Record:
- `fan_get_speed()` → `fan_fan1_input_show()` (hwmon `fan1_input`) and
  `fan_read()` (`/proc/acpi/ibm/fan`).
- Userspace: lm-sensors, thinkfan, TLP, etc., on ThinkPads with
  `CONFIG_THINKPAD_ACPI`.
- Init-time quirk match only; no IRQ path.

**Step 5.3: TRACE CALLEES**
Record: Existing `acpi_ec_read(0x95)` and RPM conversion. No new
allocation/locking.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from userspace sysfs/proc reads on E330 with
thinkpad_acpi loaded. Unprivileged read of hwmon is typical. Not a
syscall crash path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Nine existing `TPACPI_FAN_NS` rows in the same table; this is
the tenth. Thermal NS table for the Yoga/11e set is **not** extended
here (E330 was not claimed to need thermal NS).

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `fan_quirk_table` in `drivers/platform/x86/thinkpad_acpi.c`
(lines 8805–8837) has NS entries through 11e Gen5 and then jumps to
`TPACPI_FAN_NOFAN`. No `'H','3'` row. Default TPEC RPM path is used → 0
RPM on E330. Infrastructure needed for the fix is here since
`66e92e23a7276`.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Minor path adjustment only.** Surrounding context in this tree
matches the hunk exactly (same 11e Gen5 / X1 Tablet / L480 / x120e
neighbors). File move to `lenovo/` happened after 6.12. Expected apply:
change path, otherwise clean.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: NS path and other model quirks are here. This specific H3/E330
line is not. `git merge-base --is-ancestor 051292bf7697… HEAD` fails
because that SHA is not in this object store.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **platform/x86 thinkpad_acpi** — **PERIPHERAL/IMPORTANT for
ThinkPad users**. Fan sysfs is widely used; not core mm/fs/net.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained; recent 6.12 backports already include other
thinkpad_acpi fan quirks (X120e TPR, T495 NOACPI). Mature driver, long-
lived quirk table.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / DMI-specific.** Only Lenovo machines whose
BIOS parses as family `H3` (E330 H3ET; likely E335 siblings). Everyone
else is unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every read of `fan1_input` or `/proc/acpi/ibm/fan` on those
machines. Common for anyone monitoring fans. Unprivileged sysfs read.
Not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Incorrect fan RPM (always 0). **MEDIUM** for affected users
(broken monitoring; thinkfan/sensors may treat the fan as stopped). Not
panic, UAF, or corruption. Still a real hardware bug with a standard
quirk fix.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Makes fan tachometer work on E330 (and H3-family
  siblings) on 6.12 LTS. Same class of fix already accepted in this tree
  for X120e/L480/Yoga.
- **Risk:** Very low — one line, model-gated, existing code path.
- **Ratio:** Favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, tested hardware bug: E330 reports 0 RPM.
- Classic stable-eligible **hardware quirk** (one `TPACPI_Q_LNV` row).
- Existing NS path already in 6.12; no new feature/API.
- 1-line, obviously correct; Lenovo + pdx86 review.
- Analogous fan quirks already live in this tree.
- Applies here with a trivial path change.

AGAINST:
- Not crash/security/corruption.
- Old niche laptop; small population.
- Maintainer sent it via for-next, not as a current-cycle regression.
- Author-only test; Pearson could not independently verify.

UNRESOLVED:
- Stable-list discussion (lore 403).
- Whether every H3 BIOS SKU (e.g. E335) truly uses 0x95; family-level
  match is the driver’s normal pattern.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 1-line quirk; tested on E330
   H3ET77WW; two Reviewed-by.
2. Fixes a real bug that affects users? **PASS** — fan speed stuck at 0.
3. Important issue? **PASS** under the hardware-quirk exception;
   severity MEDIUM, not CRITICAL.
4. Small and contained? **PASS** — +1 line, one table.
5. No new features or APIs? **PASS** — enables existing NS path for one
   BIOS family.
6. Can apply to the local tree? **PASS** — NS path present; path rename
   only.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk/workaround** — qualifies even though it adds a
table row.

**Step 9.4: DECISION**
This is the same kind of thinkpad_acpi fan quirk this 6.12 tree already
carries. The bug exists here, the fix is surgical, and the risk is
confined to H3-family ThinkPads.

---

### What the commit solves for this tree

On ThinkPad Edge E330 (BIOS family H3), thinkpad_acpi reads the standard
EC tachometer at 0x84/0x85 and always reports 0 RPM. Adding
`TPACPI_FAN_NS` for `H3` switches that model onto the existing 0x95
period reader so hwmon/`/proc/acpi/ibm/fan` show a real speed. 6.12
already has that reader; it is only missing this DMI row.

### Risk vs benefit

Benefit is correct fan monitoring on those laptops. Risk is a one-line,
model-gated change. Backport needs only retargeting the path from
`lenovo/thinkpad_acpi.c` to `drivers/platform/x86/thinkpad_acpi.c`.

---

### Verification
- [Phase 1] Parsed subject/tags/body from the provided commit message;
  Link msgid `20260806154417.618575-1-andryk.rv@gmail.com`.
- [Phase 2] Diff is +1 `TPACPI_Q_LNV('H','3', TPACPI_FAN_NS)` in
  `fan_quirk_table`.
- [Phase 2] Read `fan_get_speed()` NS case (0x95) and `fan_init()` NS
  setup in this tree.
- [Phase 2] Read `tpacpi_parse_fw_id()`: `H3ET77WW` → `TPID('H','3')`,
  matches `TPACPI_Q_LNV`.
- [Phase 3] `git blame -L 8822,8837`: NS rows from `66e92e23a7276` and
  `a6dcd3f1725e0`.
- [Phase 3] `git merge-base --is-ancestor 66e92e23a7276 HEAD` and
  `a6dcd3f1725e0 HEAD`: both in tree.
- [Phase 3] `git log --author=Onyshchuk` on platform/x86: no local
  commits.
- [Phase 4] `b4 dig`/`b4 mbox`/lore.kernel.org failed (missing SHA / 404
  / 403). Thread recovered from Patchew + lkml.iu.edu + Openwall:
  Pearson Reviewed-by, Ilpo applied as `051292bf7697`.
- [Phase 4] Web search: H3ET is E330/E335 BIOS family; author tested
  H3ET77WW.
- [Phase 5] semcode unavailable; `grep fan_get_speed` → sysfs
  `fan1_input` and `fan_read()`.
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111.
- [Phase 6] Grep: no `'H', '3'` / Edge E330 in local file; NS table ends
  at 11e Gen5.
- [Phase 6] File exists only at `drivers/platform/x86/thinkpad_acpi.c`.
- [Phase 6] `051292bf7697` is not a valid object in this repo.
- [Phase 7] `CONFIG_THINKPAD_ACPI` in `drivers/platform/x86/Kconfig`.
- [Phase 8] Failure mode: 0 RPM reporting, not oops.
- UNVERIFIED: stable@ lore discussion (HTTP 403); independent
  confirmation on E335.

**YES**

 drivers/platform/x86/lenovo/thinkpad_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/lenovo/thinkpad_acpi.c b/drivers/platform/x86/lenovo/thinkpad_acpi.c
index 075543cd0e77e..f3b2e3c794571 100644
--- a/drivers/platform/x86/lenovo/thinkpad_acpi.c
+++ b/drivers/platform/x86/lenovo/thinkpad_acpi.c
@@ -8854,6 +8854,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('R', '0', 'T', TPACPI_FAN_NS),	/* 11e Gen5 GL */
 	TPACPI_Q_LNV3('R', '1', 'D', TPACPI_FAN_NS),	/* 11e Gen5 GL-R */
 	TPACPI_Q_LNV3('R', '0', 'V', TPACPI_FAN_NS),	/* 11e Gen5 KL-Y */
+	TPACPI_Q_LNV('H', '3', TPACPI_FAN_NS),		/* Edge E330 */
 	TPACPI_Q_LNV3('N', '1', 'O', TPACPI_FAN_NOFAN),	/* X1 Tablet (2nd gen) */
 	TPACPI_Q_LNV3('R', '0', 'Q', TPACPI_FAN_DECRPM),/* L480 */
 	TPACPI_Q_LNV('8', 'F', TPACPI_FAN_TPR),		/* ThinkPad x120e */
-- 
2.53.0

