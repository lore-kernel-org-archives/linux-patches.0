Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D967F582790;
	Mon, 19 Oct 2026 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418399; cv=none; b=N6BGOSfGYnJIy441wrUybV2WWAAzUraW3oj10ePo7qCZG8dDe0o9gGVqdobE3WnEu7jkq7I6qOgtShZLl7xT8X2QR2jLpy3DXxoBrjPb9K6Hh0tleFSU0qNaCncOzJR6KMLVF6HIHhOs87/YORaBoxnHuP7TNw8JuqOhwuE3pGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418399; c=relaxed/simple;
	bh=uZukE25iEAl//S0ejw2tfv0/KdKPev8quqJPBkrJLig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdnWpjTyiTl4zAOKNdCCAfdjteUW2QFOQCfIDtCz2hsgX1Nry6tN06RxVK4X+hwxe4dJexfK4dQ2WXTp1sGxOEH1DWlruZGkAKG/VXl/wZB73lRhfcAKZIerBoIZQV5Dwnl15vN73T4Eb84CAOdjumaAFkz70uSp91ctZwL8A04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ec82nxEg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ec82nxEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB391F000C9;
	Mon, 19 Oct 2026 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418397;
	bh=KpHCv03iBiqXe9bmGz9dOiNVSpQl+aoBCSsyicKvSkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ec82nxEgfiZ/NkB17hcT+MK8Us+80Ax329H7p1j5pb7wNLAEW+n7pCE+WUjHpvu3y
	 yVE/NyO4EQAopddV5So3UbREkSmA8GvPdlCcfMUF7goJ8bvpWTKGCtUS8fJhbXlBkN
	 APDCHF5AEbdZ5BjYMxBVarRWF2saXTX/bbkIsFmPkCb0Y7cipm4CGWPCJXrymp6KNY
	 qu4FsapDXSXf9GeCZhBSwfL3ZK9pscCS1vdBtHwE95RvEggeZ8VA2TWPjxpiir35dY
	 JCuVT7OycKNA19gsTS+/GuJaHfEszDpaPutvGN5Q8/mIucRQLc2oNm+0zy4MulaRrP
	 EXVbD/GXAdRSg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Abhijeeth Babu <babu.jeeth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	westeri@kernel.org,
	linux-i2c@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] i2c: acpi: Force ELAN1300 touchpads to 100 kHz
Date: Mon, 19 Oct 2026 09:48:32 -0400
Message-ID: <20261019135441.1420968-221-sashal@kernel.org>
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

From: Abhijeeth Babu <babu.jeeth@gmail.com>

[ Upstream commit 9e9762e578db7556bea644bb5a8a2435f63544d1 ]

The ELAN1300 touchpad with HID ID 04F3:3104 on the ASUS VivoBook
X513UA_KM513UA exhibits severe pointer jumps and erratic movement when
the I2C bus operates at 400 kHz.

The system DSDT describes the touchpad using an I2cSerialBusV2 resource
with a speed of 0x00061A80, corresponding to 400 kHz, on the
AMDI0010:03 controller.

At this speed, libinput repeatedly reports:

kernel bug: Touch jump detected and discarded

Add ELAN1300 to i2c_acpi_force_100khz_device_ids so that it operates at
100 kHz.

Before the change, nine touch-jump events were recorded, with additional
messages suppressed by libinput's rate limiter. With the bus forced to
100 kHz, no touch-jump events have been observed and the touchpad operates
normally.

The affected system uses BIOS X513UA.319 dated 2023-05-09.

Signed-off-by: Abhijeeth Babu <babu.jeeth@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260617192611.125513-1-babu.jeeth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[i2c: acpi]` `[Force]` Force ELAN1300 touchpads to 100 kHz
instead of the DSDT-advertised 400 kHz.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Fixes:` none (expected)
- `Reported-by:` none
- `Tested-by:` none (author reports before/after on the affected
  machine)
- `Reviewed-by:` none
- `Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>`
  (ACPI/I2C ACPI expert)
- `Signed-off-by: Abhijeeth Babu` (author)
- `Signed-off-by: Andi Shyti` (I2C host-driver maintainer; merged to
  `i2c/i2c-for-7.3`)
- `Link: https://lore.kernel.org/r/20260617192611.125513-1-
  babu.jeeth@gmail.com`
