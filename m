Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9F229DB8D;
	Wed, 23 Apr 2025 15:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422068; cv=none; b=l2jcJQxLUzXwtStMs5U8fro0iN4RVH7Jp664Snc4AJGEiPzUI8wxeeZAZivgYr3+2Mj2dPmvotBSRVv1P7z5URXK8B3uH3sdzyfacjHiR+z3mC5mWFuaeUIH67fSf8U02zVdXyMIoxWH5kuputIxumVwVtKTHw/Ne+Cg7442ndk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422068; c=relaxed/simple;
	bh=PY8gioSIeKewWwBYZcQpXb7Tfi3W1lxlEkU5R09Shwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frclFqttqogh8qnHUsfA8l1qOxJtnJsyUkprIq8GalzN8fLUv0+CbmNX9rBtBH1eMNVv+i1XJE3ZK4jVwb1f+11gxAi+eR9c5g9mIH8V1ouOJswEMVchgKpmFDj+8RhK8JMlF6P3cZAdxvpz3ATofZZAD15XnB73kbQWtIhHepA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBSeyH+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBSeyH+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B620BC4CEE2;
	Wed, 23 Apr 2025 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422068;
	bh=PY8gioSIeKewWwBYZcQpXb7Tfi3W1lxlEkU5R09Shwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBSeyH+igYKa52FYEgj+eLsibgnh9QooDEnVvjGtdEdPNIUTZaYpUOy8Fz/OtjCwr
	 pzLkA3cDt4kbOHrN9iZEMXaD3cLoHqKXDcNlLRpww6t+mjMlajDiK94dLI6EI/VAZB
	 l3jamInShXqfPtu0VoznLR19fSdJz2cp+9EFSWs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 272/393] net: ethernet: ti: am65-cpsw: fix port_np reference counting
Date: Wed, 23 Apr 2025 16:42:48 +0200
Message-ID: <20250423142654.591016872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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
index dbca0b2889bc5..9c8376b271891 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2076,7 +2076,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				of_property_read_bool(port_np, "ti,mac-only");
 
 		/* get phy/link info */
-		port->slave.port_np = port_np;
+		port->slave.port_np = of_node_get(port_np);
 		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
 		if (ret) {
 			dev_err(dev, "%pOF read phy-mode err %d\n",
@@ -2134,6 +2134,17 @@ static void am65_cpsw_nuss_phylink_cleanup(struct am65_cpsw_common *common)
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
@@ -3009,6 +3020,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 err_free_phylink:
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
+	am65_cpsw_remove_dt(common);
 err_of_clear:
 	if (common->mdio_dev)
 		of_platform_device_destroy(common->mdio_dev, NULL);
@@ -3040,6 +3052,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
 	am65_cpsw_disable_serdes_phy(common);
+	am65_cpsw_remove_dt(common);
 
 	if (common->mdio_dev)
 		of_platform_device_destroy(common->mdio_dev, NULL);
-- 
2.39.5



