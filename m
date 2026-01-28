Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359DD2DB789;
	Wed, 28 Jan 2026 15:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614707; cv=none; b=JQmNdnk5C3T6WUKyidLMQwQPjBkZSmRCs9JZRt1QZYFv+hhE2ZsrH3aQDal5PDJO9DSKACFpBDVwQ8ShQPWBRSpaOwdAK4zom7PeafqapzzsQjkMvKJuWLgf0l3nC8wN2k9VjcyGDF9Du8KIRxBUT/ClVTSNT+FAmnfqLZJZmiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614707; c=relaxed/simple;
	bh=IgU4eJm/PUuUpbbMQ9MP/br/Nz01C+ootMiGAZL5yCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6vy8Fs1n29yNSevF5k7frPftKoy17qWbiAUBCUAC46iawDVtnCT/5l9Y/iiMjooeGf2wp8hDdnFXBRW39eNu6voJSn8K/kL9zVuaiT1nQhdcU1/YRuuQyOo4vN4DKdH7LJNw79f3q6NbUjvAOFxKUTQuEROU/K/AXhG6Osm0wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X12kPzCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X12kPzCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451EFC16AAE;
	Wed, 28 Jan 2026 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614706;
	bh=IgU4eJm/PUuUpbbMQ9MP/br/Nz01C+ootMiGAZL5yCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X12kPzCW1XM9FuM/n0uv78ew5/vJgXHUqo1hJwsQ7a+elGrNsTDDbBzKmnEpB5aBZ
	 F10YKmM0FYGalX7rTQ5U9/98h938dsrZ4BnT7zL45Iewgnjyk14Rj1Dz9o7VfY8hzO
	 upDSdq97hAbmXJM5tnPdbJNFkGxGOVIS3hc3tPE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 218/254] can: mcba_usb: mcba_usb_read_bulk_callback(): fix URB memory leak
Date: Wed, 28 Jan 2026 16:23:14 +0100
Message-ID: <20260128145352.633725299@linuxfoundation.org>
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


