Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B60BA32
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57754C433C8;
	Mon, 19 Jun 2023 11:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172480;
	bh=x5cqhOOX9+WZOcrg9T2k5O5rVu0x/Hlo+PcmlWogr74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9Q9DRCn9MjrjxhrcgtBMkJGnZekx+o/FCnO0OQKXXN3btJ/Q20GSgFy0RV5gBfXV
	 3qptz27BlZKjEZBkA0wfWYrne6r61UvM39UJMal5mcmopE2jNbepDGyYX03dYwLoyd
	 MKsEqPY010pvYMXvUHnFPfAaQT5GlB/u0YzrSdJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/107] RDMA/rtrs: Fix the last iu->buf leak in err path
Date: Mon, 19 Jun 2023 12:30:42 +0200
Message-ID: <20230619102144.264733467@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 3bf3a7c6985c625f64e73baefdaa36f1c2045a29 ]

The last iu->buf will leak if ib_dma_mapping_error() fails.

Fixes: c0894b3ea69d ("RDMA/rtrs: core: lib functions shared between client and server modules")
Link: https://lore.kernel.org/r/1682384563-2-3-git-send-email-lizhijian@fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index 4da889103a5ff..4745f33d7104a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -37,8 +37,10 @@ struct rtrs_iu *rtrs_iu_alloc(u32 iu_num, size_t size, gfp_t gfp_mask,
 			goto err;
 
 		iu->dma_addr = ib_dma_map_single(dma_dev, iu->buf, size, dir);
-		if (ib_dma_mapping_error(dma_dev, iu->dma_addr))
+		if (ib_dma_mapping_error(dma_dev, iu->dma_addr)) {
+			kfree(iu->buf);
 			goto err;
+		}
 
 		iu->cqe.done  = done;
 		iu->size      = size;
-- 
2.39.2



