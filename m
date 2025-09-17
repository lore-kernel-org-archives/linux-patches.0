Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CB62FBE1D;
	Wed, 17 Sep 2025 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114150; cv=none; b=cxWqn7WfXnKXGthDMck1wKdOI/WFspRGMsCNl9A8komayZkIzcl8B2PyTlGK8kLMRbzJqmZTXLEJVmTa4PgUxRP0mDV4pzmtUIIEiEx+1EwrVhXJG2ibRBH3Zt2u8YCri3h+yEoE26otuVwfaAo3so++IsHAcFeYh8do4whECk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114150; c=relaxed/simple;
	bh=jowV962RF+QJkeE/eKvhnuheKnjQ1RUDYc2jdDwgv8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6r0m+nqJBnR8fFfI/v21YzoJsFtH2q3GwwiN5F6DuFqWMT2ZwkdH/KuKeZfK2JXpqeXmVsnNxcf6R7PWVip/KTEMKH1K7N6ZfqMm4jeqZJeNvG1hl1rBoGkwWHoSXNyTLtx21szLhASv+TD3jn/NjQZA8ohKHpfd5cJrTsJr40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzzIJlSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzzIJlSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D393C4CEF0;
	Wed, 17 Sep 2025 13:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114149;
	bh=jowV962RF+QJkeE/eKvhnuheKnjQ1RUDYc2jdDwgv8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzzIJlSJDTJCt4PJHV/vknqrgPBxC+DjbzvUxqO4j4LBBSnG9ODWnlaAmSjzVpWUF
	 2AwUenI96bHfeIqv+WeAbm66yl8qsIqRPe5owwkl9xGkHCoP266tU+wLzvtPedTBXP
	 eEZJu5enPknk9BTLBowLJeVHrKfT4eK0aEnXYbpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murali Karicheri <m-karicheri2@ti.com>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 60/78] net: hsr: Add support for MC filtering at the slave device
Date: Wed, 17 Sep 2025 14:35:21 +0200
Message-ID: <20250917123331.036734105@linuxfoundation.org>
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

[ Upstream commit 36b20fcdd9663ced36d3aef96f0eff8eb79de4b8 ]

When MC (multicast) list is updated by the networking layer due to a
user command and as well as when allmulti flag is set, it needs to be
passed to the enslaved Ethernet devices. This patch allows this
to happen by implementing ndo_change_rx_flags() and ndo_set_rx_mode()
API calls that in turns pass it to the slave devices using
existing API calls.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 8884c6939913 ("hsr: use rtnl lock when iterating over ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 67 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 511407df49151..e9a1a5cf120dd 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -170,7 +170,24 @@ static int hsr_dev_open(struct net_device *dev)
 
 static int hsr_dev_close(struct net_device *dev)
 {
-	/* Nothing to do here. */
+	struct hsr_port *port;
+	struct hsr_priv *hsr;
+
+	hsr = netdev_priv(dev);
+	hsr_for_each_port(hsr, port) {
+		if (port->type == HSR_PT_MASTER)
+			continue;
+		switch (port->type) {
+		case HSR_PT_SLAVE_A:
+		case HSR_PT_SLAVE_B:
+			dev_uc_unsync(port->dev, dev);
+			dev_mc_unsync(port->dev, dev);
+			break;
+		default:
+			break;
+		}
+	}
+
 	return 0;
 }
 
@@ -401,12 +418,60 @@ void hsr_del_ports(struct hsr_priv *hsr)
 		hsr_del_port(port);
 }
 
+static void hsr_set_rx_mode(struct net_device *dev)
+{
+	struct hsr_port *port;
+	struct hsr_priv *hsr;
+
+	hsr = netdev_priv(dev);
+
+	hsr_for_each_port(hsr, port) {
+		if (port->type == HSR_PT_MASTER)
+			continue;
+		switch (port->type) {
+		case HSR_PT_SLAVE_A:
+		case HSR_PT_SLAVE_B:
+			dev_mc_sync_multiple(port->dev, dev);
+			dev_uc_sync_multiple(port->dev, dev);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void hsr_change_rx_flags(struct net_device *dev, int change)
+{
+	struct hsr_port *port;
+	struct hsr_priv *hsr;
+
+	hsr = netdev_priv(dev);
+
+	hsr_for_each_port(hsr, port) {
+		if (port->type == HSR_PT_MASTER)
+			continue;
+		switch (port->type) {
+		case HSR_PT_SLAVE_A:
+		case HSR_PT_SLAVE_B:
+			if (change & IFF_ALLMULTI)
+				dev_set_allmulti(port->dev,
+						 dev->flags &
+						 IFF_ALLMULTI ? 1 : -1);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 static const struct net_device_ops hsr_device_ops = {
 	.ndo_change_mtu = hsr_dev_change_mtu,
 	.ndo_open = hsr_dev_open,
 	.ndo_stop = hsr_dev_close,
 	.ndo_start_xmit = hsr_dev_xmit,
+	.ndo_change_rx_flags = hsr_change_rx_flags,
 	.ndo_fix_features = hsr_fix_features,
+	.ndo_set_rx_mode = hsr_set_rx_mode,
 };
 
 static struct device_type hsr_type = {
-- 
2.51.0



