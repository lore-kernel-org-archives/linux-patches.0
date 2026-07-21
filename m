Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624CF39B4A2;
	Tue, 21 Jul 2026 17:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655199; cv=none; b=q+6xr+RxsKiIEUsRSkCbjAVrDnS4p/g106JGzcIxPWmtQRBVGe+tUKttcn51/tgxuT3DP0G76W5RMHf9yjNtfeuA1VLq9YYo/6ELLpQOiNWgU9S2roV8mLdPqxV5qeAHqhESskmoqxiHWWsJyUmfvqkxuVePeE4USMA/CpIyAXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655199; c=relaxed/simple;
	bh=TssOHHWTlYZ/F6gVP5ZiLOoilvqe2NfOUs4QhEvCwmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9DklRnikiok4hJn8ScF4TDV+AmsncNMer5I37yEOKd/odbzlF9jKR7bGdJ8KhMY3xC8iu01SrnkiPNijIQ+eCtEpmglioxT+7k6zX0pb0vSKblP+rnQn/ITFWaXld4FPDCeOYkFyY3FcLtmxwaW2U429DIaaLLxV+auFVepGNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbBSH9tU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbBSH9tU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5991F000E9;
	Tue, 21 Jul 2026 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655198;
	bh=n6pZCAiEAv5w4M78E0J7c0M6jgs2pq1Ya2JJrGihBmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbBSH9tUZlZRQcoFffaYT2qCcaBS5bvRDDXInfwyrbjgck5po61ex3peGoCdX5rU+
	 Tb+en4c/ZO4ree/SattCSYnDUYhAJUu6+2ww2WJpfhwwBV8S8wceoDSaoJqKsK6AcT
	 SH25DIrx/GeVIECbL1RBkDH/2d1m5wcFgUVBXTxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 1994/2077] pmdomain: imx93-blk-ctrl: Extract PHY as shared domain for DSI/CSI
Date: Tue, 21 Jul 2026 17:27:47 +0200
Message-ID: <20260721152639.742930900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

commit 99611233f8cda833169fa6487d5dacdf189e5cb0 upstream.

The MIPI DSI and CSI domains share control bits for clock and reset, which
can lead to incorrect behavior if one domain disables the shared resource
while the other is still active.

To fix the issue, introduce a shared MIPI PHY power domain to own the
common resources and make DSI and CSI its subdomains. This ensures the
shared bits are properly managed and not disabled while still in use.

