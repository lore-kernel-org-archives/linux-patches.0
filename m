Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C9457EDB0;
	Mon, 19 Oct 2026 13:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418392; cv=none; b=T6q3NoJDGxg0AxwPAFZXLzQEXGIW+Ic0N4NFMGiJSu15w/EKAIyQ9JjwH1uswjbmP1ujo+G9BnCJ2mr55bjsJG6mOTrkVwd96QN/HVal/IGmQA0xRgs2uvN84dXDmkaLASxoYfKhyKeAN2+pXSjAWZgMTqwq9ulVRUgf+i86KWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418392; c=relaxed/simple;
	bh=znw0jCi4tK2DDnYP0wUk8j9JGWuISqEE8fnVi62qINs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HF+S1IIqRO+gL7neB6r+/Mf7IvGJiqU4Vk1shvu9Gy8RfCELpHpZa+kPqCSUX0VwPaKegX9GoYBFe/Cr0J4tDsweJrogEPFbGzbpU81YlMQG4Ge3jPCLVTyHTmR95vi3XAGRrkeAIwu+PGW70LxsV6b8RgyplgM+7tb2z45et0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+QARUGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+QARUGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132DB1F000C7;
	Mon, 19 Oct 2026 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418390;
	bh=0mTnB3q6qurKbbisj70Dl3zQHIdtoxqYsW4cUmLxyc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+QARUGYOZHGORb6zT6nA2btLAmCjZiCCG0COl08XSJT9Tx0/7Y1B+3HLIBlYVwPS
	 pL9+sTp1RwjEhZhG5l2I+bo03vRB5kaYBxWzCmJyo+NpLTdGhE2aY02aFlLaQWevAo
	 Df0111gQFMOxm6ptDFcZXdAVjd8ZHYhEGiJjKJy/OtVsLjxq+vwc9BTYqhgVUCpHHY
	 MPYYq7gqEa/AQ2AjJpcUVV+ma4eeMI0gkBO+0ytn0pq1O1UB1cSRLApy12Onsl+/zd
	 TiX6ctG3rrcUDliciNF0QPSPcqVpgJ/IEc+H74JxTCz3M5zrKmiSLtDonEywAIEvZJ
	 Cp9sHcmmO0qdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pavel Zverev <playximik29@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] Bluetooth: btusb: Add support for 1357:c123 Realtek 8852BE device
Date: Mon, 19 Oct 2026 09:48:26 -0400
Message-ID: <20261019135441.1420968-215-sashal@kernel.org>
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

From: Pavel Zverev <playximik29@gmail.com>

[ Upstream commit 335d7bd554a20f33acf762655cafe1089f7f5822 ]

Wiko Hi MateBook 14 Ryzen 200 laptops (DMI system-product-name
"MNCA-XX", board "M1060") are equipped with an RTL8852BE Wi-Fi/BT
combo chip (rtw89_8852be), whose Bluetooth radio enumerates as
1357:c123 instead of one of the already-supported 1358:c123 / 0bda:c123
identifiers, presumably due to OEM rebranding. Without a matching
entry it only matches the generic USB Bluetooth class fallback, so the
Realtek firmware/config (rtl8852btu_fw.bin / rtl8852btu_config.bin) is
never loaded and the adapter cannot discover or connect to any device,
even though hciconfig reports it as powered and scanning.

Device descriptor:
  idVendor           0x1357
  idProduct          0xc123
  bcdDevice            0.00
  iManufacturer           1 Realtek
  iProduct                2 Bluetooth Radio
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth

Adding the same BTUSB_REALTEK | BTUSB_WIDEBAND_SPEECH quirk already
used for 1358:c123 and 0bda:c123 fixes firmware loading and normal
operation.

