Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944AE376BF4;
	Fri,  4 Sep 2026 05:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500916; cv=none; b=fmef5ai6HSkQj3+ztUnRiIGsvKNkwJ+AHAzo42g0glaSQGCHUGKwq0xqX6JzRAleyYRrdgaAe5yA2wJm0/2OsjarLyDJ6fQqzUT8nTdrZfSCcy5uKcl44pFBaaz+DRCAsXrlhEu0o+4UXxPgF+3KjZwWqRw7l47hS66cuEuAm8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500916; c=relaxed/simple;
	bh=gg9fVHOk0olrCCFXiBGCEsjqNdS/ogyWB8Dqj0ZqTgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9DCRgL4KW5AcgdJG/jc15WJ/GOwWBb8hPmaalSOsuXFfSz2Crdk6nvLMrC27mvxJCHDIz1tS1YtJHpdScjP6wsuswuy8aRTybPOxtgcZJpGDvTSa+bHkGE40A8lmiib1idVTDz+mRPj8fFABZqot3yXe0+Mr+ER6K62yURuNAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ms65AV7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ms65AV7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB7B1F00A3D;
	Fri,  4 Sep 2026 05:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500915;
	bh=49DYo6NdytNCgg63BWl896QVmNJenHtZra9uJ8OXtxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ms65AV7KbC3GN6MyzgnIZ4Y9eCn6Fn48tFPOFATwKcpMUoRC6VQsU2lS+F+PL53T+
	 MNYDzyPJU4XE4nFMFbqdZTqwX9M4muJaYSKEs0j1Jb+sQUpr200/ld7rgIr6latSvL
	 bOU0LUxF3dk5gcsd5Z+7uk/kmmNF5XnY4fO/vPEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 226/552] Bluetooth: btusb: limit RTL8761B BROKEN_EXT_SCAN quirk to 0bda:a728
Date: Fri,  4 Sep 2026 06:56:23 +0200
Message-ID: <20260904045754.616308260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1331,19 +1331,6 @@ void btrtl_set_quirks(struct hci_dev *hd
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
@@ -608,6 +609,10 @@ static const struct usb_device_id quirks
 	{ USB_DEVICE(0x0489, 0xe130), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Realtek 8761BU Bluetooth devices */
+	{ USB_DEVICE(0x0bda, 0xa728), .driver_info = BTUSB_REALTEK |
+						     BTUSB_BROKEN_EXT_SCAN },
+
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
 	  .driver_info = BTUSB_REALTEK },
@@ -4325,6 +4330,9 @@ static int btusb_probe(struct usb_interf
 	if (id->driver_info & BTUSB_INVALID_LE_STATES)
 		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_LE_STATES);
 
+	if (id->driver_info & BTUSB_BROKEN_EXT_SCAN)
+		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_EXT_SCAN);
+
 	if (id->driver_info & BTUSB_DIGIANSWER) {
 		data->cmdreq_type = USB_TYPE_VENDOR;
 		hci_set_quirk(hdev, HCI_QUIRK_RESET_ON_CLOSE);


