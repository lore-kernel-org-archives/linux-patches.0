Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE0227FD56;
	Wed,  4 Feb 2026 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216513; cv=none; b=luT6/lm5BJIPjjNalXTATZillyg8jYjJOf6RMsdstpIu2WEH7A2YQEchgn3LlNc7Ybi6VQZqWLM65ba8mBrtNRLDcuZjRDQFOHQmDDBn0QQljaIXzdM4Ny/wFf4Ww/Vpwl05Vd+PEhP931031pP7rsk5mTxXYmeybwKhW/A84a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216513; c=relaxed/simple;
	bh=Pj5hSK7fB3nUiUHXvjVUQuD/C3BnuwZKULVV6Pbmzqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inDMnMRCQEbtRdqGW66Sw5W7Svilo4v22BeZHLr7yn0dLHZGgOiszPztfs4m8fQhsT/XL6fuv/lxmEs0I3+lvx9sikU4EU3bsbknnilmEyj5PVMvNwriGAeP+jYDfgf2gg+G+CHBIdPFNinzblfihTQ9GuYC5bA9ChX/+9hwpSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9dtMV/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9dtMV/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410AAC4CEF7;
	Wed,  4 Feb 2026 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216513;
	bh=Pj5hSK7fB3nUiUHXvjVUQuD/C3BnuwZKULVV6Pbmzqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9dtMV/YZ8JPX2KVkY52nAg4MBA8nG1fGSBPyst6p3JB6kEohb6OU/mpwGBvTShun
	 pOUisxgtdts/6/98HVOdQPHvaRNl0CyJz3O3gtNoIwal+Mz38jS0nmNilXbwom50ob
	 V9hbuhBlk+y2fNhjUCTwXtR9PG82HAWP7jOWRkgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 111/161] can: usb_8dev: usb_8dev_read_bulk_callback(): fix URB memory leak
Date: Wed,  4 Feb 2026 15:39:34 +0100
Message-ID: <20260204143855.737986321@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -546,11 +546,17 @@ resubmit_urb:
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