- `Cc: stable@vger.kernel.org` none (expected)
- Ignored: `[Upstream commit 9e9762e578db7556bea644bb5a8a2435f63544d1]`
  and `Signed-off-by: Sasha Levin` (pipeline markers)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- Bug: ELAN1300 (`HID 04F3:3104`) on ASUS VivoBook X513UA_KM513UA
  jumps/erratically tracks when the I2C bus runs at 400 kHz.
- DSDT `I2cSerialBusV2` speed `0x00061A80` = 400000 Hz on `AMDI0010:03`.
- Symptom: libinput `kernel bug: Touch jump detected and discarded`
  (nine events before rate limiting).
- Root cause: bus too fast for this touchpad under Linux (same class of
  issue as existing ELAN06FA/DLL0945 100 kHz quirks; comment notes
  Windows works at 400 kHz, so this is a Linux HCNT/LCNT/timing
  interaction, not a DSDT typo).
- Author tested: jumps gone at 100 kHz. BIOS X513UA.319 (2023-05-09).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. Explicit hardware quirk. Same pattern as the
existing `i2c_acpi_force_100khz_device_ids` entries.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/i2c/i2c-core-acpi.c` (+1 / −0)
- Function: none; one ACPI ID added to
  `i2c_acpi_force_100khz_device_ids[]`
- Scope: single-file, one-line surgical quirk

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: Before, `i2c_acpi_lookup_speed()` left ELAN1300 at DSDT 400 kHz.
After, `acpi_match_device_ids()` matches `"ELAN1300"` and sets
`lookup->force_speed = I2C_MAX_STANDARD_MODE_FREQ` (100000).
`i2c_acpi_find_bus_speed()` then returns that forced speed and logs
`FW_BUG` if it differs from the ACPI-advertised speed.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: Category **(h) hardware workaround**. Same mechanism as
DLL0945/ELAN06FA: ACPI HID match forces the adapter to 100 kHz because
400 kHz produces unusable HID reports.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct; one table entry; no API/locking/refcount
change. Regression risk is limited to other machines whose ACPI HID is
also `ELAN1300`: they would be forced to 100 kHz. Standard-mode I2C is
universally supported; previous quirks used the same HID-wide match.
Bus-wide force could slow sibling devices on `AMDI0010:03`; that is the
established tradeoff of this table.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: Table introduced by `bfd74cd1fbc02` (“i2c: Force ELAN06FA
touchpad I2C bus freq to 100KHz”, 2025-01-13). DLL0945 added by
`0b7c9528facdb` (2025-08-03). Both are in `v6.18` / `v6.18.53`. The 400
kHz force infrastructure is `7574c0db2e68c` (2019), also in this tree.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Not applicable. The “bug” is
hardware+DSDT+Linux timing, present whenever this laptop runs a kernel
that honors the 400 kHz DSDT resource.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent related commits on this file: ELAN06FA (`bfd74cd1fbc02`),
DLL0945 (`0b7c9528facdb`). Standalone; not patch X/Y. `ELAN0678` appears
in the mainline hunk context but is **not** in this 6.18 tree (`git log
--grep=ELAN0678 -- drivers/i2c/` empty; no matches in the tree). That ID
is not a prerequisite.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Only this I2C commit from Abhijeeth Babu. Acked by Mika
Westerberg; merged by Andi Shyti (`MAINTAINERS`: I2C host-driver
maintainer).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Depends on `i2c_acpi_force_100khz_device_ids` +
`i2c_acpi_lookup_speed()` force path. Both exist at `v6.18.53`.
Standalone one-line add. Applies to `v6.18.53` (`git apply --check` on
that file: rc 0).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 9e9762e578db7556bea644bb5a8a2435f63544d1` →
  https://patch.msgid.link/20260617192611.125513-1-babu.jeeth@gmail.com
- Thread: https://lore-kernel.gnuweeb.org/linux-
  acpi/ajSIc9fcALRaYhRq@zenone.zhora.eu/T/ (3 messages)
- `b4 dig -a`: v1 only; no later revisions
- No NAK. Mika Acked-by. Andi: “merged to i2c/i2c-for-7.3.” No reviewer
  `Cc: stable` request (absence is not a negative).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To Mika Westerberg, Andi Shyti; Cc linux-i2c,
