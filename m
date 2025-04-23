Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DF9175BF;
	Wed, 23 Apr 2025 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420073; cv=none; b=idkjtWBBgYrdnf4Tm1zBUdq6xWodHIK3g52VsG+SHjxeos9RcENkrXB9g+aGR1z2IsJzpIbzYsLNOcttdCTeQI6/KpLPi3mLV19LoTnj8rIpZY6AJopQm/EejeaT2me1HIJ5NWuQ6gUKjtRRhXk1vk0as2w3rrwwWbFmmbS2AWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420073; c=relaxed/simple;
	bh=+uiZoT4UOS2wvRgP9L1bYKwM5wQccnRXlOgmmennzq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coESweJJWTD6DT1CCtijBtzV4uqRop3SXECQuQAcExDfrAOQ9+fJMTQl7ySiH9x0X/6BmxYKHL2DFkuxjq49PCr+iiSAYugmpVws9Xk2GFLYp/Kly+r4WlYUwxX1yANbM/tqe0kl0nD+dIoXRvRjefxrtv4QGfCpPWJb0Yt5zds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGwx2vc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGwx2vc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DA7C4CEE2;
	Wed, 23 Apr 2025 14:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420073;
	bh=+uiZoT4UOS2wvRgP9L1bYKwM5wQccnRXlOgmmennzq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGwx2vc5OxkRcSCC1l8FxNOd6qs7qNaUNw0+9H161LMCotGGkZ9pe9nu5h4yAyvt0
	 W0umYM0zuCN5caaoCjNifb6+oyD9C0YW1yIi6UcCDmwUB2VrIPyS37wHPu/9kCXnUq
	 mcF/xaoG4ME0VjPBJhiIt5u8eVxO0xgorsJ50vmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 057/241] net: ethernet: ti: am65-cpsw: fix port_np reference counting
Date: Wed, 23 Apr 2025 16:42:01 +0200
Message-ID: <20250423142622.933654904@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 903d2b9f9efc5b3339d74015fcfc0d9fff276c4c ]

A reference to the device tree node is stored in a private struct, thus
the reference count has to be incremented. Also, decrement the count on
device removal and in the error path.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250414083942.4015060-1-mwalle@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index bef734c6e5c2b..afe8127fd32be 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2756,7 +2756,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				of_property_read_bool(port_np, "ti,mac-only");
 
 		/* get phy/link info */
-		port->slave.port_np = port_np;
+		port->slave.port_np = of_node_get(port_np);
 		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
 		if (ret) {
 			dev_err(dev, "%pOF read phy-mode err %d\n",
@@ -2810,6 +2810,17 @@ static void am65_cpsw_nuss_phylink_cleanup(struct am65_cpsw_common *common)
 	}
 }
 
+static void am65_cpsw_remove_dt(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_port *port;
+	int i;
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+		of_node_put(port->slave.port_np);
+	}
+}
+
 static int
 am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 {
@@ -3708,6 +3719,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	am65_cpsw_nuss_cleanup_ndev(common);
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
+	am65_cpsw_remove_dt(common);
 err_of_clear:
 	if (common->mdio_dev)
 		of_platform_device_destroy(common->mdio_dev, NULL);
@@ -3747,6 +3759,7 @@ static void am65_cpsw_nuss_remove(struct platform_device *pdev)
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
 	am65_cpsw_disable_serdes_phy(common);
+	am65_cpsw_remove_dt(common);
 
 	if (common->mdio_dev)
 		of_platform_device_destroy(common->mdio_dev, NULL);
-- 
2.39.5



