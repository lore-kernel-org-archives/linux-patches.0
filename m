Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A29F3081B5;
	Tue, 30 Sep 2025 15:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245278; cv=none; b=JhE3Yqnrb/vYtsFV0bUeDwrtklXkp8sQjfNreiY7woXwPrmaTj8jB2HrqbsZI+lV7N2mQmqlWx+3DxGAAKxqqeIdDETAjLY7WPfgfSqOc7zaD/YMcQE2kRj0RWyInp2sXuzPqofJyT+0/G0vYbYrCkDdDh/iFNFYeK9vzWAUdgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245278; c=relaxed/simple;
	bh=vRZ7KGBklrsgtSNygl2oFBSkAvSDzPo8vQojysVSbjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odB5KFuJHEViW23BuuWXUn9Msz7Nx4Ow6q/bkkqnQmDbsV/cwz8C6qBKl3pz/SqRoX524/dacSPeRivE2FYDMKrYko7wlbh6T/DMe1Qai4gj0P9zekp4n5XEvddLMw9S7KVhLcd+Qhgmvg523IjDxeHdI88luEtjT8eP0c9nqz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhPwRucL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhPwRucL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E22C116B1;
	Tue, 30 Sep 2025 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245278;
	bh=vRZ7KGBklrsgtSNygl2oFBSkAvSDzPo8vQojysVSbjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhPwRucLsujMOCMzEjoZAEj8vHJVd97xmdqpELGzHu9v2xPIHko9r7qZtO7dDt3E9
	 WXTactKcZWRoOtD0NnGhDalgBhwvn0a6XlGf1jhjMfCmv5uzsaLEXcShlQvz3PZ7sA
	 cDP/FdTK+u68Db5hnpUH8mOUrNS0iuMcG1dHT5IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/151] can: dev: add generic function can_ethtool_op_get_ts_info_hwts()
Date: Tue, 30 Sep 2025 16:47:29 +0200
Message-ID: <20250930143832.346987376@linuxfoundation.org>
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

[ Upstream commit 7fb48d25b5ce3bc488dbb019bf1736248181de9a ]

Add function can_ethtool_op_get_ts_info_hwts(). This function will be
used by CAN devices with hardware TX/RX timestamping support to
implement ethtool_ops::get_ts_info. This function does not offer
support to activate/deactivate hardware timestamps at device level nor
support the filter options (which is currently the case for all CAN
devices with hardware timestamping support).

The fact that hardware timestamp can not be deactivated at hardware
level does not impact the userland. As long as the user do not set
SO_TIMESTAMPING using a setsockopt() or ioctl(), the kernel will not
emit TX timestamps (RX timestamps will still be reproted as it is the
case currently).

Drivers which need more fine grained control remains free to implement
their own function, but we foresee that the generic function
introduced here will be sufficient for the majority.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220727101641.198847-8-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 38c0abad45b1 ("can: etas_es58x: populate ndo_change_mtu() to prevent buffer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/dev.c | 21 +++++++++++++++++++++
 include/linux/can/dev.h   |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 641f84e5beb0c..d429a2940e83f 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -331,6 +331,27 @@ int can_change_mtu(struct net_device *dev, int new_mtu)
 }
 EXPORT_SYMBOL_GPL(can_change_mtu);
 
+/* generic implementation of ethtool_ops::get_ts_info for CAN devices
+ * supporting hardware timestamps
+ */
+int can_ethtool_op_get_ts_info_hwts(struct net_device *dev,
+				    struct ethtool_ts_info *info)
+{
+	info->so_timestamping =
+		SOF_TIMESTAMPING_TX_SOFTWARE |
+		SOF_TIMESTAMPING_RX_SOFTWARE |
+		SOF_TIMESTAMPING_SOFTWARE |
+		SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->phc_index = -1;
+	info->tx_types = BIT(HWTSTAMP_TX_ON);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
+EXPORT_SYMBOL(can_ethtool_op_get_ts_info_hwts);
+
 /* Common open function when the device gets opened.
  *
  * This function should be called in the open function of the device
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 6dacbbb41e68c..23f1c9f0109d7 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -21,6 +21,7 @@
 #include <linux/can/length.h>
 #include <linux/can/netlink.h>
 #include <linux/can/skb.h>
+#include <linux/ethtool.h>
 #include <linux/netdevice.h>
 
 /*
@@ -132,6 +133,8 @@ struct can_priv *safe_candev_priv(struct net_device *dev);
 int open_candev(struct net_device *dev);
 void close_candev(struct net_device *dev);
 int can_change_mtu(struct net_device *dev, int new_mtu);
+int can_ethtool_op_get_ts_info_hwts(struct net_device *dev,
+				    struct ethtool_ts_info *info);
 
 int register_candev(struct net_device *dev);
 void unregister_candev(struct net_device *dev);
-- 
2.51.0



