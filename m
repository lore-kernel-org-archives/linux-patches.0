Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC615415F16;
	Tue, 21 Jul 2026 20:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664750; cv=none; b=tetixFQCOi0NVtj1KC6hLYOxJ9Us6jpjrtNGbhmflhcehmoq1ve0l8pZTmWZ1TB6unwCoaB3EM77/IdVR2xmfi6Nz78zOYQEh2HXo+mv+QIXysEMJcGTAORCia67V8IrIvZvkfLC9NULMHZAqa2YWzCGyb0Wh1Y8xhkia3qWKYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664750; c=relaxed/simple;
	bh=XfMy2VeXkkz67a2DbpgOMAkClE1lZAo5umH9AN6/zt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9qDBiy2rvqdQnnzw4lF5Yloy5fkH27IFTRqZb1oXJ5Y4sD5xS/nuAz3O88jeOMsh1NbmtSRTdTwdse1gSBchV0KijdwC9KoYr4uetaIKS3as47F2ZC6OGop+niCbAznuiy1B/5Lvu3346KkEYK2ZDvU0+KDeaVaZMJ8l1bSQUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTsAcU8T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTsAcU8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3BE1F00A3A;
	Tue, 21 Jul 2026 20:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664748;
	bh=U0E+2x41YjVKCtBFWDQ/G5YlcvA38tU5sE1IPTvYzdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTsAcU8ThHfCiXGOLXxzPMHqkNbjfqb87kvCMkZNh2rx5kibsGefpnR6ekcbbUlMb
	 UjYd+a/TIzih94xtjdI36TiXi8TOfP3KbHR4Uf/DcMV//Y5mBunA5gYvpmUPkS6o+j
	 ImusX0nNg7/7Up7Iir6K7Kk6A+AnAKsOhFqcuqjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0010/1266] Bluetooth: btusb: mediatek: return error for failed reg access
Date: Tue, 21 Jul 2026 17:07:27 +0200
Message-ID: <20260721152442.022857575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 3dcb122b30643444352ff4b9aa16367dd24d7571 ]

