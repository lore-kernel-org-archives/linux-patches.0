Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5F45A310E;
	Mon, 31 Aug 2026 13:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184330; cv=none; b=uF7TZF7OyN5ccPKHzsJGwNHZuavJ1CIl+sz3KRSCPaMtQO8cw3REbjrt6P7OKt3gE3+ZgAmr/hzKg17R9Lc6O6v8Oqg7FpecuaJSuUjmMo+5kXz9hg/Te4MnQG50xG9QncDuHuSeD6YkwVQJ8aRkxJIt4imFDPAtMceUgGi3RN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184330; c=relaxed/simple;
	bh=jvPy/o3A60Biykc89WOcTOUdIgxk2j85X5Xcl9zEGYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AHCelJeTmh8WY8j8BkQtLiRSkP0CZKA8vDWqRq/usjmWBrz2S3f77Py7kVt+NPphexmkXbKB5r+nfHGGPkCVZi5H5wMsMPK8yH8jQJ4yMLbIbIoudVCOW8lB8QDSq0DDMFLJVfGkIfzNuFdJ1YaaYvmbgu7N134WBXioy2IlExo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTxwOmev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTxwOmev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8E21F00A3D;
	Mon, 31 Aug 2026 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184327;
	bh=/ywgHoGDBdnLgNzikZgX18OzVKD88gPRnEUhW07+zPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTxwOmevFZIeULwxz/o4Vg9n+JNfDm0ma/KluZWk8Ub9d8iYsrwJ4R+OVeQlaTkbT
	 17soAS9DbtdvRDlr9Os/22v7YWUSrYt7EuH89vzBCUSpPQzjFiG5ClVmsyGOTIP0hw
	 76KupYT3gmZBmkIUs3IPrncSqfRHHE4JXxeuVpFyzl0Z7Gq6TFbr2yEJuZhBn7AJ4H
	 Omc5msvGAut/N0Fl5xq2u2zMWJ0wSLuGkqdxON0XCCOXhlYArl9BflK3NFqxnT0rHB
	 gr1CnnZ7M+wFUBc9KwaYQCQ8pm0S70DLjsZSXbaG5pF5esfhHH4hfQBrbLpGKvbx25
	 Zfj3kJsOcj/7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dave Carey <carvsdriver@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] HID: multitouch: Fix Yoga Book 9 14IAH10 touchscreen misclassification
Date: Mon, 31 Aug 2026 09:30:55 -0400
Message-ID: <20260831133314.4125787-627-sashal@kernel.org>
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

From: Dave Carey <carvsdriver@gmail.com>

[ Upstream commit f1bd44b9b62c6fbdaacdd5d115ebe3fe543fcfa1 ]

The Lenovo Yoga Book 9 14IAH10 (83KJ) (17EF:6161) firmware includes a
HID_DG_TOUCHPAD application collection designed for the Windows inbox HID
driver's Win8 PTP touchpad mode.  On Linux the HID_DG_TOUCHSCREEN
collections provide the correct direct-touch interface.  The presence of
the touchpad collection causes hid-multitouch to misclassify the
touchscreen nodes as indirect buttonpads, leaving them non-functional.

Within the touchpad collection:
- HID_UP_BUTTON usages trigger the touchscreen-with-buttons heuristic
  that sets INPUT_MT_POINTER on the touchscreen applications.
- The HID_DG_TOUCHPAD application itself sets INPUT_MT_POINTER via
  mt_allocate_application(), propagating to all touchscreen nodes.
- A HID_DG_BUTTONTYPE feature (report 0x51) returns MT_BUTTONTYPE_CLICKPAD,
  setting td->is_buttonpad = true for the entire device.

Additionally, the firmware resets if any USB control request arrives while
the CDC-ACM interface is initialising (~1.18 s after enumeration).
The Win8 compliance blob (0xff00:0xc5) and Contact Count Max feature
reports in the touchscreen collections trigger GET_REPORT calls at probe
that hit this window.  Surface Switch (0x57) and Button Switch (0x58)
feature reports are sent by mt_set_modes() on every input-device open and
close, repeatedly hitting this window throughout device lifetime.

