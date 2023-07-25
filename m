Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1F91ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83B7C433C7;
	Tue, 25 Jul 2023 11:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284718;
	bh=mHqtrWmHQvosHAEQF48HnB7AOxcHyS2luVsj9VQzs10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cc1SMRiiOLpZ6DZKP6yZgyD32C9E1+frcaT5+wpGz8v12kEQILYH4R/G3xk6K/coW
	 LSky1mIiPODpzwbpJMZrY2qI5yvHkYQe4S2dhsaUlpMRNM7GhlsWyMWquKyv/92aJF
	 uRqPjptNb0wJTv1DNkZafh+YuIiN/cixmtTl7hy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jinghua <zhongjinghua@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 456/509] nbd: Add the maximum limit of allocated index in nbd_dev_add
Date: Tue, 25 Jul 2023 12:46:35 +0200
Message-ID: <20230725104614.613420470@linuxfoundation.org>
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

From: Zhong Jinghua <zhongjinghua@huawei.com>

[ Upstream commit f12bc113ce904777fd6ca003b473b427782b3dde ]

If the index allocated by idr_alloc greater than MINORMASK >> part_shift,
the device number will overflow, resulting in failure to create a block
device.

Fix it by imiting the size of the max allocation.

Signed-off-by: Zhong Jinghua <zhongjinghua@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230605122159.2134384-1-zhongjinghua@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b6940f0a9c905..e0f805ca0e727 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1723,7 +1723,8 @@ static int nbd_dev_add(int index)
 		if (err == -ENOSPC)
 			err = -EEXIST;
 	} else {
-		err = idr_alloc(&nbd_index_idr, nbd, 0, 0, GFP_KERNEL);
+		err = idr_alloc(&nbd_index_idr, nbd, 0,
+				(MINORMASK >> part_shift) + 1, GFP_KERNEL);
 		if (err >= 0)
 			index = err;
 	}
-- 
2.39.2



