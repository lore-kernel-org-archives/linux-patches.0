Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39642566FB;
	Thu, 17 Apr 2025 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912543; cv=none; b=Daqt0m27jkNMvv1TRY1mxTuFN2RwippPrmX5085g1+aAqn5FTMGQaSfzrvKqaw/xdvoKQ/UT0529gu9lP+mWN7S2Bj0JK/9/E0dosR/Lhz79b3OwKDXH5v/bZh47Er5BmlCnluiT9CVSUxW8zO6xf2ocPh2OsTUrblOMYDRL2i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912543; c=relaxed/simple;
	bh=8zPqB3OgmQHm90K2ryc8Bxw6ZA9t+rfWkMQbAlnbsfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkHnk1mcOPV22ZFAiL9p9hDCip5M4SpYhf6F8FDnF+pr5HkjFA4b/WKjgjOq6hYb4i90Q9cwYh16bripu0m3TebMibVtMYyuZbZEFvTsZMtlR+i0Y+tWhPejOW4RBz3VHCqguKMRcvLngS9AKE/ndbKNhBy9d18h5VahLs/qsL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvdeXdA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvdeXdA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A82C4CEE4;
	Thu, 17 Apr 2025 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912542;
	bh=8zPqB3OgmQHm90K2ryc8Bxw6ZA9t+rfWkMQbAlnbsfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvdeXdA+Q0qAu1WFQIx1K2iaZFGkxHPio3nf15eG8fjpTX31IhHD2PuS1A+fAQJyI
	 uMDaOI9XV9n1ESxv4s/dVVz81aYZyRi2hlhu19VF1aWdRKGbG4LbB9+CvuZlLoDtPb
	 SKdR58s/rzCtRm755IwugQqatgl3WE/iKuJX7EC0=
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
Subject: [PATCH 6.14 045/449] iommu/mediatek: Fix NULL pointer deference in mtk_iommu_device_group
Date: Thu, 17 Apr 2025 19:45:33 +0200
Message-ID: <20250417175119.799337325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 034b0e670384a..df98d0c65f546 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1372,15 +1372,6 @@ static int mtk_iommu_probe(struct platform_device *pdev)
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
@@ -1390,19 +1381,28 @@ static int mtk_iommu_probe(struct platform_device *pdev)
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



