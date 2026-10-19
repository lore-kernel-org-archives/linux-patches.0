Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83035595CD8;
	Mon, 19 Oct 2026 13:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418394; cv=none; b=KK1fwECvRiwUM0QUobuY4RIqvJ7heFauJsqU7rW5ZXaeOr1N23PPnNU5KLM76JSikHcqkID/+E8ioeA3t+W72yFywKmF6DYIquKvVAVw1IONiAp4xTp4yz5aSkPy+C+ClAV3snhp1WXXMiyOlguVENm6zaEGwTlDATBDo0K3+sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418394; c=relaxed/simple;
	bh=es51uOIfY4ZDUFSxVfpu6zkaZGLjK1XPp+DHopqu7uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GoUPTdY/PpCKNqdu2EBmV7KRwGet+oeU6ieWoRBAvRIkn9VhRL91MJ/8c15UMqdbvPQypS4hHi8Xzx6O+uIvAl1gL2ywetS3WR+qatoas4iA8iSKrJJ82u69JBf96Np5/Hp47GOpp2nLR4QKsvK2tymhY5vDFjqratmZQqpfKeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZiTEnYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZiTEnYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDCA1F000C6;
	Mon, 19 Oct 2026 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418391;
	bh=mkawlIdJSb/yYZBHgME/6QeavKcQcI8B3RKWmpaEJOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZiTEnYhGNuH9KpWdcRjd0QMJ2Y/2YA8AgyxwcDtCDc3fD7pznD66dLEqhXNhOzd0
	 XmgsbTu4jbtmMSeUBAW+oPkvA8hWP5NniCnBwXJKsJkhAiHSvl6yYBku+O5P+AdwTW
	 hjCMoqLNUVpIz7ouYMvGPYR9ToxCwR/WfzCd5qCD7nqOJrBz1cHR2r7ZSgMFVmtGoc
	 m/GRs0Z22brf+AeU8ARbb4kJD7/K/dXSWHO/7C1ebxoPMJyr9mFqdiBchwe7jCenhs
	 z3cR23WcCjaNw/DTz4Cpn3jYs9fklx3LAdNdSPwbwXZzWlZqxZeBumjjp2k357A+eX
	 nDnDEXiFTZf2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oleg Keri <okerixx@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] HID: i2c-hid: add reset quirk for Lenovo Yoga Slim 7x Gen 11 keyboard
Date: Mon, 19 Oct 2026 09:48:27 -0400
Message-ID: <20261019135441.1420968-216-sashal@kernel.org>
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

From: Oleg Keri <okerixx@gmail.com>

[ Upstream commit 39e8e085710a2d36d9ceade11739fb7b87f5aeb0 ]

The ITE controller behind the keyboard of the Lenovo Yoga Slim 7x Gen 11
(048d:83db) carries out a reset but never raises the interrupt that
acknowledges it. i2c_hid_finish_hwreset() therefore waits out its full
one second timeout and logs "device did not ack reset within 1000 ms" on
every probe and every resume, before the keyboard comes up regardless.

Set I2C_HID_QUIRK_NO_IRQ_AFTER_RESET for it, as is already done for
several other ITE parts, so the reset is followed by a fixed 100 ms sleep
instead.

Signed-off-by: Oleg Keri <okerixx@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge this as a hardware quirk for the existing i2c-hid
driver: the 1-second reset-ack wait is in this 6.18 tree, and the new ID
only matches 048d:83db.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[HID: i2c-hid] [add] [reset quirk for Lenovo Yoga Slim 7x Gen
11 keyboard]`

Subsystem prefix is `HID: i2c-hid`. Action verb is **add** (hardware
quirk table entry). Claimed intent: stop waiting a full second for a
reset IRQ this ITE keyboard never raises.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Fixes:` — absent (expected for autosel review; not a negative signal)
- `Reported-by:` — absent
- `Tested-by:` — absent
- `Reviewed-by:` — absent
- `Acked-by:` — absent
- `Link:` — absent
- `Cc: stable@vger.kernel.org` — absent (expected)
- `Signed-off-by: Oleg Keri <okerixx@gmail.com>` (author)
- `Signed-off-by: Jiri Kosina <jkosina@suse.com>` (HID maintainer; this
  is the real maintainer SOB)
