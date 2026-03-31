Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAD53033CC;
	Tue, 31 Mar 2026 17:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976541; cv=none; b=MebojKaKGBR36rHANVM9VKFowTfxGS3BYfB4mBefs6VsKJcTGuMA667BHt5oFtG+ASLrOj7dUpApi3DFFi/1nXZm+kbBRQogvWq5/ClukHUDfJEf5ARoXv8i5iqPj7kgU5FtOQdFDQoe9p2lLlySGcPM9N5tpU+HbqbA4V+fXrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976541; c=relaxed/simple;
	bh=/3ulhgmdd2KYEUIwCsI4XbMwjma9q+2uB5sxmxdXQMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQI0/SiiHrA+Mj2ntuQK2u6muWa+CHmiiNIJ8HzIq9Q0KDYbyqTVsPJLOUJkdd8slqEwlx5niJwcnk3wa4XSTh3DWPjXrYwbvuiIi/I68FhqpZoOGSn3KVQMfdS3ac5JpJCFHRhmtqqdqLqiFOsRJ+wvBRgCbv8rBPVy7qBcbYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNsoXL8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNsoXL8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B41C19423;
	Tue, 31 Mar 2026 17:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976541;
	bh=/3ulhgmdd2KYEUIwCsI4XbMwjma9q+2uB5sxmxdXQMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNsoXL8KzA05pu2cOiCsUZ/kUddD6rs59/WZSvVqn5ZO9jK57WPv2u2jBz6gAP1g7
	 tCNBFPSyoovbogeIqmZwtq54Kre5TmkBwlf6cOsTXoRMXuQPIxKXGb401CCOf+T7/B
	 /iy3jN3FRsocQrs6hW8d01xgz6HXDm2eTjMR2ZP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/309] net: bcmasp: fix double disable of clk
Date: Tue, 31 Mar 2026 18:20:02 +0200
Message-ID: <20260331161757.132974846@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 27dfe9030acbc601c260b42ecdbb4e5858a97b53 ]

Switch to devm_clk_get_optional() so we can manage the clock ourselves.
We dynamically control the clocks depending on the state of the interface
for power savings. The default state is clock disabled, so unbinding the
driver causes a double disable.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260319234813.1937315-3-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c | 33 ++++++++++++++-------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index fac795ac0fcee..1fdf0822c8a02 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -1254,7 +1254,7 @@ static int bcmasp_probe(struct platform_device *pdev)
 	if (priv->irq <= 0)
 		return -EINVAL;
 
-	priv->clk = devm_clk_get_optional_enabled(dev, "sw_asp");
+	priv->clk = devm_clk_get_optional(dev, "sw_asp");
 	if (IS_ERR(priv->clk))
 		return dev_err_probe(dev, PTR_ERR(priv->clk),
 				     "failed to request clock\n");
@@ -1282,6 +1282,10 @@ static int bcmasp_probe(struct platform_device *pdev)
 
 	bcmasp_set_pdata(priv, pdata);
 
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to start clock\n");
+
 	/* Enable all clocks to ensure successful probing */
 	bcmasp_core_clock_set(priv, ASP_CTRL_CLOCK_CTRL_ASP_ALL_DISABLE, 0);
 
@@ -1293,8 +1297,10 @@ static int bcmasp_probe(struct platform_device *pdev)
 
 	ret = devm_request_irq(&pdev->dev, priv->irq, bcmasp_isr, 0,
 			       pdev->name, priv);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to request ASP interrupt: %d", ret);
+	if (ret) {
+		dev_err(dev, "Failed to request ASP interrupt: %d", ret);
+		goto err_clock_disable;
+	}
 
 	/* Register mdio child nodes */
 	of_platform_populate(dev->of_node, bcmasp_mdio_of_match, NULL, dev);
@@ -1306,13 +1312,17 @@ static int bcmasp_probe(struct platform_device *pdev)
 
 	priv->mda_filters = devm_kcalloc(dev, priv->num_mda_filters,
 					 sizeof(*priv->mda_filters), GFP_KERNEL);
-	if (!priv->mda_filters)
-		return -ENOMEM;
+	if (!priv->mda_filters) {
+		ret = -ENOMEM;
+		goto err_clock_disable;
+	}
 
 	priv->net_filters = devm_kcalloc(dev, priv->num_net_filters,
 					 sizeof(*priv->net_filters), GFP_KERNEL);
-	if (!priv->net_filters)
-		return -ENOMEM;
+	if (!priv->net_filters) {
+		ret = -ENOMEM;
+		goto err_clock_disable;
+	}
 
 	bcmasp_core_init_filters(priv);
 
@@ -1321,7 +1331,8 @@ static int bcmasp_probe(struct platform_device *pdev)
 	ports_node = of_find_node_by_name(dev->of_node, "ethernet-ports");
 	if (!ports_node) {
 		dev_warn(dev, "No ports found\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_clock_disable;
 	}
 
 	i = 0;
@@ -1343,8 +1354,6 @@ static int bcmasp_probe(struct platform_device *pdev)
 	 */
 	bcmasp_core_clock_set(priv, 0, ASP_CTRL_CLOCK_CTRL_ASP_ALL_DISABLE);
 
-	clk_disable_unprepare(priv->clk);
-
 	/* Now do the registration of the network ports which will take care
 	 * of managing the clock properly.
 	 */
@@ -1357,12 +1366,16 @@ static int bcmasp_probe(struct platform_device *pdev)
 		count++;
 	}
 
+	clk_disable_unprepare(priv->clk);
+
 	dev_info(dev, "Initialized %d port(s)\n", count);
 
 	return ret;
 
 err_cleanup:
 	bcmasp_remove_intfs(priv);
+err_clock_disable:
+	clk_disable_unprepare(priv->clk);
 
 	return ret;
 }
-- 
2.51.0



