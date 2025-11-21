Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE204274FE3;
	Fri, 21 Nov 2025 13:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731671; cv=none; b=gt6qYsV4CMzmczH3SkBFtRde1LvKWoPf2TYOW9UMbMLFLki/yAm0MV/LsOunrJ4oaUXlUS7ymSjBQo6vlseoWxamC2o85ZqoQ1hExcZ1aXtZyWIc0piLKNx2OGFWttN2n66wB1TXlqpJ6IDYuXQ6KURqiW8s2tZ7z/bamechQlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731671; c=relaxed/simple;
	bh=LzEcXmli/XIX0fuPoDEYSCyqjDkYCZCa7xOcXGiDei4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDJAlSIGtepYgtBJaYNar5s2iZZjwBI3AbIHKbPQhnsLDvMSTLoNVTVBuAuAmByiC6yiKxar/SEBYsUJ5lLP0a2/1KwbDpAzxVNih+mZvTd8LA+OX1ENHimKy6we8BlU8dx852ltNVQjgZBlWM5Z08wwQFMpDll2yr44VfZ3xJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUyk/gXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUyk/gXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CD5C4CEF1;
	Fri, 21 Nov 2025 13:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731670;
	bh=LzEcXmli/XIX0fuPoDEYSCyqjDkYCZCa7xOcXGiDei4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUyk/gXVq0LCdNBeaRWxHpSKgQxpnMlHsK7xEf2DQNTAaFgle8QrZ/rWsbjbzf7Es
	 0dV/vFF1r9vMrCRlQB7TK07hG1PqsO/tYdtkrKUMaWGqT0nbAqgHlrZd17celjVqSs
	 VuC1vdevJWAr68FDENxVFCUmUWcvghh9l45Qjkak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2fc81b50a4f8263a159b@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/185] Bluetooth: btusb: reorder cleanup in btusb_disconnect to avoid UAF
Date: Fri, 21 Nov 2025 14:11:07 +0100
Message-ID: <20251121130145.326382374@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
index a734c5135a8be..aedb478614000 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4179,6 +4179,11 @@ static void btusb_disconnect(struct usb_interface *intf)
 
 	hci_unregister_dev(hdev);
 
+	if (data->oob_wake_irq)
+		device_init_wakeup(&data->udev->dev, false);
+	if (data->reset_gpio)
+		gpiod_put(data->reset_gpio);
+
 	if (intf == data->intf) {
 		if (data->isoc)
 			usb_driver_release_interface(&btusb_driver, data->isoc);
@@ -4189,17 +4194,11 @@ static void btusb_disconnect(struct usb_interface *intf)
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