- `Signed-off-by: Sasha Levin` — ignored per instructions (pipeline)

Notable: HID maintainer applied it. No syzbot/KASAN tags. Author is a
hardware user, not a regular HID contributor (`git log --author='Oleg
Keri'` on `drivers/hid/` shows only this commit).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** ITE controller `048d:83db` on Lenovo Yoga Slim 7x Gen 11
  performs reset but never raises the ack IRQ.
- **Symptom:** `i2c_hid_finish_hwreset()` waits the full 1000 ms and
  logs `device did not ack reset within 1000 ms` on probe (author also
  says resume). Keyboard still comes up afterward.
- **Root cause:** Device does not implement the i2c-hid reset-complete
  interrupt.
- **Fix:** `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET` → 100 ms `msleep` instead
  of 1 s `wait_event_timeout`.
- **Version info:** None in the message. Cover letter (mailing list)
  identifies the machine as a Snapdragon X2 Elite (glymur) laptop.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a hidden fix. It is an explicit hardware quirk. Same class
as USB/PCI/HID quirk table additions, which stable explicitly accepts.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- `drivers/hid/hid-ids.h`: +1
  (`I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_G11_KEYBOARD 0x83db`)
- `drivers/hid/i2c-hid/i2c-hid-core.c`: +2 (quirk table entry using
  `USB_VENDOR_ID_ITE` + that ID + `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET`)
- Total: **+3 / -0**. Functions: none modified; static
  `i2c_hid_quirks[]` table only.
- Scope: **single-purpose, two-file surgical quirk**.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `i2c_hid_lookup_quirk(0x048d, 0x83db)` returns 0.
  `i2c_hid_finish_hwreset()` takes the `wait_event_timeout(..., 1000
  ms)` branch, warns, then continues.
- **After:** lookup returns `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET`. Same
  function `msleep(100)` and clears `I2C_HID_RESET_PENDING` without
  waiting for IRQ.
- Path: HID probe (`hid_add_device` → `ll_driver->parse` →
  `i2c_hid_parse` → start/finish hwreset). Initialization path, not a
  new API.

Verified `i2c_hid_finish_hwreset()`:

```508:516:drivers/hid/i2c-hid/i2c-hid-core.c
        if (ihid->quirks & I2C_HID_QUIRK_NO_IRQ_AFTER_RESET) {
                msleep(100);
                clear_bit(I2C_HID_RESET_PENDING, &ihid->flags);
        } else if (!wait_event_timeout(ihid->wait,
                                       !test_bit(I2C_HID_RESET_PENDING,
&ihid->flags),
                                       msecs_to_jiffies(1000))) {
                dev_warn(&ihid->client->dev, "device did not ack reset
within 1000 ms\n");
                clear_bit(I2C_HID_RESET_PENDING, &ihid->flags);
        }
```

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **(h) Hardware workaround.** Device never signals reset-
complete. Generic 1 s wait is correct for spec-compliant parts and wrong
for this ITE keyboard. Quirk matches the existing Voyo/Hantick/Raydium
pattern.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: identical to existing table rows;
  `USB_VENDOR_ID_ITE` is `0x048d`, matching the commit text.
- Minimal: three lines, no behavioral change for any other VID/PID.
- Regression risk: very low. Only `048d:83db` is affected. If a future
  device reused that ID and *did* ack reset, it would sleep 100 ms
  instead of waiting for IRQ — that ID is this laptop’s keyboard.
- No public API / data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Quirk flag and table date to 2017 (`402946a8ef71e`, Hantick).
- ITE Voyo entry: `fc6a31b007393` (2021-02-05), Hans de Goede.
- Timeout-as-warning (so probe still succeeds): `7bcf9ebb50f2a`
  (2023-12-06). That commit even said more `NO_IRQ_AFTER_RESET` quirks
  should become unnecessary; they still help because the 1 s wait
  remains.
- G11 ID did not exist before this change (`git show
  <parent>:drivers/hid/hid-ids.h` has Slim 7x `0x8987` only).
- Buggy *behavior* is the generic wait in `i2c_hid_finish_hwreset`,
  present for years, including this 6.18 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Not applicable. The “introduction” is hardware,
not a kernel regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Related: `a45f15808fb75` “HID: lenovo: fixup Lenovo Yoga Slim 7x
  Keyboard rdesc” (product `0x8987`, original Slim 7x, not Gen 11).
