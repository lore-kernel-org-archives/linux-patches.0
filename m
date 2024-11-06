Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804811D173F;
	Wed,  6 Nov 2024 12:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895638; cv=none; b=U2sLt144KxcPbx/IoaTlwXEigMTIhpaisaD6z3MHGFXd5IV7HBBIfhzQpSiIZvgSkptOV9pCB7QJWkGBh6CZOc9I13L8Aleb2T9Kr9inqGKHYEnowgkUPPpM+tEThkvKD1NPFJD5QS6kl5rwdudLUxdSoqOSG4WRfB+vC5yD9dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895638; c=relaxed/simple;
	bh=M9sLvhATp9GosYqJURjSX9T5UjysBlqwB7f8Nnq9bOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rssIEhKpw+sopatIshpNPKi5e2oJWEZXCLwEcVDavzFu+AYXT4EJfCJvEXkoBG0gWrnVzR6QqsEci8+SKqZBDB5NtbXOdn8qXCZwMG8HlX00hT2Oufdwmasi5rY5ek0gHHGrJMUTQvAiVtIBwhZEXrTf/G0OX4Qprq5L0IsqPHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6z+Zr72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6z+Zr72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B1DC4CECD;
	Wed,  6 Nov 2024 12:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895638;
	bh=M9sLvhATp9GosYqJURjSX9T5UjysBlqwB7f8Nnq9bOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6z+Zr72Kka4q0n63RZpWEm22xpC0nnuWw3RE8cTf/INfEJ5nLExPnCir9QU1DbOc
	 xcn41QkjxRQwSAk+QV0vq3itCNgT9M0KU1CvAdM6fRbKy/vuw9XiMWxOWL964wwZiO
	 p9Ur6SXWweBHoGfmMR4esgRa+lYRQCLgl0wUo12Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 4.19 284/350] Bluetooth: btusb: Fix regression with fake CSR controllers 0a12:0001
Date: Wed,  6 Nov 2024 13:03:32 +0100
Message-ID: <20241106120327.862701847@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 2c1dda2acc4192d826e84008d963b528e24d12bc upstream.

Fake CSR controllers don't seem to handle short-transfer properly which
cause command to time out:

kernel: usb 1-1: new full-speed USB device number 19 using xhci_hcd
kernel: usb 1-1: New USB device found, idVendor=0a12, idProduct=0001, bcdDevice=88.91
kernel: usb 1-1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
kernel: usb 1-1: Product: BT DONGLE10
...
Bluetooth: hci1: Opcode 0x1004 failed: -110
kernel: Bluetooth: hci1: command 0x1004 tx timeout

According to USB Spec 2.0 Section 5.7.3 Interrupt Transfer Packet Size
Constraints a interrupt transfer is considered complete when the size is 0
(ZPL) or < wMaxPacketSize:

 'When an interrupt transfer involves more data than can fit in one
 data payload of the currently established maximum size, all data
 payloads are required to be maximum-sized except for the last data
 payload, which will contain the remaining data. An interrupt transfer
 is complete when the endpoint does one of the following:

 • Has transferred exactly the amount of data expected
 • Transfers a packet with a payload size less than wMaxPacketSize or
 transfers a zero-length packet'

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219365
Fixes: 7b05933340f4 ("Bluetooth: btusb: Fix not handling ZPL/short-transfer")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -743,10 +743,15 @@ static int btusb_submit_intr_urb(struct
 	if (!urb)
 		return -ENOMEM;
 
-	/* Use maximum HCI Event size so the USB stack handles
-	 * ZPL/short-transfer automatically.
-	 */
-	size = HCI_MAX_EVENT_SIZE;
+	if (le16_to_cpu(data->udev->descriptor.idVendor)  == 0x0a12 &&
+	    le16_to_cpu(data->udev->descriptor.idProduct) == 0x0001)
+		/* Fake CSR devices don't seem to support sort-transter */
+		size = le16_to_cpu(data->intr_ep->wMaxPacketSize);
+	else
+		/* Use maximum HCI Event size so the USB stack handles
+		 * ZPL/short-transfer automatically.
+		 */
+		size = HCI_MAX_EVENT_SIZE;
 
 	buf = kmalloc(size, mem_flags);
 	if (!buf) {


