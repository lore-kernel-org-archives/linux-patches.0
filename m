Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD171A9B46;
	Thu, 28 May 2026 20:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001563; cv=none; b=AkzOx2PWz9aqwRdfQeHyrilWtHCQElrFtae/F1eqiOOeL+3dk/IIMUKtbLxskmnQk+dytmvIZD3iJN7RQuBkPiQTloiY977lQxHJkUsOr23U87A/yz770NI//q9iGfinjC4FqneGQpIvf35gjGnnCJ/Zb3va9yRxnbfj6cq32D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001563; c=relaxed/simple;
	bh=v9Khwh4zpeg6ukHrpqrcEKRbocS9DKcsMTD9IaXkyQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spuvpkEjagVq9ginRSaWVRNpOA8W87OEojIv5xX+0+WVhFh/VXND8jy03+UL9YzmLl5ugfPJVe3jzhM/HE69ELDwpq42uvK31Qbu39RQa2QoNCaSC/miDQzdFb4K4fBjtttRDepXZgvN3NL5XwEjB6LFrbWEEfT9Om8WYb6cxOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NggKR1KM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NggKR1KM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD021F000E9;
	Thu, 28 May 2026 20:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001562;
	bh=Kj1p+hWSmH7jT/I04TdOFmGZ9Pp0RBmKglThD3/3hRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NggKR1KM2zTCXsaImDsyLO+iw2V2JD1iOfJS1ZhioygkI9IgA1f0bUSaW/cjkLh0d
	 /jtjka0LfTY4e6NmAWKPCx5VcFRzahmx2K6OISNVp1bR0+Wb4s3N+cHTwgp5Nqmscq
	 K+hl3WZHxAtegtpRmbxrsgOn/qkq9w+tGB2T1VIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Hao Qin <hao.qin@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/186] Bluetooth: btusb: mediatek: refactor the function btusb_mtk_reset
Date: Thu, 28 May 2026 21:50:52 +0200
Message-ID: <20260528194933.616944688@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Hao Qin <hao.qin@mediatek.com>

[ Upstream commit 4c0c28f2bbec0c51395fd1f13c697da67483964b ]

Extract the function btusb_mtk_subsys_reset from the btusb_mtk_reset
for the future handling of resetting bluetooth controller without
the USB reset.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Hao Qin <hao.qin@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: dd1dda6b8d6e ("Bluetooth: btmtk: fix urb->setup_packet leak in error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 45 +++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c51523d780e65..04eaf7abf75c4 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3081,28 +3081,13 @@ static u32 btusb_mtk_reset_done(struct hci_dev *hdev)
 	return val & MTK_BT_RST_DONE;
 }
 
-static int btusb_mtk_reset(struct hci_dev *hdev, void *rst_data)
+static int btusb_mtk_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 {
 	struct btusb_data *data = hci_get_drvdata(hdev);
-	struct btmediatek_data *mediatek;
 	u32 val;
 	int err;
 
-	/* It's MediaTek specific bluetooth reset mechanism via USB */
-	if (test_and_set_bit(BTUSB_HW_RESET_ACTIVE, &data->flags)) {
-		bt_dev_err(hdev, "last reset failed? Not resetting again");
-		return -EBUSY;
-	}
-
-	err = usb_autopm_get_interface(data->intf);
-	if (err < 0)
-		return err;
-
-	btusb_stop_traffic(data);
-	usb_kill_anchored_urbs(&data->tx_anchor);
-	mediatek = hci_get_priv(hdev);
-
-	if (mediatek->dev_id == 0x7925) {
+	if (dev_id == 0x7925) {
 		btusb_mtk_uhw_reg_read(data, MTK_BT_RESET_REG_CONNV3, &val);
 		val |= (1 << 5);
 		btusb_mtk_uhw_reg_write(data, MTK_BT_RESET_REG_CONNV3, val);
@@ -3146,8 +3131,32 @@ static int btusb_mtk_reset(struct hci_dev *hdev, void *rst_data)
 	if (!val)
 		bt_dev_err(hdev, "Can't get device id, subsys reset fail.");
 
-	usb_queue_reset_device(data->intf);
+	return err;
+}
 
+static int btusb_mtk_reset(struct hci_dev *hdev, void *rst_data)
+{
+	struct btusb_data *data = hci_get_drvdata(hdev);
+	struct btmediatek_data *mtk_data;
+	int err;
+
+	/* It's MediaTek specific bluetooth reset mechanism via USB */
+	if (test_and_set_bit(BTUSB_HW_RESET_ACTIVE, &data->flags)) {
+		bt_dev_err(hdev, "last reset failed? Not resetting again");
+		return -EBUSY;
+	}
+
+	err = usb_autopm_get_interface(data->intf);
+	if (err < 0)
+		return err;
+
+	btusb_stop_traffic(data);
+	usb_kill_anchored_urbs(&data->tx_anchor);
+	mtk_data = hci_get_priv(hdev);
+
+	err = btusb_mtk_subsys_reset(hdev, mtk_data->dev_id);
+
+	usb_queue_reset_device(data->intf);
 	clear_bit(BTUSB_HW_RESET_ACTIVE, &data->flags);
 
 	return err;
-- 
2.53.0



