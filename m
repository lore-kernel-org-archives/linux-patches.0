Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EE23148D4;
	Mon, 13 Oct 2025 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369213; cv=none; b=grPYvOzm2mjItFLD+UGTz6WYDmvnxZj1+6pltbMfRO9m0Li/rgKvor1WT8jt36kxKxKBjdmNIENiGhVCpjvM2xVAv6T7Ijpxvd/AXSDTNCM910UVdX2gqS0D2ShBOpEOrVPtoodKmoS5D2G3yjUz6RoRQbE/zfsZt9ETYXTBqXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369213; c=relaxed/simple;
	bh=pe/gq6GXn55t6uAHoAsCnKjz8M02ynqRYTmG/2qLYPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnXUdrvMqEGwyW6bQbmH8raFpWkq3lDAxqaqGFemXaTZzBcopywl6Uw347uaJ12zuED/mlRq7vllVSqnLe0rwXoyzPPH+4e15CxBx24GvIJazhhlreXV6LYAW2mippLniIQJfhva6ioo15rFtFK+7OChoohjxtzxH4f14gPbze8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFYkLCwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFYkLCwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600F0C4CEE7;
	Mon, 13 Oct 2025 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369212;
	bh=pe/gq6GXn55t6uAHoAsCnKjz8M02ynqRYTmG/2qLYPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFYkLCwYmVyNv3giVXXZCLwcA0/bVQCmONnHzxY3Qxb+SPvRox8LvLcBnOJQ51jeu
	 aCCVvXqwpz449KRc5gSCGxfu8KxKNaPMvrQCzOSYvARKqqDrcRFrCfpo0B0whGoFDy
	 s2w9JmXnDKm1ztOgQX6Bmhs6HlllTnFwIiHFZ5eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tie Ren <tieren@fnnas.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 124/563] block: fix ordering of recursive split IO
Date: Mon, 13 Oct 2025 16:39:45 +0200
Message-ID: <20251013144415.785974566@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

[ Upstream commit b2f5974079d82a4761f002e80601064d4e39a81f ]

Currently, split bio will be chained to original bio, and original bio
will be resubmitted to the tail of current->bio_list, waiting for
split bio to be issued. However, if split bio get split again, the IO
order will be messed up. This problem, on the one hand, will cause
performance degradation, especially for mdraid with large IO size; on
the other hand, will cause write errors for zoned block devices[1].

For example, in raid456 IO will first be split by max_sector from
md_submit_bio(), and then later be split again by chunksize for internal
handling:

For example, assume max_sectors is 1M, and chunksize is 512k

1) issue a 2M IO:

bio issuing: 0+2M
current->bio_list: NULL

2) md_submit_bio() split by max_sector:

bio issuing: 0+1M
current->bio_list: 1M+1M

3) chunk_aligned_read() split by chunksize:

bio issuing: 0+512k
current->bio_list: 1M+1M -> 512k+512k

4) after first bio issued, __submit_bio_noacct() will contuine issuing
next bio:

bio issuing: 1M+1M
current->bio_list: 512k+512k
bio issued: 0+512k

5) chunk_aligned_read() split by chunksize:

bio issuing: 1M+512k
current->bio_list: 512k+512k -> 1536k+512k
bio issued: 0+512k

6) no split afterwards, finally the issue order is:

0+512k -> 1M+512k -> 512k+512k -> 1536k+512k

This behaviour will cause large IO read on raid456 endup to be small
discontinuous IO in underlying disks. Fix this problem by placing split
bio to the head of current->bio_list.

Test script: test on 8 disk raid5 with 64k chunksize
dd if=/dev/md0 of=/dev/null bs=4480k iflag=direct

Test results:
Before this patch
1) iostat results:
Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz  aqu-sz  %util
md0           52430.00   3276.87     0.00   0.00    0.62    64.00   32.60  80.10
sd*           4487.00    409.00  2054.00  31.40    0.82    93.34    3.68  71.20
2) blktrace G stage:
  8,0    0   486445    11.357392936   843  G   R 14071424 + 128 [dd]
  8,0    0   486451    11.357466360   843  G   R 14071168 + 128 [dd]
  8,0    0   486454    11.357515868   843  G   R 14071296 + 128 [dd]
  8,0    0   486468    11.357968099   843  G   R 14072192 + 128 [dd]
  8,0    0   486474    11.358031320   843  G   R 14071936 + 128 [dd]
  8,0    0   486480    11.358096298   843  G   R 14071552 + 128 [dd]
  8,0    0   486490    11.358303858   843  G   R 14071808 + 128 [dd]
3) io seek for sdx:
Noted io seek is the result from blktrace D stage, statistic of:
ABS((offset of next IO) - (offset + len of previous IO))

Read|Write seek
cnt 55175, zero cnt 25079
    >=(KB) .. <(KB)     : count       ratio |distribution                            |
         0 .. 1         : 25079       45.5% |########################################|
         1 .. 2         : 0            0.0% |                                        |
         2 .. 4         : 0            0.0% |                                        |
         4 .. 8         : 0            0.0% |                                        |
         8 .. 16        : 0            0.0% |                                        |
        16 .. 32        : 0            0.0% |                                        |
        32 .. 64        : 12540       22.7% |#####################                   |
        64 .. 128       : 2508         4.5% |#####                                   |
       128 .. 256       : 0            0.0% |                                        |
       256 .. 512       : 10032       18.2% |#################                       |
       512 .. 1024      : 5016         9.1% |#########                               |

