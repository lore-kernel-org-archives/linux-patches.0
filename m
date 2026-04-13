Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4172E888C;
	Mon, 13 Apr 2026 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096328; cv=none; b=m4y95YRUZl4SGLmeOdgL4mVggN4HJgkfqiIT/PstnAnqSLGcKQ8H0IkEIRnlIXsQKeZmfiz6sEzu8YT0sWhAkjgXuOKieCb4f6dSGQm+b8t0YI/A4ArYRlVdaLXDEr6dTDFzLR0heNW4XxmXTiCVYosyDYwQ9z02C1evAwihj7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096328; c=relaxed/simple;
	bh=eogl/1cVdn5XmgijZlrRgLkbsZkpY7wOs02E2RStGuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnU/nlFRFAjTHWzcgbYlG+nqdTpT3SnVBYACiu5avjcHrwlMGb0YoRGWox8zjMofQX3jHRGPumqRjWf11YZZDGwF/71ZnERp9geCloFOSXY+xTH+X6sEdd3vfcf8j4xb1FGBS2BkfJmB42hs5Cc4w1KI2wZ8BOxG4kfVppmKIV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yv90oISE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yv90oISE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D3EC2BCAF;
	Mon, 13 Apr 2026 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096328;
	bh=eogl/1cVdn5XmgijZlrRgLkbsZkpY7wOs02E2RStGuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yv90oISEChvcl1ZwjniW9p6nyUDfF+9MGi6fjZPcc8ytIY/H/ZzoT/qsWVUONkiCy
	 HPvJ1e5eBEeK869cG4FefNcMkiOciGsLihz4B26MQEJs4Nw3iUNJlNvixR/9CjbiNo
	 CZjWPiuTPypnuALpXNYgmx/C5srNPc/gtq002pbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.19 55/86] mmc: vub300: fix use-after-free on disconnect
Date: Mon, 13 Apr 2026 18:00:02 +0200
Message-ID: <20260413155733.619702376@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 8f4d20a710225ec7a565f6a0459862d3b1f32330 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

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
@@ -2112,7 +2115,7 @@ static int vub300_probe(struct usb_inter
 		goto error1;
 	}
 	/* this also allocates memory for our VUB300 mmc host device */
-	mmc = devm_mmc_alloc_host(&udev->dev, sizeof(*vub300));
+	mmc = mmc_alloc_host(sizeof(*vub300), &udev->dev);
 	if (!mmc) {
 		retval = -ENOMEM;
 		dev_err(&udev->dev, "not enough memory for the mmc_host\n");
@@ -2269,7 +2272,7 @@ static int vub300_probe(struct usb_inter
 		dev_err(&vub300->udev->dev,
 		    "Could not find two sets of bulk-in/out endpoint pairs\n");
 		retval = -EINVAL;
-		goto error4;
+		goto err_free_host;
 	}
 	retval =
 		usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
@@ -2278,14 +2281,14 @@ static int vub300_probe(struct usb_inter
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
@@ -2300,7 +2303,7 @@ static int vub300_probe(struct usb_inter
 				0x0000, 0x0000, &vub300->system_port_status,
 				sizeof(vub300->system_port_status), 1000);
 	if (retval < 0) {
-		goto error4;
+		goto err_free_host;
 	} else if (sizeof(vub300->system_port_status) == retval) {
 		vub300->card_present =
 			(0x0001 & vub300->system_port_status.port_flags) ? 1 : 0;
@@ -2308,7 +2311,7 @@ static int vub300_probe(struct usb_inter
 			(0x0010 & vub300->system_port_status.port_flags) ? 1 : 0;
 	} else {
 		retval = -EINVAL;
-		goto error4;
+		goto err_free_host;
 	}
 	usb_set_intfdata(interface, vub300);
 	INIT_DELAYED_WORK(&vub300->pollwork, vub300_pollwork_thread);
@@ -2338,6 +2341,8 @@ static int vub300_probe(struct usb_inter
 	return 0;
 error6:
 	timer_delete_sync(&vub300->inactivity_timer);
+err_free_host:
+	mmc_free_host(mmc);
 	/*
 	 * and hence also frees vub300
 	 * which is contained at the end of struct mmc


