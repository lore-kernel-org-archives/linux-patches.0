Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257CE2FABE1;
	Wed, 28 Jan 2026 15:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614814; cv=none; b=PtKU/u098M39jESHl3Gsd5dHoW85luo+neyiBES6JbQP3P+nFGd6UuyUVWHSuRLeiDXO0syinQ+rOcD0PzUJaYoox8hRUPoOAAQt6BlZa2TIPSFwkn1gOXfeIk/p1USZa2kh1S6SnKvZ/gER8X7s46dcCLnungGYf76HZlwRqtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614814; c=relaxed/simple;
	bh=/kz3gYaz/H6LH+ahT7TIR0ytE/NHS4PqASevnkZlgw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Te9TSe9pO/EO7tMfJkerzlHLWNMKx211G8RAPO4RHwsIpiGs/eNyLMjaezI+LzC6E1crpYGddP+4mK/yM74zgXL/JPQnGnv3bFulF8cW8C0dHJzX06KyJ1dFh6OcuoPzGfv1tuHO+pLLicrhKmW6T+6lYBamy7L54vU1c09EQ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rx6/cKwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rx6/cKwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F423BC4CEF1;
	Wed, 28 Jan 2026 15:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614813;
	bh=/kz3gYaz/H6LH+ahT7TIR0ytE/NHS4PqASevnkZlgw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rx6/cKwtAJ1JV/bALsRyk9I5+aOjCrBC/l6MT3FX1ARRtv+SFvmTBQwsiqjGFQwzO
	 2zdrvPzDMwVnhTb4KCWGOhhKrCOmVKlufOcCmf0ER8+8KdzSBf4rWafwAGr+zeCPYh
	 G7/ISr6Ea+iZZJxG0K4USCswFRwwxFYWw0cNnLjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 217/254] can: kvaser_usb: kvaser_usb_read_bulk_callback(): fix URB memory leak
Date: Wed, 28 Jan 2026 16:23:13 +0100
Message-ID: <20260128145352.598425454@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


