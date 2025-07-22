Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620122EA73F;
	Tue, 22 Jul 2025 14:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193078; cv=none; b=dPQZn5LOKG2zjxtm6MDvBdS0CENzEiCPBdejHOru2ALjlWCJNy24JS7Zn6t9RYrJAj5RK16BisGoktK9hD6HSUxw94GNlcstFlZnkZA49hHNa/CUGZeXiB2nZsmtPb9kkhGBYgSl6Qcv1jvhkrZMTHVmTLSFPji7EbH88As0g/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193078; c=relaxed/simple;
	bh=HiUanZnC0+KWnPlK5vRmJIi9ev57PfWLwyQJBHCQ+Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnR9hSphd0L8Pi4SQ6lliK+Nl+CPDDT5FRJRVPpLb1E9ceBM5ACB5HDrrJY3FL5Li5JwBfOYVNnMJF9sL4WkzC6I3GO7+vofabICrkQCGcuxFLdZNaHB9MqDXXZfNdN1pJxtOaXWa8QKfnUsy6T7OPpS0pabSK+cfdKSbRuMsV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJ//WGb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJ//WGb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33CBC4CEF6;
	Tue, 22 Jul 2025 14:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193078;
	bh=HiUanZnC0+KWnPlK5vRmJIi9ev57PfWLwyQJBHCQ+Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJ//WGb9a8UpDzmQfChXTrQdLQIJlQfovV1eI5kLn9fOgM5RB13LkCaCchuiJQj1e
	 Vd2dYvfKrBD/wiEOsUkxZNqojHOkYcuu694OfzYa0vFhznA/r1VXFvTJvLwMcTa3en
	 KQC2Pwrljdop6kPum+jAqLll37mKh+sgTAXzE01Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/158] drm/mediatek: Add wait_event_timeout when disabling plane
Date: Tue, 22 Jul 2025 15:45:20 +0200
Message-ID: <20250722134345.800323774@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Jason-JH Lin <jason-jh.lin@mediatek.com>

[ Upstream commit d208261e9f7c66960587b10473081dc1cecbe50b ]

Our hardware registers are set through GCE, not by the CPU.
DRM might assume the hardware is disabled immediately after calling
atomic_disable() of drm_plane, but it is only truly disabled after the
GCE IRQ is triggered.

Additionally, the cursor plane in DRM uses async_commit, so DRM will
not wait for vblank and will free the buffer immediately after calling
atomic_disable().

To prevent the framebuffer from being freed before the layer disable
settings are configured into the hardware, which can cause an IOMMU
fault error, a wait_event_timeout has been added to wait for the
ddp_cmdq_cb() callback,indicating that the GCE IRQ has been triggered.

Fixes: 2f965be7f900 ("drm/mediatek: apply CMDQ control flow")
Signed-off-by: Jason-JH Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20250624113223.443274-1-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_crtc.c  | 33 ++++++++++++++++++++++++++++
 drivers/gpu/drm/mediatek/mtk_crtc.h  |  1 +
 drivers/gpu/drm/mediatek/mtk_plane.c |  5 +++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_crtc.c b/drivers/gpu/drm/mediatek/mtk_crtc.c
index 8f6fba4217ece..6916c8925b412 100644
--- a/drivers/gpu/drm/mediatek/mtk_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_crtc.c
@@ -719,6 +719,39 @@ int mtk_crtc_plane_check(struct drm_crtc *crtc, struct drm_plane *plane,
 	return 0;
 }
 
+void mtk_crtc_plane_disable(struct drm_crtc *crtc, struct drm_plane *plane)
+{
+#if IS_REACHABLE(CONFIG_MTK_CMDQ)
+	struct mtk_crtc *mtk_crtc = to_mtk_crtc(crtc);
+	struct mtk_plane_state *plane_state = to_mtk_plane_state(plane->state);
+	int i;
+
+	/* no need to wait for disabling the plane by CPU */
+	if (!mtk_crtc->cmdq_client.chan)
+		return;
+
+	if (!mtk_crtc->enabled)
+		return;
+
+	/* set pending plane state to disabled */
+	for (i = 0; i < mtk_crtc->layer_nr; i++) {
+		struct drm_plane *mtk_plane = &mtk_crtc->planes[i];
+		struct mtk_plane_state *mtk_plane_state = to_mtk_plane_state(mtk_plane->state);
+
+		if (mtk_plane->index == plane->index) {
+			memcpy(mtk_plane_state, plane_state, sizeof(*plane_state));
+			break;
+		}
+	}
+	mtk_crtc_update_config(mtk_crtc, false);
+
+	/* wait for planes to be disabled by CMDQ */
+	wait_event_timeout(mtk_crtc->cb_blocking_queue,
+			   mtk_crtc->cmdq_vblank_cnt == 0,
+			   msecs_to_jiffies(500));
+#endif
+}
+
 void mtk_crtc_async_update(struct drm_crtc *crtc, struct drm_plane *plane,
 			   struct drm_atomic_state *state)
 {
diff --git a/drivers/gpu/drm/mediatek/mtk_crtc.h b/drivers/gpu/drm/mediatek/mtk_crtc.h
index 388e900b6f4de..828f109b83e78 100644
--- a/drivers/gpu/drm/mediatek/mtk_crtc.h
+++ b/drivers/gpu/drm/mediatek/mtk_crtc.h
@@ -21,6 +21,7 @@ int mtk_crtc_create(struct drm_device *drm_dev, const unsigned int *path,
 		    unsigned int num_conn_routes);
 int mtk_crtc_plane_check(struct drm_crtc *crtc, struct drm_plane *plane,
 			 struct mtk_plane_state *state);
+void mtk_crtc_plane_disable(struct drm_crtc *crtc, struct drm_plane *plane);
 void mtk_crtc_async_update(struct drm_crtc *crtc, struct drm_plane *plane,
 			   struct drm_atomic_state *plane_state);
 struct device *mtk_crtc_dma_dev_get(struct drm_crtc *crtc);
diff --git a/drivers/gpu/drm/mediatek/mtk_plane.c b/drivers/gpu/drm/mediatek/mtk_plane.c
index 8a48b3b0a9567..1a855a75367a1 100644
--- a/drivers/gpu/drm/mediatek/mtk_plane.c
+++ b/drivers/gpu/drm/mediatek/mtk_plane.c
@@ -285,9 +285,14 @@ static void mtk_plane_atomic_disable(struct drm_plane *plane,
 	struct drm_plane_state *new_state = drm_atomic_get_new_plane_state(state,
 									   plane);
 	struct mtk_plane_state *mtk_plane_state = to_mtk_plane_state(new_state);
+	struct drm_plane_state *old_state = drm_atomic_get_old_plane_state(state,
+									   plane);
+
 	mtk_plane_state->pending.enable = false;
 	wmb(); /* Make sure the above parameter is set before update */
 	mtk_plane_state->pending.dirty = true;
+
+	mtk_crtc_plane_disable(old_state->crtc, plane);
 }
 
 static void mtk_plane_atomic_update(struct drm_plane *plane,
-- 
2.39.5



