Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BFF18657
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJeYaIwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6DDC4E778;
	Wed, 15 Nov 2023 20:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081763;
	bh=R/AoS85NAGfsZA52M+0ikJo4qNwYKk3wD8VxiYJI7To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJeYaIwSQYFlPt7f/1s2UduUt3EgcloRStKbkt5FD7y2i0lej8Gi9KGP0+6y3OS5r
	 iafczKOW0wNwn2Gctyw6cM36s25cgvycmaSwC91zEqAYQj1xdrx5apNhB20KoRgwOz
	 F4l3da3ezS4E2Uv/kv6ugZcWu7km2Y1bF+vmcYgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/191] drm/mediatek: Fix iommu fault during crtc enabling
Date: Wed, 15 Nov 2023 15:45:50 -0500
Message-ID: <20231115204649.097162373@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 53412dc2905401207f264dc30890f6b9e41524a6 ]

The difference between drm_atomic_helper_commit_tail() and
drm_atomic_helper_commit_tail_rpm() is
drm_atomic_helper_commit_tail() will commit plane first and
then enable crtc, drm_atomic_helper_commit_tail_rpm() will
enable crtc first and then commit plane.

Before mediatek-drm enables crtc, the power and clk required
by OVL have not been turned on, so the commit plane cannot be
committed before crtc is enabled. That means OVL layer should
not be enabled before crtc is enabled.
Therefore, the atomic_commit_tail of mediatek-drm is hooked with
drm_atomic_helper_commit_tail_rpm().

Another reason is that the plane_state of drm_atomic_state is not
synchronized with the plane_state stored in mtk_crtc during crtc enablng,
so just set all planes to disabled.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20230809125722.24112-3-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index e83b1c406b96a..cc3cb5b63d444 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -320,6 +320,9 @@ static int mtk_crtc_ddp_hw_init(struct mtk_drm_crtc *mtk_crtc)
 		unsigned int local_layer;
 
 		plane_state = to_mtk_plane_state(plane->state);
+
+		/* should not enable layer before crtc enabled */
+		plane_state->pending.enable = false;
 		comp = mtk_drm_ddp_comp_for_plane(crtc, plane, &local_layer);
 		if (comp)
 			mtk_ddp_comp_layer_config(comp, local_layer,
-- 
2.42.0