- Later in this checkout: `245d6017beff2` adds `BAD_INPUT_SIZE` for
  another device; independent.
- This commit is **patch 1/2** of “HID: Lenovo Yoga Slim 7x Gen 11
  keyboard fixes”. Patch 2 (`HID: lenovo: suppress phantom radio control
  input`) uses the `#define` this patch adds. Cover letter: each patch
  builds standalone if applied in order; this one does not need patch 2.
- Patch 2 is **not** in this tree (`git log --grep='suppress phantom
  radio'` empty; `hid-lenovo.c` has no G11 ID).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Oleg Keri has no other HID commits here. Jiri Kosina (HID
maintainer) signed off and applied it. Recipients included Benjamin
Tissoires and Lenovo’s Mark Pearson.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: No prerequisites. `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET`,
`i2c_hid_lookup_quirk()`, `USB_VENDOR_ID_ITE`, and the quirks table all
exist in the parent (`7e1d29620273b`, `v6.18.57-15-g7e1d29620273b`).
Standalone apply.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 2cb79eaedc9ed` matched lore:
  https://patch.msgid.link/20260908111812.43837-2-okerixx@gmail.com
- `b4 dig -a`:
  - v1 (2026-09-08): standalone i2c-hid patch
    `20260908091926.5773-1-okerixx@gmail.com`
  - v2 series (2026-09-08 / resend 2026-09-10): 0/2 + 1/2 + 2/2
- v2 change was **ordering only** (kbuild robot: patch 2 used an
  undeclared ID). No functional change to this quirk.
- Jiri applied 1/2 from the standalone posting (“Applied, thank you.”).
  Oleg later noted 1/2 was already applied, only 2/2 still needed.
- No NAK. No reviewer concern about the quirk itself. No `Cc: stable` in
  the thread (absence expected).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): Oleg Keri; Jiri Kosina; Benjamin Tissoires; Derek
J. Clark; Mark Pearson (Lenovo); `linux-input`; `linux-kernel`. Right
maintainers and Lenovo contact were on the original To/Cc. Maintainer
applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No bugzilla/syzbot link. Evidence is the author’s machine
(`048d:83db`) and the exact `dev_warn` string, which matches
`i2c_hid_finish_hwreset()`. Cover letter: Snapdragon X2 Elite (glymur)
Yoga Slim 7x Gen 11.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Series of two. Patch 1 (this) is self-contained. Patch 2 is hid-
lenovo input mapping for a phantom `KEY_RFKILL` collection; it needs
this `#define` but this patch does not need patch 2. Evaluating only
this commit: standalone YES.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: Web search of lore stable for this subject returned no relevant
hits. No record of a prior rejection from stable. UNVERIFIED beyond
that: lore.kernel.org search URLs returned 403 via WebFetch.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: No function bodies changed. Data consumed by
`i2c_hid_lookup_quirk()`; effect in `i2c_hid_finish_hwreset()`.

**Step 5.2: TRACE CALLERS**

Record (git grep, no semcode MCP in this session):
- `i2c_hid_lookup_quirk`: `__i2c_hid_core_probe()` — sets `ihid->quirks`
  from HID descriptor VID/PID **before** `hid_add_device()`.
- `i2c_hid_finish_hwreset`:
  1. `i2c_hid_parse()` — `.parse` of `i2c_hid_ll_driver`, called from
     `hid_add_device()` (`drivers/hid/hid-core.c:2998`). **Every
     probe.**
  2. `i2c_hid_core_resume()` — **only if**
     `I2C_HID_QUIRK_RESET_ON_RESUME`. This device is **not** given that
     quirk.

So the 1 s wait is verified on **probe**. “Every resume” is **not**
explained by `i2c_hid_core_resume()` for this ID unless the I2C HID
device is re-probed (possible on some Qualcomm/ACPI power paths). Author
may have observed re-probe; that part is not proven from this tree’s
resume function. Probe delay is enough.

**Step 5.3: TRACE CALLEES**

