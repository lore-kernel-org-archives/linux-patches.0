Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED1A49F123;
	Mon, 31 Aug 2026 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183668; cv=none; b=PcQPl/N8dKpAK6G0lGzyhOIEEQH4qmcv48CZMGu61ffWOqUUagboZIUWUY/h0e8vl1kl09aEDbAkmsAPVkwfTnHJc1JjObZpWYJcBxRpkywGxTOy8ukthbrNZb91ZsbZ71/ZisKe7atViJvu3iZ5UtLBW//6qVJXxTpEODnYL5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183668; c=relaxed/simple;
	bh=zvbgLQlyE3XZI8hi7IDQCO9BCw9OjTH1HEf2nr4Y4ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cV5ioV5QbPAP5KBN2CDG+6TaT1Dy5TdFccxgbRf/pa/JGMBvQhm4n5muzzhXeVc1MwB0UMlJF1na5xNtG8TmpjNzUU1VABi8+kPWU9PZLLLP/8gOxR4HPGMFihTBzzt7mzd8UXVN3mRNL92/TM01cyG+/neS6V9LPWqQLjmkG3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNKOu2e4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNKOu2e4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E321F00ACA;
	Mon, 31 Aug 2026 13:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183665;
	bh=jIFRwDtGevzwGuvaiQHrD3gkkM3dtSQmr9LB9w5ZZrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNKOu2e4uNgcmh2sNcjaxMvsShgwcLgkPCHuPxL9zuo6vjBDm3HDoGSh3dq1bCVc3
	 3u+Nbvi10WpjvyMYLVpRcG1LJVOpSplUkjCtVrJWVNV8s1RmdXBL+ksS+H7nydANlU
	 AGy828x2UMsecZOYM+LUGPAV2Sk1naK8Zpy+ygINwaXVaWP9gfGq0/gC46LotcM+a1
	 8v3aDWZflRq509RoTsaSLnnjhnYBLEN2fYT8vcwr+mQoTW79RRmfpWnbuJjgs7wFtB
	 XIBWGM2Y9kBDPtNfHey42xVkHzPnl8Yp0QdQkw5TYm9t8+nCxH1m40m6M86D+rNgag
	 iX3q24B7r6RFQ==
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
Subject: [PATCH AUTOSEL 6.18-6.12] HID: multitouch: Honor ContactCount for Yoga Book 9 to suppress ghost contacts
Date: Mon, 31 Aug 2026 09:24:19 -0400
Message-ID: <20260831133314.4125787-231-sashal@kernel.org>
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

[ Upstream commit ef257b8be9776915ca468bae6c91e31757e69734 ]

The INGENIC 17EF:6161 firmware on the Lenovo Yoga Book 9 14IAH10
does not clear stale contact slots when fingers are lifted.  Each
HID report contains up to 10 finger slots, but only the first
ContactCount slots represent valid contacts; the remaining slots
retain TipSwitch=1 with positions from previous touches.

Raw HID capture confirms this: across a 60-second capture with
repeated multi-finger gestures, 90% of frames had more TipSwitch=1
slots than the reported ContactCount.  The ContactCount field itself
is always accurate.

Add MT_QUIRK_CONTACT_CNT_ACCURATE to the MT_CLS_YOGABOOK9I class so
the driver stops processing slots once ContactCount valid contacts
have been consumed, discarding the stale ghost entries per HID
specification section 17.  MT_QUIRK_NOT_SEEN_MEANS_UP (already in
the class) ensures that any slot skipped by this guard is released
via INPUT_MT_DROP_UNUSED at frame sync.

Signed-off-by: Dave Carey <carvsdriver@gmail.com>
Tested-by: Dave Carey <carvsdriver@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: HID multitouch Yoga Book 9 ContactCount

