Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB88135A3AD;
	Mon,  4 May 2026 14:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903724; cv=none; b=K2olZI/scjaCeR8LwmwgIdEOPRXT6CuFTcE14JCkszqjxVvHHTHkX6Q30jUsTBaZrn1uUbyGpZpuKdyIk77rYONwnP8rB5OK0ItKwI2IJw3Z0sSTfVo7eG0TQU0dc/Q3LoonIEYLHjzrlH8tILpR1EVeHS3zFT5hz+RnWR2Ibnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903724; c=relaxed/simple;
	bh=XK9GyH6c6Y0o6meJIGtlkgZ5XLmem6ptvQBEI2sxZUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmPmGVPqgTPKyaAZJMxR0tM8uTCOoEoKF58yuEBbuhqFhIVyopY8p5vcttKp/vNCoTPFAO6E2ml57fhTAuvrzVn085aENdv0lAZQmy49EGi+bcpToueX69b2Vg4ueeDMax8TKSs23cB5hm7oXaXMzGnBxj8DNV4Ew6cBaz3zuVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUCn7kTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUCn7kTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0D7C2BCB8;
	Mon,  4 May 2026 14:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903724;
	bh=XK9GyH6c6Y0o6meJIGtlkgZ5XLmem6ptvQBEI2sxZUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUCn7kTvskduPFQYOTFoOOgSnfUxkZ5G0rliG33sb/DlKCDCuOYx32AiPsTb+mb/o
	 sbOjCeLjCZ/BkcJ+aswiZzTnYOaGWR25s1IlKrvysA/+uYNfyQJ9Au2HQn3LrngNLu
	 324BQvkKeLH1ZPCDm//3jQvsi4Dm79cV1DCT2P4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <jth@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 037/275] spi: ch341: fix memory leaks on probe failures
Date: Mon,  4 May 2026 15:49:37 +0200
Message-ID: <20260504135144.316533747@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


