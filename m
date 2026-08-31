Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF89570949;
	Mon, 31 Aug 2026 13:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184122; cv=none; b=EFUYTXopVtyY75ienuVAsuZ7mUJNMdCGvS/FgDJayljRszFvmf0jnzAzmQTTc54HpcMkTiWod/CkY2/a0np/kDbMue5fEwC00MmzwWd/w0hX0RjK7OC+eg9753zOUoOZ22LLncbqWo6TqGZVvDM2Yt0xe0gHci4hlejvbfyAqlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184122; c=relaxed/simple;
	bh=kmfXnNh3nW1Tg6xQeUrBoohg2i0kGOQcCo6SOJOot8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nj3EvEfHm5F0Mn+AWmCojvLjQGwsHmvuA3RO3+pcGFipGxc9GBbUfKS1ddG6ZxQMwXt6hKFFS0kdWb8P06b02j9Xi8GEwZlpy5Ij2z478a5lCowasAqpOnVz+FxEE2JerJdZpGsOB/Em6buVub8Aod/m+hufnBA065rEJWHcDQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARyuucKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARyuucKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436DD1F00A3E;
	Mon, 31 Aug 2026 13:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184119;
	bh=xuv0Qm7I4So6We4T+cPlqW/th5JMFvoaN8vG4g+joF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARyuucKJnZtpzg57O2sbs8PszpUY1jtQNLNZtEHFggAbByUxHPuMlp3tNyv7qYJXS
	 Dj9W4H/IXS4bGkHtabagulko+YnpJHo0/9llFYZ+CxzgSk8Zyj8PEKONbLlBmGPdqr
	 gg/WFISgHx+NZ1waCb3b7YOlGFHPdQB10yaeZpMAJtyvcka+0rMDHi5BKZPxYk9yXe
	 xJ0+2ZSxAEhZGkl9fKGbkARvJuU+vIdu6UNT8GXh372xsav5j1yz2HecwH13rTCKTL
	 lpcsGlZk21iUFjRauXN+ICzpqrShuU9GvPYzQiWdF3ZKi5+O4DdBLzZED3+8lkqUxA
	 C2EFLAIwFktBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rong Zhang <i@rong.moe>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] Bluetooth: btmtk: Disable remote wakeup for MT7922/MT7925
Date: Mon, 31 Aug 2026 09:28:51 -0400
Message-ID: <20260831133314.4125787-503-sashal@kernel.org>
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

From: Rong Zhang <i@rong.moe>

[ Upstream commit e31d761628ad7e96490fc78105ed0a064ec1c1d9 ]

These NICs are often reported to lose their Bluetooth interfaces, i.e,
their USB interfaces suddenly become completely unresponsive, causing
the USB core to reset them, only to find that they are no longer
accessible. A power cycle is required to make the Bluetooth interfaces
recover.

