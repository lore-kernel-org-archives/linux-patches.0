Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394E31E520C;
	Wed,  4 Feb 2026 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217994; cv=none; b=MhyZMk+H0QmBOQPuebuP5x41xID2GIpeC4W5pleMNsVjDm83uv9l6W3+CCmCWQ2T/Rkyc92Rzv0C9vmzj+3IFTH480T4oZkqM91TcZg37Myb78X2Z1CRQW2u7x+uN17nn075PR3SyoWBXlYYusoCNVjbgUbYIp5A/xOi/Q3k0Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217994; c=relaxed/simple;
	bh=S7JJNJuYr//FpFyzX3dpF7eOLYS8Ng46ytA7755l1qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS6wk8sdF2+y2xWTuzaEJ1uiMqoVV2PVZc2STfN7ngHhxdvFzq4MdkPkv8tZSg6Skk4t31GZBhOHBqAHlDhRlntGDj9BQzvQ77BFDwnZKhphGK33BX4qLP35bWJOPalMBmr5XsnUaFognEWLcf79Kj3L7G7o6Ij8YYSKUIdOFiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywma5HX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywma5HX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DA5C4CEF7;
	Wed,  4 Feb 2026 15:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217993;
	bh=S7JJNJuYr//FpFyzX3dpF7eOLYS8Ng46ytA7755l1qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywma5HX271MJJ1P6mkvO6cJl41q9OeTeEhr5puLwS49kyAiVR896jWJVY/9ahxuuY
	 Dt01WfVX/edW91kgE91g6Fgp+9xlarK6zLudldO9snUQ+gufewcJTCXYG2tqxohi6S
	 O98SEP2dtsPmJZyCroHF6NdkEi9cp21LkoPZhtAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 180/280] can: kvaser_usb: kvaser_usb_read_bulk_callback(): fix URB memory leak
Date: Wed,  4 Feb 2026 15:39:14 +0100
Message-ID: <20260204143916.094163763@linuxfoundation.org>
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

commit 248e8e1a125fa875158df521b30f2cc7e27eeeaa upstream.

Fix similar memory leak as in commit 7352e1d5932a ("can: gs_usb:
gs_usb_receive_bulk_callback(): fix URB memory leak").

In kvaser_usb_set_{,data_}bittiming() -> kvaser_usb_setup_rx_urbs(), the
URBs for USB-in transfers are allocated, added to the dev->rx_submitted
anchor and submitted. In the complete callback
kvaser_usb_read_bulk_callback(), the URBs are processed and resubmitted. In
kvaser_usb_remove_interfaces() the URBs are freed by calling
usb_kill_anchored_urbs(&dev->rx_submitted).

However, this does not take into account that the USB framework unanchors
the URB before the complete function is called. This means that once an
in-URB has been completed, it is no longer anchored and is ultimately not
released in usb_kill_anchored_urbs().

Fix the memory leak by anchoring the URB in the
kvaser_usb_read_bulk_callback() to the dev->rx_submitted anchor.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260116-can_usb-fix-memory-leak-v2-3-4b8cb2915571@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -349,7 +349,14 @@ resubmit_urb:
 			  urb->transfer_buffer, KVASER_USB_RX_BUFFER_SIZE,
 			  kvaser_usb_read_bulk_callback, dev);
 
+	usb_anchor_urb(urb, &dev->rx_submitted);
+
 	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!err)
+		return;
+
+	usb_unanchor_urb(urb);
+
 	if (err == -ENODEV) {
 		for (i = 0; i < dev->nchannels; i++) {
 			if (!dev->nets[i])
@@ -357,7 +364,7 @@ resubmit_urb:
 
 			netif_device_detach(dev->nets[i]->netdev);
 		}
-	} else if (err) {
+	} else {
 		dev_err(&dev->intf->dev,
 			"Failed resubmitting read bulk urb: %d\n", err);
 	}


