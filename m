Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11F119CD1D;
	Thu, 30 Jul 2026 15:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425217; cv=none; b=P6eX+zfEO60vgLaYQhrMqjgWLaKjlRXh6egWdGQ1OAaseATULgeKz9xP76xHf+YJ71lezDh97U3CGxjKrNtt+sdxQwXvFcWR7CtTpJ5NTCMsPDo50AENAEjq9qBsHHlxpc1NIAnmyD5EYlPD2bTVHIPtjqmvp9QTbNN6rOYCDpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425217; c=relaxed/simple;
	bh=OthIY64F8BU/klWHu3lHqpiseS2SmFfKu76Xu6NX3gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ditg6ajKF519f3z/FkpAMtNxTN99tFBr0YzVkXCyXfOzcnd0I2zw+pjIV1mSx9kpptJSwXBcZqFjtPxh1mUQXQWn5K7Rh9TEYk8Jv58bGi6OGK56xcV2HO9mBQj0mm2ItxX4FoheMNqSj+YgbWOUnAVJzGT8JEUPLwlEB8hBD7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMbHfm9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMbHfm9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3F31F000E9;
	Thu, 30 Jul 2026 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425216;
	bh=MpWyEv/qLaSkmM0wfWKoAfJsR/0ycoZhgkCLY7WTKLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMbHfm9q8ai7ExKa+SnFHHBMekdBmQar4VTtx6pt2Llk2hr9jRcr7m68st5ocoF3l
	 QooqOvcs8LEcxz1TENXbDyFjmnGVDaNrcr7rj3daRUH+ubjvmR7lj0brCuFzZYSFzw
	 iWr1zloosqaAvRuKtFljkFajhTAAPE0ji83wo3fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 664/675] pmdomain: imx93-blk-ctrl: Extract PHY as shared domain for DSI/CSI
Date: Thu, 30 Jul 2026 16:16:34 +0200
Message-ID: <20260730141459.268286095@linuxfoundation.org>
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

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

[ Upstream commit 99611233f8cda833169fa6487d5dacdf189e5cb0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx93-blk-ctrl.c |   60 ++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

--- a/drivers/pmdomain/imx/imx93-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx93-blk-ctrl.c
@@ -47,6 +47,8 @@
 
 #define PRIO(X)			(X)
 
+#define BLK_CTRL_NO_PARENT	UINT_MAX
+
 struct imx93_blk_ctrl_domain;
 
 struct imx93_blk_ctrl {
@@ -67,12 +69,18 @@ struct imx93_blk_ctrl_qos {
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
@@ -202,6 +210,13 @@ static void imx93_release_pm_genpd(void
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
@@ -303,6 +318,34 @@ static int imx93_blk_ctrl_probe(struct p
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
@@ -323,8 +366,9 @@ static const struct imx93_blk_ctrl_domai
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
@@ -332,6 +376,7 @@ static const struct imx93_blk_ctrl_domai
 		.num_clks = 2,
 		.rst_mask = BIT(9) | BIT(10),
 		.clk_mask = BIT(9) | BIT(10),
+		.parent = IMX93_MEDIABLK_PD_MIPI_PHY,
 	},
 	[IMX93_MEDIABLK_PD_PXP] = {
 		.name = "mediablk-pxp",
@@ -339,6 +384,7 @@ static const struct imx93_blk_ctrl_domai
 		.num_clks = 1,
 		.rst_mask = BIT(7) | BIT(8),
 		.clk_mask = BIT(7) | BIT(8),
+		.parent = BLK_CTRL_NO_PARENT,
 		.num_qos = 2,
 		.qos = {
 			{
@@ -360,6 +406,7 @@ static const struct imx93_blk_ctrl_domai
 		.num_clks = 2,
 		.rst_mask = BIT(4) | BIT(5) | BIT(6),
 		.clk_mask = BIT(4) | BIT(5) | BIT(6),
+		.parent = BLK_CTRL_NO_PARENT,
 		.num_qos = 1,
 		.qos = {
 			{
@@ -376,6 +423,7 @@ static const struct imx93_blk_ctrl_domai
 		.num_clks = 1,
 		.rst_mask = BIT(2) | BIT(3),
 		.clk_mask = BIT(2) | BIT(3),
+		.parent = BLK_CTRL_NO_PARENT,
 		.num_qos = 4,
 		.qos = {
 			{
@@ -401,6 +449,14 @@ static const struct imx93_blk_ctrl_domai
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


