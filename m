Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899862F8E8B;
	Fri,  7 Aug 2026 15:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115298; cv=none; b=uTntNe5WbkDmuYT3I4VBPIblfvKznd2N+6sAbggwRWZ/lhHhn2Hv3ipLVvsIkVWslcKItZIt12iVzmGOvUh55n5Jue/Cx0k3auJWOESSmkVYI+Ny6lQIbzanK4DUu05aFlcaNoap+KIgHo1Gt0y60messqwyjee4NfmNQIvc6sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115298; c=relaxed/simple;
	bh=E6a6Lzt9Vmtf/UHuieZC1RtW4/NYFbRk04qb3F0Yt3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruYzq25kaQ+P4jU4mznVN8zwQEZaYT8Bl2vIdEj0PB/Rv2jDTHg7OxrWuk4ZCOOkr+2sifBWsXVnZgSFPWWCkZTKoScjpvP8azh3tkTRAvpYqj3PwjXmAVMf41Ifd8n/CDCz6a0SMsgveVtVrhufks9NnZ0FepHWGc3pZqE7BxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsZiTVRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsZiTVRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55961F000E9;
	Fri,  7 Aug 2026 15:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115297;
	bh=JK+gx2NFWHKHBHC0vR8GIES93ioVoB/5X6l2rKHSYHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsZiTVRu2+THdZOqoVItZ8Flwx9kxAIXaYqnq3bb0JK+NYnvBpvfEhmo3HmH9UTvY
	 vYQiS43cxCw2EoQkr1M4SE2HQ8Mhs0wihhnCDZSa3WLslDiqX22rQOswl8lfx/e3ZK
	 KySuuUGUcU0rJYtKt7NRB0P2DZQnojcZXNwlzytE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 190/396] Bluetooth: btmtk: Fix short read errors in btmtk_usb_uhw_reg_read()
Date: Fri,  7 Aug 2026 16:35:50 +0200
Message-ID: <20260807143428.385424910@linuxfoundation.org>
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
 


