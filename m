Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7323C2C026C;
	Sat, 17 Oct 2026 16:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254368; cv=none; b=Vh3Lc7DmcZkrzFXUPM4xk2cGFo3MO78OBqfwPf3lE4oEz2RvhaN6/vIhc4WKF+WClkb3EPfrYIVgbamtI1rFlHdYznkvyEiv03ggSHL+rgXbEUzmPquetXJovngNMDRg/65Uvjx47cRnrTH0NgJ9n0L4UQyhCdxFeLCeCNGy4Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254368; c=relaxed/simple;
	bh=FQ3wHw0PrsEK1aYeUxGVmsAQqQ9EESNYg5T9Z69Lcs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8j+xfNuSBdulYhdKwYK/ddHcL0+MVw9GgU1Uwjndysw7JnnSYiw+o/9K1H4tzcHq8pFD18GygjBPYr8xzPoUNHgB2ceUm4bvHeQVgJxmk67jDK6b5e5oeqhrvsJewHY55dA0cvATYt4K1MVr+NJowrC/BR+EoO3RvmdPayFCq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAYM5/90; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAYM5/90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0FC1F000C4;
	Sat, 17 Oct 2026 16:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254367;
	bh=Yr27pXmT37x5+iaOlwyydrtbsvNMf3fXrRgy1Q3wkOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAYM5/90nov5MTSbudSpD14lU59J94PtVv2PQCVgf3eUKWcQZ+Tus8hIKaGql1tJV
	 9yDk2ELyMxmGHoz1jr76zVYhOxjxyEvsmEK3hEoEo6YhkWzyVZxi5ROXd1K4L3HzlG
	 VsC3jN8T8sCodRwE8WapgNtph9gT2Yt8fcE98j0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 421/869] mmc: vub300: Use devm_mmc_alloc_host() helper
Date: Sat, 17 Oct 2026 17:54:22 +0200
Message-ID: <20261017160047.932586238@linuxfoundation.org>
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

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit dcfdd698dc521c6046e9b80c16281575efb25d23 ]

Use new function devm_mmc_alloc_host() to simplify the code.

Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Link: https://lore.kernel.org/r/f023d2caa02fab405f089c5170b686529857fb70.1748933789.git.zhoubinbin@loongson.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: a3b5f242997a ("mmc: vub300: fix use-after-free on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/vub300.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 35393f534de2b..2b0623cf34c90 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -369,13 +369,11 @@ struct vub300_mmc_host {
 static void vub300_delete(struct kref *kref)
 {				/* kref callback - softirq */
 	struct vub300_mmc_host *vub300 = kref_to_vub300_mmc_host(kref);
-	struct mmc_host *mmc = vub300->mmc;
 	usb_free_urb(vub300->command_out_urb);
 	vub300->command_out_urb = NULL;
 	usb_free_urb(vub300->command_res_urb);
 	vub300->command_res_urb = NULL;
 	usb_put_dev(vub300->udev);
-	mmc_free_host(mmc);
 	/*
 	 * and hence also frees vub300
 	 * which is contained at the end of struct mmc
@@ -2122,7 +2120,7 @@ static int vub300_probe(struct usb_interface *interface,
 		goto error1;
 	}
 	/* this also allocates memory for our VUB300 mmc host device */
-	mmc = mmc_alloc_host(sizeof(struct vub300_mmc_host), &udev->dev);
+	mmc = devm_mmc_alloc_host(&udev->dev, sizeof(*vub300));
 	if (!mmc) {
 		retval = -ENOMEM;
 		dev_err(&udev->dev, "not enough memory for the mmc_host\n");
@@ -2279,7 +2277,7 @@ static int vub300_probe(struct usb_interface *interface,
 		dev_err(&vub300->udev->dev,
 		    "Could not find two sets of bulk-in/out endpoint pairs\n");
 		retval = -EINVAL;
-		goto error5;
+		goto error4;
 	}
 	retval =
 		usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
@@ -2288,14 +2286,14 @@ static int vub300_probe(struct usb_interface *interface,
 				0x0000, 0x0000, &vub300->hc_info,
 				sizeof(vub300->hc_info), 1000);
 	if (retval < 0)
-		goto error5;
+		goto error4;
 	retval =
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_ROM_WAIT_STATES,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				firmware_rom_wait_states, 0x0000, NULL, 0, 1000);
 	if (retval < 0)
-		goto error5;
+		goto error4;
 	dev_info(&vub300->udev->dev,
 		 "operating_mode = %s %s %d MHz %s %d byte USB packets\n",
 		 (mmc->caps & MMC_CAP_SDIO_IRQ) ? "IRQs" : "POLL",
@@ -2310,7 +2308,7 @@ static int vub300_probe(struct usb_interface *interface,
 				0x0000, 0x0000, &vub300->system_port_status,
 				sizeof(vub300->system_port_status), 1000);
 	if (retval < 0) {
-		goto error5;
+		goto error4;
 	} else if (sizeof(vub300->system_port_status) == retval) {
 		vub300->card_present =
 			(0x0001 & vub300->system_port_status.port_flags) ? 1 : 0;
@@ -2318,7 +2316,7 @@ static int vub300_probe(struct usb_interface *interface,
 			(0x0010 & vub300->system_port_status.port_flags) ? 1 : 0;
 	} else {
 		retval = -EINVAL;
-		goto error5;
+		goto error4;
 	}
 	usb_set_intfdata(interface, vub300);
 	INIT_DELAYED_WORK(&vub300->pollwork, vub300_pollwork_thread);
@@ -2348,8 +2346,6 @@ static int vub300_probe(struct usb_interface *interface,
 	return 0;
 error6:
 	del_timer_sync(&vub300->inactivity_timer);
-error5:
-	mmc_free_host(mmc);
 	/*
 	 * and hence also frees vub300
 	 * which is contained at the end of struct mmc
-- 
2.53.0



