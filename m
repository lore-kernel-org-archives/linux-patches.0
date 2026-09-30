Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF55513548;
	Wed, 30 Sep 2026 16:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786298; cv=none; b=s5pOoGN0EalltoIsF5jBndmi7PYB5+fNkEerebtl7Dxb354wFxCCiHQGFgegEyv2e9lrJM9v/P9d+hG2AFpypdJgTnByBwX0WBUEF2g1HL86lTT02B0XZB0dW7qq8EgqbQNaGcSWAMSom5NNRgjrYvM93g6OBRLwXwsBUr2J3bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786298; c=relaxed/simple;
	bh=LFIXcYbgF03dq1RK5mYfW77ZWmyq05M26eop2SNPk2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYvOarqpbsgHyM4tahTGWsGiIOuAS6J2IcSIJ/WEcIffhYKPzII0Bh17cvoen/rpEH9/izz2J0PuZlRPVElvKkyeMXz66yXrva+nMOzhh8+7+mkuqh52QXHseOy7DLHCOw0UyoQMyt4cxYfRBhSVeD9ICDDzP8brHLU9MNhT0UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqyK/XNw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqyK/XNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065DB1F000FF;
	Wed, 30 Sep 2026 16:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786296;
	bh=SX84ItWGA/2TaFPY65iLvufBUcR3URXESejUj0/EZts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LqyK/XNwNjQoO/b3Fsqh2fS/2cxBP2uMXiiE9yz+ABBZ9F42niizPuI0VmuQWfOoV
	 S8f9FYSe5470C+KQS85rfAB9uqSkDJRTGAhPL7s4kedafaWwH9teRGDSr8vxsP+O88
	 ncjAMLVilOoUp47aSWbz4QghbzO+UlzkGzPAjs8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 785/982] blk-mq: fix tags UAF when shrinking q->nr_hw_queues
Date: Wed, 30 Sep 2026 17:25:21 +0200
Message-ID: <20260930152433.617379019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Backport to 6.1.y follow-up to e1dd7bc93029: move those frees after
  hctx resizing using cur_nr_hw_queues, preventing its tag UAF. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b6215bee3d3c4..bf69079f6bd51 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4509,13 +4509,9 @@ static int blk_mq_realloc_tag_set_tags(struct blk_mq_tag_set *set,
 				  int cur_nr_hw_queues, int new_nr_hw_queues)
 {
 	struct blk_mq_tags **new_tags;
-	int i;
 
-	if (cur_nr_hw_queues >= new_nr_hw_queues) {
-		for (i = new_nr_hw_queues; i < cur_nr_hw_queues; i++)
-			__blk_mq_free_map_and_rqs(set, i);
+	if (cur_nr_hw_queues >= new_nr_hw_queues)
 		return 0;
-	}
 
 	new_tags = kcalloc_node(new_nr_hw_queues, sizeof(struct blk_mq_tags *),
 				GFP_KERNEL, set->numa_node);
@@ -4804,7 +4800,8 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 {
 	struct request_queue *q;
 	LIST_HEAD(head);
-	int prev_nr_hw_queues;
+	int prev_nr_hw_queues = set->nr_hw_queues;
+	int i;
 
 	lockdep_assert_held(&set->tag_list_lock);
 
@@ -4831,7 +4828,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 		blk_mq_sysfs_unregister_hctxs(q);
 	}
 
-	prev_nr_hw_queues = set->nr_hw_queues;
 	if (blk_mq_realloc_tag_set_tags(set, set->nr_hw_queues, nr_hw_queues) <
 	    0)
 		goto reregister;
@@ -4869,6 +4865,10 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_unfreeze_queue(q);
+
+	/* Free the excess tags when nr_hw_queues shrink. */
+	for (i = set->nr_hw_queues; i < prev_nr_hw_queues; i++)
+		__blk_mq_free_map_and_rqs(set, i);
 }
 
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
-- 
2.53.0