Signed-off-by: Pavel Zverev <playximik29@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a two-line USB ID addition for an existing Realtek path in
`btusb`. The 6.18.53 tree already has that path and the sibling IDs;
this OEM VID is missing, so Bluetooth never loads firmware on the
affected laptop.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[Bluetooth/btusb] [Add] USB ID 1357:c123 for Realtek 8852BE
(OEM rebrand of known c123 devices)`

**Step 1.2 — Tags**
Record:
- Signed-off-by: Pavel Zverev \<playximik29@gmail.com\> (author)
- Signed-off-by: Luiz Augusto von Dentz \<luiz.von.dentz@intel.com\>
  (Bluetooth maintainer; applied the patch)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable (absence of Fixes/Cc:stable is expected for this review
  queue)

**Step 1.3 — Body**
Record:
- Bug: Wiko Hi MateBook 14 Ryzen 200 (DMI `"MNCA-XX"` / board `"M1060"`)
  has RTL8852BE (Wi-Fi `rtw89_8852be`). BT enumerates as **1357:c123**
  instead of already-supported **1358:c123** / **0bda:c123**.
- Symptom: generic USB Bluetooth class match only; `rtl8852btu_fw.bin` /
  `rtl8852btu_config.bin` never load; adapter appears powered/scanning
  but cannot discover or connect.
- Root cause: missing `quirks_table` entry so `BTUSB_REALTEK` is never
  applied.
- Descriptor: vendor 0x1357, product 0xc123, class 224/1/1, manufacturer
  “Realtek”.
- Fix: same `BTUSB_REALTEK | BTUSB_WIDEBAND_SPEECH` flags as the sibling
  IDs.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. It is an explicit hardware-enablement / device-ID
quirk. Bluetooth is non-functional without it.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record: `drivers/bluetooth/btusb.c` only; **+2 / -0** lines; table
`quirks_table[]`; single-file surgical change.

**Step 2.2 — Flow**
Record: After `{ USB_DEVICE(0x0bda, 0xc123), ... }` insert `{
USB_DEVICE(0x1357, 0xc123), .driver_info = BTUSB_REALTEK |
BTUSB_WIDEBAND_SPEECH }`. Probe path only; no error-path or locking
change.

**Step 2.3 — Bug mechanism**
Record: **Hardware workaround / device ID** (stable exception). Without
the ID:
1. Device matches generic `{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) }` in
   `btusb_table` with `driver_info == 0`.
2. `btusb_probe()` then calls `usb_match_id(intf, quirks_table)`.
3. No match → no `BTUSB_REALTEK` → `hdev->setup` is not
   `btusb_setup_realtek` → no `btrtl_download_firmware()`.

Firmware is chosen later by chip identity (`btrtl_match_ic()` on LMP/HCI
rev), not by USB PID, so this ID only gates the Realtek setup path.

**Step 2.4 — Fix quality**
Record: Obviously correct copy of sibling entries. Scope is this VID:PID
only. Regression risk is negligible (wrong non-Realtek device with
1357:c123 is not plausible given the descriptor). No API/structure
change.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Neighbor IDs:
- `1358:c123` — `f496297e76a69` (Julian Pidancet, 2020) “Add support for
  1358:c123 Realtek 8822CE” (Huawei Matebook); contained in v5.11-rc1.
- `0bda:c123` — `24d6a6d24f01f` (Cadel Watson, 2020) “Support 0bda:c123
  Realtek 8822CE”; also v5.11-rc1.
The missing ID is new OEM VID 0x1357 with the same PID. Buggy “no
Realtek quirk” behavior has existed for this VID:PID for as long as the
device has existed; the table itself has been there since ~5.11.

**Step 3.2 — Fixes: tag**
Record: None. Not a regression from a specific commit; it is a missing
ID.

**Step 3.3 — File history**
Record: Recent `btusb.c` history in this tree includes many of the same
pattern (`Add Realtek RTL8922AE VID/PID 0bda/d923`, Mercusys/ASUS/TP-
Link IDs, several RTL8852BE IDs). Standalone; not “patch X/Y”.

**Step 3.4 — Author**
Record: Pavel Zverev has no other `drivers/bluetooth/` commits in this
tree. Applied by Luiz Augusto von Dentz (Bluetooth USB maintainer). Same
class of ID adds is routinely accepted.

**Step 3.5 — Dependencies**
Record: Needs existing `BTUSB_REALTEK` / `quirks_table` /
`btrtl_setup_realtek()` / RTL8852 firmware table. All are in this tree
(`1fb9943146968` RTL8852BT/8852BE-VT firmware matching is an ancestor of
HEAD). Standalone +2 lines.

## Phase 4: Mailing list

**Step 4.1 — Original discussion**
Record:
- SHA: `335d7bd554a20f33acf762655cafe1089f7f5822`
- `b4 dig -c`:
  https://patch.msgid.link/20260707221549.27269-1-playximik29@gmail.com
- `b4 dig -a`: **v1 only**, 2026-07-08, no later revision
- Thread: submission, BlueZ CI pass, patchwork-bot “applied to
  bluetooth-next”
- No NAK, no reviewer risk flags, no request for changes
- Applied to bluetooth-next as `1386e748cfc0`; later on master as
  `335d7bd554a20`

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: To Marcel Holtmann, Luiz Dentz; Cc linux-bluetooth@. Correct
lists/maintainers. Luiz applied it.

**Step 4.3 — Bug report**
Record: No bugzilla/syzbot link. Author reports a specific laptop (DMI +
USB descriptor) and that adding the ID restored discovery/connect.
Direct user impact, one platform.

**Step 4.4 — Series**
Record: Single standalone patch. CI: CheckPatch, build, sparse all PASS
(Patchwork series 1123385).

**Step 4.5 — Stable list**
Record: lore.kernel.org HTTP 403 from WebFetch; WebSearch for stable
discussion failed. No local `git log --grep=1357:c123` hits. UNVERIFIED:
no evidence this was already discussed on stable@; that is not a
negative.

## Phase 5: Code semantics

**Step 5.1 — Functions**
Record: No function body change. Data: `quirks_table[]`. Consumers:
`btusb_probe()` via `usb_match_id()`.

**Step 5.2 — Callers**
Record: USB probe when a matching interface is enumerated. `btusb_table`
generic class entry binds first; then quirks_table supplies
`driver_info`. Not irq/syscall hot path; once per device bind.

**Step 5.3 — Callees**
Record: With the new flags, probe sets `hdev->setup =
btusb_setup_realtek` → `btrtl_setup_realtek()` → `btrtl_initialize()` /
`btrtl_download_firmware()`. Also `HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED`.
`CONFIG_BT_HCIBTUSB_RTL` defaults to y.

**Step 5.4 — Reachability**
Record: Yes, from plugging in / internal USB BT of that laptop.
Unprivileged users then use BlueZ; the bug is “adapter never works,” not
a crash.

**Step 5.5 — Similar patterns**
Record: Dozens of `BTUSB_REALTEK | BTUSB_WIDEBAND_SPEECH` IDs, including
other 8852BE VIDs (`0bda:4853`, `13d3:3618`, `0489:e123`, …). Sibling
`c123` IDs already present. Same fix applied many times.

## Phase 6: This tree (6.18.53)

**Step 6.1 — Does the buggy code exist?**
Record: Yes.
- Tree: `pending-6.18`, `git describe HEAD` = `p-6.18-1-g03b85e06ca9bf`,
  `make kernelversion` = **6.18.53**, merge-base with master = `Linux
  6.18` (2025-11-30).
- `git merge-base --is-ancestor 335d7bd554a20 HEAD` → **not in HEAD**.
- `1358:c123` and `0bda:c123` are at lines 877–880 of
  `drivers/bluetooth/btusb.c`; **1357:c123 is absent**.
- Realtek setup and `rtl8852btu_*` firmware names exist in `btrtl.c`.

The ID was added in mainline in Aug 2026, after 6.18; the **gap**
(missing ID) is in this tree. That is the usual device-ID backport case,
not “code not present.”

**Step 6.2 — Backport difficulty**
Record: `git show 335d7bd554a20 | git apply --check` succeeded (hunk at
line 878, offset -16). Clean apply, trivial offset.

**Step 6.3 — Related fixes already here?**
Record: No 1357:c123 entry. Other 8852BE IDs and firmware support are
already here; this does not duplicate them.

## Phase 7: Subsystem context

**Step 7.1**
Record: `drivers/bluetooth/btusb.c` — USB Bluetooth. **IMPORTANT** (very
common laptop combo chips), not core mm/vfs, not staging.

**Step 7.2**
Record: Actively maintained; this tree already backported many
`Bluetooth: btusb: Add ...` ID patches (e.g. `b85ef6483d5b3` RTL8922AE
0bda/d923). Mature table, ongoing OEM IDs.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: Driver + VID/PID specific. Users of 1357:c123, documented as
Wiko Hi MateBook 14 Ryzen 200. No effect on other devices.

**Step 8.2 — Trigger**
Record: Every boot / BT bring-up on that hardware. Not a race.
Unprivileged use of BT is broken until firmware loads.

**Step 8.3 — Failure mode**
Record: Adapter enumerates and looks “up” but cannot discover or
connect. Severity **HIGH** for that hardware (Bluetooth unusable), not a
panic. Device-ID exception still applies.

**Step 8.4 — Risk vs benefit**
Record:
- Benefit: high for affected laptops; zero for everyone else.
- Risk: very low (+2 lines, VID/PID gated, same flags as existing c123
  entries).
- Ratio: strongly in favor of backport.

## Phase 9: Synthesis

**Evidence FOR**
- Explicit stable exception: **new USB ID on an existing driver**.
- Real user-visible bug: BT cannot pair/connect without Realtek
  firmware.
- +2 lines, identical to 1358:c123 / 0bda:c123 already in 6.18.53.
- Applies cleanly; Realtek/8852 firmware path already present.
- Maintainer-applied; CI passed; no NAKs.
- This 6.18.y tree already takes the same class of ID adds.

**Evidence AGAINST**
- Not a crash/UAF/security issue (not required for device IDs).
- One OEM laptop family (still a real product).
- Author is not a regular Bluetooth contributor (offset by Luiz applying
  it).
- Sibling IDs were labeled 8822CE in 2020; this commit says 8852BE.
  Firmware is matched by chip ID after `BTUSB_REALTEK`, so a mis-named
  chip in the subject would still load the correct image. Author cites
  `rtl8852btu_*` from the working setup.

**Unresolved**
- Could not fetch lore/stable@ via HTTP (403). Thread recovered via `b4
  dig -m`.
- Did not independently attach the laptop; relied on author’s descriptor
  and “works after this ID.”

**Stable rules**
1. Obviously correct and tested? **PASS** (same flags as siblings;
   author + CI + maintainer).
2. Real bug affecting users? **PASS** (BT unusable on that hardware).
3. Important? **PASS** under the device-ID exception (hardware does not
   work).
4. Small and contained? **PASS** (+2 lines, one table).
5. No new features/APIs? **PASS** (existing quirk flags only).
6. Applies to this tree? **PASS** (`git apply --check` clean).

**Exception category:** NEW DEVICE ID on existing `btusb` / Realtek
path.

This should be backported to this 6.18.53 tree. The driver, Realtek
firmware loader, and sibling `c123` quirks are already here; only
1357:c123 is missing, and that is enough to leave this laptop’s
Bluetooth non-functional.

Verification:
- [Phase 1] Parsed subject/tags from `git show 335d7bd554a20`; no
  Fixes/Cc:stable; Luiz SOB present
- [Phase 2] Diff is +2 lines in `quirks_table`; confirmed
  `btusb_probe()` uses generic class match then `usb_match_id(...,
  quirks_table)` when `driver_info == 0` (btusb.c ~4064–4069, 82–83,
  4309–4312)
- [Phase 2] Firmware selected by `btrtl_match_ic()` /
  `btrtl_setup_realtek()`, not USB PID (`btrtl.c` 342–345, 1359–1368)
- [Phase 3] Blame: 1358:c123 = f496297e76a69, 0bda:c123 = 24d6a6d24f01f,
  both v5.11-rc1 and in this tree
- [Phase 3] `git merge-base --is-ancestor 335d7bd554a20 HEAD` → not in
  this tree
- [Phase 3] `git merge-base --is-ancestor 1fb9943146968 HEAD` →
  8852BT/BE-VT firmware support is in this tree
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1, linux-bluetooth, Luiz applied, CI
  PASS, no NAK
- [Phase 4] lore WebFetch 403; stable@ search failed — UNVERIFIED beyond
  b4 mbox
- [Phase 5] `CONFIG_BT_HCIBTUSB_RTL` default y (Kconfig);
  `BTUSB_WIDEBAND_SPEECH` → `HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED`
  (btusb.c:4344)
- [Phase 6] `git describe HEAD` p-6.18-1-g03b85e06ca9bf; kernel 6.18.53;
  grep shows 1358/0bda:c123, not 1357:c123
- [Phase 6] `git apply --check` succeeded with offset -16
- [Phase 7/8] Same ID-add pattern already in this tree (e.g.
  b85ef6483d5b3)
- UNVERIFIED: physical confirmation of 8852BE vs 8822CE; does not change
  the ID-add decision because firmware is chip-matched

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9257341b01399..3c9d5d0976936 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -882,6 +882,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0xc123), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x1357, 0xc123), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-- 
2.53.0

