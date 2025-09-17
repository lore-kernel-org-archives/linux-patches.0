Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF74432BC13;
	Wed, 17 Sep 2025 12:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113866; cv=none; b=gQq9Qx/h8Wq5Jpm9x1XYwMyjZL/obdeFjisBeeBvJwtMigP85TovzHsZpjOrXmF6TdCpUuJd8049lkm4jiPcMWoKbniscgSE3Dzskk09j9Duvkp4EXRwzQgJqw8nIYJNT+VQ9Pswr9cxH2IXRo7x33bgqjkYJyaCaMQ4g2IvGEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113866; c=relaxed/simple;
	bh=02/wD4Nlpoa3IbGzCVJVufexJbW70MEHvlS8eoHCBhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdtSaeZV+ElP1ecw3Bqt4rd2YtlMFpX0AwUZnyPLJ96f5xOnr6Awb9qOdLjTF5bFQJCVI3mwbEDhRzEdbzcBAISyvOvCwuK0KCLry4ymSJ3nEIdFIgSZ36Mdony5WVCPWflKKoBpuQ1Fy/iCLLz9SBLOfXVYghakJDnd9rVBmwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEaSghkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEaSghkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B299C4CEF0;
	Wed, 17 Sep 2025 12:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113866;
	bh=02/wD4Nlpoa3IbGzCVJVufexJbW70MEHvlS8eoHCBhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEaSghkQqqeEnRuMQA0A1IIQv6o+9/f3D10xAk6SxCm03CnUZhTcTbzXdLlmyvqDk
	 pLxWobPt+0M4dg7pZzX85CQZOYTD1yrMqwVICLf5Mp3EU2nXhlwtnw2GtbCQ9p5wlK
	 LzqWQN9ZklLrD7Vr+bIUfuidz2LmW9KIEpyTM+jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murali Karicheri <m-karicheri2@ti.com>,
	MD Danish Anwar <danishanwar@ti.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/101] net: hsr: Add VLAN CTAG filter support
Date: Wed, 17 Sep 2025 14:35:01 +0200
Message-ID: <20250917123338.722384534@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Murali Karicheri <m-karicheri2@ti.com>

[ Upstream commit 1a8a63a5305e95519de6f941922dfcd8179f82e5 ]

This patch adds support for VLAN ctag based filtering at slave devices.
The slave ethernet device may be capable of filtering ethernet packets
based on VLAN ID. This requires that when the VLAN interface is created
over an HSR/PRP interface, it passes the VID information to the
associated slave ethernet devices so that it updates the hardware
filters to filter ethernet frames based on VID. This patch adds the
required functions to propagate the vid information to the slave
devices.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20241106091710.3308519-3-danishanwar@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8884c6939913 ("hsr: use rtnl lock when iterating over ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 80 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index cff37637c96d3..69f6c704352de 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -464,6 +464,77 @@ static void hsr_change_rx_flags(struct net_device *dev, int change)
 	}
 }
 
+static int hsr_ndo_vlan_rx_add_vid(struct net_device *dev,
+				   __be16 proto, u16 vid)
+{
+	bool is_slave_a_added = false;
+	bool is_slave_b_added = false;
+	struct hsr_port *port;
+	struct hsr_priv *hsr;
+	int ret = 0;
+
+	hsr = netdev_priv(dev);
+
+	hsr_for_each_port(hsr, port) {
+		if (port->type == HSR_PT_MASTER ||
+		    port->type == HSR_PT_INTERLINK)
+			continue;
+
+		ret = vlan_vid_add(port->dev, proto, vid);
+		switch (port->type) {
+		case HSR_PT_SLAVE_A:
+			if (ret) {
+				/* clean up Slave-B */
+				netdev_err(dev, "add vid failed for Slave-A\n");
+				if (is_slave_b_added)
+					vlan_vid_del(port->dev, proto, vid);
+				return ret;
+			}
+
+			is_slave_a_added = true;
+			break;
+
+		case HSR_PT_SLAVE_B:
+			if (ret) {
+				/* clean up Slave-A */
+				netdev_err(dev, "add vid failed for Slave-B\n");
+				if (is_slave_a_added)
+					vlan_vid_del(port->dev, proto, vid);
+				return ret;
+			}
+
+			is_slave_b_added = true;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int hsr_ndo_vlan_rx_kill_vid(struct net_device *dev,
+				    __be16 proto, u16 vid)
+{
+	struct hsr_port *port;
+	struct hsr_priv *hsr;
+
+	hsr = netdev_priv(dev);
+
+	hsr_for_each_port(hsr, port) {
+		switch (port->type) {
+		case HSR_PT_SLAVE_A:
+		case HSR_PT_SLAVE_B:
+			vlan_vid_del(port->dev, proto, vid);
+			break;
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+
 static const struct net_device_ops hsr_device_ops = {
 	.ndo_change_mtu = hsr_dev_change_mtu,
 	.ndo_open = hsr_dev_open,
@@ -472,6 +543,8 @@ static const struct net_device_ops hsr_device_ops = {
 	.ndo_change_rx_flags = hsr_change_rx_flags,
 	.ndo_fix_features = hsr_fix_features,
 	.ndo_set_rx_mode = hsr_set_rx_mode,
+	.ndo_vlan_rx_add_vid = hsr_ndo_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid = hsr_ndo_vlan_rx_kill_vid,
 };
 
 static struct device_type hsr_type = {
@@ -512,7 +585,8 @@ void hsr_dev_setup(struct net_device *dev)
 
 	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA |
 			   NETIF_F_GSO_MASK | NETIF_F_HW_CSUM |
-			   NETIF_F_HW_VLAN_CTAG_TX;
+			   NETIF_F_HW_VLAN_CTAG_TX |
+			   NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	dev->features = dev->hw_features;
 
@@ -598,6 +672,10 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	    (slave[1]->features & NETIF_F_HW_HSR_FWD))
 		hsr->fwd_offloaded = true;
 
+	if ((slave[0]->features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	    (slave[1]->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+		hsr_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+
 	res = register_netdevice(hsr_dev);
 	if (res)
 		goto err_unregister;
-- 
2.51.0