Update the code to immediately return an error code if accessing a
related register fails. This ensures that our desired logic for
subsequent register operations is maintained and allows us to promptly
catch any unexpected errors.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 5c5e8c52e3ca ("Bluetooth: btmtk: move btusb_mtk_[setup, shutdown] to btmtk.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 114 ++++++++++++++++++++++++++++----------
 1 file changed, 84 insertions(+), 30 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 926ca7ecaf0cc2..a7aa4c1dacb295 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2809,47 +2809,98 @@ static int btusb_mtk_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 	int err;
 
 	if (dev_id == 0x7922) {
-		btusb_mtk_uhw_reg_read(data, MTK_BT_SUBSYS_RST, &val);
+		err = btusb_mtk_uhw_reg_read(data, MTK_BT_SUBSYS_RST, &val);
+		if (err < 0)
+			return err;
 		val |= 0x00002020;
-		btusb_mtk_uhw_reg_write(data, MTK_BT_SUBSYS_RST, val);
-		btusb_mtk_uhw_reg_write(data, MTK_EP_RST_OPT, 0x00010001);
-		btusb_mtk_uhw_reg_read(data, MTK_BT_SUBSYS_RST, &val);
+		err = btusb_mtk_uhw_reg_write(data, MTK_BT_SUBSYS_RST, val);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_write(data, MTK_EP_RST_OPT, 0x00010001);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_read(data, MTK_BT_SUBSYS_RST, &val);
+		if (err < 0)
+			return err;
 		val |= BIT(0);
-		btusb_mtk_uhw_reg_write(data, MTK_BT_SUBSYS_RST, val);
+		err = btusb_mtk_uhw_reg_write(data, MTK_BT_SUBSYS_RST, val);
+		if (err < 0)
+			return err;
 		msleep(100);
 	} else if (dev_id == 0x7925) {
-		btusb_mtk_uhw_reg_read(data, MTK_BT_RESET_REG_CONNV3, &val);
+		err = btusb_mtk_uhw_reg_read(data, MTK_BT_RESET_REG_CONNV3, &val);
+		if (err < 0)
+			return err;
 		val |= (1 << 5);
-		btusb_mtk_uhw_reg_write(data, MTK_BT_RESET_REG_CONNV3, val);
-		btusb_mtk_uhw_reg_read(data, MTK_BT_RESET_REG_CONNV3, &val);
+		err = btusb_mtk_uhw_reg_write(data, MTK_BT_RESET_REG_CONNV3, val);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_read(data, MTK_BT_RESET_REG_CONNV3, &val);
+		if (err < 0)
+			return err;
 		val &= 0xFFFF00FF;
+		if (err < 0)
+			return err;
 		val |= (1 << 13);
-		btusb_mtk_uhw_reg_write(data, MTK_BT_RESET_REG_CONNV3, val);
-		btusb_mtk_uhw_reg_write(data, MTK_EP_RST_OPT, 0x00010001);
-		btusb_mtk_uhw_reg_read(data, MTK_BT_RESET_REG_CONNV3, &val);
+		err = btusb_mtk_uhw_reg_write(data, MTK_BT_RESET_REG_CONNV3, val);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_write(data, MTK_EP_RST_OPT, 0x00010001);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_read(data, MTK_BT_RESET_REG_CONNV3, &val);
+		if (err < 0)
+			return err;
 		val |= (1 << 0);
-		btusb_mtk_uhw_reg_write(data, MTK_BT_RESET_REG_CONNV3, val);
-		btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT, 0x000000FF);
-		btusb_mtk_uhw_reg_read(data, MTK_UDMA_INT_STA_BT, &val);
-		btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT1, 0x000000FF);
-		btusb_mtk_uhw_reg_read(data, MTK_UDMA_INT_STA_BT1, &val);
+		err = btusb_mtk_uhw_reg_write(data, MTK_BT_RESET_REG_CONNV3, val);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT, 0x000000FF);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_read(data, MTK_UDMA_INT_STA_BT, &val);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT1, 0x000000FF);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_read(data, MTK_UDMA_INT_STA_BT1, &val);
+		if (err < 0)
+			return err;
 		msleep(100);
 	} else {
 		/* It's Device EndPoint Reset Option Register */
 		bt_dev_dbg(hdev, "Initiating reset mechanism via uhw");
-		btusb_mtk_uhw_reg_write(data, MTK_EP_RST_OPT, MTK_EP_RST_IN_OUT_OPT);
-		btusb_mtk_uhw_reg_read(data, MTK_BT_WDT_STATUS, &val);
-
+		err = btusb_mtk_uhw_reg_write(data, MTK_EP_RST_OPT, MTK_EP_RST_IN_OUT_OPT);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_read(data, MTK_BT_WDT_STATUS, &val);
+		if (err < 0)
+			return err;
 		/* Reset the bluetooth chip via USB interface. */
-		btusb_mtk_uhw_reg_write(data, MTK_BT_SUBSYS_RST, 1);
-		btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT, 0x000000FF);
-		btusb_mtk_uhw_reg_read(data, MTK_UDMA_INT_STA_BT, &val);
-		btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT1, 0x000000FF);
-		btusb_mtk_uhw_reg_read(data, MTK_UDMA_INT_STA_BT1, &val);
+		err = btusb_mtk_uhw_reg_write(data, MTK_BT_SUBSYS_RST, 1);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT, 0x000000FF);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_read(data, MTK_UDMA_INT_STA_BT, &val);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT1, 0x000000FF);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_read(data, MTK_UDMA_INT_STA_BT1, &val);
+		if (err < 0)
+			return err;
 		/* MT7921 need to delay 20ms between toggle reset bit */
 		msleep(20);
-		btusb_mtk_uhw_reg_write(data, MTK_BT_SUBSYS_RST, 0);
-		btusb_mtk_uhw_reg_read(data, MTK_BT_SUBSYS_RST, &val);
+		err = btusb_mtk_uhw_reg_write(data, MTK_BT_SUBSYS_RST, 0);
+		if (err < 0)
+			return err;
+		err = btusb_mtk_uhw_reg_read(data, MTK_BT_SUBSYS_RST, &val);
+		if (err < 0)
+			return err;
 	}
 
 	err = readx_poll_timeout(btusb_mtk_reset_done, hdev, val,
@@ -2857,11 +2908,14 @@ static int btusb_mtk_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 	if (err < 0)
 		bt_dev_err(hdev, "Reset timeout");
 
-	if (dev_id == 0x7922)
-		btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT, 0x000000FF);
+	if (dev_id == 0x7922) {
+		err = btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT, 0x000000FF);
+		if (err < 0)
+			return err;
+	}
 
-	btusb_mtk_id_get(data, 0x70010200, &val);
-	if (!val)
+	err = btusb_mtk_id_get(data, 0x70010200, &val);
+	if (err < 0 || !val)
 		bt_dev_err(hdev, "Can't get device id, subsys reset fail.");
 
 	return err;
-- 
2.53.0



