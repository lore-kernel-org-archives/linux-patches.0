Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B676C35A94B;
	Fri,  9 Jan 2026 12:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960734; cv=none; b=bN8cq21Al1PbWokwDiwWwmxP6lLb0Fpv1TfL6jsZrnUDtiGx9G6Tlqcvh1C7v+JwYjMcWgTAQeNrx+7BWCu0pl9pbt82T5tuGzXNYwbKjnJvKlLeJzNtOvEKF3yA68ol1+VsYjQr4aoPKu++wbwip5CJrOqllNGJ6ZJT55Pk9p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960734; c=relaxed/simple;
	bh=SQVpbEnsu9z7qIsYj/iYabX2Tt/CbZ972ArZ3FHA6Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkbLsAJJTM02gL0dnxMgxsRdTg94HRGhyFe5NA4tFUVG4DvBdnJUDYpMXEgm+iauoxTh2Ekvzbiyz9/YuB3ftCrrKXvxxvNS7YO39kF8BGj/qTb3LvihjCFlorhd6zVYEmmNMi3b+OcLwXx8K3GAGmvVtG8MuftE5R4pzGX0yg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCQ2z306; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCQ2z306"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F5AC4CEF1;
	Fri,  9 Jan 2026 12:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960734;
	bh=SQVpbEnsu9z7qIsYj/iYabX2Tt/CbZ972ArZ3FHA6Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCQ2z306s7/NnCkpn3U19/uEJh2SzNKs1QbR0+euu1zi7CeZeXyCBoGBX0/dTD+i1
	 3NufbuEAB7FS/zSYZd/u3LbKsWAH/jAk860Pd/5/AFnAKmLtcVtqf+SLEm8dEFh/nZ
	 96Cnn+9HTelUGNyiBMTIxlgiZmqTmrfYU3e3Dte4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 507/737] Bluetooth: btusb: revert use of devm_kzalloc in btusb
Date: Fri,  9 Jan 2026 12:40:46 +0100
Message-ID: <20260109112153.066200135@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>

[ Upstream commit 252714f1e8bdd542025b16321c790458014d6880 ]

This reverts commit 98921dbd00c4e ("Bluetooth: Use devm_kzalloc in
btusb.c file").

In btusb_probe(), we use devm_kzalloc() to allocate the btusb data. This
ties the lifetime of all the btusb data to the binding of a driver to
one interface, INTF. In a driver that binds to other interfaces, ISOC
and DIAG, this is an accident waiting to happen.

The issue is revealed in btusb_disconnect(), where calling
usb_driver_release_interface(&btusb_driver, data->intf) will have devm
free the data that is also being used by the other interfaces of the
driver that may not be released yet.

To fix this, revert the use of devm and go back to freeing memory
explicitly.

Fixes: 98921dbd00c4e ("Bluetooth: Use devm_kzalloc in btusb.c file")
Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 7bc7ee4eebd3..1309e9318bdb 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4342,7 +4342,7 @@ static int btusb_probe(struct usb_interface *intf,
 			return -ENODEV;
 	}
 
-	data = devm_kzalloc(&intf->dev, sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -4365,8 +4365,10 @@ static int btusb_probe(struct usb_interface *intf,
 		}
 	}
 
-	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep)
+	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep) {
+		kfree(data);
 		return -ENODEV;
+	}
 
 	if (id->driver_info & BTUSB_AMP) {
 		data->cmdreq_type = USB_TYPE_CLASS | 0x01;
@@ -4421,8 +4423,10 @@ static int btusb_probe(struct usb_interface *intf,
 	data->recv_acl = hci_recv_frame;
 
 	hdev = hci_alloc_dev_priv(priv_size);
-	if (!hdev)
+	if (!hdev) {
+		kfree(data);
 		return -ENOMEM;
+	}
 
 	hdev->bus = HCI_USB;
 	hci_set_drvdata(hdev, data);
@@ -4690,6 +4694,7 @@ static int btusb_probe(struct usb_interface *intf,
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);
 	hci_free_dev(hdev);
+	kfree(data);
 	return err;
 }
 
@@ -4738,6 +4743,7 @@ static void btusb_disconnect(struct usb_interface *intf)
 	}
 
 	hci_free_dev(hdev);
+	kfree(data);
 }
 
 #ifdef CONFIG_PM
-- 
2.51.0



