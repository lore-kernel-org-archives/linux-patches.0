Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882E61D6A7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC6AC433CA;
	Wed, 20 Sep 2023 11:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210676;
	bh=MIPkkOCqqxAHf33xiWhmZb5dAjxfMRYuI9INjv+i7uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0W+lTYncGyI6kOCPzX7Cw3QYfVXtK5pyFgkuGD47Ithz5QaQcZV87sW4FUFMRZRW
	 n82RUSchtgD+1Gcc379ee32elDG2IZBWtJzRgYjfwdyCdm8SF+g9c1aDFtLFmnlqAh
	 RautKUcfMqdGE6wMa4IXqGGaBaYTMCjoT6aOMQA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 164/211] blk-mq: fix tags UAF when shrinking q->nr_hw_queues
Date: Wed, 20 Sep 2023 13:30:08 +0200
Message-ID: <20230920112850.972495331@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit 6be6d112419713334ddd9c01f219ca16adaa4c76 ]

When nr_hw_queues shrink, we free the excess tags before realloc'ing
hw_ctxs for each queue. During that resize, we may need to access those
tags, like blk_mq_tag_idle(hctx) will access queue shared tags.

This can cause a slab use-after-free, as reported by KASAN. Fix it by
moving the releasing of excess tags to the end.

Fixes: e1dd7bc93029 ("blk-mq: fix tags leak when shrink nr_hw_queues")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/all/CAHj4cs_CK63uoDpGBGZ6DN4OCTpzkR3UaVgK=LX8Owr8ej2ieQ@mail.gmail.com/
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20230908005702.2183908-1-chengming.zhou@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4404,11 +4404,8 @@ static int blk_mq_realloc_tag_set_tags(s
 	struct blk_mq_tags **new_tags;
 	int i;
 
-	if (set->nr_hw_queues >= new_nr_hw_queues) {
-		for (i = new_nr_hw_queues; i < set->nr_hw_queues; i++)
-			__blk_mq_free_map_and_rqs(set, i);
+	if (set->nr_hw_queues >= new_nr_hw_queues)
 		goto done;
-	}
 
 	new_tags = kcalloc_node(new_nr_hw_queues, sizeof(struct blk_mq_tags *),
 				GFP_KERNEL, set->numa_node);
@@ -4718,7 +4715,8 @@ static void __blk_mq_update_nr_hw_queues
 {
 	struct request_queue *q;
 	LIST_HEAD(head);
-	int prev_nr_hw_queues;
+	int prev_nr_hw_queues = set->nr_hw_queues;
+	int i;
 
 	lockdep_assert_held(&set->tag_list_lock);
 
@@ -4745,7 +4743,6 @@ static void __blk_mq_update_nr_hw_queues
 		blk_mq_sysfs_unregister_hctxs(q);
 	}
 
-	prev_nr_hw_queues = set->nr_hw_queues;
 	if (blk_mq_realloc_tag_set_tags(set, nr_hw_queues) < 0)
 		goto reregister;
 
@@ -4781,6 +4778,10 @@ switch_back:
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_unfreeze_queue(q);
+
+	/* Free the excess tags when nr_hw_queues shrink. */
+	for (i = set->nr_hw_queues; i < prev_nr_hw_queues; i++)
+		__blk_mq_free_map_and_rqs(set, i);
 }
 
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)


