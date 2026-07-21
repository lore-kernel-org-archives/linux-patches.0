Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8124582E8;
	Tue, 21 Jul 2026 21:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668209; cv=none; b=FTXgDLUKK910boubcpSTQqnZJTD7c807rSZ5GY9xkfN8fSHCzqcEucaSqK6/GHlgpF6xLris5QGSIjzox8pk71up0pGb1+HOJKWWU0/muwvm0HZmNL9zvvrco3HKM89hgiB8qiQq1yhH5s3eFWLf9yps4/ps6wVVJa9mycbLB5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668209; c=relaxed/simple;
	bh=q0H8RokFXpqxfwg/gjZpFk51KrnZncpDsobXPs4eQqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lh0KlJZKGm82+tAxojVnVcwUwCJkofPOnjUuXUS3yswnsnjZ/wTC5tEaUirVeki8wcjO09p/k4hcuDwYAdi5FCTikrxvgnzsyPpLTkL65Vw14wUNQ11ThjvEk+0le0GlWf1jNQcd/Jp+ijQGsb9kwXadcjT9orYt6tjUVjF6eVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5WfXJ4b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5WfXJ4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A061F000E9;
	Tue, 21 Jul 2026 21:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668208;
	bh=EfznAavgPbAVlKe/mmNtE0jLFWqdZjZZSRYtr7aoYc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5WfXJ4bc7daRs03f9CtnAH9txLTx+Dj1LGX/iWBxVR1U8dhsHQlbUQDUtP+D4Z27
	 XwDyTAGj9X2HPvJRcyu8BVNsytDIbA2vULtDqJBDvjZMKP8oj2zX4G9kWgCXghKtTF
	 asMZtd8AYuW86JkLLrkF3/yocp7v6c4rLbHXY1Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0088/1067] Bluetooth: btusb: fix use-after-free on marvell probe failure
Date: Tue, 21 Jul 2026 17:11:29 +0200
Message-ID: <20260721152426.545654134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -4013,7 +4013,7 @@ static int btusb_probe(struct usb_interf
 	if (id->driver_info & BTUSB_INTEL_COMBINED) {
 		err = btintel_configure_setup(hdev);
 		if (err)
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 
 		/* Transport specific configuration */
 		hdev->send = btusb_send_frame_intel;
@@ -4161,7 +4161,7 @@ static int btusb_probe(struct usb_interf
 		err = usb_set_interface(data->udev, 0, 0);
 		if (err < 0) {
 			BT_ERR("failed to set interface 0, alt 0 %d", err);
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 		}
 	}
 
@@ -4169,7 +4169,7 @@ static int btusb_probe(struct usb_interf
 		err = usb_driver_claim_interface(&btusb_driver,
 						 data->isoc, data);
 		if (err < 0)
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 	}
 
 	if (IS_ENABLED(CONFIG_BT_HCIBTUSB_BCM) && data->diag) {
@@ -4203,6 +4203,8 @@ err_release_siblings:
 		usb_set_intfdata(data->isoc, NULL);
 		usb_driver_release_interface(&btusb_driver, data->isoc);
 	}
+err_kill_tx_urbs:
+	usb_kill_anchored_urbs(&data->tx_anchor);
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);


