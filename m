Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045250;
	b=H0JMm82RRld1wdpOjFoVjywi4HtJH/35qEfqCcFWl83PKovZapd0njfy7HiqsUBcV8En
	 kVHw3v+8gIuu7qP883irmpZf15Bx+NAXXD+DjiOikJAEF5fFjjcFQTpCXjIVq5ze0eSj6
	 /cWK3e1rIBufolphtLNWheaZ03fpoJSDl7aoKTmA1OteWp6TGHW7XQGVTWeXjUpHaHgim
	 wUkuvkfJAoec4NC/z30fnxVJBTesRUDcqJYZAJFZJtRMeEwZvc1s38TxjlwBZl0GXxl7R
	 AS3Wx8TPKr+QmGRuoG0FFrWxqGFhGXUBFYMr3ulKusEA97dN7jDFdoE99o33pfRbDVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eqlrrThmzJyJQ6hr+7WsCm+58HW+cwWYxIftGX3tlps=;
	b=10EFMWy5xEGtiIp/BjpRC9rQ1SyQO2q4EQepIxyfnFXWcn8mNdcoK7wdImlBtCFqAAdv
	 H4IvXtlzkf+PHyZYKLrD4zgzG7jC/s6G/sD3Voh1yh3kX/1AngVhy3g6A2jpA4l9PrPR2
	 E3YY784rF3VGK6dISxH9+ZeiyetfM+uGtplolw0Aoxvn+9OirvReytjPKEDsFN6C6gPXK
	 oPfHrI4WYpA3UnZWlBYyCBYnnYT6HvYy027z1+7KI8kCMg0byGNrfoZcmAuYNZwGd34J/
	 01BYb0Ps1i1I9tazBOMU6TbLJcMxCEIzzPSPdTGgjdvpQ99AWRzL9LdqHom8ChSOJDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RD2eHjBm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F005606A32C;
	Wed, 18 Nov 2026 23:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RD2eHjBm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3541F000C4;
	Wed, 18 Nov 2026 23:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045250;
	bh=eqlrrThmzJyJQ6hr+7WsCm+58HW+cwWYxIftGX3tlps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RD2eHjBmn8HUxfJ1vtkB40lZ4Jkq30faEQzEpCWXmMx6v0U0EF8HhRXFVu+Iy6t9a
	 g++GlowcHurDbzTy7FmT6bEi79btzImRbjFhCJz/eUxj7n80BjiZO/5vJNUG5Y295r
	 X9p9vV6Dup7vdVraCsiGceiHXFhTkKyXBfc6YuZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0856/2857] dm-writecache: fix REQ_FUA processing
Date: Wed, 18 Nov 2026 15:31:30 +0100
Message-ID: <20261118150232.388832480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 21b16a3c6945f..8ef49cde630b2 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -195,6 +195,7 @@ struct dm_writecache {
 	struct task_struct *endio_thread;
 
 	struct task_struct *flush_thread;
+	spinlock_t flush_list_lock;
 	struct bio_list flush_list;
 
 	struct dm_kcopyd_client *dm_kcopyd;
@@ -1287,9 +1288,11 @@ static int writecache_flush_thread(void *data)
 		struct bio *bio;
 
 		wc_lock(wc);
+		spin_lock_irq(&wc->flush_list_lock);
 		bio = bio_list_pop(&wc->flush_list);
 		if (!bio) {
 			set_current_state(TASK_INTERRUPTIBLE);
+			spin_unlock_irq(&wc->flush_list_lock);
 			wc_unlock(wc);
 
 			if (unlikely(kthread_should_stop())) {
@@ -1300,6 +1303,7 @@ static int writecache_flush_thread(void *data)
 			schedule();
 			continue;
 		}
+		spin_unlock_irq(&wc->flush_list_lock);
 
 		if (bio_op(bio) == REQ_OP_DISCARD) {
 			writecache_discard(wc, bio->bi_iter.bi_sector,
@@ -1321,9 +1325,12 @@ static int writecache_flush_thread(void *data)
 
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
@@ -1435,6 +1442,8 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio *bio)
 {
 	struct wc_entry *e;
+	enum wc_map_op ret = WC_MAP_SUBMIT;
+	bool need_flush = false;
 
 	do {
 		bool found_entry = false;
@@ -1471,7 +1480,8 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 				writecache_map_remap_origin(wc, bio, e);
 				wc->stats.writes_around += bio->bi_iter.bi_size >> wc->block_size_bits;
 				wc->stats.writes += bio->bi_iter.bi_size >> wc->block_size_bits;
-				return WC_MAP_REMAP_ORIGIN;
+				ret = WC_MAP_REMAP_ORIGIN;
+				goto flush_pmem_and_ret;
 			}
 			wc->stats.writes_blocked_on_freelist++;
 			writecache_wait_on_freelist(wc);
@@ -1485,21 +1495,25 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
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
@@ -1589,7 +1603,10 @@ static int writecache_map(struct dm_target *ti, struct bio *bio)
 
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
@@ -1619,12 +1636,19 @@ static int writecache_end_io(struct dm_target *ti, struct bio *bio, blk_status_t
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
@@ -2526,6 +2550,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 		wc->memory_map_size -= (uint64_t)wc->start_sector << SECTOR_SHIFT;
 
+		spin_lock_init(&wc->flush_list_lock);
 		bio_list_init(&wc->flush_list);
 		wc->flush_thread = kthread_run(writecache_flush_thread, wc, "dm_writecache_flush");
 		if (IS_ERR(wc->flush_thread)) {
-- 
2.53.0



