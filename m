Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F7A3093C1;
	Mon, 29 Dec 2025 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025271; cv=none; b=o3ziaGWYT46hxaBR61Uqq+STHBlo922CcR5FX/Gng/Xp6IIBQtfJoHSyZUNPVlqyXJufY/7QlDJ125FxjETAt5MsDy3Ai1lCebUcZMh32OW170VRd+MKSeTVG3fPOImFDBVkHxcSSgKmjWjVM1vQrR9wlmTPwjnNGQPeoF+vZKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025271; c=relaxed/simple;
	bh=GLq3ueTe19OxxOOywyXe9GSIVSCQ5/MEHnQvWq4YUPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEF8rrtH34WPhL7mWAEpT3T0d1gUwtSU0+BvWyzjIZ+NOFzjAehxncsXYtocGVIrUvPu7T48wh12wRKJgI63Ws81FkstKFh1LYlk6ZaN8lSS7AY4gxKUIEEqONB91BbnGVSXewwnl3ti0TCMiPN4WOCcTlniK6y7975IbBAkY18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uir5mZc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uir5mZc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D01C4CEF7;
	Mon, 29 Dec 2025 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025271;
	bh=GLq3ueTe19OxxOOywyXe9GSIVSCQ5/MEHnQvWq4YUPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uir5mZc+HpYMhIwH0NbcK8sxVEgHMPFkbgAp1WBlVbmdOlfDBN3B5a8JOOR14FxSc
	 MX8JlUV3GVDoJbE2catC1/cGOIT7BRpmsXlZ7dy45jkmge/v08LDs7YmW679qXhjUK
	 5WaI95rxj/WDMWiLP4Ks6KeOUDB+CsjlXXn9MBGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 154/430] can: gs_usb: gs_can_open(): fix error handling
Date: Mon, 29 Dec 2025 17:09:16 +0100
Message-ID: <20251229160730.027347523@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -1074,7 +1074,7 @@ out_usb_free_urb:
 	usb_free_urb(urb);
 out_usb_kill_anchored_urbs:
 	if (!parent->active_channels) {
-		usb_kill_anchored_urbs(&dev->tx_submitted);
+		usb_kill_anchored_urbs(&parent->rx_submitted);
 
 		if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
 			gs_usb_timestamp_stop(parent);


