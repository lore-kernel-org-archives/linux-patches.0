Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921E24A3D4A;
	Mon, 31 Aug 2026 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183762; cv=none; b=oN7rwICV+5kkU/jY24uaww3db//Kvp7yE3rmAvCaeITA3uVOwOimyYIB8U8lFdWNB7m6rAMhlKLhKEp4/m/tKTSrxaz5qGAjL0ZRQBJZwkAfexX4tn3Vek7QF4EAKFv8h5az+J56MFHGRCMzMwos8ygJ24dklte7QxNkb5U9j74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183762; c=relaxed/simple;
	bh=3iGBA8GPAyEAcjrSEst6g140fbLvyvhiHxE/6wa8oXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R1EcJzyE4tYjziFD8PK5bUamLjZxGLT4PMvJozoFvmphCgWytPps6Mhqjj90OcNMoPIb/2OQrQ+K9JNt+94cUUD6BJOR79TYT4YeEYpim670NWo38ExQLL6ptd8aBOB1MFNsqRcw6gr8UYieMy/pqsRtDTnPsun6YMAj0RZw1iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvaoBYoc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvaoBYoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB501F000E9;
	Mon, 31 Aug 2026 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183759;
	bh=zz/5QezpqgGOOoE/n7i7SwncuG4gpF25aapWSTCVBqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvaoBYocZlNbT1XB7fjauyiqWRS0RGGC8kGI1YDn31up3AlbXN5v237o/sVfeB/8t
	 2Uuf5uXpsfMJOCrFmKdxcQ1lkMODIpvefO1Ht8Glqb8rkdu9JeR23YPgpTqKQp01Fs
	 1hyTHuUUuUfzWHPJsPwLS4nFcFWlK/E4ozsu+MJvTdFti64JOBP+bv31zXhy9j6KML
	 7NLfo/Pps/MhKBxSA+SFM5SQ1wzPpnvI5qNGoChrm+p/Em/KlFIxedTy4XGRHPhdYs
	 Zjg/3zRa5ZBOm02Cc57R1OnJVfIVPJ9y4TDk9JReIx/zl7mSWbvhoZvFY2FGvdOuP/
	 dbBkTC7X3p/Rw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
	Sashiko <sashiko-bot@kernel.org>,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] hwmon: (corsair-psu) Fix linear11 calculation
Date: Mon, 31 Aug 2026 09:25:15 -0400
Message-ID: <20260831133314.4125787-287-sashal@kernel.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit c6c4234928d2eb4f61fecb61067e612d9bdbd2ff ]

In corsairpsu_linear11_to_int(), the mantissa is extracted using bitwise
operations and cast to s16 before being shifted left:

static int corsairpsu_linear11_to_int(const u16 val, const int scale)
{
    ...
    const int mant = (((s16)(val & 0x7ff)) << 5) >> 5;
    ...
}

Due to C integer promotion rules, the masked value (which is always
positive) is promoted to a 32-bit integer before the left shift. As a
result, the sign bit is never extended to bit 31 of the promoted integer.

When the device hardware reports a negative temperature in Linear11 format
(such as an ambient temperature probe reporting sub-zero), the negative
mantissa is parsed incorrectly as a massive positive value. For example,
-1 becomes 2047, which scales to 2047 degrees Celsius.

Fix the problem by type casting the result of the left shift operation
to s16.

Another problem is left-shifting of negative values. In C, the result of
left-shifting negative values is undefined. Use a multiplication instead
to avoid the problem.

Also use a local s64 variable to store temporary results, change
the return value type from int to long, and clamp the final value
to LONG_MIN and LONG_MAX to avoid under- and overflow issues while
retaining as much information as possible.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/20260804034811.2385506-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `hwmon: (corsair-psu) Fix linear11
calculation`

