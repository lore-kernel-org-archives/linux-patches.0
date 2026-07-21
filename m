Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B128430CE3;
	Tue, 21 Jul 2026 22:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674587; cv=none; b=W7iJHoUvPH1vq0HakdiXf0pOQiyGbU+q4IHw6dcaCGyVEh2c6FO0ZEp505TSJzMOCBhisxjC+0S/tcTTxH64bPZLiR++COCdi7gZAFsrBGJbREosvHHkmWh+fOlj90b05oz8Uh/OABX4pL54LQum7BCOjHzMJ2wwbq+1inAGzZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674587; c=relaxed/simple;
	bh=f3/XyOatbVWiNRmUyLRx4MaJnx3jky9iFFAmrLU2MyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keJf/QVGbfkrTj6Smgevw+dlxP2JgcalOlkI01rp2OpXIYpi5/ozCQgP1+vD7OyQ3ihMdulY1Gq5i/5NcCouVyBJ0wQhc2HMPxFhCyI1ZV/9HO5A2aY306PcSoTVzSlL7B6PqT7h9gQ5EpxLjW1JXGHCMXDto22+sVlyngXUBuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUjVXmYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUjVXmYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10681F00A3A;
	Tue, 21 Jul 2026 22:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674586;
	bh=nymxLm1hyYI5Mr04qCWsklJhXBlpJWfwHTszBwJZbVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUjVXmYAK1f6RAxt/fvQBQPbsKTYsWCAAQwmMLhn38F0HlLMmTftInbVwx1UJqznY
	 QesIruKj1lpAAunI4GkALT7kVEZIAF4mPkiVmUCj4dYfgF9/atvcXxek28yzoh3i8S
	 DKX7+L4EsOS60pFC4crR0CKkp5GifAQCglFVGrbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 598/699] Bluetooth: btusb: fix wakeup source leak on probe failure
Date: Tue, 21 Jul 2026 17:25:57 +0200
Message-ID: <20260721152409.220092684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 3d93e1bb0fb881fe3ef961d1120556658e9cac4d ]

Make sure to disable wakeup on probe failure to avoid leaking the wakeup
source.

Fixes: fd913ef7ce61 ("Bluetooth: btusb: Add out-of-band wakeup support")
Cc: stable@vger.kernel.org	# 4.11
Cc: Rajat Jain <rajatja@google.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3501,6 +3501,11 @@ static int marvell_config_oob_wake(struc
 
 	return 0;
 }
+#else
+static inline int marvell_config_oob_wake(struct hci_dev *hdev)
+{
+	return 0;
+}
 #endif
 
 static int btusb_set_bdaddr_marvell(struct hci_dev *hdev,
@@ -4011,6 +4016,11 @@ static int btusb_config_oob_wake(struct
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
@@ -4164,7 +4174,6 @@ static int btusb_probe(struct usb_interf
 	hdev->notify = btusb_notify;
 	hdev->prevent_wake = btusb_prevent_wake;
 
-#ifdef CONFIG_PM
 	err = btusb_config_oob_wake(hdev);
 	if (err)
 		goto out_free_dev;
@@ -4173,9 +4182,9 @@ static int btusb_probe(struct usb_interf
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
 
@@ -4393,6 +4402,9 @@ err_release_siblings:
 	}
 err_kill_tx_urbs:
 	usb_kill_anchored_urbs(&data->tx_anchor);
+err_disable_wakeup:
+	if (data->oob_wake_irq)
+		device_init_wakeup(&data->udev->dev, false);
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);


