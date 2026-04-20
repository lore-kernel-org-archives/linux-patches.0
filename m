Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41E83AB28E;
	Mon, 20 Apr 2026 13:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691968; cv=none; b=m8cl59mE/6iurJCOos++gAVlwnuhbvDxNK1a7ScgebvzHMVx8TbBOUskm8KgWEDKXBiajtAfkj2LfwnLgnywT0uXdc/n8h4BupgMOxD00+EaupyELEHHSaCgZLerS3OTPyAtlIq6cNYX2mtl8XUXPDuolb3ynyKFhcOp2uD+JoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691968; c=relaxed/simple;
	bh=dl/KSAVgNXpqg6W2a+h/Rq4UV9ZqAUqgFihOVvGECmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GT4+iLjt4+OOsp896Id7AehxuliFNIlCBZ3wUo2uIkIclO4Lw3J/EtKUbpT2wtk3KWm9bLB3Xyq51tkV9i749NdVLcxJQ6SvBUhpfy1OvOxC7vpyyASXohkX+fhVLZGw/1yQVwbNTtaiSSXclPE43w/i/ZBtFDnlvKioYVeL9d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AuImcncQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AuImcncQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B4EC2BCB9;
	Mon, 20 Apr 2026 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691968;
	bh=dl/KSAVgNXpqg6W2a+h/Rq4UV9ZqAUqgFihOVvGECmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuImcncQbHuyfTzJ3yrO3u0drDKAX3P9kk2UfugvwldYeNzV/NTCVlVMS3l8cygkU
	 xFBHADO9xH/cSDOoDq6wtLdz1jRQ1/tebNEL9E6dzcP5CZoo/HXRM/IUgDuln86WKm
	 NXdSOolIebdpxezd9OzeXPqkqYGrqQH6oSEyIwyQWn5G6bJRXD0CFdHiYY1BiMahWL
	 xci1zbAVsk5u3144sZ6HcbmqWfFhUZb8ThyleZ5zLbd7k9Rapb1me0dCctsIk+whbM
	 hht5ijN2r5l6WWlEABUJ21sES5+v6i7fclSpXG6iyYiKp59h8CWEbJo8EWfs5L6BmH
	 e6Y/tnZqIewBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	roderick.colenbrander@sony.com,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] HID: playstation: validate num_touch_reports in DualShock 4 reports
Date: Mon, 20 Apr 2026 09:21:30 -0400
Message-ID: <20260420132314.1023554-296-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit 82a4fc46330910b4c1d9b189561439d468e3ff11 ]

The DualShock 4 HID driver fails to validate the num_touch_reports field
received from the device in both USB and Bluetooth input reports.
A malicious device could set this field to a value larger than the
allocated size of the touch_reports array (3 for USB, 4 for Bluetooth),
leading to an out-of-bounds read in dualshock4_parse_report().

This can result in kernel memory disclosure when processing malicious
HID reports.

Validate num_touch_reports against the array size for the respective
connection types before processing the touch data.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to make my analysis. Let me compile the
complete assessment.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line parse**
Record: `[HID: playstation:]` `[validate]` - validates
`num_touch_reports` in DualShock 4 USB and Bluetooth input reports to
prevent out-of-bounds reads from malicious HID devices.

**Step 1.2: Commit message tags**
Record:
- `Signed-off-by: Benoît Sevens <bsevens@google.com>` - author from
  Google (security researcher who has found and fixed multiple HID/USB
  vulnerabilities)
- `Signed-off-by: Jiri Kosina <jkosina@suse.com>` - HID subsystem
  maintainer applied it
- **No** `Fixes:`, `Reported-by:`, `Reviewed-by:`, `Tested-by:`,
  `Link:`, or `Cc: stable` tags (expected absence of stable tag - that's
  why review is needed)

**Step 1.3: Commit body analysis**
Record: The commit explicitly describes a security vulnerability: a
malicious HID device can set `num_touch_reports` in the input report
payload to an arbitrary u8 value (0-255). Since the `touch_reports[]`
arrays are fixed at size 3 (USB) and 4 (Bluetooth), values >3/4 cause
out-of-bounds reads in `dualshock4_parse_report()`, leading to **kernel
memory disclosure**. Root cause: missing bounds check on device-supplied
count.

