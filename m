Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7085827FD56;
	Wed,  4 Feb 2026 14:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216510; cv=none; b=uoMOVVGyWqaoMwXLpk4l09aoTsn/WzmwsaDZgC5BDRHr+Gd4PrWiOu+ril0MqWsyuXMGpteBCqy+PfZBOUlEvbRXiO6UXhKPtsHu4CpsXwkFzeVQvFnkWdwF5pg0KSg+zFI/9Jisuiq0ZNbnG4DgxDIMynXA6ibjfCIBmh0/yns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216510; c=relaxed/simple;
	bh=hsBGUt2YRVgYrFrvZnmkgIXhuBTF24gneZIad3mbAZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0JWa95kO4mGr+s47kPNp6xIDJ6bUDgOAAcXgZxG4swM3/MemAst5latyCwNBGEYklILTpp0imp3Gf2vZekfjekpB9pEvQG7RZIizgwbdNBr0rNFQONdbFMkv/t/o81QJkCZBugK9CEpDPCqM17aZqdh1f1fFbPxLNwcE5W5edU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnSkNOPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnSkNOPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D952CC4CEF7;
	Wed,  4 Feb 2026 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216510;
	bh=hsBGUt2YRVgYrFrvZnmkgIXhuBTF24gneZIad3mbAZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnSkNOPATgCAiKq8To4kI2aCV2GK+9BLBH4Gr15MPiR+vGpvotPKTCpokaeLFKhEK
	 5n8ASpOw2/NPDKuYTnk4+Aa1qUZroRDX18QmwaIKjW5OijaYCllOQjLmtw63xe4Lrk
	 fYzhZyXOw5loRO1eI46y4ciqlpnkIhadXQtPFCzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 110/161] can: mcba_usb: mcba_usb_read_bulk_callback(): fix URB memory leak
Date: Wed,  4 Feb 2026 15:39:33 +0100
Message-ID: <20260204143855.702515778@linuxfoundation.org>
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
@@ -614,11 +614,17 @@ resubmit_urb:
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


