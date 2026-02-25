Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6BF1D5141;
	Wed, 25 Feb 2026 01:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983728; cv=none; b=Jr5PThvQIdcfPTMLrNvoZk/nN6XYSzW/eP+pFTB9zIe7YAZRyyXv/hKOi23mQm0hR7VHrpki3xqZd9debPkAAFlzTXf/9Q1yj5p37GiHxx6+xPj0Howx398eIDTycvaQjAlXOOD0uV2qdRT6+2D4dgxiRHUj9R/wYXuy9IL1B8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983728; c=relaxed/simple;
	bh=uJdgWmdxVoqHdmXpEC/RHRkoyFW85DEgtZ+XfqfWRGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCnApGzdK5jfsrEgilBblPn6wfjNcLO1LUS4Y1/FKb5A/W5cOGzgyKkzW20xGLOMLworUZBGAs4Eftz9HP44jIGLfi32MrpvqdjJG63GFimxeGYCAUptYXTT0+05C/r870x7DvMDSOSF5TYgHA7X85dBdK/QSAUoUWGPlqQd0ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9gdsD0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9gdsD0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD9BC116D0;
	Wed, 25 Feb 2026 01:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983728;
	bh=uJdgWmdxVoqHdmXpEC/RHRkoyFW85DEgtZ+XfqfWRGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9gdsD0AOevtXjEV3w9mFsBMXqeNxs25VIAnBDKqYgzmU3P7emgQTV1QibJo5tWaD
	 VoRI8vvnarz1SXC1COV5azAASqXWTjRO/L4qfLYhFk0pm+OkujQY+gCEvsBoh03khg
	 6a1GCUUEvtAxzzaF6mrUfwT0wSMPgzihNifnwBvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/641] btrfs: make sure all btrfs_bio::end_io are called in task context
Date: Tue, 24 Feb 2026 17:15:50 -0800
Message-ID: <20260225012349.565373155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 4591c3ef751d861d7dd95ff4d2aadb1b5e95854e ]

[BACKGROUND]
Btrfs has a lot of different bi_end_io functions, to handle different
raid profiles. But they introduced a lot of different contexts for
btrfs_bio::end_io() calls:

- Simple read bios
  Run in task context, backed by either endio_meta_workers or
  endio_workers.

- Simple write bios
  Run in IRQ context.

- RAID56 write or rebuild bios
  Run in task context, backed by rmw_workers.

- Mirrored write bios
  Run in irq context.

This is inconsistent, and contributes to the number of workqueues used
in btrfs.

[ENHANCEMENT]
Make all the above bios call their btrfs_bio::end_io() in task context,
backed by either endio_meta_workers for metadata, or endio_workers for
data.

For simple write bios, merge the handling into simple_end_io_work().

For mirrored write bios, it will be a little more complex, since both
the original or the cloned bios can run the final btrfs_bio::end_io().

Here we make sure the cloned bios are using btrfs_bioset, to reuse the
end_io_work, and run both original and cloned work inside the workqueue.

Add extra ASSERT()s to make sure btrfs_bio_end_io() is running in task
context.

This not only unifies the context for btrfs_bio::end_io() functions, but
also opens a new door for further btrfs_bio::end_io() related cleanups.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: b39b26e017c7 ("btrfs: zoned: don't zone append to conventional zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c | 64 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index b85b6b21b5450..52b8893f26f16 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -102,6 +102,9 @@ static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
 
 void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 {
+	/* Make sure we're already in task context. */
+	ASSERT(in_task());
+
 	bbio->bio.bi_status = status;
 	if (bbio->bio.bi_pool == &btrfs_clone_bioset) {
 		struct btrfs_bio *orig_bbio = bbio->private;
@@ -318,15 +321,20 @@ static struct workqueue_struct *btrfs_end_io_wq(const struct btrfs_fs_info *fs_i
 	return fs_info->endio_workers;
 }
 
-static void btrfs_end_bio_work(struct work_struct *work)
+static void simple_end_io_work(struct work_struct *work)
 {
 	struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, end_io_work);
+	struct bio *bio = &bbio->bio;
 
-	/* Metadata reads are checked and repaired by the submitter. */
-	if (is_data_bbio(bbio))
-		btrfs_check_read_bio(bbio, bbio->bio.bi_private);
-	else
-		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
+	if (bio_op(bio) == REQ_OP_READ) {
+		/* Metadata reads are checked and repaired by the submitter. */
+		if (is_data_bbio(bbio))
+			return btrfs_check_read_bio(bbio, bbio->bio.bi_private);
+		return btrfs_bio_end_io(bbio, bbio->bio.bi_status);
+	}
+	if (bio_is_zone_append(bio) && !bio->bi_status)
+		btrfs_record_physical_zoned(bbio);
+	btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 }
 
 static void btrfs_simple_end_io(struct bio *bio)
@@ -340,14 +348,8 @@ static void btrfs_simple_end_io(struct bio *bio)
 	if (bio->bi_status)
 		btrfs_log_dev_io_error(bio, dev);
 
-	if (bio_op(bio) == REQ_OP_READ) {
-		INIT_WORK(&bbio->end_io_work, btrfs_end_bio_work);
-		queue_work(btrfs_end_io_wq(fs_info, bio), &bbio->end_io_work);
-	} else {
-		if (bio_is_zone_append(bio) && !bio->bi_status)
-			btrfs_record_physical_zoned(bbio);
-		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
-	}
+	INIT_WORK(&bbio->end_io_work, simple_end_io_work);
+	queue_work(btrfs_end_io_wq(fs_info, bio), &bbio->end_io_work);
 }
 
 static void btrfs_raid56_end_io(struct bio *bio)
@@ -355,6 +357,9 @@ static void btrfs_raid56_end_io(struct bio *bio)
 	struct btrfs_io_context *bioc = bio->bi_private;
 	struct btrfs_bio *bbio = btrfs_bio(bio);
 
+	/* RAID56 endio is always handled in workqueue. */
+	ASSERT(in_task());
+
 	btrfs_bio_counter_dec(bioc->fs_info);
 	bbio->mirror_num = bioc->mirror_num;
 	if (bio_op(bio) == REQ_OP_READ && is_data_bbio(bbio))
@@ -365,11 +370,12 @@ static void btrfs_raid56_end_io(struct bio *bio)
 	btrfs_put_bioc(bioc);
 }
 
