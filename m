Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14EB43DA26;
	Thu, 30 Jul 2026 15:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425214; cv=none; b=QusWbUUalxQF2DIdHC3oni183e4I85kBVA+yZoi2lStc9OASUb1TxhRlQ5+ouNilj9ynCGgJsaBxmp3aekH6UlqXkKLf8VnJJHW4yDuiCgq4tDUsyK+mbmwBc8rLQG5Vq7/chSdYTDVYuoKRxEk+QHVmeHZXXfZkglbp8EwPZV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425214; c=relaxed/simple;
	bh=9iZcv4eDOf+224qSN7gp6u/FETewJjn4JrRsUkvPI84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZLHqJ28Lals63H554Dbb3l9cwtM3vj2wY0P3A+OokqCUhVwqVteNBmXMmNp96dlLab0ziTs7gJY3T500VoIBUnTwk0Ev77tfCR9d8nX0+yP/pOMmSKg/j7rhV9+bURma23NBT18RHlMOItvgc5joPQ+iXisbrK1HY2kfLzFPkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXg4NLyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXg4NLyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFC71F000E9;
	Thu, 30 Jul 2026 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425213;
	bh=/a1N/Lko3SAcVpZajDleQg9Q9yahtUB7YQOKfARdCy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXg4NLyWjg9C41GSMWKVotzO+TbUR6bHQTaAdpikKJuW4Ab4RvtJUs+jmNXUcURsd
	 LDlC25Aup2MQP8rFz+R6qPFhipojsZ6Ya4+rm6vOKraGvJS2/vgYtdhia1ngc9PIvS
	 gyAE90aWYNSwEkDBDzqJPjZcyZNv9voALqtDcGeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 663/675] pmdomain: imx93-blk-ctrl: convert to devm_* only
Date: Thu, 30 Jul 2026 16:16:33 +0200
Message-ID: <20260730141459.244345174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 52becc142280eeef828d19f9cd01fd653b588786 ]

Convert the driver to devm_ APIs only by making use of
devm_add_action_or_reset() and devm_pm_runtime_enable() to simplify the
probe error path and to drop the .remove() callback. This also ensures
that the device release order equals the device probe error path order.

Furthermore drop the dev_set_drvdata() usage since the only user was the
.remove() callback which is removed by this commit.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 99611233f8cd ("pmdomain: imx93-blk-ctrl: Extract PHY as shared domain for DSI/CSI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx93-blk-ctrl.c |   66 ++++++++++++++--------------------
 1 file changed, 29 insertions(+), 37 deletions(-)

--- a/drivers/pmdomain/imx/imx93-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx93-blk-ctrl.c
@@ -188,6 +188,20 @@ static int imx93_blk_ctrl_power_off(stru
 	return 0;
 }
 
+static void imx93_release_genpd_provider(void *data)
+{
+	struct device_node *of_node = data;
+
+	of_genpd_del_provider(of_node);
+}
+
+static void imx93_release_pm_genpd(void *data)
+{
+	struct generic_pm_domain *genpd = data;
+
+	pm_genpd_remove(genpd);
+}
+
 static struct lock_class_key blk_ctrl_genpd_lock_class;
 
 static int imx93_blk_ctrl_probe(struct platform_device *pdev)
@@ -258,10 +272,8 @@ static int imx93_blk_ctrl_probe(struct p
 			domain->clks[j].id = data->clk_names[j];
 
 		ret = devm_clk_bulk_get(dev, data->num_clks, domain->clks);
-		if (ret) {
-			dev_err_probe(dev, ret, "failed to get clock\n");
-			goto cleanup_pds;
-		}
+		if (ret)
+			return dev_err_probe(dev, ret, "failed to get clock\n");
 
 		domain->genpd.name = data->name;
 		domain->genpd.power_on = imx93_blk_ctrl_power_on;
@@ -269,11 +281,12 @@ static int imx93_blk_ctrl_probe(struct p
 		domain->bc = bc;
 
 		ret = pm_genpd_init(&domain->genpd, NULL, true);
-		if (ret) {
-			dev_err_probe(dev, ret, "failed to init power domain\n");
-			goto cleanup_pds;
-		}
+		if (ret)
+			return dev_err_probe(dev, ret, "failed to init power domain\n");
 
+		ret = devm_add_action_or_reset(dev, imx93_release_pm_genpd, &domain->genpd);
+		if (ret)
+			return dev_err_probe(dev, ret, "failed to add pm_genpd release callback\n");
 		/*
 		 * We use runtime PM to trigger power on/off of the upstream GPC
 		 * domain, as a strict hierarchical parent/child power domain
@@ -290,39 +303,19 @@ static int imx93_blk_ctrl_probe(struct p
 		bc->onecell_data.domains[i] = &domain->genpd;
 	}
 
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to enable pm-runtime\n");
 
 	ret = of_genpd_add_provider_onecell(dev->of_node, &bc->onecell_data);
-	if (ret) {
-		dev_err_probe(dev, ret, "failed to add power domain provider\n");
-		goto cleanup_pds;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to add power domain provider\n");
 
-	dev_set_drvdata(dev, bc);
+	ret = devm_add_action_or_reset(dev, imx93_release_genpd_provider, dev->of_node);
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to add genpd_provider release callback\n");
 
 	return 0;
-
-cleanup_pds:
-	for (i--; i >= 0; i--)
-		pm_genpd_remove(&bc->domains[i].genpd);
-
-	return ret;
-}
-
-static void imx93_blk_ctrl_remove(struct platform_device *pdev)
-{
-	struct imx93_blk_ctrl *bc = dev_get_drvdata(&pdev->dev);
-	int i;
-
-	of_genpd_del_provider(pdev->dev.of_node);
-
-	pm_runtime_disable(&pdev->dev);
-
-	for (i = 0; i < bc->onecell_data.num_domains; i++) {
-		struct imx93_blk_ctrl_domain *domain = &bc->domains[i];
-
-		pm_genpd_remove(&domain->genpd);
-	}
 }
 
 static const struct imx93_blk_ctrl_domain_data imx93_media_blk_ctl_domain_data[] = {
@@ -457,7 +450,6 @@ MODULE_DEVICE_TABLE(of, imx93_blk_ctrl_o
 
 static struct platform_driver imx93_blk_ctrl_driver = {
 	.probe = imx93_blk_ctrl_probe,
-	.remove = imx93_blk_ctrl_remove,
 	.driver = {
 		.name = "imx93-blk-ctrl",
 		.of_match_table = imx93_blk_ctrl_of_match,


