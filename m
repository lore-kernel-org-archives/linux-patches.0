Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188392E2F0E;
	Mon,  4 May 2026 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902943; cv=none; b=e3tQNtp7TC5yV8ThsUHwZSJsvNCFP38lUEOu/tohAVUMa21BF/bZrGsW8vOXv5VRd2am8iSjQEQgAjgN1Zq0A9jqqy24Gk+47y+hzTgtxQftNCfcZJSDfwiwTpzsE5o5rjJq22drqM2lvyW4mILM0F9lC+4DnMpdnWfKmirD3lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902943; c=relaxed/simple;
	bh=dE40IZRpxioTX+tE+Lyrd4oWPXt7QdEvqlfWfiNN5qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeS/IO3hGinvDXkFFDDeMus2tx/z0GT/6PLx/xgacbS3nJPIL/IkfnNOkXh8FqoMNtfeZZ5ZNkiZJH5MSzb0DLz0CBoie9G2HbM+9/ejHJ7Zii5VUU0iKV3FDYpH0ZQ2lw9X/n8BUJAWLqPBmLARDUCnQSNhlp/SC1iu7jqCTV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdGBrpxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdGBrpxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EA5C2BCB8;
	Mon,  4 May 2026 13:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902943;
	bh=dE40IZRpxioTX+tE+Lyrd4oWPXt7QdEvqlfWfiNN5qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdGBrpxManBtgEGDS6cROlxf/UqcoXRz1T+D48wXNVO9zpeOcLelXSjvzspeZXwlc
	 coDBiZEdzXkSZ+q/QAgN8lvQPS0rBJrG0f+qnFqBGtySiflY63N7m2p/Etwpkxv6m8
	 e+kAjt4XOTG9pBkSxtVbZkagQP9EkbdHuBqE5A3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <jth@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 043/307] spi: ch341: fix memory leaks on probe failures
Date: Mon,  4 May 2026 15:48:48 +0200
Message-ID: <20260504135144.455877314@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 