**Step 1.4: Hidden bug fix detection**
Record: Not hidden - the commit is explicitly a security fix. The
language "validate" + "malicious device" + "kernel memory disclosure" +
"out-of-bounds read" is textbook security fix vocabulary.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: 1 file (`drivers/hid/hid-playstation.c`), 12 lines added, 0
removed. Modifies one function: `dualshock4_parse_report()`.
Classification: single-file surgical fix.

**Step 2.2: Code flow change**
Record:
- Before: Code blindly trusted `usb->num_touch_reports` and
  `bt->num_touch_reports` from device, used them as loop bound for
  `touch_reports[]` array access at line 2482.
- After: Validates both fields against `ARRAY_SIZE(touch_reports)`
  before use; returns `-EINVAL` with `hid_err()` log on bogus values.

**Step 2.3: Bug mechanism**
Record: Category (f) memory safety / bounds check fix. The
`num_touch_reports` is a u8 field in the HID report, attacker-controlled
(up to 255). The later loop `for (i = 0; i < num_touch_reports; i++) {
struct dualshock4_touch_report *touch_report = &touch_reports[i]; ...}`
dereferences each `touch_report` and reads `.contact`, `.x_hi`, `.x_lo`,
`.y_hi`, `.y_lo` fields, then feeds them into `input_report_abs()`. With
`num_touch_reports=255` (u8 max) × 9 bytes per `dualshock4_touch_report`
= up to 2,295 bytes of OOB read beyond the 64-byte USB (or 78-byte BT)
report buffer. Disclosed content can potentially leak to userspace via
the resulting input events.

