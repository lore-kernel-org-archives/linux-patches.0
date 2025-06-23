Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744766136;
	Mon, 23 Jun 2025 21:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714701; cv=none; b=VmG8jft/xi8E9J3HheUm1rEO6PUBjdoHJiEOr8bCNK+SeRG9RpCr2fb/i7ahpG9MW2QJTZtS4qH+0grfpoug2H0BXZeeHNhrk7tyVpCqYPTyR2410rzNePyAS4RcGLVqkQl3c9v0yhFbms4IuGLnEu/DUM6m1elmmg07/QN819M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714701; c=relaxed/simple;
	bh=ffb+uBz0L93L7zLzVbks+qHOp089RbrQbZj5j4zmfTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dsl5Z+TabeDpd2kXH7fQVq1at6FZy78b4O5MggwEaq/s4iMpYVbKDXJNu32Gyq5GHVjupp9DMCcRAtk2hvXrMGTdQCEDmaQwgyB7aAoN9sYTpFHbiBy4HEVwJSZvhOn6t16/7zeUr61SYEJ/iG1wZ2/2+MA/cjCLg7wxEoHqkuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7SLKx2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7SLKx2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C505C4CEEA;
	Mon, 23 Jun 2025 21:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714701;
	bh=ffb+uBz0L93L7zLzVbks+qHOp089RbrQbZj5j4zmfTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7SLKx2F5BBT6bgqnV0RFRPQcCF8p8gm8LVCx+25nGIdGCSeywiYJG0na0Xi4mcCS
	 qxc6QGSFVzCdolhZcu3rP70bQDt2TtHAytB6EqFYTNhjSRoXCl9brilbxm6v55MAnX
	 0M7I2zWBnQzug73Y9HVeMqCF9scuFz4MAlcWB2o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 399/592] net: ethernet: ti: am65-cpsw: handle -EPROBE_DEFER
Date: Mon, 23 Jun 2025 15:05:57 +0200
Message-ID: <20250623130709.933519352@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 09737cb80b8686ffca4ed1805fee745d5c85604d ]

of_get_mac_address() might fetch the MAC address from NVMEM and that
driver might not have been loaded. In that case, -EPROBE_DEFER is
returned. Right now, this will trigger an immediate fallback to
am65_cpsw_am654_get_efuse_macid() possibly resulting in a random MAC
address although the MAC address is stored in the referenced NVMEM.

Fix it by handling the -EPROBE_DEFER return code correctly. This also
means that the creation of the MDIO device has to be moved to a later
stage as -EPROBE_DEFER must not be returned after child devices are
created.

Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250414084336.4017237-3-mwalle@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 30665ffe78cf9..4cec05e0e3d9b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2679,7 +2679,9 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			goto of_node_put;
 
 		ret = of_get_mac_address(port_np, port->slave.mac_addr);
-		if (ret) {
+		if (ret == -EPROBE_DEFER) {
+			goto of_node_put;
+		} else if (ret) {
 			am65_cpsw_am654_get_efuse_macid(port_np,
 							port->port_id,
 							port->slave.mac_addr);
@@ -3561,6 +3563,16 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	am65_cpsw_nuss_get_ver(common);
+
+	ret = am65_cpsw_nuss_init_host_p(common);
+	if (ret)
+		goto err_pm_clear;
+
+	ret = am65_cpsw_nuss_init_slave_ports(common);
+	if (ret)
+		goto err_pm_clear;
+
 	node = of_get_child_by_name(dev->of_node, "mdio");
 	if (!node) {
 		dev_warn(dev, "MDIO node not found\n");
@@ -3577,16 +3589,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	}
 	of_node_put(node);
 
-	am65_cpsw_nuss_get_ver(common);
-
-	ret = am65_cpsw_nuss_init_host_p(common);
-	if (ret)
-		goto err_of_clear;
-
-	ret = am65_cpsw_nuss_init_slave_ports(common);
-	if (ret)
-		goto err_of_clear;
-
 	/* init common data */
 	ale_params.dev = dev;
 	ale_params.ale_ageout = AM65_CPSW_ALE_AGEOUT_DEFAULT;
-- 
2.39.5



