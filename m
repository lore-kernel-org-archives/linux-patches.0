Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0F538654F;
	Sat, 17 Oct 2026 16:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254371; cv=none; b=SvGtbtQBLIC+rqzrgh5w1vivbGYEEs7Rmzram6WK5SiL2zK8YuErJb7se5k/siGSiHToYVC6nioFHG0StEhT4BanjChbbvjT3iUwmJm0spQ3ecdsceeoZXxle47rQROjFlbbV5QKhCG82hiSc1mE6FRUKBHnVBZKpOqkEkfMw3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254371; c=relaxed/simple;
	bh=7IlxLdAEG8Bk0F+GWi77dkpLIri6s+gn6cwjXWu/r9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keEWHJQa8/ffe5za74JM+bR78rdQeJt+Je9tS/lDgo+578cjRjI4kpcxcgiMm6EEnuLtkkPbu+339X0vUZ8B6O4xkhAZ4iuYO8jpn4UKBLZ0A55tMcqspAhuvuJ/nAgbPrBN0JRLdiw2JWXP65i1vruyyrZUhq4LW4O0BscFk5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+JMHVMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+JMHVMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3BC1F000C4;
	Sat, 17 Oct 2026 16:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254370;
	bh=dSD6H8xnEjtAapQ0U3gZo/3seYLvO/ZMT8PJmNyYPNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+JMHVMnxqceQRiF8XNNVtc+vp7U/pv2SVK7XOnXs4OQCYx/vlxP/fyVl+2tRxuHh
	 o52pY0vuQBtxe4VKf+EIjonadt2lQ6Zkmisc18R50X8fTw5VAbx+8Tj+l9F8lhuNI+
	 mYPt/9+r4LdsTb5D2uJe7kmXCYxoGCbB+L5seh80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 422/869] mmc: vub300: fix use-after-free on disconnect
Date: Sat, 17 Oct 2026 17:54:23 +0200
Message-ID: <20261017160047.956961288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 8f4d20a710225ec7a565f6a0459862d3b1f32330 ]

The vub300 driver maintains an explicit reference count for the
controller and its driver data and the last reference can in theory be
dropped after the driver has been unbound.

This specifically means that the controller allocation must not be
device managed as that can lead to use-after-free.

Note that the lifetime is currently also incorrectly tied the parent USB
device rather than interface, which can lead to memory leaks if the
driver is unbound without its device being physically disconnected (e.g.
on probe deferral).

Fix both issues by reverting to non-managed allocation of the controller.

Fixes: dcfdd698dc52 ("mmc: vub300: Use devm_mmc_alloc_host() helper")
Cc: stable@vger.kernel.org # 6.17+
Cc: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: a3b5f242997a ("mmc: vub300: fix use-after-free on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/vub300.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 2b0623cf34c90..937b9644f958c 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -369,11 +369,14 @@ struct vub300_mmc_host {
 static void vub300_delete(struct kref *kref)
 {				/* kref callback - softirq */
 	struct vub300_mmc_host *vub300 = kref_to_vub300_mmc_host(kref);
+	struct mmc_host *mmc = vub300->mmc;
+
 	usb_free_urb(vub300->command_out_urb);
 	vub300->command_out_urb = NULL;
 	usb_free_urb(vub300->command_res_urb);
 	vub300->command_res_urb = NULL;
 	usb_put_dev(vub300->udev);
+	mmc_free_host(mmc);
 	/*
 	 * and hence also frees vub300
 	 * which is contained at the end of struct mmc
@@ -2120,7 +2123,7 @@ static int vub300_probe(struct usb_interface *interface,
 		goto error1;
 	}
 	/* this also allocates memory for our VUB300 mmc host device */
-	mmc = devm_mmc_alloc_host(&udev->dev, sizeof(*vub300));
+	mmc = mmc_alloc_host(sizeof(*vub300), &udev->dev);
 	if (!mmc) {
 		retval = -ENOMEM;
 		dev_err(&udev->dev, "not enough memory for the mmc_host\n");
@@ -2277,7 +2280,7 @@ static int vub300_probe(struct usb_interface *interface,
 		dev_err(&vub300->udev->dev,
 		    "Could not find two sets of bulk-in/out endpoint pairs\n");
 		retval = -EINVAL;
-		goto error4;
+		goto err_free_host;
 	}
 	retval =
 		usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
@@ -2286,14 +2289,14 @@ static int vub300_probe(struct usb_interface *interface,
 				0x0000, 0x0000, &vub300->hc_info,
 				sizeof(vub300->hc_info), 1000);
 	if (retval < 0)
-		goto error4;
+		goto err_free_host;
 	retval =
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_ROM_WAIT_STATES,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				firmware_rom_wait_states, 0x0000, NULL, 0, 1000);
 	if (retval < 0)
-		goto error4;
+		goto err_free_host;
 	dev_info(&vub300->udev->dev,
 		 "operating_mode = %s %s %d MHz %s %d byte USB packets\n",
 		 (mmc->caps & MMC_CAP_SDIO_IRQ) ? "IRQs" : "POLL",
@@ -2308,7 +2311,7 @@ static int vub300_probe(struct usb_interface *interface,
 				0x0000, 0x0000, &vub300->system_port_status,
 				sizeof(vub300->system_port_status), 1000);
 	if (retval < 0) {
-		goto error4;
+		goto err_free_host;
 	} else if (sizeof(vub300->system_port_status) == retval) {
 		vub300->card_present =
 			(0x0001 & vub300->system_port_status.port_flags) ? 1 : 0;
@@ -2316,7 +2319,7 @@ static int vub300_probe(struct usb_interface *interface,
 			(0x0010 & vub300->system_port_status.port_flags) ? 1 : 0;
 	} else {
 		retval = -EINVAL;
-		goto error4;
+		goto err_free_host;
 	}
 	usb_set_intfdata(interface, vub300);
 	INIT_DELAYED_WORK(&vub300->pollwork, vub300_pollwork_thread);
@@ -2341,11 +2344,14 @@ static int vub300_probe(struct usb_interface *interface,
 			 interface_to_InterfaceNumber(interface));
 	retval = mmc_add_host(mmc);
 	if (retval)
-		goto error6;
+		goto err_delete_timer;
 
 	return 0;
-error6:
-	del_timer_sync(&vub300->inactivity_timer);
+
+err_delete_timer:
+	timer_delete_sync(&vub300->inactivity_timer);
+err_free_host:
+	mmc_free_host(mmc);
 	/*
 	 * and hence also frees vub300
 	 * which is contained at the end of struct mmc
-- 
2.53.0



