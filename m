Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275D12F5B;
	Sat, 25 Oct 2025 16:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409303; cv=none; b=R8Dl5L5D79N4XVw68MiQSmx3WTU4pCfZo2r6jNyYzmTx3pXbCTqhjd6zeX9yuuo9w0lmMGWpEzbDV+NnyqW9r/cEVE1pzik0VKQ9bXgJUz00Bu3a7It9Dz9d8uSmHNG6pDwYVjUOurBpo9bhxi3O7PgZLyzQpJdrSu7qNuFDgqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409303; c=relaxed/simple;
	bh=sdh77JmwGYvA4i8yRTUsYshH3R4xFHVoJysBOv0Dlmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3JmjLoTXLQPVZC+YxArKWbuZu+pRJ1tBHQY2n9X7SzgJxJEiQ11RGMNIqtuoYB5+fjuKdSYEDIuNaSwuqs90qRg0DZfi9x0H6kxsRtgt2HCkkxd0Kq0niA8l6bLmcrfgze5mMyyNXdsF1dgw4qU1fPRE/GO9BX0vcwuxVDijrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcTkjzP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcTkjzP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B5CC2BC9E;
	Sat, 25 Oct 2025 16:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409303;
	bh=sdh77JmwGYvA4i8yRTUsYshH3R4xFHVoJysBOv0Dlmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcTkjzP4xI9TyRiYygFmSyrcraAzvpSsku6QD0F2yxe0jUrwDyMy9shsoGPfUOwvN
	 Iu+VAK++wgy3Pw92WAPTV4PQQpgPZ6IRju/SWpeBPOt242SkOOz/NTj3bi3j6wfdWG
	 LZNi9VnWXva8/zGDHaTlc3h7H7LL+bZdxRtwovTJrr88FvKb/U6DgHRtSLyC5KOhES
	 xdJ6JODkXcJAHCB0d0CAGl0QjiBdl1yvA9T//B19jgLHNU5/JSO1b3Cn2PkyuPnWvJ
	 5KlyI64PW9rSEhkdImf2tIOnJSsoRlh4TbdDoDkqx4YES1osFZ1AgXP2VnZ1rRWK4X
	 SzBGlnoaJx3Cw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] Bluetooth: btusb: Check for unexpected bytes when defragmenting HCI frames
Date: Sat, 25 Oct 2025 11:58:21 -0400
Message-ID: <20251025160905.3857885-270-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- The failure mode is severe: certain Barrot-based USB dongles (UGREEN
  BT6.0, VID:PID 33fa:0012/0010) append a spurious byte after
  `HCI_OP_READ_LOCAL_EXT_FEATURES`, causing the very next event stream
  to be misaligned and the controller never completes init. The new
  guard in `drivers/bluetooth/btusb.c:1171-1221` drops any leftover
  single byte after a complete event and logs `"Unexpected
  continuation"`; without it, those devices stay unusable.
- The guard is tightly scoped and low-risk. `HCI_EVENT_HDR_SIZE` is only
  2 bytes, so `count < HCI_EVENT_HDR_SIZE` can only be true for a stray
  single byte; legitimate multi-event or fragmented transfers keep
  `hci_skb_expect()` non-zero and bypass this path. For well-behaved
  controllers nothing changes, while misbehaving hardware regains
  operation.
- Adding the `BTUSB_BARROT` flag and matching IDs
  (`drivers/bluetooth/btusb.c:69`, `drivers/bluetooth/btusb.c:820-822`)
  helps tag the affected devices; the flag is otherwise inert, so it
  does not perturb other platforms.
- The patch is self-contained to btusb, has no architectural fallout,
  and matches stable policy: it fixes a real user-visible regression
  with minimal code, no new features, and explicit testing on the
  affected hardware. Backporting will let current stable kernels drive
  these widely sold adapters again with negligible downside.

 drivers/bluetooth/btusb.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 30679a572095c..b231caa84757c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -66,6 +66,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_INTEL_BROKEN_INITIAL_NCMD BIT(25)
 #define BTUSB_INTEL_NO_WBS_SUPPORT	BIT(26)
 #define BTUSB_ACTIONS_SEMI		BIT(27)
+#define BTUSB_BARROT			BIT(28)
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -814,6 +815,10 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Barrot Technology Bluetooth devices */
+	{ USB_DEVICE(0x33fa, 0x0010), .driver_info = BTUSB_BARROT },
+	{ USB_DEVICE(0x33fa, 0x0012), .driver_info = BTUSB_BARROT },
+
 	/* Actions Semiconductor ATS2851 based devices */
 	{ USB_DEVICE(0x10d7, 0xb012), .driver_info = BTUSB_ACTIONS_SEMI },
 
@@ -1196,6 +1201,18 @@ static int btusb_recv_intr(struct btusb_data *data, void *buffer, int count)
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

