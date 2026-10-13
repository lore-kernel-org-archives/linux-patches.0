Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6416C36B937;
	Tue, 13 Oct 2026 12:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894924; cv=none; b=tfnfhDhKm25wlmclwMemRejEFsMZRAQcJ+pEAQmDJKaCY8U1bAuD28EuAY5DDvXUyv1vOT4fpxUpeqWC+V2LtMRZ8hAqcLlTH7O9EIc/bjxGQJbyURVIJGdGUDoWtGpLT4N6+ycoBDLI0GOhhWlHOPdIM+SVZI6cEXpMyro9oZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894924; c=relaxed/simple;
	bh=EAwFQsOandrWoGAr5GzUi2JcV1UkjwOvKVsg9X7ReHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aydGKGhZHmE0c0+mKEFW4lAZ5YAdBWwMTD4IZai86XQ+kbEE4vFf9oDwstFPr+tQtw9Rxbh+OFLNJy7pmrQKIzY4FjJJkNvr5ZMt4XtJHiMhpO7XTvbnmDy04zqnqAwtliapdzkwVWyjMcMRaqF/fx0gwAKVhWQyYBU9EQ9x67M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EM1F5qUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EM1F5qUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0051F000FF;
	Tue, 13 Oct 2026 12:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894923;
	bh=P31xPRMwOYsgUqq8SH2E86T+AkiMXK4ebe7VnTU9kzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EM1F5qUtJ5UtRvo2aZNjVBhzf2Bync9BGkFCZQYYlL279hmVRPfnAFsAPrB+jmX1T
	 sip0gGdj1F3pd7qY9NAY8FNLkfRW1B+ZEUqRB5i3bku8bNJnM3dlHcPigQnypd4Fjh
	 91AHFBXqPoaEHYPaq41AXWCw0RyJ5Dhx7A25J6lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Freimanis <quentin@q-lab.dev>,
	Simon Horman <horms@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/497] net: sparx5: make ports inherit the switch base mac address type
Date: Tue, 13 Oct 2026 13:34:30 +0200
Message-ID: <20261013112910.336166915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0c4c75b3682fa..5b83cd4b6270b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -843,6 +843,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
 		eth_random_addr(sparx5->base_mac);
 		sparx5->base_mac[5] = 0;
+		sparx5->base_mac_assign_type = NET_ADDR_RANDOM;
 	}
 
 	sparx5->fdma_irq = platform_get_irq_byname(sparx5->pdev, "fdma");
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 3309060b1e4c6..fde3e3d686d17 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -252,6 +252,7 @@ struct sparx5 {
 	struct notifier_block switchdev_blocking_nb;
 	/* Switch state */
 	u8 base_mac[ETH_ALEN];
+	u8 base_mac_assign_type;
 	/* Associated bridge device (when bridged) */
 	struct net_device *hw_bridge_dev;
 	/* Bridged interfaces */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 705a004b324fd..62025aba558cd 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -281,6 +281,7 @@ struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
 	ndev->ethtool_ops = &sparx5_ethtool_ops;
 
 	eth_hw_addr_gen(ndev, sparx5->base_mac, portno + 1);
+	ndev->addr_assign_type = sparx5->base_mac_assign_type;
 
 	return ndev;
 }
-- 
2.53.0



