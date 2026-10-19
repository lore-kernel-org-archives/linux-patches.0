Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A9C5AA66D;
	Mon, 19 Oct 2026 13:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418137; cv=none; b=txFi0TSR1QifF/fnJ/Knm0kW7HLeBzaEasDlzM81Kssci/aqKF9ZHld0qsRavhPpcgtreIWg2aB32tLYqsbk8sl8IwC36f4Wquexznx1T13DtuCon2FlpJnLBRTpLpFe5WephR2qD9/o2LqiAhZS36M53/5FYjhPyCnXRIGiHZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418137; c=relaxed/simple;
	bh=xtaCHAOAz4a2OS6Vk1eD9fzhFcP81bK6rp40371+RqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aY5BfLsq5fe3oGzngJX3S63qi8C25IIRWF0ozVZIXxwsU6VAc+GzN2CbhBJUYBunAOPemUmiGel3PykACN4JU52r87qo4rGOXR9knW767L759V9p9nSTO4Kcv1TFX8VlHjEtrF15Cqe4K0s1GfSN0Dh5f+zTTSobgRaxOS31lH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPYoV5Iq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPYoV5Iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2FD1F000C4;
	Mon, 19 Oct 2026 13:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418134;
	bh=hqu6bHS4m3fKvIVckbvIo05gJFOI2yEzudMV5O4M1Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPYoV5IqRvb9+i2V8Prl931C6LPPev7UHTZe5vTQk7f8quTagExytIcgED/Vy1yN0
	 kIer4zMil8qt+CU3D1YUnrQDUIE2MMFjfulMti35INr5fo5HLDnprvfzWdEnjvrlgk
	 oPt3fzC4FwyOK73j9IPVUDMu3qAL1O/G2BJbSstdNN/pSkkYo9HncsCai4jkzIeFpY
	 pLflZA4B9nMBJYwVufHD/67dGe+qdfWSZoN/Om5fYk+/ejb9U0cufkUbF6nBiEkLXQ
	 crknB0LJtJMhN/0M7kvdEU44mWJDoA6HL/HLPEM4soIPGpaEmgssTeOLW8WA17Dcik
	 y+qU1bgCMCreA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Robert Leussler <robert.leussler@leica-geosystems.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-rtc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] rtc: ds1307: fix RX8130 wakeup alarm WADA bit for day-of-month mode
Date: Mon, 19 Oct 2026 09:45:27 -0400
Message-ID: <20261019135441.1420968-36-sashal@kernel.org>
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

From: Robert Leussler <robert.leussler@leica-geosystems.com>

[ Upstream commit 878d93aaa596a861dbc8d71f7c38e62a2e805f01 ]

The RX8130 wakeup alarm never fired when set via
/sys/class/rtc/rtc0/wakealarm. The root cause is that the WADA bit
(bit 3) in the Extension register (0x1c) was never set before
programming the alarm registers.

Per the RX8130 datasheet:
WADA=0 - Week alarm: register 0x19 is compared against day-of-week
WADA=1 - Day alarm:  register 0x19 is compared against day-of-month

rx8130_set_alarm() always writes a BCD day-of-month value to alarm
register 0x19, so WADA must be 1. With WADA=0 the hardware matched the
day-of-month value (e.g. 15) as a day-of-week index, which is always
out of range (valid weekdays are 0-6), so the alarm interrupt was never
asserted.

Fix by setting the WADA bit in rx8130_set_alarm() before writing the
Extension register back to the device.

This is consistent with rx8130_read_alarm(), which decodes the same
register under the same assumption (24-hour and day-of-month mode).

Signed-off-by: Robert Leussler <robert.leussler@leica-geosystems.com>
Link: https://patch.msgid.link/20260721081907.3518648-1-robert.leussler@leica-geosystems.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line RX8130 wakeup-alarm fix. The buggy `&=` is present in
this 6.12.111 tree, the datasheet matches the new polarity, and the
patch applies cleanly.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: **[rtc/ds1307] [fix] RX8130 wakeup alarm never fires because
WADA is not set for day-of-month mode**

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none (author is from Leica Geosystems; they hit this on
  hardware)
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** `https://patch.msgid.link/20260721081907.3518648-1-
  robert.leussler@leica-geosystems.com`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Robert Leussler (author); Alexandre Belloni (RTC
  maintainer). Ignore any Sasha Levin SOB if later added by the
  pipeline.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** RX8130 wakeup alarm never fires when set via
  `/sys/class/rtc/rtc0/wakealarm`.
