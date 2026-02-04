Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1662874E6;
	Wed,  4 Feb 2026 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216507; cv=none; b=p0IluzaJJcHbRmyTeGYYvLq9890P7cZD8Jch49l0FCulzNiTUl1mYd+QSGPqSV184F8nD1wpLtKG7hfmE8M9E76FwEXhXcDTUKGEW9exzcZeRx2KpkreVHTAycMQwwDJ1/UN5f4NGqTMF/QFDCKnX4cZ0IV1uVZb56zWNdpqqGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216507; c=relaxed/simple;
	bh=M9rHocOFP8E2lxg4uZklr69LfhLkliZwHIH+kxVKv9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saRrsPsyVBf5lXMVNRi1009dmmYcjHOGRVdZCMwva5UggOAz38iI6eIGZI3AhSQwzx90t675nsWpV/dUYmEJlWglFeDXpdKJcVwQUByPrD9iNoqR+ykXa072s0rPvkzXNjmbfaxfeJrexKmPZJhqEYixawkz53rt1PVTSSab/9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0Zjw3+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0Zjw3+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800EEC4CEF7;
	Wed,  4 Feb 2026 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216507;
	bh=M9rHocOFP8E2lxg4uZklr69LfhLkliZwHIH+kxVKv9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0Zjw3+TKq+XNP8zRebhwVBZbTNkqGn1g3Tam5rtU0aYIQpaT2f4zKkp+Srtw4KH9
	 uJ9423EyM6r3vW/Xna11aBYwOB49LPuvTqe0/01lEdgcVn7KsOh+buWWUEYipdbl97
	 IAHlY3fptw3htmM5qYMPfvnz497u/ZhZa6W8X3fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 109/161] can: kvaser_usb: kvaser_usb_read_bulk_callback(): fix URB memory leak
Date: Wed,  4 Feb 2026 15:39:32 +0100
Message-ID: <20260204143855.666188691@linuxfoundation.org>
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
@@ -325,7 +325,14 @@ resubmit_urb:
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
@@ -333,7 +340,7 @@ resubmit_urb:
 
 			netif_device_detach(dev->nets[i]->netdev);
 		}
-	} else if (err) {
+	} else {
 		dev_err(&dev->intf->dev,
 			"Failed resubmitting read bulk urb: %d\n", err);
 	}


