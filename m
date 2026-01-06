Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAB5155389;
	Tue,  6 Jan 2026 17:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720659; cv=none; b=mikX9sOrCQ7zzryD2dDaprCuBH9C1bXOxMmo9rO4PSpRewQm9j9PhEHonFxiIncZrl/MmdVb14n/Fp/hKERXiNlaRTrLLs9Y4KxAxS80OQEuf2ll6EnO28bzcOVueWkSsYjWYFb4h3berWNmA59x0QKlFXhBBhlBZBQaqY5CdyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720659; c=relaxed/simple;
	bh=w9Dzo4FmYr/nWZb/VYVEG81U13eZuiPvhm45FeuiD/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNRAe5RJZVMIcZx3oTNqzOM7Uae0L297NljIxut77Ilj4xhxUmVADlG3E51BWIfHwh+CzcZtOyAnu24Eya/NPnZndbO7jrA61c9nm2CG3eMf4yqZkOydezUdVo6MxXOFjkM3+AuDCr9MB15qW3/y/KGu8bB9f5+AkxG1zShyDjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nAv/YqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nAv/YqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E565C116C6;
	Tue,  6 Jan 2026 17:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720659;
	bh=w9Dzo4FmYr/nWZb/VYVEG81U13eZuiPvhm45FeuiD/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1nAv/YqBsV/fX7tRxKS6aec/p75ffybIzI3AKMRuuAQw8Ut20GH6MbRqX0ve+SAyH
	 EfI9P+QcJq8WSwj9K+BX4+UJhorMRPknKlc4mKZdQhfqZG3zWvv1dKNOvYSOSrhQuc
	 jsm+IyFPzcONRHXKhtrUTvazTqwDqUSa2TmbyHW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/567] Bluetooth: btusb: revert use of devm_kzalloc in btusb
Date: Tue,  6 Jan 2026 18:01:25 +0100
Message-ID: <20260106170502.540152739@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fc7b3e02f14b..603ff13d9f7c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3835,7 +3835,7 @@ static int btusb_probe(struct usb_interface *intf,
 			return -ENODEV;
 	}
 
-	data = devm_kzalloc(&intf->dev, sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -3858,8 +3858,10 @@ static int btusb_probe(struct usb_interface *intf,
 		}
 	}
 
-	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep)
+	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep) {
+		kfree(data);
 		return -ENODEV;
+	}
 
 	if (id->driver_info & BTUSB_AMP) {
 		data->cmdreq_type = USB_TYPE_CLASS | 0x01;
@@ -3914,8 +3916,10 @@ static int btusb_probe(struct usb_interface *intf,
 	data->recv_acl = hci_recv_frame;
 
 	hdev = hci_alloc_dev_priv(priv_size);
-	if (!hdev)
+	if (!hdev) {
+		kfree(data);
 		return -ENOMEM;
+	}
 
 	hdev->bus = HCI_USB;
 	hci_set_drvdata(hdev, data);
@@ -4187,6 +4191,7 @@ static int btusb_probe(struct usb_interface *intf,
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);
 	hci_free_dev(hdev);
+	kfree(data);
 	return err;
 }
 
@@ -4235,6 +4240,7 @@ static void btusb_disconnect(struct usb_interface *intf)
 	}
 
 	hci_free_dev(hdev);
+	kfree(data);
 }
 
 #ifdef CONFIG_PM
-- 
2.51.0



