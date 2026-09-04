Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC4B3DAAC8;
	Fri,  4 Sep 2026 05:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499274; cv=none; b=MMJO/PfYCaLaF98dyWXTwMTKXI6YJC7DuqC3d0GmpHlZl+EdRmucMfrXgURUUs5SiRv4ZpR2LXtlQQ+GgkVDA21sU1qBzFrJYcovpZ7/AZDjEd0yVoer+GU32OnHymcAJK1uo721nAQktVnSy+ZpliFMTyjU+L16p0F4bep6gac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499274; c=relaxed/simple;
	bh=KwoY6989w6VCnMH3mla1f6d0F3KT7kPVflBsAMSmG8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n375pkwebGorN6tM8Izk2qIEbjO76/+nEWf/BsWfFgGgBknI7P+3UPWDvMFJphigPwDJ1UQCEc4+OLf610r68ym+QxCWuMlONcB+2Z9dpOoY3Pci9JUuudGyUhxDt7dorp+ZAQeRzmvqhY7yYtZjSNDyqGwlGmC4xKwNWDoBfkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Meg1h1rN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Meg1h1rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7891F00A3D;
	Fri,  4 Sep 2026 05:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499273;
	bh=q6oeecDozVr2VoDrdlvX9sNI0gseJm5ZJM6qv2QaKSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Meg1h1rNAyyhzRGPuLquV+/CkTy1f8lotK3q4Gof92S/aOH93JQsvsYnP7vxEs6SZ
	 aRDY4najGU6CtJgzjsLtMdS+3UIi/9S1M/7FdpjLcslxtnD6ubeJZjS6+buoli0yQ4
	 z9fMemYrNFmanM7/eYDxfdF6V7d2rNdI+qz593GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 316/713] Bluetooth: btusb: limit RTL8761B BROKEN_EXT_SCAN quirk to 0bda:a728
Date: Fri,  4 Sep 2026 06:54:44 +0200
Message-ID: <20260904045810.915580821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junjie Cao <junjie.cao@intel.com>

commit ca0583c24661749508a0979189c254388a685559 upstream.

Commit 5ead2063611a ("Bluetooth: btrtl: fix RTL8761B/BU broken LE
extended scan") set HCI_QUIRK_BROKEN_EXT_SCAN for every CHIP_ID_8761B
device to cure repeated 0x2042 failures on an 0bda:a728 dongle. The
brokenness is per-dongle, not per-chip: on a TP-Link UB500 (2357:0604,
RTL8761BU, fw 0xdfc6d922) extended scan works, and the legacy scan
path the quirk forces is what is broken -- LE Set Scan Enable (0x200c)
times out with -110 about 30 s after firmware load, btusb resets the
device, and the adapter re-enumerates in an endless loop (382 firmware
reloads in one boot). 7.1.8, which predates the stable backport, runs
clean on this unit; 7.1.9 loops.

Move the quirk from btrtl's chip-wide switch to a btusb device-table
flag on the USB id the original fix was verified against. Other 8761B
dongles return to their earlier long-standing behaviour.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2521504
Fixes: 5ead2063611a ("Bluetooth: btrtl: fix RTL8761B/BU broken LE extended scan")
Cc: stable@vger.kernel.org
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btrtl.c |   13 -------------
 drivers/bluetooth/btusb.c |    8 ++++++++
 2 files changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1343,19 +1343,6 @@ void btrtl_set_quirks(struct hci_dev *hd
 	if (!btrtl_dev->ic_info)
 		return;
 
-	switch (btrtl_dev->project_id) {
-	case CHIP_ID_8761B:
-		/* RTL8761B/BU reports HCI version 5.1 but does not support
-		 * the LE Extended Scan commands (Opcode 0x2042), causing
-		 * repeated -EBUSY failures when BlueZ attempts extended
-		 * scanning while a connection is active.
-		 */
-		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_EXT_SCAN);
-		break;
-	default:
-		break;
-	}
-
 	switch (btrtl_dev->ic_info->lmp_subver) {
 	case RTL_ROM_LMP_8703B:
 		/* 8723CS reports two pages for local ext features,
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -67,6 +67,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_INTEL_NO_WBS_SUPPORT	BIT(26)
 #define BTUSB_ACTIONS_SEMI		BIT(27)
 #define BTUSB_BARROT			BIT(28)
+#define BTUSB_BROKEN_EXT_SCAN		BIT(29)
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -615,6 +616,10 @@ static const struct usb_device_id quirks
 	{ USB_DEVICE(0x0489, 0xe130), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Realtek 8761BU Bluetooth devices */
+	{ USB_DEVICE(0x0bda, 0xa728), .driver_info = BTUSB_REALTEK |
+						     BTUSB_BROKEN_EXT_SCAN },
+
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
 	  .driver_info = BTUSB_REALTEK },
@@ -4372,6 +4377,9 @@ static int btusb_probe(struct usb_interf
 	if (id->driver_info & BTUSB_INVALID_LE_STATES)
 		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_LE_STATES);
 
+	if (id->driver_info & BTUSB_BROKEN_EXT_SCAN)
+		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_EXT_SCAN);
+
 	if (id->driver_info & BTUSB_DIGIANSWER) {
 		data->cmdreq_type = USB_TYPE_VENDOR;
 		hci_set_quirk(hdev, HCI_QUIRK_RESET_ON_CLOSE);


