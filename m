Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2D3412276;
	Sat, 12 Sep 2026 11:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212211; cv=none; b=gwL2SHhvGNEPsCIP750Ug0Ssv8KlPl86AVYupPVD7jKgnZd7WuL2r1pTtFBGuiAVemvCUPQWolCa5lyNsVLo9E+wRjiNK1MD99HYq7XcTePspAY2VtaxvSlsz35JBzOikDH01pveVhbm0avkCJr6d8T8ngpvX/hLqOMpgJzIIY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212211; c=relaxed/simple;
	bh=I+yUjwizppOohYmniZVs5A6ARrp7rW2jUnbAhnj2hg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqEZxKma2Y3xLg/0F1XxgmgLEV0ttLVNGga83mIw1pVPaHTbu+kxhXhV1dbwaDIaMTHMTZ7BxOvWLRM1o07jog4dXyG+W1p+a/VbSUX7diHcaUub6W3R2A1EOyUha9c4k1tF9T8ITJL9iy9QppGvS/w8SMWrYbDWBfxshLOUxT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaDyVET4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaDyVET4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF5D1F000FF;
	Sat, 12 Sep 2026 11:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212209;
	bh=IB6Ur5gUUEIwSrXi9SAg4leEfX+TRNTk7jaZa748iTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaDyVET4zi9xkwzZzjTbep9gJgC81/Ltytq2QiosvFddDElduWVtFDv9OjnQy885U
	 5vhm1IF9DNwnBbgSs2NR6fBDJqdvWJ4ZebG7i0/W6j0u75LjqGPMq947F4HthMx/VZ
	 urUrnpHJt/wOkt5y8rFpSCcz5XGhy9gim3Id6obI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1391/1518] Bluetooth: btmtk: Fix short read errors in btmtk_usb_reg_read()
Date: Sat, 12 Sep 2026 08:59:20 +0200
Message-ID: <20260912065655.015088312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 0cc4b5649ae83deb8222100dba31aa0f100a19cd ]

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
Stable-dep-of: 59c3ee19ca88 ("Bluetooth: btmtk: Do not report success when subsys reset fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 4cfc1763d36e7..d7f81496edef9 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -815,27 +815,21 @@ static int btmtk_usb_uhw_reg_read(struct hci_dev *hdev, u32 reg, u32 *val)
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
@@ -962,7 +956,7 @@ int btmtk_usb_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 	}
 
 	err = btmtk_usb_id_get(hdev, 0x70010200, &val);
-	if (err < 0 || (!val && dev_id != 0x6639))
+	if (err || (!val && dev_id != 0x6639))
 		bt_dev_err(hdev, "Can't get device id, subsys reset fail.");
 
 	return err;
@@ -1324,24 +1318,24 @@ int btmtk_usb_setup(struct hci_dev *hdev)
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
-- 
2.53.0