The firmware also leaves a persistent ghost contact in its contact buffer
(contact ID 2, fixed coordinates, tip always asserted) on every enumeration.
This ghost occupies a multitouch slot and prevents KWin from seeing a clean
finger-lift, causing stuck touch state.  The ghost is cleared when Input
Mode is set via HID_REQ_SET_REPORT at probe.

Fix using a report descriptor fixup in mt_report_fixup() and a class
definition update:

1. Remove the entire HID_DG_TOUCHPAD application collection.  Parsing
   HID short items from its header to the matching End Collection and
   closing the gap with memmove eliminates all three BUTTONPAD
   heuristics and the feature reports within the collection.

2. Neutralize the Win8 compliance blob feature reports remaining in the
   touchscreen collections by changing Usage Page 0xff00 to 0x0f00,
   preventing the case 0xff0000c5 branch in mt_feature_mapping() from
   issuing GET_REPORT.

3. Neutralize the Contact Count Max feature reports by changing usage
   0x55 to 0x00; set maxcontacts = 10 in the class definition so the
   driver uses the correct contact limit without querying the device.

4. Neutralize Surface Switch (0x57) and Button Switch (0x58) feature
   report usages in the Device Configuration collection so mt_set_modes()
   does not issue HID_REQ_SET_REPORT for these on every input-device
   open/close.  Input Mode (0x52) is intentionally left intact: the single
   HID_REQ_SET_REPORT at probe flushes the firmware's contact buffer and
   clears the persistent ghost contact.  By probe time the cdc-acm driver
   has already satisfied the CDC-ACM init watchdog (~130 ms), so this
   request arrives safely after the reset window has closed.

5. Add MT_QUIRK_NOT_SEEN_MEANS_UP to the MT_CLS_YOGABOOK9I class so that
   contacts not present in a frame are released via INPUT_MT_DROP_UNUSED,
   preventing stale multitouch slots from lingering if the firmware omits
   a contact from a report.

Signed-off-by: Dave Carey <carvsdriver@gmail.com>
Tested-by: Dave Carey <carvsdriver@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: **[HID: multitouch]** **[Fix]** **Yoga Book 9 14IAH10
touchscreen misclassification** — fixes incorrect buttonpad
classification that leaves touchscreens non-functional on Lenovo Yoga
Book 9 14IAH10 (83KJ, 17EF:6161).

**Step 1.2 — Tags**

