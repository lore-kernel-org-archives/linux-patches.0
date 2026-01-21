Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC11332EDD;
	Wed, 21 Jan 2026 18:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020238; cv=none; b=OL3moarkwysNZW3hkHOOdI1yXMIpMxkV2z1z/EgwwACB12uVxzaNsN4TtYFsxjevk/YbHBs1RrG9wKxSK32xG16cKbPxTMQmOwO4nDulGf4NLYMe5yp/WDWOfrg3/y/8xbMSly+lazZhf38rj/oTKq4ncGLMr9dkGPKGjxtdtSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020238; c=relaxed/simple;
	bh=m6UczAJzSKC2WondLH11piZAm8BgGTmvCwRbw2FnJWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQnvYcqKD8cQeS6QU0Q8zRjUdQ7LKCroKb7OCYZSCrh2HcbfyRQBdw6g3TBaL+/q9GSVd9IGVFHqsSZPSRLjYYxs+tN18mS2S/2UasahnZgEZjNXTI1t0ehoG8XsUBn7Q9o2jPf/FAWyixcop7JMeIqzqCStUopLaW6IC9ljWIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aInskDGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aInskDGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C4FC4CEF1;
	Wed, 21 Jan 2026 18:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020238;
	bh=m6UczAJzSKC2WondLH11piZAm8BgGTmvCwRbw2FnJWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aInskDGHRuru79x7i2K+4MP1E3PiBl3D3zwlPdFC3FBLuLmfo5i0MrnEJlDdpEaXJ
	 dyo7UNHYlLLUg9SsiHmU5JHxP6aSRPndODsWWYQq40ZJ6WLbhfAJY2Ti0iEXa2qEfX
	 mtYQ9ENAtldWIndXQzN47oP6713M3P2GMDYyFyDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 098/198] can: gs_usb: gs_usb_receive_bulk_callback(): fix URB memory leak
Date: Wed, 21 Jan 2026 19:15:26 +0100
Message-ID: <20260121181422.081522624@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

commit 7352e1d5932a0e777e39fa4b619801191f57e603 upstream.

In gs_can_open(), the URBs for USB-in transfers are allocated, added to the
parent->rx_submitted anchor and submitted. In the complete callback
gs_usb_receive_bulk_callback(), the URB is processed and resubmitted. In
gs_can_close() the URBs are freed by calling
usb_kill_anchored_urbs(parent->rx_submitted).

However, this does not take into account that the USB framework unanchors
the URB before the complete function is called. This means that once an
in-URB has been completed, it is no longer anchored and is ultimately not
released in gs_can_close().

Fix the memory leak by anchoring the URB in the
gs_usb_receive_bulk_callback() to the parent->rx_submitted anchor.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260105-gs_usb-fix-memory-leak-v2-1-cc6ed6438034@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -751,6 +751,8 @@ resubmit_urb:
 			  hf, parent->hf_size_rx,
 			  gs_usb_receive_bulk_callback, parent);
 
+	usb_anchor_urb(urb, &parent->rx_submitted);
+
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 
 	/* USB failure take down all interfaces */


