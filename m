Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B9E359FA0;
	Fri,  9 Jan 2026 12:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961185; cv=none; b=AoZHYiExD19EI44kg0U4/GPqjEjrLfoTAT1jISYTK0hcTXzlsMsc4pHuzjYvM0ea06S+ZouB2nEQO0fJIuQKC/ndcre+VoqZbhcZT/GqQ3ssRVWfIQ9tZOqISUC4UFcOgU4aObKeznMJWIeiz/aKDSAHMDEA0A75YiyR1NEz4bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961185; c=relaxed/simple;
	bh=+Z5N6BEiHyE7wGc2HnjPVaCeblq//h4fEQarawgYtjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcg2Fa3a2ODcdvKijWc7DdWt0xKYYLmioNeTsW5Ivm7w0FkMY1CxtuuTJ9NcgonTLdkQBEqlVrA+kY1Mu78h4T+9UPJz7o7DABHxEbRTxnNw3P/rl6lcSKThpKlPFMrtwlCn9JBwrjr/A96lZpx08qcW9/mii6fwiyDC2uaEvwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ediiIg3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ediiIg3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D572CC4CEF1;
	Fri,  9 Jan 2026 12:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961185;
	bh=+Z5N6BEiHyE7wGc2HnjPVaCeblq//h4fEQarawgYtjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ediiIg3Q4uDsKhJ/o170mtARBqU/jVKa2HIweBolhj5Fb0A5eyanBO80KE6wrVcaq
	 eOyq3SZrn8++AwWZly3621RXIlZxolULEi0J+dD0LfUAMLftIvxWWF18RzYQC+K58q
	 jIxbP0vtJFUcmzkOByc3KMxtnsKL+2UJKENgf6NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 664/737] drm/mediatek: Fix probe resource leaks
Date: Fri,  9 Jan 2026 12:43:23 +0100
Message-ID: <20260109112159.020121146@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 07c7c640a8eb9e196f357d15d88a59602a947197 ]

Make sure to unmap and release the component iomap and clock on probe
failure (e.g. probe deferral) and on driver unbind.

Note that unlike of_iomap(), devm_of_iomap() also checks whether the
region is already mapped.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Cc: stable@vger.kernel.org	# 4.7
Cc: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250923152340.18234-2-johan@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c |   20 ++++++++++++++++----
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h |    2 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c      |    4 ++--
 3 files changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -543,15 +543,20 @@ unsigned int mtk_drm_find_possible_crtc_
 	return ret;
 }
 
-int mtk_ddp_comp_init(struct device_node *node, struct mtk_ddp_comp *comp,
+static void mtk_ddp_comp_clk_put(void *_clk)
+{
+	struct clk *clk = _clk;
+
+	clk_put(clk);
+}
+
+int mtk_ddp_comp_init(struct device *dev, struct device_node *node, struct mtk_ddp_comp *comp,
 		      unsigned int comp_id)
 {
 	struct platform_device *comp_pdev;
 	enum mtk_ddp_comp_type type;
 	struct mtk_ddp_comp_dev *priv;
-#if IS_REACHABLE(CONFIG_MTK_CMDQ)
 	int ret;
-#endif
 
 	if (comp_id >= DDP_COMPONENT_DRM_ID_MAX)
 		return -EINVAL;
@@ -592,11 +597,18 @@ int mtk_ddp_comp_init(struct device_node
 	if (!priv)
 		return -ENOMEM;
 
-	priv->regs = of_iomap(node, 0);
+	priv->regs = devm_of_iomap(dev, node, 0, NULL);
+	if (IS_ERR(priv->regs))
+		return PTR_ERR(priv->regs);
+
 	priv->clk = of_clk_get(node, 0);
 	if (IS_ERR(priv->clk))
 		return PTR_ERR(priv->clk);
 
+	ret = devm_add_action_or_reset(dev, mtk_ddp_comp_clk_put, priv->clk);
+	if (ret)
+		return ret;
+
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
 	ret = cmdq_dev_get_client_reg(comp->dev, &priv->cmdq_reg, 0);
 	if (ret)
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h
@@ -279,7 +279,7 @@ int mtk_ddp_comp_get_id(struct device_no
 			enum mtk_ddp_comp_type comp_type);
 unsigned int mtk_drm_find_possible_crtc_by_comp(struct drm_device *drm,
 						struct device *dev);
-int mtk_ddp_comp_init(struct device_node *comp_node, struct mtk_ddp_comp *comp,
+int mtk_ddp_comp_init(struct device *dev, struct device_node *comp_node, struct mtk_ddp_comp *comp,
 		      unsigned int comp_id);
 enum mtk_ddp_comp_type mtk_ddp_comp_get_type(unsigned int comp_id);
 void mtk_ddp_write(struct cmdq_pkt *cmdq_pkt, unsigned int value,
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -841,7 +841,7 @@ static int mtk_drm_probe(struct platform
 							    (void *)private->mmsys_dev,
 							    sizeof(*private->mmsys_dev));
 		private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR].dev = &ovl_adaptor->dev;
-		mtk_ddp_comp_init(NULL, &private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR],
+		mtk_ddp_comp_init(dev, NULL, &private->ddp_comp[DDP_COMPONENT_DRM_OVL_ADAPTOR],
 				  DDP_COMPONENT_DRM_OVL_ADAPTOR);
 		component_match_add(dev, &match, compare_dev, &ovl_adaptor->dev);
 	}
@@ -910,7 +910,7 @@ static int mtk_drm_probe(struct platform
 						   node);
 		}
 
-		ret = mtk_ddp_comp_init(node, &private->ddp_comp[comp_id], comp_id);
+		ret = mtk_ddp_comp_init(dev, node, &private->ddp_comp[comp_id], comp_id);
 		if (ret) {
 			of_node_put(node);
 			goto err_node;


