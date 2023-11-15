Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317933C470
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IV2TEcc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE79C433CA;
	Wed, 15 Nov 2023 19:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077358;
	bh=1G9UBmfDutNtqVeh+zn4SMhLY3pQrp2uEBVXJTQhHcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IV2TEcc7aKJGGnrYitszvc0LgBeGK7e5kzbXnlkC8i5v3uN0VZB2rSNc2Tj2bBeMl
	 dTr/nlReFl130we7T0J9IuzIUu5+DNFEVGSEss06a1sunEM1lpiNPanP2bxHmr+tI9
	 VF00Iwnjq1TagkdyVqi6kYdLI7RPTJK/q3F3rilM=
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
Subject: [PATCH 6.6 253/603] drm/mediatek: Fix iommu fault during crtc enabling
Date: Wed, 15 Nov 2023 14:13:18 -0500
Message-ID: <20231115191630.779751293@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b6fa4ad2f94dc..0a511d7688a3a 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -408,6 +408,9 @@ static int mtk_crtc_ddp_hw_init(struct mtk_drm_crtc *mtk_crtc)
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



