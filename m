Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107602DF137;
	Thu, 16 Jul 2026 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209262; cv=none; b=pwRAb4BVqylzLVhcL8ZDg6zEwIR5RCs3BCA9EAphjbsYmIqLOmK9PpjN3IMMhBgBEjc16xsC0cOOkinq8kzds6qymfixECqzGWj5IBWL97NAEIF1JnNFKJWZWKrM0GQSjJREEm0hFM7qIgs3iuRkcY3BwmNEpdl2g9lYlzlX1hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209262; c=relaxed/simple;
	bh=gZGXyJLmH+BGXJTK/wBdIyPeNovuAcITbsRsh78PfmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWxORe/stV9xk68Eibej/y5d0/IkkqSOEXEuzpT5adUNhnkC6+ZORpFh1siTC7bl6wIDEB/EH3KQTHfdrELzpyBH2tjzZp9iY8Cqwa3ekSo03qid6RP2oFEEQ2+7oEqpnpbZ3hPOzRQPbeeB6N8CEHFZE7WE1YfzlhIj7SS9DwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bOr/vAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bOr/vAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8E71F000E9;
	Thu, 16 Jul 2026 13:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209261;
	bh=oBM/ND6Wll4+dC3+qsrrOXAvOM5puWFrXofOEHFJc+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bOr/vAy3HlweQjzDR8B+VsOMQ8ekA1sN0Hg0iPKux1KZbHNs67mcgfi/O+QCcQvB
	 OwrnV2t8T5cTaJ5WnhXKEnSbYs+b/kcXMhqz9zPle71n7MCQ/NN8/GBhkf3FxtXw3n
	 f/fFeY2P6dqqQ8fcZ/KBWaxtss39mYGPr3pKPhRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 116/518] Bluetooth: btusb: fix wakeup source leak on probe failure
Date: Thu, 16 Jul 2026 15:26:24 +0200
Message-ID: <20260716133050.393743306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2996,6 +2996,11 @@ static int marvell_config_oob_wake(struc
 
 	return 0;
 }
+#else
+static inline int marvell_config_oob_wake(struct hci_dev *hdev)
+{
+	return 0;
+}
 #endif
 
 static int btusb_set_bdaddr_marvell(struct hci_dev *hdev,
@@ -3838,6 +3843,11 @@ static int btusb_config_oob_wake(struct
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
@@ -4174,7 +4184,6 @@ static int btusb_probe(struct usb_interf
 	hdev->wakeup  = btusb_wakeup;
 	hdev->hci_drv = &btusb_hci_drv;
 
-#ifdef CONFIG_PM
 	err = btusb_config_oob_wake(hdev);
 	if (err)
 		goto out_free_dev;
@@ -4183,9 +4192,9 @@ static int btusb_probe(struct usb_interf
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
 
@@ -4429,6 +4438,9 @@ err_release_siblings:
 	}
 err_kill_tx_urbs:
 	usb_kill_anchored_urbs(&data->tx_anchor);
+err_disable_wakeup:
+	if (data->oob_wake_irq)
+		device_init_wakeup(&data->udev->dev, false);
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);


