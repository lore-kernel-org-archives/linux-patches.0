Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F875A0ABF;
	Mon, 31 Aug 2026 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184320; cv=none; b=BZk6+/1KbCL/Hm4BppryQISHHLpqKK+UDKNRmHCdaI+8LpiAHeMa80rLr7Tz3KrliazWf/vkFrGUF/KgVQieLXMHDVmdD2PhN36YRcGs1cQpY1kbzovnMH/ITCVhGMlxe1jCHvMteXMD0+iYz7Obkby75LW7wCzGg4kYEM9fgqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184320; c=relaxed/simple;
	bh=xLf09wVcxA9h6jkZi0DhwH75Z5jb+hNoZ/8z5EFt3YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oWvfJ5AFoIGTBewKbWcoPFbZ/oreES27BtD7NDATAzbOVr5Kcinsb6nTIPysbUYcySPEGlPthSYzzprEnPt757Vi+ryIo9/tLZcDuzKpO3jYuT+9EcrNuvP6WP65fZ/5eUCgXo8zfR8TDOajkmw6lvEdgMH1/mqdJ8szt0mggww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRUpYnlF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRUpYnlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFB41F00A3D;
	Mon, 31 Aug 2026 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184318;
	bh=kdfRuPl0hrKyvihyJ/gG0bBiOeV8URDkBe9P+1/RTYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRUpYnlFayg/LUcKzDr5xZtvPAz06BDRVgGiRc16O/1FCH2WDWc1qcIXJFGhOkGT/
	 FTC6hyArvBk8NrP1jBLFw/iU/3HTM0iE8hp8ZHh3E/FyB4sBaY87Qk8R4g5/Rr7bYo
	 wNx81v+j19BR3JxxBqKvBvuhxtHwCzSws8s+eWRMvSKOVnkvg8fSeGEObVF24lWs4+
	 Q5kbTS75jEqKUxKjNN/3KzKISQ+oFTZ3b6rvH9eIMhcA8iW+0mem6boDEqZVTIBax1
	 XDuur9TNECs/gy0eA/69FrcDkv1toPlbTV6Xp7dE1Efud+glRBswBmDfKqJOabtJUW
	 IsftKScf9weDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexej Sidorenko <alexej@sidorenko.cz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] Bluetooth: btrtl: fix RTL8761B/BU broken LE extended scan
Date: Mon, 31 Aug 2026 09:30:49 -0400
Message-ID: <20260831133314.4125787-621-sashal@kernel.org>
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

From: Alexej Sidorenko <alexej@sidorenko.cz>

[ Upstream commit 5ead2063611ae56809b1b113ac44cef9547c81d7 ]

RTL8761B and RTL8761BU devices report HCI version 5.1 but do not
support the LE Extended Scan commands. This causes repeated failures
with Opcode 0x2042 (LE Set Extended Scan Parameters) returning -EBUSY
when BlueZ attempts extended scanning while a connection is active.

Set HCI_QUIRK_BROKEN_EXT_SCAN for CHIP_ID_8761B to make BlueZ fall
back to legacy LE scan commands which the firmware supports correctly.

Tested with RTL8761BU (USB ID 0bda:a728) where the issue manifested
as continuous 'Opcode 0x2042 failed: -16' errors in dmesg whenever
a BLE connection was active.

Signed-off-by: Alexej Sidorenko <alexej@sidorenko.cz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: Bluetooth: btrtl: fix RTL8761B/BU broken LE
extended scan

