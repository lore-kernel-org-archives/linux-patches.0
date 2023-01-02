Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E086628EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EC0C433D2;
	Mon,  2 Jan 2023 11:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658885;
	bh=+WqYG61EZeWSB++ZlVi6LOKpBaW1/2UKgLGUqUVnJ58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2TQDTbCPvEmGH+hJbczCWkFZRvi36mQcQjrpBzy7qxiXparQGHiqzYmj4810nsx1
	 CrvxKxdqtC9G3u3ABARULJoa5pqXmq3ikXo0KUOs9Jl9JbY5ED0owH1AO3KbhLwvNk
	 L9m3/c+gOrnX07zWjWYJjOKm/8Aad/RG4ldCfweU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andreas Herrmann <aherrmann@suse.de>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 06/74] blk-cgroup: pass a gendisk to blkcg_init_queue and blkcg_exit_queue
Date: Mon,  2 Jan 2023 12:21:39 +0100
Message-Id: <20230102110552.325564169@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

[ Upstream commit 9823538fb7efe66ce987a1e4c0e0f3dc882623c4 ]

Pass the gendisk to blkcg_init_disk and blkcg_exit_disk as part of moving
the blk-cgroup infrastructure to be gendisk based.  Also remove the
rather pointless kerneldoc comments for these internal functions with a
single caller each.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220921180501.1539876-7-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 813e693023ba ("blk-iolatency: Fix memory leak on add_disk() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 25 +++++--------------------
 block/blk-cgroup.h |  8 ++++----
 block/genhd.c      |  5 +++--
 3 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f66cf1734e84..4943f36d8a84 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1246,18 +1246,9 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
 	return 0;
 }
 
-/**
- * blkcg_init_queue - initialize blkcg part of request queue
- * @q: request_queue to initialize
- *
- * Called from blk_alloc_queue(). Responsible for initializing blkcg
- * part of new request_queue @q.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int blkcg_init_queue(struct request_queue *q)
+int blkcg_init_disk(struct gendisk *disk)
 {
+	struct request_queue *q = disk->queue;
 	struct blkcg_gq *new_blkg, *blkg;
 	bool preloaded;
 	int ret;
@@ -1310,16 +1301,10 @@ int blkcg_init_queue(struct request_queue *q)
 	return PTR_ERR(blkg);
 }
 
-/**
- * blkcg_exit_queue - exit and release blkcg part of request_queue
- * @q: request_queue being released
- *
- * Called from blk_exit_queue().  Responsible for exiting blkcg part.
- */
-void blkcg_exit_queue(struct request_queue *q)
+void blkcg_exit_disk(struct gendisk *disk)
 {
-	blkg_destroy_all(q);
-	blk_throtl_exit(q);
+	blkg_destroy_all(disk->queue);
+	blk_throtl_exit(disk->queue);
 }
 
 static void blkcg_bind(struct cgroup_subsys_state *root_css)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 91b7ae0773be..aa2b286bc825 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -178,8 +178,8 @@ struct blkcg_policy {
 extern struct blkcg blkcg_root;
 extern bool blkcg_debug_stats;
 
-int blkcg_init_queue(struct request_queue *q);
-void blkcg_exit_queue(struct request_queue *q);
+int blkcg_init_disk(struct gendisk *disk);
+void blkcg_exit_disk(struct gendisk *disk);
 
 /* Blkio controller policy registration */
 int blkcg_policy_register(struct blkcg_policy *pol);
@@ -481,8 +481,8 @@ struct blkcg {
 };
 
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
-static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
-static inline void blkcg_exit_queue(struct request_queue *q) { }
+static inline int blkcg_init_disk(struct gendisk *disk) { return 0; }
+static inline void blkcg_exit_disk(struct gendisk *disk) { }
 static inline int blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
 static inline void blkcg_policy_unregister(struct blkcg_policy *pol) { }
 static inline int blkcg_activate_policy(struct request_queue *q,
diff --git a/block/genhd.c b/block/genhd.c
index 28654723bc2b..0568da4c0a2e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1154,7 +1154,8 @@ static void disk_release(struct device *dev)
 	    !test_bit(GD_ADDED, &disk->state))
 		blk_mq_exit_queue(disk->queue);
 
-	blkcg_exit_queue(disk->queue);
+	blkcg_exit_disk(disk);
+
 	bioset_exit(&disk->bio_split);
 
 	disk_release_events(disk);
@@ -1367,7 +1368,7 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
 		goto out_destroy_part_tbl;
 
-	if (blkcg_init_queue(q))
+	if (blkcg_init_disk(disk))
 		goto out_erase_part0;
 
 	rand_initialize_disk(disk);
-- 
2.35.1



