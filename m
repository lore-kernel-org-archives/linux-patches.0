Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64CC39CD16;
	Fri,  7 Aug 2026 14:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114113; cv=none; b=tTYWOO6lFLvdXPdNZktcN8CJr95jCWTLnlAIvMMaWQByZyKxanz/+bQzZwuU1dSuh8NHY0y6RIrvJfRQi29Bhb7nrE3oBXeIZV6ps3hOelkXQY4CCDom5g+n2kl5xZ/IfVCe7MXfIlA0ypQAnrJsd3LlSnF9gJiQHHPWwtsEn5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114113; c=relaxed/simple;
	bh=xa3BMFur92U6NdmTYWYNxTbCvuyLiwRQgD+H4XAgDGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7D1wIaz8Iy0WS/ojGivkvUGukADrDJ4ogwATpvfsC/C6JBGC1NIeZ0qL0wP/Mo3NtiRBb4T3qZar2THSJKphIUJNyYKxw4o9w87Up8HdCiG7VVNP/4QqZN4yr/AIJqabwbiaFrGb3tOhTaG+RdEQ5CR4kGx2b5pVwkIpH0krU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvsbDpT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvsbDpT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8F71F00A3A;
	Fri,  7 Aug 2026 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114110;
	bh=X/U58adZ/6iuSoueurdnEmXlmAFoRr2cAwm6jNBz3rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvsbDpT4S7GYvY5YrxRbs6ZTjvglyo6jVBnP0fsUmrBtB6sTMHTCNqiVpd9CFcn2S
	 rAM37rpNNJpGPCWRiTNaKr02Sjlf9Sd9tjxTTQd6uJhY+HrzI/dV5eftb+1SgyJDbA
	 8Hf9FWLzEEMDBlQ8AOBrVsBachVHv/9iBhJ3bbaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 148/337] Bluetooth: btmtk: Fix short read errors in btmtk_usb_uhw_reg_read()
Date: Fri,  7 Aug 2026 16:35:51 +0200
Message-ID: <20260807143421.755709006@linuxfoundation.org>
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

commit b186c18c4843dd58adc29443369bddc71cb626a3 upstream.

If btmtk_usb_uhw_reg_read() gets a "short" read from a device, it will
accidentally treat that as a "real" read and populate the returned value
with some unknown and probably totally invalid data.

Fix this logic error up by calling usb_control_msg_recv() which
guarantees a "full" read happens, and then simplify the error checking
for when btmtk_usb_uhw_reg_read() is called.

Note, one caller of btmtk_usb_uhw_reg_read() does not check the return
value, but as we pre-initialize the return value as 0, an incorrect read
will not do anything wrong.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtk.c |   50 ++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -763,30 +763,24 @@ static int btmtk_usb_uhw_reg_write(struc
 static int btmtk_usb_uhw_reg_read(struct hci_dev *hdev, u32 reg, u32 *val)
 {
 	struct btmtk_data *data = hci_get_priv(hdev);
-	int pipe, err;
-	void *buf;
-
-	buf = kzalloc(4, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	u8 buf[sizeof(u32)];
+	int err;
 
-	pipe = usb_rcvctrlpipe(data->udev, 0);
-	err = usb_control_msg(data->udev, pipe, 0x01,
-			      0xDE,
-			      reg >> 16, reg & 0xffff,
-			      buf, 4, USB_CTRL_GET_TIMEOUT);
-	if (err < 0) {
+	*val = 0;
+	err = usb_control_msg_recv(data->udev, 0, 0x01,
+				   0xDE,
+				   reg >> 16, reg & 0xffff,
+				   buf, sizeof(buf), USB_CTRL_GET_TIMEOUT,
+				   GFP_KERNEL);
+	if (err) {
 		bt_dev_err(hdev, "Failed to read uhw reg(%d)", err);
-		goto err_free_buf;
+		return err;
 	}
 
 	*val = get_unaligned_le32(buf);
 	bt_dev_dbg(hdev, "reg=%x, value=0x%08x", reg, *val);
 
-err_free_buf:
-	kfree(buf);
-
-	return err;
+	return 0;
 }
 
 static int btmtk_usb_reg_read(struct hci_dev *hdev, u32 reg, u32 *val)
@@ -836,7 +830,7 @@ int btmtk_usb_subsys_reset(struct hci_de
 
 	if (dev_id == 0x7922) {
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_BT_SUBSYS_RST, &val);
-		if (err < 0)
+		if (err)
 			return err;
 		val |= 0x00002020;
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_BT_SUBSYS_RST, val);
@@ -846,7 +840,7 @@ int btmtk_usb_subsys_reset(struct hci_de
 		if (err < 0)
 			return err;
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_BT_SUBSYS_RST, &val);
-		if (err < 0)
+		if (err)
 			return err;
 		val |= BIT(0);
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_BT_SUBSYS_RST, val);
@@ -855,14 +849,14 @@ int btmtk_usb_subsys_reset(struct hci_de
 		msleep(100);
 	} else if (dev_id == 0x7925) {
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_BT_RESET_REG_CONNV3, &val);
-		if (err < 0)
+		if (err)
 			return err;
 		val |= (1 << 5);
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_BT_RESET_REG_CONNV3, val);
 		if (err < 0)
 			return err;
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_BT_RESET_REG_CONNV3, &val);
-		if (err < 0)
+		if (err)
 			return err;
 		val &= 0xFFFF00FF;
 		val |= (1 << 13);
@@ -873,7 +867,7 @@ int btmtk_usb_subsys_reset(struct hci_de
 		if (err < 0)
 			return err;
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_BT_RESET_REG_CONNV3, &val);
-		if (err < 0)
+		if (err)
 			return err;
 		val |= (1 << 0);
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_BT_RESET_REG_CONNV3, val);
@@ -883,13 +877,13 @@ int btmtk_usb_subsys_reset(struct hci_de
 		if (err < 0)
 			return err;
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_UDMA_INT_STA_BT, &val);
-		if (err < 0)
+		if (err)
 			return err;
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_UDMA_INT_STA_BT1, 0x000000FF);
 		if (err < 0)
 			return err;
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_UDMA_INT_STA_BT1, &val);
-		if (err < 0)
+		if (err)
 			return err;
 		msleep(100);
 	} else {
@@ -899,7 +893,7 @@ int btmtk_usb_subsys_reset(struct hci_de
 		if (err < 0)
 			return err;
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_BT_WDT_STATUS, &val);
-		if (err < 0)
+		if (err)
 			return err;
 		/* Reset the bluetooth chip via USB interface. */
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_BT_SUBSYS_RST, 1);
@@ -909,13 +903,13 @@ int btmtk_usb_subsys_reset(struct hci_de
 		if (err < 0)
 			return err;
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_UDMA_INT_STA_BT, &val);
-		if (err < 0)
+		if (err)
 			return err;
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_UDMA_INT_STA_BT1, 0x000000FF);
 		if (err < 0)
 			return err;
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_UDMA_INT_STA_BT1, &val);
-		if (err < 0)
+		if (err)
 			return err;
 		/* MT7921 need to delay 20ms between toggle reset bit */
 		msleep(20);
@@ -923,7 +917,7 @@ int btmtk_usb_subsys_reset(struct hci_de
 		if (err < 0)
 			return err;
 		err = btmtk_usb_uhw_reg_read(hdev, MTK_BT_SUBSYS_RST, &val);
-		if (err < 0)
+		if (err)
 			return err;
 	}
 