After some investigations, I found that their USB autosuspend remote
wakeup capabilities are so broken that they are precisely the culprit
behind the issue:

  [27452.608056] hub 3-0:1.0: state 7 ports 5 chg 0000 evt 0020
  [27452.702018] usb 3-5: usb wakeup-resume
  [27452.716038] usb 3-5: Waited 0ms for CONNECT
  [27452.716642] usb 3-5: finish resume
  /* usbmon showed that the device was completely unresponsive to any
     URBs after the remote wakeup */
  [27457.836030] usb 3-5: retry with reset-resume
  [27457.956046] usb 3-5: reset high-speed USB device number 4 using xhci_hcd
  [27463.332047] usb 3-5: device descriptor read/64, error -110
  [27478.948117] usb 3-5: device descriptor read/64, error -110
  [27479.172430] usb 3-5: reset high-speed USB device number 4 using xhci_hcd
  [27484.332035] usb 3-5: device descriptor read/64, error -110
  [27499.940039] usb 3-5: device descriptor read/64, error -110
  [27500.164060] usb 3-5: reset high-speed USB device number 4 using xhci_hcd
  [27505.196142] xhci_hcd 0000:67:00.0: Timeout while waiting for setup device command
  [27510.576045] xhci_hcd 0000:67:00.0: Timeout while waiting for setup device command
  [27510.784038] usb 3-5: device not accepting address 4, error -62
  [27510.912215] usb 3-5: reset high-speed USB device number 4 using xhci_hcd
  [27515.948307] xhci_hcd 0000:67:00.0: Timeout while waiting for setup device command
  [27521.324380] xhci_hcd 0000:67:00.0: Timeout while waiting for setup device command
  [27521.525107] usb 3-5: device not accepting address 4, error -62
  [27521.525928] usb usb3-port5: logical disconnect
  [27521.525996] usb 3-5: gone after usb resume? status -19
  [27521.526230] usb 3-5: can't resume, status -19
  [27521.526434] usb usb3-port5: logical disconnect
  [27521.526469] usb usb3-port5: resume, status -19
  [27521.526493] usb usb3-port5: status 0503, change 0004, 480 Mb/s
  [27521.526528] usb 3-5: USB disconnect, device number 4
  [27521.526736] usb 3-5: unregistering device
  [27521.804029] usb 3-5: new high-speed USB device number 5 using xhci_hcd
  [27527.076067] usb 3-5: device descriptor read/64, error -110
  [27542.692027] usb 3-5: device descriptor read/64, error -110
  [27542.916047] usb 3-5: new high-speed USB device number 6 using xhci_hcd
  [27548.068043] usb 3-5: device descriptor read/64, error -110
  [27563.684073] usb 3-5: device descriptor read/64, error -110
  [27563.792133] usb usb3-port5: attempt power cycle
  [27563.924381] hub 3-0:1.0: port_wait_reset: err = -11
  [27563.925213] usb usb3-port5: not enabled, trying reset again...
  [27564.184398] usb 3-5: new high-speed USB device number 7 using xhci_hcd
  [27569.196322] xhci_hcd 0000:67:00.0: Timeout while waiting for setup device command
  [27574.572040] xhci_hcd 0000:67:00.0: Timeout while waiting for setup device command
  [27574.776053] usb 3-5: device not accepting address 7, error -62
  [27574.900165] usb 3-5: new high-speed USB device number 8 using xhci_hcd
  [27579.948039] xhci_hcd 0000:67:00.0: Timeout while waiting for setup device command
  [27585.324331] xhci_hcd 0000:67:00.0: Timeout while waiting for setup device command
  [27585.528040] usb 3-5: device not accepting address 8, error -62
  [27585.528389] usb usb3-port5: unable to enumerate USB device
  [27585.528424] hub 3-0:1.0: state 7 ports 5 chg 0000 evt 0020

To reproduce the issue, these conditions must be met:
- a noisy radio environment (cafe or office) to cause frequent remote
  wakeup events
- no Bluetooth device is connected, so autosuspend is not prohibited
- the Bluetooth interface is opened, so remote wakeup is enabled when
  the device runs into autosuspend

Then I can reproduce the issue within sereval hours each time.

Increasing TRSMRCY or setting USB_QUIRK_RESET doesn't help at all.

Since the remote wakeup capability is super broken, just disable it to
get rid of the troubles. The device can still be autosuspended when
the bluetooth interface is closed, which won't break the device as
remote wakeup is unneeded in this case.

Link: https://bbs.archlinux.org/viewtopic.php?id=308169
Link: https://bbs.bee-link.com/d/7694-gtr9-pro-ai-max-395-usb-issues
Signed-off-by: Rong Zhang <i@rong.moe>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: **[Bluetooth: btmtk]** **[Disable]** — disable broken USB remote
wakeup for MT7922/MT7925 MediaTek Bluetooth controllers.

**Step 1.2 — Tags**

Record:
- **Link:** https://bbs.archlinux.org/viewtopic.php?id=308169
- **Link:** https://bbs.bee-link.com/d/7694-gtr9-pro-ai-max-395-usb-
  issues
