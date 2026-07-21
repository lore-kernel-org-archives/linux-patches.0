Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623433C1081;
	Tue, 21 Jul 2026 21:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670996; cv=none; b=r2hwKUTG8769zdzPZdezuGCoYm3ZApp1c0Z1YTivlD00/xk3xLv9GK0nV/DWpTvW+icxcuKp1rsvtD6z/iAR79t7Z7ztW2z6mfzM2FKZ0xaasTcMIci+uiTmQHwVDiwW4pIYBnJ7Mb6s/BWMUu6MOW8KOfhks6g7ybrX2EcUr0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670996; c=relaxed/simple;
	bh=kSwtwAp+r/Bha5E5ptQFJSWHWYSlD82IzrBm0IEtjys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJEuPI095MSBhNaKOcTpxFwV7d6ndqiJ7HEBs34isGQTskxzNyJqs8ZrFWmGceFPRg4h99GNQDJpPY7XfoG94on1xOHSUMD924/u/D+JLSBnmXjAxbeWMmRYuNjiQHvs4u+7UEMY5ys9s9SH7EcX6jSJpnpK76/hA73CZbqrCQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apuAEWyN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apuAEWyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30E21F000E9;
	Tue, 21 Jul 2026 21:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670995;
	bh=zyCOVz3S2Cb8HCG+NorxIB6awKSSAHhgiTswtJv3z+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apuAEWyNoXtOC53BMefYE1PSFvWq2RP0+up7OJs0x6tIjwhjMqEHS8hq7OAyIVpbK
	 Y/A8U+/pjWyVLIwr/X1siJHWgnqqgK119mV0lsPVZxN3NAy34MW6EUSV3jBE0VwGWX
	 ifvhIEZkJjUeYWhZ8vfqMmcDdePnLg8W+pxV8nWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 077/843] Bluetooth: btusb: fix use-after-free on marvell probe failure
Date: Tue, 21 Jul 2026 17:15:12 +0200
Message-ID: <20260721152407.726469918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -3946,7 +3946,7 @@ static int btusb_probe(struct usb_interf
 	if (id->driver_info & BTUSB_INTEL_COMBINED) {
 		err = btintel_configure_setup(hdev);
 		if (err)
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 
 		/* Transport specific configuration */
 		hdev->send = btusb_send_frame_intel;
@@ -4084,7 +4084,7 @@ static int btusb_probe(struct usb_interf
 		err = usb_set_interface(data->udev, 0, 0);
 		if (err < 0) {
 			BT_ERR("failed to set interface 0, alt 0 %d", err);
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 		}
 	}
 
@@ -4092,7 +4092,7 @@ static int btusb_probe(struct usb_interf
 		err = usb_driver_claim_interface(&btusb_driver,
 						 data->isoc, data);
 		if (err < 0)
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 	}
 
 	if (IS_ENABLED(CONFIG_BT_HCIBTUSB_BCM) && data->diag) {
@@ -4123,6 +4123,8 @@ err_release_siblings:
 		usb_set_intfdata(data->isoc, NULL);
 		usb_driver_release_interface(&btusb_driver, data->isoc);
 	}
+err_kill_tx_urbs:
+	usb_kill_anchored_urbs(&data->tx_anchor);
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);