linux-acpi, linux-kernel. Right maintainers on the original submission.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla. Author is the reporter: before (nine
libinput touch-jumps) / after (none). Real hardware, BIOS dated 2023.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone v1. Same table already holds ELAN06FA and DLL0945.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: gnuweeb `stable/?q=ELAN1300` hits are unrelated old stable
reviews (no this patch). No recorded reason to exclude it.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: Table `i2c_acpi_force_100khz_device_ids`; consumers
`i2c_acpi_lookup_speed()`, `i2c_acpi_find_bus_speed()`. semcode MCP not
available; used grep.

**Step 5.2: TRACE CALLERS**

Record: `i2c_acpi_find_bus_speed()` callers include:
- `drivers/i2c/busses/i2c-designware-common.c`
  (`i2c_dw_acpi_round_bus_speed`) — **this is the path for AMDI0010**
- `i2c-amd-mp2-plat.c`, `i2c-synquacer.c`, `i2c-ls2x.c`,
  `i2c-viai2c-zhaoxin.c`, `i2c-usbio.c`, `drivers/crypto/atmel-i2c.c`

`AMDI0010` is in `dw_i2c_acpi_match[]` in `i2c-designware-platdrv.c`
(line 359). Probe-time bus frequency, not a hot path.

**Step 5.3: TRACE CALLEES**

Record: `acpi_walk_namespace` → `i2c_acpi_lookup_speed` →
`acpi_match_device_ids`. Then DesignWare `i2c_dw_adjust_bus_speed()`
takes `min`/`max` with ACPI speed. Forced 100 kHz is applied at adapter
setup.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Laptop boot → DesignWare AMDI0010 probe → ACPI speed lookup →
ELAN1300 match → 100 kHz. Userspace HID/libinput then sees stable
reports. Reachable on any ACPI x86 laptop with this HID; not a rare
config.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same table already has `{ "DLL0945", 0 }` and `{ "ELAN06FA", 0
}`. This is the third instance of the same quirk.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Local tree is **6.18.53** (`make kernelversion`; `git describe
HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`). At **`v6.18.53`** the table is:

```
{ "DLL0945", 0 },
{ "ELAN06FA", 0 },
{}
```

No `ELAN1300`. Matching/force path is present. Hardware (BIOS 2023)
predates 6.18. Bug exists here.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Clean apply to `v6.18.53` (`git apply --check` rc 0). Mainline
context mentions `ELAN0678`, which is not in 6.18; the one-line add
still matches `DLL0945`/`ELAN06FA`. Difficulty: clean / trivial.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: ELAN06FA and DLL0945 are in `v6.18`. No other ELAN1300
workaround in hid/i2c (`rg ELAN1300` only this table). No alternate fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: I2C ACPI core (`drivers/i2c/i2c-core-acpi.c`). **IMPORTANT** for
ACPI laptops: input device usability. Not mm/fs/net core, but a shared
I2C path used by many x86 systems.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature. Speed-force tables have existed since 2019 (400 kHz) and
2025 (100 kHz). Low churn; ID additions are the normal maintenance
pattern.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Driver/hardware-specific: ACPI HID `ELAN1300` (reported: ASUS
VivoBook X513UA_KM513UA, I2C-HID `04F3:3104`, DesignWare `AMDI0010`).
Only those machines change behavior.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Every boot / every pointer motion at 400 kHz. Not a race.
Unprivileged user just uses the touchpad. Common on the affected laptop.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Unusable touchpad (severe jumps; libinput discards motion). Not
a panic/UAF. **MEDIUM–HIGH** for affected users (primary pointing device
broken). Fits the documented **hardware quirk** exception.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- Benefit: high for ELAN1300 laptops on 6.18.y (touchpad works).
- Risk: very low (1 line, existing table, 100 kHz is safer than 400 kHz
  for I2C slaves).
- Ratio: strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real user-visible hardware bug (tested before/after).
- Classic I2C ACPI speed quirk; table and matcher already in 6.18.53.
- One line; no new API.
- Acked by Mika Westerberg; merged by Andi Shyti; no NAK.
- Same class as ELAN06FA/DLL0945 already in this tree.

AGAINST:
- Not a crash/security/corruption issue.
- Affects a specific HID, not all machines.
- No `Fixes:`/`Cc: stable` (expected; not a negative).
- HID-wide match could slow other ELAN1300 boards to 100 kHz (accepted
  pattern; low risk).

