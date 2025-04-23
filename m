Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1496B189F39;
	Wed, 23 Apr 2025 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421750; cv=none; b=tqSqCdXaqhiq5yU9dXKkYZA6UDzSwtbibWAjFvBZrNVmme1mlmpU4ds9c1zSFxiONV1nzi2Y4co15c5vzqPBukdOZFbMvRjQJN1Z2TWHShocDf3GYSZR2X6wcyI6uCLvr8T2+FOF6QoGN4V90AsF6KxKn4t8RZ5dr8jG1pFCrro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421750; c=relaxed/simple;
	bh=vYMBSWXINaYq945sryZJqNb5vdrtYb3awEbysn+c3eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZjgD1UUC8tQdV3rq8T2f+eZsP+A9wUP1+nLrI+Ka7M8Sg+I2UoOHJsXud/K3MVM/garsbaahvmNlN3JKE0Qo4nPfc9L8ry9zcRUXNvZ3HcRvEU+WAB/LW8iQ0JRXaPtew1f6Sv2r5PGUsPV00UjlRVbj6kYuljdx/wvfya2C8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXUIXtae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXUIXtae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAD3C4CEE8;
	Wed, 23 Apr 2025 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421750;
	bh=vYMBSWXINaYq945sryZJqNb5vdrtYb3awEbysn+c3eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXUIXtaedntf4/3xDNpGYv5dMLo/aOs1VlSFcJLv7ZB/1hyKRApvi+FVrKIaLH9aw
	 Lm4/81g2PREELI1EvK1gv+qrAYdJ5ARhUUWqKUbxPte8Qx+Zq3B9SpYgNa8Zi4vPnM
	 b4whLgNJ06N6JNmaL4YBNG0fZB/HFZroCeU75NiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/291] RDMA/hns: Fix wrong maximum DMA segment size
Date: Wed, 23 Apr 2025 16:42:43 +0200
Message-ID: <20250423142631.494334950@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 9beb2c91fb86e0be70a5833c6730441fa3c9efa8 ]

Set maximum DMA segment size to 2G instead of UINT_MAX due to HW limit.

Fixes: e0477b34d9d1 ("RDMA: Explicitly pass in the dma_device to ib_register_device")
Link: https://patch.msgid.link/r/20250327114724.3454268-3-huangjunxian6@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 5106b3ce89f08..eae22ac42e05d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -642,7 +642,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 		if (ret)
 			return ret;
 	}
-	dma_set_max_seg_size(dev, UINT_MAX);
+	dma_set_max_seg_size(dev, SZ_2G);
 	ret = ib_register_device(ib_dev, "hns_%d", dev);
 	if (ret) {
 		dev_err(dev, "ib_register_device failed!\n");
-- 
2.39.5



