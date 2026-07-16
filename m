Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5FC400982;
	Thu, 16 Jul 2026 14:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211833; cv=none; b=fSYEVG3oCSZat0BaW1DE3HPAFnUWHLwy9alpZxiUWPYRz9iTZ14R7Pmty4rW+Blm7Ftcw7DHMPbBDMdMQBcZqKsuq2lVzseJ7oV8CV5+jlotgdiqeLIXokxhoHm1ZSsUulIw1HJ6cWmyqq9TREjOW7ZBt2illujQGbeoJ9IbCOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211833; c=relaxed/simple;
	bh=gXGPOCr8gCzp++C0WP3+8t8PXKnnyzv8/lCR2kZ2t2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ0dCYOq9b600jgP4ITwDFciOyRpE76fgw7Rs5MXaUktghFCiF4FNV0QzzKigsi7TqLfB+pHGpliC8Oxn1742y5bczhDMfzXAG6e7NX8yh3BzObdmsd3kK7mK6XLBwhMaG/3gpYfnaaTdBopGmATSeAJY2rGYfpwY6ZvvMYp85A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJCSKDcp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJCSKDcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9220F1F000E9;
	Thu, 16 Jul 2026 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211832;
	bh=iMQDZswxS4ruPUUIbmlJlyzgjG59o0uu3/Ku7Ky/Zzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJCSKDcphQL8d9b6hv+kc/1MAWAI8B0YNa/GhIs5yAWp4jI3bke4MmA0zvSBP4ZqH
	 xiQl2zIE6KE5kM7tXaDOYpDy5suHg8ufLzqtICCsjxwFBazb3mnYjdbqpzDj4jUSrm
	 3LgU4ReiMSQ48NjOp3Fg7xXGvgoZ1UJsx47UqyUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 095/349] Bluetooth: btusb: fix use-after-free on marvell probe failure
Date: Thu, 16 Jul 2026 15:30:29 +0200
Message-ID: <20260716133035.441792932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit c5b600a3c05b1a7a110d558df935a8fc8a471c79 upstream.

Make sure to stop any TX URBs submitted during Marvell OOB wakeup
configuration on later probe failures to avoid use-after-free in the
completion callback.

This issue was reported by Sashiko while reviewing a fix for a wakeup
source leak in the btusb probe errors paths.

Link: https://sashiko.dev/#/patchset/20260402092704.2346710-1-johan%40kernel.org
Fixes: a4ccc9e33d2f ("Bluetooth: btusb: Configure Marvell to use one of the pins for oob wakeup")
Cc: stable@vger.kernel.org	# 4.11
Cc: Rajat Jain <rajatja@google.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4008,7 +4008,7 @@ static int btusb_probe(struct usb_interf
 	if (id->driver_info & BTUSB_INTEL_COMBINED) {
 		err = btintel_configure_setup(hdev, btusb_driver.name);
 		if (err)
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 
 		/* Transport specific configuration */
 		hdev->send = btusb_send_frame_intel;
@@ -4170,7 +4170,7 @@ static int btusb_probe(struct usb_interf
 		err = usb_set_interface(data->udev, 0, 0);
 		if (err < 0) {
 			BT_ERR("failed to set interface 0, alt 0 %d", err);
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 		}
 	}
 
@@ -4178,7 +4178,7 @@ static int btusb_probe(struct usb_interf
 		err = usb_driver_claim_interface(&btusb_driver,
 						 data->isoc, data);
 		if (err < 0)
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 	}
 
 	if (IS_ENABLED(CONFIG_BT_HCIBTUSB_BCM) && data->diag) {
@@ -4214,6 +4214,8 @@ err_release_siblings:
 		usb_set_intfdata(data->isoc, NULL);
 		usb_driver_release_interface(&btusb_driver, data->isoc);
 	}
+err_kill_tx_urbs:
+	usb_kill_anchored_urbs(&data->tx_anchor);
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);


