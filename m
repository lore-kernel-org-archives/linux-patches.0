Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C346FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF90C433EF;
	Thu,  1 Jun 2023 13:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685626007;
	bh=aqVK/aFHene3fMXpiV9PVreukKsTMhLtTjmZeC3NWww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4EeeyeRedhU8xAvTDADMh0sNAsxMFNrhi2hwlH5GTVVaMnPc26/qinYcHlXD3fgs
	 m40nqUlK5auf5J9pMF2UhUKxIl+DBzD1VFeGRds3ZyNaOCrcJkGkKD8IzODIEreUyR
	 c9u0lzfuGIGlCLo3R017JYFni0RNPj6EoYZ5a3kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tian Lan <tian.lan@twosigma.com>,
	Ming Lei <ming.lei@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 38/45] blk-mq: fix race condition in active queue accounting
Date: Thu,  1 Jun 2023 14:21:34 +0100
Message-Id: <20230601131940.443054353@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
References: <20230601131938.702671708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tian Lan <tian.lan@twosigma.com>

[ Upstream commit 3e94d54e83cafd2b562bb6d15bb2f72d76200fb5 ]

If multiple CPUs are sharing the same hardware queue, it can
cause leak in the active queue counter tracking when __blk_mq_tag_busy()
is executed simultaneously.

Fixes: ee78ec1077d3 ("blk-mq: blk_mq_tag_busy is no need to return a value")
Signed-off-by: Tian Lan <tian.lan@twosigma.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20230522210555.794134-1-tilan7663@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-tag.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 9eb968e14d31f..a80d7c62bdfe6 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -41,16 +41,20 @@ void __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 {
 	unsigned int users;
 
+	/*
+	 * calling test_bit() prior to test_and_set_bit() is intentional,
+	 * it avoids dirtying the cacheline if the queue is already active.
+	 */
 	if (blk_mq_is_shared_tags(hctx->flags)) {
 		struct request_queue *q = hctx->queue;
 
-		if (test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
+		if (test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) ||
+		    test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
 			return;
-		set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags);
 	} else {
-		if (test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
+		if (test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) ||
+		    test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
 			return;
-		set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state);
 	}
 
 	users = atomic_inc_return(&hctx->tags->active_queues);
-- 
2.39.2



