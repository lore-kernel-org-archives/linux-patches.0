Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A033161AD;
	Thu, 16 Jul 2026 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210646; cv=none; b=t/M/Uv17Eopwj/Ue0FYR7yISFO1B1dIcDXlZms2kL0qwvQxFuz+WOl/uZ3Px1MU92H4vJTkzhF3eaLlWVoVZHpGEYUbHUw04U7EueH1QDELOC0dfeJ7SFf7+ya56fMWlHJRPHtbMrcjQhqOX0oMEevL9XYGcJifTqqCoKBUptTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210646; c=relaxed/simple;
	bh=O/dW9VDoabGSK774t0kdf8YbJlx3dscanU8CiFJvLf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHsnK5kDW5+q6f7QW0O2fK3fUFZg6o+KBafkg5zV5inLSqoPa/KfhxrlufOvWCjHbxVVDcdrLWN+aBEX0o9l+dkUv49r7FmqztjbRy9mzsmPicdJnI5wPxV2ikLIGFN9hT2Vs2JF7ECxRGIBYQnmqeSX9Zi5JzTe4RizDCknnrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcKyzcIZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcKyzcIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A651F000E9;
	Thu, 16 Jul 2026 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210645;
	bh=SehjEWcoEluM3iACZIT+Q+QTngi4VwdFRBFJLb+IhM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fcKyzcIZOhCt2e63xu/N9V9dtkLtwIWWDJKZXg/TMhTFMEeyhJaZVZYlq+jYqKBOh
	 EevFkWBD7JI6PoY7GAq8Abn4IX0uZVCtfb2t/e81a5bURy/r2vxJJ2jSqfqVbS947R
	 9Sc1gKv5BcWxeyIepfnK2iW6WzrwX3lO6z6YPZW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 125/480] Bluetooth: btusb: fix wakeup source leak on probe failure
Date: Thu, 16 Jul 2026 15:27:52 +0200
Message-ID: <20260716133047.413568199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -2934,6 +2934,11 @@ static int marvell_config_oob_wake(struc
 
 	return 0;
 }
+#else
+static inline int marvell_config_oob_wake(struct hci_dev *hdev)
+{
+	return 0;
+}
 #endif
 
 static int btusb_set_bdaddr_marvell(struct hci_dev *hdev,
@@ -3793,6 +3798,11 @@ static int btusb_config_oob_wake(struct
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
@@ -4147,7 +4157,6 @@ static int btusb_probe(struct usb_interf
 	hdev->wakeup  = btusb_wakeup;
 	hdev->hci_drv = &btusb_hci_drv;
 
-#ifdef CONFIG_PM
 	err = btusb_config_oob_wake(hdev);
 	if (err)
 		goto out_free_dev;
@@ -4156,9 +4165,9 @@ static int btusb_probe(struct usb_interf
 	if (id->driver_info & BTUSB_MARVELL && data->oob_wake_irq) {
 		err = marvell_config_oob_wake(hdev);
 		if (err)
-			goto out_free_dev;
+			goto err_disable_wakeup;
 	}
-#endif
+
 	if (id->driver_info & BTUSB_CW6622)
 		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_STORED_LINK_KEY);
 
@@ -4401,6 +4410,9 @@ err_release_siblings:
 	}
 err_kill_tx_urbs:
 	usb_kill_anchored_urbs(&data->tx_anchor);
+err_disable_wakeup:
+	if (data->oob_wake_irq)
+		device_init_wakeup(&data->udev->dev, false);
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);


