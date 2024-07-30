Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DA618801A;
	Tue, 30 Jul 2024 16:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358437; cv=none; b=KIPXWQU8JlPohfx9l7ZLDL7qNgpMljzWzRvdiRf8ZYNm+JomFofoRN+EL4x8ltPE6YeLbs23U3mGWVrmuhXErlsSTb4CUMmMuWcRu/u2q6N+XFg5okEDfxPYEYcm+ybhpfyqCpUxdhR7E/Q6hBhqBa//B5zd41lCKSFYrJIojW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358437; c=relaxed/simple;
	bh=U1t07AGAvMJW/BmWh+GdDKxUwer3oNOu6u930PbBFiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJOoEFJwFC5T9uIdDENKTBPvY8VLGnYe2unnlKHx48+8gwact6kOtmor5aXImlyl12cs652g9D7/P0YL6DhvTXtqFkCKnlWOzoQK8M7Rffhw85tXFdm3sJZtUD64cqGZioQQSIR8usjt2r0cl5O0H7Xg7zZHLnKQ9MePNm7eHI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBVWyVjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBVWyVjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB516C32782;
	Tue, 30 Jul 2024 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358437;
	bh=U1t07AGAvMJW/BmWh+GdDKxUwer3oNOu6u930PbBFiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBVWyVjcmxU+plsp6fHlkx9WMkHbJQc/7ezk8VW+hqkgIQFw6YzZO0hgY+GPg1VaT
	 LSMd6vsXoN9WnqQ8L+gM3Kf+/BbcVqWZoV2dBiRGGcQ0KZhegCyWecIMvDXbmJnWLC
	 Lte/hnuk0j5c84+DwBJ4EF5UTzI3/DohpCt46d2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Michael Walle <mwalle@kernel.org>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 359/809] drm/mediatek: dpi/dsi: Fix possible_crtcs calculation
Date: Tue, 30 Jul 2024 17:43:55 +0200
Message-ID: <20240730151738.825282250@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 9ff6df49e6cbcc9834865870d7c4f3059b0891d3 ]

mtk_find_possible_crtcs() assumes that the main path will always have
the CRTC with id 0, the ext id 1 and the third id 2. This is only true
if the paths are all available. But paths are optional (see also
comment in mtk_drm_kms_init()), e.g. the main path might not be enabled
or available at all. Then the CRTC IDs will shift one up, e.g. ext will
be 0 and the third path will be 1.

To fix that, dynamically calculate the IDs by the presence of the paths.

While at it, make the return code a signed one and return -ENODEV if no
path is found and handle the error in the callers.

Fixes: 5aa8e7647676 ("drm/mediatek: dpi/dsi: Change the getting possible_crtc way")
Suggested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240606092122.2026313-1-mwalle@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_ddp_comp.c | 107 ++++++++++++++++--------
 drivers/gpu/drm/mediatek/mtk_ddp_comp.h |   2 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c      |   5 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c      |   5 +-
 4 files changed, 80 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
index a66e46d0b45eb..be66d94be3613 100644
--- a/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
@@ -514,29 +514,42 @@ static bool mtk_ddp_comp_find(struct device *dev,
 	return false;
 }
 
-static unsigned int mtk_ddp_comp_find_in_route(struct device *dev,
-					       const struct mtk_drm_route *routes,
-					       unsigned int num_routes,
-					       struct mtk_ddp_comp *ddp_comp)
+static int mtk_ddp_comp_find_in_route(struct device *dev,
+				      const struct mtk_drm_route *routes,
+				      unsigned int num_routes,
+				      struct mtk_ddp_comp *ddp_comp)
 {
-	int ret;
 	unsigned int i;
 
-	if (!routes) {
-		ret = -EINVAL;
-		goto err;
-	}
+	if (!routes)
+		return -EINVAL;
 
 	for (i = 0; i < num_routes; i++)
 		if (dev == ddp_comp[routes[i].route_ddp].dev)
 			return BIT(routes[i].crtc_id);
 
-	ret = -ENODEV;
-err:
+	return -ENODEV;
+}
 