**Local tree:** `v6.18.44` (6.18.y stable)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[HID: multitouch]` `[Honor]` — Honor the HID ContactCount
field on Lenovo Yoga Book 9 to suppress ghost/stale touch contacts
caused by firmware not clearing lifted finger slots.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Dave Carey `<carvsdriver@gmail.com>` (author) |
| Tested-by | Dave Carey `<carvsdriver@gmail.com>` |
| Signed-off-by | Jiri Kosina `<jkosina@suse.com>` (HID maintainer) |
| Fixes: | None |
| Reported-by: | None |
| Cc: stable | None (expected for manual review) |
| Link: | None |

**Notable patterns:** Hardware-tested by author on the affected device.
No syzbot/sanitizer reports. Part of Dave Carey’s two-commit “Yoga Book
9 UX” series merged for Linux 7.2 (per OpenWall git-pull summary).

### Step 1.3: Body Analysis
**Record:**
- **Bug:** INGENIC `17EF:6161` firmware on Lenovo Yoga Book 9 14IAH10
  does not clear stale contact slots when fingers lift. Up to 10 slots
  per report, but only the first `ContactCount` slots are valid;
  remaining slots keep `TipSwitch=1` with old positions.
- **Symptom:** Ghost touch contacts — phantom fingers reported at stale
  positions, breaking multi-touch gestures and usability.
- **Evidence:** 60-second raw HID capture: 90% of frames had more
  `TipSwitch=1` slots than `ContactCount`; `ContactCount` itself was
  always accurate.
- **Root cause:** Driver processes all slots with `TipSwitch=1` instead
  of stopping at `ContactCount`.
- **Fix mechanism:** Add `MT_QUIRK_CONTACT_CNT_ACCURATE` to
  `MT_CLS_YOGABOOK9I`. Author states `MT_QUIRK_NOT_SEEN_MEANS_UP`
  (already in upstream class) releases skipped slots via
  `INPUT_MT_DROP_UNUSED` at frame sync.

### Step 1.4: Hidden Bug Fix?
**Record:** Not disguised — this is an explicit hardware/firmware quirk
fix for ghost touch contacts. Standard HID multitouch quirk pattern.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Change |
|------|--------|
| `drivers/hid/hid-multitouch.c` | +1 line |

**Functions modified:** None — only the `mt_classes[]` static table
entry for `MT_CLS_YOGABOOK9I`.

**Scope:** Single-file, single-line surgical quirk addition.

### Step 2.2: Code Flow Change
**Record:**
- **Before:** All finger slots with `TipSwitch=1` are processed for
  `MT_CLS_YOGABOOK9I`, including stale slots beyond `ContactCount`.
- **After:** In `mt_process_slot()`, when
  `MT_QUIRK_CONTACT_CNT_ACCURATE` is set and `app->num_received >=
  app->num_expected` (from `ContactCount`), processing returns `-EAGAIN`
  and the slot is skipped:

```1110:1112:drivers/hid/hid-multitouch.c
        if ((quirks & MT_QUIRK_CONTACT_CNT_ACCURATE) &&
            app->num_received >= app->num_expected)
                return -EAGAIN;
```

- **Affected path:** Normal multitouch report processing hot path for
  Yoga Book 9 devices.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware quirk / logic correctness fix
- **Mechanism:** Firmware violates HID spec §17 by leaving stale active
  slots. `MT_QUIRK_CONTACT_CNT_ACCURATE` enforces spec-compliant
  behavior: only the first `ContactCount` contacts are valid. Companion
  quirk `MT_QUIRK_NOT_SEEN_MEANS_UP` sets `INPUT_MT_DROP_UNUSED` so
  skipped/unseen slots are released at `input_mt_sync_frame()`.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct — same quirk is already used for SIS,
  Smart Tech, Egallax, Win8 PTP, and many other classes in this file.
- **Risk:** Very low — one flag addition to an existing quirk table
  entry; no new APIs, no structural changes.
- **Regression risk:** Minimal; quirk is device-class-specific and only
  affects `MT_CLS_YOGABOOK9I` matched devices.
- **Caveat:** Upstream testing was done with
  `MT_QUIRK_NOT_SEEN_MEANS_UP` also present in the class; this tree’s
  `MT_CLS_YOGABOOK9I` entry lacks that flag (see Phase 6).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `MT_CLS_YOGABOOK9I` class introduced in `409d19050cde8`
(Brian Howard, 2026-03-04) — “HID: multitouch: add quirks for Lenovo
Yoga Book 9i”. Present in this 6.18.y tree. The buggy behavior is
firmware-side; kernel support without `CONTACT_CNT_ACCURATE` has existed
since that commit.

### Step 3.2: Fixes: Tag
**Record:** No `Fixes:` tag present. N/A.

### Step 3.3: Related File History
**Record:**
- `409d19050cde8` — Introduced `MT_CLS_YOGABOOK9I`,
  `MT_QUIRK_YOGABOOK9I`, device ID `USB_DEVICE_ID_LENOVO_YOGABOOK9I`
  (0x6161), bogus-report filtering in `mt_report()`.
- `5d29d7ff8679e` — Dave Carey’s USB cdc-acm quirk for Yoga Book 9
  14IAH10 (`17EF:6161`), already in this tree with `Cc: stable`.
- Upstream 7.2 series includes a **prior** Dave Carey commit: “HID:
  multitouch: Fix Yoga Book 9 14IAH10 touchscreen misclassification”
  (adds `mt_yogabook9_fixup()`, `MT_QUIRK_NOT_SEEN_MEANS_UP`,
  `maxcontacts = 10`) — **not present in this 6.18.y tree**.
- This commit is patch 2/2 of Dave Carey’s Yoga Book 9 multitouch UX
  fixes in the 7.2 merge window.

### Step 3.4: Author Context
**Record:** Dave Carey is the reporter/fixer for Yoga Book 9 14IAH10
hardware issues. Same author’s cdc-acm fix is already in 6.18.44. Jiri
Kosina (HID maintainer) signed off.

### Step 3.5: Dependencies
**Record:**
- **Soft dependency:** Commit message explicitly relies on
  `MT_QUIRK_NOT_SEEN_MEANS_UP` being in the `MT_CLS_YOGABOOK9I` class
  for complete ghost-contact release via `INPUT_MT_DROP_UNUSED`. That
  flag is **not** in this tree’s YOGABOOK9I class (added upstream in the
  companion misclassification commit).
- **Infrastructure dependency:** `MT_QUIRK_CONTACT_CNT_ACCURATE`
  mechanism fully exists in this tree (since early multitouch driver
  history). `mt_post_parse()` strips the quirk only if
  `!app->have_contact_count`; the 14IAH10 device reports
  `HID_DG_CONTACTCOUNT`.
- **Standalone applicability:** The one-line change applies cleanly. For
  full effectiveness, backport should also add
  `MT_QUIRK_NOT_SEEN_MEANS_UP` to the same class entry (trivial one-line
  addition, not a separate subsystem).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c <commit>` could not be run — commit hash not
