Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B32211706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2407C433C7;
	Mon, 11 Sep 2023 14:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443487;
	bh=sgssh4JQHgQmfjD3RWzQs1bv1Tr5pL2rZnvx9JRwif8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4/LOPzFv/Klq1Nm7LdHewB0HY4n1+Xvh1SPQO/Gye0RO7iN1wkVKWqS0rJX1kFdt
	 PJMY3LYOxARoVCRTK9LNc4W9I81pRr1JVn73J2kEirXxYaeGW4sa+LwlIKnNaW5wGQ
	 Jgrt6niPmKmmVW0alIDzElEZSoYrfPH56gxqySE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nancy.Lin" <nancy.lin@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 367/737] drm/mediatek: Fix uninitialized symbol
Date: Mon, 11 Sep 2023 15:43:46 +0200
Message-ID: <20230911134700.794393212@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nancy.Lin <nancy.lin@mediatek.com>

[ Upstream commit 63ee9438f2aeffb2d1b2df2599c168ca08d35025 ]

Fix Smatch static checker warning
  -Fix uninitialized symbol comp_pdev in mtk_ddp_comp_init.

Fixes: 0d9eee9118b7 ("drm/mediatek: Add drm ovl_adaptor sub driver for MT8195")
Signed-off-by: Nancy.Lin <nancy.lin@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20230803094843.4439-1-nancy.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
index f114da4d36a96..771f4e1733539 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -563,14 +563,15 @@ int mtk_ddp_comp_init(struct device_node *node, struct mtk_ddp_comp *comp,
 	/* Not all drm components have a DTS device node, such as ovl_adaptor,
 	 * which is the drm bring up sub driver
 	 */
-	if (node) {
-		comp_pdev = of_find_device_by_node(node);
-		if (!comp_pdev) {
-			DRM_INFO("Waiting for device %s\n", node->full_name);
-			return -EPROBE_DEFER;
-		}
-		comp->dev = &comp_pdev->dev;
+	if (!node)
+		return 0;
+
+	comp_pdev = of_find_device_by_node(node);
+	if (!comp_pdev) {
+		DRM_INFO("Waiting for device %s\n", node->full_name);
+		return -EPROBE_DEFER;
 	}
+	comp->dev = &comp_pdev->dev;
 
 	if (type == MTK_DISP_AAL ||
 	    type == MTK_DISP_BLS ||
@@ -580,7 +581,6 @@ int mtk_ddp_comp_init(struct device_node *node, struct mtk_ddp_comp *comp,
 	    type == MTK_DISP_MERGE ||
 	    type == MTK_DISP_OVL ||
 	    type == MTK_DISP_OVL_2L ||
-	    type == MTK_DISP_OVL_ADAPTOR ||
 	    type == MTK_DISP_PWM ||
 	    type == MTK_DISP_RDMA ||
 	    type == MTK_DPI ||
-- 
2.40.1



