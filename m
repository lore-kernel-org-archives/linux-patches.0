Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C849328B58;
	Fri,  9 Jan 2026 12:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960808; cv=none; b=RTxEJyw/C8kcYh6zhCPHZrrdbbl9+jCccWTHmfqNJxmDlrhY6JBFr23bXbO/Mb8gFxoUE8ACdysik6yQ+Iy8XBUaiwI5sWELfZVGmJcMnMSEEiCRnTAUUXxfOYMWs5W9Wwdjsf2tInlymeBJmPzBfYhcG/12Ry4A3+shVFJzEjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960808; c=relaxed/simple;
	bh=L/UGCnH3F4JzhcJuKRcqUH/Mf8lNvZQxKEMcetj1zP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrMWhs3CmASSe3OK01oaCltvK8F68YQZjc486fE5iwOD5aZkAVXY0oqweZTmfO4WGclbS6X1ttoMVZbWbt6HCWIvqcYtM70XXsj4cibBDLqqv4Hn5Ru+QJfNmoD+70vRov6zfjW8cV84Qpfh44hpIidvP50F+NEXWco//apgWYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMYrQg4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMYrQg4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C501C4CEF1;
	Fri,  9 Jan 2026 12:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960808;
	bh=L/UGCnH3F4JzhcJuKRcqUH/Mf8lNvZQxKEMcetj1zP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMYrQg4O3PozPfvrCLOFwr8+QM9wk7utt9tfntgjGKZHpHv83LBdStUy0AVugTipl
	 B7Fa+Z9Yjlvtl7KAB7ljFWe10l9T0CN3YrsGovfJPr9+M4BP99PFeBE+f42TIfRwda
	 j5rKsCt4c6fFaYkb8NzqUFFV0l2eW3DyoYHVcyEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 500/737] iommu/mediatek: fix use-after-free on probe deferral
Date: Fri,  9 Jan 2026 12:40:39 +0100
Message-ID: <20260109112152.803035225@linuxfoundation.org>
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
@@ -1196,16 +1196,19 @@ static int mtk_iommu_mm_dts_parse(struct
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
@@ -1213,7 +1216,8 @@ static int mtk_iommu_mm_dts_parse(struct
 	platform_device_put(pcommdev);
 	if (!link) {
 		dev_err(dev, "Unable to link %s.\n", dev_name(data->smicomm_dev));
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_larbdev_put;
 	}
 	return 0;
 
@@ -1385,8 +1389,12 @@ out_sysfs_remove:
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
@@ -1406,6 +1414,9 @@ static void mtk_iommu_remove(struct plat
 	if (MTK_IOMMU_IS_TYPE(data->plat_data, MTK_IOMMU_TYPE_MM)) {
 		device_link_remove(data->smicomm_dev, &pdev->dev);
 		component_master_del(&pdev->dev, &mtk_iommu_com_ops);
+
+		for (i = 0; i < MTK_LARB_NR_MAX; i++)
+			put_device(data->larb_imu[i].dev);
 	}
 	pm_runtime_disable(&pdev->dev);
 	for (i = 0; i < data->plat_data->banks_num; i++) {


