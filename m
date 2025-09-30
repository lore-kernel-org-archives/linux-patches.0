Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F32E217F55;
	Tue, 30 Sep 2025 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245404; cv=none; b=Tkt8lI/fzWiynqqzlPhfMB3ZYRREAT+7csiCzje6aCgY/GJEsPamO1KlBb6Ly9HkzsQrSuKtOeORoyn1IoKUboaTaJdtH0lQthQDvQqbuO/5VCQYvCD+HqYNMqdi6Ijvas52UGbTFKbgvqJ5Eqn+XM6q/ERNF/bhTaKUslEEp1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245404; c=relaxed/simple;
	bh=hvzPtjosgf9uvB/G/J2/w1+WxgHzvjPjXy7ItL9HU5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6aVanDCalZ+eOOomtt/lnZRBpEZwbKiltTVqHz1P9QrX0T0Cqra9CaUL10+B8wSc+UbCPb5pSp2EjqvU2X5hpq0REBLVJxmMS2rrzsaL8MhZ5T119QKDkW0+N+tR2bjH8oHi63X+2FenomlSLyczIWjA1MiJ6wkMdEfaj6ROr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dh1eZzEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dh1eZzEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA9DC4CEF0;
	Tue, 30 Sep 2025 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245403;
	bh=hvzPtjosgf9uvB/G/J2/w1+WxgHzvjPjXy7ItL9HU5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dh1eZzEwpiLy5usHFcgSg/xu+6eVg51MMU3mIrpJBNmsXqr0gCaZRDhtx+RZ7kf1I
	 C8dZDdTRHKQeSkzzVrPw530A/Shvok/xnXyz5n/Yo1VDMCreiAMPhlsVFItctZjjdW
	 kM1Z6gFiXp+V+miHTWnpPx+L2z8pi5CW0jIry+zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/151] can: dev: add generic function can_eth_ioctl_hwts()
Date: Tue, 30 Sep 2025 16:47:30 +0200
Message-ID: <20250930143832.386675419@linuxfoundation.org>
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

[ Upstream commit 90f942c5a6d775bad1be33ba214755314105da4a ]

Tools based on libpcap (such as tcpdump) expect the SIOCSHWTSTAMP
ioctl call to be supported. This is also specified in the kernel doc
[1]. The purpose of this ioctl is to toggle the hardware timestamps.

Currently, CAN devices which support hardware timestamping have those
always activated. can_eth_ioctl_hwts() is a dumb function that will
always succeed when requested to set tx_type to HWTSTAMP_TX_ON or
rx_filter to HWTSTAMP_FILTER_ALL.

[1] Kernel doc: Timestamping, section 3.1 "Hardware Timestamping
Implementation: Device Drivers"
Link: https://docs.kernel.org/networking/timestamping.html#hardware-timestamping-implementation-device-drivers

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220727101641.198847-9-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 38c0abad45b1 ("can: etas_es58x: populate ndo_change_mtu() to prevent buffer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/dev.c | 29 +++++++++++++++++++++++++++++
 include/linux/can/dev.h   |  1 +
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index d429a2940e83f..645564b9bff00 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -331,6 +331,35 @@ int can_change_mtu(struct net_device *dev, int new_mtu)
 }
 EXPORT_SYMBOL_GPL(can_change_mtu);
 
+/* generic implementation of netdev_ops::ndo_eth_ioctl for CAN devices
+ * supporting hardware timestamps
+ */
+int can_eth_ioctl_hwts(struct net_device *netdev, struct ifreq *ifr, int cmd)
+{
+	struct hwtstamp_config hwts_cfg = { 0 };
+
+	switch (cmd) {
+	case SIOCSHWTSTAMP: /* set */
+		if (copy_from_user(&hwts_cfg, ifr->ifr_data, sizeof(hwts_cfg)))
+			return -EFAULT;
+		if (hwts_cfg.tx_type == HWTSTAMP_TX_ON &&
+		    hwts_cfg.rx_filter == HWTSTAMP_FILTER_ALL)
+			return 0;
+		return -ERANGE;
+
+	case SIOCGHWTSTAMP: /* get */
+		hwts_cfg.tx_type = HWTSTAMP_TX_ON;
+		hwts_cfg.rx_filter = HWTSTAMP_FILTER_ALL;
+		if (copy_to_user(ifr->ifr_data, &hwts_cfg, sizeof(hwts_cfg)))
+			return -EFAULT;
+		return 0;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL(can_eth_ioctl_hwts);
+
 /* generic implementation of ethtool_ops::get_ts_info for CAN devices
  * supporting hardware timestamps
  */
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 23f1c9f0109d7..c439735dce6a7 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -133,6 +133,7 @@ struct can_priv *safe_candev_priv(struct net_device *dev);
 int open_candev(struct net_device *dev);
 void close_candev(struct net_device *dev);
 int can_change_mtu(struct net_device *dev, int new_mtu);
+int can_eth_ioctl_hwts(struct net_device *netdev, struct ifreq *ifr, int cmd);
 int can_ethtool_op_get_ts_info_hwts(struct net_device *dev,
 				    struct ethtool_ts_info *info);
 
-- 
2.51.0



