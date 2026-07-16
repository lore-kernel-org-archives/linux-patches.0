Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636E8423E84;
	Thu, 16 Jul 2026 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209259; cv=none; b=EmqSkbEYCoZO2x+mtZxg+0RyzKOF8nabzQrmUXwyrOIr0e0b7NTEWhxAwo8FYnJYlXqywOIQfZn8PGpcEM4ytzC6uJg69LHtEz1uUL7kcBH/YFoYguqzB0UUySA8QiS6vBGr6cvaGRhSf64icl9hFVksCIkba3XZfaJbKtDB5IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209259; c=relaxed/simple;
	bh=ARseLUq06c9hgHJs6WPoSl7eK3L9wLjDAAdH01CPaus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIkU0Ja0KnTNBvX6Yo+wU3mAxpEyHjT1gvUXk8l/Sq4HuWlUbPYzavj2rk/jjYh+G1gf2Oa2KWiqm1k5p5MC8TlEXuLwJXtshTAQT89hw4/9NX89W9KeCoAX6papGRezUu0efxUxNoWTSiEwD4YytLu2kFhUSdxq6NlNXJKViyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VFSy5eO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VFSy5eO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B151F00A3A;
	Thu, 16 Jul 2026 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209258;
	bh=9x3IPFGJVmX59k0aAoMXkeb1sXfz20WN6RShaIEZWuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0VFSy5eOzqz3zw8xTXqHqmGDaNTLCtmvZial6mZpBF+5U/rXFxnsDP5X+8nmjwplM
	 OPgjG7UBJlqWEsChnhOVrPhr/S+XE5oyRw1A46dXYuwf3B5wx5TX05rWMo1K0ZVjdo
	 bdK9HfBWPADnqoXj3pg6rQrQcIAlJyJIEQI6dVs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 115/518] Bluetooth: btusb: fix use-after-free on marvell probe failure
Date: Thu, 16 Jul 2026 15:26:23 +0200
Message-ID: <20260716133050.368861313@linuxfoundation.org>
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
@@ -4220,7 +4220,7 @@ static int btusb_probe(struct usb_interf
 	if (id->driver_info & BTUSB_INTEL_COMBINED) {
 		err = btintel_configure_setup(hdev, btusb_driver.name);
 		if (err)
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 
 		/* Transport specific configuration */
 		hdev->send = btusb_send_frame_intel;
@@ -4383,7 +4383,7 @@ static int btusb_probe(struct usb_interf
 		err = usb_set_interface(data->udev, 0, 0);
 		if (err < 0) {
 			BT_ERR("failed to set interface 0, alt 0 %d", err);
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 		}
 	}
 
@@ -4391,7 +4391,7 @@ static int btusb_probe(struct usb_interf
 		err = usb_driver_claim_interface(&btusb_driver,
 						 data->isoc, data);
 		if (err < 0)
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 	}
 
 	if (IS_ENABLED(CONFIG_BT_HCIBTUSB_BCM) && data->diag) {
@@ -4427,6 +4427,8 @@ err_release_siblings:
 		usb_set_intfdata(data->isoc, NULL);
 		usb_driver_release_interface(&btusb_driver, data->isoc);
 	}
+err_kill_tx_urbs:
+	usb_kill_anchored_urbs(&data->tx_anchor);
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);


