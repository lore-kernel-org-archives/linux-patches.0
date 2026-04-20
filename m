Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768F43E4C68;
	Mon, 20 Apr 2026 13:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691487; cv=none; b=V+mq9JpksigVtuFOc9GEne9nuY0nT5R3zlF+my8bkK8FBg41oUIX5Opv79AzvfzTLe1qE4QD03sZUgdni2HnRT1ubCw9+TPlOOPTCIYyR5paqu+ArqDFey2oK4UIqSmDnVyd6ihno0rd5myEZcwkWB68Q5Bdk/SH4qD34RTnkY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691487; c=relaxed/simple;
	bh=mto+6jsYIVpuVH9PM596mhw/jjt5JOFdKFLGWGOxB3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sziT7hgXy+heaoZ/S82yKPpp4QCpi7JQZjmWi1gUljb3FsXbCkCLsbcxZUupCB24L300hZk8o8XW/h6I0Vf6M0yiVwEk0BnvT8M87PyJMvaVa9SKFzcWvh29YhDaWsES20UcRPyjYti3iQvzAvLzSdmlnaBlL29GUp4aYbax4HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q61Gqwhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q61Gqwhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF5BC19425;
	Mon, 20 Apr 2026 13:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691487;
	bh=mto+6jsYIVpuVH9PM596mhw/jjt5JOFdKFLGWGOxB3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q61GqwhvRUDqYBCXHVQ7D+Kll2X58Hi6tu4fdYx+QfkbDimQTmHFj1YDhXBv125vh
	 ERRVLS/o75NnQdZpHaA7qVdLeLN3lrGzAL3fK/Ey5NmyhqLo6/+ED98okOVGxRX1cd
	 mLuk89ulJ3nbKecIW6rfEOxe0x+qiquSFMXyFmBrtdU3NIA04oQ5vNY3aFSRIop4hG
	 wKXj0Rzs4/vP6RqBBRkntP4XM20SgFmVMnXqAClJWJEmqXKqiI13xL/Eir9XCAvpl5
	 NX6a6Ehc3fZqk7Qxmh5DWXhRNzn+w0l/0bLnlh00D3Dmyx1r33VkgLnLWjsb+xUOYZ
	 e5CMaNmcq38Ow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dylan Eray <dylan.eray6@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] Bluetooth: btusb: Add Lite-On 04ca:3807 for MediaTek MT7921
Date: Mon, 20 Apr 2026 09:17:32 -0400
Message-ID: <20260420132314.1023554-58-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dylan Eray <dylan.eray6@gmail.com>

[ Upstream commit 67377cd38b89ce782ccdb83bda3f65a2def843cd ]

Add USB device ID (04ca:3807) for a Lite-On Wireless_Device containing
a MediaTek MT7921 (MT7920) Bluetooth chipset found in Acer laptops.

Without this entry, btusb binds via the generic USB class-based wildcard
match but never sets the BTUSB_MEDIATEK flag. This means btmtk never
triggers firmware loading, and the driver sends a raw HCI Reset that
the uninitialized chip cannot respond to, resulting in:

  Bluetooth: hci0: Opcode 0x0c03 failed: -110

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below:

T:  Bus=03 Lev=01 Prnt=01 Port=09 Cnt=01 Dev#=5 Spd=480 MxCh=0
P:  Vendor=04ca ProdID=3807 Rev=1.00
S:  Manufacturer=MediaTek Inc.
S:  Product=Wireless_Device
S:  SerialNumber=000000000
C:  #Ifs= 3 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#= 2 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Dylan Eray <dylan.eray6@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `Bluetooth: btusb:`
- Action verb: "Add" (adding a USB device ID)
- Summary: Adding USB device ID 04ca:3807 for Lite-On/MediaTek MT7921
  Bluetooth adapter

Record: [Bluetooth: btusb] [Add] [New USB device ID for existing
MediaTek BT chipset]

**Step 1.2: Tags**
- Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de> (confirmed from
  mailing list review)
- Signed-off-by: Dylan Eray <dylan.eray6@gmail.com> (author)
- Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
  (Bluetooth maintainer)
- No Fixes: tag, no Cc: stable — expected for the commits under review

