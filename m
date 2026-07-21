Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB0D47044A;
	Tue, 21 Jul 2026 20:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664966; cv=none; b=dnsQavXO/+XarFrOl69v9x4ybGvLxuROs8dSKukYMJZKwQ9gvOMQ2OB5tBgIodfk0HF/y4+/fJ+WgZJGDh4fBSrAknAcKxcZTKs/hejT2Bz7efAi1SbQpQokiY3TEXwTSsR/Ql649/X+8vRKwgacaZZohQ7wrlHlNKSWuLaz+Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664966; c=relaxed/simple;
	bh=fuZcP6OQDLTis1O7wwcSXTrubrLjch7DH5269godvTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NT+IFHqCrhU7MZxjHwPiuL8+uLIOGNFl2ijV1lSaAoeQyYdDQlUJXOO/ti03hR9PoGYSbU21irP/AF5s3NNxLt0uEYusSJcsYp1cYVv0zFkfhilaKtO5rsKvoBPjEQfrva7zJAm9neYIaqG9dWO8ehzhE2QuXDXdcgA+8KPvssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8Sis/U/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8Sis/U/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D47C1F000E9;
	Tue, 21 Jul 2026 20:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664965;
	bh=CY3xUOBqXiDj1e0XvQluSQPHbDwacS6Ge8CgK3BHMmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8Sis/U/OjdK2Ns9jQuuxCVhBoAZpabti66iGQCSbDpkugQAVQvFnch8oCfDI0fdj
	 x4NntU4BBsFJcKQtx/t5Ry4dQbKE4ePkclxQd9oPsjON5uU+Xw4qNhs7UI1gknkQ1K
	 RugtAb+INbphHDZU6UhTNGKpIrCZsF5vFmZpnN5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0125/1266] Bluetooth: btusb: fix wakeup source leak on probe failure
Date: Tue, 21 Jul 2026 17:09:22 +0200
Message-ID: <20260721152444.601091259@linuxfoundation.org>
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
@@ -2811,6 +2811,11 @@ static int marvell_config_oob_wake(struc
 
 	return 0;
 }
+#else
+static inline int marvell_config_oob_wake(struct hci_dev *hdev)
+{
+	return 0;
+}
 #endif
 
 static int btusb_set_bdaddr_marvell(struct hci_dev *hdev,
@@ -3625,6 +3630,11 @@ static int btusb_config_oob_wake(struct
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
@@ -3848,7 +3858,6 @@ static int btusb_probe(struct usb_interf
 	hdev->notify = btusb_notify;
 	hdev->wakeup = btusb_wakeup;
 
-#ifdef CONFIG_PM
 	err = btusb_config_oob_wake(hdev);
 	if (err)
 		goto out_free_dev;
@@ -3857,9 +3866,9 @@ static int btusb_probe(struct usb_interf
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
 
@@ -4098,6 +4107,9 @@ err_release_siblings:
 	}
 err_kill_tx_urbs:
 	usb_kill_anchored_urbs(&data->tx_anchor);
+err_disable_wakeup:
+	if (data->oob_wake_irq)
+		device_init_wakeup(&data->udev->dev, false);
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);


