Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D65933EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7CDC433EF;
	Mon, 16 Jan 2023 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885003;
	bh=ddxVIuZ80ekhAArGJ0kjPXXg5d7ym6qulLTSOE2DmSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvgF8ouposIKvON6Fl/mKp0PXH6VlRLE/BdCmouewTGPhhh8XQgEFTkgHJMPACNgv
	 XseKFG3soU7U4zTh6S01c1au/y6AyOykC+wFpvbBopuwiaLJ5wcia2g8pd9fWGjQGh
	 h+ymOgebAhciruazUkpUFCK8V1n1ojQuczUXmDcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Yong Wu <yong.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.15 38/86] iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()
Date: Mon, 16 Jan 2023 16:51:12 +0100
Message-Id: <20230116154748.658816564@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 142e821f68cf5da79ce722cb9c1323afae30e185 upstream.

A clk, prepared and enabled in mtk_iommu_v1_hw_init(), is not released in
the error handling path of mtk_iommu_v1_probe().

Add the corresponding clk_disable_unprepare(), as already done in the
remove function.

Fixes: b17336c55d89 ("iommu/mediatek: add support for mtk iommu generation one HW")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/593e7b7d97c6e064b29716b091a9d4fd122241fb.1671473163.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/mtk_iommu_v1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -655,7 +655,7 @@ static int mtk_iommu_probe(struct platfo
 	ret = iommu_device_sysfs_add(&data->iommu, &pdev->dev, NULL,
 				     dev_name(&pdev->dev));
 	if (ret)
-		return ret;
+		goto out_clk_unprepare;
 
 	ret = iommu_device_register(&data->iommu, &mtk_iommu_ops, dev);
 	if (ret)
@@ -678,6 +678,8 @@ out_dev_unreg:
 	iommu_device_unregister(&data->iommu);
 out_sysfs_remove:
 	iommu_device_sysfs_remove(&data->iommu);
+out_clk_unprepare:
+	clk_disable_unprepare(data->bclk);
 	return ret;
 }
 


