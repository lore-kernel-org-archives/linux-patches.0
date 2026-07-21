Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CEB44AB9F;
	Tue, 21 Jul 2026 22:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674588; cv=none; b=E31QLYaFZA+9wtmieMYZQLJSJL4jiT9c5NjS62DO8iHQVjYjt9ejzC1od41p8jZ7yM9essGICaKZjOTQ9JviZz+WVVmrCVnAsB8rM+b8qdZX5SNIN09vlRfQV1zk5RzwcH24degHEnq9bsGQr2RjPQRJzPWffvtWy8LKuatkr8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674588; c=relaxed/simple;
	bh=f5tpRQWiUOqUpCuM10lk3B3am8eEplaB5CJ2BsIY/Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhD3ofraQuMNDZcXVtjsrOJAivu3eJpjHDnTdSIKBee6LjGZdri16u45K93HzrIgX0EcSsr5k3jx4kDmp6b6AdlGZLqYv7kKi5Z9FxAbqTV6tkOdp18Ms9V46oNdNgMr1G9Hg7GM/L2vt+RE7+2eTN1NQxE/Fubygv13Kej1TBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTNAPCMD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTNAPCMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055FE1F000E9;
	Tue, 21 Jul 2026 22:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674583;
	bh=iPn9wIGwrTfZO17ez+42+kLAZVEVH7qGt02MEb4mlG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTNAPCMDLIMu5itGRETjvshmi5FNijx7L7M0SD8Wo+irZjLzzJ9FBQOKy9t9jdkBq
	 U11U+SYieCKy8mGHIkQsXKocQxDVPHQFcPX/blYGr/khvjp789v6TkAR+OXKAFj2pi
	 US1ZjTkOkiCw94c87N8gJZEu59fDaBd8Nf2HD3os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	Johan Hovold <johan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 597/699] Bluetooth: btusb: fix use-after-free on marvell probe failure
Date: Tue, 21 Jul 2026 17:25:56 +0200
Message-ID: <20260721152409.198134518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit c5b600a3c05b1a7a110d558df935a8fc8a471c79 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4352,7 +4352,7 @@ static int btusb_probe(struct usb_interf
 		err = usb_set_interface(data->udev, 0, 0);
 		if (err < 0) {
 			BT_ERR("failed to set interface 0, alt 0 %d", err);
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 		}
 	}
 
@@ -4360,7 +4360,7 @@ static int btusb_probe(struct usb_interf
 		err = usb_driver_claim_interface(&btusb_driver,
 						 data->isoc, data);
 		if (err < 0)
-			goto out_free_dev;
+			goto err_kill_tx_urbs;
 	}
 
 	if (IS_ENABLED(CONFIG_BT_HCIBTUSB_BCM) && data->diag) {
@@ -4391,6 +4391,8 @@ err_release_siblings:
 		usb_set_intfdata(data->isoc, NULL);
 		usb_driver_release_interface(&btusb_driver, data->isoc);
 	}
+err_kill_tx_urbs:
+	usb_kill_anchored_urbs(&data->tx_anchor);
 out_free_dev:
 	if (data->reset_gpio)
 		gpiod_put(data->reset_gpio);


