Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238F379C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B039C433C1;
	Wed, 30 Nov 2022 18:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834110;
	bh=rtudHmHhc01+/aPmQNfd0ptQQKzu93QwJRAILq+diAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkHl33BDKHc0nWOM3WF4r41pMf0EzahONq2+zb/b5/+q6m5GShwupSL2rVGxGq5kw
	 VCBSNj7av+ljaLxHhSzXzNzZD13RWUV2Vef8QA6kUPt0Fn7ExWvt+9lqBT1hnY/E3w
	 JrbHudkR9mBS6mQeY4akMXVhuKfT0y78E+nG4mu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 132/289] blk-mq: fix queue reference leak on blk_mq_alloc_disk_for_queue failure
Date: Wed, 30 Nov 2022 19:21:57 +0100
Message-Id: <20221130180547.131336154@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 22c17e279a1b03bad7987e4a4192b289b890f293 ]

Drop the request queue reference just acquired when __alloc_disk_node
failed.

Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20221122072753.426077-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4402e4ecb8b1..3f1f5e3e0951 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3956,9 +3956,14 @@ EXPORT_SYMBOL(__blk_mq_alloc_disk);
 struct gendisk *blk_mq_alloc_disk_for_queue(struct request_queue *q,
 		struct lock_class_key *lkclass)
 {
+	struct gendisk *disk;
+
 	if (!blk_get_queue(q))
 		return NULL;
-	return __alloc_disk_node(q, NUMA_NO_NODE, lkclass);
+	disk = __alloc_disk_node(q, NUMA_NO_NODE, lkclass);
+	if (!disk)
+		blk_put_queue(q);
+	return disk;
 }
 EXPORT_SYMBOL(blk_mq_alloc_disk_for_queue);
 
-- 
2.35.1



