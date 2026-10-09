Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A475F399CE9;
	Fri,  9 Oct 2026 14:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555843; cv=none; b=BCYzH62JmDO4x70Wdcb8S2tiUyRXDpACMk560emBnuqUPijeji8BoV4/CjE3X/gwkOGuIRK5p9rEP1DB/VNDh5bfrmyBsNBY9HiuFU38UZXKbyZ9rMiwdvvaMga64Fpw2KoxtNGVWWys7hcjXyLVGdZqzE9+1fSUJagtnSv2RK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555843; c=relaxed/simple;
	bh=r6HVJslfGR/SAJ37mI+deStnXBoPMXxMV25qkws9ZW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3/56oBMEzWntzMtqzJkjWRsVWR+drKMiEToSrGpH7eggDffxdb0DG40H/iZwBd1HZeKLaUE7hb0gKpel7c1/uITQQoJZkqSByjjS/upV6vgLqCu3Z1Cg2opcVsEuNEBo+z5LGIeVq1dFPLEh3aynx6h4Kfq+LoV+gQLwqsxQOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfbIa2Oo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfbIa2Oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BEC1F000FF;
	Fri,  9 Oct 2026 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555842;
	bh=oDYuUqqViovbI8icUFjYOgr+DMPd7pKzcG0BoiaaKPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfbIa2OoHKzQ6gDhdk11a9+VXV91wVfmXN+6A+qxfA/WoUFo2ORRBZR9FXx6W0Xtv
	 N81y/L1juk3p4ATgpP2n+jIY+eOhZHRbWB92M0A6sQJi5GK2OEDcpt8LGVONvnoxK5
	 5FE0cQdt5OWxIMzE2sgzaqqcSPCFjLtDAp7uTS/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Freimanis <quentin@q-lab.dev>,
	Simon Horman <horms@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/403] net: sparx5: make ports inherit the switch base mac address type
Date: Fri,  9 Oct 2026 16:08:08 +0200
Message-ID: <20261009140955.047073923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Quentin Freimanis <quentin@q-lab.dev>

[ Upstream commit 5642b1648d5c4561d8ed7a410d0a7017f706604d ]

When the switch uses a random base MAC address it does not mark each
port's address as random:

  $ dmesg | grep "MAC addr"
  sparx5-switch e00c0000.switch: MAC addr was not set, use random MAC
  $ cat /sys/class/net/eth0/addr_assign_type
  0

0 is NET_ADDR_PERM, so userspace thinks this is a stable address.

With a random MAC reported as NET_ADDR_PERM, systemd's
MACAddressPolicy=persistent [1] leaves it unchanged, so a DHCP client
gets a new IP address every boot and a static reservation can't be used.
Reporting it as NET_ADDR_RANDOM makes systemd replace it with a stable
address derived from the interface name and machine-id.

Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Quentin Freimanis <quentin@q-lab.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20260928045012.30178-1-quentin@q-lab.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c   | 1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_main.h   | 1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index f201cb6c587a7..46837e7efbd07 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -896,6 +896,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
 		eth_random_addr(sparx5->base_mac);
 		sparx5->base_mac[5] = 0;
+		sparx5->base_mac_assign_type = NET_ADDR_RANDOM;
 	}
 
 	sparx5->fdma_irq = platform_get_irq_byname(sparx5->pdev, "fdma");
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 97d53e229ad69..a5675f13a11e2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -392,6 +392,7 @@ struct sparx5 {
 	struct notifier_block switchdev_blocking_nb;
 	/* Switch state */
 	u8 base_mac[ETH_ALEN];
+	u8 base_mac_assign_type;
 	/* Associated bridge device (when bridged) */
 	struct net_device *hw_bridge_dev;
 	/* Bridged interfaces */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 1d34af78166a3..ae84ab7378823 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -289,6 +289,7 @@ struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
 	ndev->ethtool_ops = &sparx5_ethtool_ops;
 
 	eth_hw_addr_gen(ndev, sparx5->base_mac, portno + 1);
+	ndev->addr_assign_type = sparx5->base_mac_assign_type;
 
 	return ndev;
 }
-- 
2.53.0



