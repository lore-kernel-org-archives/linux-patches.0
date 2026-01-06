Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F45335FF4F;
	Tue,  6 Jan 2026 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721738; cv=none; b=LEwy0mSI3iw8t4BH/qDERAy0nnY/WBooAkS8jVZoM6tTFHN7HjcSg/iQzIYERk9N5x5TCkZKzajtHGldz4NyrMSYHkzPkOsOuaoyS7XnyGKjtpzbZTJWG+0V4OEse/oUKz1BOe8gxtCs2QpBYBCj+z55yB95KIRHCfNmprr7sQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721738; c=relaxed/simple;
	bh=VVQak6pMiqHhHXivTHzHwWLcP3gu9EGOaCQVMmU/NXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzeRSqYXTUAfnfRbrjO2/0mqyLQ9ecxy+m7LyBxTz64mdHEALz2SK1JSdxYSt1MyOG8iYvdz2lUd8QIUcdOWJg5sQvl25cBF05xe3ZUum7DU0JLaxZcJe9yF8CpDyEBnv1XVquE20ZSN/bKDmjTY7yYdjrZypW5o+tDsj3INkhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odFBz9Hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odFBz9Hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E15C116C6;
	Tue,  6 Jan 2026 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721738;
	bh=VVQak6pMiqHhHXivTHzHwWLcP3gu9EGOaCQVMmU/NXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odFBz9Hb9vKhPhd97gyMaSzyAWpfaQH20bZZCwdVn5zVRny6cFM/u54M7Xjukp7Pg
	 oixTlwDlzG73rYo46XlJ4vmV0U03C7Z0CGXJxISiR+IDiaaqrltLymb0zlCTcUZaCt
	 tFfzR/kn6Ng/97WEuTTU48p92e18zi7oU2WwbjTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/312] Bluetooth: btusb: revert use of devm_kzalloc in btusb
Date: Tue,  6 Jan 2026 18:01:39 +0100
Message-ID: <20260106170548.766716896@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
index b92bfd131567..3420f711f0f0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4017,7 +4017,7 @@ static int btusb_probe(struct usb_interface *intf,
 			return -ENODEV;
 	}
 
-	data = devm_kzalloc(&intf->dev, sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -4040,8 +4040,10 @@ static int btusb_probe(struct usb_interface *intf,
 		}
 	}
 
-	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep)
+	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep) {
+		kfree(data);
 		return -ENODEV;
+	}
 
 	if (id->driver_info & BTUSB_AMP) {
 		data->cmdreq_type = USB_TYPE_CLASS | 0x01;
@@ -4096,8 +4098,10 @@ static int btusb_probe(struct usb_interface *intf,
 	data->recv_acl = hci_recv_frame;
 
 	hdev = hci_alloc_dev_priv(priv_size);
-	if (!hdev)
+	if (!hdev) {
+		kfree(data);
 		return -ENOMEM;
+	}
 
 	hdev->bus = HCI_USB;
 	hci_set_drvdata(hdev, data);
@@ -4370,6 +4374,7 @@ static int btusb_probe(struct usb_interface *intf,
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);
 	hci_free_dev(hdev);
+	kfree(data);
 	return err;
 }
 
@@ -4418,6 +4423,7 @@ static void btusb_disconnect(struct usb_interface *intf)
 	}
 
 	hci_free_dev(hdev);
+	kfree(data);
 }
 
 #ifdef CONFIG_PM
-- 
2.51.0