After this patch:
1) iostat results:
Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz  aqu-sz  %util
md0           87965.00   5271.88     0.00   0.00    0.16    61.37   14.03  90.60
sd*           6020.00    658.44  5117.00  45.95    0.44   112.00    2.68  86.50
2) blktrace G stage:
  8,0    0   206296     5.354894072   664  G   R 7156992 + 128 [dd]
  8,0    0   206305     5.355018179   664  G   R 7157248 + 128 [dd]
  8,0    0   206316     5.355204438   664  G   R 7157504 + 128 [dd]
  8,0    0   206319     5.355241048   664  G   R 7157760 + 128 [dd]
  8,0    0   206333     5.355500923   664  G   R 7158016 + 128 [dd]
  8,0    0   206344     5.355837806   664  G   R 7158272 + 128 [dd]
  8,0    0   206353     5.355960395   664  G   R 7158528 + 128 [dd]
  8,0    0   206357     5.356020772   664  G   R 7158784 + 128 [dd]
3) io seek for sdx
Read|Write seek
cnt 28644, zero cnt 21483
    >=(KB) .. <(KB)     : count       ratio |distribution                            |
         0 .. 1         : 21483       75.0% |########################################|
         1 .. 2         : 0            0.0% |                                        |
         2 .. 4         : 0            0.0% |                                        |
         4 .. 8         : 0            0.0% |                                        |
         8 .. 16        : 0            0.0% |                                        |
        16 .. 32        : 0            0.0% |                                        |
        32 .. 64        : 7161        25.0% |##############                          |

BTW, this looks like a long term problem from day one, and large
sequential IO read is pretty common case like video playing.

And even with this patch, in this test case IO is merged to at most 128k
is due to block layer plug limit BLK_PLUG_FLUSH_SIZE, increase such
limit can get even better performance. However, we'll figure out how to do
this properly later.

[1] https://lore.kernel.org/all/e40b076d-583d-406b-b223-005910a9f46f@acm.org/

Fixes: d89d87965dcb ("When stacked block devices are in-use (e.g. md or dm), the recursive calls")
Reported-by: Tie Ren <tieren@fnnas.com>
Closes: https://lore.kernel.org/all/7dro5o7u5t64d6bgiansesjavxcuvkq5p2pok7dtwkav7b7ape@3isfr44b6352/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c     | 16 ++++++++++------
 block/blk-merge.c    |  2 +-
 block/blk-throttle.c |  2 +-
 block/blk.h          |  2 +-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 03a5d4c9cbf72..14ae73eebe0d7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -727,7 +727,7 @@ static void __submit_bio_noacct_mq(struct bio *bio)
 	current->bio_list = NULL;
 }
 
-void submit_bio_noacct_nocheck(struct bio *bio)
+void submit_bio_noacct_nocheck(struct bio *bio, bool split)
 {
 	blk_cgroup_bio_start(bio);
 
@@ -746,12 +746,16 @@ void submit_bio_noacct_nocheck(struct bio *bio)
 	 * to collect a list of requests submited by a ->submit_bio method while
 	 * it is active, and then process them after it returned.
 	 */
-	if (current->bio_list)
-		bio_list_add(&current->bio_list[0], bio);
-	else if (!bdev_test_flag(bio->bi_bdev, BD_HAS_SUBMIT_BIO))
+	if (current->bio_list) {
+		if (split)
+			bio_list_add_head(&current->bio_list[0], bio);
+		else
+			bio_list_add(&current->bio_list[0], bio);
+	} else if (!bdev_test_flag(bio->bi_bdev, BD_HAS_SUBMIT_BIO)) {
 		__submit_bio_noacct_mq(bio);
-	else
+	} else {
 		__submit_bio_noacct(bio);
+	}
 }
 
 static blk_status_t blk_validate_atomic_write_op_size(struct request_queue *q,
@@ -872,7 +876,7 @@ void submit_bio_noacct(struct bio *bio)
 
 	if (blk_throtl_bio(bio))
 		return;
-	submit_bio_noacct_nocheck(bio);
+	submit_bio_noacct_nocheck(bio, false);
 	return;
 
 not_supported:
diff --git a/block/blk-merge.c b/block/blk-merge.c
index c411045fcf03a..77488f11a9441 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -134,7 +134,7 @@ struct bio *bio_submit_split_bioset(struct bio *bio, unsigned int split_sectors,
 	if (should_fail_bio(bio))
 		bio_io_error(bio);
 	else if (!blk_throtl_bio(bio))
-		submit_bio_noacct_nocheck(bio);
+		submit_bio_noacct_nocheck(bio, true);
 
 	return split;
 }
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index cfa1cd60d2c5f..f510ae072868c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1224,7 +1224,7 @@ static void blk_throtl_dispatch_work_fn(struct work_struct *work)
 	if (!bio_list_empty(&bio_list_on_stack)) {
 		blk_start_plug(&plug);
 		while ((bio = bio_list_pop(&bio_list_on_stack)))
-			submit_bio_noacct_nocheck(bio);
+			submit_bio_noacct_nocheck(bio, false);
 		blk_finish_plug(&plug);
 	}
 }
diff --git a/block/blk.h b/block/blk.h
index 18cc3c2afdd4d..d9efc8693aa48 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -54,7 +54,7 @@ bool blk_queue_start_drain(struct request_queue *q);
 bool __blk_freeze_queue_start(struct request_queue *q,
 			      struct task_struct *owner);
 int __bio_queue_enter(struct request_queue *q, struct bio *bio);
-void submit_bio_noacct_nocheck(struct bio *bio);
+void submit_bio_noacct_nocheck(struct bio *bio, bool split);
 void bio_await_chain(struct bio *bio);
 
 static inline bool blk_try_enter_queue(struct request_queue *q, bool pm)
-- 
2.51.0