- **Symptom:** scheduled RTC wakeup does not occur; `/IRQ` is never
  asserted.
- **Root cause:** `rx8130_set_alarm()` writes BCD day-of-month to alarm
  register 0x19 but never sets WADA (Extension 0x1c bit 3). With WADA=0
  the chip compares 0x19 as a week alarm.
- **Version info:** none in the message. Code has been in-tree since
  RX8130 support (v4.13); the current `&=` form dates to 2019.
- **Author’s fix:** `ctl[0] &= WADA` → `ctl[0] |= WADA` so WADA=1 (day-
  of-month), matching `rx8130_read_alarm()`.

### Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. Explicit hardware-logic fix. The `&=` → `|=` change
also stops wiping other Extension bits (FSEL/USEL/TE/TSEL), which is
extra correctness, not a drive-by refactor.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/rtc/rtc-ds1307.c` — **1 line changed** (`&=` → `|=`)
- Function: `rx8130_set_alarm()`
- Scope: single-file surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** after reading Extension/Flag/Control0, `ctl[0] &= BIT(3)`
  keeps only the current WADA bit (typically 0 from POR) and **clears
  every other Extension bit**, then writes it back, then programs
  min/hour/**mday**.
- **After:** `ctl[0] |= BIT(3)` **sets WADA=1** and **preserves**
  FSEL/USEL/TE/TSEL, then programs the same mday alarm.

### Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** logic / hardware-programming correctness (wrong alarm
  mode bit).
- **Mechanism:** RX8130 WADA selects week vs day comparison for register
  0x19. Driver always writes `bin2bcd(tm_mday)` to 0x19, so WADA must be
  1. WADA=0 makes the chip treat that BCD value as a week-alarm bitmap,
  so the alarm either never matches or matches the wrong weekdays.

Verified from Epson RX8130CE application manual (Table 23):
- WADA=0 → WEEK is the alarm target
- WADA=1 → DAY (day-of-month) is the alarm target
- Example “Day” settings explicitly use WADA=1

### Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** obviously correct. One operator change; polarity matches
  the datasheet and the existing read path (`tm_mday`, comment “day-of-
  month modes”).
- **Regression risk:** very low. Only RX8130 `set_alarm`. `|=` is the
  correct RMW (old `&= BIT(3)` was also clobbering FSEL/TE/TSEL). No
  API/lock/struct change.
- The author’s “valid weekdays are 0-6, so mday 15 never matches” is
  slightly imprecise: week mode is a **bitmap**, so some BCD mday values
  can match the wrong weekdays. Failure mode is still “alarm broken,”
  possibly worse than “never fires.”

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
Record:
- Buggy line `ctl[0] &= RX8130_REG_EXTENSION_WADA` introduced by
  **3f929cad94338** (“rtc: ds1307: rx8130: Fix alarm handling”, Uwe
  Kleine-König, 2019-01-25).
- First appeared: **v5.1-rc1**. Present in this tree (`git merge-base
  --is-ancestor` succeeded).
- RX8130 support itself: **ee0981be77045** (v4.13-rc1), which used
  `ctl[0] &= ~WADA` (explicitly **cleared** WADA).

### Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Historical introducer is 3f929cad94338, which is
in this tree.

That 2019 commit **intended** to “clear WADA for day-of-month,” but:
1. Its datasheet polarity was inverted vs Epson (it treated WADA=1 as
   weekdays).
2. Its diff changed `&= ~WADA` to `&= WADA` (dropped `~`), which does
   **not** clear WADA; it preserves WADA and zeros other Extension bits.

Original 2017 code already chose the wrong polarity for mday. The 2019
change left WADA at POR 0 and made Extension clobber worse.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record (recent on this file in this tree):
- `e0e6ddc431177` rtc: ds1307: Fix off-by-one issue with wday for rx8130
  — **time** wday encoding, not alarm WADA. Independent; already here.
- `204756f016726` rtc: ds1307: Fix wday settings for rx8130 — also time,
  not alarm.
- `3f929cad94338` — the buggy alarm handling change.

Standalone one-line fix; not patch X/Y.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Robert Leussler has no other rtc commits in this tree. Alexandre
Belloni (RTC maintainer) signed off and applied it. Weight comes from
maintainer application + hardware report, not from a regular-contributor
history.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Diff only needs `rx8130_set_alarm()` and
`RX8130_REG_EXTENSION_WADA`, both present. `git show 878d93aaa596 | git
apply --check` **succeeded** on this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 878d93aaa596` → https://patch.msgid.link/20260721081907.351
  8648-1-robert.leussler@leica-geosystems.com
