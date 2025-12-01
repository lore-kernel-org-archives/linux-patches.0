Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9E1258ED1;
	Mon,  1 Dec 2025 11:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588670; cv=none; b=A7oSPxWvH+7N/Jhf+rmyxD+tNWsVrMLmA84NeoPrW5MrqAYjsstqNFsKRnFADii22J6+Rduu/rKpXzk2Q3bOz/Llf7S/0WXMx/oUvSBopCX2e2mpF8wWtWAJGWTyLWd09FzNP5WsA7/3bpIQQa539Sx/2Z36fsHwEedKyvZp5Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588670; c=relaxed/simple;
	bh=Ewlaa6a2SWFveX+qRZ2sKhN0NknuNugiIj9VYz4QPH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKKW+iADBF7UNKYMUuLTti3XajWp/uRxOG8y7MoU5NqAFp2S07cv1wZdVfopEqEUBAKnmuXPPrkjXeyiICHQSthJUyGPWjxoFoVsj+YAGZ+m/GpChyoVdG3LSn5Bm5bsTORtLNR8Rj5QHMpnFhw5vBk9PGlYsZzn1Z3XQzdTYaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXcfYzcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXcfYzcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EC1C4CEF1;
	Mon,  1 Dec 2025 11:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588669;
	bh=Ewlaa6a2SWFveX+qRZ2sKhN0NknuNugiIj9VYz4QPH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXcfYzcsOHNVmx1bl81TuvGYdOl6C1Nf9X+38UbKYSMhN7CwSAgTGb8NXM/Z9VD0j
	 P5Cp6WKNaNVUq1oEQ7EFPCnqRjz+bEOi+oJ8xsUBSVthFEcqg45I/w+9ikiXsvyzFv
	 2eBZ3LXsgs9q1734vZxvLbBmX9e1gpr1DVrFQ024=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2fc81b50a4f8263a159b@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/187] Bluetooth: btusb: reorder cleanup in btusb_disconnect to avoid UAF
Date: Mon,  1 Dec 2025 12:23:58 +0100
Message-ID: <20251201112245.923135891@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>

[ Upstream commit 23d22f2f71768034d6ef86168213843fc49bf550 ]

There is a KASAN: slab-use-after-free read in btusb_disconnect().
Calling "usb_driver_release_interface(&btusb_driver, data->intf)" will
free the btusb data associated with the interface. The same data is
then used later in the function, hence the UAF.

Fix by moving the accesses to btusb data to before the data is free'd.

Reported-by: syzbot+2fc81b50a4f8263a159b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2fc81b50a4f8263a159b
Tested-by: syzbot+2fc81b50a4f8263a159b@syzkaller.appspotmail.com
Fixes: fd913ef7ce619 ("Bluetooth: btusb: Add out-of-band wakeup support")
Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9f71f9135f9e3..3d79637a56cc4 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4004,6 +4004,11 @@ static void btusb_disconnect(struct usb_interface *intf)
 
 	hci_unregister_dev(hdev);
 
+	if (data->oob_wake_irq)
+		device_init_wakeup(&data->udev->dev, false);
+	if (data->reset_gpio)
+		gpiod_put(data->reset_gpio);
+
 	if (intf == data->intf) {
 		if (data->isoc)
 			usb_driver_release_interface(&btusb_driver, data->isoc);
@@ -4014,17 +4019,11 @@ static void btusb_disconnect(struct usb_interface *intf)
 			usb_driver_release_interface(&btusb_driver, data->diag);
 		usb_driver_release_interface(&btusb_driver, data->intf);
 	} else if (intf == data->diag) {
-		usb_driver_release_interface(&btusb_driver, data->intf);
 		if (data->isoc)
 			usb_driver_release_interface(&btusb_driver, data->isoc);
+		usb_driver_release_interface(&btusb_driver, data->intf);
 	}
 
-	if (data->oob_wake_irq)
-		device_init_wakeup(&data->udev->dev, false);
-
-	if (data->reset_gpio)
-		gpiod_put(data->reset_gpio);
-
 	hci_free_dev(hdev);
 }
 
-- 
2.51.0



