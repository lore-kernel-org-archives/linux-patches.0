Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9A374C0C;
	Mon, 15 Apr 2024 14:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191148; cv=none; b=TlYa5QuGEjlsj5Ea5oZLhzmckunIIkTbdCLOS/+kTmXhDqedSC88R7aPyQDWtStikQ/H5ism25qQQ8Igvp9mWVfgVv8tchlrKZWZK/OKVCHaweWZK2lrVSchpzLGkW18kXxjETltPVosSmTfecWkINRemVdXftdS5atTk51nFD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191148; c=relaxed/simple;
	bh=qropjtm1ZEGxoMkWPLsK/KhzNVpJlzfeY8fMMnV+zjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkxOCP5m8wqUsuXoUHJD22gNwjk25WZCkuJqLh+HYoJI/QfHcEsDKD3xNbMAEoIdCrYsL9ASOxycHvuBGqvJmf8zi2+pmD5zrV7k0aX0yUCEA6eGhBolCQgvDaTxFXEXgQomhaAaOmwxlNOzlpX4ZYtIm9Bsen4npY8mYMqa8Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1RK5l2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1RK5l2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24ABDC2BD10;
	Mon, 15 Apr 2024 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191148;
	bh=qropjtm1ZEGxoMkWPLsK/KhzNVpJlzfeY8fMMnV+zjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1RK5l2PMnvPNirsdjlVGWSNSCAC2HdQL3wphzZ+POnsfxvXRNYkhVsivy8t7RtSe
	 lGBzHmH1uRkhyobpt5awHePmhNpCNSreazj0r+vh7dJpQLqEJrKnDMkxyiHn7Sj/oH
	 YGqDN1+SuCDaiaeaCsDm7cK0QxvbV+E7bsfni2Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 047/172] block: fix q->blkg_list corruption during disk rebind
Date: Mon, 15 Apr 2024 16:19:06 +0200
Message-ID: <20240415142001.847109919@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 8b8ace080319a866f5dfe9da8e665ae51d971c54 ]

Multiple gendisk instances can allocated/added for single request queue
in case of disk rebind. blkg may still stay in q->blkg_list when calling
blkcg_init_disk() for rebind, then q->blkg_list becomes corrupted.

Fix the list corruption issue by:

- add blkg_init_queue() to initialize q->blkg_list & q->blkcg_mutex only
- move calling blkg_init_queue() into blk_alloc_queue()

The list corruption should be started since commit f1c006f1c685 ("blk-cgroup:
synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()")
which delays removing blkg from q->blkg_list into blkg_free_workfn().

Fixes: f1c006f1c685 ("blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()")
Fixes: 1059699f87eb ("block: move blkcg initialization/destroy into disk allocation/release handler")
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240407125910.4053377-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 9 ++++++---
 block/blk-cgroup.h | 2 ++
 block/blk-core.c   | 2 ++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ff93c385ba5af..4529122e0cbdb 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1409,6 +1409,12 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
 	return 0;
 }
 
+void blkg_init_queue(struct request_queue *q)
+{
+	INIT_LIST_HEAD(&q->blkg_list);
+	mutex_init(&q->blkcg_mutex);
+}
+
 int blkcg_init_disk(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
@@ -1416,9 +1422,6 @@ int blkcg_init_disk(struct gendisk *disk)
 	bool preloaded;
 	int ret;
 
-	INIT_LIST_HEAD(&q->blkg_list);
-	mutex_init(&q->blkcg_mutex);
-
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
 		return -ENOMEM;
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index b927a4a0ad030..5b0bdc268ade9 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -188,6 +188,7 @@ struct blkcg_policy {
 extern struct blkcg blkcg_root;
 extern bool blkcg_debug_stats;
 
+void blkg_init_queue(struct request_queue *q);
 int blkcg_init_disk(struct gendisk *disk);
 void blkcg_exit_disk(struct gendisk *disk);
 
@@ -481,6 +482,7 @@ struct blkcg {
 };
 
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
+static inline void blkg_init_queue(struct request_queue *q) { }
 static inline int blkcg_init_disk(struct gendisk *disk) { return 0; }
 static inline void blkcg_exit_disk(struct gendisk *disk) { }
 static inline int blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
diff --git a/block/blk-core.c b/block/blk-core.c
index de771093b5268..99d684085719d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -431,6 +431,8 @@ struct request_queue *blk_alloc_queue(int node_id)
 	init_waitqueue_head(&q->mq_freeze_wq);
 	mutex_init(&q->mq_freeze_lock);
 
+	blkg_init_queue(q);
+
 	/*
 	 * Init percpu_ref in atomic mode so that it's faster to shutdown.
 	 * See blk_register_queue() for details.
-- 
2.43.0



