Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB6C3161BF;
	Mon, 13 Apr 2026 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099050; cv=none; b=TS2VQs9w6isT+4Iec3akkEr3bSMJVjEfcIbuQPLKglCgyNmKs2qy4WFdq2v2FL9VKdHz18VZdyqFO9XqMIDzZfoMQiH2V0iowurSmNPFdLcGFp46R5dubQpBQPvgKEaoHY/1CMmciIJjeQWxqgvsxV0Aa0iq7OScYRr1/crBZHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099050; c=relaxed/simple;
	bh=wvlmGNcqnuPBLi7Zu7n7HtTfo/LUrx+Vz9DKtkpRt0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzpjcOzrgmv8fwYxI71K2obCFCVrAVEqmONbMEFWdliI+7K0v5b62TdFNlVctVqDHqnQWjxl9PDb8tu1X6X27vcfr7eoX8Cp0spYT0X2l+H1vlecUrlLNbPaMk9Nohl308d/MgeIf66Tgw5JalxMPtdMRqRKYFBin9W9s+6uj2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+LiJDSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+LiJDSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B27C2BCAF;
	Mon, 13 Apr 2026 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099049;
	bh=wvlmGNcqnuPBLi7Zu7n7HtTfo/LUrx+Vz9DKtkpRt0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+LiJDSVdh7rdwx28ZBCzkD3yrOa9PF4ttRf8/aKwVA01yg7l/UVDTDUESe3Dg9eE
	 sIRBgj+ycVdar3YaGU+BbVVHEJEqt7GgtZsM6cjJxLua2m9gsDPR/upMNwu2ogehQj
	 Q+ZT6xQ6UJJgsONkIytxOV0sbC0CVemumhcOvaEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/491] can: gs_usb: gs_can_open(): always configure bitrates before starting device
Date: Mon, 13 Apr 2026 17:57:16 +0200
Message-ID: <20260413155826.219285216@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
[ No CAN-FD ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -413,9 +413,8 @@ static void gs_usb_receive_bulk_callback
 	}
 }
 
-static int gs_usb_set_bittiming(struct net_device *netdev)
+static int gs_usb_set_bittiming(struct gs_can *dev)
 {
-	struct gs_can *dev = netdev_priv(netdev);
 	struct can_bittiming *bt = &dev->can.bittiming;
 	struct usb_interface *intf = dev->iface;
 	int rc;
@@ -445,7 +444,7 @@ static int gs_usb_set_bittiming(struct n
 	kfree(dbt);
 
 	if (rc < 0)
-		dev_err(netdev->dev.parent, "Couldn't set bittimings (err=%d)",
+		dev_err(dev->netdev->dev.parent, "Couldn't set bittimings (err=%d)",
 			rc);
 
 	return (rc > 0) ? 0 : rc;
@@ -675,6 +674,13 @@ static int gs_can_open(struct net_device
 	if (ctrlmode & CAN_CTRLMODE_3_SAMPLES)
 		flags |= GS_CAN_MODE_TRIPLE_SAMPLE;
 
+	rc = gs_usb_set_bittiming(dev);
+	if (rc) {
+		netdev_err(netdev, "failed to set bittiming: %pe\n", ERR_PTR(rc));
+		kfree(dm);
+		return rc;
+	}
+
 	/* finally start device */
 	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 	dm->mode = cpu_to_le32(GS_CAN_MODE_START);
@@ -888,7 +894,6 @@ static struct gs_can *gs_make_candev(uns
 	dev->can.state = CAN_STATE_STOPPED;
 	dev->can.clock.freq = le32_to_cpu(bt_const->fclk_can);
 	dev->can.bittiming_const = &dev->bt_const;
-	dev->can.do_set_bittiming = gs_usb_set_bittiming;
 
 	dev->can.ctrlmode_supported = 0;
 