Record: Reviewed by Paul Menzel, applied by Bluetooth subsystem
maintainer Luiz Augusto von Dentz.

**Step 1.3: Commit Body**
The commit describes a clear, concrete bug: without this device ID
entry, btusb binds via the generic USB class wildcard but never sets
`BTUSB_MEDIATEK`, preventing firmware loading. The chip receives a raw
HCI Reset it cannot handle, producing:
`Bluetooth: hci0: Opcode 0x0c03 failed: -110`
This means Bluetooth is completely non-functional on Acer laptops with
this Lite-On adapter.

Record: [Bug: Bluetooth completely broken on affected Acer laptops]
[Symptom: HCI Reset fails with -110 timeout] [Root cause: missing
device-specific flag prevents firmware loading]

**Step 1.4: Hidden Bug Fix Detection**
This is not disguised — it's a straightforward device ID addition that
fixes a real hardware enablement issue.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `drivers/bluetooth/btusb.c`
- +2 lines added, 0 lines removed
- Only change is adding a new entry to the `quirks_table[]` array

Record: [1 file, +2 lines] [quirks_table[] in btusb.c] [Trivial single-
table addition]

**Step 2.2: Code Flow Change**
Before: Device 04ca:3807 matches the generic USB class wildcard, btusb
loads without `BTUSB_MEDIATEK` flag, firmware not loaded, chip cannot
respond to HCI commands.
After: Device 04ca:3807 matches the specific USB_DEVICE entry with
`BTUSB_MEDIATEK | BTUSB_WIDEBAND_SPEECH` flags, btmtk firmware loading
is triggered, Bluetooth works.

**Step 2.3: Bug Mechanism**
Category: Hardware workaround / Device ID addition. The format is
identical to dozens of surrounding entries in the same table.

**Step 2.4: Fix Quality**
The fix is a 2-line addition to a static table, following the exact same
pattern as all neighboring entries (e.g., 04ca:3804, 04ca:38e4).
Obviously correct. Zero regression risk — only affects the specific USB
VID/PID.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The neighboring entry `04ca:3804` was added in commit 59be4be82bd363
"Bluetooth: btusb: Add new VID/PID 04ca/3804 for MT7922" by Chris Lu
(2023-07-07). The MediaTek device ID section has been present and
actively extended since at least 2023.

**Step 3.2: Fixes tag** — No Fixes: tag (expected). Not applicable.

**Step 3.3: File History**
Recent btusb.c changes show a pattern of frequent device ID additions,
which are standard for this file. The device ID 04ca:3807 is confirmed
NOT yet in the 7.0 tree.

**Step 3.4: Author**
Dylan Eray appears to be an external contributor (Acer laptop user who
encountered the bug). The patch was reviewed and applied by the
Bluetooth subsystem maintainer Luiz Augusto von Dentz.

**Step 3.5: Dependencies**
None. This is a standalone 2-line addition to a static array. The
MediaTek MT7921/MT7922 support infrastructure (`btmtk.c`, `btmtk.h`,
`BTUSB_MEDIATEK` flag) has been present in the kernel since well before
v6.1.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Patch Discussion**
Found via web search. The patch went through v1 -> v2. The v1 was
submitted 2026-02-19 and reviewer Paul Menzel suggested adding USB
device info output to the commit message. The v2 incorporated that
feedback and received Paul Menzel's Reviewed-by. It was applied to
bluetooth/bluetooth-next as commit 79e029818394.

**Step 4.2: Reviewers**
- Paul Menzel (reviewer) — confirmed reviewed the diff and said "The
  diff looks good."
- Luiz Augusto von Dentz (Bluetooth maintainer) — applied the patch
- Sean Wang (MediaTek) was CC'd on the submission

**Step 4.3: Bug Report**
The author IS the bug reporter — they discovered the issue on their Acer
laptop. No syzbot or bugzilla, but a clear real-world user who can't use
Bluetooth.

**Step 4.4-4.5: Related Patches / Stable Discussion**
No explicit stable nomination found. This is typical for device ID
additions that are manually selected.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4:** The change only affects the `quirks_table[]` static
initializer in btusb.c. It adds a new USB device match entry. When USB
enumeration encounters this VID/PID, it will now set `BTUSB_MEDIATEK |
BTUSB_WIDEBAND_SPEECH` flags, causing the btmtk firmware loading path to
be used. The MT7921 support code is confirmed present in `btmtk.c`,
`btmtk.h`.

