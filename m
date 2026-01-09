Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731203346AF;
	Fri,  9 Jan 2026 12:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960871; cv=none; b=NjN1bIjBA1n+IP6q0xqFdXhRoXdzZribVLeLNRwEj/jYTC2saitxIoRkDdZ4imWmz9vanEzsQErlttiumSPFxYZBRGXdiKVU0iQlzkvsCIe2JzrQ7qZ/v5iz8YNQQHKKRuij9vpcaw9mVMrRZW9LFMR5eFyiLuAfoQ+3360QxVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960871; c=relaxed/simple;
	bh=1UyiHiOplnXCTzeAWGO/U/32qEXQvhAwr2DxajHfiqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InSSqcWcBwoWefU04PTlliRBlaIUZ38JIh1J0Dkjq3nbw++ONWDt+r2dKo9QQfM5l5ox+pxt9/ffTLq/dzC7HbOcs66/JQTuLgmNll452Xu0DQkpY5HEL5pK9Og/QRHKhejq+Yy+QxbVHzovC84pRWys2O5uOwXcJvALoH1tMYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLEVYSJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLEVYSJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9448C4CEF1;
	Fri,  9 Jan 2026 12:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960871;
	bh=1UyiHiOplnXCTzeAWGO/U/32qEXQvhAwr2DxajHfiqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLEVYSJfyykflzd0HwUSMOEfqeeRlxCBBeZhuXSm+ZHhb56Di7VCpnzRRL6u9zFOM
	 4lVi298AnuFWL4TR5bsnNeHWLLBrpQ2vbhW1ABexcGwqi8CCT/0xA/Ir8ZTts8hbbs
	 bWFpILJXrzXuy5z6O0A7HCUjAO3E8CPHaGdJn25k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honghui Zhang <honghui.zhang@mediatek.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 554/737] iommu/mediatek-v1: fix device leaks on probe()
Date: Fri,  9 Jan 2026 12:41:33 +0100
Message-ID: <20260109112154.839154610@linuxfoundation.org>
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

commit 46207625c9f33da0e43bb4ae1e91f0791b6ed633 upstream.

Make sure to drop the references taken to the larb devices during
probe on probe failure (e.g. probe deferral) and on driver unbind.

Fixes: b17336c55d89 ("iommu/mediatek: add support for mtk iommu generation one HW")
Cc: stable@vger.kernel.org	# 4.8
Cc: Honghui Zhang <honghui.zhang@mediatek.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/mtk_iommu_v1.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -654,8 +654,10 @@ static int mtk_iommu_v1_probe(struct pla
 		struct platform_device *plarbdev;
 
 		larbnode = of_parse_phandle(dev->of_node, "mediatek,larbs", i);
-		if (!larbnode)
-			return -EINVAL;
+		if (!larbnode) {
+			ret = -EINVAL;
+			goto out_put_larbs;
+		}
 
 		if (!of_device_is_available(larbnode)) {
 			of_node_put(larbnode);
@@ -665,11 +667,14 @@ static int mtk_iommu_v1_probe(struct pla
 		plarbdev = of_find_device_by_node(larbnode);
 		if (!plarbdev) {
 			of_node_put(larbnode);
-			return -ENODEV;
+			ret = -ENODEV;
+			goto out_put_larbs;
 		}
 		if (!plarbdev->dev.driver) {
 			of_node_put(larbnode);
-			return -EPROBE_DEFER;
+			put_device(&plarbdev->dev);
+			ret = -EPROBE_DEFER;
+			goto out_put_larbs;
 		}
 		data->larb_imu[i].dev = &plarbdev->dev;
 
@@ -681,7 +686,7 @@ static int mtk_iommu_v1_probe(struct pla
 
 	ret = mtk_iommu_v1_hw_init(data);
 	if (ret)
-		return ret;
+		goto out_put_larbs;
 
 	ret = iommu_device_sysfs_add(&data->iommu, &pdev->dev, NULL,
 				     dev_name(&pdev->dev));
@@ -703,12 +708,17 @@ out_sysfs_remove:
 	iommu_device_sysfs_remove(&data->iommu);
 out_clk_unprepare:
 	clk_disable_unprepare(data->bclk);
+out_put_larbs:
+	for (i = 0; i < MTK_LARB_NR_MAX; i++)
+		put_device(data->larb_imu[i].dev);
+
 	return ret;
 }
 
 static void mtk_iommu_v1_remove(struct platform_device *pdev)
 {
 	struct mtk_iommu_v1_data *data = platform_get_drvdata(pdev);
+	int i;
 
 	iommu_device_sysfs_remove(&data->iommu);
 	iommu_device_unregister(&data->iommu);
@@ -716,6 +726,9 @@ static void mtk_iommu_v1_remove(struct p
 	clk_disable_unprepare(data->bclk);
 	devm_free_irq(&pdev->dev, data->irq, data);
 	component_master_del(&pdev->dev, &mtk_iommu_v1_com_ops);
+
+	for (i = 0; i < MTK_LARB_NR_MAX; i++)
+		put_device(data->larb_imu[i].dev);
 }
 
 static int __maybe_unused mtk_iommu_v1_suspend(struct device *dev)


