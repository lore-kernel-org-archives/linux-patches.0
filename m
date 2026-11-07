Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063080;
	b=b0EzOiZmXHL6KHzK3mOSCYhH/jT+iiFDsxtI6gNK2WzgJC/NjTRuMWEPz2YIph//HyN0
	 IoFhe+m7LJhuGvfgFwWlAstfU0qbiDrPxrwQX3T1wNa7Z1GJSM+QSmhH2mpkPxl/HsHKq
	 Nci88PLwjtGRrYylWyf9SDWoyFTlNxneMsVIkQYVROINrWxDBd0GDTwSmF2F3dzn3mTfb
	 1O/KlNg3eG0g9OdIlPmb7/nkdqlX95AXmSnV9Kks8mbtpwWaZ2xg3N/6n2H7Zen/DYwhN
	 LqPgD9iZFDBT1EALAMzfmnPnYutNtjb6juLLaqQh5pLbQaA7drZGNSQdLhTUFxWWTDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dYuodXA7SeHPYscWnEw17+LP8xEp4vJk/0LEFDLe/uo=;
	b=toC3epND82u2CkTFBJ+51mjsm8vYeBgbNkZyDjkp238T057zKaSD4AkajDrTrxO8zVZw
	 yn5wk5VEeJspkEo5BgmJbFj9zqDADifZ9Z6aVO9P2Q7oUVuU3St/nYkGGGAExqNJO8rVo
	 8VhU2kmNrZPsrzg44q522vWSNMTPIZeh6HlZLIssbzUVbhMZX9Kmcn0zlLWXyjftH279d
	 VP+spYMfSHKYzJs59qxXjThi+PhUt8hSzYeHmJpPeJ7p3XlVNZ0XAZofSWaFInGH70gyw
	 eXqZjEJnXTFn0jZgeMqYCzxEGpofevLMplZ22/mqQ5YZaBTOECnUAlrFjjvSTetcUDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=piUoOmr3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2D2606EE87;
	Sat,  7 Nov 2026 14:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=piUoOmr3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6AE1F0089F;
	Sat,  7 Nov 2026 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063080;
	bh=dYuodXA7SeHPYscWnEw17+LP8xEp4vJk/0LEFDLe/uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=piUoOmr3tPm1OvUTZQCwv2+BYejuOUiJ/y3y2HLURjMQoYSimxfRFff9F+nOsc6Ru
	 nR5zddkkCa5z1WpYPq887sAWaMbd8x68Jq/PPF0vgCHhwQqhfZ6EkA+1d+tIN+ZXQ/
	 Pb5vYFqu/poPOpl4uGqXN6j+Eu6gI02QVwKk0LhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 320/869] dm-writecache: fix REQ_FUA processing
Date: Sat,  7 Nov 2026 08:50:02 -0500
Message-ID: <20261107134903.326056650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit c0df022cb0fa2bbee74bd9b90c66790bcd4e3050 ]