Record:
- **Signed-off-by:** Dave Carey `<carvsdriver@gmail.com>` (author)
- **Tested-by:** Dave Carey `<carvsdriver@gmail.com>`
- **Signed-off-by:** Jiri Kosina `<jkosina@suse.com>` (HID maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Link:`, `Reviewed-by:`, or
  `Acked-by:` tags in the provided commit message
- Notable: author hardware-tested; maintainer signed off

**Step 1.3 — Body analysis**

Record:
- **Bug:** `hid-multitouch` misclassifies both touchscreen nodes as
  indirect buttonpads (`INPUT_PROP_BUTTONPAD` / `INPUT_MT_POINTER`), so
  libinput/KWin suppress direct touch; touchscreens are non-functional.
- **Root cause:** Windows-oriented `HID_DG_TOUCHPAD` collection plus
  buttonpad heuristics (`HID_UP_BUTTON` in touchscreen collections,
  `mt_allocate_application()` touchpad handling, `HID_DG_BUTTONTYPE`
  clickpad feature).
- **Additional bugs:** USB control requests during CDC-ACM init window
  (~1.18 s) cause firmware reset; repeated `mt_set_modes()` SET_REPORT
  on open/close hits that window; persistent ghost contact (ID 2) causes
  stuck touch state.
- **Symptom:** Non-functional touchscreens; possible USB resets / stuck
  multitouch state.
- **Version info:** Specific to Yoga Book 9 14IAH10 (83KJ), USB
  17EF:6161.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Although framed as descriptor/class fixup, this is a
real hardware/firmware bug fix (misclassification, firmware reset
sensitivity, ghost contact), not cosmetic cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/hid/hid-multitouch.c` only
- **Scope:** ~145 lines added, 1 line changed in class definition
- **Functions modified/added:** `mt_classes[]` (`MT_CLS_YOGABOOK9I`),
  new `mt_yogabook9_fixup()`, `mt_report_fixup()`
- **Classification:** Single-file, device-specific surgical fix

**Step 2.2 — Code flow changes**

Record:
- **Before:** Full HID report descriptor parsed as-is; touchpad
  collection triggers buttonpad heuristics; `mt_feature_mapping()`
  issues GET_REPORT for Win8 blob/contact max; `mt_set_modes()`
  SET_REPORT on Surface/Button Switch every open/close.
- **After:** For 17EF:6161 only, `mt_report_fixup()` strips touchpad
  collection, neutralizes problematic feature usages/pages before
  parsing; class gets `MT_QUIRK_NOT_SEEN_MEANS_UP` and `maxcontacts =
  10`.
- **Paths affected:** HID probe (`report_fixup` → parse), feature
  mapping, input open/close (`mt_set_modes`), multitouch slot lifecycle.

**Step 2.3 — Bug mechanism**

Record: **Hardware workaround / logic correctness fix**
- Removes source of `INPUT_MT_POINTER` / `is_buttonpad`
  misclassification
- Prevents probe-time and runtime HID control traffic that triggers
  firmware reset
- Clears ghost-contact behavior via retained Input Mode SET_REPORT at
  probe plus `MT_QUIRK_NOT_SEEN_MEANS_UP`

**Step 2.4 — Fix quality**

Record: **High quality, maintainer-aligned.** v2 replaced scattered
`MT_QUIRK_YOGABOOK9I` guards with descriptor fixup per Benjamin
Tissoires’ review. Follows existing `mt_report_fixup()` pattern (Goodix
fixup already present). Device-gated to Lenovo 17EF:6161 only. Minor
regression risk on older Yoga Book 9i (same VID:PID) from class quirk
changes, but descriptor surgery is pattern-driven and largely no-op if
patterns absent.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- `MT_CLS_YOGABOOK9I` introduced in `409d19050cde8` (Brian Howard,
  2025-12-02) — “add quirks for Lenovo Yoga Book 9i”
- `mt_report_fixup()` exists since before 6.18 merge base; currently
  only Goodix fixup, no Yoga Book fixup
- Buggy classification paths (`mt_allocate_application`,
  `mt_touch_input_mapping`, `mt_feature_mapping`, `mt_set_modes`) are
  long-standing generic multitouch logic

**Step 3.2 — Fixes: tag**

Record: **N/A** — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**

Record:
- `409d19050cde8` — original Yoga Book 9i support (Gen 8–10, same
  17EF:6161)
- `5d29d7ff8679e` — USB cdc-acm quirk for Yoga Book 9 14IAH10 (already
  in this tree, `Cc: stable`)
- Candidate HID fix **not present** in this tree
- Standalone patch (not part of a multi-patch HID series)

**Step 3.4 — Author context**

Record: Dave Carey authored the companion cdc-acm 14IAH10 fix already
merged here. HID subsystem maintainer chain includes Jiri Kosina sign-
off.

**Step 3.5 — Dependencies**

Record:
- **Requires in tree:** `MT_CLS_YOGABOOK9I`,
  `USB_DEVICE_ID_LENOVO_YOGABOOK9I` (0x6161), `mt_report_fixup` hook —
  **all present**
- **Complementary:** cdc-acm quirk `5d29d7ff8679e` already in 6.18.43;
  HID fix assumes CDC-ACM init completes before probe-time Input Mode
  SET_REPORT
- **Can apply standalone:** Yes, to this tree

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- Thread: https://yhbt.net/lore/linux-
  input/20260413125803.46792-1-carvsdriver@gmail.com/T/
- v1 (2026-04-02): scattered quirk guards
- v2 (2026-04-13): descriptor fixup (matches analyzed commit)
- Benjamin Tissoires reviewed v1, requested descriptor fixup instead of
  sprinkling quirk guards; author implemented v2 accordingly
- No explicit `Cc: stable` nomination in thread
- No NAK; constructive review leading to v2 redesign

**Step 4.2 — Reviewers**

Record: CC’d: `jikos@`, `bentiss@` (Benjamin Tissoires), `linux-input@`,
`linux-kernel@`

**Step 4.3 — Bug report**

Record: No syzbot/bugzilla link in this commit. Original Yoga Book 9i
work referenced bugzilla 220386 for earlier models; 14IAH10 issue
documented by hardware owner with detailed firmware analysis.

**Step 4.4 — Series context**

Record: Two-patch user-space fix set with cdc-acm quirk (already in
tree) + this HID fix. HID v2 is self-contained.

**Step 4.5 — Stable list**

Record: No stable-list discussion found for this HID patch. Companion
cdc-acm patch was nominated `Cc: stable`.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `mt_yogabook9_fixup()`, `mt_report_fixup()`,
`mt_feature_mapping()`, `mt_set_modes()`, `mt_on_hid_hw_open()`,
`mt_on_hid_hw_close()`, `mt_allocate_application()`,
`mt_touch_input_configured()`

**Step 5.2 — Callers**

Record:
- `mt_report_fixup` — HID core during `hid_parse()` / probe
- `mt_set_modes` — probe, resume, suspend, `mt_on_hid_hw_open/close`
  (every userspace open/close of input device)
- `mt_feature_mapping` — during HID feature report parsing at probe
- Impact surface: device probe and normal desktop session input
  open/close paths

**Step 5.3 — Callees**

Record: `memmove`, `hid_hw_request(HID_REQ_SET_REPORT)`,
`mt_get_feature` (avoided after fixup), `input_mt_init_slots` with
`INPUT_MT_DROP_UNUSED`

**Step 5.4 — Reachability**

Record: Triggered by plugging in Yoga Book 9 14IAH10 USB composite
device (17EF:6161) and opening touch input devices — common laptop hot
path, not obscure debug-only code.

**Step 5.5 — Similar patterns**

Record: Existing Goodix `mt_report_fixup()` in same function; other HID
descriptor fixups elsewhere in tree. `MT_QUIRK_NOT_SEEN_MEANS_UP`
already used by SIS and other classes.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **6.18.43** (`git describe`:
`v6.18.43-1-gc7f0dac02d232`). `MT_CLS_YOGABOOK9I` and device ID `0x6161`
are bound, but **no `mt_yogabook9_fixup()`**. Generic buttonpad
heuristics and feature-report GET/SET paths are unchanged. cdc-acm
14IAH10 quirk is already present at `drivers/usb/class/cdc-
acm.c:2045-2057`.

**Step 6.2 — Backport difficulty**

Record: **Clean apply expected** — adds new function and one conditional
call in existing `mt_report_fixup()`; small class table tweak. No
structural conflicts observed.

**Step 6.3 — Related fixes already present?**

Record: Partial — `409d190` Yoga Book 9i quirks (bogus InRange drop,
naming) and `5d29d7ff8679e` cdc-acm quirk are present. **This specific
misclassification/descriptor fix is missing.**

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**

Record: **drivers/hid** — IMPORTANT (input/touch for laptop users, not
core kernel, but affects primary interaction on affected hardware)

**Step 7.2 — Activity**

Record: HID subsystem actively maintained in 6.18.y with recent
multitouch and quirk fixes.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: **Driver-specific** — Lenovo Yoga Book 9 14IAH10 (and
potentially other 17EF:6161 Yoga Book 9 variants sharing
descriptor/class binding)

**Step 8.2 — Trigger conditions**

Record: Device enumeration and normal input device use (open/close).
Common on every boot and session. Unprivileged users interact via normal
input stack; not a privilege-escalation vector.

**Step 8.3 — Failure mode severity**

Record:
- Without fix: touchscreens **completely non-functional** (HIGH severity
  for affected users)
- Firmware reset window: USB instability / re-enumeration during HID
  traffic (HIGH)
- Ghost contact: stuck touch state in compositor (MEDIUM-HIGH)
- Not kernel oops/panic, but makes primary hardware unusable

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** HIGH for 14IAH10 owners; completes fix started by
  already-backported cdc-acm quirk
- **Risk:** LOW-MEDIUM — ~145 lines, device-gated, but shared
  VID:PID/class with earlier Yoga Book 9i could affect Gen 8–10 behavior
  (`NOT_SEEN_MEANS_UP`, removing emulated touchpad collection)
- **Ratio:** Benefit clearly outweighs risk for this stable tree where
  partial support already exists

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence compile**

**FOR:**
- Fixes real, user-visible hardware breakage (non-functional
  touchscreens)
- Hardware quirk / descriptor fixup — standard stable exception
- Small, single-file, device-specific
- Author Tested-by on actual hardware
- HID maintainer signed off
- Subsystem expert (Tissoires) guided v2 design
- Complementary cdc-acm fix already in 6.18.43 with stable nomination
- Buggy code and prerequisites exist in this tree
- Prevents firmware-reset-triggering HID control traffic

**AGAINST:**
- No syzbot/CVE — usability/hardware enablement, not security
- Shared 17EF:6161 with earlier Yoga Book 9i — possible regression on
  Gen 8–10 (untested on those models in v2)
- Larger than a one-liner quirk, but still contained
- Not yet merged in this checkout (candidate evaluation)

**UNRESOLVED:**
- Whether v2 was merged to mainline beyond this 6.18.43 checkout (not
  needed for backport decision)
- Regression testing on pre-14IAH10 Yoga Book 9i units

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — detailed mechanism, hardware
   Tested-by, maintainer SOB, expert-reviewed approach
2. Fixes real bug affecting users? **PASS** — touchscreens non-
   functional on 14IAH10
3. Important issue? **PASS** — primary input hardware unusable; USB
   reset sensitivity
4. Small and contained? **PASS** — one file, device-specific
5. No new features/APIs? **PASS** — descriptor quirk only
6. Can apply to local tree? **PASS** — prerequisites present, clean
   apply expected

**Step 9.3 — Exception category**

Record: **Hardware quirk/workaround** (HID report descriptor fixup for
broken firmware/descriptor)

**Step 9.4 — Decision rationale**

For **Linux 6.18.y** specifically: the tree already ships Yoga Book 9i
(`MT_CLS_YOGABOOK9I`, 17EF:6161) support and the cdc-acm 14IAH10 quirk,
but without this HID fix the touchscreens remain misclassified and non-
functional on the 14IAH10. This is exactly the kind of device-specific
hardware workaround stable trees accept. The fix is self-contained,
reviewed, tested, and completes an already-started stable-relevant
enablement path.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided commit
  text
- [Phase 2] Analyzed full diff: `mt_yogabook9_fixup()`, class changes,
  `mt_report_fixup()` hook
- [Phase 3] `git describe HEAD` → v6.18.43; `git log --grep="Yoga Book"`
  → `409d190`, `5d29d7ff8679e`; `git blame` on lines 442-448, 1567+
- [Phase 3] `git show 409d19050cde8` — original Yoga Book 9i support
  confirmed
- [Phase 3] `git show 5d29d7ff8679e` — cdc-acm quirk with `Cc: stable`
  confirmed in tree
- [Phase 4] Fetched lore thread via yhbt.net; v1→v2 evolution and
  Tissoires review confirmed
- [Phase 4] UNVERIFIED: `b4 dig -c <hash>` — commit hash not in local
  repo
- [Phase 5] `grep` confirmed `mt_set_modes` called from
  open/close/resume/suspend; `mt_feature_mapping` GET_REPORT paths at
  lines 549-574
- [Phase 5] Read `mt_allocate_application`, `mt_touch_input_mapping`,
  `mt_touch_input_configured` buttonpad heuristics
- [Phase 6] `grep` — `mt_yogabook9_fixup` **absent**;
  `MT_CLS_YOGABOOK9I` and `USB_DEVICE_ID_LENOVO_YOGABOOK9I` **present**
- [Phase 6] Read `cdc-acm.c:2045-2057` — 14IAH10 quirk present
- [Phase 6] Read current `mt_report_fixup()` — only Goodix fixup, no
  Yoga Book call
- [Phase 8] Failure mode: non-functional touchscreens + firmware reset
  sensitivity on 17EF:6161 without fix

**YES**

 drivers/hid/hid-multitouch.c | 146 ++++++++++++++++++++++++++++++++++-
 1 file changed, 145 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1959481dc7820..0e204acdc9306 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -440,11 +440,13 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE,
 	},
 		{ .name = MT_CLS_YOGABOOK9I,
-		.quirks = MT_QUIRK_ALWAYS_VALID |
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
+			MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_FORCE_MULTI_INPUT |
 			MT_QUIRK_SEPARATE_APP_REPORT |
 			MT_QUIRK_HOVERING |
 			MT_QUIRK_YOGABOOK9I,
+		.maxcontacts = 10,
 		.export_all_inputs = true
 	},
 	{ .name = MT_CLS_EGALAX_P80H84,
@@ -1564,6 +1566,144 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	return 0;
 }
 
