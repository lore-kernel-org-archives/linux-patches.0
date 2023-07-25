Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3C615AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53050C433C8;
	Tue, 25 Jul 2023 11:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283838;
	bh=1Y7KPaafpLmYTzRNxCApd7jMwlH0eji51A9J3OCx9vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c25+RkTtPfhw6kCb/pfoNmIulnU3Z5IzT9zeQqRoJ51+acCbPCEYqA/LDc/c/nIVI
	 0HF9Qe+qPN6CU2xE3bpIt8vrLsWmC+nWSlxwMouoD5LXT8bJWaeBfVX5+1m5cU0FvP
	 4cqJhGMZY36mhzQgL6tKJGvkV//stCZxrmmOVklg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/509] RDMA/hns: Fix hns_roce_table_get return value
Date: Tue, 25 Jul 2023 12:41:19 +0200
Message-ID: <20230725104600.152006679@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit cf5b608fb0e369c473a8303cad6ddb386505e5b8 ]

The return value of set_hem has been fixed to ENODEV, which will lead a
diagnostic information missing.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Link: https://lore.kernel.org/r/20230523121641.3132102-3-huangjunxian6@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 3c3187f22216a..854b41c14774d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -588,11 +588,12 @@ int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 	}
 
 	/* Set HEM base address(128K/page, pa) to Hardware */
-	if (hr_dev->hw->set_hem(hr_dev, table, obj, HEM_HOP_STEP_DIRECT)) {
+	ret = hr_dev->hw->set_hem(hr_dev, table, obj, HEM_HOP_STEP_DIRECT);
+	if (ret) {
 		hns_roce_free_hem(hr_dev, table->hem[i]);
 		table->hem[i] = NULL;
-		ret = -ENODEV;
-		dev_err(dev, "set HEM base address to HW failed.\n");
+		dev_err(dev, "set HEM base address to HW failed, ret = %d.\n",
+			ret);
 		goto out;
 	}
 
-- 
2.39.2