UNRESOLVED:
- lore.kernel.org WebFetch returned 403; discussion recovered via
  b4/gnuweeb/lkml.
- How many other products share ACPI HID `ELAN1300` is unverified.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — one ID; author measured
   jumps gone.
2. Fixes a real bug that affects users? **PASS** — unusable touchpad on
   a shipping ASUS laptop.
3. Important issue? **PASS** as hardware quirk (broken input), not a
   kernel oops.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — existing quirk table.
6. Can apply to the local tree? **PASS** — table exists; applies cleanly
   to 6.18.53.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Hardware quirk/workaround** (and ACPI device-ID addition to an
existing table). Explicitly allowed for stable.

**Step 9.4: DECISION**

This 6.18.53 tree already has the 100 kHz force table and honors DSDT
400 kHz for unmatched HIDs, so ELAN1300 laptops still misbehave here.
The fix is a one-line ID add, the same mechanism already used for
ELAN06FA and DLL0945, and it applies cleanly.

What it solves for stable users: ASUS VivoBook X513UA (and any other
`ELAN1300`) touchpads stop jumping when the DesignWare `AMDI0010` bus is
left at 400 kHz.

Risk vs benefit: negligible code risk, restores a primary input device.

---

## Verification

- [Phase 1] Parsed tags: Acked-by Mika Westerberg; SOB Andi Shyti; Link
  lore msgid `20260617192611.125513-1-babu.jeeth@gmail.com`; no
  Fixes/Reported-by/Cc-stable. Ignored Upstream/Sasha markers.
- [Phase 1] Body: DSDT 0x00061A80 = 400 kHz; libinput touch jumps; BIOS
  X513UA.319 2023-05-09.
- [Phase 2] Diff: +1 `{ "ELAN1300", 0 }` in
  `i2c_acpi_force_100khz_device_ids`; `i2c_acpi_lookup_speed` sets
  `I2C_MAX_STANDARD_MODE_FREQ` (100000 in `include/linux/i2c.h`).
- [Phase 3] `git blame`: table from `bfd74cd1fbc02` (ELAN06FA, 2025-01);
  DLL0945 `0b7c9528facdb`. Both ancestors of `v6.18.53`.
- [Phase 3] `git merge-base --is-ancestor`: ELAN06FA and DLL0945 in
  v6.18.53; ELAN1300 **not** in v6.18.53 tag.
- [Phase 3] No ELAN0678 in this tree; not a dependency.
- [Phase 4] `b4 dig -c 9e9762e578db7556bea644bb5a8a2435f63544d1`: v1
  only; Mika ack; Andi merged to i2c-for-7.3; no NAK.
- [Phase 4] `b4 dig -w`: To Mika/Andi; Cc linux-i2c/linux-acpi.
- [Phase 4] Thread read via gnuweeb/lkml (lore.kernel.org fetch 403).
- [Phase 4] Stable list search for ELAN1300: no discussion of this
  patch.
- [Phase 5] Callers of `i2c_acpi_find_bus_speed`: DesignWare (AMDI0010),
  plus several other ACPI I2C hosts. `AMDI0010` in `i2c-designware-
  platdrv.c`.
- [Phase 5] semcode: namespace not present; used `rg`.
- [Phase 6] `make kernelversion` / `git describe HEAD`: 6.18.53 /
  `v6.18.53-5049-g0f0bdc2b0dffb`.
- [Phase 6] `git show v6.18.53:drivers/i2c/i2c-core-acpi.c`: table has
  DLL0945+ELAN06FA only.
- [Phase 6] `git apply --check` of the hunk onto v6.18.53 file: success
  (rc 0).
- [Phase 7] `MAINTAINERS`: Andi Shyti = I2C SUBSYSTEM HOST DRIVERS.
- [Phase 8] Failure mode: broken touchpad tracking, not oops. Severity
  MEDIUM–HIGH for affected laptops; quirk exception applies.
- UNVERIFIED: exact number of other SKUs using ACPI HID ELAN1300.

**YES**

 drivers/i2c/i2c-core-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index ed90858a27b7b..98ebbc973f212 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -372,6 +372,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 */
 	{ "DLL0945", 0 },
 	{ "ELAN06FA", 0 },
+	{ "ELAN1300", 0 },
 	{}
 };
 
-- 
2.53.0

