Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924D84AA1D4;
	Mon, 31 Aug 2026 13:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184000; cv=none; b=ZDVhGS86tjQvrIBaly4LbiwbUKMlHf2frjzVZpDil2UJNCqQNdcGgOUDlZnUdDOUwXdciyAdvglFjvSAaOEYo8lPD1NW2dAHOv0SOpesj0eIM+BFY6lUTnw8VeoWh0cGIlFnZbFiOP5luvKTIqOizfUxd7xaAipIP1felcAfIts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184000; c=relaxed/simple;
	bh=1WaqryaEJVC8c0lCH5B/XBmgCX3uxNjq297k7NBaHpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kVLqfCtcHMVwrCKZDaOY+uXu8TJoMUi1isTQhPnAJgb5wP9eRleQRxcUzG5IlFCtQpyI6BnY1cNsw3C7MMzpUMRLA6u/mEVCRqFY+5l2FHdw284Y546l0jHnJLx2nx2wOAT/glNJ7+NcaJNEmGRzvuqHpOLFroaGGnAj0r6qzks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NysT7AIR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NysT7AIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644781F00ACA;
	Mon, 31 Aug 2026 13:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183995;
	bh=LI/CQT654bOiZ+Y53OyKaYiM4PboTE5opkHx1+nNk60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NysT7AIRkonQ+9dm2DXn4KjTtIwLH31YWm5ONtiMbPGYh5H/ngyQzjq+KOzrJuP3p
	 5KquQc2uwIW2wYUOELL+ojE7qAxKbaX3yTU3sf4zzy0sjddnxZOKbWiyMUq6atf7/d
	 gfqfeaVcUGssiOpluXfB8f+uPDWp7iZZhkgs90eixh7GHGPlTNRkbTc9Qs7It6Cz14
	 BPn9khQcKWgTvmR6u8g2rnjxqj1n+k2ZB/bJw/I7BUcvUqIUfczsFS1ooze+i2r84R
	 5XcCkQd5aWnPScpXlh5Y+Vd7DysNAD2SeSBksiWQAB1q2Jpcq2/tl6MIsMlwXR+kWM
	 e9uLArBA5UmAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nikolay Metchev <nikolaymetchev@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexhung@gmail.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] platform/x86: intel-hid: Add HP ProBook x360 440 G1 to button_array_table
Date: Mon, 31 Aug 2026 09:27:35 -0400
Message-ID: <20260831133314.4125787-427-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Nikolay Metchev <nikolaymetchev@gmail.com>

[ Upstream commit c39023ca9a447f09c072080efc84d6874c2275c9 ]

The volume rocker buttons on the HP ProBook x360 440 G1 convertible emit
events 0xc4-0xc7 via the intel-hid ACPI device (INT33D5). These codes are
only present in intel_array_keymap, which is used when the "5 button
array" input device exists. On this machine button_array_present()
returns false because the firmware does not advertise the array through
the HEBC method, so notify_handler() routes the events to a NULL
priv->array and they are dropped as "unknown event 0xc4". As a result
the side volume keys do nothing.

Add the machine to button_array_table so the array device is created and
the volume rocker emits KEY_VOLUMEUP / KEY_VOLUMEDOWN. This is equivalent
to booting with the enable_5_button_array=1 module parameter, which was
used to confirm the fix on the affected hardware.

