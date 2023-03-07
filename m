Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CF6BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204A6C433D2;
	Tue,  7 Mar 2023 18:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215444;
	bh=76qygZA4dwmqhuNDmkDvgKmv43FOx6IoUSgQ0S1eyCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lo1auAG9cpmYttTHLlEMGfzBdUdx8y7tZ1q6WOnh8+TCBnbLUIrf5dhlKSY91EgSG
	 BCV+GEXosjtIzMNWymDFc8OcrvOucx1hw3DmQDiqWVWqgtVVkdGJTFWumlOIeUcpaH
	 OYoKWgUYyM/FE0mrjHeI90IMZr53FHiwq5ab63A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/567] scsi: aic94xx: Add missing check for dma_map_single()
Date: Tue,  7 Mar 2023 17:59:27 +0100
Message-Id: <20230307165915.939621890@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 32fe45274edb5926abc0fac7263d9f889d02d9cf ]

Add check for dma_map_single() and return error if it fails in order to
avoid invalid DMA address.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Link: https://lore.kernel.org/r/20230128110832.6792-1-jiasheng@iscas.ac.cn
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic94xx/aic94xx_task.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index c6b63eae28f51..ce48f34f412f0 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -50,6 +50,9 @@ static int asd_map_scatterlist(struct sas_task *task,
 		dma_addr_t dma = dma_map_single(&asd_ha->pcidev->dev, p,
 						task->total_xfer_len,
 						task->data_dir);
+		if (dma_mapping_error(&asd_ha->pcidev->dev, dma))
+			return -ENOMEM;
+
 		sg_arr[0].bus_addr = cpu_to_le64((u64)dma);
 		sg_arr[0].size = cpu_to_le32(task->total_xfer_len);
 		sg_arr[0].flags |= ASD_SG_EL_LIST_EOL;
-- 
2.39.2



