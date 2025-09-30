Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D330303CA8;
	Tue, 30 Sep 2025 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245303; cv=none; b=jfqXy39AL9Th4S0ms7eNC2qQlhKhVEn9c7HkUV0NhBx3wzf1HwfD1tNmi08jAd9qHhTxm9CLLfvSz/GH0QwVUel0ZWXMtjsab7GBjDbTT94UrlHeJB8J0uQNRn8x7cqRLx5WCrYzLr3HOWlxIgNbUwsvI4LDKm7KEmw06p4dRpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245303; c=relaxed/simple;
	bh=BbIQExRH/gkwmYiZRFEpvVYj6ble4ubE3EW6lf3MTiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4rWScAEHzgn0t4ZUAcVFodOJwxO8O0Ka8XH0N91vhNR8y1XULCkIn7+CqGQSUZcyvqFhVn8ncA1/oMlnSR3reXTCx0zmoYj+k9WzcUzBT31gVFeWFis4aov5ze2OwkPDimNudwPx4N8LC9trJ6Q6WZeR3/qNL3JZJ7fK3KX3k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMd8cy5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMd8cy5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C26C4CEF0;
	Tue, 30 Sep 2025 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245303;
	bh=BbIQExRH/gkwmYiZRFEpvVYj6ble4ubE3EW6lf3MTiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMd8cy5LRcaJ6HUGz0D92YNfgS3ltz4LIL+PJ6VTUWaCF8FpUx34h15rmfbxAqLrZ
	 m4sTw4TX8umQCwKHMhsoKy4xosViN1a7/6s+FNyArlwLu7Ktm4JsxdFRxtjsXnsas9
	 cupXsZwYjDUiXAOT6jKRbMMbl24mWTZNNqrNIHMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/151] can: etas_es58x: advertise timestamping capabilities and add ioctl support
Date: Tue, 30 Sep 2025 16:47:31 +0200
Message-ID: <20250930143832.428463480@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 1d46efa0008a6d73dad40e78a2b3fa6d3cfb74e4 ]

Currently, userland has no method to query which timestamping features
are supported by the etas_es58x driver (aside maybe of getting RX
messages and observe whether or not hardware timestamps stay at zero).

The canonical way for a network driver to advertise what kind of
timestamping is supports is to implement
ethtool_ops::get_ts_info(). Here, we use the CAN specific
can_ethtool_op_get_ts_info_hwts() function to achieve this.

In addition, the driver currently does not support the hardware
timestamps ioctls. According to [1], SIOCSHWTSTAMP is "must" and
SIOCGHWTSTAMP is "should". This patch fills up that gap by
implementing net_device_ops::ndo_eth_ioctl() using the CAN specific
function can_eth_ioctl_hwts().

[1] kernel doc Timestamping, section 3.1: "Hardware Timestamping
Implementation: Device Drivers"
Link: https://docs.kernel.org/networking/timestamping.html#hardware-timestamping-implementation-device-drivers

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220727101641.198847-11-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 38c0abad45b1 ("can: etas_es58x: populate ndo_change_mtu() to prevent buffer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 34d374d301e50..0c0e2363f674b 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -10,6 +10,7 @@
  * Copyright (c) 2020, 2021 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
  */
 
+#include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/usb.h>
@@ -1981,7 +1982,12 @@ static netdev_tx_t es58x_start_xmit(struct sk_buff *skb,
 static const struct net_device_ops es58x_netdev_ops = {
 	.ndo_open = es58x_open,
 	.ndo_stop = es58x_stop,
-	.ndo_start_xmit = es58x_start_xmit
+	.ndo_start_xmit = es58x_start_xmit,
+	.ndo_eth_ioctl = can_eth_ioctl_hwts,
+};
+
+static const struct ethtool_ops es58x_ethtool_ops = {
+	.get_ts_info = can_ethtool_op_get_ts_info_hwts,
 };
 
 /**
@@ -2088,6 +2094,7 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	es58x_init_priv(es58x_dev, es58x_priv(netdev), channel_idx);
 
 	netdev->netdev_ops = &es58x_netdev_ops;
+	netdev->ethtool_ops = &es58x_ethtool_ops;
 	netdev->flags |= IFF_ECHO;	/* We support local echo */
 
 	ret = register_candev(netdev);
-- 
2.51.0