**Step 5.5:** There are ~70 existing `BTUSB_MEDIATEK` entries in this
file. This follows an identical pattern.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The MediaTek Bluetooth support (BTUSB_MEDIATEK, btmtk
firmware loading) exists in all active stable trees. The
`quirks_table[]` structure exists in all versions. The neighboring entry
04ca:3804 was added in 2023 and is in older stable trees.

**Step 6.2:** The patch will apply cleanly or with trivial context
adjustment. The table area may have slightly different surrounding
entries in older stable trees, but the insertion point (between
04ca:3804 and 04ca:38e4) should be present.

**Step 6.3:** No related fix already in stable for this specific device
ID.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** Bluetooth is an IMPORTANT subsystem — widely used on
laptops, IoT, and mobile devices. btusb.c is the primary USB Bluetooth
driver.

**Step 7.2:** btusb.c is actively maintained with frequent device ID
additions.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected: Users of Acer laptops with the Lite-On 04ca:3807
Bluetooth adapter.

**Step 8.2:** Trigger: Every boot. Bluetooth is completely non-
functional without this fix.

**Step 8.3:** Severity: HIGH — complete loss of Bluetooth functionality
on affected hardware. Not a crash, but total feature loss.

**Step 8.4:**
- **Benefit:** HIGH — makes Bluetooth work on Acer laptops with this
  chipset
- **Risk:** VERY LOW — 2-line addition to a static table, only affects
  devices with this specific VID/PID. Zero chance of regression to
  existing devices.

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR:**
- Classic device ID addition — explicitly listed as an exception that is
  "almost always YES" for stable
- 2-line change, zero regression risk
- Fixes complete Bluetooth failure on real hardware (Acer laptops)
- Reviewed by Paul Menzel, applied by Bluetooth maintainer
- MediaTek MT7921 support infrastructure exists in all active stable
  trees
- Follows identical pattern of dozens of existing entries
- Standalone — no dependencies whatsoever

**Evidence AGAINST:**
- None

**Stable Rules Checklist:**
1. Obviously correct? YES — identical to surrounding entries
2. Fixes a real bug? YES — Bluetooth completely broken without it
3. Important issue? YES — total hardware feature loss
4. Small and contained? YES — 2 lines in 1 file
5. No new features/APIs? CORRECT — just a device ID to an existing
   driver
6. Can apply to stable? YES — clean apply expected

**Exception Category:** This is a USB device ID addition to an existing
driver — an explicitly recognized exception for stable backporting.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Paul Menzel, SOB by author and
  maintainer
- [Phase 2] Diff analysis: 2-line addition to `quirks_table[]`, adds
  `USB_DEVICE(0x04ca, 0x3807)` with `BTUSB_MEDIATEK |
  BTUSB_WIDEBAND_SPEECH`
- [Phase 3] git blame: neighboring 04ca:3804 added in commit
  59be4be82bd363 (2023-07-07), MediaTek support long-standing
- [Phase 3] grep confirmed 04ca:3807 NOT yet in the 7.0 tree
- [Phase 3] Confirmed MT7921/MT7922 firmware support present in btmtk.h
  and btmtk.c
- [Phase 4] Found v1 and v2 submissions on spinics.net mirror; v1
  reviewed by Paul Menzel who requested USB device info, v2 incorporated
  feedback
- [Phase 4] Patch applied to bluetooth-next as commit 79e029818394 by
  Luiz Augusto von Dentz
- [Phase 5] BTUSB_MEDIATEK appears ~70 times in btusb.c — this is a
  well-established pattern
- [Phase 6] MediaTek support infrastructure confirmed present in all
  stable trees
- [Phase 8] Impact: Bluetooth completely non-functional without this fix
  on affected Acer laptops

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index aeba026bdb427..d07db8e3a79d5 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -707,6 +707,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x04ca, 0x3804), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x04ca, 0x3807), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x04ca, 0x38e4), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3568), .driver_info = BTUSB_MEDIATEK |
-- 
2.53.0

