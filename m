Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546868820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5F7C4339B;
	Fri, 10 Mar 2023 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459760;
	bh=FG13CUAL75KAN25BOQAHmETjCOd+JG96/UF35bdDbAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRSrRN90UHuGcLhgqrfPdviFvrfqm1S6nb++NgSjg4pRgNDdd24dIJikBnww+KRqW
	 86zBUZTm1dhBUQ0LCmi7/kxNYlQDHzsNszpPBROrdHFmiKUV9CyguQ48aBy+sNNkQV
	 +QhZPTsZmfV9rCX0vDXIxYskEZ7/gGXbXphLvjR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Qing <wangqing@vivo.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/529] net: ethernet: ti: add missing of_node_put before return
Date: Fri, 10 Mar 2023 14:34:13 +0100
Message-Id: <20230310133810.088199929@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Qing <wangqing@vivo.com>

[ Upstream commit be565ec71d1d59438bed0c7ed0a252a327e0b0ef ]

Fix following coccicheck warning:
WARNING: Function "for_each_child_of_node"
should have of_node_put() before return.

Early exits from for_each_child_of_node should decrement the
node reference counter.

Signed-off-by: Wang Qing <wangqing@vivo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 29 ++++++++++++++++--------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 5300e1439e1e5..4074310abcff4 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1724,13 +1724,14 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (ret < 0) {
 			dev_err(dev, "%pOF error reading port_id %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		if (!port_id || port_id > common->port_num) {
 			dev_err(dev, "%pOF has invalid port_id %u %s\n",
 				port_np, port_id, port_np->name);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto of_node_put;
 		}
 
 		port = am65_common_get_port(common, port_id);
@@ -1746,8 +1747,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				(AM65_CPSW_NU_FRAM_PORT_OFFSET * (port_id - 1));
 
 		port->slave.mac_sl = cpsw_sl_get("am65", dev, port->port_base);
-		if (IS_ERR(port->slave.mac_sl))
-			return PTR_ERR(port->slave.mac_sl);
+		if (IS_ERR(port->slave.mac_sl)) {
+			ret = PTR_ERR(port->slave.mac_sl);
+			goto of_node_put;
+		}
 
 		port->disabled = !of_device_is_available(port_np);
 		if (port->disabled)
@@ -1758,7 +1761,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			ret = PTR_ERR(port->slave.ifphy);
 			dev_err(dev, "%pOF error retrieving port phy: %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		port->slave.mac_only =
@@ -1767,10 +1770,12 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		/* get phy/link info */
 		if (of_phy_is_fixed_link(port_np)) {
 			ret = of_phy_register_fixed_link(port_np);
-			if (ret)
-				return dev_err_probe(dev, ret,
+			if (ret) {
+				ret = dev_err_probe(dev, ret,
 						     "failed to register fixed-link phy %pOF\n",
 						     port_np);
+				goto of_node_put;
+			}
 			port->slave.phy_node = of_node_get(port_np);
 		} else {
 			port->slave.phy_node =
@@ -1780,14 +1785,15 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (!port->slave.phy_node) {
 			dev_err(dev,
 				"slave[%d] no phy found\n", port_id);
-			return -ENODEV;
+			ret = -ENODEV;
+			goto of_node_put;
 		}
 
 		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
 		if (ret) {
 			dev_err(dev, "%pOF read phy-mode err %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		mac_addr = of_get_mac_address(port_np);
@@ -1804,6 +1810,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 	of_node_put(node);
 
 	return 0;
+
+of_node_put:
+	of_node_put(port_np);
+	of_node_put(node);
+	return ret;
 }
 
 static void am65_cpsw_pcpu_stats_free(void *data)
-- 
2.39.2



