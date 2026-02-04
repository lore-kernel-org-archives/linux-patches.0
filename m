Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A10285404;
	Wed,  4 Feb 2026 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217329; cv=none; b=Kw6H7u0YhxPIeqSwA149u9Q3KtG5fG9t0Vh+wq9Ajhm2TMcMwzfw6ZJpfgyqQ1dQDxDtTnsk6iKj8lsLeCjckqfVkCchjtT4IFk1LR0yChZCT+H6Go1XDdBPQFkFqvfdKo8ixYgDv4Qwx5yaMg4cyXrmCsR4UIkWUW1nm//IdQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217329; c=relaxed/simple;
	bh=7NqI4bhQE/IocWjm82ZA/pWsaxPhcP+1D1uBC6Jo/as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp3ob0JIqtIWKuEJqPjzW6YmuhFwxv3pDdgxml5dod4pUTGoCO/kvZeonIAELiQCbdHDjIx9iRqEUI0AMYi32J3nUsUwjOES6XnPSKtQJJfTWbg/x+LAMu4Y6W69jGqudWLKk3RvoNnkyn2xbC7QcqUk7I04MlqAPXL37zwFuBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIqIdXI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIqIdXI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB1EC4CEF7;
	Wed,  4 Feb 2026 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217329;
	bh=7NqI4bhQE/IocWjm82ZA/pWsaxPhcP+1D1uBC6Jo/as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIqIdXI8+VW/4ipxl49k2jRWDqtcshl1DWHI24oHmiJ6LleKzRXbFEfKwQ8+ilmGm
	 7gGEaef0mVolfc/fZcA7HcHGJS+D6e7KHWEVTB4Dl/jZw6NGMs2V1RZjR4DYMlVec1
	 uYQcCtqU7YhqaAd7cBN/9au0C3aoa8uaVIJG3pGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 191/206] can: esd_usb: esd_usb_read_bulk_callback(): fix URB memory leak
Date: Wed,  4 Feb 2026 15:40:22 +0100
Message-ID: <20260204143905.103860466@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/can/usb/esd_usb2.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -440,13 +440,20 @@ resubmit_urb:
 			  urb->transfer_buffer, RX_BUFFER_SIZE,
 			  esd_usb2_read_bulk_callback, dev);
 
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


