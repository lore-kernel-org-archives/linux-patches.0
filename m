Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508DA1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE0EC433D2;
	Wed, 28 Dec 2022 16:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245436;
	bh=li3uXa7z1/Pb+JciIitirypteWWSVkGCeqkibJqk17k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lccvWQczb1r2Z40wGtL+6Zt0KKCZVfYbObqaMV7Ed50Dt3P2pJyCKdVNyVRe9/s+H
	 12Jc6eT4r+xvBHh7oCl8YilOVcqbz2GHOrt1eg3kyl+xQ2ZID5+xUfM1LXgZPx82rC
	 eE1fEmVEQtytWIAwKxLPWTNQnuJ/c2f3wXIh2rGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0861/1146] iommu/mediatek: Add platform_device_put for recovering the device refcnt
Date: Wed, 28 Dec 2022 15:40:00 +0100
Message-Id: <20221228144353.542264322@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit dcb40e9fcce9bd251eaff19f3724131db522846c ]

Add platform_device_put to match with of_find_device_by_node.

Meanwhile, I add a new variable "pcommdev" which is for smi common device.
Otherwise, "platform_device_put(plarbdev)" for smi-common dev may be not
readable. And add a checking for whether pcommdev is NULL.

Fixes: d2e9a1102cfc ("iommu/mediatek: Contain MM IOMMU flow with the MM TYPE")
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20221018024258.19073-2-yong.wu@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 2d14dc846b83..febcca8fcbcf 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1044,7 +1044,7 @@ static int mtk_iommu_mm_dts_parse(struct device *dev, struct component_match **m
 				  struct mtk_iommu_data *data)
 {
 	struct device_node *larbnode, *smicomm_node, *smi_subcomm_node;
-	struct platform_device *plarbdev;
+	struct platform_device *plarbdev, *pcommdev;
 	struct device_link *link;
 	int i, larb_nr, ret;
 
@@ -1075,12 +1075,14 @@ static int mtk_iommu_mm_dts_parse(struct device *dev, struct component_match **m
 		}
 		if (!plarbdev->dev.driver) {
 			of_node_put(larbnode);
+			platform_device_put(plarbdev);
 			return -EPROBE_DEFER;
 		}
 		data->larb_imu[id].dev = &plarbdev->dev;
 
 		component_match_add_release(dev, match, component_release_of,
 					    component_compare_of, larbnode);
+		platform_device_put(plarbdev);
 	}
 
 	/* Get smi-(sub)-common dev from the last larb. */
@@ -1098,12 +1100,15 @@ static int mtk_iommu_mm_dts_parse(struct device *dev, struct component_match **m
 	else
 		smicomm_node = smi_subcomm_node;
 
-	plarbdev = of_find_device_by_node(smicomm_node);
+	pcommdev = of_find_device_by_node(smicomm_node);
 	of_node_put(smicomm_node);
-	data->smicomm_dev = &plarbdev->dev;
+	if (!pcommdev)
+		return -ENODEV;
+	data->smicomm_dev = &pcommdev->dev;
 
 	link = device_link_add(data->smicomm_dev, dev,
 			       DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME);
+	platform_device_put(pcommdev);
 	if (!link) {
 		dev_err(dev, "Unable to link %s.\n", dev_name(data->smicomm_dev));
 		return -EINVAL;
-- 
2.35.1



