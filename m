Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9D21E1DFC;
	Wed, 28 Jan 2026 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615319; cv=none; b=nsWXYHSE5/tvyuJSsEbJ/7DY027Pmw74C7CzOCMQVZr7A2gpTf1T6qx4n7AA/T1xaSa33BwohQc8R5iiy695UhasFz/4dXH7CujXR+NrDlRDQ7QSshqbeeGbmKMDzvQqWOV/cdZm+2PhmtwLZ28yxj607typkF4hqkWcor0SyDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615319; c=relaxed/simple;
	bh=G5big1uJiM0ACa7xRW9fbVxpJbmjoUQJGoeYNoWnluk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrkvQovRMr/hwIfFUoXjtWU5H89o4H4Y6GRuW0UwrVMvg4Q+muvt51utHJp1fWgoie2Zue+vBmLN5jwsk6S4F+z8u0kt5dEeFUGQ6vPN5UHeMAgHanhA1DxAKNjaCChzU5Rp+KuzCJ4IvROF3wlCcWtA40k8xMeD3sw/Y8ncrnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIPfUFcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIPfUFcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B2EC116C6;
	Wed, 28 Jan 2026 15:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615319;
	bh=G5big1uJiM0ACa7xRW9fbVxpJbmjoUQJGoeYNoWnluk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIPfUFcsQmlDGu+RUHzQ7g9o+6u8lVsiO3Efp1LN6UEXyfxWxe/bKE1AdUIcPbxSL
	 vuZHzDIhOsBT70yYz9sEv176zQeKm2Y2hD1m0Zqk4MQh87h3N4EPPvkWJ551kdb3BK
	 mcB3wNox9Wxyb19mUtMWKb+muEVaQXuVJo6Tt/NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 143/169] can: usb_8dev: usb_8dev_read_bulk_callback(): fix URB memory leak
Date: Wed, 28 Jan 2026 16:23:46 +0100
Message-ID: <20260128145339.152140009@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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


