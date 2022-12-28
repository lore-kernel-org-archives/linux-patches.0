Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5781C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88797C433F0;
	Wed, 28 Dec 2022 16:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244993;
	bh=0U853qzJ/DPe+ViHdeRKey9xUYRZw2Gn0TeYA3x0vI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+vQF9WfLUE8+5qH/MGRL9c/vqdREc0s5n1Ie3UoKbuUCEwLqv6cVdjpqDx6mbMiT
	 VZfkddFI9yzIuvCjqKWVLWilo/ImZPW9EJcqAAw+yQTaQ1IyUzrefHp85IabDI7BFl
	 r9i1h9hewld3wZDHanJJie4J7CyOlCD5RVRGKY/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Yong Wu <yong.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0812/1073] iommu/mediatek: Use component_match_add
Date: Wed, 28 Dec 2022 15:40:00 +0100
Message-Id: <20221228144350.063012800@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit b5765a1b44bea9dfcae69c53ffeb4c689d0922a7 ]

In order to simplify the error patch(avoid call of_node_put), Use
component_match_add instead component_match_add_release since we are only
interested in the "device" here. Then we could always call of_node_put in
normal path.

Strictly this is not a fixes patch, but it is a prepare for adding the
error path, thus I add a Fixes tag too.

Fixes: d2e9a1102cfc ("iommu/mediatek: Contain MM IOMMU flow with the MM TYPE")
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20221018024258.19073-3-yong.wu@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 93005e63fc7f..ce9288695f9b 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1066,19 +1066,17 @@ static int mtk_iommu_mm_dts_parse(struct device *dev, struct component_match **m
 			id = i;
 
 		plarbdev = of_find_device_by_node(larbnode);
-		if (!plarbdev) {
-			of_node_put(larbnode);
+		of_node_put(larbnode);
+		if (!plarbdev)
 			return -ENODEV;
-		}
+
 		if (!plarbdev->dev.driver) {
-			of_node_put(larbnode);
 			platform_device_put(plarbdev);
 			return -EPROBE_DEFER;
 		}
 		data->larb_imu[id].dev = &plarbdev->dev;
 
-		component_match_add_release(dev, match, component_release_of,
-					    component_compare_of, larbnode);
+		component_match_add(dev, match, component_compare_dev, &plarbdev->dev);
 		platform_device_put(plarbdev);
 	}
 
-- 
2.35.1



