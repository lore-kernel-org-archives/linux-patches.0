Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FF935BDD6;
	Fri,  9 Jan 2026 12:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963102; cv=none; b=msLiZN+4c76SM/dVZnaLvTBwkzdePTKRvrAkyDwFRL+uPDiDeO7ix8TPEJwpFeDYm3bSbD+TJFue2mPbSqTNViHJu3pWYL1QwvSJyNe6xsc+Qkqvexk8f37LmfDCtikC+xj0DKrTX+PZrcF7nMPUQ1/hTVjTHPXM7CUx1Uz9cJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963102; c=relaxed/simple;
	bh=wTvlXC+NQy2gU+gdEmLK9Y0L/GUpzGKnPBuqPSRt0Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyoCTCxo0B3X0SAYvdJyk0IDIs1ni3WDE3JRvK9TzAyXr6yxTLzkrqg3O2/HljQa5LWWsrt3jUxa1ac8QFNzXznhumF7sb4CPYt9bXkHXDRXGx4Dk5/SOIGmvxE0fCaMzcTwxVfRHnZniQxbs/bwUSgHB3M8G5YR0JQh+BdQJyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmcwL900; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmcwL900"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95E8C4CEF1;
	Fri,  9 Jan 2026 12:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963102;
	bh=wTvlXC+NQy2gU+gdEmLK9Y0L/GUpzGKnPBuqPSRt0Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmcwL900mw2nK+ovfqWCSgdyKem3pjt6mwvVB1+0hnKWlXP1uEfgaM29tAwpxaN1W
	 l/TdeDX3JmpUerISyjXs5qOwSEAcu/7cUXHA4FtMAEhv2TJGdYKmZ9gFg87PL6ISYC
	 UUGkpp4Nlu45qAExO/Pfqf34qAKPFvuzJAlVVk3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 566/634] iommu/mediatek: fix use-after-free on probe deferral
Date: Fri,  9 Jan 2026 12:44:04 +0100
Message-ID: <20260109112138.902496055@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit de83d4617f9fe059623e97acf7e1e10d209625b5 ]

The driver is dropping the references taken to the larb devices during
probe after successful lookup as well as on errors. This can
potentially lead to a use-after-free in case a larb device has not yet
been bound to its driver so that the iommu driver probe defers.

Fix this by keeping the references as expected while the iommu driver is
bound.

Fixes: 26593928564c ("iommu/mediatek: Add error path for loop of mm_dts_parse")
Cc: stable@vger.kernel.org
Cc: Yong Wu <yong.wu@mediatek.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/mtk_iommu.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1134,16 +1134,19 @@ static int mtk_iommu_mm_dts_parse(struct
 		}
 
 		component_match_add(dev, match, component_compare_dev, &plarbdev->dev);
-		platform_device_put(plarbdev);
 	}
 
-	if (!frst_avail_smicomm_node)
-		return -EINVAL;
+	if (!frst_avail_smicomm_node) {
+		ret = -EINVAL;
+		goto err_larbdev_put;
+	}
 
 	pcommdev = of_find_device_by_node(frst_avail_smicomm_node);
 	of_node_put(frst_avail_smicomm_node);
-	if (!pcommdev)
-		return -ENODEV;
+	if (!pcommdev) {
+		ret = -ENODEV;
+		goto err_larbdev_put;
+	}
 	data->smicomm_dev = &pcommdev->dev;
 
 	link = device_link_add(data->smicomm_dev, dev,
@@ -1151,7 +1154,8 @@ static int mtk_iommu_mm_dts_parse(struct
 	platform_device_put(pcommdev);
 	if (!link) {
 		dev_err(dev, "Unable to link %s.\n", dev_name(data->smicomm_dev));
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_larbdev_put;
 	}
 	return 0;
 
@@ -1322,8 +1326,12 @@ out_sysfs_remove:
 	iommu_device_sysfs_remove(&data->iommu);
 out_list_del:
 	list_del(&data->list);
-	if (MTK_IOMMU_IS_TYPE(data->plat_data, MTK_IOMMU_TYPE_MM))
+	if (MTK_IOMMU_IS_TYPE(data->plat_data, MTK_IOMMU_TYPE_MM)) {
 		device_link_remove(data->smicomm_dev, dev);
+
+		for (i = 0; i < MTK_LARB_NR_MAX; i++)
+			put_device(data->larb_imu[i].dev);
+	}
 out_runtime_disable:
 	pm_runtime_disable(dev);
 	return ret;
@@ -1343,6 +1351,9 @@ static int mtk_iommu_remove(struct platf
 	if (MTK_IOMMU_IS_TYPE(data->plat_data, MTK_IOMMU_TYPE_MM)) {
 		device_link_remove(data->smicomm_dev, &pdev->dev);
 		component_master_del(&pdev->dev, &mtk_iommu_com_ops);
+
+		for (i = 0; i < MTK_LARB_NR_MAX; i++)
+			put_device(data->larb_imu[i].dev);
 	}
 	pm_runtime_disable(&pdev->dev);
 	for (i = 0; i < data->plat_data->banks_num; i++) {


