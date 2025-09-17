Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C512FBE1D;
	Wed, 17 Sep 2025 13:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114153; cv=none; b=W7lAfC45WV3DAs9xWwoeCXT0cQ6YoOUKUQ486XeBrKBT7I/Aennfwb1RpgcWVHTxZ2XMEBUR3wyPn6deZKP1KxImrgMlK0j4oGF5mRwtdhfpuN6GdLpoYBcOpcJyfBDIpKfJBwfvPolcLSkuzRXTCNpSDbQTm2EqdCV+WUX9zHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114153; c=relaxed/simple;
	bh=WNxL7YFfnQAg8O5rOSUMOcPr6XNyYs2arnL3eYYmMHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/H8vdVEoWeZUGIh56TBKpxxBpODakmW6aV71JXekXZRtBVSn7wa11gNRvW66Kn1eRT+Wt0mowzFRx+zMnr01WCf6+ZNLQo55dtKXGI9nJ4b4ghLfXUSWhxeCgQteHaVA1Mm2SmnsIJJLP3n7HSzhjWAaZSGSyP72Sjxwd3nr+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHBDidyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHBDidyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F11BC4CEF0;
	Wed, 17 Sep 2025 13:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114153;
	bh=WNxL7YFfnQAg8O5rOSUMOcPr6XNyYs2arnL3eYYmMHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHBDidyYe0IauUOSwT8IF9PpgdOjQG2zNJx+u3rDzuysvnsGvMnTUhGrvGLJjYEeQ
	 QQbHKeO107TuRgYHUtc4B54M5hktUf3zMvql6HuorV+qQUhvUFF9UFiQC5uVepDA1X
	 vA+9ze1Mf1o6ZAy3qrGY5UOHEZw3nrzB+pgDhheA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murali Karicheri <m-karicheri2@ti.com>,
	MD Danish Anwar <danishanwar@ti.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 61/78] net: hsr: Add VLAN CTAG filter support
Date: Wed, 17 Sep 2025 14:35:22 +0200
Message-ID: <20250917123331.062851276@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e9a1a5cf120dd..cb4787327c66b 100644
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
 
@@ -599,6 +673,10 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
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