-	DRM_INFO("Failed to find comp in ddp table, ret = %d\n", ret);
+static bool mtk_ddp_path_available(const unsigned int *path,
+				   unsigned int path_len,
+				   struct device_node **comp_node)
+{
+	unsigned int i;
 
-	return 0;
+	if (!path || !path_len)
+		return false;
+
+	for (i = 0U; i < path_len; i++) {
+		/* OVL_ADAPTOR doesn't have a device node */
+		if (path[i] == DDP_COMPONENT_DRM_OVL_ADAPTOR)
+			continue;
+
+		if (!comp_node[path[i]])
+			return false;
+	}
+
+	return true;
 }
 
 int mtk_ddp_comp_get_id(struct device_node *node,
@@ -554,31 +567,53 @@ int mtk_ddp_comp_get_id(struct device_node *node,
 	return -EINVAL;
 }
 
-unsigned int mtk_find_possible_crtcs(struct drm_device *drm, struct device *dev)
+int mtk_find_possible_crtcs(struct drm_device *drm, struct device *dev)
 {
 	struct mtk_drm_private *private = drm->dev_private;
-	unsigned int ret = 0;
-
-	if (mtk_ddp_comp_find(dev,
-			      private->data->main_path,
-			      private->data->main_len,
-			      private->ddp_comp))
-		ret = BIT(0);
-	else if (mtk_ddp_comp_find(dev,
-				   private->data->ext_path,
-				   private->data->ext_len,
-				   private->ddp_comp))
-		ret = BIT(1);
-	else if (mtk_ddp_comp_find(dev,
-				   private->data->third_path,
-				   private->data->third_len,
-				   private->ddp_comp))
-		ret = BIT(2);
-	else
-		ret = mtk_ddp_comp_find_in_route(dev,
-						 private->data->conn_routes,
-						 private->data->num_conn_routes,
-						 private->ddp_comp);
+	const struct mtk_mmsys_driver_data *data;
+	struct mtk_drm_private *priv_n;
+	int i = 0, j;
+	int ret;
+
+	for (j = 0; j < private->data->mmsys_dev_num; j++) {
+		priv_n = private->all_drm_private[j];
+		data = priv_n->data;
+
+		if (mtk_ddp_path_available(data->main_path, data->main_len,
+					   priv_n->comp_node)) {
+			if (mtk_ddp_comp_find(dev, data->main_path,
+					      data->main_len,
+					      priv_n->ddp_comp))
+				return BIT(i);
+			i++;
+		}
+
+		if (mtk_ddp_path_available(data->ext_path, data->ext_len,
+					   priv_n->comp_node)) {
+			if (mtk_ddp_comp_find(dev, data->ext_path,
+					      data->ext_len,
+					      priv_n->ddp_comp))
+				return BIT(i);
+			i++;
+		}
+
+		if (mtk_ddp_path_available(data->third_path, data->third_len,
+					   priv_n->comp_node)) {
+			if (mtk_ddp_comp_find(dev, data->third_path,
+					      data->third_len,
+					      priv_n->ddp_comp))
+				return BIT(i);
+			i++;
+		}
+	}
+
+	ret = mtk_ddp_comp_find_in_route(dev,
+					 private->data->conn_routes,
+					 private->data->num_conn_routes,
+					 private->ddp_comp);
+
+	if (ret < 0)
+		DRM_INFO("Failed to find comp in ddp table, ret = %d\n", ret);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/mediatek/mtk_ddp_comp.h b/drivers/gpu/drm/mediatek/mtk_ddp_comp.h
index f7fe2e08dc8e2..ecf6dc283cd7c 100644
--- a/drivers/gpu/drm/mediatek/mtk_ddp_comp.h
+++ b/drivers/gpu/drm/mediatek/mtk_ddp_comp.h
@@ -330,7 +330,7 @@ static inline void mtk_ddp_comp_encoder_index_set(struct mtk_ddp_comp *comp)
 
 int mtk_ddp_comp_get_id(struct device_node *node,
 			enum mtk_ddp_comp_type comp_type);
-unsigned int mtk_find_possible_crtcs(struct drm_device *drm, struct device *dev);
+int mtk_find_possible_crtcs(struct drm_device *drm, struct device *dev);
 int mtk_ddp_comp_init(struct device_node *comp_node, struct mtk_ddp_comp *comp,
 		      unsigned int comp_id);
 enum mtk_ddp_comp_type mtk_ddp_comp_get_type(unsigned int comp_id);
diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index bfe8653005dbf..a08d206549543 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -805,7 +805,10 @@ static int mtk_dpi_bind(struct device *dev, struct device *master, void *data)
 		return ret;
 	}
 
-	dpi->encoder.possible_crtcs = mtk_find_possible_crtcs(drm_dev, dpi->dev);
+	ret = mtk_find_possible_crtcs(drm_dev, dpi->dev);
+	if (ret < 0)
+		goto err_cleanup;
+	dpi->encoder.possible_crtcs = ret;
 
 	ret = drm_bridge_attach(&dpi->encoder, &dpi->bridge, NULL,
 				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index c255559cc56ed..b6e3c011a12d8 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -837,7 +837,10 @@ static int mtk_dsi_encoder_init(struct drm_device *drm, struct mtk_dsi *dsi)
 		return ret;
 	}
 
-	dsi->encoder.possible_crtcs = mtk_find_possible_crtcs(drm, dsi->host.dev);
+	ret = mtk_find_possible_crtcs(drm, dsi->host.dev);
+	if (ret < 0)
+		goto err_cleanup_encoder;
+	dsi->encoder.possible_crtcs = ret;
 
 	ret = drm_bridge_attach(&dsi->encoder, &dsi->bridge, NULL,
 				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
-- 
2.43.0



