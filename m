Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D365D471421;
	Tue, 21 Jul 2026 20:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664742; cv=none; b=ELLJGswpEOyqFVA4m0kVer6nTxISnsiIXOsHI8NSEkocriIQ4wvsEFlNDBhvPXceyCXk28FO4LKwfOHT/77AwmTJru6c3MYLXuOw2rixQUDC36Rh1i3tD9Dh1pTaz4nxXY+DqgkrQgy7dwWpRuF8mYSO0XQzNP3QkKZDdWnBHag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664742; c=relaxed/simple;
	bh=V64t55gOvqL5tB9VJ8C4qtYn7etjazHSfnxBECaag0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K772X/lRAR2Tw7hNd0eUhxMbm04455s4KDvT6Lz3QK8S2ADqDbPbzURT6TxCZvshdasdA41XFjkJQB65qZ0LOdyjS7gKEAGbtTuv5Z4hDuTbLTyOJbrkL4YFcztR6ONQI7HyGZ7FJMb3JXuJQDethahdPRLZXDajEJsbLV628NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3NSV0Z/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3NSV0Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4459D1F000E9;
	Tue, 21 Jul 2026 20:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664740;
	bh=ZgeBk8QZypqski2LjAmWbnD8iKUODY5EhqDS2CrHVwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3NSV0Z/JjS+EP78JLvIfP3+e7pwAq6LgwEZTdEZtHwdZVVbperG7qO6PFPVL2Csk
	 UMZo79vDn+z6DdC71c2yrctKrdBtXuSoRuOh3pOO6eqBNnpSm//BUdHS5AWZ5xPMdk
	 BaCnMpRMw8O94dy8jRYvEPoL9w6pIYmfNYkeqejA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Chris Lu <chris.lu@mediatek.com>,
	Hao Qin <hao.qin@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0007/1266] Bluetooth: btusb: mediatek: reset the controller before downloading the fw
Date: Tue, 21 Jul 2026 17:07:24 +0200
Message-ID: <20260721152441.956863996@linuxfoundation.org>
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

[ Upstream commit ccfc8948d7e4d93cab341a99774b24586717d89a ]

Reset the controller before downloading the firmware to improve its
reliability. This includes situations like cold or warm reboots, ensuring
the controller is in its initial state before starting the firmware
download.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Co-developed-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Hao Qin <hao.qin@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 5c5e8c52e3ca ("Bluetooth: btmtk: move btusb_mtk_[setup, shutdown] to btmtk.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 048929e336cf64..c6b62437be2d5a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2940,6 +2940,13 @@ static int btusb_mtk_setup(struct hci_dev *hdev)
 	case 0x7922:
 	case 0x7961:
 	case 0x7925:
+		/* Reset the device to ensure it's in the initial state before
+		 * downloading the firmware to ensure.
+		 */
+
+		if (!test_bit(BTUSB_FIRMWARE_LOADED, &data->flags))
+			btusb_mtk_subsys_reset(hdev, dev_id);
+
 		btmtk_fw_get_filename(fw_bin_name, sizeof(fw_bin_name), dev_id,
 				      fw_version, 0);
 
@@ -2947,9 +2954,12 @@ static int btusb_mtk_setup(struct hci_dev *hdev)
 						btmtk_usb_hci_wmt_sync);
 		if (err < 0) {
 			bt_dev_err(hdev, "Failed to set up firmware (%d)", err);
+			clear_bit(BTUSB_FIRMWARE_LOADED, &data->flags);
 			return err;
 		}
 
+		set_bit(BTUSB_FIRMWARE_LOADED, &data->flags);
+
 		/* It's Device EndPoint Reset Option Register */
 		btusb_mtk_uhw_reg_write(data, MTK_EP_RST_OPT, MTK_EP_RST_IN_OUT_OPT);
 
-- 
2.53.0