Record: Quirk path: `msleep(100)` + `clear_bit(I2C_HID_RESET_PENDING)`.
Default path: `wait_event_timeout` on `ihid->wait`, woken from
`i2c_hid_get_input()` when a zero-length reset-complete report arrives.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Boot/device enumeration: ACPI or OF I2C HID → `i2c_hid` probe →
fetch HID descriptor (`048d:83db`) → quirk lookup → `hid_add_device` →
`i2c_hid_parse` → hwreset. Not a syscall bug; it is the laptop keyboard
coming up. Userspace-visible: ~1 s before the keyboard is ready, plus a
warning.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same quirk already used for Hantick 5288, ITE Voyo Winpad A15,
Raydium 3118. ITE not sending reset IRQ is a known family issue. This is
not a one-off invention.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: `v6.18.57-155-gcdf239ca885b2`, `Makefile` 6.18.57.
- `i2c_hid_finish_hwreset()` 1 s timeout + warning: **yes**.
- Quirk infrastructure: **yes**.
- G11 ID before this change: **no** (parent hid-ids.h).
- i2c-hid driver: **yes** (`CONFIG_I2C_HID`, ACPI and OF).
- Glymur platform bits exist in this tree (pinctrl, rpmhpd, sound). No
  `yoga-slim7x` Gen 11 DT (only original `x1e80100-lenovo-yoga-
  slim7x.dts`). These Windows-on-ARM laptops typically enumerate I2C HID
  from **ACPI**, so the quirk does not depend on a Gen 11 DT.

Bug exists whenever this keyboard is present on 6.18.y.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Parent quirks table has the Voyo row
immediately above the insertion point, same as the diff.
`USB_VENDOR_ID_ITE` and neighboring ITE IDs already exist.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No other G11 reset fix. Slim 7x rdesc fix (`0x8987`) is a
different product. Hans’s 2023 warning change is here; it makes missing
ACK non-fatal but still waits 1 s. This quirk still does useful work.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `drivers/hid/i2c-hid` — laptop built-in keyboard over I2C-HID.
**IMPORTANT** (not core mm/VFS; not staging). Affects owners of this
Lenovo model, which is a real shipping machine.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: i2c-hid is mature (quirk table since 2016/2017) and still gets
device-specific quirks. Typical stable material.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver/hardware-specific** — only `048d:83db` (Yoga Slim 7x
Gen 11 ITE keyboard). Harmless to everyone else.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Every i2c-hid probe of that keyboard (boot; also any
unbind/rebind or platform re-probe). Not an unprivileged syscall
exploit. Timing-independent; 100% on this hardware.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Keyboard still works after the timeout (`7bcf9ebb50f2a` turned
missing ACK into a warning). User impact is **~1 second delay** plus a
warning on init. Severity **MEDIUM** as a hang/crash, but this is the
**hardware-quirk exception**, not a panic fix.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Removes a 1 s keyboard delay and a false warning on a
  current Lenovo ARM laptop that 6.18.y users can run.
- **Risk:** Very low (3 lines, VID/PID match, existing flag).
- **Ratio:** Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real hardware bug: ITE keyboard never acks reset IRQ.
- User-visible 1 s delay + warning on probe.
- Classic HID/i2c-hid quirk; same flag already used for other ITE parts.
- +3 lines, obviously correct, HID maintainer applied.
- Driver and quirk machinery exist in this 6.18.57 tree.
- Applies cleanly; no new API; no prerequisites.
- Explicit stable exception: hardware quirk / device ID for an existing
  driver.

AGAINST:
- Not a crash, UAF, deadlock, or data-corruption bug.
- `7bcf9ebb50f2a` made missing ACK non-fatal and hoped to reduce new
  quirks.
- “Every resume” is not the `RESET_ON_RESUME` path for this ID
  (unverified as a code path; author observation only).
- Patch 2 of the series is separate (not required for this fix).
- No `Reported-by` besides the author (still a real device).

UNRESOLVED:
- Could not fetch lore.kernel.org HTML (403); used `b4 dig` +
  patchew/openwall instead.
- Resume-on-this-ID not shown in `i2c_hid_core_resume()` without
  `RESET_ON_RESUME`.
- No in-tree DT for Gen 11; ACPI I2C HID still makes the quirk relevant.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — copy of existing quirk row;
   author has the laptop; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — 1 s keyboard init
   delay and warning on this model.
3. Important issue? **PASS** as hardware-quirk exception (not CRITICAL
   panic; still the class stable takes).
