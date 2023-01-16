Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA8F46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905DBC433D2;
	Mon, 16 Jan 2023 16:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885311;
	bh=xi60FueD+t6nKnAtgiEThZmexk2RbBHkjvRnRMIcy3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YfOB+QRXeZR8WgSGRHVikKZZKjQW/dqoMdIs+y5mESw30+YBZePhREOOrVdfjhWm
	 xDEZgqbaYnXELSfHpxEB7OCwF7ZXTSyqBruUWD6lOsgk2hDF+DiXr+DreUyN9avqwz
	 SLNbgDT9Mp6J1hfz/BL8I2s41jg+qHrv8u6hg7RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/64] iommu/mediatek-v1: Add error handle for mtk_iommu_probe
Date: Mon, 16 Jan 2023 16:51:58 +0100
Message-Id: <20230116154745.340197684@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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

[ Upstream commit ac304c070c54413efabf29f9e73c54576d329774 ]

In the original code, we lack the error handle. This patch adds them.

Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Link: https://lore.kernel.org/r/20210412064843.11614-2-yong.wu@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 142e821f68cf ("iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu_v1.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index 82ddfe9170d4..4ed8bc755f5c 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -624,12 +624,26 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 
 	ret = iommu_device_register(&data->iommu);
 	if (ret)
-		return ret;
+		goto out_sysfs_remove;
 
-	if (!iommu_present(&platform_bus_type))
-		bus_set_iommu(&platform_bus_type,  &mtk_iommu_ops);
+	if (!iommu_present(&platform_bus_type)) {
+		ret = bus_set_iommu(&platform_bus_type,  &mtk_iommu_ops);
+		if (ret)
+			goto out_dev_unreg;
+	}
 
-	return component_master_add_with_match(dev, &mtk_iommu_com_ops, match);
+	ret = component_master_add_with_match(dev, &mtk_iommu_com_ops, match);
+	if (ret)
+		goto out_bus_set_null;
+	return ret;
+
+out_bus_set_null:
+	bus_set_iommu(&platform_bus_type, NULL);
+out_dev_unreg:
+	iommu_device_unregister(&data->iommu);
+out_sysfs_remove:
+	iommu_device_sysfs_remove(&data->iommu);
+	return ret;
 }
 
 static int mtk_iommu_remove(struct platform_device *pdev)
-- 
2.35.1