Signed-off-by: Nikolay Metchev <nikolaymetchev@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260609213309.445019-1-nikolaymetchev@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[platform/x86: intel-hid] [add] Add HP ProBook x360 440 G1 to
button_array_table`

**Step 1.2 — Tags**
Record:
- Fixes: — none
- Reported-by: — none
- Tested-by: — none (hardware testing described in v1 body text)
- Reviewed-by: Hans de Goede `<johannes.goede@oss.qualcomm.com>`, Ilpo
  Järvinen `<ilpo.jarvinen@linux.intel.com>`
- Acked-by: — none
- Link: https://patch.msgid.link/20260609213309.445019-1-
  nikolaymetchev@gmail.com
- Cc: stable@vger.kernel.org — none (expected)
- Signed-off-by: Nikolay Metchev (author), Ilpo Järvinen (committer)

Notable: Reviewed by the platform-x86 maintainer (Hans de Goede) and
intel-hid maintainer (Ilpo Järvinen).

**Step 1.3 — Body analysis**
Record:
- Bug: Side volume rocker on HP ProBook x360 440 G1 sends ACPI events
  0xc4–0xc7 via INT33D5, but firmware does not advertise the 5-button
  array via HEBC, so `button_array_present()` returns false,
  `priv->array` is never created, and volume events are dropped.
- Symptom: Volume keys do nothing; kernel logs "unknown event 0xc4" (per
  v1 submission).
- Root cause: Missing DMI quirk entry; events require
  `intel_array_keymap` which is only wired when the 5-button array input
  device exists.
- Verification: Equivalent to `enable_5_button_array=1`, tested on real
  hardware.

**Step 1.4 — Hidden bug fix?**
Record: Not disguised — this is an explicit hardware-enablement quirk,
not cleanup. It fixes broken input functionality on a specific laptop
model.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- Files: `drivers/platform/x86/intel/hid.c` (+7 lines, 0 removed)
- Functions touched: `button_array_table[]` static data only
- Scope: Single-file, surgical DMI table entry

**Step 2.2 — Code flow change**
Record:
- Before: On HP ProBook x360 440 G1, `button_array_present()` returns
  false → probe skips `intel_button_array_input_setup()` → `priv->array`
  stays NULL → `notify_handler()` drops 0xc4–0xc7 events.
- After: DMI match forces `button_array_present()` true → 5-button array
  input device created with `intel_array_keymap` → volume rocker emits
  `KEY_VOLUMEUP` / `KEY_VOLUMEDOWN`.

**Step 2.3 — Bug mechanism**
Record: [Hardware quirk / logic correctness] Firmware reports volume-
button ACPI events but does not advertise the 5-button array capability.
Driver relies on DMI fallback table (`button_array_table`) for such
machines. Missing entry = non-functional hardware keys.

**Step 2.4 — Fix quality**
Record: Obviously correct — identical pattern to existing entries (HP
Spectre x2, Surface Go 3/4, ThinkPad models). Minimal regression risk:
only affects DMI-matched HP ProBook x360 440 G1 systems. Uses existing,
tested code path (`enable_5_button_array=1` confirmed equivalent).

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: `button_array_table[]` introduced in c454a99d4ce1 (2017). DMI
fallback mechanism extended with `enable_5_button_array` in
e32354bb8fe33. Bug is longstanding pattern — machines with
broken/missing HEBC advertisement need DMI entries. HP ProBook was never
added until this commit.

**Step 3.2 — Fixes: tag**
Record: N/A — no Fixes: tag present.

**Step 3.3 — Related commits in this tree**
Record: Direct precedents already in 6.18.y:
- `2738d06fb4f01` — Surface Go 4 volume buttons (identical fix)
- `75a978bd604b5` — ThinkPad X12 volume buttons (identical fix)
- `05bc9939b501f` — ThinkPad X1 Fold 16 Gen 1 (identical fix)

Standalone — not part of a multi-patch series.

**Step 3.4 — Author context**
Record: Nikolay Metchev is an external contributor (not subsystem
maintainer). Patch went through normal maintainer review by Hans de
Goede and Ilpo Järvinen.

**Step 3.5 — Dependencies**
Record: None. All required infrastructure (`button_array_table`,
`intel_array_keymap`, `enable_5_button_array`, `button_array_present()`,
`notify_handler()`) exists in this tree. Applies standalone.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- Lore URL: https://patch.msgid.link/20260609213309.445019-1-
  nikolaymetchev@gmail.com
- Series: v1 (2026-06-02, attachment) → v2 (2026-06-09, inline) —
  committed version is v2 (latest)
- Hans de Goede: "Thanks, patch looks good to me" + Reviewed-by
- Ilpo Järvinen: Applied to review branch; v1 feedback was formatting
  only ("send inline")
- No NAKs or objections
- No explicit "Cc: stable" nomination in thread

**Step 4.2 — Reviewers**
Record: CC'd to Hans de Goede, Ilpo Järvinen, Alex Hung, platform-
driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org — appropriate
subsystem maintainers included.

**Step 4.3 — Bug report**
Record: User-reported on real hardware (HP ProBook x360 440 G1). v1
describes testing with `enable_5_button_array=1` confirming fix. No
syzbot/bugzilla.

**Step 4.4 — Related patches**
Record: Part of ongoing intel-hid DMI quirk additions; each machine
entry is independent.

**Step 4.5 — Stable list history**
Record: Not searched separately; no stable discussion found in mbox
thread.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: Data change only in `button_array_table[]`. Affects runtime
behavior via `button_array_present()` → `intel_hid_probe()` →
`intel_button_array_input_setup()` → `notify_handler()`.

**Step 5.2 — Callers**
Record:
- `dmi_check_system(button_array_table)` called from
  `button_array_present()` (line 682)
- `button_array_present()` called from `intel_hid_probe()` (line 743)
- `intel_hid_probe()` registered as platform driver probe — runs at boot
  on matching ACPI INT33D5 devices

**Step 5.3 — Callees**
Record: When matched, probe calls `intel_button_array_input_setup()`
which allocates input device, sets up `intel_array_keymap`, registers
"Intel HID 5 button array" device.

**Step 5.4 — Reachability**
Record: Triggered automatically at boot on HP ProBook x360 440 G1 with
CONFIG_INTEL_HID (common on Intel x86 laptops). Volume key presses are
normal user interaction — highly reachable for affected owners.

**Step 5.5 — Similar patterns**
Record: Same file contains 8 existing `button_array_table` entries for
machines with identical firmware quirk pattern. This tree already
backported Surface Go 4 and ThinkPad fixes of the same nature.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code exists?**
Record: **YES.** Local tree is **v6.18.44** (`stable/linux-6.18.y`).
`button_array_table[]` exists without HP ProBook entry. Bug affects any
6.18.y user with this laptop. Commit `c39023ca9a447` is on master but
**NOT** in current HEAD.

**Step 6.2 — Backport complications**
Record: **Clean apply confirmed** (`git apply --check` succeeded).
Insertion point after Surface Go 4 entry matches current file layout
exactly.

**Step 6.3 — Related fixes already present?**
Record: Surface Go 4 (`2738d06fb4f01`), ThinkPad X12, X1 Fold 16 fixes
are already in 6.18.y. HP ProBook entry is the missing piece — not
duplicated elsewhere.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
Record: `drivers/platform/x86/intel/hid.c` — platform driver, IMPORTANT
for Intel x86 convertible/tablet users, PERIPHERAL in global kernel
scope but critical for affected hardware.

**Step 7.2 — Subsystem activity**
Record: Actively maintained — multiple DMI quirk additions in 2024–2026,
including several already backported to 6.18.y.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Owners of HP ProBook x360 440 G1 convertibles running intel-hid
(Intel ACPI INT33D5). Config-specific (`CONFIG_INTEL_HID`), platform-
specific (x86, specific DMI).

**Step 8.2 — Trigger conditions**
Record: Every boot + every volume button press on affected hardware.
Common, deterministic. Unprivileged users trigger via normal key use.

**Step 8.3 — Failure mode severity**
Record: Non-functional volume rocker buttons. Severity: **LOW** (no
crash, corruption, or security impact). Functional hardware regression
for affected users.

**Step 8.4 — Risk-benefit**
Record:
- Benefit: **MEDIUM** for affected users (restores expected laptop
  input); **LOW** globally (single DMI match)
- Risk: **VERY LOW** (7-line DMI entry, established pattern, hardware-
  tested, maintainer-reviewed)
- Ratio: Strong benefit for affected users at negligible risk — matches
  stable precedent for intel-hid DMI quirks

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR backport:
- Fixes real, reproducible hardware bug (volume keys dead)
- Hardware-tested on affected machine
- Reviewed by subsystem and driver maintainers
- Identical to Surface Go 4 / ThinkPad fixes already in 6.18.y
- Falls under stable "quirks/workarounds" exception (DMI table for
  broken firmware)
- 7 lines, single file, applies cleanly
- All infrastructure present in local tree

AGAINST backport:
- Not crash/security/corruption — functional input regression only
- Affects narrow hardware population
- No explicit stable nomination in mailing list

UNRESOLVED: None affecting decision.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — maintainers reviewed;
   hardware verified via `enable_5_button_array=1`
2. Fixes real bug affecting users? **PASS** — volume buttons non-
   functional
3. Important issue? **PASS** (hardware quirk exception) — real-world
   broken hardware on a business laptop; same category as prior stable
   backports in this driver
4. Small and contained? **PASS** — 7 lines, one DMI entry
5. No new features/APIs? **PASS** — DMI quirk only
6. Can apply to local tree? **PASS** — verified clean apply to v6.18.44

**Step 9.3 — Exception category**
Record: **Hardware quirk/workaround** — DMI-based enablement of 5-button
array for firmware that fails to advertise capability via HEBC.
Explicitly allowed per stable rules.

**Step 9.4 — Decision rationale**
This commit restores volume rocker functionality on HP ProBook x360 440
G1 by adding a DMI entry to an existing quirk table. The 6.18.y tree
already carries nearly identical fixes for Surface Go 4, ThinkPad X12,
and ThinkPad X1 Fold 16. The patch is minimal, maintainer-reviewed,
hardware-tested, and applies cleanly. While not a crash fix, it matches
the well-established stable pattern for intel-hid DMI quirks that fix
broken laptop input hardware.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Hans de Goede, Ilpo Järvinen; Link
  to patch submission; no Fixes/Reported-by/syzbot
- [Phase 2] Diff: +7 lines, DMI entry in `button_array_table[]`;
  verified event drop path in `notify_handler()` lines 646–649 when
  `!priv->array`
- [Phase 3] `git describe HEAD`: v6.18.44; commit NOT ancestor of HEAD;
  `button_array_table` since 2017
- [Phase 3] Precedent commits in tree: 2738d06fb4f01 (Surface Go 4),
  75a978bd604b5 (ThinkPad X12), 05bc9939b501f (X1 Fold 16)
- [Phase 4] `b4 dig -c c39023ca9a447`: lore URL found; v1→v2 series;
  Hans de Goede Reviewed-by; no NAKs
- [Phase 4] `b4 dig -w`: CC'd Hans de Goede, Ilpo Järvinen, platform-
  driver-x86, LKML
- [Phase 4] Mbox: v1 tested on HP ProBook x360 440 G1 with
  `enable_5_button_array=1`
- [Phase 5] Call chain: probe → `button_array_present()` →
  `intel_button_array_input_setup()` → `notify_handler()` with
  `priv->array`
- [Phase 6] `git apply --check` on commit diff: **clean apply**
- [Phase 6] HP ProBook entry absent from current `hid.c`; infrastructure
  present
- [Phase 8] Failure mode: dropped input events, severity LOW; hardware
  quirk category

**YES**The background checks finished and match the earlier analysis:

- **Commit location:** `c39023ca9a447` (HP ProBook x360 440 G1 DMI
  quirk) is on **master**, not in the current **v6.18.44** stable
  checkout.
- **b4 dig:** Found the v1→v2 lore thread; Hans de Goede and Ilpo
  Järvinen reviewed it, with hardware testing on the affected laptop.

**Verdict for this tree (6.18.y): YES** — same pattern as the Surface Go
4 / ThinkPad volume-button fixes already in 6.18.y; 7-line DMI quirk,
applies cleanly.

 drivers/platform/x86/intel/hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 0dcf3a68a3355..f97f7f111319e 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -158,6 +158,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 4"),
 		},
 	},
+	{
+		.ident = "HP ProBook x360 440 G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook x360 440 G1"),
+		},
+	},
 	{ }
 };
 
-- 
2.53.0

