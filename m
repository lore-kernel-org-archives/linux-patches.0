Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C37B32AAC5;
	Tue, 17 Mar 2026 17:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767713; cv=none; b=sh84umWKgsIEg75KRjxvfb1XJe0mhSRsy7J2LPYIr4B06I3l4CuRWETzNFFpsNdwNNKqQNTIz9Vyxzf5sg4Ax9BCoSADtNVLYgXq1NS+0PCINz/zmkaylyOhdVINFDRCtnAkyy8QEFw5DPu+h4aF5N8UtTTMUleSJZWGm91zE5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767713; c=relaxed/simple;
	bh=w2ZgWJTurucSqRHN4/XVhKlqG01KHwWnmeKUkZeb7SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbML8zUlElMwQaCx6SCr0wyGOspi0Mz6rUu94oj/gLM/6CPLx2Oi0JnWreB1/m5UJv0lYF4cCMccDBXAlMrSTvf7DjVX7rlUlnZE/ASI1R1MPIOS68+Gjim5QAkfEhYfEL0hvnvL7hHm4tvyfLq050gXgRMNG/3D1RcVsnQ2s2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8As6DyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8As6DyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CB0C2BCAF;
	Tue, 17 Mar 2026 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767713;
	bh=w2ZgWJTurucSqRHN4/XVhKlqG01KHwWnmeKUkZeb7SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8As6DyYrWz5QUV4A/fMl8o9LrX5Prm7w4UMMK5mzFIyy6fC6f3sMOCapsHO+2lYr
	 s9Gd+j6vw/EIp8nyKPh4amTQoYiunlfqiNO6T3IDkrCFx0WxRmkdAYjRtJn3mNYjDu
	 jq0WHlZTfD9dYRiJgtg0y2KFH9oQa9oJgcA7Kn7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 109/333] can: gs_usb: gs_can_open(): always configure bitrates before starting device
Date: Tue, 17 Mar 2026 17:32:18 +0100
Message-ID: <20260317163003.410915194@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

commit 2df6162785f31f1bbb598cfc3b08e4efc88f80b6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -772,9 +772,8 @@ device_detach:
 	}
 }
 
-static int gs_usb_set_bittiming(struct net_device *netdev)
+static int gs_usb_set_bittiming(struct gs_can *dev)
 {
-	struct gs_can *dev = netdev_priv(netdev);
 	struct can_bittiming *bt = &dev->can.bittiming;
 	struct gs_device_bittiming dbt = {
 		.prop_seg = cpu_to_le32(bt->prop_seg),
@@ -791,9 +790,8 @@ static int gs_usb_set_bittiming(struct n
 				    GFP_KERNEL);
 }
 
-static int gs_usb_set_data_bittiming(struct net_device *netdev)
+static int gs_usb_set_data_bittiming(struct gs_can *dev)
 {
-	struct gs_can *dev = netdev_priv(netdev);
 	struct can_bittiming *bt = &dev->can.fd.data_bittiming;
 	struct gs_device_bittiming dbt = {
 		.prop_seg = cpu_to_le32(bt->prop_seg),
@@ -1057,6 +1055,20 @@ static int gs_can_open(struct net_device
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
 	/* finally start device */
 	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 	dm.flags = cpu_to_le32(flags);
@@ -1357,7 +1369,6 @@ static struct gs_can *gs_make_candev(uns
 	dev->can.state = CAN_STATE_STOPPED;
 	dev->can.clock.freq = le32_to_cpu(bt_const.fclk_can);
 	dev->can.bittiming_const = &dev->bt_const;
-	dev->can.do_set_bittiming = gs_usb_set_bittiming;
 
 	dev->can.ctrlmode_supported = CAN_CTRLMODE_CC_LEN8_DLC;
 
@@ -1381,7 +1392,6 @@ static struct gs_can *gs_make_candev(uns
 		 * GS_CAN_FEATURE_BT_CONST_EXT is set.
 		 */
 		dev->can.fd.data_bittiming_const = &dev->bt_const;
-		dev->can.fd.do_set_data_bittiming = gs_usb_set_data_bittiming;
 	}
 
 	if (feature & GS_CAN_FEATURE_TERMINATION) {


