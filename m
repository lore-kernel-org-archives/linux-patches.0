Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A98E42882B;
	Fri,  7 Aug 2026 15:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115267; cv=none; b=CdccV3/19eqKXRq3LBlADOIF4pl0L3hqdsHS28SEqtZMBzzFwQs00B+c6GZ7v+1y7ZRUEbIMpuw45+mRve0kASw1dXaj5bzmJq8TLugQ6/8KFa+k7Mw4WTqhLnRerpauDBf/JRptVEdsUe4wiM00Zk/POIvWlwT+93cZVqc89Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115267; c=relaxed/simple;
	bh=NIQyDkihCLwcWC4pEoig5edlR9pDKmwbDmSa585njCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3cOb2xPmlv8IpbqKoC6sOGC0UgAjLRN3ysq/7WE1YUM3Co1qDdZfm5pSx+bhXypWVzkxQ6fKuNnsfHTM9XYjlt9WA9Jr1+RlvtTETepK9tDtk55QfnVrdYu0OD/GY8fcj7SmuhkGqNexwbMnFXL65VVAj6GezNVnG0zzOxJaAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9RMfQgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9RMfQgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857831F000E9;
	Fri,  7 Aug 2026 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115266;
	bh=B8ae9RPtkQvGqepm9rlNxoZWmXDLveFJ/KsefTLnFxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r9RMfQgTnAhxtCLJKZhtsNKXUtUIM4lAfNtiw4Q6KUbRvG9D5+UVZJzgayBt8JCwV
	 rNr05GxbbDVHQXSwtDNAsXZBaVusMke/hYP6uPwUSs0EnssrsVzhe+2HtGYf03Z3MY
	 HNYnPbNtJKzzlJUQa4D2gPBa5VaNRXYM/6g9eAq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 189/396] Bluetooth: btusb: Fix short read errors in btusb_qca_send_vendor_req()
Date: Fri,  7 Aug 2026 16:35:49 +0200
Message-ID: <20260807143428.364082828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -3345,28 +3345,16 @@ static const char *qca_get_fw_subdirecto
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
@@ -3573,7 +3561,7 @@ static bool btusb_qca_need_patch(struct
 	struct qca_version ver;
 
 	if (btusb_qca_send_vendor_req(udev, QCA_GET_TARGET_VERSION, &ver,
-				      sizeof(ver)) < 0)
+				      sizeof(ver)))
 		return false;
 	/* only low ROM versions need patches */
 	return !(le32_to_cpu(ver.rom_version) & ~0xffffU);
@@ -3591,7 +3579,7 @@ static int btusb_setup_qca(struct hci_de
 
 	err = btusb_qca_send_vendor_req(udev, QCA_GET_TARGET_VERSION, &ver,
 					sizeof(ver));
-	if (err < 0)
+	if (err)
 		return err;
 
 	ver_rom = le32_to_cpu(ver.rom_version);
@@ -3614,7 +3602,7 @@ static int btusb_setup_qca(struct hci_de
 
 	err = btusb_qca_send_vendor_req(udev, QCA_CHECK_STATUS, &status,
 					sizeof(status));
-	if (err < 0)
+	if (err)
 		return err;
 
 	if (!(status & QCA_PATCH_UPDATED)) {
@@ -3625,7 +3613,7 @@ static int btusb_setup_qca(struct hci_de
 
 	err = btusb_qca_send_vendor_req(udev, QCA_GET_TARGET_VERSION, &ver,
 					sizeof(ver));
-	if (err < 0)
+	if (err)
 		return err;
 
 	btdata->qca_dump.fw_version = le32_to_cpu(ver.patch_version);


