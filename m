Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D971DB147;
	Wed, 15 Jan 2025 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937964; cv=none; b=dILMmZBDRCp9m6GhfQ9JeBQ/rFhRiRRC2BsxrafjG3/5Ha4q/RrpZhmSowWDWUlhwdbpdK004mS2V8XrZerwBIf6gydflXe79EqeNVTXH2ZlrmbIO2NZMbgBZ/d2EDmEyNgrhNDevBAeJ4j8a79zkrPgY7W/F+QRXGPxbXSpQwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937964; c=relaxed/simple;
	bh=FxIGlcJQ32DwdCpZEaFjZkIq7A+FnJPKytLB8Fdhb5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntVRpRjeAI+Wsr0oln2Vfbb8+3qRR/MICZYVpvty22SVSarMAhYU7ByQ2v81g15UPzkf9cXbYOF3G1BurZifUrLxyhiY56aVYxrYpywUREqATP4RFwdn/hoQVQLN/teId22b4lXoE1FOvpi9MYesa+Hf50s2cCI6kjQmyvUdG08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDM4GA9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDM4GA9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C70C4CEDF;
	Wed, 15 Jan 2025 10:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937964;
	bh=FxIGlcJQ32DwdCpZEaFjZkIq7A+FnJPKytLB8Fdhb5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDM4GA9AXYRPX3XG91eJaJWp5tWHcoDC7UThvY3K7MVOo4/yxv3yCYaM5dqj1wWnS
	 r+1xRTuZJOyvySaer0ANB+s5VW37pI82cqVApPNeUQP4WRDgJdah4g3rDhsf3d+ZFz
	 5gDqTNHgig+39C3is65rCLHG72xIxktWLlyxmktU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/189] Bluetooth: btmtk: Fix failed to send func ctrl for MediaTek devices.
Date: Wed, 15 Jan 2025 11:35:40 +0100
Message-ID: <20250115103608.118431308@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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
index 85e99641eaae..af487abe9932 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1472,10 +1472,15 @@ EXPORT_SYMBOL_GPL(btmtk_usb_setup);
 
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
@@ -1486,9 +1491,11 @@ int btmtk_usb_shutdown(struct hci_dev *hdev)
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
index af80d599c337..21a5b5535ebc 100644
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
2.39.5



