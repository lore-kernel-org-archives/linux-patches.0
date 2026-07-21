Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2214582F0;
	Tue, 21 Jul 2026 21:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668212; cv=none; b=uXCM34wx7EUBsBP8tLrAT0CtHjtTsvILxi2BEGJTPUE3+1ysxoZv0j/NNlphu2O4b8waZigxdTOLvZhjG7bGOg1wG74FgZTqdii8hu1LR9oQbmeCLtsQUimAKfvxZvvcRKC7KPoMwKGUCPOKhs9b9i0Kr1f1qbV2N/oaotKdDCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668212; c=relaxed/simple;
	bh=hsbpp5A0LETWJQZvx5oySZ/H2zxQrtUjKqq66H/2ybU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLyPpNvIqEiWSLtn4sN/LDULoENt5HW8Vd6txlDYasinh74rFm40iAretwRZhy8rxHxyjiKp/Cc/dMT8//hvyt8IMzm5nUuBJZHLiwI8Q7/O/vvi7GPYhsYkNeyXJHEAhzmCrqbVkdb963HgGRRtDKydi9XKg5UsVDbqtOr5DlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHVeKoTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHVeKoTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A5E1F000E9;
	Tue, 21 Jul 2026 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668211;
	bh=LJ12h19++3M9EPnyk+8yJQ0E0rsXVSMRHich8iDAHzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHVeKoTY2U400444Fh2/F1OmR8YwA7lmdu6NVRFBQhhzePWfw6m6FIi4e92fUBnNo
	 OhzcCThvQRxG8t63Rz8A63OSpOA2xcho+NWJ+UasF/5NUPVOpsE3mys6d7WHnzIz/B
	 /9/gdmARURkd1AGeyATQv7kg6W51S04stZHonJBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0089/1067] Bluetooth: btusb: fix wakeup source leak on probe failure
Date: Tue, 21 Jul 2026 17:11:30 +0200
Message-ID: <20260721152426.569026092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 3d93e1bb0fb881fe3ef961d1120556658e9cac4d upstream.

Make sure to disable wakeup on probe failure to avoid leaking the wakeup
source.

Fixes: fd913ef7ce61 ("Bluetooth: btusb: Add out-of-band wakeup support")
Cc: stable@vger.kernel.org	# 4.11
Cc: Rajat Jain <rajatja@google.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3155,6 +3155,11 @@ static int marvell_config_oob_wake(struc
 
 	return 0;
 }
+#else
+static inline int marvell_config_oob_wake(struct hci_dev *hdev)
+{
+	return 0;
+}
 #endif
 
 static int btusb_set_bdaddr_marvell(struct hci_dev *hdev,
@@ -3744,6 +3749,11 @@ static int btusb_config_oob_wake(struct
 	bt_dev_info(hdev, "OOB Wake-on-BT configured at IRQ %u", irq);
 	return 0;
 }
+#else
+static inline int btusb_config_oob_wake(struct hci_dev *hdev)
+{
+	return 0;
+}
 #endif
 
 static void btusb_check_needs_reset_resume(struct usb_interface *intf)
@@ -3967,7 +3977,6 @@ static int btusb_probe(struct usb_interf
 	hdev->notify = btusb_notify;
 	hdev->wakeup = btusb_wakeup;
 
-#ifdef CONFIG_PM
 	err = btusb_config_oob_wake(hdev);
 	if (err)
 		goto out_free_dev;
@@ -3976,9 +3985,9 @@ static int btusb_probe(struct usb_interf
 	if (id->driver_info & BTUSB_MARVELL && data->oob_wake_irq) {
 		err = marvell_config_oob_wake(hdev);
 		if (err)
-			goto out_free_dev;
+			goto err_disable_wakeup;
 	}
-#endif
+
 	if (id->driver_info & BTUSB_CW6622)
 		set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
 
@@ -4205,6 +4214,9 @@ err_release_siblings:
 	}
 err_kill_tx_urbs:
 	usb_kill_anchored_urbs(&data->tx_anchor);
+err_disable_wakeup:
+	if (data->oob_wake_irq)
+		device_init_wakeup(&data->udev->dev, false);
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);


