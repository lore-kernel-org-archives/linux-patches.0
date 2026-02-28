Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846C73191D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300948; cv=none; b=sX62vg+df2JashXuaGgdZQTUxad9zHPt3HGRgAjO2XMdsBA7DNq+PiUdhXfJr6A3WXJ+GE/5aAeptVPy26gZN3bHZSfzBv1N1sGundmG94jg05bSx6w8oX9sDjfEnBJ+dy5mEjcCIbCHfd9ipfWx3sFRIFAfIFacnbDivNd0Pg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300948; c=relaxed/simple;
	bh=CVqVwpqZk+YxuKM0mb9XWBs8u2jDMk4RtmFncLskw28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlN8wITvS6wLZ7mWzL/1c2kr55tOaVrgkFmh5NYBfT0AhaZNZiuaQDxRkSdC0u5Y41NmzIVBXlj/m6rSbqN1czDjJR4uZCp9VtJfVBgqJPYNfVvCKir6X7TB9xu26pWCGe5ANqlUZP0PF+CCehRKEbSUy7rGQzgxtF5MxotSyEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AX5jgGtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AX5jgGtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A8DC116D0;
	Sat, 28 Feb 2026 17:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300948;
	bh=CVqVwpqZk+YxuKM0mb9XWBs8u2jDMk4RtmFncLskw28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AX5jgGtIHI9SFyBCtltrMsOBbOeihBebRw/WA6tikKwfWEqsz0K/0v3J/QshaX80s
	 f1zUqNAhNjO6aXVZa8oCxllsUAGYUSctSfHz+DTHyPvJhwEvuJMD4HovDOlGq/ZHZo
	 m4RobiSQmdeeiuyyFSH11UifKmWbgXRiJxE6lQm7BJcPibH4wBQdjr8XcS/c+XD+87
	 GuIFPy2fQRLthAdToY7+pwDejkjLGsVO7Oe71GEHBLesx2fBHQjhmGTLFWGAeQGl8O
	 KNuKSMH+wflUYgd0nKAsZgZpk1Joojt6wbkJVypXyf50lqLiTg2GSzBePpOOIx4jdR
	 kMAkXT6Uzk24A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yu Kuai <yukuai@fnnas.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/752] blk-mq-sched: unify elevators checking for async requests
Date: Sat, 28 Feb 2026 12:36:22 -0500
Message-ID: <20260228174750.1542406-71-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit 1db61b0afdd7e8aa9289c423fdff002603b520b5 ]

bfq and mq-deadline consider sync writes as async requests and only
reserve tags for sync reads by async_depth, however, kyber doesn't
consider sync writes as async requests for now.

Consider the case there are lots of dirty pages, and user use fsync to
flush dirty pages. In this case sched_tags can be exhausted by sync writes
and sync reads can stuck waiting for tag. Hence let kyber follow what
mq-deadline and bfq did, and unify async requests checking for all
elevators.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c   | 2 +-
 block/blk-mq-sched.h  | 5 +++++
 block/kyber-iosched.c | 2 +-
 block/mq-deadline.c   | 2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 6e54b1d3d8bc2..9e9d081e86bb2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -697,7 +697,7 @@ static void bfq_limit_depth(blk_opf_t opf, struct blk_mq_alloc_data *data)
 	unsigned int limit, act_idx;
 
 	/* Sync reads have full depth available */
-	if (op_is_sync(opf) && !op_is_write(opf))
+	if (blk_mq_is_sync_read(opf))
 		limit = data->q->nr_requests;
 	else
 		limit = bfqd->async_depths[!!bfqd->wr_busy_queues][op_is_sync(opf)];
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 02c40a72e9598..5678e15bd33c4 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -137,4 +137,9 @@ static inline void blk_mq_set_min_shallow_depth(struct request_queue *q,
 						depth);
 }
 
+static inline bool blk_mq_is_sync_read(blk_opf_t opf)
+{
+	return op_is_sync(opf) && !op_is_write(opf);
+}
+
 #endif
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 18efd6ef2a2b9..e3eaeea62e24d 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -544,7 +544,7 @@ static void kyber_limit_depth(blk_opf_t opf, struct blk_mq_alloc_data *data)
 	 * We use the scheduler tags as per-hardware queue queueing tokens.
 	 * Async requests can be limited at this stage.
 	 */
-	if (!op_is_sync(opf)) {
+	if (!blk_mq_is_sync_read(opf)) {
 		struct kyber_queue_data *kqd = data->q->elevator->elevator_data;
 
 		data->shallow_depth = kqd->async_depth;
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 3e3719093aec7..29d00221fbea6 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -495,7 +495,7 @@ static void dd_limit_depth(blk_opf_t opf, struct blk_mq_alloc_data *data)
 	struct deadline_data *dd = data->q->elevator->elevator_data;
 
 	/* Do not throttle synchronous reads. */
-	if (op_is_sync(opf) && !op_is_write(opf))
+	if (blk_mq_is_sync_read(opf))
 		return;
 
 	/*
-- 
2.51.0