present in this tree. Lore.kernel.org and patch.msgid.link blocked by
bot protection. OpenWall git-pull summary (2026-06-16) confirms both
Dave Carey Yoga Book 9 multitouch commits merged for 7.2 under “UX
improvement fixes for Yoga Book 9.”

### Step 4.2: Reviewers
**Record:** Jiri Kosina (HID maintainer) committed. Author Tested-by on
actual hardware. UNVERIFIED: full lore thread review comments.

### Step 4.3: Bug Report
**Record:** No formal bugzilla/syzbot link. Author provided quantitative
HID capture data (90% of frames affected). Real hardware testing on
Lenovo Yoga Book 9 14IAH10.

### Step 4.4: Related Patches
**Record:** Companion commit “Fix Yoga Book 9 14IAH10 touchscreen
misclassification” (descriptor fixup, `NOT_SEEN_MEANS_UP`,
`maxcontacts=10`) is upstream-only and not in 6.18.44. This commit is
logically the second half of a two-patch series but is self-contained as
a one-line quirk addition.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — lore stable list inaccessible. Related cdc-acm
fix for same device was explicitly nominated with `Cc: stable` and is
already in this tree.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** No functions modified. Quirk affects behavior in:
- `mt_process_slot()` — enforces ContactCount limit
- `mt_touch_report()` — sets `num_expected` from ContactCount
- `mt_post_parse()` / `mt_input_configured()` — `NOT_SEEN_MEANS_UP` →
  `INPUT_MT_DROP_UNUSED`

### Step 5.2: Callers
**Record:** `mt_process_slot()` called from `mt_touch_report()` during
every multitouch HID report — common per-frame hot path for all
multitouch devices. Yoga Book 9 devices match `MT_CLS_YOGABOOK9I` via:

```2380:2383:drivers/hid/hid-multitouch.c
        { .driver_data = MT_CLS_YOGABOOK9I,
                HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
                           USB_VENDOR_ID_LENOVO,
                           USB_DEVICE_ID_LENOVO_YOGABOOK9I) },
```

### Step 5.3: Callees
**Record:** `mt_process_slot()` → `mt_compute_slot()`,
`input_mt_report_slot_state()`. Frame end → `mt_sync_frame()` →
`input_mt_sync_frame()`.

### Step 5.4: Reachability
**Record:** Triggered on every touch report from Yoga Book 9 touchscreen
during normal use. Userspace-reachable via touch input events. High-
frequency, user-visible path.

