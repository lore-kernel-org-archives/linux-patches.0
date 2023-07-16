Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042938F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F18C433C8;
	Sun, 16 Jul 2023 19:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537322;
	bh=vUK77IlKZc0r2vG5CAl6vNhidrsC+gPI5OwLxs3ieVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9zK0B75ri5EV/b2mQjS/kRMKNYc3FWsV4fqAQEI9qsKF313LnLWDBfoMVMJc7VM2
	 7dNuIBz6C2V3KnS9fAeOGje+3g3WjQXvzCPm3jbZOACmFazKYR/KvhoTqaEQguzWw2
	 eim9jcE9wHj+wPZ34UNzsN8q0zACdCKaG7+zdva8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 027/800] blk-mq: fix potential io hang by wrong wake_batch
Date: Sun, 16 Jul 2023 21:38:00 +0200
Message-ID: <20230716194949.730249864@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit 4f1731df60f9033669f024d06ae26a6301260b55 ]

In __blk_mq_tag_busy/idle(), updating 'active_queues' and calculating
'wake_batch' is not atomic:

t1:			t2:
_blk_mq_tag_busy	blk_mq_tag_busy
inc active_queues
// assume 1->2
			inc active_queues
			// 2 -> 3
			blk_mq_update_wake_batch
			// calculate based on 3
blk_mq_update_wake_batch
/* calculate based on 2, while active_queues is actually 3. */

Fix this problem by protecting them wih 'tags->lock', this is not a hot
path, so performance should not be concerned. And now that all writers
are inside the lock, switch 'actives_queues' from atomic to unsigned
int.

Fixes: 180dccb0dba4 ("blk-mq: fix tag_get wait task can't be awakened")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230610023043.2559121-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-debugfs.c |  2 +-
 block/blk-mq-tag.c     | 15 ++++++++++-----
 block/blk-mq.h         |  3 +--
 include/linux/blk-mq.h |  3 +--
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index d23a8554ec4ae..7851e149d365f 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -399,7 +399,7 @@ static void blk_mq_debugfs_tags_show(struct seq_file *m,
 	seq_printf(m, "nr_tags=%u\n", tags->nr_tags);
 	seq_printf(m, "nr_reserved_tags=%u\n", tags->nr_reserved_tags);
 	seq_printf(m, "active_queues=%d\n",
-		   atomic_read(&tags->active_queues));
+		   READ_ONCE(tags->active_queues));
 
 	seq_puts(m, "\nbitmap_tags:\n");
 	sbitmap_queue_show(&tags->bitmap_tags, m);
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index dfd81cab57888..cc57e2dd9a0bb 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -38,6 +38,7 @@ static void blk_mq_update_wake_batch(struct blk_mq_tags *tags,
 void __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 {
 	unsigned int users;
+	struct blk_mq_tags *tags = hctx->tags;
 
 	/*
 	 * calling test_bit() prior to test_and_set_bit() is intentional,
@@ -55,9 +56,11 @@ void __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 			return;
 	}
 
-	users = atomic_inc_return(&hctx->tags->active_queues);
-
-	blk_mq_update_wake_batch(hctx->tags, users);
+	spin_lock_irq(&tags->lock);
+	users = tags->active_queues + 1;
+	WRITE_ONCE(tags->active_queues, users);
+	blk_mq_update_wake_batch(tags, users);
+	spin_unlock_irq(&tags->lock);
 }
 
 /*
@@ -90,9 +93,11 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 			return;
 	}
 
-	users = atomic_dec_return(&tags->active_queues);
-
+	spin_lock_irq(&tags->lock);
+	users = tags->active_queues - 1;
+	WRITE_ONCE(tags->active_queues, users);
 	blk_mq_update_wake_batch(tags, users);
+	spin_unlock_irq(&tags->lock);
 
 	blk_mq_tag_wakeup_all(tags, false);
 }
diff --git a/block/blk-mq.h b/block/blk-mq.h
index e876584d35163..890fef9796bf9 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -417,8 +417,7 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 			return true;
 	}
 
-	users = atomic_read(&hctx->tags->active_queues);
-
+	users = READ_ONCE(hctx->tags->active_queues);
 	if (!users)
 		return true;
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 06caacd77ed66..710d122472641 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -746,8 +746,7 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 struct blk_mq_tags {
 	unsigned int nr_tags;
 	unsigned int nr_reserved_tags;
-
-	atomic_t active_queues;
+	unsigned int active_queues;
 
 	struct sbitmap_queue bitmap_tags;
 	struct sbitmap_queue breserved_tags;
-- 
2.39.2



