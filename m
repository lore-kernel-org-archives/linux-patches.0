Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28683033E4;
	Wed, 28 Jan 2026 16:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616194; cv=none; b=k0Menr67wMCXMAcasBAvBYiAAPk6dp6xEKE3Y8OQadtCRK92U0SLco11sl1FK8v9Tu78IZ8VIX04lVtJ5pSpArB6fvyI2f7OVF/qAd3LoEU6/J87u9PAwBLjqBmKErjE7gNDfQidM5UXYbo9W4T1CjaPvHfQc5jDmr2bb1/oNcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616194; c=relaxed/simple;
	bh=9+itl2qFMu7VFkzrGaZdnlJlMlb1mZR/irnHM0t8wEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wlmoz17mMHjXldpXOZPJr3Eo7HcJOVB8QX3oGM6yXWBFhULLzDx2mBOVT0zpSmJo3+PD9CCUft32AnrJrxWeR+d3ZnjWEYLkcyMsdAK3G2V/rcGE7sqdK6QTEp8crSFz7WOU1Pma/QxBP8CvYs5hUuKfC3rZ5GIqBi6PVDVGM1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4d7ugtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4d7ugtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D38C4CEF1;
	Wed, 28 Jan 2026 16:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616193;
	bh=9+itl2qFMu7VFkzrGaZdnlJlMlb1mZR/irnHM0t8wEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4d7ugtjRIKF+WxYPGuJVgpJk1CvoLP88eZqevGoss7yDhXG/NVu/tjoB7o1ki6Up
	 oqJg62eaqHtK1tGyKCo4ZawNASu03rP1d7lSokFHX7EzCzEJqsjnUUZKPlZL2ubJqd
	 LQcRe+fu34B/cIWIoHEvZ3rKEmWuENQOY0NqtfZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 210/227] can: mcba_usb: mcba_usb_read_bulk_callback(): fix URB memory leak
Date: Wed, 28 Jan 2026 16:24:15 +0100
Message-ID: <20260128145351.991779993@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 710a7529fb13c5a470258ff5508ed3c498d54729 upstream.

Fix similar memory leak as in commit 7352e1d5932a ("can: gs_usb:
gs_usb_receive_bulk_callback(): fix URB memory leak").

In mcba_usb_probe() -> mcba_usb_start(), the URBs for USB-in transfers are
allocated, added to the priv->rx_submitted anchor and submitted. In the
complete callback mcba_usb_read_bulk_callback(), the URBs are processed and
resubmitted. In mcba_usb_close() -> mcba_urb_unlink() the URBs are freed by
calling usb_kill_anchored_urbs(&priv->rx_submitted).

However, this does not take into account that the USB framework unanchors
the URB before the complete function is called. This means that once an
in-URB has been completed, it is no longer anchored and is ultimately not
released in usb_kill_anchored_urbs().

Fix the memory leak by anchoring the URB in the
mcba_usb_read_bulk_callback()to the priv->rx_submitted anchor.

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260116-can_usb-fix-memory-leak-v2-4-4b8cb2915571@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/mcba_usb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -608,11 +608,17 @@ resubmit_urb:
 			  urb->transfer_buffer, MCBA_USB_RX_BUFF_SIZE,
 			  mcba_usb_read_bulk_callback, priv);
 
+	usb_anchor_urb(urb, &priv->rx_submitted);
+
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!retval)
+		return;
+
+	usb_unanchor_urb(urb);
 
 	if (retval == -ENODEV)
 		netif_device_detach(netdev);
-	else if (retval)
+	else
 		netdev_err(netdev, "failed resubmitting read bulk urb: %d\n",
 			   retval);
 }


