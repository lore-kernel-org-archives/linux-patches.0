Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DB935A955;
	Fri,  9 Jan 2026 12:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962550; cv=none; b=q0o0FyUCBsyr2Otul8tWm7uhQMNK0wvDXT4Qixh6rcsMJjCiGA7QjzAcBvguLnblfP5TdXu7pyB0Dosx4n9frxEUJlfJ0K/Luadrojx8puBFt7RcCZS9SaeyhptSsAK6ZMCS4xuGQVYBBKjrg+8FhuJyERI4ulQ3mxPHj12YEwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962550; c=relaxed/simple;
	bh=/jmcWKSO+ef6sjmyMzquY9dsx5z2oLiyVRW64zk3ynw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVMKqSvXNcaIf3yIMgVsdkFVfgzHqK+gEMzDykqj++y6HJlVvAzsbV+/KF93oDEbw6qrvuwGlM9u8KCXsbsHyAWfPX/UHZyfgck/emjzGbWZy4hNHfz7Q0hHs8JLxIH9CGWuutWkRT68Z5bIrb6o1NzhgiD5so38Jk7rrDcrdsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXO3SRSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXO3SRSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7188C4CEF1;
	Fri,  9 Jan 2026 12:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962550;
	bh=/jmcWKSO+ef6sjmyMzquY9dsx5z2oLiyVRW64zk3ynw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXO3SRStoyIqQGoJgXXsbDvARSLFRkxa31zDjWSdvFwDH88kU26j4r+etn+DJpnXe
	 rxEZZNJMa8pCj2uztiE5a90D/7v7hg60HSPyXBHuGuPNLIoN5+WJKFBb3btf8MyRoJ
	 eyeThM5ybx0DFjRo8THACu+J/vD437vrOoPu9G9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 404/634] Bluetooth: btusb: revert use of devm_kzalloc in btusb
Date: Fri,  9 Jan 2026 12:41:22 +0100
Message-ID: <20260109112132.730397465@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index 983794632927..c6ac351209c0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3849,7 +3849,7 @@ static int btusb_probe(struct usb_interface *intf,
 			return -ENODEV;
 	}
 
-	data = devm_kzalloc(&intf->dev, sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -3872,8 +3872,10 @@ static int btusb_probe(struct usb_interface *intf,
 		}
 	}
 
-	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep)
+	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep) {
+		kfree(data);
 		return -ENODEV;
+	}
 
 	if (id->driver_info & BTUSB_AMP) {
 		data->cmdreq_type = USB_TYPE_CLASS | 0x01;
@@ -3920,8 +3922,10 @@ static int btusb_probe(struct usb_interface *intf,
 	data->recv_acl = hci_recv_frame;
 
 	hdev = hci_alloc_dev_priv(priv_size);
-	if (!hdev)
+	if (!hdev) {
+		kfree(data);
 		return -ENOMEM;
+	}
 
 	hdev->bus = HCI_USB;
 	hci_set_drvdata(hdev, data);
@@ -4182,6 +4186,7 @@ static int btusb_probe(struct usb_interface *intf,
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);
 	hci_free_dev(hdev);
+	kfree(data);
 	return err;
 }
 
@@ -4227,6 +4232,7 @@ static void btusb_disconnect(struct usb_interface *intf)
 	}
 
 	hci_free_dev(hdev);
+	kfree(data);
 }
 
 #ifdef CONFIG_PM
-- 
2.51.0