-static void btrfs_orig_write_end_io(struct bio *bio)
+static void orig_write_end_io_work(struct work_struct *work)
 {
+	struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, end_io_work);
+	struct bio *bio = &bbio->bio;
 	struct btrfs_io_stripe *stripe = bio->bi_private;
 	struct btrfs_io_context *bioc = stripe->bioc;
-	struct btrfs_bio *bbio = btrfs_bio(bio);
 
 	btrfs_bio_counter_dec(bioc->fs_info);
 
@@ -394,8 +400,18 @@ static void btrfs_orig_write_end_io(struct bio *bio)
 	btrfs_put_bioc(bioc);
 }
 
-static void btrfs_clone_write_end_io(struct bio *bio)
+static void btrfs_orig_write_end_io(struct bio *bio)
+{
+	struct btrfs_bio *bbio = btrfs_bio(bio);
+
+	INIT_WORK(&bbio->end_io_work, orig_write_end_io_work);
+	queue_work(btrfs_end_io_wq(bbio->inode->root->fs_info, bio), &bbio->end_io_work);
+}
+
+static void clone_write_end_io_work(struct work_struct *work)
 {
+	struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, end_io_work);
+	struct bio *bio = &bbio->bio;
 	struct btrfs_io_stripe *stripe = bio->bi_private;
 
 	if (bio->bi_status) {
@@ -410,6 +426,14 @@ static void btrfs_clone_write_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
+static void btrfs_clone_write_end_io(struct bio *bio)
+{
+	struct btrfs_bio *bbio = btrfs_bio(bio);
+
+	INIT_WORK(&bbio->end_io_work, clone_write_end_io_work);
+	queue_work(btrfs_end_io_wq(bbio->inode->root->fs_info, bio), &bbio->end_io_work);
+}
+
 static void btrfs_submit_dev_bio(struct btrfs_device *dev, struct bio *bio)
 {
 	if (!dev || !dev->bdev ||
@@ -456,6 +480,7 @@ static void btrfs_submit_dev_bio(struct btrfs_device *dev, struct bio *bio)
 static void btrfs_submit_mirrored_bio(struct btrfs_io_context *bioc, int dev_nr)
 {
 	struct bio *orig_bio = bioc->orig_bio, *bio;
+	struct btrfs_bio *orig_bbio = btrfs_bio(orig_bio);
 
 	ASSERT(bio_op(orig_bio) != REQ_OP_READ);
 
@@ -464,8 +489,11 @@ static void btrfs_submit_mirrored_bio(struct btrfs_io_context *bioc, int dev_nr)
 		bio = orig_bio;
 		bio->bi_end_io = btrfs_orig_write_end_io;
 	} else {
-		bio = bio_alloc_clone(NULL, orig_bio, GFP_NOFS, &fs_bio_set);
+		/* We need to use endio_work to run end_io in task context. */
+		bio = bio_alloc_clone(NULL, orig_bio, GFP_NOFS, &btrfs_bioset);
 		bio_inc_remaining(orig_bio);
+		btrfs_bio_init(btrfs_bio(bio), orig_bbio->inode,
+			       orig_bbio->file_offset, NULL, NULL);
 		bio->bi_end_io = btrfs_clone_write_end_io;
 	}
 
-- 
2.51.0



