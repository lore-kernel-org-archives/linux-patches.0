Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A071DA112;
	Wed, 19 Mar 2025 14:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395095; cv=none; b=PkoL5N4mfi0diZINAukkhrxNfamr73ZwK8WOA7jsHcXULFvPFQfSTL7+JrWdlWDr81KHq1D+Vt8gRhQyAHMBVEHno3Zm0qTnvoYuQBjHH97DppLnqNLQFOTjZ2hkLVln16XvNOYq1m6h0UCLtFSYn3twPDPXrZlAfXQ9K1XUhos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395095; c=relaxed/simple;
	bh=PFJOY6v4NmlYpX2uWjHI1yrQI3k/xIwajVeWHk+xO1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THT/Lt0x/4hFI+yYZDSgPVulA6IDxVW76hBCceWmwfxc9AjiC/CJB2zKAaWq7ti05xfYqzwaRBl8OvNStSRCYwfOI3jav1stdvlQ5ZRA2q6S+YWrgrzq/d4JwFeZyHfD3m9YaqwmIe+rw3jOfHEr2HcmXTR8VLGHcp2IfPfBaG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyi63xdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyi63xdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A1FC4CEE4;
	Wed, 19 Mar 2025 14:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395095;
	bh=PFJOY6v4NmlYpX2uWjHI1yrQI3k/xIwajVeWHk+xO1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyi63xdK1VSrRlfA429KT+S8hFZ183nv/eqQ7uHilkFcGwEA/xIoMm7Ye5xcyvFfI
	 9Fmd6Yslh53r5kmwWAIlTYmG5v8Ft+emnFBF3eUqUTDi3p9fN8iyelFCkgW0Q/IG0S
	 U9aWg9sssND0LzvJWcuB7W0ovlqbqEuN4DR/WEl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/231] phy: ti: gmii-sel: Do not use syscon helper to build regmap
Date: Wed, 19 Mar 2025 07:30:20 -0700
Message-ID: <20250319143029.975705058@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit 5ab90f40121a9f6a9b368274cd92d0f435dc7cfa ]

The syscon helper device_node_to_regmap() is used to fetch a regmap
registered to a device node. It also currently creates this regmap
if the node did not already have a regmap associated with it. This
should only be used on "syscon" nodes. This driver is not such a
device and instead uses device_node_to_regmap() on its own node as
a hacky way to create a regmap for itself.

This will not work going forward and so we should create our regmap
the normal way by defining our regmap_config, fetching our memory
resource, then using the normal regmap_init_mmio() function.

Signed-off-by: Andrew Davis <afd@ti.com>
Tested-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20250123182234.597665-1-afd@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-gmii-sel.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/ti/phy-gmii-sel.c b/drivers/phy/ti/phy-gmii-sel.c
index 103b266fec771..2c2256fe5a3b6 100644
--- a/drivers/phy/ti/phy-gmii-sel.c
+++ b/drivers/phy/ti/phy-gmii-sel.c
@@ -423,6 +423,12 @@ static int phy_gmii_sel_init_ports(struct phy_gmii_sel_priv *priv)
 	return 0;
 }
 
+static const struct regmap_config phy_gmii_sel_regmap_cfg = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+};
+
 static int phy_gmii_sel_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -467,7 +473,14 @@ static int phy_gmii_sel_probe(struct platform_device *pdev)
 
 	priv->regmap = syscon_node_to_regmap(node->parent);
 	if (IS_ERR(priv->regmap)) {
-		priv->regmap = device_node_to_regmap(node);
+		void __iomem *base;
+
+		base = devm_platform_ioremap_resource(pdev, 0);
+		if (IS_ERR(base))
+			return dev_err_probe(dev, PTR_ERR(base),
+					     "failed to get base memory resource\n");
+
+		priv->regmap = regmap_init_mmio(dev, base, &phy_gmii_sel_regmap_cfg);
 		if (IS_ERR(priv->regmap))
 			return dev_err_probe(dev, PTR_ERR(priv->regmap),
 					     "Failed to get syscon\n");
-- 
2.39.5