### Step 5.5: Similar Patterns
**Record:** `MT_QUIRK_CONTACT_CNT_ACCURATE` used identically in
`MT_CLS_SIS`, `MT_CLS_SMART_TECH`, `MT_CLS_EGALAX_P80H84`, and all Win8
PTP classes — well-established pattern for firmware that misreports
contact slots.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** `MT_CLS_YOGABOOK9I` exists since `409d19050cde8`
(March 2026) without `MT_QUIRK_CONTACT_CNT_ACCURATE`:

```442:448:drivers/hid/hid-multitouch.c
                { .name = MT_CLS_YOGABOOK9I,
                .quirks = MT_QUIRK_ALWAYS_VALID |
                        MT_QUIRK_FORCE_MULTI_INPUT |
                        MT_QUIRK_SEPARATE_APP_REPORT |
                        MT_QUIRK_HOVERING |
                        MT_QUIRK_YOGABOOK9I,
                .export_all_inputs = true
        },
```

USB cdc-acm quirk for the same `17EF:6161` device (`5d29d7ff8679e`) is
already in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply** for the one-line
`MT_QUIRK_CONTACT_CNT_ACCURATE` addition. Minor backport adjustment
recommended: also add `MT_QUIRK_NOT_SEEN_MEANS_UP` to the same class
entry (present upstream, absent here) for complete ghost-contact
release. No file restructuring conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** Base Yoga Book 9i support (`409d19050cde8`) and cdc-acm
watchdog fix (`5d29d7ff8679e`) are present. Misclassification fixup
(`mt_yogabook9_fixup`) and `NOT_SEEN_MEANS_UP` on YOGABOOK9I are **not**
present. No duplicate fix for ghost contacts found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/hid/` — **IMPORTANT** (input/HID subsystem).
Affects touch input for a specific laptop model, not core kernel paths.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent commits in `hid-multitouch.c` on
this tree include out-of-bounds fix (`37daa8c96bd56`), Egallax class,
latency quirk.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Device-specific** — Lenovo Yoga Book 9 14IAH10 (and
potentially other Gen 8–10 models using `17EF:6161` with the same
firmware behavior). Users who already have Yoga Book 9i multitouch
support in 6.18.y.

### Step 8.2: Trigger Conditions
**Record:** Every multi-touch interaction where fingers are lifted —
extremely common during normal laptop use. Not privilege-dependent;
affects all users of this hardware.

### Step 8.3: Failure Mode Severity
**Record:** Ghost/stale touch contacts at wrong screen positions.
**Severity: MEDIUM** — no kernel crash, no data corruption, no security
issue, but significant UX degradation (phantom touches, broken gestures,
unintended UI interaction). This is a real, reproducible hardware bug
with quantified impact (90% of frames).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected Yoga Book 9 users — restores correct
  multitouch behavior on a supported device.
- **Risk:** VERY LOW — one-line quirk flag on an existing device class;
  identical pattern used across many other devices.
- **Ratio:** Favorable. Standard hardware-quirk stable material.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real firmware bug on hardware already supported in 6.18.44
- Hardware quirk — explicit stable exception category
- One-line, surgical, obviously correct change
- `MT_QUIRK_CONTACT_CNT_ACCURATE` infrastructure fully present and
  battle-tested
- Author tested on actual hardware; HID maintainer signed off
- Companion cdc-acm fix for same device already in this tree
- Quantified impact (90% of frames affected)

**AGAINST backport:**
- Not a crash/security/corruption issue — UX/input correctness only
- Upstream fix assumes `MT_QUIRK_NOT_SEEN_MEANS_UP` is already in the
  class; this tree lacks it (backport should add both flags)
- Companion “misclassification” commit not in tree (separate concern;
  touch may work without it via existing `409d19050cde8` support)
- Device is relatively new/niche

**Unresolved:**
- Full lore review thread inaccessible
- Whether misclassification fixup is also needed for 14IAH10 on 6.18.y
  (separate from this ghost-contact fix)

### Step 9.2: Stable Rules Checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — standard quirk,
hardware-tested; backport should include `NOT_SEEN_MEANS_UP` for tested
configuration |
| 2. Fixes real bug affecting users? | **PASS** — ghost contacts on
supported hardware |
| 3. Important issue? | **PASS (MEDIUM)** — hardware quirk affecting
input correctness on every touch interaction |
| 4. Small and contained? | **PASS** — 1 line |
| 5. No new features/APIs? | **PASS** — quirk flag on existing class |
| 6. Can apply to local tree? | **PASS** — clean apply; recommend adding
`NOT_SEEN_MEANS_UP` alongside |

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** for broken device firmware —
automatic stable qualification per stable-kernel-rules exceptions.

### Step 9.4: Decision Rationale

This is a textbook stable hardware-quirk fix: a one-line addition of an
existing, well-proven quirk flag to a device class that already exists
in v6.18.44. The Lenovo Yoga Book 9 14IAH10 is already partially
supported (HID multitouch class + USB cdc-acm quirk), and users on this
stable tree will hit the ghost-contact firmware bug during normal use.

The fix is minimal, device-scoped, and follows an established pattern
used by a dozen other device classes in the same file. The only backport
consideration is that the tested upstream configuration also includes
`MT_QUIRK_NOT_SEEN_MEANS_UP`, which should be added alongside
`MT_QUIRK_CONTACT_CNT_ACCURATE` in the backport for complete
effectiveness — a trivial one-line addition, not a blocker.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
  and message
- **[Phase 2]** Diff analysis: +1 line to `MT_CLS_YOGABOOK9I` quirks in
  `mt_classes[]`
- **[Phase 2]** Read `mt_process_slot()` lines 1110–1112: confirmed
  `CONTACT_CNT_ACCURATE` guard logic
- **[Phase 2]** Read `mt_post_parse()` line 1774–1775: confirmed quirk
  stripped if no ContactCount field
- **[Phase 3]** `git describe HEAD`: v6.18.44
- **[Phase 3]** `make kernelversion`: 6.18.44
- **[Phase 3]** `git blame -L 442,449`: YOGABOOK9I introduced in
  `409d19050cde8`
- **[Phase 3]** `git show 409d19050cde8`: confirmed base Yoga Book 9i
  support in tree since 2026-03-04
- **[Phase 3]** `git show 5d29d7ff8679e`: confirmed cdc-acm quirk for
  same 17EF:6161 device in tree
- **[Phase 3]** `git log --grep`: commit not in tree; no local history
  for this specific patch
- **[Phase 4]** `b4 dig -c`: failed — no commit hash in tree
- **[Phase 4]** WebFetch lore.kernel.org: blocked by bot protection
- **[Phase 4]** WebSearch: confirmed commit in Linux 7.2 HID merge; part
  of Dave Carey Yoga Book 9 UX series
- **[Phase 4]** Fetched torvalds/linux `hid-multitouch.c`: confirmed
  upstream YOGABOOK9I has both `NOT_SEEN_MEANS_UP` and
  `CONTACT_CNT_ACCURATE`
- **[Phase 5]** `grep MT_QUIRK_CONTACT_CNT_ACCURATE`: confirmed
  widespread use in this tree
- **[Phase 5]** `grep MT_CLS_YOGABOOK9I`: confirmed device ID 0x6161
  match entry at line 2380
- **[Phase 6]** Read current YOGABOOK9I class: lacks
  `CONTACT_CNT_ACCURATE` and `NOT_SEEN_MEANS_UP`
- **[Phase 6]** `grep mt_yogabook9_fixup`: not present in this tree
  (misclassification fix is separate)
- **[Phase 7]** `git log --oneline -5 -- drivers/hid/hid-multitouch.c`:
  confirmed active maintenance
- **UNVERIFIED:** Full lore review thread and stable-list nomination
  history (sites blocked)

**YES**The background `git log --grep` search finished with no matches —
the **Honor ContactCount for Yoga Book 9** commit is not in this
`v6.18.44` tree, which fits treating it as a backport candidate rather
than something already applied.

That lines up with the earlier analysis: `MT_CLS_YOGABOOK9I` is already
here (since `409d19050cde8`), but it still lacks
`MT_QUIRK_CONTACT_CNT_ACCURATE`. This is a one-line hardware quirk fix
worth backporting; for full effect on 6.18.y, the backport should also
add `MT_QUIRK_NOT_SEEN_MEANS_UP` to the same class entry.

**YES**

 drivers/hid/hid-multitouch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 0e204acdc9306..5b7f532c6e0b0 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -442,6 +442,7 @@ static const struct mt_class mt_classes[] = {
 		{ .name = MT_CLS_YOGABOOK9I,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_FORCE_MULTI_INPUT |
 			MT_QUIRK_SEPARATE_APP_REPORT |
 			MT_QUIRK_HOVERING |
-- 
2.53.0

