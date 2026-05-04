Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261D835A3AD;
	Mon,  4 May 2026 14:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904512; cv=none; b=Kb+0ctv2diUXBH6XSDzbexuu0T5vDj2f0EvXZIMJHyRv4Uf4sJXEjNfn0jwYCcPUl6zE5HJDh9r0FRM7gmhLgW6pwStGt4dEfY4wnHwFKbhh6vgJxcw0XfjJ0HAAAtMXN+QPKomETu6n1Bsd+HOUiaFOgusRBCWZHCcGS2LGs/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904512; c=relaxed/simple;
	bh=bZS2ycbsz2Dg5A84OaeW3kR+t13Xs+so64rbbVKxvrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SY57b1g27iym4CzjKkLjHP9dl1g53ee/u97xlhcBwf1H5zIwcWlWlO1JhKGoFDuCCLsaf+dDi+XwrCl1JZ/GLP32wEmDsGZk0mfh/MtfyunqTS+nQ02SgTUYTaVbzcrrqmmPwtJoxw5y3F/AodKCE4VxLZvX8TfSvhxddLYs0sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTOsCduV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTOsCduV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA303C2BCB8;
	Mon,  4 May 2026 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904512;
	bh=bZS2ycbsz2Dg5A84OaeW3kR+t13Xs+so64rbbVKxvrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTOsCduVf1dMu4l+4IJ2LC9CVkHsQD2pQQE/ITO4G3Kc5F5vQyV/jKTOGxqqjv4yt
	 jImf1FrCR492NbETglVKdLGQ8NAocT/zVyYjXoKGPzhxtFYvbDZOdUIGNhwrOMUaii
	 2HDlNK98tH0C4+JY/rHXV+T8v8+PaYUIt9zZET9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <jth@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 034/215] spi: ch341: fix memory leaks on probe failures
Date: Mon,  4 May 2026 15:50:53 +0200
Message-ID: <20260504135131.422566631@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

commit b99e3ddb91b499d920e63a2daff8880be68cfe9e upstream.

Make sure to deregister the controller, disable pins, and kill and free
the RX URB on probe failures to mirror disconnect and avoid memory
leaks and use-after-free.

Also add an explicit URB kill on disconnect for symmetry (even if that
is not strictly required as USB core would have stopped it in the
current setup).

Fixes: 8846739f52af ("spi: add ch341a usb2spi driver")
Cc: stable@vger.kernel.org	# 6.11
Cc: Johannes Thumshirn <jth@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260327104305.1309915-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ch341.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

--- a/drivers/spi/spi-ch341.c
+++ b/drivers/spi/spi-ch341.c
@@ -173,17 +173,17 @@ static int ch341_probe(struct usb_interf
 
 	ch341->tx_buf =
 		devm_kzalloc(&udev->dev, CH341_PACKET_LENGTH, GFP_KERNEL);
-	if (!ch341->tx_buf)
-		return -ENOMEM;
+	if (!ch341->tx_buf) {
+		ret = -ENOMEM;
+		goto err_free_urb;
+	}
 
 	usb_fill_bulk_urb(ch341->rx_urb, udev, ch341->read_pipe, ch341->rx_buf,
 			  ch341->rx_len, ch341_recv, ch341);
 
 	ret = usb_submit_urb(ch341->rx_urb, GFP_KERNEL);
-	if (ret) {
-		usb_free_urb(ch341->rx_urb);
-		return -ENOMEM;
-	}
+	if (ret)
+		goto err_free_urb;
 
 	ctrl->bus_num = -1;
 	ctrl->mode_bits = SPI_CPHA;
@@ -195,21 +195,34 @@ static int ch341_probe(struct usb_interf
 
 	ret = ch341_config_stream(ch341);
 	if (ret)
-		return ret;
+		goto err_kill_urb;
 
 	ret = ch341_enable_pins(ch341, true);
 	if (ret)
-		return ret;
+		goto err_kill_urb;
 
 	ret = spi_register_controller(ctrl);
 	if (ret)
-		return ret;
+		goto err_disable_pins;
 
 	ch341->spidev = spi_new_device(ctrl, &chip);
-	if (!ch341->spidev)
-		return -ENOMEM;
+	if (!ch341->spidev) {
+		ret = -ENOMEM;
+		goto err_unregister;
+	}
 
 	return 0;
+
+err_unregister:
+	spi_unregister_controller(ctrl);
+err_disable_pins:
+	ch341_enable_pins(ch341, false);
+err_kill_urb:
+	usb_kill_urb(ch341->rx_urb);
+err_free_urb:
+	usb_free_urb(ch341->rx_urb);
+
+	return ret;
 }
 
 static void ch341_disconnect(struct usb_interface *intf)
@@ -219,6 +232,7 @@ static void ch341_disconnect(struct usb_
 	spi_unregister_device(ch341->spidev);
 	spi_unregister_controller(ch341->ctrl);
 	ch341_enable_pins(ch341, false);
+	usb_kill_urb(ch341->rx_urb);
 	usb_free_urb(ch341->rx_urb);
 }
 