- **Signed-off-by:** Rong Zhang \<i@rong.moe\> (author)
- **Signed-off-by:** Luiz Augusto von Dentz \<luiz.von.dentz@intel.com\>
  (Bluetooth maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable@vger.kernel.org
- Notable: maintainer Signed-off-by; two public user forum links
  documenting widespread hardware issues

**Step 1.3 — Body analysis**

Record:
- **Bug:** MT7922/MT7925 USB Bluetooth interfaces become completely
  unresponsive after a broken USB remote-wakeup/autosuspend resume
  cycle.
- **Symptom:** USB core logs `usb wakeup-resume`, device stops answering
  URBs, repeated reset-resume failures (`error -110`, `error -62`),
  logical disconnect, enumeration failure; only a full power cycle
  recovers Bluetooth.
- **Root cause (author):** USB autosuspend remote-wakeup on these chips
  is fundamentally broken.
- **Trigger:** Noisy RF environment → frequent remote wakeup; no BT
  connection (autosuspend allowed); HCI interface open
  (`needs_remote_wakeup` enabled).
- **Reproducibility:** Author reproduces within hours under those
  conditions.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite “Disable” wording, this is a hardware quirk
workaround for a real, user-visible failure — same class as existing
Bluetooth USB wakeup workarounds.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **Files:** `drivers/bluetooth/btmtk.c` (+10 lines, 0 removed)
- **Function:** `btmtk_usb_setup()`
- **Scope:** Single-file, surgical change in a `switch (dev_id)` case
  block

**Step 2.2 — Code flow**

Record:
- **Before:** `case 0x7922:` / `case 0x7925:` fall through directly into
  shared 79xx firmware setup with default USB wakeup capability.
- **After:** For 7922/7925 only, call
  `device_set_wakeup_capable(&btmtk_data->udev->dev, false)`, then
  `fallthrough` into the shared 7961/79xx path.
- **Path:** Runs during `btmtk_usb_setup()` → `btusb_mtk_setup()` →
  `hdev->setup` on each HCI open (`HCI_QUIRK_NON_PERSISTENT_SETUP`).

**Step 2.3 — Bug mechanism**

Record: **Hardware quirk / PM correctness fix.** USB core enables remote
wakeup when `intf->needs_remote_wakeup` is set (in `btusb_open()`) and
`device_can_wakeup()` is true. Broken remote wakeup on MT7922/7925
leaves the device dead on resume. Disabling wakeup capability prevents
the broken path while preserving autosuspend when the interface is
closed.

**Step 2.4 — Fix quality**

Record:
- **Quality:** High — mirrors the existing CSR/Barrot workaround in
  `btusb.c` (`device_set_wakeup_capable(..., false)` at line 2584).
- **Regression risk:** Low — only affects MT7922/MT7925; trade-off is
  losing remote wakeup from autosuspend while HCI is open, which the
  author documents as non-functional on this hardware anyway.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- `case 0x7922:` / `case 0x7925:` introduced in `5c5e8c52e3caf`
  (2024-07-15) when setup moved to `btmtk.c`.
- `case 0x7961:` added in `a7208610761ae` (2025-01-10).
- MT7922 USB support dates to `09a19d6dd974c` (2021); MT7925 to
  `4c92ae75ea7d4` (2023).
- Bug has been present since wakeup-capable autosuspend was possible on
  these chips.

**Step 3.2 — Fixes: tag**

Record: N/A — no Fixes: tag.

**Step 3.3 — Related file history**

Record:
- Active `btmtk.c` maintenance (URB leaks, WMT validation, shutdown
  fixes).
- No prior fix for this remote-wakeup issue in this tree.
- Mainline commit: `e31d761628ad7e96490fc78105ed0a064ec1c1d9`
  (2026-06-11) — **not** an ancestor of local HEAD.

**Step 3.4 — Author context**

Record: Rong Zhang is a regular kernel contributor; patch merged with
Bluetooth maintainer Luiz von Dentz SOB.

**Step 3.5 — Dependencies**

Record: **Standalone.** No series dependencies. Mainline references
`0x7902`/`0x6639` cases not present in this 6.18.44 tree; adapted
version applies cleanly (verified).

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- **b4 dig:** https://patch.msgid.link/20260603-btmtk-remote-
  wakeup-v1-1-5c1006442f36@rong.moe
- **Revisions:** v1 only (no v2/v3).
- Lore direct fetch blocked by bot protection; thread metadata obtained
  via b4.

**Step 4.2 — Reviewers**

Record: CC'd Marcel Holtmann, Luiz von Dentz, Matthias Brugger, linux-
bluetooth@vger.kernel.org, linux-mediatek@lists.infradead.org.

**Step 4.3 — Bug reports**

Record:
- Arch Linux forum: MT7922 Bluetooth USB failures.
- Bee-link forum: GTR9 Pro USB/BT issues.
- Severity: device permanently unusable until power cycle — high
  functional impact.

**Step 4.4 — Related patches**

Record: Standalone single patch; not part of a multi-patch series.

**Step 4.5 — Stable list**

Record: Not searched (lore blocked); no stable discussion found via b4.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `btmtk_usb_setup()`, called from `btusb_mtk_setup()` in
`btusb.c`.

**Step 5.2 — Callers**

Record:
- `btusb_mtk_setup()` → `btmtk_usb_setup()` during HCI setup on every
  open.
- `btusb_open()` sets `data->intf->needs_remote_wakeup = 1` (line 1948).
- USB PM in `driver.c` checks `device_can_wakeup()` before enabling
  `do_remote_wakeup` (line 1970).

**Step 5.3 — Callees**

Record: `device_set_wakeup_capable()` — PM helper, already used in
`btusb.c` for similar purpose.

**Step 5.4 — Reachability**

Record: **Userspace-reachable** — opening Bluetooth (`bluetoothd`,
`hciconfig up`, etc.) triggers setup; with
`CONFIG_BT_HCIBTUSB_AUTOSUSPEND` (or runtime PM), autosuspend + remote
wakeup is a normal laptop code path.

**Step 5.5 — Similar patterns**

Record: CSR/Barrot clone workaround in `btusb.c` uses identical
`device_set_wakeup_capable(false)` approach for broken remote wakeup.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **YES.** Local tree is **v6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`, `make kernelversion` → `6.18.44`).
`drivers/bluetooth/btmtk.c` lines 1335–1337 have `case 0x7922:` / `case
0x7925:` without wakeup disable. Fix commit `e31d761628ad` is **not** in
this tree.

**Step 6.2 — Backport complications**

Record:
- Mainline patch does **not** apply verbatim (`git apply --check` fails
  — missing `div class="content"` cases).
- **Adapted patch applies cleanly** (insert wakeup disable +
  `fallthrough` before `case 0x7961:`).
- `fallthrough` already used in this file (lines 417, 966).

**Step 6.3 — Related fixes already present?**

Record: **No** equivalent fix in `btmtk.c`. `btusb.c` CSR workaround is
unrelated hardware.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: **drivers/bluetooth** (btmtk USB) — **IMPORTANT** (common
laptop/mini-PC hardware, not core kernel but widely deployed).

**Step 7.2 — Activity**

Record: `btmtk.c` actively maintained in 6.18.y with multiple recent bug
fixes.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users with USB MT7922/MT7925 Bluetooth (`CONFIG_BT_HCIBTUSB` +
`CONFIG_BT_HCIBTUSB_MTK`) — very common on AMD Ryzen laptops and recent
mini PCs.

**Step 8.2 — Trigger conditions**

Record: Autosuspend + open HCI + noisy RF → remote wakeup events.
Moderately common on laptops in offices/cafés with Bluetooth scanning
enabled.

**Step 8.3 — Failure severity**

Record: USB device permanently dead until power cycle; Bluetooth lost
entirely. **HIGH** functional severity (not a kernel oops, but
effectively bricks BT until reboot).

**Step 8.4 — Risk/benefit**

Record:
- **Benefit:** High — prevents common, hard-to-recover hardware failure
  on widely deployed chips.
- **Risk:** Very low — 10-line quirk, chip-specific, established pattern
  in same driver stack.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

**Evidence FOR:**
- Real hardware bug with detailed dmesg and author reproduction
- Multiple public user reports (Arch Linux, Bee-link)
- Bluetooth maintainer Signed-off-by
- Small, surgical, obviously correct quirk workaround
- Precedent in same subsystem (`btusb.c` CSR workaround)
- Buggy code present since MT7922/7925 support in this tree
- Adapted patch applies cleanly to 6.18.44

**Evidence AGAINST:**
- Mainline patch needs minor context adjustment (no `0x7902`/`0x6639` in
  this tree) — trivial
- Loses remote wakeup from autosuspend while HCI open — acceptable since
  hardware wakeup is broken
- Trigger requires specific conditions (noisy RF + autosuspend) — but
  consequences are severe

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — maintainer SOB; author
   reproduced; established pattern
2. Fixes real bug? **PASS** — documented user-visible device failure
3. Important issue? **PASS** — device bricking until power cycle
4. Small and contained? **PASS** — +10 lines, one file
5. No new features/APIs? **PASS** — hardware quirk workaround
6. Can apply to local tree? **PASS** — with trivial context adjustment

**Exception category:** Hardware quirk/workaround (#2 in stable
exceptions).

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  kernel.org patch
- [Phase 2] Diff analysis: +10 lines in `btmtk_usb_setup()`, adds
  `device_set_wakeup_capable(false)` + `fallthrough`
- [Phase 3] `git describe HEAD`: v6.18.44-1-g2736c32da98b9; `make
  kernelversion`: 6.18.44
- [Phase 3] `git blame -L 1335,1340 drivers/bluetooth/btmtk.c`:
  7922/7925 from 5c5e8c52e3caf (2024-07-15)
- [Phase 3] `git merge-base --is-ancestor e31d761628ad HEAD`: exit 129 —
  fix NOT in tree
- [Phase 3] `git log --oneline -20 -- drivers/bluetooth/btmtk.c`: active
  maintenance, no duplicate fix
- [Phase 4] `b4 dig -c e31d761628ad`: lore URL found; v1 only
- [Phase 4] `b4 dig -w`: Marcel Holtmann, Luiz von Dentz CC'd
- [Phase 5] `grep btmtk_usb_setup`: called from `btusb_mtk_setup()` in
  `btusb.c:2882`
- [Phase 5] Read `btusb.c:1948`: `needs_remote_wakeup = 1` on open
- [Phase 5] Read `driver.c:1970`: `device_can_wakeup()` gates remote
  wakeup
- [Phase 5] `btusb.c:2584`: existing `device_set_wakeup_capable(false)`
  precedent
- [Phase 6] `grep device_set_wakeup_capable drivers/bluetooth/btmtk.c`:
  not present — bug exists
- [Phase 6] `git apply --check` mainline patch: FAIL (context mismatch)
- [Phase 6] `git apply --check` adapted patch for 6.18.44: PASS
- [Phase 6] `grep 0x7902|0x6639 drivers/bluetooth/btmtk.c`: no matches
  in this tree
- [Phase 8] MT7922 support since 2021 (`09a19d6dd974c`); MT7925 since
  2023 (`4c92ae75ea7d4`)

---

## Summary

This commit fixes a real, reproducible hardware defect on extremely
common MT7922/MT7925 USB Bluetooth controllers. When autosuspend remote
wakeup fires (especially in noisy RF environments with the HCI interface
open), the device becomes permanently unresponsive and requires a power
cycle. The fix is a 10-line chip-specific quirk that disables broken
remote wakeup — the same approach already used for CSR clone chips in
`btusb.c`. For the locally checked-out **6.18.44** tree, the buggy code
is present, the fix is absent, and an adapted version applies cleanly.

**YES**Those background searches finished and match the earlier
analysis:

- **Local repo search** did not find this fix in the 6.18.44 tree; it
  only turned up an unrelated USB-core commit about freeze/quiesce
  remote wakeup.
- **Kernel.org search** found the mainline commit: `e31d761628ad7` —
  *Bluetooth: btmtk: Disable remote wakeup for MT7922/MT7925* (Rong
  Zhang, 2026-06-11), +10 lines in `drivers/bluetooth/btmtk.c`.

That confirms the fix is on mainline but not in this checkout, and the
backport verdict for **6.18.44** remains **YES** (with a small context
tweak for the missing `0x7902`/`0x6639` cases).

 drivers/bluetooth/btmtk.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index df0b59e6f968b..73ff64a7980ff 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1334,6 +1334,16 @@ int btmtk_usb_setup(struct hci_dev *hdev)
 		break;
 	case 0x7922:
 	case 0x7925:
+		/*
+		 * A remote wakeup could cause the device completely unresponsive, and
+		 * recovering from such a state needs a power cycle.
+		 *
+		 * Since the remote wakeup capability is super broken, just disable it
+		 * to get rid of the troubles. The device can still be autosuspended
+		 * when the bluetooth interface is closed.
+		 */
+		device_set_wakeup_capable(&btmtk_data->udev->dev, false);
+		fallthrough;
 	case 0x7961:
 		btmtk_fw_get_filename(fw_bin_name, sizeof(fw_bin_name), dev_id,
 				      fw_version, fw_flavor);
-- 
2.53.0

