Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0173A13A26F;
	Tue, 27 Feb 2024 14:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042976; cv=none; b=LZDVEGSTTVpVevttecwUNu4q4WjuiJ9diq8EmmgUKjC1l4ZnCYvVoKs/dFz0LJjdUICuOwpX8s3PN2aYdIkzrTKunu2e4qxhE51sfEWdb9RnRPcetEy2/oSNJTBvfvUttsXW6cN8AtMRz/IynmZdyd0nmfpdeXNN5Hmni2QhOMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042976; c=relaxed/simple;
	bh=dlV5pKSDSdwvtR58+YVtmhiBijOzPYaJfn4dwd3m9RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkTSPsMsSjTofJ/gQIVUHKRjEf4dcmSGAsBaRT5/zm+tejwKcdkv2qIc+o1dg/CUd6PH+nxxR+p5hSiQtSs5pIdoBy89CoW19P5oxS5LYCzhl34gcBVEqnK8YUFmnL69XVYzt/94WuqMb03SQ2o8qXLFiVsqm0PwSSJXAO+ylXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y35oJUfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y35oJUfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8E7C433F1;
	Tue, 27 Feb 2024 14:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042975;
	bh=dlV5pKSDSdwvtR58+YVtmhiBijOzPYaJfn4dwd3m9RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y35oJUflZVZDP+3/22zv8T5QWEMOdIw2FY2A9P8sjAGTLezWIUAgDYHGr5UShUb3N
	 6vocEtFj39hFMe162pmj1sVZY6mNZ7q+jaCAlAdbxEPuLWSEOFuXBBhbHamInN6zD7
	 Ee6tq/C/4J1ebbfUTe1jFmAuBSAC82GChqeVw26s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Qing <wangqing@vivo.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/245] net: ethernet: ti: add missing of_node_put before return
Date: Tue, 27 Feb 2024 14:25:38 +0100
Message-ID: <20240227131620.090094364@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
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
index 1fa6f0dacd2de..f94d6d322df42 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1856,13 +1856,14 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
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
@@ -1878,8 +1879,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				(AM65_CPSW_NU_FRAM_PORT_OFFSET * (port_id - 1));
 
 		port->slave.mac_sl = cpsw_sl_get("am65", dev, port->port_base);
-		if (IS_ERR(port->slave.mac_sl))
-			return PTR_ERR(port->slave.mac_sl);
+		if (IS_ERR(port->slave.mac_sl)) {
+			ret = PTR_ERR(port->slave.mac_sl);
+			goto of_node_put;
+		}
 
 		port->disabled = !of_device_is_available(port_np);
 		if (port->disabled) {
@@ -1892,7 +1895,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			ret = PTR_ERR(port->slave.ifphy);
 			dev_err(dev, "%pOF error retrieving port phy: %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		port->slave.mac_only =
@@ -1901,10 +1904,12 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
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
@@ -1914,14 +1919,15 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
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
 
 		ret = of_get_mac_address(port_np, port->slave.mac_addr);
@@ -1944,6 +1950,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 	}
 
 	return 0;
+
+of_node_put:
+	of_node_put(port_np);
+	of_node_put(node);
+	return ret;
 }
 
 static void am65_cpsw_pcpu_stats_free(void *data)
-- 
2.43.0



