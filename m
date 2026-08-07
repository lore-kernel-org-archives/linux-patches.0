Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3536136403D;
	Fri,  7 Aug 2026 14:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114110; cv=none; b=jyUD2hHaaPfaJpxTLCN2xMBM4r6iaIxwqBuegonxG1m4vvstihNKdJCGWVqR7895kofJ6sPj67vchqVVK+TVzQX9hHL07onh6TrPzB0AbSM2BpPuOBMfsqjw12/XObVzDeHgFfsxXu0fQwzuBvZBHoMWWOUj58AWdBD/b8WmzNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114110; c=relaxed/simple;
	bh=KwDyRqNsdOWlJ6HnOiO0zP7j794LqOqKByinAigUPhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRauAdPRrjuas6f7nA3pIx0Sy09yMRzTsQxXxWSN8ikUkXLawNmqE8neZDnTbqrIxChjZbyDT36A6H/VqJ+04VIpIzhVK5Ug6v9zn9+ttBeVKESae264LagdOBjZqJSzsJbbzJs3Y3CCK/yKKi2Kr721EVVv5Zon+iFhR3w9u5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qL1wAuTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qL1wAuTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344D91F000E9;
	Fri,  7 Aug 2026 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114107;
	bh=TqvMrUWuRPFtpVaZZM/KtLRDZSeL0ptLZ42TJb1TVBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qL1wAuTB4S/b4UJeIX0K7PItRx0Q5GQxz1u+3cdOOGbgxWI69nWIKdTnrHXXpoblc
	 vOZiD8GIRmP9Jl6WRR6BOKvle88Ch7qz1WTuj1F+nSESSjeK7aL0Md15AkZsH4VC2K
	 yXUdZ6dpLzDekdaruxKyWoDbhy5Gq3mqHQmmoeZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 147/337] Bluetooth: btusb: Fix short read errors in btusb_qca_send_vendor_req()
Date: Fri,  7 Aug 2026 16:35:50 +0200
Message-ID: <20260807143421.732538761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit cac43d360c928bc0cbbd18809632388265649761 upstream.

If btusb_qca_send_vendor_req() gets a "short" read from a device, it
will accidentally treat that as a "real" read and populate the returned
value with some unknown and probably totally invalid data.

Fix this logic error up by calling usb_control_msg_recv() which
guarantees a "full" read happens, and then simplify the error checking
for when btusb_qca_send_vendor_req() is called.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3304,28 +3304,16 @@ static u16 qca_extract_board_id(const st
 static int btusb_qca_send_vendor_req(struct usb_device *udev, u8 request,
 				     void *data, u16 size)
 {
-	int pipe, err;
-	u8 *buf;
-
-	buf = kmalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	int err;
 
 	/* Found some of USB hosts have IOT issues with ours so that we should
 	 * not wait until HCI layer is ready.
 	 */
-	pipe = usb_rcvctrlpipe(udev, 0);
-	err = usb_control_msg(udev, pipe, request, USB_TYPE_VENDOR | USB_DIR_IN,
-			      0, 0, buf, size, USB_CTRL_GET_TIMEOUT);
-	if (err < 0) {
+	err = usb_control_msg_recv(udev, 0, request, USB_TYPE_VENDOR | USB_DIR_IN,
+				   0, 0, data, size, USB_CTRL_GET_TIMEOUT,
+				   GFP_KERNEL);
+	if (err)
 		dev_err(&udev->dev, "Failed to access otp area (%d)", err);
-		goto done;
-	}
-
-	memcpy(data, buf, size);
-
-done:
-	kfree(buf);
 
 	return err;
 }
@@ -3519,7 +3507,7 @@ static bool btusb_qca_need_patch(struct
 	struct qca_version ver;
 
 	if (btusb_qca_send_vendor_req(udev, QCA_GET_TARGET_VERSION, &ver,
-				      sizeof(ver)) < 0)
+				      sizeof(ver)))
 		return false;
 	/* only low ROM versions need patches */
 	return !(le32_to_cpu(ver.rom_version) & ~0xffffU);
@@ -3537,7 +3525,7 @@ static int btusb_setup_qca(struct hci_de
 
 	err = btusb_qca_send_vendor_req(udev, QCA_GET_TARGET_VERSION, &ver,
 					sizeof(ver));
-	if (err < 0)
+	if (err)
 		return err;
 
 	ver_rom = le32_to_cpu(ver.rom_version);
@@ -3560,7 +3548,7 @@ static int btusb_setup_qca(struct hci_de
 
 	err = btusb_qca_send_vendor_req(udev, QCA_CHECK_STATUS, &status,
 					sizeof(status));
-	if (err < 0)
+	if (err)
 		return err;
 
 	if (!(status & QCA_PATCH_UPDATED)) {
@@ -3571,7 +3559,7 @@ static int btusb_setup_qca(struct hci_de
 
 	err = btusb_qca_send_vendor_req(udev, QCA_GET_TARGET_VERSION, &ver,
 					sizeof(ver));
-	if (err < 0)
+	if (err)
 		return err;
 
 	btdata->qca_dump.fw_version = le32_to_cpu(ver.patch_version);


