Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076582571A0;
	Thu, 17 Apr 2025 18:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915170; cv=none; b=DH0Pc8cW7cK776FNIUUbkG1h03Mr2wFRUWeGYrZ/e2ZHEyHHIZZUO318mL20O4S051H63jGd+QzvVV9sU0FA2a2W8qE6ygiNYuwJxMJQlt3IP23rtk3Zti7gfcfMfgFcp9MT4TNMbPuFe8/ZTeFVB3ZSPmSq+ZWXvjHuB0lr26Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915170; c=relaxed/simple;
	bh=NvYCh16aMkbL0ughi7TajFypcQQDwD+I7ApM2nhXYes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PC58ZxoEjmIlxkoobptXZ9+/uJtY09V6Cp7v3fSOp+U3BTMv4/j8IThs0co0IacESE6pVFZSZ+5pdZqG+u4e9pCZUPSvQdRUEa0MQseBADpDADmfnTB59E7cYNuyKdXrgk0u87q6L1bmranuOivIw4tT4tfE+6wte9H/eTAiBQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJJoEzPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJJoEzPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3C4C4CEE4;
	Thu, 17 Apr 2025 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915169;
	bh=NvYCh16aMkbL0ughi7TajFypcQQDwD+I7ApM2nhXYes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJJoEzPQGLY8TzL9S5xiWogFyHEZurGxd+CYjsV9qOde6U2WCcEAZTnvzuUwYlajt
	 PdLq4vZ4llXazM59zIoEYnkVI7hFoUj2deJmh6tRqDcP/VLaWeZhZWTmWrx2UmuwWT
	 SVu5QlERfBR5UJH8oiPHqpaNnSAeWrQhnDFVp608=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Chen-Yu Tsai <wenst@chromium.org>
Subject: [PATCH 6.12 041/393] iommu/mediatek: Fix NULL pointer deference in mtk_iommu_device_group
Date: Thu, 17 Apr 2025 19:47:30 +0200
Message-ID: <20250417175109.246762028@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit 38e8844005e6068f336a3ad45451a562a0040ca1 ]

Currently, mtk_iommu calls during probe iommu_device_register before
the hw_list from driver data is initialized. Since iommu probing issue
fix, it leads to NULL pointer dereference in mtk_iommu_device_group when
hw_list is accessed with list_first_entry (not null safe).

So, change the call order to ensure iommu_device_register is called
after the driver data are initialized.

Fixes: 9e3a2a643653 ("iommu/mediatek: Adapt sharing and non-sharing pgtable case")
Fixes: bcb81ac6ae3c ("iommu: Get DT/ACPI parsing into the proper probe path")
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Tested-by: Chen-Yu Tsai <wenst@chromium.org> # MT8183 Juniper, MT8186 Tentacruel
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Link: https://lore.kernel.org/r/20250403-fix-mtk-iommu-error-v2-1-fe8b18f8b0a8@collabora.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 6a2707fe7a78c..32deab732209e 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1371,15 +1371,6 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, data);
 	mutex_init(&data->mutex);
 
-	ret = iommu_device_sysfs_add(&data->iommu, dev, NULL,
-				     "mtk-iommu.%pa", &ioaddr);
-	if (ret)
-		goto out_link_remove;
-
-	ret = iommu_device_register(&data->iommu, &mtk_iommu_ops, dev);
-	if (ret)
-		goto out_sysfs_remove;
-
 	if (MTK_IOMMU_HAS_FLAG(data->plat_data, SHARE_PGTABLE)) {
 		list_add_tail(&data->list, data->plat_data->hw_list);
 		data->hw_list = data->plat_data->hw_list;
@@ -1389,19 +1380,28 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 		data->hw_list = &data->hw_list_head;
 	}
 
+	ret = iommu_device_sysfs_add(&data->iommu, dev, NULL,
+				     "mtk-iommu.%pa", &ioaddr);
+	if (ret)
+		goto out_list_del;
+
+	ret = iommu_device_register(&data->iommu, &mtk_iommu_ops, dev);
+	if (ret)
+		goto out_sysfs_remove;
+
 	if (MTK_IOMMU_IS_TYPE(data->plat_data, MTK_IOMMU_TYPE_MM)) {
 		ret = component_master_add_with_match(dev, &mtk_iommu_com_ops, match);
 		if (ret)
-			goto out_list_del;
+			goto out_device_unregister;
 	}
 	return ret;
 
-out_list_del:
-	list_del(&data->list);
+out_device_unregister:
 	iommu_device_unregister(&data->iommu);
 out_sysfs_remove:
 	iommu_device_sysfs_remove(&data->iommu);
-out_link_remove:
+out_list_del:
+	list_del(&data->list);
 	if (MTK_IOMMU_IS_TYPE(data->plat_data, MTK_IOMMU_TYPE_MM))
 		device_link_remove(data->smicomm_dev, dev);
 out_runtime_disable:
-- 
2.39.5