**Local tree:** `v6.18.44` (linux-6.18.y, `VERSION = 6`, `PATCHLEVEL =
18`, `SUBLEVEL = 44`)
**Upstream fix commit:** `c6c4234928d2e` (on `master`, not yet in this
tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
**Record:** `[hwmon: (corsair-psu)] [fix] [correct LINEAR11 mantissa
sign-extension and exponent handling in sensor value conversion]`

### Step 1.2: Parse All Commit Message Tags
**Record:**
| Tag | Value |
|-----|-------|
| Reported-by | Sashiko \<sashiko-bot@kernel.org\> (AI code review bot,
not a user crash report) |
| Cc | Wilken Gottwalt \<wilken.gottwalt@posteo.net\> (driver author) |
| Signed-off-by | Guenter Roeck \<linux@roeck-us.net\> (hwmon subsystem
maintainer) |
| Tested-by | Wilken Gottwalt \<wilken.gottwalt@posteo.net\> |
| Link | https://lore.kernel.org/r/20260804034811.2385506-1-linux@roeck-
us.net |
| Fixes: | **Absent** (expected for manual review) |
| Cc: stable | **Absent** (expected) |

**Notable patterns:** Maintainer-authored fix with hardware-expert
Tested-by. Reported-by is an automated AI reviewer, not syzbot or a user
bug report.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug description:** `corsairpsu_linear11_to_int()` incorrectly
  extracts the signed 11-bit LINEAR11 mantissa. Casting `(val & 0x7ff)`
  to `s16` before left-shift fails because the masked value is always
  non-negative and gets promoted to a 32-bit int without sign extension.
- **Symptom:** Negative temperatures (e.g., sub-zero ambient probe)
  parse as huge positive values. Example: -1°C → 2047°C.
- **Secondary issues:** Left-shifting negative values is undefined
  behavior in C; exponent scaling can overflow `int`.
- **Root cause:** Integer promotion rules + incorrect cast order in
  mantissa extraction (introduced in 2021 refactor).
- **Version info:** None explicit; bug has existed since Feb 2021.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — explicitly labeled and described as a fix.
The overflow/clamp and UB avoidance are genuine correctness improvements
bundled with the sign-extension fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the Changes
**Record:**
- **File:** `drivers/hwmon/corsair-psu.c` — +14 / -9 lines (23 lines
  total with context)
- **Functions modified:** `corsairpsu_linear11_to_int()` → renamed
  `corsairpsu_linear11_to_long()`; call sites in
  `corsairpsu_get_value()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change (per hunk)

**Hunk 1 — `corsairpsu_linear11_to_long()`:**
- **Before:** Mantissa `(((s16)(val & 0x7ff)) << 5) >> 5` — sign never
  propagated for negative mantissas; exponent applied via bit-shift on
  `int`; returns `int`.
- **After:** Mantissa `((s16)((val & 0x7ff) << 5)) >> 5` — sign
  extension works; exponent via multiplication/division on `s64`; result
  clamped to `LONG_MIN`/`LONG_MAX`; returns `long`.

**Hunk 2 — `corsairpsu_get_value()` call sites:**
- **Before:** Calls `corsairpsu_linear11_to_int()` for temps, fan, PWM,
  watts.
- **After:** Calls `corsairpsu_linear11_to_long()` — same call paths,
  corrected return type.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness fix (type promotion bug) +
  initialization/overflow hardening
- **Mechanism:** For LINEAR11 value `0xFFFF` (mantissa -1): `val &
  0x7ff` = `0x7FF` (2047). Old code: `(s16)2047 << 5 >> 5` = 2047. Fixed
  code: `(s16)(2047 << 5) >> 5` = `(s16)0xFFE0 >> 5` = -1. Affects all
  LINEAR11 conversions; primary real-world impact is temperature sysfs
  readings at sub-zero ambient.

### Step 2.4: Fix Quality Assessment
**Record:**
- Fix is obviously correct by inspection; matches standard LINEAR11
  sign-extension pattern.
- Minimal, self-contained; no API changes visible to userspace (still
  `long` hwmon values).
- **Regression risk:** Very low. Positive values unchanged; only
  negative mantissa paths and overflow edge cases differ.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
**Record:**
- Buggy mantissa line introduced by **918f22104d64d** (Wilken Gottwalt,
  2021-02-27): `hwmon: (corsair-psu) Update calculation of LINEAR11
  values`
- Function shell from **d115b51e0e5671** (2020-10-27): original driver
  introduction
- Bug present since kernel ~5.12 era; definitely present in this 6.18.y
  tree

### Step 3.2: Follow Fixes: Tag
**Record:** No `Fixes:` tag present. Bug introduced by 918f22104d64d,
which is an ancestor of HEAD — confirmed with `git merge-base --is-
ancestor`.

### Step 3.3: File History for Related Changes
**Record:** Recent corsair-psu changes in this tree include UAF fix
(`ec477af3a7e8d`), probe error handling, device ID additions. On master
after v6.18.44: additional corsair-psu fixes (debugfs serialization,
string termination, this linear11 fix). **Standalone** — no series
dependency.

### Step 3.4: Author's Other Commits
**Record:** Guenter Roeck is hwmon subsystem maintainer. Wilken Gottwalt
is the primary corsair-psu driver author (multiple commits in this
file). High subsystem expertise.

### Step 3.5: Prerequisites
**Record:** No dependencies. Patch applies cleanly to current tree (`git
apply --check` → `APPLIES_CLEANLY`). Fix commit `c6c4234928d2e` is NOT
an ancestor of HEAD (`fix_NOT_in_tree`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260804034811.2385506-1-linux@roeck-us.net
- **Series:** v1 (RESEND, 2026-08-03) → v2 (2026-08-03, applied
  version). v2 change: "Skip handling right-shift of negative values"
- **Reviewer feedback:** Sashiko AI bot: "found no issues." Wilken
  Gottwalt: "Don't see any anomalies," gave Tested-by; noted he cannot
  simulate negative temps but PSU operating range is 0–50°C.
- **Stable nominations:** None found in thread.
- **NAKs:** None.

### Step 4.2: Who Reviewed
**Record:** CC'd to `linux-hwmon@vger.kernel.org`, Sashiko bot, Wilken
Gottwalt (driver author). Maintainer self-submitted.

### Step 4.3: Bug Report
**Record:** No user bug report, syzbot, or KASAN report. Found via code
review (Sashiko AI). Concrete failure example provided in commit message
(-1 → 2047°C).

### Step 4.4: Related Patches
**Record:** Standalone 1-patch series. No other patches required.

### Step 4.5: Stable Mailing List History
**Record:** Not searched separately; no stable nomination in the patch
thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `corsairpsu_linear11_to_long()` (was `_to_int`), called from
`corsairpsu_get_value()`.

### Step 5.2: Trace Callers
**Record:** `corsairpsu_get_value()` called from:
- `corsairpsu_get_criticals()` — critical threshold reads at probe
- `corsairpsu_hwmon_temp_read()` — **TEMP0/TEMP1** (primary bug impact)
- `corsairpsu_hwmon_fan_read()`, `corsairpsu_hwmon_power_read()`,
  `corsairpsu_hwmon_in_read()`, `corsairpsu_hwmon_curr_read()`
- debugfs read paths

All ultimately reachable from userspace via sysfs hwmon reads
(`corsairpsu_hwmon_ops_read`).

### Step 5.3: Key Callees
**Record:** `corsairpsu_request()` (USB HID I/O), `clamp()` macro. No
locking changes.

### Step 5.4: Call Chain / Reachability
**Record:** Userspace reads `/sys/class/hwmon/hwmonN/tempN_input` →
`corsairpsu_hwmon_ops_read()` → `corsairpsu_hwmon_temp_read()` →
`corsairpsu_get_value()` → `corsairpsu_linear11_to_long()`. **Reachable
from userspace** on systems with `CONFIG_SENSORS_CORSAIR_PSU` enabled
and a supported Corsair PSU connected.

### Step 5.5: Similar Patterns
**Record:** Other hwmon drivers in this tree have had LINEAR11 fixes
backported (e.g., `pmbus/fsp-3y` non-compliant linear11 vout encoding).
Same class of sensor-parsing correctness bug.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does Buggy Code Exist?
**Record:** **YES.** Current tree at lines 143–149 has the exact buggy
code:

```143:149:drivers/hwmon/corsair-psu.c
static int corsairpsu_linear11_to_int(const u16 val, const int scale)
{
        const int exp = ((s16)val) >> 11;
        const int mant = (((s16)(val & 0x7ff)) << 5) >> 5;
        const int result = mant * scale;

        return (exp >= 0) ? (result << exp) : (result >> -exp);
```

Driver present since driver intro commit `d115b51e0e5671`; buggy
mantissa since `918f22104d64d`.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — verified with `git apply --check`. No
conflicting changes in the affected region.

### Step 6.3: Related Fixes Already Present?
**Record:** Other corsair-psu fixes are present (UAF fix
`ec477af3a7e8d`, probe fixes), but this linear11 fix is **not** yet in
v6.18.44.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/hwmon/` — **PERIPHERAL** (optional tristate module
`CONFIG_SENSORS_CORSAIR_PSU`, Corsair PSU HID hardware only).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained. Recent 6.18.y stable queue includes
multiple hwmon sensor-correctness and crash fixes (adt7470, ina2xx,
ltc4282, sht3x).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Driver-specific** — users with supported Corsair PSUs
(RM/HX series with HID interface) who have `CONFIG_SENSORS_CORSAIR_PSU`
built-in or loaded as module.

### Step 8.2: Trigger Conditions
**Record:** PSU firmware reports a negative LINEAR11 mantissa, most
plausibly on temperature sensors in sub-zero ambient conditions.
Unprivileged users can trigger sysfs reads but cannot inject the
hardware value. **Uncommon** but realistic in cold environments; driver
author notes PSU spec is 0–50°C continuous.

### Step 8.3: Failure Mode Severity
**Record:**
- **Failure mode:** Incorrect sysfs sensor readings (e.g., 2047°C
  instead of -1°C); could cause false monitoring alerts or fan-control
  script misfires if tied to PSU temps.
- **NOT:** kernel crash, oops, hang, deadlock, data corruption, or
  security issue.
- **Severity: MEDIUM** — real user-visible incorrect data, but no kernel
  instability.

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** Correct temperature/voltage/power readings for affected
  hardware; eliminates absurd 2047°C values.
- **Risk:** Very low — 23-line change, maintainer-authored, tested,
  clean apply.
- **Ratio:** Moderate benefit, very low risk. Appropriate for 6.18.y
  where the driver and bug both exist.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible parsing bug with concrete example (-1 → 2047°C)
- Bug present in this tree since 2021
- Fix from hwmon maintainer (Guenter Roeck), Tested-by from driver
  author
- Small (23 lines), single file, applies cleanly
- Precedent: similar hwmon sensor-reading correctness fixes already in
  6.18.y stable queue
- Fixes undefined behavior (left-shift of negative values)

**AGAINST backport:**
- Niche optional driver; small user population
- No crash/corruption/security impact
- Trigger requires sub-zero ambient (edge case per driver author)
- Reported-by is AI review bot, not a user bug report
- Does not meet the strongest stable signals (oops, UAF, syzbot)

**Unresolved:** No independent user reports of the 2047°C symptom found.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — clear C promotion fix;
Tested-by from driver author |
| 2. Fixes a real bug affecting users? | **PASS** — wrong sysfs sensor
values for Corsair PSU users |
| 3. Important issue? | **PASS (borderline)** — "oh, that's not good"
per stable-kernel-rules.rst; not crash-level but clearly wrong
monitoring data |
| 4. Small and contained? | **PASS** — 23 lines, 1 file |
| 5. No new features/APIs? | **PASS** — bug fix only |
| 6. Can apply to local tree? | **PASS** — verified clean apply |

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build fix, or docs fix).
Qualifies as a hardware-monitoring correctness bug fix.

### Step 9.4: Decision Rationale

For **linux-6.18.y at v6.18.44**: the corsair-psu driver and the buggy
LINEAR11 code are both present. The fix is maintainer-quality, tested,
minimal, and applies cleanly. While the impact is limited to a niche
driver and cold-ambient edge cases (wrong sysfs readings, not kernel
crashes), stable-kernel-rules explicitly include fixes for real bugs
that bother users and "oh, that's not good" issues. This tree already
backports similar hwmon sensor-correctness fixes. The risk of regression
is negligible.

---

## Verification

- **[Phase 1]** Parsed commit message tags from `git show c6c4234928d2e`
- **[Phase 2]** Diff analysis: 23 lines changed in
  `drivers/hwmon/corsair-psu.c`; verified buggy mantissa at lines
  143–149
- **[Phase 3]** `git blame`: buggy line from 918f22104d64d (2021-02-27);
  driver from d115b51e0e5671 (2020-10-27)
- **[Phase 3]** `git merge-base --is-ancestor`: driver and buggy code
  both in tree; fix commit NOT in tree
- **[Phase 3]** `git log --oneline -20 -- drivers/hwmon/corsair-psu.c`:
  history reviewed
- **[Phase 4]** `b4 dig -c c6c4234928d2e`: found v1→v2 series at lore
  URL above
- **[Phase 4]** `b4 dig -c c6c4234928d2e -w`: CC'd linux-hwmon, Sashiko,
  Wilken Gottwalt
- **[Phase 4]** `b4 dig -m /tmp/corsair_linear11.mbox`: read thread;
  Tested-by from Wilken; no stable nomination; no NAKs
- **[Phase 5]** `grep corsairpsu_get_value`: traced callers to hwmon
  sysfs read path
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** `git apply --check`: patch applies cleanly
- **[Phase 6]** Read current `corsairpsu_linear11_to_int()` — buggy code
  confirmed present
- **[Phase 7]** `CONFIG_SENSORS_CORSAIR_PSU` in `drivers/hwmon/Kconfig`
  — tristate optional module
- **[Phase 8]** Assessed severity as MEDIUM (wrong sysfs data, no kernel
  crash)

---

**YES**The background lookups are done and match what the analysis
already used:

- **b4 dig** found the patch thread: [PATCH v2] hwmon: (corsair-psu) Fix
  linear11 calculation (v1 → v2, Tested-by from Wilken Gottwalt).
- **`git log --grep="Fix linear11"`** hung and was stopped; the fix was
  already located on `master` as `c6c4234928d2e`.
- **`git log --grep="linear11"`** returned unrelated hwmon LINEAR11
  commits in other drivers (pmbus/fsp-3y, etc.), not this corsair-psu
  fix.

Nothing else is needed from those tasks. The backport recommendation for
**linux-6.18.y (v6.18.44)** remains **YES** — small maintainer fix for
wrong sub-zero temperature readings, applies cleanly, and the buggy code
is present in this tree.

 drivers/hwmon/corsair-psu.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/corsair-psu.c b/drivers/hwmon/corsair-psu.c
index 4681af6843596..d56a6cd76ff26 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -140,13 +140,18 @@ struct corsairpsu_data {
 };
 
 /* some values are SMBus LINEAR11 data which need a conversion */
-static int corsairpsu_linear11_to_int(const u16 val, const int scale)
+static long corsairpsu_linear11_to_long(const u16 val, const int scale)
 {
 	const int exp = ((s16)val) >> 11;
-	const int mant = (((s16)(val & 0x7ff)) << 5) >> 5;
-	const int result = mant * scale;
+	const int mant = ((s16)((val & 0x7ff) << 5)) >> 5;
+	s64 result = mant * scale;
 
-	return (exp >= 0) ? (result << exp) : (result >> -exp);
+	if (exp >= 0)
+		result *= (int)(1UL << exp);
+	else
+		result >>= -exp;
+
+	return clamp(result, LONG_MIN, LONG_MAX);
 }
 
 /* the micro-controller uses percentage values to control pwm */
@@ -271,13 +276,13 @@ static int corsairpsu_get_value(struct corsairpsu_data *priv, u8 cmd, u8 rail, l
 	case PSU_CMD_RAIL_AMPS:
 	case PSU_CMD_TEMP0:
 	case PSU_CMD_TEMP1:
-		*val = corsairpsu_linear11_to_int(tmp & 0xFFFF, 1000);
+		*val = corsairpsu_linear11_to_long(tmp & 0xFFFF, 1000);
 		break;
 	case PSU_CMD_FAN:
-		*val = corsairpsu_linear11_to_int(tmp & 0xFFFF, 1);
+		*val = corsairpsu_linear11_to_long(tmp & 0xFFFF, 1);
 		break;
 	case PSU_CMD_FAN_PWM_ENABLE:
-		*val = corsairpsu_linear11_to_int(tmp & 0xFFFF, 1);
+		*val = corsairpsu_linear11_to_long(tmp & 0xFFFF, 1);
 		/*
 		 * 0 = automatic mode, means the micro-controller controls the fan using a plan
 		 *     which can be modified, but changing this plan is not supported by this
@@ -291,12 +296,12 @@ static int corsairpsu_get_value(struct corsairpsu_data *priv, u8 cmd, u8 rail, l
 			*val = 2;
 		break;
 	case PSU_CMD_FAN_PWM:
-		*val = corsairpsu_linear11_to_int(tmp & 0xFFFF, 1);
+		*val = corsairpsu_linear11_to_long(tmp & 0xFFFF, 1);
 		*val = corsairpsu_dutycycle_to_pwm(*val);
 		break;
 	case PSU_CMD_RAIL_WATTS:
 	case PSU_CMD_TOTAL_WATTS:
-		*val = corsairpsu_linear11_to_int(tmp & 0xFFFF, 1000000);
+		*val = corsairpsu_linear11_to_long(tmp & 0xFFFF, 1000000);
 		break;
 	case PSU_CMD_TOTAL_UPTIME:
 	case PSU_CMD_UPTIME:
-- 
2.53.0

