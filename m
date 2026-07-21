Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668B940803D;
	Tue, 21 Jul 2026 20:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664755; cv=none; b=ZkVSqOwOVAe75K/Y67EZrxV11QfA/HMzxhIrSoMCgWv35zfjCe4+hDI52XUB+6r76TU4akcEzpswCds2C7dsNqrHFD3t3G0iteP5C+Qumm1w6qAXdr5Opc3o+8JylejBnqvmLYVqjgd7E+bk41DZsMQVSqYJzF5eH8Vse6mo4rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664755; c=relaxed/simple;
	bh=lMpxLqYkhDE9nkoLnq9nfU1p+MeKOuoCN8Mo5yQW6xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/sNM1n0DHQWXpN5HW62ugtEdrkJYSyjabZP0aVkeJBMiC3x8EBr39w9+JRuO8GB6NjjQYPJwygaBsJLKX6Jshu5bfmDEhmDMWp8rGXKGc6Yjwe4PElt6PzwsBUuG+01ZESVcbJpNcjCDoA4DFmQK1vTNsfo1WIxfICm1lsj/kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsJI07jF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsJI07jF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0651F00AC4;
	Tue, 21 Jul 2026 20:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664754;
	bh=djKwzjaOTECfTiTUH+9j/qtcNlpxUUmXexpkXavGmq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VsJI07jFz9hXpbAe0A+1GZH4xMdT8surqWRMx7h2liMT1qPa8/hOOqiRnmpje3xhx
	 ZMfNzm++Vh5/qvc1M2ODxYjkz4vNQHq/O+VLIPSvjaROaQd6YDcWD62LRpM9eESp9u
	 zbx/lmFIQWSZ/6SEosH50tbkRTQbodthSOJZfp7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0012/1266] Bluetooth: btmtk: Fix failed to send func ctrl for MediaTek devices.
Date: Tue, 21 Jul 2026 17:07:29 +0200
Message-ID: <20260721152442.066942461@linuxfoundation.org>
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

[ Upstream commit 67dba2c28fe0af7e25ea1aeade677162ed05310a ]

Use usb_autopm_get_interface() and usb_autopm_put_interface()
in btmtk_usb_shutdown(), it could send func ctrl after enabling
autosuspend.

Bluetooth: btmtk_usb_hci_wmt_sync() hci0: Execution of wmt command
           timed out
Bluetooth: btmtk_usb_shutdown() hci0: Failed to send wmt func ctrl
           (-110)

Fixes: 5c5e8c52e3ca ("Bluetooth: btmtk: move btusb_mtk_[setup, shutdown] to btmtk.c")
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c  | 7 +++++++
 net/bluetooth/rfcomm/tty.c | 4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 8fd923de47c1f3..29d4a04ea0d46a 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1140,10 +1140,15 @@ EXPORT_SYMBOL_GPL(btmtk_usb_setup);
 
 int btmtk_usb_shutdown(struct hci_dev *hdev)
 {
+	struct btmtk_data *data = hci_get_priv(hdev);
 	struct btmtk_hci_wmt_params wmt_params;
 	u8 param = 0;
 	int err;
 
+	err = usb_autopm_get_interface(data->intf);
+	if (err < 0)
+		return err;
+
 	/* Disable the device */
 	wmt_params.op = BTMTK_WMT_FUNC_CTRL;
 	wmt_params.flag = 0;
@@ -1154,9 +1159,11 @@ int btmtk_usb_shutdown(struct hci_dev *hdev)
 	err = btmtk_usb_hci_wmt_sync(hdev, &wmt_params);
 	if (err < 0) {
 		bt_dev_err(hdev, "Failed to send wmt func ctrl (%d)", err);
+		usb_autopm_put_interface(data->intf);
 		return err;
 	}
 
+	usb_autopm_put_interface(data->intf);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(btmtk_usb_shutdown);
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 912e37cb8310c6..389d7b47ad6132 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -201,14 +201,14 @@ static ssize_t address_show(struct device *tty_dev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct rfcomm_dev *dev = dev_get_drvdata(tty_dev);
-	return sprintf(buf, "%pMR\n", &dev->dst);
+	return sysfs_emit(buf, "%pMR\n", &dev->dst);
 }
 
 static ssize_t channel_show(struct device *tty_dev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct rfcomm_dev *dev = dev_get_drvdata(tty_dev);
-	return sprintf(buf, "%d\n", dev->channel);
+	return sysfs_emit(buf, "%d\n", dev->channel);
 }
 
 static DEVICE_ATTR_RO(address);
-- 
2.53.0