Fixes: e9aa77d413c9 ("soc: imx: add i.MX93 media blk ctrl driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx93-blk-ctrl.c |   60 ++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

--- a/drivers/pmdomain/imx/imx93-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx93-blk-ctrl.c
@@ -48,6 +48,8 @@
 
 #define PRIO(X)			(X)
 
+#define BLK_CTRL_NO_PARENT	UINT_MAX
+
 struct imx93_blk_ctrl_domain;
 
 struct imx93_blk_ctrl {
@@ -68,12 +70,18 @@ struct imx93_blk_ctrl_qos {
 	u32 cfg_prio;
 };
 
+struct imx93_blk_ctrl_subdomain_link {
+	struct generic_pm_domain *parent;
+	struct generic_pm_domain *subdomain;
+};
+
 struct imx93_blk_ctrl_domain_data {
 	const char *name;
 	const char * const *clk_names;
 	int num_clks;
 	u32 rst_mask;
 	u32 clk_mask;
+	u32 parent;
 	int num_qos;
 	struct imx93_blk_ctrl_qos qos[DOMAIN_MAX_QOS];
 };
@@ -203,6 +211,13 @@ static void imx93_release_pm_genpd(void
 	pm_genpd_remove(genpd);
 }
 
+static void imx93_release_subdomain(void *data)
+{
+	struct imx93_blk_ctrl_subdomain_link *link = data;
+
+	pm_genpd_remove_subdomain(link->parent, link->subdomain);
+}
+
 static struct lock_class_key blk_ctrl_genpd_lock_class;
 
 static int imx93_blk_ctrl_probe(struct platform_device *pdev)
@@ -302,6 +317,34 @@ static int imx93_blk_ctrl_probe(struct p
 		bc->onecell_data.domains[i] = &domain->genpd;
 	}
 
+	for (i = 0; i < bc_data->num_domains; i++) {
+		struct imx93_blk_ctrl_domain *domain = &bc->domains[i];
+		const struct imx93_blk_ctrl_domain_data *data = domain->data;
+		struct imx93_blk_ctrl_subdomain_link *link;
+
+		if (bc_data->skip_mask & BIT(i) ||
+		    data->parent == BLK_CTRL_NO_PARENT)
+			continue;
+
+		link = devm_kzalloc(dev, sizeof(*link), GFP_KERNEL);
+		if (!link)
+			return -ENOMEM;
+
+		link->parent = &bc->domains[data->parent].genpd;
+		link->subdomain = &domain->genpd;
+
+		ret = pm_genpd_add_subdomain(&bc->domains[data->parent].genpd,
+					     &domain->genpd);
+		if (ret)
+			return dev_err_probe(dev, ret, "failed to add subdomain %s\n",
+					     domain->genpd.name);
+
+		ret = devm_add_action_or_reset(dev, imx93_release_subdomain, link);
+		if (ret)
+			return dev_err_probe(dev, ret,
+					     "failed to add subdomain release callback\n");
+	}
+
 	ret = devm_pm_runtime_enable(dev);
 	if (ret)
 		return dev_err_probe(dev, ret, "failed to enable pm-runtime\n");
@@ -326,8 +369,9 @@ static const struct imx93_blk_ctrl_domai
 		.name = "mediablk-mipi-dsi",
 		.clk_names = (const char *[]){ "dsi" },
 		.num_clks = 1,
-		.rst_mask = BIT(11) | BIT(12),
-		.clk_mask = BIT(11) | BIT(12),
+		.rst_mask = BIT(11),
+		.clk_mask = BIT(11),
+		.parent = IMX93_MEDIABLK_PD_MIPI_PHY,
 	},
 	[IMX93_MEDIABLK_PD_MIPI_CSI] = {
 		.name = "mediablk-mipi-csi",
@@ -335,6 +379,7 @@ static const struct imx93_blk_ctrl_domai
 		.num_clks = 2,
 		.rst_mask = BIT(9) | BIT(10),
 		.clk_mask = BIT(9) | BIT(10),
+		.parent = IMX93_MEDIABLK_PD_MIPI_PHY,
 	},
 	[IMX93_MEDIABLK_PD_PXP] = {
 		.name = "mediablk-pxp",
@@ -342,6 +387,7 @@ static const struct imx93_blk_ctrl_domai
 		.num_clks = 1,
 		.rst_mask = BIT(7) | BIT(8),
 		.clk_mask = BIT(7) | BIT(8),
+		.parent = BLK_CTRL_NO_PARENT,
 		.num_qos = 2,
 		.qos = {
 			{
@@ -363,6 +409,7 @@ static const struct imx93_blk_ctrl_domai
 		.num_clks = 2,
 		.rst_mask = BIT(4) | BIT(5) | BIT(6),
 		.clk_mask = BIT(4) | BIT(5) | BIT(6),
+		.parent = BLK_CTRL_NO_PARENT,
 		.num_qos = 1,
 		.qos = {
 			{
@@ -379,6 +426,7 @@ static const struct imx93_blk_ctrl_domai
 		.num_clks = 1,
 		.rst_mask = BIT(2) | BIT(3),
 		.clk_mask = BIT(2) | BIT(3),
+		.parent = BLK_CTRL_NO_PARENT,
 		.num_qos = 4,
 		.qos = {
 			{
@@ -404,6 +452,14 @@ static const struct imx93_blk_ctrl_domai
 			}
 		}
 	},
+	[IMX93_MEDIABLK_PD_MIPI_PHY] = {
+		.name = "mediablk-mipi-phy",
+		.clk_names = NULL,
+		.num_clks = 0,
+		.rst_mask = BIT(12),
+		.clk_mask = BIT(12),
+		.parent = BLK_CTRL_NO_PARENT,
+	},
 };
 
 static const struct regmap_range imx93_media_blk_ctl_yes_ranges[] = {


