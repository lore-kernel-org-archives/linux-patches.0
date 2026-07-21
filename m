Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAFC472553;
	Tue, 21 Jul 2026 20:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664744; cv=none; b=rBKx7gbtVptF8tCPYtScNfrC6PnaKHs3UDNbQUiGv2u4bAO0nnKi2bxnH1i/gNoHRbLd2VMf6T7BHBCzDvpcQYd0v8f0+JjqEegtiuJX4SQo8b47bl8K9VNjkx+AivMPNaHF8O3/RderlXuNXWDV1vHi/ZbkTUsd0koCRzNb7mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664744; c=relaxed/simple;
	bh=8INbr9QcIYBKatsTyOkc1braqMy2ikJf/7DPK0veylU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4mrTSIJwZt/tHYvt8uG9Zb4fWb/R4GQIwdZefl3uBIWCaP2swF3dte1SstQF1WIAtYJuBwCfY6F9BncB5NZI2BVFIcXImyXFS+HnnxQZiA6Yx+hkIPZCMIZUC5b+wkh/SIRTj4pbGvebI+rJ2FqHWoXDge+MKCFBHVZogoPcPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYBxbMS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYBxbMS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38261F00A3D;
	Tue, 21 Jul 2026 20:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664743;
	bh=4sMm1AQ97qT3QNaSvzNtl+OYXAWSqpULJN6RlW8j9Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYBxbMS1CRLnt89KP1NE08xiUg+f3VfkaBbuPfvWV1O3q1s511Y4864xezdxGWR04
	 q/ocARuduWaUdPqN9oUATTio7WjL/nTsI8pnu3qozt3FsQLzwqB+CnAdZ2VoNKBjTT
	 DrnZdDoarIA/7b+ou4j3F1TK8bVcuvzMNNhaflMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Hao Qin <hao.qin@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0008/1266] Bluetooth: btusb: mediatek: add MT7922 subsystem reset
Date: Tue, 21 Jul 2026 17:07:25 +0200
Message-ID: <20260721152441.978857926@linuxfoundation.org>
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

From: Hao Qin <hao.qin@mediatek.com>

[ Upstream commit 064aee501012eaeeeb40a2acb991598e0a89fac9 ]

Add the support of MT7922 bluetooth subsystem reset that was called the
auto revert to self-recover from the fatal error in the controller like
the host encounters HCI cmd timeout or the controller crashes.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Hao Qin <hao.qin@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 5c5e8c52e3ca ("Bluetooth: btmtk: move btusb_mtk_[setup, shutdown] to btmtk.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c6b62437be2d5a..536b013ff7aedc 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2811,7 +2811,16 @@ static int btusb_mtk_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 	u32 val;
 	int err;
 
-	if (dev_id == 0x7925) {
+	if (dev_id == 0x7922) {
+		btusb_mtk_uhw_reg_read(data, MTK_BT_SUBSYS_RST, &val);
+		val |= 0x00002020;
+		btusb_mtk_uhw_reg_write(data, MTK_BT_SUBSYS_RST, val);
+		btusb_mtk_uhw_reg_write(data, MTK_EP_RST_OPT, 0x00010001);
+		btusb_mtk_uhw_reg_read(data, MTK_BT_SUBSYS_RST, &val);
+		val |= BIT(0);
+		btusb_mtk_uhw_reg_write(data, MTK_BT_SUBSYS_RST, val);
+		msleep(100);
+	} else if (dev_id == 0x7925) {
 		btusb_mtk_uhw_reg_read(data, MTK_BT_RESET_REG_CONNV3, &val);
 		val |= (1 << 5);
 		btusb_mtk_uhw_reg_write(data, MTK_BT_RESET_REG_CONNV3, val);
@@ -2851,6 +2860,9 @@ static int btusb_mtk_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 	if (err < 0)
 		bt_dev_err(hdev, "Reset timeout");
 
+	if (dev_id == 0x7922)
+		btusb_mtk_uhw_reg_write(data, MTK_UDMA_INT_STA_BT, 0x000000FF);
+
 	btusb_mtk_id_get(data, 0x70010200, &val);
 	if (!val)
 		bt_dev_err(hdev, "Can't get device id, subsys reset fail.");
-- 
2.53.0



