Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8DD262FEC;
	Tue, 11 Nov 2025 01:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824401; cv=none; b=BCj7IymXHhk86DGcYn8LR1kDCQ58nUt7PlfGAYspI2ue28JlgcOP5Guguiq3KOqgMpvuHWhs/JD7Bvoth8v5QdwAN0D76MRhmLRqKcrZME7UDxkNlfwZwndT7KFxrInmV+tu7bZJyeBL4PwsCJRe1PsmYv62XoLor/S6MhCsDoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824401; c=relaxed/simple;
	bh=gM1JPEbfLUGAFMVHTafKTWOe+lG627OWzjvH8QKXaws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raNBF0luujEH3QcTd4bFWXsEZ6a/jDdPzmxNRUiiMiGl6hUBFqJ7Wgc4xRL4ihAfcuIWBLV0/sPjDSBr1nEuwESkRxwQDf5SZCVOEaUmsJGqYEHDR+0LErzYEe6egDwgYvUeXuRyUdAAmdDyRHJ8vbrvmHH+qHJoW4s2586/8+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMaUnyzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMaUnyzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CEBC19421;
	Tue, 11 Nov 2025 01:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824400;
	bh=gM1JPEbfLUGAFMVHTafKTWOe+lG627OWzjvH8QKXaws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMaUnyzMWahO9QnskHa97VyAnjiJfaDIwfr9dolQt3K/nNY9a+Hx4oROUYHiEpjK4
	 /JQWorKRCfH1CNDITjZW/r4OU/tFwc3MvdLhek4Ulwemh4lX1zPTg9TlDX1gWWgkUR
	 KljQezARxDApjzF458fhtxjKyAoKLvEOyTAbL/2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 436/565] Bluetooth: btusb: Check for unexpected bytes when defragmenting HCI frames
Date: Tue, 11 Nov 2025 09:44:52 +0900
Message-ID: <20251111004536.689019978@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c07d57eaca3bf..cf5b2a617c771 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -65,6 +65,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_INTEL_BROKEN_INITIAL_NCMD BIT(25)
 #define BTUSB_INTEL_NO_WBS_SUPPORT	BIT(26)
 #define BTUSB_ACTIONS_SEMI		BIT(27)
+#define BTUSB_BARROT			BIT(28)
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -796,6 +797,10 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Barrot Technology Bluetooth devices */
+	{ USB_DEVICE(0x33fa, 0x0010), .driver_info = BTUSB_BARROT },
+	{ USB_DEVICE(0x33fa, 0x0012), .driver_info = BTUSB_BARROT },
+
 	/* Actions Semiconductor ATS2851 based devices */
 	{ USB_DEVICE(0x10d7, 0xb012), .driver_info = BTUSB_ACTIONS_SEMI },
 
@@ -1193,6 +1198,18 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
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



