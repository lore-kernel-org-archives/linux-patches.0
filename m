Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5412D6E6A;
	Wed, 28 Jan 2026 15:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614711; cv=none; b=CAK9l7Ddvs2F45s5irI48lVdFfyfDkRWXdXSU4jRD7LVYKSy6OczyB+IYAUkrt8LJVE9REiXA/Ke3RFJuNQRcIJ8EoqxiVyG6+45/4+dLDuoXTv+2FeuVwc8NjYjPZm4ZqzWzXeVyc9mbQKU2GnCohNxcv1H3mxqBRWZbuwwU6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614711; c=relaxed/simple;
	bh=Ne8q+MnuhHEA/5nWIzTKSQsMGwc+aaePBv5QOP1ieG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdIkkwXkNJE5XO3+juowwbNQX5M7BOxVMyfZgT3WMW6vBTNiE3hjFN9g+A6YRrJKykGGmLKI3k9dRTf5WiXsoYoLL1GGa5SglFu8HEUFePKc0DUzOeMrdI2ayXtkUJiIjcDtMawPm+3Tz0KmbLTXdicKv4cO/VMoYo3JgpBcO10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUlEj0B1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUlEj0B1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7D7C4CEF7;
	Wed, 28 Jan 2026 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614710;
	bh=Ne8q+MnuhHEA/5nWIzTKSQsMGwc+aaePBv5QOP1ieG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUlEj0B1yF1n6Ab4sR/FgjPmiznnGomAvWel4aELz2efhQblLQPVorUZ/cPPDjFZN
	 0Oz3MwSKYt4mkN3+/UVuwGhvK4HR/47MmtbTnIYBjbZGJu6kRuU0r2/3b0iSFkawhG
	 0gyVsC9SxFz9x/ZEy75ee3hVvyNQEnQ2TFiZUveo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 219/254] can: usb_8dev: usb_8dev_read_bulk_callback(): fix URB memory leak
Date: Wed, 28 Jan 2026 16:23:15 +0100
Message-ID: <20260128145352.668615896@linuxfoundation.org>
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

commit f7a980b3b8f80fe367f679da376cf76e800f9480 upstream.

Fix similar memory leak as in commit 7352e1d5932a ("can: gs_usb:
gs_usb_receive_bulk_callback(): fix URB memory leak").

In usb_8dev_open() -> usb_8dev_start(), the URBs for USB-in transfers are
allocated, added to the priv->rx_submitted anchor and submitted. In the
complete callback usb_8dev_read_bulk_callback(), the URBs are processed and
resubmitted. In usb_8dev_close() -> unlink_all_urbs() the URBs are freed by
calling usb_kill_anchored_urbs(&priv->rx_submitted).

However, this does not take into account that the USB framework unanchors
the URB before the complete function is called. This means that once an
in-URB has been completed, it is no longer anchored and is ultimately not
released in usb_kill_anchored_urbs().

Fix the memory leak by anchoring the URB in the
usb_8dev_read_bulk_callback() to the priv->rx_submitted anchor.

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260116-can_usb-fix-memory-leak-v2-5-4b8cb2915571@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/usb_8dev.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -541,11 +541,17 @@ resubmit_urb:
 			  urb->transfer_buffer, RX_BUFFER_SIZE,
 			  usb_8dev_read_bulk_callback, priv);
 
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
 		netdev_err(netdev,
 			"failed resubmitting read bulk urb: %d\n", retval);
 }


