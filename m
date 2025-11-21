Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A6734CFA1;
	Fri, 21 Nov 2025 13:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732909; cv=none; b=CeRc/G+X4GSY1wC/QyWZpuO10xd199o0ESOhsCsEUpOgrqvLJScNpPAm/cVfN1zWw3EAlV+JBIwDqrIQT8cA3ENRJkM6JCG0z6vmswz1w/201RLSacScIM+GXXZJEy0mnt+xy+MnIdVHv2t04XDDIpZYRNgNFeVNritJ8N529kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732909; c=relaxed/simple;
	bh=qRGPM/uBGC9fSidxYyOSHHBGTn8LRCKMx3gjFy1hYBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXlx3QtfYpsrRNT8k9Mnbw99kFN5WefC60wRF6FQoQgzVc+cWmxY7E93/ANLYWttPk0DCOcTKiBGkzfWwqXjG1rAFI/VU3HMKYuF6nv8dek0mPJCuE2ckje9y740mCN4Q8tss6Utdso5xYNWZJhYoVL+XKyyjv5mczQmwfkOkGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuZOwfIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuZOwfIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B3EC4CEF1;
	Fri, 21 Nov 2025 13:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732909;
	bh=qRGPM/uBGC9fSidxYyOSHHBGTn8LRCKMx3gjFy1hYBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CuZOwfIiVD/UpLbjgImh+g36Qy2yoOvB/XTDYZYpFTwKdnwcv53OUSNp41vNHQeiF
	 1ShlJnoT++iUla2eakUfOtdCWJMF5D67g1bIbqhWoiYLaQuAEeX1CPufvnv0FP4uXB
	 IYVT3QDSniswmXbn2d4Ob8bdOVLYm4MJQ/bbrXKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/529] Bluetooth: btusb: Check for unexpected bytes when defragmenting HCI frames
Date: Fri, 21 Nov 2025 14:09:45 +0100
Message-ID: <20251121130241.206064495@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>

[ Upstream commit 7722d6fb54e428a8f657fccf422095a8d7e2d72c ]

Some Barrot based USB Bluetooth dongles erroneously send one extra
random byte for the HCI_OP_READ_LOCAL_EXT_FEATURES command. The
consequence of that is that the next HCI transfer is misaligned by one
byte causing undefined behavior. In most cases the response event for
the next command fails with random error code.

Since the HCI_OP_READ_LOCAL_EXT_FEATURES command is used during HCI
controller initialization, the initialization fails rendering the USB
dongle not usable.

> [59.464099] usb 1-1.3: new full-speed USB device number 11 using xhci_hcd
> [59.561617] usb 1-1.3: New USB device found, idVendor=33fa, idProduct=0012, bcdDevice=88.91
> [59.561642] usb 1-1.3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
> [59.561656] usb 1-1.3: Product: UGREEN BT6.0 Adapter
> [61.720116] Bluetooth: hci1: command 0x1005 tx timeout
> [61.720167] Bluetooth: hci1: Opcode 0x1005 failed: -110

This patch was tested with the 33fa:0012 device. The info from the
/sys/kernel/debug/usb/devices is shown below:

T:  Bus=01 Lev=02 Prnt=02 Port=02 Cnt=01 Dev#= 12 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=33fa ProdID=0012 Rev=88.91
S:  Product=UGREEN BT6.0 Adapter
C:* #Ifs= 2 Cfg#= 1 Atr=c0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Now the device is initialized properly:

> [43.329852] usb 1-1.4: new full-speed USB device number 4 using dwc_otg
> [43.446790] usb 1-1.4: New USB device found, idVendor=33fa, idProduct=0012, bcdDevice=88.91
> [43.446813] usb 1-1.4: New USB device strings: Mfr=0, Product=2, SerialNumber=0
> [43.446821] usb 1-1.4: Product: UGREEN BT6.0 Adapter
> [43.582024] Bluetooth: hci1: Unexpected continuation: 1 bytes
> [43.703025] Bluetooth: hci1: Unexpected continuation: 1 bytes
> [43.750141] Bluetooth: MGMT ver 1.23

Link: https://github.com/bluez/bluez/issues/1326
Signed-off-by: Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
Tested-by: Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4c21230aee460..23a9a221056a4 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -65,6 +65,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_INTEL_BROKEN_INITIAL_NCMD BIT(25)
 #define BTUSB_INTEL_NO_WBS_SUPPORT	BIT(26)
 #define BTUSB_ACTIONS_SEMI		BIT(27)
+#define BTUSB_BARROT			BIT(28)
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -770,6 +771,10 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Barrot Technology Bluetooth devices */
+	{ USB_DEVICE(0x33fa, 0x0010), .driver_info = BTUSB_BARROT },
+	{ USB_DEVICE(0x33fa, 0x0012), .driver_info = BTUSB_BARROT },
+
 	/* Actions Semiconductor ATS2851 based devices */
 	{ USB_DEVICE(0x10d7, 0xb012), .driver_info = BTUSB_ACTIONS_SEMI },
 
@@ -1167,6 +1172,18 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
 		}
 
 		if (!hci_skb_expect(skb)) {
+			/* Each chunk should correspond to at least 1 or more
+			 * events so if there are still bytes left that doesn't
+			 * constitute a new event this is likely a bug in the
+			 * controller.
+			 */
+			if (count && count < HCI_EVENT_HDR_SIZE) {
+				bt_dev_warn(data->hdev,
+					"Unexpected continuation: %d bytes",
+					count);
+				count = 0;
+			}
+
 			/* Complete frame */
 			btusb_recv_event(data, skb);
 			skb = NULL;
-- 
2.51.0



