Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B673A3081A1;
	Tue, 30 Sep 2025 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245044; cv=none; b=k6+WqJB2S8CP6wLorNZfM1dtj0We0LDPFUt0P0eHp/g7QPUhtJ95x8+FmHgUZjFGOlPg9R7j66eO8BEWb39kFwUYFnTs9X3s92Jt87NKozl+OdICpeuqyuKI1glHiosAhnusfpaUr0ei2NR3m/3R6CUkeATNGhiNPonO7VLPDIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245044; c=relaxed/simple;
	bh=ljWpEEzDqEBj0MCHEgj7YQJ6EyMVFdixLDOy/OY+zeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUjvCqbcS1QYi82kRLWpkSX2GPrenGpanB5nuZtHCy/ejqf9LPUaBP2Gi17q+qRqIGZlJ+Tb7Ri4Na6PrBcAAD8ShclLkkNNktYDvtr2pKEvBfAxLABzhW1CWDeQSFpqAwfj4+waVfqatzQAgQkXHZsvb2gsJWwg+wSaFia5ims=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6Rett9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6Rett9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAF0C113D0;
	Tue, 30 Sep 2025 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245044;
	bh=ljWpEEzDqEBj0MCHEgj7YQJ6EyMVFdixLDOy/OY+zeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6Rett9H56HLeBeoLnPNBnEYDIX6Jy3eECvEyrBRDydyp/TgJHLBgncE2Kv123v4m
	 16PPr1tHRwnMku4dXxy0ZWiennSyFuCEPKTGANc463JrBHd8+n/1UPCYEm9hoEuDgM
	 a+9OB9Vm6HZYfhFmqqzJ+MLyl8hfdi2uIVX+i9BY=
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
Subject: [PATCH 5.15 048/151] net: hsr: Add support for MC filtering at the slave device
Date: Tue, 30 Sep 2025 16:46:18 +0200
Message-ID: <20250930143829.523443042@linuxfoundation.org>
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
index 4967dc22824c7..5b7bca9e7e5ae 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -173,7 +173,24 @@ static int hsr_dev_open(struct net_device *dev)
 
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
 
@@ -404,12 +421,60 @@ void hsr_del_ports(struct hsr_priv *hsr)
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



