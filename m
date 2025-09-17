Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8530B32BC13;
	Wed, 17 Sep 2025 12:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113863; cv=none; b=ZbhG49VqHGI8/2Udr7TGJRyeXGBC4eZBLYmQSxC+OlH7afKVWlZbpvBJOWQZELJNYnq+4ZYL6tu9IE/Nd8nFqLUxdD0/CPXqWq2eND18kFz/eDdAy4vcltfjl/eYWiFdJ91/Jjk/N3aLez+Os3081o70mTNThNzoxRNJeZB8jGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113863; c=relaxed/simple;
	bh=EEfKpmJwfuBrGTrd0/uvQTp/RnZWPv1dcqb80ApLDRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vve60peaBVWfQFFjDWkmJQw7jZYHJ0q9YjZAdtgExHF2Qpc8teSsgmbey2fkBttiq8UMx6RhwV+ZPfzxezUO6ISiadeh+l13Dk3u50r1G4U//o4t/EBW73L1v15olZIZip7o/mES/sS2deGhLCotXR8soHq3rvoN1b5R9Bte+j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qr0eJrzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr0eJrzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F91C4CEFB;
	Wed, 17 Sep 2025 12:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113863;
	bh=EEfKpmJwfuBrGTrd0/uvQTp/RnZWPv1dcqb80ApLDRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qr0eJrzlLWnFA9tWTUl7k/JsbqBPlEVsd2zNxlwU/a7D+5OHlrBYxVemF4j2imVXO
	 pVHWEhOaHOmULnK1BklPPDBbqAGuwJhRa1Kofl86FRD8p8aGNWXBWulIcal2FAtx2F
	 lr8TacUgWf0RZt93zfOo4sHXb4EsDopKgAz8Uwjk=
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
Subject: [PATCH 6.6 077/101] net: hsr: Add support for MC filtering at the slave device
Date: Wed, 17 Sep 2025 14:35:00 +0200
Message-ID: <20250917123338.698628915@linuxfoundation.org>
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
index 906c38b9d66ff..cff37637c96d3 100644
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