**Local tree:** `v6.18.44-1-g2736c32da98b9` (kernel 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[Bluetooth: btrtl]` `[fix]` — RTL8761B/BU devices falsely
advertise LE Extended Scan support; set a quirk so the stack falls back
to legacy LE scan.

### Step 1.2: Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none (author says "Tested with RTL8761BU" in body)
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable@vger.kernel.org** — not present (expected)
- **Signed-off-by:** Alexej Sidorenko (author), Luiz Augusto von Dentz
  (Bluetooth maintainer)

Notable: maintainer SOB from Luiz von Dentz is a strong quality signal.
No syzbot/fuzzer report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** RTL8761B/BU report HCI 5.1 and claim LE Extended Scan
  support, but firmware does not implement those commands.
- **Symptom:** Repeated `Opcode 0x2042 failed: -16` (-EBUSY) in dmesg
  when BlueZ attempts extended scanning while a BLE connection is
  active.
- **Root cause:** Kernel's `use_ext_scan()` sees advertised capability
  and uses extended scan HCI commands; firmware rejects them.
- **Fix approach:** Set `HCI_QUIRK_BROKEN_EXT_SCAN` for `CHIP_ID_8761B`
  so the stack uses legacy LE scan commands.
- **Version info:** None stated; hardware has been supported since
  RTL8761B support landed in 2020.

Note: commit message labels 0x2042 as "LE Set Extended Scan Parameters",
but in this tree `0x2041` is Parameters and `0x2042` is Enable
(`include/net/bluetooth/hci.h`). The quirk disables both via
`use_ext_scan()`, so the fix is still correct.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit hardware quirk/workaround fix, not
disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/bluetooth/btrtl.c` (+13 lines, 0 removed)
- **Function:** `btrtl_set_quirks()`
- **Scope:** Single-file, surgical hardware quirk addition

### Step 2.2: Code flow change
**Record:**
- **Hunk (before):** After the `ic_info` NULL check, code only handled
  `RTL_ROM_LMP_8703B` local-ext-features quirk.
- **Hunk (after):** New `switch (btrtl_dev->project_id)` sets
  `HCI_QUIRK_BROKEN_EXT_SCAN` for `CHIP_ID_8761B` before the existing
  `lmp_subver` switch.
- **Path affected:** Device init — `btrtl_set_quirks()` called from
  `btrtl_setup_realtek()` during Realtek USB/UART Bluetooth probe.

### Step 2.3: Bug mechanism
**Record:** **[Hardware workaround / logic correctness]**
- `use_ext_scan(dev)` is true when controller advertises extended scan
  support AND quirk is not set.
- RTL8761B falsely advertises support → kernel sends
  `HCI_OP_LE_SET_EXT_SCAN_*` commands → firmware returns error (-EBUSY).
- Quirk forces fallback to legacy `HCI_OP_LE_SET_SCAN_PARAM` /
  `HCI_OP_LE_SET_SCAN_ENABLE`.

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct — identical pattern to BCM4377
  (`hci_bcm4377.c`) and Actions Semi (`btusb.c`).
- **Regression risk:** Very low — only affects `CHIP_ID_8761B` devices,
  and only changes scan command selection to what firmware actually
  supports.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `btrtl_set_quirks()` structure from Max Chou (2023-03-21).
- `CHIP_ID_8761B` added in `04896832c94aa` ("Bluetooth: btrtl: Add
  support for RTL8761B", Apr 2020).
- `HCI_QUIRK_BROKEN_EXT_SCAN` added in `392fca352c7a9` (Nov 2022) for
  Broadcom 4377.
- Bug has existed since 8761B support without this quirk — long-standing
  on common hardware.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related file history
**Record:**
- Recent `btrtl.c` changes: firmware bounds validation, memory leak fix,
  quirk bitmap migration — unrelated.
- No prior fix for 8761B extended scan in this tree.
- Standalone patch, not part of a series.

### Step 3.4: Author context
**Record:** Alexej Sidorenko is not a frequent btrtl contributor in this
tree. Luiz von Dentz (Bluetooth maintainer) signed off. No related
commits from this author found in-tree.

### Step 3.5: Dependencies
**Record:**
- Requires `HCI_QUIRK_BROKEN_EXT_SCAN` — present (ancestor
  `392fca352c7a9` confirmed in tree).
- Requires `CHIP_ID_8761B` — present (ancestor `04896832c94aa` confirmed
  in tree).
- Requires `btrtl_set_quirks()` call path — present via
  `btusb_setup_realtek()` → `btrtl_setup_realtek()`.
- **Standalone:** Yes, applies without other patches.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 shazam "Bluetooth: btrtl: fix RTL8761B/BU broken LE extended
  scan"` — not found on lore.
- `b4 shazam "fix RTL8761B"` / `"BROKEN_EXT_SCAN"` — not found.
- No `.mbx` file for this patch in the workspace.
- **UNVERIFIED:** Full review thread — patch may be too recent for lore
  indexing.

### Step 4.2: Reviewers
**Record:** Could not retrieve via `b4 dig -w` (commit not in local git
history). Maintainer SOB from Luiz von Dentz confirmed in commit
message.

### Step 4.3: Bug report
**Record:** No external bug report links. Author tested on RTL8761BU
(USB ID 0bda:a728). That specific VID/PID is not yet in `btusb.c` device
table in this tree, but many other 8761B/BU IDs are (0x0bda:0x8771,
0x2b89:0x8761, etc.) — all use the same `BTUSB_REALTEK` →
`btrtl_setup_realtek()` path.

### Step 4.4: Related patches
**Record:** No multi-patch series identified. Precedent: `392fca352c7a9`
(BCM4377), `7c2b2d2d0cb65` (Actions Semi ATS2851) use the same quirk for
the same class of bug.

### Step 4.5: Stable list history
**Record:** No stable-list discussion found (lore fetch blocked by bot
protection for general search).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `btrtl_set_quirks()` — only function modified.

### Step 5.2: Callers
**Record:**
- `btrtl_setup_realtek()` (line 1359) — called from
  `btusb_setup_realtek()` for all Realtek USB devices.
- `hci_h5.c` (line 946) — UART Realtek path.
- Impact: all RTL8761B/BU devices (USB and UART) during probe/setup.

### Step 5.3: Callees
**Record:** `hci_set_quirks()` — standard HCI quirk registration, no
side effects beyond flag setting.

### Step 5.4: Reachability
**Record:**
- Trigger: any BLE scan attempt while a connection is active on RTL8761B
  hardware — common BlueZ usage pattern.
- Reachable from userspace via normal Bluetooth scanning/discovery
  operations.
- Not config-gated beyond `CONFIG_BT` + Realtek hardware.

### Step 5.5: Similar patterns
**Record:** Identical quirk already used in:
- `drivers/bluetooth/hci_bcm4377.c:2394`
- `drivers/bluetooth/btusb.c:4297` (Actions Semi)

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `btrtl_set_quirks()` in this tree lacks the
`CHIP_ID_8761B` / `HCI_QUIRK_BROKEN_EXT_SCAN` case. RTL8761B support and
extended-scan infrastructure are both present. Bug is live.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Insertion point (`if
(!btrtl_dev->ic_info) return;` followed by new switch, before existing
`lmp_subver` switch) matches current file at lines 1331–1334 exactly.
Recent quirk-bitmap migration (`6851a0c228fc0`) already uses
`hci_set_quirk()` — compatible.

### Step 6.3: Related fixes already present?
**Record:** No existing fix for 8761B extended scan. Quirk exists for
other vendors only.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/bluetooth/btrtl.c` — **IMPORTANT** (Bluetooth
subsystem, Realtek USB dongles widely deployed on
desktops/laptops/embedded).

### Step 7.2: Activity
**Record:** Actively maintained — 5 commits to `btrtl.c` in recent
history (firmware validation, leak fix, quirk migration).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of RTL8761B/BU Bluetooth adapters (USB dongles like
ASUS BT500, TP-Link UB500, Edimax BT-8500, and many 0x0bda:0x8771
variants). Driver-specific, but hardware is very common.

### Step 8.2: Trigger conditions
**Record:**
- BLE connection active + scanning/discovery attempted.
- Common in desktop/laptop Bluetooth usage with BlueZ.
- Unprivileged users can trigger via normal Bluetooth operations.

### Step 8.3: Failure mode severity
**Record:**
- **Failure:** Extended scan HCI commands fail with -EBUSY; continuous
  dmesg errors; BLE scanning broken or degraded while connected.
- **Severity: MEDIUM** — functional breakage and log spam, not kernel
  crash/panic/data corruption. Real user impact on common hardware.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected hardware users — restores working BLE
  scan while connected.
- **Risk:** VERY LOW — 13-line quirk for one chip ID, established
  pattern.
- **Ratio:** Strongly favorable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real hardware bug on common Realtek BT chip
- Hardware quirk/workaround — standard stable exception category
- Small (13 lines), surgical, obviously correct
- Uses existing quirk API — no new features
- Maintainer (Luiz von Dentz) signed off
- Author tested on real RTL8761BU hardware
- Bug present since 8761B support (2020); affects this 6.18.44 tree
- Prerequisites all present; clean apply expected
- Same fix pattern already accepted for BCM4377 and Actions Semi

**AGAINST backport:**
- Not a crash/security/data-corruption issue (severity MEDIUM, not
  CRITICAL)
- No syzbot or multi-user reports
- Lore discussion not found (may be very recent patch)

**UNRESOLVED:**
- Full mailing-list review thread not retrieved
- 0bda:a728 test device ID not yet in btusb table (but fix is chip-ID
  based, not USB-ID based)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — established quirk pattern;
   author tested on RTL8761BU; maintainer SOB.
2. Fixes a real bug affecting users? **PASS** — broken BLE scanning +
   dmesg errors on RTL8761B/BU.
3. Important issue? **PASS (MEDIUM)** — functional breakage on common
   hardware, not crash/corruption.
4. Small and contained? **PASS** — 13 lines, one file, one chip ID.
5. No new features or APIs? **PASS** — uses existing
   `HCI_QUIRK_BROKEN_EXT_SCAN`.
6. Can apply to local tree? **PASS** — prerequisites present, insertion
   point matches.

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — controller falsely
advertises HCI 5.1 extended scan capability; quirk forces fallback to
supported legacy commands.

### Step 9.4: Decision rationale
This is a textbook stable hardware-quirk fix: Realtek RTL8761B/BU
firmware lies about extended scan support, causing repeated HCI command
failures during normal BlueZ operation. The fix is minimal, follows an
established pattern already in this tree for other vendors, touches only
affected hardware, and restores correct behavior. While not a crash-
level bug, it causes real functional breakage on widely deployed USB
Bluetooth dongles — exactly the kind of fix stable trees carry for
existing drivers.

---

## Verification

- **[Phase 1]** Parsed commit message: subject, body, SOBs; no
  Fixes/Reported-by/Link tags
- **[Phase 1]** Confirmed opcode note: 0x2041=PARAMS, 0x2042=ENABLE in
  `include/net/bluetooth/hci.h`
- **[Phase 2]** Diff: +13 lines in `btrtl_set_quirks()`, one file
- **[Phase 2]** Read `use_ext_scan()` macro at
  `include/net/bluetooth/hci_core.h:2011-2013`
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- **[Phase 3]** `git merge-base --is-ancestor 392fca352c7a9 HEAD`: quirk
  in tree
- **[Phase 3]** `git merge-base --is-ancestor 04896832c94aa HEAD`: 8761B
  support in tree
- **[Phase 3]** `git blame` on lines 1331-1344: structure unchanged, no
  8761B quirk present
- **[Phase 3]** `git log --grep="broken LE extended scan"`: no match
  (commit not yet merged)
- **[Phase 4]** `b4 shazam`: patch not found on lore
- **[Phase 4]** WebFetch lore.kernel.org: blocked by bot protection
- **[Phase 5]** Grep callers: `btrtl_setup_realtek()` at btrtl.c:1359,
  `btusb_setup_realtek()` at btusb.c:2709
- **[Phase 5]** Grep `HCI_QUIRK_BROKEN_EXT_SCAN`: hci_bcm4377.c, btusb.c
  (Actions Semi)
- **[Phase 6]** Read current `btrtl_set_quirks()`: missing 8761B quirk
  case (lines 1290-1345)
- **[Phase 6]** Verified `CHIP_ID_8761B` enum and firmware mapping at
  btrtl.c:68,658
- **[Phase 6]** Verified 8761BU IC_INFO entry at btrtl.c:225-231
- **[Phase 8]** Grep btusb device table: multiple 8761B/BU USB IDs
  present (0x8771, 0x8761, etc.)
- **UNVERIFIED:** Full lore review thread and explicit stable nomination
  from reviewers

**YES**The background searches finished and didn’t change the
conclusion.

**Task 1 (commit search / b4 dig):** The commit isn’t in this tree yet.
`b4 dig` on HEAD pointed at an unrelated patch, and `git log` had no
match for “broken LE extended scan” or “8761B/BU”.

**Task 2 (author / lore):** Alexej Sidorenko and Sidorenko don’t show up
as btrtl contributors here. `b4 dig` failed due to wrong syntax, and `b4
shazam` later also found no lore thread for this patch — likely too new
or not indexed yet.

The stable backport verdict stands: **YES** for 6.18.44 — a small
hardware quirk fix for RTL8761B/BU that restores working BLE scan while
connected.

 drivers/bluetooth/btrtl.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index a62eae7276d64..cb1c321910e2a 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1331,6 +1331,19 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
 	if (!btrtl_dev->ic_info)
 		return;
 
+	switch (btrtl_dev->project_id) {
+	case CHIP_ID_8761B:
+		/* RTL8761B/BU reports HCI version 5.1 but does not support
+		 * the LE Extended Scan commands (Opcode 0x2042), causing
+		 * repeated -EBUSY failures when BlueZ attempts extended
+		 * scanning while a connection is active.
+		 */
+		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_EXT_SCAN);
+		break;
+	default:
+		break;
+	}
+
 	switch (btrtl_dev->ic_info->lmp_subver) {
 	case RTL_ROM_LMP_8703B:
 		/* 8723CS reports two pages for local ext features,
-- 
2.53.0

