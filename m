Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60F630E0F2;
	Fri,  7 Aug 2026 15:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117221; cv=none; b=MrUSVyt7BYHHw1ans4LbYASqIe8cgiQbV80pP5JU59d4RInBpg7SFMb7nq72bSI/0ceUbmB8hgFdliot/aEbU1mPyhzgqI0vrkdO5l/3wCFkrk7i67JOp4jaSRZQ5/mO1vrxJ/Upony4iGsnHY7BozTAhJrLdmsgAwkGsEfeUbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117221; c=relaxed/simple;
	bh=EvL/i37XwBnjFR+zkH8/+vmg98c8I5Bp1dOJcjVPRSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPtD8dw0kUrTBpuUC53MRrvCqoq4ebL+S3rjhFDMguNEZe1wjhCZU65XT6xvYslr2LdUMRVxdpB/zfFJa1rGcrJ3CSaSZLvh3W3OMgk8/tTUNSIlnMydH67LVvECDbG8L/C4wN2fCBqJ7b6KDx1NTxelJ5kyaXzizx+7pMmx7w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/3idATZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/3idATZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3452D1F000E9;
	Fri,  7 Aug 2026 15:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117219;
	bh=1GWRxJvnZZG3W0r4yABOH9DEqgClN1yRka07JVo0f2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/3idATZZr6xTPbeIrRoPtNOp9wF05rTpRmgZO/dofAMPUFIGZQg8o9qzFuRN0FdR
	 siLiIH83dLg7aS6K0/lnKPnnxXzsefKrHfVqpWjFyhaMnGfXo80FdyANZoAh14PByW
	 kFR9njI1pHTbrLriaCrGcJS0qxd+J5g/p2qWJpZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 241/438] Bluetooth: btmtk: Fix short read errors in btmtk_usb_reg_read()
Date: Fri,  7 Aug 2026 16:37:17 +0200
Message-ID: <20260807143433.139300432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 0cc4b5649ae83deb8222100dba31aa0f100a19cd upstream.

If btmtk_usb_reg_read() gets a "short" read from a device, it will
accidentally treat that as a "real" read and populate the returned value
with some unknown and probably totally invalid data.

Fix this logic error up by calling usb_control_msg_recv() which
guarantees a "full" read happens, and then simplify the error checking
for when btmtk_usb_reg_read() is called (it's really just
btmtk_usb_id_get() that calls btmtk_usb_reg_read(), so fix up those
return sites.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtk.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -827,27 +827,21 @@ static int btmtk_usb_uhw_reg_read(struct
 static int btmtk_usb_reg_read(struct hci_dev *hdev, u32 reg, u32 *val)
 {
 	struct btmtk_data *data = hci_get_priv(hdev);
-	int pipe, err, size = sizeof(u32);
-	void *buf;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	u8 buf[sizeof(u32)];
+	int err;
 
-	pipe = usb_rcvctrlpipe(data->udev, 0);
-	err = usb_control_msg(data->udev, pipe, 0x63,
-			      USB_TYPE_VENDOR | USB_DIR_IN,
-			      reg >> 16, reg & 0xffff,
-			      buf, size, USB_CTRL_GET_TIMEOUT);
+	*val = 0;
+	err = usb_control_msg_recv(data->udev, 0, 0x63,
+				   USB_TYPE_VENDOR | USB_DIR_IN,
+				   reg >> 16, reg & 0xffff,
+				   buf, sizeof(buf), USB_CTRL_GET_TIMEOUT,
+				   GFP_KERNEL);
 	if (err < 0)
-		goto err_free_buf;
+		return err;
 
 	*val = get_unaligned_le32(buf);
 
-err_free_buf:
-	kfree(buf);
-
-	return err;
+	return 0;
 }
 
 static int btmtk_usb_id_get(struct hci_dev *hdev, u32 reg, u32 *id)
@@ -974,7 +968,7 @@ int btmtk_usb_subsys_reset(struct hci_de
 	}
 
 	err = btmtk_usb_id_get(hdev, 0x70010200, &val);
-	if (err < 0 || (!val && dev_id != 0x6639))
+	if (err || (!val && dev_id != 0x6639))
 		bt_dev_err(hdev, "Can't get device id, subsys reset fail.");
 
 	return err;
@@ -1318,24 +1312,24 @@ int btmtk_usb_setup(struct hci_dev *hdev
 	calltime = ktime_get();
 
 	err = btmtk_usb_id_get(hdev, 0x80000008, &dev_id);
-	if (err < 0) {
+	if (err) {
 		bt_dev_err(hdev, "Failed to get device id (%d)", err);
 		return err;
 	}
 
 	if (!dev_id || dev_id != 0x7663) {
 		err = btmtk_usb_id_get(hdev, 0x70010200, &dev_id);
-		if (err < 0) {
+		if (err) {
 			bt_dev_err(hdev, "Failed to get device id (%d)", err);
 			return err;
 		}
 		err = btmtk_usb_id_get(hdev, 0x80021004, &fw_version);
-		if (err < 0) {
+		if (err) {
 			bt_dev_err(hdev, "Failed to get fw version (%d)", err);
 			return err;
 		}
 		err = btmtk_usb_id_get(hdev, 0x70010020, &fw_flavor);
-		if (err < 0) {
+		if (err) {
 			bt_dev_err(hdev, "Failed to get fw flavor (%d)", err);
 			return err;
 		}


