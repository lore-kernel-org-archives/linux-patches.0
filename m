Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ED215FCE9;
	Mon, 27 May 2024 19:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837830; cv=none; b=tt4vSBuVRF8sks+kIo7Q2poeyaqcLS38aq6dwW/F2uh+952PiBxuGd8GlO6fL3eaMoMBExcuYpj5LCVw96g0hE1aJy/Zm62xvBx3Nda+GiOcbEtLdenW3QTK1iucwcMeqe5Z229c1yqaG7YSwjd2fYbKveXbSrhhZn2ebLrJ5UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837830; c=relaxed/simple;
	bh=t/UcmtvIVB2maWOAFEb+FWB0x36LL7/lkds4U7BhoaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OE5LMhbio48gBF8PkQ3JQGZadXa6+iNt9RTq4n3rk4XdnsiwHsGTI3Zskx3AIgjXYagyc1LWFzPS9KpgzUmjTQMc5JNPcxI4g+X7brOtQ0rhCIm1Jj8Ht96ItYm3R/dJu6TDPpY+3i03B/ljIdvwpRCvL2Y5saPWH27R6ELCKpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpiUCWs2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpiUCWs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FC3C2BBFC;
	Mon, 27 May 2024 19:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837830;
	bh=t/UcmtvIVB2maWOAFEb+FWB0x36LL7/lkds4U7BhoaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpiUCWs2ZdL78ydkBujZrkX/vkV4D319xJxGXvjbUV1gbiIvt4z8EN8o+N8vi6khP
	 hQl2GH/AYRhnRH4ZqcXgBkRn/4RZ1ECVOR4c1jZONKZvkt44EZ6jKicNiotZUipOwv
	 h6enMshSdkNTdi9t78+RdKtFa9vvPf54Q2W6Bg0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 160/493] block: support to account io_ticks precisely
Date: Mon, 27 May 2024 20:52:42 +0200
Message-ID: <20240527185635.628552816@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 99dc422335d8b2bd4d105797241d3e715bae90e9 ]

Currently, io_ticks is accounted based on sampling, specifically
update_io_ticks() will always account io_ticks by 1 jiffies from
bdev_start_io_acct()/blk_account_io_start(), and the result can be
inaccurate, for example(HZ is 250):

Test script:
fio -filename=/dev/sda -bs=4k -rw=write -direct=1 -name=test -thinktime=4ms

Test result: util is about 90%, while the disk is really idle.

This behaviour is introduced by commit 5b18b5a73760 ("block: delete
part_round_stats and switch to less precise counting"), however, there
was a key point that is missed that this patch also improve performance
a lot:

Before the commit:
part_round_stats:
  if (part->stamp != now)
   stats |= 1;

  part_in_flight()
  -> there can be lots of task here in 1 jiffies.
  part_round_stats_single()
   __part_stat_add()
  part->stamp = now;

After the commit:
update_io_ticks:
  stamp = part->bd_stamp;
  if (time_after(now, stamp))
   if (try_cmpxchg())
    __part_stat_add()
    -> only one task can reach here in 1 jiffies.

Hence in order to account io_ticks precisely, we only need to know if
there are IO inflight at most once in one jiffies. Noted that for
rq-based device, iterating tags should not be used here because
'tags->lock' is grabbed in blk_mq_find_and_get_req(), hence
part_stat_lock_inc/dec() and part_in_flight() is used to trace inflight.
The additional overhead is quite little:

 - per cpu add/dec for each IO for rq-based device;
 - per cpu sum for each jiffies;

And it's verified by null-blk that there are no performance degration
under heavy IO pressure.

Fixes: 5b18b5a73760 ("block: delete part_round_stats and switch to less precise counting")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240509123717.3223892-2-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c  | 9 +++++----
 block/blk-merge.c | 2 ++
 block/blk-mq.c    | 4 ++++
 block/blk.h       | 1 +
 block/genhd.c     | 2 +-
 5 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 99d684085719d..923b7d91e6dc5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -976,10 +976,11 @@ void update_io_ticks(struct block_device *part, unsigned long now, bool end)
 	unsigned long stamp;
 again:
 	stamp = READ_ONCE(part->bd_stamp);
-	if (unlikely(time_after(now, stamp))) {
-		if (likely(try_cmpxchg(&part->bd_stamp, &stamp, now)))
-			__part_stat_add(part, io_ticks, end ? now - stamp : 1);
-	}
+	if (unlikely(time_after(now, stamp)) &&
+	    likely(try_cmpxchg(&part->bd_stamp, &stamp, now)) &&
+	    (end || part_in_flight(part)))
+		__part_stat_add(part, io_ticks, now - stamp);
+
 	if (part->bd_partno) {
 		part = bdev_whole(part);
 		goto again;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2d470cf2173e2..925c5eaac5815 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -779,6 +779,8 @@ static void blk_account_io_merge_request(struct request *req)
 	if (blk_do_io_stat(req)) {
 		part_stat_lock();
 		part_stat_inc(req->part, merges[op_stat_group(req_op(req))]);
+		part_stat_local_dec(req->part,
+				    in_flight[op_is_write(req_op(req))]);
 		part_stat_unlock();
 	}
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 25d2f3239eb65..f1d071810893e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -998,6 +998,8 @@ static inline void blk_account_io_done(struct request *req, u64 now)
 		update_io_ticks(req->part, jiffies, true);
 		part_stat_inc(req->part, ios[sgrp]);
 		part_stat_add(req->part, nsecs[sgrp], now - req->start_time_ns);
+		part_stat_local_dec(req->part,
+				    in_flight[op_is_write(req_op(req))]);
 		part_stat_unlock();
 	}
 }
@@ -1020,6 +1022,8 @@ static inline void blk_account_io_start(struct request *req)
 
 		part_stat_lock();
 		update_io_ticks(req->part, jiffies, false);
+		part_stat_local_inc(req->part,
+				    in_flight[op_is_write(req_op(req))]);
 		part_stat_unlock();
 	}
 }
diff --git a/block/blk.h b/block/blk.h
index 1ef920f72e0f8..1154e87a4022d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -344,6 +344,7 @@ static inline bool blk_do_io_stat(struct request *rq)
 }
 
 void update_io_ticks(struct block_device *part, unsigned long now, bool end);
+unsigned int part_in_flight(struct block_device *part);
 
 static inline void req_set_nomerge(struct request_queue *q, struct request *req)
 {
diff --git a/block/genhd.c b/block/genhd.c
index d0471f469f7d0..2e4c2521584a1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -118,7 +118,7 @@ static void part_stat_read_all(struct block_device *part,
 	}
 }
 
-static unsigned int part_in_flight(struct block_device *part)
+unsigned int part_in_flight(struct block_device *part)
 {
 	unsigned int inflight = 0;
 	int cpu;
-- 
2.43.0