**Step 2.4: Fix quality**
Record: Obviously correct - `ARRAY_SIZE()` is the canonical sizeof-based
macro, the comparison is unsigned-safe, and the return path properly
propagates the error. Zero regression risk: only an early return when
invalid input is detected; valid devices (which set num_touch_reports ≤
3 or ≤ 4) are completely unaffected. No locking, memory, or API changes.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Record: The buggy loop `for (i = 0; i < num_touch_reports; i++)` was
introduced in commit `752038248808a` ("HID: playstation: add DualShock4
touchpad support") by Roderick Colenbrander, 2022-10-29. The BT path
(`bt->num_touch_reports = ...`) was added in `2d77474a239294` same day.
`git describe --contains 752038248808a7` returns `v6.2-rc1~115^2~2^2~11`
— so the bug landed in **v6.2**.

**Step 3.2: Fixes: tag**
Record: No Fixes: tag present. However, git blame clearly points to
`752038248808a` (v6.2) and `2d77474a239294` (v6.2) as the introducing
commits. Neither exists in pre-6.2 stable trees (5.15.y, 5.10.y, 4.19.y,
etc.).

**Step 3.3: File history**
Record: File has seen churn (cleanup commits from Cristian Ciocaltea in
2025-06: u8 migration `134a40c9d6d9b`, alignment fixes `56d7f285bfaa38`,
guard/scoped_guard refactoring `a38d070ffe338`), but none that would
significantly affect the specific hunks modified by this patch. The
`num_touch_reports` access pattern and struct layout are unchanged since
v6.2.

**Step 3.4: Author's other commits**
Record:
```
d802d848308b3 HID: roccat: fix use-after-free in roccat_report_event
2f1763f62909c HID: wacom: fix out-of-bounds read in wacom_intuos_bt_irq
082dd785e2086 media: uvcvideo: Refactor frame parsing code...
b909df18ce2a9 ALSA: usb-audio: Fix potential out-of-bound accesses for
Extigy and Mbox
ecf2b43018da9 media: uvcvideo: Skip parsing frames of type
UVC_VS_UNDEFINED
```
Record: Benoît Sevens is a Google security researcher. His HID/USB bug
fixes (e.g., wacom OOB) have been AUTOSEL'd into stable 5.10–6.19.
Strong trust indicator.

**Step 3.5: Dependencies**
Record: Standalone patch. Uses only `ARRAY_SIZE()`, `hid_err()`, and
struct fields that have existed since v6.2. No prerequisites.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original submission**
Record: `b4 dig -c 82a4fc4633091` found it immediately at `https://lore.
kernel.org/all/20260323124737.3223129-1-bsevens@google.com/`. Only v1
exists — no review iterations.

**Step 4.2: Recipients**
Record: `b4 dig -w` shows To: Roderick Colenbrander (original DS4
author, Sony), Jiri Kosina (HID maintainer, jikos@kernel.org), Benjamin
Tissoires (HID co-maintainer, bentiss@kernel.org), Cc: linux-input,
linux-kernel. Maintainer-appropriate recipient list.

**Step 4.3: Discussion thread**
Record: Thread saved to `/tmp/playstation-thread.mbox`. Only one reply -
from Jiri Kosina:
> "Applied now to hid.git#for-7.0/upstream-fixes, thanks!"

Applied to the "upstream-fixes" branch, i.e., treated as a bug fix for
the current merge window, not "next". No NAK, no concerns raised. No
explicit stable nomination in the thread, but the maintainer considered
it an urgent fix (upstream-fixes branch).

**Step 4.4: Related series**
Record: Not part of a series - single standalone patch.

**Step 4.5: Stable list history**
Record: No prior stable discussion found for this specific bug. Similar
sibling fix (`HID: wacom: fix out-of-bounds read in wacom_intuos_bt_irq`
by the same author) was AUTOSEL'd to stable 5.10-6.19 per public archive
— same author, same class of fix, same quality profile.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions modified**
Record: Only `dualshock4_parse_report()`.

**Step 5.2: Callers**
Record: `dualshock4_parse_report` is assigned to `ps_dev->parse_report`
(line 2720) and called via the dongle path at line 2603 and ultimately
from `ps_raw_event` (line 2824-2825) which is the `.raw_event` callback
in `ps_driver` (line 2923). The chain is: HID core `hid_input_report()`
→ driver's `.raw_event` → `ps_raw_event` → `dualshock4_parse_report`.
This is called for **every input report** from any device matching Sony
PS4 controller USB/BT IDs.

**Step 5.3: Callees**
Record: Inside the loop, `input_mt_slot()`,
`input_mt_report_slot_state()`, `input_report_abs()` consume data read
from `touch_reports[i]`. Reading OOB does not crash directly (these are
arithmetic operations on u8 fields) but the leaked data flows as input
coordinates and touchpoint activity to userspace input event consumers.

**Step 5.4: Reachability**
Record: Triggerable by any device that enumerates with USB VID/PID or BT
identification matching `USB_VENDOR_ID_SONY` +
`USB_DEVICE_ID_SONY_PS4_CONTROLLER[_2]` (list at lines 2893-2903).
Attacker scenarios:
- Physical USB plug of a crafted device
- Bluetooth-proximate attacker masquerading as a DualShock 4
No root privileges required - kernel trusts device-reported data.

**Step 5.5: Similar patterns**
Record: Other HID drivers have similar validation patterns added
recently (wacom_intuos_bt_irq length checks, `HID: multitouch: Check to
ensure report responses match the request`). Same author has
systematically audited HID drivers for malicious-device OOB reads. This
fits the established pattern.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code presence in stable**
Record: Verified with `git cat-file -p v6.2:drivers/hid/hid-
playstation.c` through `v6.15`. All versions from v6.2 onward contain
the identical vulnerable code (`num_touch_reports` usage). `v6.1` does
NOT contain DS4 support in this file. Affected stable trees: **6.6.y,
6.12.y, 6.15.y, 6.16.y, 6.17.y and any active stable ≥ 6.2**. NOT
affected: 6.1.y, 5.15.y, 5.10.y, 4.19.y.

**Step 6.2: Backport difficulty**
Record: Minor context differences — in pre-2025 stable trees (e.g.,
v6.6), the `u32` is spelled `uint32_t` and `u8` is spelled `uint8_t`.
The actual changed lines (`if (usb->num_touch_reports >
ARRAY_SIZE(usb->touch_reports))`) use only struct field names and
`ARRAY_SIZE`, which are identical across all affected stable trees.
Expected to apply cleanly with a tiny fuzz or minor manual adjustment.
In v6.12+, structs already use `u8` so the patch applies 1:1.

**Step 6.3: Related fixes in stable**
Record: No prior fix for this specific issue in stable.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
Record: `drivers/hid/` - HID subsystem, specifically the generic `hid-
playstation` driver covering a widely-used gaming controller family.
IMPORTANT criticality (widely used on desktops, laptops, SteamOS/Steam
Deck, and gaming setups). Security-relevant because HID devices can be
hot-plugged by untrusted users.

**Step 7.2: Subsystem activity**
Record: Active subsystem — 69 commits to this file since initial
addition. Regular fixes and feature additions. Maintainer is responsive
(applied patch within weeks).

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected users**
Record: Anyone with `CONFIG_HID_PLAYSTATION=m/y` (common default in
distros) who connects a DualShock 4 — real or attacker-crafted. Applies
across USB and Bluetooth. Config-dependent but the config is widely
enabled.

**Step 8.2: Trigger conditions**
Record: A device that identifies as Sony PS4 controller (USB VID 0x054C
+ PID 0x05C4/0x09CC, or BT equivalent) sends a crafted input report with
`num_touch_reports > 3` (USB) or `> 4` (BT). Unprivileged attacker can
trigger via physical USB access or Bluetooth proximity + pairing. No
local privileges needed.

**Step 8.3: Severity**
Record: **HIGH severity**. Out-of-bounds read of ~2 KB of adjacent
kernel memory per malicious report. Consequences:
- Kernel memory disclosure (KASLR bypass via pointer leakage, leaking
  kernel data structures, potentially credentials/secrets if mapped
  nearby)
- No direct crash (no memory writes, no deref of wild pointers) but
  information leak is a well-recognized security class
- Sets the stage for chained exploitation

**Step 8.4: Risk-benefit**
Record:
- BENEFIT: High - fixes an exploitable kernel information disclosure in
  a widely-deployed driver
- RISK: Very low - 12 lines added, pure input validation, no behavior
  change for valid devices, no locking/memory model changes, returns
  -EINVAL which drops the report (graceful)
- Ratio: Strongly favors backporting.

## PHASE 9: SYNTHESIS

**Step 9.1: Evidence**
FOR:
- Explicit security fix (kernel memory disclosure) from a Google
  security researcher
- Trivially correct input validation (compared with compile-time
  ARRAY_SIZE)
- Zero regression risk: only drops malformed reports that already would
  have led to OOB reads
- Maintainer applied to `for-7.0/upstream-fixes` (treated as fix-track,
  not feature)
- Same author's sibling HID fixes (wacom OOB) have been AUTOSEL'd into
  stable
- Reachable by unprivileged users via USB/BT
- Affects all stable trees ≥ 6.2

AGAINST: None material. (Lack of Cc: stable / Fixes: tag is expected and
not a negative signal per the instructions.)

UNRESOLVED: None of substance.

**Step 9.2: Stable rules check**
1. Obviously correct/tested: YES — code is trivially correct; maintainer
   applied it
2. Real bug affecting users: YES — any malicious/broken HID device
   triggers it
3. Important issue: YES — kernel information disclosure, security-
   relevant
4. Small and contained: YES — 12 lines, single file, single function
5. No new features/APIs: YES — pure validation
6. Applies to stable: YES — minor context adjustments for uint8_t/u8 in
   older trees, otherwise clean

**Step 9.3: Exception category**
Record: Security fix for existing, shipped, widely-deployed driver -
meets the "fixes a real bug" criterion directly; not needed as a special
exception.

**Step 9.4: Decision**
Backport recommended.

## Explanation

The commit fixes a real kernel information disclosure vulnerability in
the `hid-playstation` driver. A malicious USB or Bluetooth device
advertising Sony PS4 controller IDs can provide a `num_touch_reports`
value larger than the fixed `touch_reports[3]` (USB) or
`touch_reports[4]` (BT) arrays in the HID report struct. The subsequent
loop in `dualshock4_parse_report()` reads up to ~2 KB of adjacent kernel
memory and feeds it to userspace input events, leaking kernel data.

The fix is textbook stable material: 12 lines of added input validation,
zero behavioral change for legitimate devices, no locking/memory model
changes, and no new APIs. The author (Benoît Sevens, Google) has a track
record of similar HID fixes (roccat UAF, wacom OOB) where comparable
fixes have been AUTOSEL'd into stable 5.10–6.19. The HID maintainer
(Jiri Kosina) applied the patch to the upstream-fixes branch, signaling
he considers it a fix rather than a feature.

The buggy code landed in v6.2 (commits `752038248808a`,
`2d77474a239294`), so stable trees ≥ 6.2 (6.6.y, 6.12.y, etc.) are all
affected and should receive this fix. The patch should apply cleanly
with only minor context fuzz in pre-`u8` stable branches.

## Verification

- [Phase 1] Parsed tags: only SoB tags, no Reported-by/Fixes/Cc:stable.
  Verified by reading commit message.
- [Phase 2] Diff analysis: verified 12 added lines in
  `dualshock4_parse_report()` - two parallel `if (usb->num_touch_reports
  > ARRAY_SIZE(usb->touch_reports))` / `... bt->... >
  ARRAY_SIZE(bt->touch_reports)` checks with `hid_err()` + `return
  -EINVAL`.
- [Phase 2] Verified struct layouts: `struct
  dualshock4_input_report_usb.touch_reports[3]` (line 482), `struct
  dualshock4_input_report_bt.touch_reports[4]` (line 492),
  `num_touch_reports` is u8 (lines 481, 491).
- [Phase 2] Verified consumer loop at line 2482: `for (i = 0; i <
  num_touch_reports; i++) { struct dualshock4_touch_report *touch_report
  = &touch_reports[i]; ... }` confirms OOB read.
- [Phase 3] `git blame -L 2482,2483` confirmed buggy loop introduced by
  commit `752038248808a7` (Roderick Colenbrander, 2022-10-29).
- [Phase 3] `git blame -L 2380,2396` confirmed BT path introduced by
  `2d77474a239294`.
- [Phase 3] `git describe --contains 752038248808a7` =
  `v6.2-rc1~115^2~2^2~11`; `2d77474a239294` = `v6.2-rc1~115^2~2^2~4` —
  both are pre-v6.2 rc1, so land in v6.2.
- [Phase 3] Author commit list: `git log --author="bsevens"` shows
  roccat UAF, wacom OOB, ALSA Extigy OOB - consistent security fix
  pattern.
- [Phase 4] `b4 dig -c 82a4fc4633091` found submission at `https://lore.
  kernel.org/all/20260323124737.3223129-1-bsevens@google.com/`.
- [Phase 4] `b4 dig -a`: only v1 - no review iterations.
- [Phase 4] `b4 dig -w`: recipients = Roderick Colenbrander (Sony), Jiri
  Kosina, Benjamin Tissoires, linux-input. Appropriate.
- [Phase 4] `b4 dig -m` + read /tmp/playstation-thread.mbox: Jiri Kosina
  reply confirms "Applied now to hid.git#for-7.0/upstream-fixes,
  thanks!" - treated as fix.
- [Phase 4] Web search confirmed sibling `HID: wacom: fix out-of-bounds
  read in wacom_intuos_bt_irq` was AUTOSEL'd to 5.10-6.19 stable.
- [Phase 5] Verified call chain: `.raw_event = ps_raw_event` (line 2923)
  → `ps_raw_event` (2819) → `dev->parse_report` (2825) assigned to
  `dualshock4_parse_report` at line 2720.
- [Phase 5] Verified ID table at lines 2893-2903 (Sony PS4 USB + BT
  IDs).
- [Phase 6] `git cat-file -p vX:drivers/hid/hid-playstation.c | grep
  num_touch_reports` for v6.2-v6.15 each returned 6 matches — consistent
  code present across all post-v6.2 trees; v6.1 returned 0 (driver path
  absent).
- [Phase 6] Verified v6.6 struct definitions (uint8_t spelling) — patch
  would need trivial context refit for pre-2025 stable trees but target
  lines are identical.
- UNVERIFIED: Whether the raw HID buffer passed into `raw_event` in
  practice is always exactly 64/78 bytes or larger (irrelevant to
  decision — even at 64+7 bytes, 255 touch entries still far exceeds the
  buffer, so the security impact holds).

**YES**

 drivers/hid/hid-playstation.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index 3c0db8f93c829..c43caac20b61b 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -2377,6 +2377,12 @@ static int dualshock4_parse_report(struct ps_device *ps_dev, struct hid_report *
 		struct dualshock4_input_report_usb *usb =
 			(struct dualshock4_input_report_usb *)data;
 
+		if (usb->num_touch_reports > ARRAY_SIZE(usb->touch_reports)) {
+			hid_err(hdev, "DualShock4 USB input report has invalid num_touch_reports=%d\n",
+				usb->num_touch_reports);
+			return -EINVAL;
+		}
+
 		ds4_report = &usb->common;
 		num_touch_reports = usb->num_touch_reports;
 		touch_reports = usb->touch_reports;
@@ -2391,6 +2397,12 @@ static int dualshock4_parse_report(struct ps_device *ps_dev, struct hid_report *
 			return -EILSEQ;
 		}
 
+		if (bt->num_touch_reports > ARRAY_SIZE(bt->touch_reports)) {
+			hid_err(hdev, "DualShock4 BT input report has invalid num_touch_reports=%d\n",
+				bt->num_touch_reports);
+			return -EINVAL;
+		}
+
 		ds4_report = &bt->common;
 		num_touch_reports = bt->num_touch_reports;
 		touch_reports = bt->touch_reports;
-- 
2.53.0

