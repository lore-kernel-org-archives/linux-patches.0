Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BC93D3017;
	Thu, 15 Jan 2026 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498184; cv=none; b=E317kU5x1MEoB92x3HPX7WC/Oi4ZTCl80POsxq4CNLr9dQy2OuV9VT0NkSXrrV6gj5lT0WxPm8Bh+j8dqSEqy7iLz7XnO3ywtd4HyqSCCgBupoY0iSdEeqztXRWgCSZLRsmugQweNdi8idjmicLHJyh6WUfGNMmv944VdIjV8Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498184; c=relaxed/simple;
	bh=CuTGPElDfxPFeAo3fuVjd9Pfi82HBXO01hCcJ8c+3Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qi64fg+CXT3scZfugjQIXw56lEqepNV2I95/rWQqsomXjD5Bx16zv4u60dRGZRpoLHezAQyD2ZDv9Nq7w+UUpNhWrjhbibklPAFCITfMSDkDCXH/19heRqJHkX18RPNLVC805FEddnysxbM8VEcVHQrCHtwecvXAridXgFmVzPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+92Zpzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+92Zpzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4574C116D0;
	Thu, 15 Jan 2026 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498184;
	bh=CuTGPElDfxPFeAo3fuVjd9Pfi82HBXO01hCcJ8c+3Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+92ZpzozaWQv7htkaRrAbYbjEfOW/dm5t8ujcjp5dvev89qQPCfyvsFkqt3IOdyu
	 T97PHgndLwmGMIAPJebBASYhXXbICPmZoQCeMOC3kFSCORa2gF9ZBT76UlU+/SFWPd
	 YxTdA0mltV1h5MH/YLPFMwcvTL7oOlI/2tyZFvBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/554] Bluetooth: btusb: revert use of devm_kzalloc in btusb
Date: Thu, 15 Jan 2026 17:46:47 +0100
Message-ID: <20260115164258.573608245@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 95483a8d7b1e..c447e2e9417b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3788,7 +3788,7 @@ static int btusb_probe(struct usb_interface *intf,
 			return -ENODEV;
 	}
 
-	data = devm_kzalloc(&intf->dev, sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -3811,8 +3811,10 @@ static int btusb_probe(struct usb_interface *intf,
 		}
 	}
 
-	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep)
+	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep) {
+		kfree(data);
 		return -ENODEV;
+	}
 
 	if (id->driver_info & BTUSB_AMP) {
 		data->cmdreq_type = USB_TYPE_CLASS | 0x01;
@@ -3855,8 +3857,10 @@ static int btusb_probe(struct usb_interface *intf,
 	data->recv_acl = hci_recv_frame;
 
 	hdev = hci_alloc_dev_priv(priv_size);
-	if (!hdev)
+	if (!hdev) {
+		kfree(data);
 		return -ENOMEM;
+	}
 
 	hdev->bus = HCI_USB;
 	hci_set_drvdata(hdev, data);
@@ -4104,6 +4108,7 @@ static int btusb_probe(struct usb_interface *intf,
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);
 	hci_free_dev(hdev);
+	kfree(data);
 	return err;
 }
 
@@ -4149,6 +4154,7 @@ static void btusb_disconnect(struct usb_interface *intf)
 	}
 
 	hci_free_dev(hdev);
+	kfree(data);
 }
 
 #ifdef CONFIG_PM
-- 
2.51.0



