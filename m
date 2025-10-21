Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679041A3029;
	Tue, 21 Oct 2025 20:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077516; cv=none; b=vAV+v8KZOleJmU5303ZcqGSlo2gXECZSXqBonlnJgQw5h/VAlXLfQ6ON4zXMkktQPQYRwO1FcgR7skxkZ1g17AaYUY/PwPInGcD+KqiHX7ilLq/gDcMmeXCx/ezHMo3sk1eWqQyfHhORZRVnYYqcaFO7cZgg54/8SfFxDqmxkwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077516; c=relaxed/simple;
	bh=5fKqL36pzUJf0EGpeExgb4DW6diH/+332jE5ypoU5xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N02fyB3/+rBz7sK64XwK7QnjudLpdhngBsQ6b9bCBX4nVUjDH2Uj1jrf6fpSIPuNN2LFsJhRb4+aVDVLr910wE2SveWsIPxsWp6aLTDyEq9xy9Ist5ORDW22OsJxOV7ocW1WxhTlBo1nY4oKAsLrHlO/o+jeDLk0PBvo0kZoGfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iolnhRfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iolnhRfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E912BC4CEF1;
	Tue, 21 Oct 2025 20:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077516;
	bh=5fKqL36pzUJf0EGpeExgb4DW6diH/+332jE5ypoU5xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iolnhRflNY6Jt5a3tFQCyPcWFaAMM5e5C2O+oCgJz/V0MDKJh8yZ6E61Fi6V+mE6t
	 JZrcsR/1Y39MJdsB0wRCq3YHMRerdRY9HCh+L+jPlSGCTGZhrmnINUgHXs9ndlESej
	 IO+Ocvs9MqoivEd7dkhWfiK4MBW1cTBElwIYB3uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Chris Mason <clm@meta.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 128/159] blk-mq: fix stale tag depth for shared sched tags in blk_mq_update_nr_requests()
Date: Tue, 21 Oct 2025 21:51:45 +0200
Message-ID: <20251021195046.229856162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit dc96cefef0d3032c69e46a21b345c60e56b18934 ]

Commit 7f2799c546db ("blk-mq: cleanup shared tags case in
blk_mq_update_nr_requests()") moves blk_mq_tag_update_sched_shared_tags()
before q->nr_requests is updated, however, it's still using the old
q->nr_requests to resize tag depth.

Fix this problem by passing in expected new tag depth.

Fixes: 7f2799c546db ("blk-mq: cleanup shared tags case in blk_mq_update_nr_requests()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reported-by: Chris Mason <clm@meta.com>
Link: https://lore.kernel.org/linux-block/20251014130507.4187235-2-clm@meta.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 2 +-
 block/blk-mq-tag.c   | 5 +++--
 block/blk-mq.c       | 2 +-
 block/blk-mq.h       | 3 ++-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index d06bb137a7437..e0bed16485c34 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -557,7 +557,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e,
 	if (blk_mq_is_shared_tags(flags)) {
 		/* Shared tags are stored at index 0 in @et->tags. */
 		q->sched_shared_tags = et->tags[0];
-		blk_mq_tag_update_sched_shared_tags(q);
+		blk_mq_tag_update_sched_shared_tags(q, et->nr_requests);
 	}
 
 	queue_for_each_hw_ctx(q, hctx, i) {
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index aed84c5d5c2b2..12f48e7a0f774 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -622,10 +622,11 @@ void blk_mq_tag_resize_shared_tags(struct blk_mq_tag_set *set, unsigned int size
 	sbitmap_queue_resize(&tags->bitmap_tags, size - set->reserved_tags);
 }
 
-void blk_mq_tag_update_sched_shared_tags(struct request_queue *q)
+void blk_mq_tag_update_sched_shared_tags(struct request_queue *q,
+					 unsigned int nr)
 {
 	sbitmap_queue_resize(&q->sched_shared_tags->bitmap_tags,
-			     q->nr_requests - q->tag_set->reserved_tags);
+			     nr - q->tag_set->reserved_tags);
 }
 
 /**
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f8a8a23b90402..19f62b070ca9d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4942,7 +4942,7 @@ struct elevator_tags *blk_mq_update_nr_requests(struct request_queue *q,
 		 * tags can't grow, see blk_mq_alloc_sched_tags().
 		 */
 		if (q->elevator)
-			blk_mq_tag_update_sched_shared_tags(q);
+			blk_mq_tag_update_sched_shared_tags(q, nr);
 		else
 			blk_mq_tag_resize_shared_tags(set, nr);
 	} else if (!q->elevator) {
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 6c9d03625ba12..2fdc8eeb40040 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -188,7 +188,8 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 		struct blk_mq_tags **tags, unsigned int depth);
 void blk_mq_tag_resize_shared_tags(struct blk_mq_tag_set *set,
 		unsigned int size);
-void blk_mq_tag_update_sched_shared_tags(struct request_queue *q);
+void blk_mq_tag_update_sched_shared_tags(struct request_queue *q,
+					 unsigned int nr);
 
 void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool);
 void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_tag_iter_fn *fn,
-- 
2.51.0



