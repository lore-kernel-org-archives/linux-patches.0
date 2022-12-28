Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112AE1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85385C433D2;
	Wed, 28 Dec 2022 16:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245334;
	bh=j6F/wc8vtUCvD9wCq4ZyLu9xcW/gTLGrdtJRhN+GuYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuvaeMwFGgk/bCIbpZslaxARJj+WiJu4W1UH7LgkmwdONRwOSA1dsOnenMl4cDsMI
	 Jp3tMEqpfDSmIDk8KevGe0q1PUeWXTGiVQDUye+bfh7SwVUTNb4K4rul6CLWfq0bgu
	 GBarSpLLStEGHiT0WN5XriygNg4FOLKDFAjCB7FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0841/1146] iommu/mediatek: Check return value after calling platform_get_resource()
Date: Wed, 28 Dec 2022 15:39:40 +0100
Message-Id: <20221228144352.999261585@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 73b6924cdebc899de9b719e1319aa86c6bed4acf ]

platform_get_resource() may return NULL pointer, we need check its
return value to avoid null-ptr-deref in resource_size().

Fixes: 42d57fc58aeb ("iommu/mediatek: Initialise/Remove for multi bank dev")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20221029103550.3774365-1-yangyingliang@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 2ab2ecfe01f8..2d14dc846b83 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1173,6 +1173,8 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 
 	banks_num = data->plat_data->banks_num;
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 	if (resource_size(res) < banks_num * MTK_IOMMU_BANK_SZ) {
 		dev_err(dev, "banknr %d. res %pR is not enough.\n", banks_num, res);
 		return -EINVAL;
-- 
2.35.1