- `b4 dig -a`: **v1 only** (no v2/v3)
- Thread: submission (2026-07-21) → Sashiko AI note on pre-existing FLAG
  RMW → author reply (2026-08-10): FLAG issue is pre-existing and out of
  scope → **Alexandre Belloni: “Applied, thanks!”** (2026-08-20), no NAK
- lore.kernel.org WebFetch returned 403; thread recovered via `b4 dig
  -m` and openwall/spinics

### Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc were Alexandre Belloni, linux-rtc, linux-
kernel. Maintainer applied it. No other human Reviewed-by.

### Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot. Concrete userspace trigger in the message
(`/sys/class/rtc/rtc0/wakealarm`). Author is an RX8130 user (Leica
Geosystems). Sashiko flagged a **pre-existing** write-0-to-clear FLAG
RMW (VLF); author correctly kept that separate. That does not weaken
this WADA fix.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone 1/1. Not part of a multi-patch series.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable WebFetch 403. No other evidence of a
stable NAK. Absence of prior stable discussion is not a negative.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS
Record: `rx8130_set_alarm()` only.

### Step 5.2: TRACE CALLERS
Record:
- Wired as `rx8130_rtc_ops.set_alarm` in `drivers/rtc/rtc-ds1307.c`
- RTC core: `rtc_set_alarm()` / `__rtc_set_alarm()` in
  `drivers/rtc/interface.c`
- Userspace: `drivers/rtc/sysfs.c` (`wakealarm`), plus `RTC_WKALM_SET` /
  `RTC_ALM_SET` ioctls
- Reachable whenever RX8130 alarm IRQ or `wakeup-source` is enabled
  (chip desc has `.alarm = 1`)

### Step 5.3: TRACE CALLEES
Record: `regmap_bulk_read/write` of Extension+Flag+Control0 and alarm
min/hour/day, then optional Control0 AIE write. No alloc/locking in this
function.

### Step 5.4: FOLLOW THE CALL CHAIN
Record: `echo T > /sys/class/rtc/rtc0/wakealarm` or `rtcwake` →
`rtc_set_alarm` → `rx8130_set_alarm`. Unprivileged access depends on rtc
device node permissions; typical embedded images use this for suspend
wakeup. **Yes, userspace-reachable.**

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Sibling Epson/MicroCrystal chips also program WADA, with **chip-
specific polarity** (RX8010 clears WADA while writing mday;
RV8803/RV3028/RV3032 set WADA). Not a copy-paste of those; RX8130
datasheet is the authority. No second broken copy in `rtc-ds1307.c`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Tree: **`git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`**, **`make
  kernelversion` = 6.12.111**
- Buggy code is here at `drivers/rtc/rtc-ds1307.c:665`: `ctl[0] &=
  RX8130_REG_EXTENSION_WADA;`
- `git merge-base --is-ancestor 878d93aaa596 HEAD` → **not an ancestor**
  (fix not in this tree)
- `git merge-base --is-ancestor 3f929cad94338 HEAD` → **yes** (bug is in
  this tree)
- Bug introduced v5.1 (wrong `&=` form); wrong polarity since v4.13

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** (`git apply --check` exit 0). Surrounding
`rx8130_set_alarm()` matches the mainline hunk. No rework needed.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: wday off-by-one (`e0e6ddc431177`) is already here and is a
different bug. No existing WADA `|=` fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **drivers/rtc** (Epson RX8130 in rtc-ds1307). Criticality:
**PERIPHERAL** for the kernel as a whole, **IMPORTANT** for boards that
use this RTC as the wake source.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: rtc-ds1307 still gets real fixes in this tree (OSF, max clock
rate, wday). Mature driver; this is a long-standing programming error,
not churn from new code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific** — `CONFIG_RTC_DRV_DS1307`
+ Epson RX8130 (`epson,rx8130` / `rx8130`) with alarm/wakeup wired.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Any `set_alarm` / `wakealarm` / `rtcwake` on RX8130. Common on
embedded systems that sleep and wake on RTC. Not a rare error path.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure: RTC alarm IRQ/`/IRQ` does not fire as intended → **system
  fails to wake from suspend** at the scheduled time (or wakes on the
  wrong weekday if the BCD mday happens to look like a week bitmap).