4. Small and contained? **PASS** — 3 lines, two files.
5. No new features or APIs? **PASS** — table entry only.
6. Can apply to the local tree? **PASS** — parent already has the table,
   flag, and ITE vendor ID.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Hardware quirk / workaround** (and a device ID on an existing
driver). Automatic stable-qualifier under the stated exceptions.

**Step 9.4: MAKE YOUR DECISION**

This should be backported to this 6.18.y tree. The i2c-hid reset-wait
bug is here; the fix is a three-line quirk for one VID/PID; risk is
negligible.

What it solves for stable users: Yoga Slim 7x Gen 11 keyboard init no
longer burns a full second waiting for an IRQ the ITE controller never
sends.

Risk vs benefit: very low risk, real delay/warning removed. No
dependencies beyond code already in 6.18.57.

===============================================================
Verification:
===============================================================
- [Phase 1] Parsed tags: author Oleg Keri; maintainer Jiri Kosina SOB;
  no Fixes/Cc stable/Reported-by (expected).
- [Phase 2] Diff: +1 hid-ids.h, +2 i2c-hid-core.c quirks table;
  `USB_VENDOR_ID_ITE` is 0x048d; finish_hwreset quirk vs 1000 ms wait
  verified in tree.
- [Phase 3] `git describe HEAD` / `make kernelversion`:
  v6.18.57-155-gcdf239ca885b2 / 6.18.57.
- [Phase 3] Parent `7e1d29620273b` lacks G11 ID; has
  Voyo/Hantick/Raydium `NO_IRQ_AFTER_RESET` rows.
- [Phase 3] Blame: flag from 402946a8ef71e (2017); ITE Voyo
  fc6a31b007393 (2021); warning 7bcf9ebb50f2a (2023).
- [Phase 3] No Fixes tag. Author has no other hid commits here.
- [Phase 3] Series 1/2; patch 2 not in this tree; this patch builds
  alone.
- [Phase 4] `b4 dig -c 2cb79eaedc9ed`: lore match
  `20260908111812.43837-2-okerixx@gmail.com`.
- [Phase 4] `b4 dig -a`: v1 standalone then v2 series (ordering only).
- [Phase 4] `b4 dig -w`: Jiri Kosina, Benjamin Tissoires, Mark Pearson,
  linux-input.
- [Phase 4] Patchew: Jiri “Applied, thank you”; kbuild robot only on
  patch 2 without this #define.
- [Phase 4] lore.kernel.org WebFetch 403; stable-list search found no
  prior discussion of this quirk.
- [Phase 5] Callers: lookup from `__i2c_hid_core_probe`; finish_hwreset
  from `i2c_hid_parse` (probe) and resume only with RESET_ON_RESUME
  (this ID does not set that).
- [Phase 5] hid_add_device → ll_driver->parse at hid-core.c:2998
  verified.
- [Phase 6] Buggy 1 s wait present; G11 ID not in parent; glymur support
  present; no Gen 11 DT; ACPI I2C HID still applies.
- [Phase 6] Parent table context matches diff; clean apply.
- [Phase 8] Failure mode: 1 s delay + warning, keyboard still works;
  severity MEDIUM; quirk exception applies.
- UNVERIFIED: author’s “every resume” vs code (resume does not call
  finish_hwreset without RESET_ON_RESUME). Did not drive the verdict;
  probe path is verified.

**YES**

 drivers/hid/hid-ids.h              | 1 +
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 11f120a5d1b90..a10b4ae0e3d8e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -737,6 +737,7 @@
 #define I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720	0x837a
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA900	0x8396
 #define I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_KEYBOARD	0x8987
+#define I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_G11_KEYBOARD	0x83db
 #define USB_DEVICE_ID_ITE8595		0x8595
 #define USB_DEVICE_ID_ITE_MEDION_E1239T	0xce50
 
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index e5a4c7deba502..62b3dd0390a7c 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -126,6 +126,8 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET | I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ I2C_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_VOYO_WINPAD_A15,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
+	{ USB_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_G11_KEYBOARD,
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ I2C_VENDOR_ID_RAYDIUM, I2C_PRODUCT_ID_RAYDIUM_3118,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ USB_VENDOR_ID_ALPS_JP, HID_ANY_ID,
-- 
2.53.0

