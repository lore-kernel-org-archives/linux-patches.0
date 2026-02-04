Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0148C2D978A;
	Wed,  4 Feb 2026 15:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218248; cv=none; b=o7qYmR6KR5i3GLaRZjX/oNOeHoVQWC998RGI9jioJ2FS5Pcg6GxDo1ygyxLmvhkiqQuxqFuCyEKM9ATsNAQbkZBGDhdF71RmEohPlh3u33SRbE2QTWM45P7nxTEoavC9I8zGcqUZvciymVAzdlbJADIyLAnfjYy9/S9EdrE6rb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218248; c=relaxed/simple;
	bh=kKD9FzeYbrD9sxiVY/25Mag6zA3mBUM4bat6bzK9NyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BozjuLP0b/YowIPgpA4A5F+e41oRK4YWqPU5D4/NoBRoKwjANTjZT4QESJQ277/zfA0gtObMpBuziuaItJK1bz6y+XrFpKOAAzeaQ1anh4GYbvWOKR/0eZJ+QKkPCojfdbFBAJ00EIhwAzw7JnDRbyvNaJcxfiKxa0bQg9Cg6fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCzdix4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCzdix4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670BEC4CEF7;
	Wed,  4 Feb 2026 15:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218247;
	bh=kKD9FzeYbrD9sxiVY/25Mag6zA3mBUM4bat6bzK9NyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCzdix4JYfDmsp23ogAsxmNVBrDplHImqZeAOyMlPxBuqdnIvltobuooaEeLLCenb
	 mvZXuXPEChr2Aw79iTs+tuyR8woMl0aQ91y5G+QUa/xMGvwL7MY7P3xgqs8Yp8O6r+
	 R7Zt1lnPoiVJdTycAemF9pWErSn+g89Hz2lTx0j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 255/280] can: esd_usb: esd_usb_read_bulk_callback(): fix URB memory leak
Date: Wed,  4 Feb 2026 15:40:29 +0100
Message-ID: <20260204143918.823466550@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 5a4391bdc6c8357242f62f22069c865b792406b3 upstream.

Fix similar memory leak as in commit 7352e1d5932a ("can: gs_usb:
gs_usb_receive_bulk_callback(): fix URB memory leak").

In esd_usb_open(), the URBs for USB-in transfers are allocated, added to
the dev->rx_submitted anchor and submitted. In the complete callback
esd_usb_read_bulk_callback(), the URBs are processed and resubmitted. In
esd_usb_close() the URBs are freed by calling
usb_kill_anchored_urbs(&dev->rx_submitted).

However, this does not take into account that the USB framework unanchors
the URB before the complete function is called. This means that once an
in-URB has been completed, it is no longer anchored and is ultimately not
released in esd_usb_close().

Fix the memory leak by anchoring the URB in the
esd_usb_read_bulk_callback() to the dev->rx_submitted anchor.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260116-can_usb-fix-memory-leak-v2-2-4b8cb2915571@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/esd_usb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -447,13 +447,20 @@ resubmit_urb:
 			  urb->transfer_buffer, RX_BUFFER_SIZE,
 			  esd_usb_read_bulk_callback, dev);
 
+	usb_anchor_urb(urb, &dev->rx_submitted);
+
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!retval)
+		return;
+
+	usb_unanchor_urb(urb);
+
 	if (retval == -ENODEV) {
 		for (i = 0; i < dev->net_count; i++) {
 			if (dev->nets[i])
 				netif_device_detach(dev->nets[i]->netdev);
 		}
-	} else if (retval) {
+	} else {
 		dev_err(dev->udev->dev.parent,
 			"failed resubmitting read bulk urb: %d\n", retval);
 	}


