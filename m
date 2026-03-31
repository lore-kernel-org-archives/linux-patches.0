Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3FF423A76;
	Tue, 31 Mar 2026 16:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974889; cv=none; b=SEyQxv0B4iaDUCWRDzZ10OpktTPpx+EUeS8q/gy29S0bxq22wffmdYwDB2bPK4hLCKxKgR7UXoaI4Zb5fLqA4tqohRxa6v8ES1moeOSADdRlKYl2n7EZ3/HqYKz5AZC2RabgseLbuNmRexCL9cg3losy+uE3xnqvoHFl3hEjESk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974889; c=relaxed/simple;
	bh=Vh1ahq59aDt8J70RP8WToCoVt0OeKtaLRL2ktoMHMmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFAWOUOaacVl3bRWTbtsggSeNMXJhdNITmVZgpgyzjwQq/VOzt923fRCTTgCqmS/MzkQXZWnIMsgt4C91BK6+5SmpoiG+BXIyFi6svueaNyVT896oDgIikPSEFAU1Hcqj4J6e8+Bwyu10plEprDIGHLF6FTSoQvZr1LEuRBFEyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oim74WmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oim74WmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFFFC19423;
	Tue, 31 Mar 2026 16:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974889;
	bh=Vh1ahq59aDt8J70RP8WToCoVt0OeKtaLRL2ktoMHMmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oim74WmS/gAax0OZ0NmhrSO1F7WTz0SKw2dEdoeiR0JU9mt/+7e4IqELBs/6hEFg2
	 qJqau0x2gFM2+MldRLfXOuA/KNCn40OKgF/3gbQqAK3GURmcmZWHPgLrx2ctsxPnKb
	 7CdA+1X0mSRuboR5WsxzngebOuW0vAC/H+ua3RSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 056/342] block: break pcpu_alloc_mutex dependency on freeze_lock
Date: Tue, 31 Mar 2026 18:18:09 +0200
Message-ID: <20260331161800.958732894@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 539d1b47e935e8384977dd7e5cec370c08b7a644 ]

While nr_hw_update allocates tagset tags it acquires ->pcpu_alloc_mutex
after ->freeze_lock is acquired or queue is frozen. This potentially
creates a circular dependency involving ->fs_reclaim if reclaim is
triggered simultaneously in a code path which first acquires ->pcpu_
alloc_mutex. As the queue is already frozen while nr_hw_queue update
allocates tagsets, the reclaim can't forward progress and thus it could
cause a potential deadlock as reported in lockdep splat[1].

Fix this by pre-allocating tagset tags before we freeze queue during
nr_hw_queue update. Later the allocated tagset tags could be safely
installed and used after queue is frozen.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/all/CAHj4cs8F=OV9s3La2kEQ34YndgfZP-B5PHS4Z8_b9euKG6J4mw@mail.gmail.com/ [1]
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
[axboe: fix brace style issue]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 968699277c3d5..3b58dd5876114 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4778,38 +4778,45 @@ static void blk_mq_update_queue_map(struct blk_mq_tag_set *set)
 	}
 }
 
-static int blk_mq_realloc_tag_set_tags(struct blk_mq_tag_set *set,
-				       int new_nr_hw_queues)
+static struct blk_mq_tags **blk_mq_prealloc_tag_set_tags(
+				struct blk_mq_tag_set *set,
+				int new_nr_hw_queues)
 {
 	struct blk_mq_tags **new_tags;
 	int i;
 
 	if (set->nr_hw_queues >= new_nr_hw_queues)
-		goto done;
+		return NULL;
 
 	new_tags = kcalloc_node(new_nr_hw_queues, sizeof(struct blk_mq_tags *),
 				GFP_KERNEL, set->numa_node);
 	if (!new_tags)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (set->tags)
 		memcpy(new_tags, set->tags, set->nr_hw_queues *
 		       sizeof(*set->tags));
-	kfree(set->tags);
-	set->tags = new_tags;
 
 	for (i = set->nr_hw_queues; i < new_nr_hw_queues; i++) {
-		if (!__blk_mq_alloc_map_and_rqs(set, i)) {
-			while (--i >= set->nr_hw_queues)
-				__blk_mq_free_map_and_rqs(set, i);
-			return -ENOMEM;
+		if (blk_mq_is_shared_tags(set->flags)) {
+			new_tags[i] = set->shared_tags;
+		} else {
+			new_tags[i] = blk_mq_alloc_map_and_rqs(set, i,
+					set->queue_depth);
+			if (!new_tags[i])
+				goto out_unwind;
 		}
 		cond_resched();
 	}
 
-done:
-	set->nr_hw_queues = new_nr_hw_queues;
-	return 0;
+	return new_tags;
+out_unwind:
+	while (--i >= set->nr_hw_queues) {
+		if (!blk_mq_is_shared_tags(set->flags))
+			blk_mq_free_map_and_rqs(set, new_tags[i], i);
+	}
+	kfree(new_tags);
+	return ERR_PTR(-ENOMEM);
 }
 
 /*
@@ -5093,6 +5100,7 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 	unsigned int memflags;
 	int i;
 	struct xarray elv_tbl;
+	struct blk_mq_tags **new_tags;
 	bool queues_frozen = false;
 
 	lockdep_assert_held(&set->tag_list_lock);
@@ -5127,11 +5135,18 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 		if (blk_mq_elv_switch_none(q, &elv_tbl))
 			goto switch_back;
 
+	new_tags = blk_mq_prealloc_tag_set_tags(set, nr_hw_queues);
+	if (IS_ERR(new_tags))
+		goto switch_back;
+
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_freeze_queue_nomemsave(q);
 	queues_frozen = true;
-	if (blk_mq_realloc_tag_set_tags(set, nr_hw_queues) < 0)
-		goto switch_back;
+	if (new_tags) {
+		kfree(set->tags);
+		set->tags = new_tags;
+	}
+	set->nr_hw_queues = nr_hw_queues;
 
 fallback:
 	blk_mq_update_queue_map(set);
-- 
2.51.0