- Severity: **HIGH** for those devices (lost wakeup; device can stay
  asleep). Not a KASAN/UAF/panic.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** high for RX8130 users — restores the documented
  alarm/wakeup path.
- **Risk:** very low — 1 line, polarity confirmed by datasheet,
  maintainer applied, no locking/API change.
- **Ratio:** strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR:**
- Real user-visible bug: RX8130 `wakealarm` does not work
- Datasheet-confirmed WADA polarity (0=week, 1=day)
- Driver always writes `tm_mday`; WADA must be 1
- Buggy `&=` is in this 6.12.111 tree; fix is not
- 1-line, obviously correct; apply-check clean
- RTC maintainer applied after review window; no NAK
- Also stops Extension-register clobber of FSEL/TE/TSEL
- Standalone; no prerequisites missing here

**AGAINST:**
- Not a crash/security/corruption issue
- Only RX8130, not all rtc-ds1307 chips
- No Fixes:/Cc:stable (expected; not a negative)
- No second independent reporter beyond the author

**UNRESOLVED:**
- Could not fetch lore.kernel.org or lore.kernel.org/stable (403);
  thread recovered via b4/openwall
- Did not re-test on hardware (author did; commit describes
  `/sys/class/rtc/rtc0/wakealarm`)

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — datasheet + maintainer apply
   + hardware report
2. Fixes a real bug that affects users? **PASS** — wakeup alarm broken
   on RX8130
3. Important issue? **PASS** — failed RTC wakeup / wrong-day match; HIGH
   for this hardware
4. Small and contained? **PASS** — 1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean apply; buggy code
   present

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary
contained driver bugfix.

### Step 9.4: MAKE YOUR DECISION
This 6.12.111 tree has the 2019 `&= WADA` bug. The fix is the smallest
possible correction so the chip compares day-of-month the way the driver
already programs it. That is exactly the kind of hardware bug stable
users of this RTC need.

Verification:
- [Phase 1] Parsed tags: Link to patch.msgid.link; SOBs Leussler +
  Belloni; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: 1 line in `rx8130_set_alarm()`, `&=` → `|=` on
  `RX8130_REG_EXTENSION_WADA`
- [Phase 2] Datasheet (Epson RX8130CE app manual Table 23): WADA=0 week,
  WADA=1 day — matches the patch
- [Phase 3] git blame: line from 3f929cad94338 (v5.1-rc1); original
  support ee0981be77045 (v4.13) used `&= ~WADA`
- [Phase 3] git show 3f929cad94338: dropped `~`, inverted polarity vs
  datasheet
- [Phase 3] git merge-base --is-ancestor 3f929cad94338 HEAD: yes;
  878d93aaa596 HEAD: no
- [Phase 4] b4 dig -c 878d93aaa596: lore msgid 20260721081907.3518648-1
- [Phase 4] b4 dig -a: v1 only
- [Phase 4] b4 dig -w: Belloni + linux-rtc + linux-kernel
- [Phase 4] b4 mbox: Belloni “Applied, thanks!”; Sashiko FLAG note pre-
  existing, not a NAK
- [Phase 5] `rx8130_set_alarm` is `rtc_class_ops.set_alarm`; sysfs
  `wakealarm` calls `rtc_set_alarm()`
- [Phase 6] git describe HEAD: p-6.12-3-gc504cf0baa3d8; kernelversion
  6.12.111; line 665 still `&=`
- [Phase 6] `git apply --check` of 878d93aaa596: clean
- [Phase 8] Failure mode: RTC wakeup does not fire (or fires on wrong
  weekdays); HIGH for RX8130 boards
- UNVERIFIED: live lore.kernel.org/stable HTML (HTTP 403); hardware
  retest in this environment

**YES**

 drivers/rtc/rtc-ds1307.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 9ba5958ca7a6e..d9a8e5045e37d 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -662,7 +662,7 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (ret < 0)
 		return ret;
 
-	ctl[0] &= RX8130_REG_EXTENSION_WADA;
+	ctl[0] |= RX8130_REG_EXTENSION_WADA;
 	ctl[1] &= ~RX8130_REG_FLAG_AF;
 	ctl[2] &= ~RX8130_REG_CONTROL0_AIE;
 
-- 
2.53.0

