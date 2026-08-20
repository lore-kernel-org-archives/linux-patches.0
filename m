Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B6F37A858;
	Thu, 20 Aug 2026 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244286; cv=none; b=O9RZvpENa7nQo2kFQSRK+tZTSgQK9AKuxvyFuFFxvptbGp6VMpirCpbmdYFjRoMC5ad7Fm9pj0AXu8vHJPfyftTDc8PPwhbRU/BxgIiFiZaajv9qg7p4wv3O2G0fYbSe1TInYmzwgJ19Pk7QJTylW5Tpn0aKoZbe/qzSpxktH6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244286; c=relaxed/simple;
	bh=1Ft23HaaYVO9K3d8x3bAcTyPpT2b+0Sp8Pi+SnCZKn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uclPIELCxMGZfKqL5BiJGtnbs+N4BVCEMPSSVmsrWzQ/Bn3XTs99r1r+ZgSnN52DWnatgjHBzaMYF7q2B2DJCtlgp2jZannxDEPpO5XqRLPlqtRQ6AvLgm+6G3DKpLCsZhuoI5FbUCEv0Hf1dNYfW1JDUN3iY/v+hpY/OgUVl7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eR5gdoeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eR5gdoeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C5B1F000E9;
	Thu, 20 Aug 2026 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244285;
	bh=WqrpIC4MYHDdUqcxZXQZCC3F6s4qWuebMp85MolUWq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eR5gdoeMToBZvJ+HeC5aFHew646vjccujQZh0rH7IzzrIZJLY0grrdwRVqzuYFeVu
	 S9I05rzmBup8Bck8Hd9xzR45VHfDHeJwPKDSMJ0E9G1hhhRAkicvrP8ITprApaNTXL
	 L/dPJ4/7gQUErasXHEo0kSa2He7TWn2XajcvPFQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 116/235] mmc: vub300: fix use-after-free on disconnect
Date: Thu, 20 Aug 2026 16:55:52 +0200
Message-ID: <20260820145219.968448566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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
(cherry picked from commit 8f4d20a710225ec7a565f6a0459862d3b1f32330)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2281,7 +2281,7 @@ static int vub300_probe(struct usb_inter
 		dev_err(&vub300->udev->dev,
 		    "Could not find two sets of bulk-in/out endpoint pairs\n");
 		retval = -EINVAL;
-		goto error5;
+		goto err_free_host;
 	}
 	retval =
 		usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
@@ -2290,14 +2290,14 @@ static int vub300_probe(struct usb_inter
 				0x0000, 0x0000, &vub300->hc_info,
 				sizeof(vub300->hc_info), 1000);
 	if (retval < 0)
-		goto error5;
+		goto err_free_host;
 	retval =
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_ROM_WAIT_STATES,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				firmware_rom_wait_states, 0x0000, NULL, 0, 1000);
 	if (retval < 0)
-		goto error5;
+		goto err_free_host;
 	dev_info(&vub300->udev->dev,
 		 "operating_mode = %s %s %d MHz %s %d byte USB packets\n",
 		 (mmc->caps & MMC_CAP_SDIO_IRQ) ? "IRQs" : "POLL",
@@ -2312,7 +2312,7 @@ static int vub300_probe(struct usb_inter
 				0x0000, 0x0000, &vub300->system_port_status,
 				sizeof(vub300->system_port_status), 1000);
 	if (retval < 0) {
-		goto error5;
+		goto err_free_host;
 	} else if (sizeof(vub300->system_port_status) == retval) {
 		vub300->card_present =
 			(0x0001 & vub300->system_port_status.port_flags) ? 1 : 0;
@@ -2320,7 +2320,7 @@ static int vub300_probe(struct usb_inter
 			(0x0010 & vub300->system_port_status.port_flags) ? 1 : 0;
 	} else {
 		retval = -EINVAL;
-		goto error5;
+		goto err_free_host;
 	}
 	usb_set_intfdata(interface, vub300);
 	INIT_DELAYED_WORK(&vub300->pollwork, vub300_pollwork_thread);
@@ -2350,7 +2350,7 @@ static int vub300_probe(struct usb_inter
 	return 0;
 error6:
 	del_timer_sync(&vub300->inactivity_timer);
-error5:
+err_free_host:
 	mmc_free_host(mmc);
 	/*
 	 * and hence also frees vub300


