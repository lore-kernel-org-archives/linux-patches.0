Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFDE359F98;
	Fri,  9 Jan 2026 12:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960357; cv=none; b=seSaQkekqMKvEgvXdMvDP+YGRy6uMvHueAdAEk12DhHZxn0M+BZvI3kGBQMuYarfvlI+C9NW1NQy8f4lz9T5WyMwdAVoI6IsvNgVhFYlOQE1ThljP0ecMKCFLgNq41EjfmNHULeHjj8irVu/KPwIhzuW4/YxzkAexkRPh/4qQaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960357; c=relaxed/simple;
	bh=WirWYWSV3FdmFE8RM+gK5qPPIrShijrsfZfDF6E794I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBNQGnaawlGglnc9ovmSuMppr5INEztSYiq3sxUpXUxlPqYD3G5sMRDcsN7Wx3hLqEAztUUBSRqVaksFtkFUy15C6jP1b2J9DAd9gsShwFyNjsvLTBKTe9FZDU9EOZJtjoGcTPTQ5F4/oHZ0zfwaf/4nQzJ4wy7wT05y1Fuf3s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iicHg3jH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iicHg3jH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB41C4CEF1;
	Fri,  9 Jan 2026 12:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960357;
	bh=WirWYWSV3FdmFE8RM+gK5qPPIrShijrsfZfDF6E794I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iicHg3jHzVw4QcrhHQJy1g5hBcTa/PiZjJ4xDzN8oDT8bD0JV4yNlJA9SzgNXj42b
	 Z9AXyw7OAt0ndfxfDjKCw3vqw5OMIqd3O3CZOJ016euzQWYXbh5+WlFFLrgSRQ70Fy
	 GXr3at0RyuGaxZM0XCUoPbAPeKYyaj71OJW+TtOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 375/737] can: gs_usb: gs_can_open(): fix error handling
Date: Fri,  9 Jan 2026 12:38:34 +0100
Message-ID: <20260109112148.101795675@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

commit 3e54d3b4a8437b6783d4145c86962a2aa51022f3 upstream.

Commit 2603be9e8167 ("can: gs_usb: gs_can_open(): improve error handling")
added missing error handling to the gs_can_open() function.

The driver uses 2 USB anchors to track the allocated URBs: the TX URBs in
struct gs_can::tx_submitted for each netdev and the RX URBs in struct
gs_usb::rx_submitted for the USB device. gs_can_open() allocates the RX
URBs, while TX URBs are allocated during gs_can_start_xmit().

The cleanup in gs_can_open() kills all anchored dev->tx_submitted
URBs (which is not necessary since the netdev is not yet registered), but
misses the parent->rx_submitted URBs.

Fix the problem by killing the rx_submitted instead of the tx_submitted.

Fixes: 2603be9e8167 ("can: gs_usb: gs_can_open(): improve error handling")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251210-gs_usb-fix-error-handling-v1-1-d6a5a03f10bb@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -1071,7 +1071,7 @@ out_usb_free_urb:
 	usb_free_urb(urb);
 out_usb_kill_anchored_urbs:
 	if (!parent->active_channels) {
-		usb_kill_anchored_urbs(&dev->tx_submitted);
+		usb_kill_anchored_urbs(&parent->rx_submitted);
 
 		if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
 			gs_usb_timestamp_stop(parent);


