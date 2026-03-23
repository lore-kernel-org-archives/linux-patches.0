Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EF23B9DB7;
	Mon, 23 Mar 2026 16:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283023; cv=none; b=seem5jEFNVfyKkAyVVymMmwUasugMjxwNEu69fdMYqn/XRnLKZ7DWwTDhOpL50wQf+DycAQEdL2+HJy6h/+8wKuwKHNckcnO0s0HvaSBr/57v6Bj/a71wbFDRmQ6vCNSjUQkix1wzssZjnh2Tu5A8A4GP6SvvcwTSwoaHGjG0mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283023; c=relaxed/simple;
	bh=rJ/JCxKQFLVXqoCA7uIPUaVnuHnjvCazRLLuNRzvuKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQoi+9qVPGeeXuPdck7GWqU1GB8dqfyOha9wqJEyD/0qsJyRxCEBP4HfrIAEc++rj/1pt+h6frkTRzeySIjG4YHW1lsMFR4foj3Lt+P8BgaPZXVe97G5j16l9WERu40sOZBx3dA2ZCmUnyrYIx2BQjzWVWEHrnCCWvFTaj8+Q+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZH6tDNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZH6tDNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832C7C4CEF7;
	Mon, 23 Mar 2026 16:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283022;
	bh=rJ/JCxKQFLVXqoCA7uIPUaVnuHnjvCazRLLuNRzvuKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZH6tDNC4m+J497uSkFwCrbzVoOMK40ts6NOyVtku1h/PtzpTMl/6v93xaMw8ZQ7+
	 XYAwGkNRKKEZVzTp+z5UTJeQcQ22fvPCBBYSTsIgJA2LWPLoFHmfqmdYb42NLs9gp1
	 rssVYSXB/mtLQ7NlXVWxPqrJLNMsBZNua8n3oCEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 329/481] can: gs_usb: gs_can_open(): always configure bitrates before starting device
Date: Mon, 23 Mar 2026 14:45:11 +0100
Message-ID: <20260323134533.121714472@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 2df6162785f31f1bbb598cfc3b08e4efc88f80b6 ]

So far the driver populated the struct can_priv::do_set_bittiming() and
struct can_priv::fd::do_set_data_bittiming() callbacks.

Before bringing up the interface, user space has to configure the bitrates.
With these callbacks the configuration is directly forwarded into the CAN
hardware. Then the interface can be brought up.

An ifdown-ifup cycle (without changing the bit rates) doesn't re-configure
the bitrates in the CAN hardware. This leads to a problem with the
CANable-2.5 [1] firmware, which resets the configured bit rates during
ifdown.

To fix the problem remove both bit timing callbacks and always configure
the bitrates in the struct net_device_ops::ndo_open() callback.

[1] https://github.com/Elmue/CANable-2.5-firmware-Slcan-and-Candlelight

Cc: stable@vger.kernel.org
Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://patch.msgid.link/20260219-gs_usb-always-configure-bitrates-v2-1-671f8ba5b0a5@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ adapted to different structure of the struct ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -678,9 +678,8 @@ device_detach:
 	}
 }
 
-static int gs_usb_set_bittiming(struct net_device *netdev)
+static int gs_usb_set_bittiming(struct gs_can *dev)
 {
-	struct gs_can *dev = netdev_priv(netdev);
 	struct can_bittiming *bt = &dev->can.bittiming;
 	struct gs_device_bittiming dbt = {
 		.prop_seg = cpu_to_le32(bt->prop_seg),
@@ -698,9 +697,8 @@ static int gs_usb_set_bittiming(struct n
 				    GFP_KERNEL);
 }
 
-static int gs_usb_set_data_bittiming(struct net_device *netdev)
+static int gs_usb_set_data_bittiming(struct gs_can *dev)
 {
-	struct gs_can *dev = netdev_priv(netdev);
 	struct can_bittiming *bt = &dev->can.data_bittiming;
 	struct gs_device_bittiming dbt = {
 		.prop_seg = cpu_to_le32(bt->prop_seg),
@@ -961,6 +959,20 @@ static int gs_can_open(struct net_device
 	if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
 		flags |= GS_CAN_MODE_HW_TIMESTAMP;
 
+	rc = gs_usb_set_bittiming(dev);
+	if (rc) {
+		netdev_err(netdev, "failed to set bittiming: %pe\n", ERR_PTR(rc));
+		goto out_usb_kill_anchored_urbs;
+	}
+
+	if (ctrlmode & CAN_CTRLMODE_FD) {
+		rc = gs_usb_set_data_bittiming(dev);
+		if (rc) {
+			netdev_err(netdev, "failed to set data bittiming: %pe\n", ERR_PTR(rc));
+			goto out_usb_kill_anchored_urbs;
+		}
+	}
+
 	/* start polling timestamp */
 	if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
 		gs_usb_timestamp_init(dev);
@@ -1231,7 +1243,6 @@ static struct gs_can *gs_make_candev(uns
 	dev->can.state = CAN_STATE_STOPPED;
 	dev->can.clock.freq = le32_to_cpu(bt_const.fclk_can);
 	dev->can.bittiming_const = &dev->bt_const;
-	dev->can.do_set_bittiming = gs_usb_set_bittiming;
 
 	dev->can.ctrlmode_supported = CAN_CTRLMODE_CC_LEN8_DLC;
 
@@ -1255,7 +1266,6 @@ static struct gs_can *gs_make_candev(uns
 		 * GS_CAN_FEATURE_BT_CONST_EXT is set.
 		 */
 		dev->can.data_bittiming_const = &dev->bt_const;
-		dev->can.do_set_data_bittiming = gs_usb_set_data_bittiming;
 	}
 
 	if (feature & GS_CAN_FEATURE_TERMINATION) {


