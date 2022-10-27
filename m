Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A907F8486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC53C433C1;
	Thu, 27 Oct 2022 16:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889925;
	bh=5X2TlAsBr5HT/ekQiYGX+cQVn4SWer7Yr+Kltw0Tm2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny8rsvf4MS7En6jR8BYhf9qzpuldV1W18suVN9d85X0z3QpbFiNIg9y2BevdMz35z
	 04KqNGDmh3edz/T3xSBe8Pd7jYlCqZ6wb2W7jcQ1ET9r0l8CDX4PJWdr3CTZKy91cB
	 oMtd6i7ZJrO7S/brYr77h0/GKN8jX7PCeMVv7bqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	John Garry <john.garry@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 50/94] blk-mq: fix null pointer dereference in blk_mq_clear_rq_mapping()
Date: Thu, 27 Oct 2022 18:54:52 +0200
Message-Id: <20221027165059.182919288@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 76dd298094f484c6250ebd076fa53287477b2328 ]

Our syzkaller report a null pointer dereference, root cause is
following:

__blk_mq_alloc_map_and_rqs
 set->tags[hctx_idx] = blk_mq_alloc_map_and_rqs
  blk_mq_alloc_map_and_rqs
   blk_mq_alloc_rqs
    // failed due to oom
    alloc_pages_node
    // set->tags[hctx_idx] is still NULL
    blk_mq_free_rqs
     drv_tags = set->tags[hctx_idx];
     // null pointer dereference is triggered
     blk_mq_clear_rq_mapping(drv_tags, ...)

This is because commit 63064be150e4 ("blk-mq:
Add blk_mq_alloc_map_and_rqs()") merged the two steps:

1) set->tags[hctx_idx] = blk_mq_alloc_rq_map()
2) blk_mq_alloc_rqs(..., set->tags[hctx_idx])

into one step:

set->tags[hctx_idx] = blk_mq_alloc_map_and_rqs()

Since tags is not initialized yet in this case, fix the problem by
checking if tags is NULL pointer in blk_mq_clear_rq_mapping().

Fixes: 63064be150e4 ("blk-mq: Add blk_mq_alloc_map_and_rqs()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/20221011142253.4015966-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 887b8682eb69..fe840536e6ac 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3028,8 +3028,11 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
 	struct page *page;
 	unsigned long flags;
 
-	/* There is no need to clear a driver tags own mapping */
-	if (drv_tags == tags)
+	/*
+	 * There is no need to clear mapping if driver tags is not initialized
+	 * or the mapping belongs to the driver tags.
+	 */
+	if (!drv_tags || drv_tags == tags)
 		return;
 
 	list_for_each_entry(page, &tags->page_list, lru) {
-- 
2.35.1



