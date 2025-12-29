Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA659332EA9;
	Mon, 29 Dec 2025 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026041; cv=none; b=cFNA2ws7FgN5QqNeSxkJJls2iuwj5b3ewT9abXjanYE7dTYwFfIR1O0SKn2f16rsi8XNCGBrzA9fBsGrApiP/ZkD4kv7Ywe5G4j+lrnE1lCxSuXobbKDJdS22koUWnJAChvGZJPlaKYYrCYQRTyhlVkBAw28GB795euegksfgs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026041; c=relaxed/simple;
	bh=UD5iVddaGYOasXIRyDtWhSqP0prQmx2uYagWfc3a70o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDeQmDG/VnDalQ8qi9/vYTrpqcI1j4y6GmAtIlMOsWy7pHxL1PpxL6qXNKEwEUMm8BZU0BE3x5PLjeq/2yJ1zODgt8uxjAWtwmC9bb/9HRHT4a71M7cV9vLeVkybI1yUlcqOw7cwZN8QhdSn8MwGkjduBttJTmnUtlBWMpj++70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHgvtJHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHgvtJHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4B6C4CEF7;
	Mon, 29 Dec 2025 16:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026041;
	bh=UD5iVddaGYOasXIRyDtWhSqP0prQmx2uYagWfc3a70o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHgvtJHsCCW8P5D6xRQi1B9P7XN1ApS1Lt2r75Y153j41mRYBZ7L+UmJxlF7hURW9
	 gL5nEw4uOqbCtq4jRjZOAEASzdLd/BXUKxLLJkHEbXeb/4Nvzu7+0KpWOxEg4wQUDP
	 BxfodvQkbNDWgUPo5SmbU0YrX2Yrv1kSTpwpvY+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 427/430] iommu/mediatek: fix use-after-free on probe deferral
Date: Mon, 29 Dec 2025 17:13:49 +0100
Message-ID: <20251229160740.026182001@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit de83d4617f9fe059623e97acf7e1e10d209625b5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/mtk_iommu.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1211,16 +1211,19 @@ static int mtk_iommu_mm_dts_parse(struct
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
@@ -1228,7 +1231,8 @@ static int mtk_iommu_mm_dts_parse(struct
 	platform_device_put(pcommdev);
 	if (!link) {
 		dev_err(dev, "Unable to link %s.\n", dev_name(data->smicomm_dev));
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_larbdev_put;
 	}
 	return 0;
 
@@ -1400,8 +1404,12 @@ out_sysfs_remove:
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
@@ -1421,6 +1429,9 @@ static void mtk_iommu_remove(struct plat
 	if (MTK_IOMMU_IS_TYPE(data->plat_data, MTK_IOMMU_TYPE_MM)) {
 		device_link_remove(data->smicomm_dev, &pdev->dev);
 		component_master_del(&pdev->dev, &mtk_iommu_com_ops);
+
+		for (i = 0; i < MTK_LARB_NR_MAX; i++)
+			put_device(data->larb_imu[i].dev);
 	}
 	pm_runtime_disable(&pdev->dev);
 	for (i = 0; i < data->plat_data->banks_num; i++) {