REQ_FUA did not flush metadata in SSD mode, this commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: c1005322ff02 ("dm writecache: handle REQ_FUA")
Assisted-by: Claude:claude-opus-5
Assisted-by: Codex:gpt-6-sol
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 45 +++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 63e18c6f1325f..aa758d5ef6013 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -194,6 +194,7 @@ struct dm_writecache {
 	struct task_struct *endio_thread;
 
 	struct task_struct *flush_thread;
+	spinlock_t flush_list_lock;
 	struct bio_list flush_list;
 
 	struct dm_kcopyd_client *dm_kcopyd;
@@ -1288,9 +1289,11 @@ static int writecache_flush_thread(void *data)
 		struct bio *bio;
 
 		wc_lock(wc);
+		spin_lock_irq(&wc->flush_list_lock);
 		bio = bio_list_pop(&wc->flush_list);
 		if (!bio) {
 			set_current_state(TASK_INTERRUPTIBLE);
+			spin_unlock_irq(&wc->flush_list_lock);
 			wc_unlock(wc);
 
 			if (unlikely(kthread_should_stop())) {
@@ -1301,6 +1304,7 @@ static int writecache_flush_thread(void *data)
 			schedule();
 			continue;
 		}
+		spin_unlock_irq(&wc->flush_list_lock);
 
 		if (bio_op(bio) == REQ_OP_DISCARD) {
 			writecache_discard(wc, bio->bi_iter.bi_sector,
@@ -1322,9 +1326,12 @@ static int writecache_flush_thread(void *data)
 
 static void writecache_offload_bio(struct dm_writecache *wc, struct bio *bio)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&wc->flush_list_lock, flags);
 	if (bio_list_empty(&wc->flush_list))
 		wake_up_process(wc->flush_thread);
 	bio_list_add(&wc->flush_list, bio);
+	spin_unlock_irqrestore(&wc->flush_list_lock, flags);
 }
 
 enum wc_map_op {
@@ -1436,6 +1443,8 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio *bio)
 {
 	struct wc_entry *e;
+	enum wc_map_op ret = WC_MAP_SUBMIT;
+	bool need_flush = false;
 
 	do {
 		bool found_entry = false;
@@ -1472,7 +1481,8 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 				writecache_map_remap_origin(wc, bio, e);
 				wc->stats.writes_around += bio->bi_iter.bi_size >> wc->block_size_bits;
 				wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
-				return WC_MAP_REMAP_ORIGIN;
+				ret = WC_MAP_REMAP_ORIGIN;
+				goto flush_pmem_and_ret;
 			}
 			wc->stats.writes_blocked_on_freelist++;
 			writecache_wait_on_freelist(wc);
@@ -1486,21 +1496,25 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 		if (WC_MODE_PMEM(wc)) {
 			bio_copy_block(wc, bio, memory_data(wc, e));
 			wc->stats.writes++;
+			need_flush = true;
 		} else {
 			writecache_bio_copy_ssd(wc, bio, e, search_used);
 			return WC_MAP_REMAP;
 		}
 	} while (bio->bi_iter.bi_size);
 
-	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks)) {
-		writecache_flush(wc);
-		if (writecache_has_error(wc))
-			bio->bi_status = BLK_STS_IOERR;
-	} else {
-		writecache_schedule_autocommit(wc);
+flush_pmem_and_ret:
+	if (need_flush) {
+		if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks)) {
+			writecache_flush(wc);
+			if (writecache_has_error(wc))
+				ret = WC_MAP_ERROR;
+		} else {
+			writecache_schedule_autocommit(wc);
+		}
 	}
 
-	return WC_MAP_SUBMIT;
+	return ret;
 }
 
 static enum wc_map_op writecache_map_flush(struct dm_writecache *wc, struct bio *bio)
@@ -1590,7 +1604,10 @@ static int writecache_map(struct dm_target *ti, struct bio *bio)
 
 	case WC_MAP_REMAP:
 		/* make sure that writecache_end_io decrements bio_in_progress: */
-		bio->bi_private = (void *)1;
+		if (unlikely(bio->bi_opf & REQ_FUA) && bio_op(bio) == REQ_OP_WRITE)
+			bio->bi_private = (void *)3;
+		else
+			bio->bi_private = (void *)1;
 		atomic_inc(&wc->bio_in_progress[bio_data_dir(bio)]);
 		wc_unlock(wc);
 		return DM_MAPIO_REMAPPED;
@@ -1620,12 +1637,19 @@ static int writecache_end_io(struct dm_target *ti, struct bio *bio, blk_status_t
 {
 	struct dm_writecache *wc = ti->private;
 
-	if (bio->bi_private == (void *)1) {
+	if (bio->bi_private == (void *)1 || bio->bi_private == (void *)3) {
 		int dir = bio_data_dir(bio);
+		bool fua = bio->bi_private == (void *)3;
 
 		if (atomic_dec_and_test(&wc->bio_in_progress[dir]))
 			if (unlikely(waitqueue_active(&wc->bio_in_progress_wait[dir])))
 				wake_up(&wc->bio_in_progress_wait[dir]);
+
+		if (fua && likely(*status == BLK_STS_OK)) {
+			bio->bi_private = NULL;
+			writecache_offload_bio(wc, bio);
+			return DM_ENDIO_INCOMPLETE;
+		}
 	} else if (bio->bi_private == (void *)2) {
 		dm_iot_io_end(&wc->iot, 1);
 	}
@@ -2531,6 +2555,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 		wc->memory_map_size -= (uint64_t)wc->start_sector << SECTOR_SHIFT;
 
+		spin_lock_init(&wc->flush_list_lock);
 		bio_list_init(&wc->flush_list);
 		wc->flush_thread = kthread_run(writecache_flush_thread, wc, "dm_writecache_flush");
 		if (IS_ERR(wc->flush_thread)) {
-- 
2.53.0