+/*
+ * Yoga Book 9 14IAH10 descriptor fixup.
+ *
+ * The device includes a HID_DG_TOUCHPAD application collection designed for
+ * the Windows inbox HID driver's Win8 PTP touchpad mode.  On Linux we want
+ * only the HID_DG_TOUCHSCREEN collections.  The touchpad collection (and the
+ * HID_DG_BUTTONTYPE and Win8 compliance blob features it contains) must be
+ * removed so hid-multitouch does not misclassify the touchscreen nodes as
+ * indirect buttonpads.
+ *
+ * The firmware also resets if any USB control request is received while the
+ * CDC-ACM interface is initialising (~1.18 s after enumeration).  Dropping
+ * the Win8 blob and Contact Count Max feature reports prevents the
+ * GET_REPORT calls that hid-multitouch issues at probe.
+ */
+static void mt_yogabook9_fixup(struct hid_device *hdev, __u8 *rdesc,
+			       unsigned int *size)
+{
+	/* Usage Page (Digitizer), Usage (Touch Pad), Collection (Application) */
+	static const __u8 tp_app_hdr[] = { 0x05, 0x0d, 0x09, 0x05, 0xa1, 0x01 };
+	/* Vendor Usage Page 0xff00 (Win8 compliance blob header) */
+	static const __u8 win8_page[] = { 0x06, 0x00, 0xff };
+	/* Usage (Contact Count Max = 0x55) */
+	static const __u8 ccmax_usage[] = { 0x09, 0x55 };
+	unsigned int i;
+
+	/*
+	 * Step 1: find and remove the Touch Pad application collection.
+	 * Walk HID short items from the collection header to its matching
+	 * End Collection, then close the gap with memmove.
+	 */
+	for (i = 0; i + sizeof(tp_app_hdr) <= *size; i++) {
+		if (memcmp(rdesc + i, tp_app_hdr, sizeof(tp_app_hdr)) == 0) {
+			__u8 *start = rdesc + i;
+			__u8 *coll_end = NULL;
+			__u8 *p = start;
+			unsigned int drop;
+			int depth = 0;
+
+			while (p < rdesc + *size) {
+				__u8 b = *p;
+				int ds = b & 3;
+				int item_len;
+
+				if (b == 0xfe) { /* long item */
+					if (p + 2 >= rdesc + *size)
+						break;
+					item_len = p[1] + 3;
+				} else {
+					item_len = (ds == 3) ? 5 : ds + 1;
+				}
+				if (p + item_len > rdesc + *size)
+					break;
+
+				if ((b & 0xfc) == 0xa0)
+					depth++; /* Collection */
+				else if (b == 0xc0) {
+					depth--; /* End Collection */
+					if (depth == 0) {
+						coll_end = p;
+						break;
+					}
+				}
+				p += item_len;
+			}
+
+			if (!coll_end) {
+				hid_err(hdev,
+					"Yoga Book 9: Touch Pad End Collection not found\n");
+				break;
+			}
+
+			drop = coll_end - start + 1;
+			memmove(start, coll_end + 1, rdesc + *size - coll_end - 1);
+			*size -= drop;
+			hid_dbg(hdev,
+				"Yoga Book 9: dropped Touch Pad collection (%u bytes)\n",
+				drop);
+			break;
+		}
+	}
+
+	/*
+	 * Step 2: neutralize Win8 compliance blob feature reports remaining
+	 * in the touchscreen collections.  Change Usage Page 0xff00 to 0x0f00
+	 * so the case 0xff0000c5 branch in mt_feature_mapping() is not reached
+	 * and no GET_REPORT is issued.
+	 */
+	for (i = 0; i + sizeof(win8_page) <= *size; i++) {
+		if (memcmp(rdesc + i, win8_page, sizeof(win8_page)) == 0) {
+			rdesc[i + 2] = 0x0f; /* 0xff00 -> 0x0f00 */
+			hid_dbg(hdev,
+				"Yoga Book 9: neutralized Win8 blob at offset %u\n",
+				i);
+		}
+	}
+
+	/*
+	 * Step 3: neutralize Contact Count Max feature reports.  Change usage
+	 * 0x55 (HID_DG_CONTACTMAX) to 0x00 so mt_feature_mapping() does not
+	 * issue GET_REPORT.  The class maxcontacts field provides the value.
+	 */
+	for (i = 0; i + sizeof(ccmax_usage) <= *size; i++) {
+		if (memcmp(rdesc + i, ccmax_usage, sizeof(ccmax_usage)) == 0) {
+			rdesc[i + 1] = 0x00;
+			hid_dbg(hdev,
+				"Yoga Book 9: neutralized ContactMax at offset %u\n",
+				i);
+		}
+	}
+
+	/*
+	 * Step 4: neutralize Surface Switch (0x57) and Button Switch (0x58)
+	 * feature report usages in the Device Configuration collection.
+	 * mt_set_modes() issues HID_REQ_SET_REPORT for these on every
+	 * input-device open/close; those repeated control requests hit the
+	 * firmware's CDC-ACM init window and trigger resets.
+	 *
+	 * Input Mode (0x52) is intentionally left intact.  mt_set_modes()
+	 * sends it once at probe to set the device into touchscreen mode,
+	 * which flushes the firmware's contact buffer and clears a persistent
+	 * ghost contact (cid 2, fixed coordinates) that otherwise appears on
+	 * every enumeration.  By probe time cdc_acm has already satisfied the
+	 * CDC-ACM init watchdog (~130 ms), so the single SET_REPORT for Input
+	 * Mode arrives safely after the reset window has closed.
+	 */
+	for (i = 0; i + 2 <= *size; i++) {
+		if (rdesc[i] == 0x09 &&
+		    (rdesc[i + 1] == 0x57 ||
+		     rdesc[i + 1] == 0x58)) {
+			hid_dbg(hdev,
+				"Yoga Book 9: neutralized set-modes usage 0x%02x at offset %u\n",
+				rdesc[i + 1], i);
+			rdesc[i + 1] = 0x00;
+		}
+	}
+}
+
 static const __u8 *mt_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 			     unsigned int *size)
 {
@@ -1593,6 +1733,10 @@ got: %x\n",
 		}
 	}
 
+	if (hdev->vendor == USB_VENDOR_ID_LENOVO &&
+	    hdev->product == USB_DEVICE_ID_LENOVO_YOGABOOK9I)
+		mt_yogabook9_fixup(hdev, rdesc, size);
+
 	return rdesc;
 }
 
-- 
2.53.0

