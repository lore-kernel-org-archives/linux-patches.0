Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82951DED47;
	Wed,  6 Nov 2024 12:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896283; cv=none; b=n6ne+/0ULKJghgeA3vY07GjWukmGawniGJDt+K555F68KwNsaRuo9dsO5iKm5nCUSa/mWmOuSPctG6zKUudiRoxRyaFp+Ye6HWzlyXnCXG8kbSQ3TobT+xVpLgtSFnqzm6zLTIsCC5mg+i682qn4+VQkdO+fXCoPUmOM3J8Xl+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896283; c=relaxed/simple;
	bh=4DBpHa+o1MqNDrGktw+ILgn6jd9sF4+DkIfHibknDME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhkjlGdZBL6KSgDxZkqcJ0lk/J7L1DQGKnBy56XfgrE9zAvPFAjlllltZ3EGGo4KjVeATQytZzQKmGwWa7LVQmbdEnj9mjoIVStiCkRtvVpyRJkN6xrshGgU3fP+vN3ZuElVjHUTPUp+TEEHocsfhAj9ZEJxVX33/lWbpBMH2gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2O/c0IfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2O/c0IfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D7FC4CECD;
	Wed,  6 Nov 2024 12:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896283;
	bh=4DBpHa+o1MqNDrGktw+ILgn6jd9sF4+DkIfHibknDME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2O/c0IfSd294FIEPBREyOHqJw5LHOu5PLSdSIdlOGOZTm7hv+xm+6upusRtgIT/1V
	 MFuKb77Bs4pm0PPp4QS4OS197X5Q8O8cNlRbCvbORYE9xxdcIL18a4LwFOrvf9NKXo
	 z/RFGLviRV13hQFU3YfPrGc0Z2boBYq8KIHztxqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 150/245] btrfs: merge btrfs_orig_bbio_end_io() into btrfs_bio_end_io()
Date: Wed,  6 Nov 2024 13:03:23 +0100
Message-ID: <20241106120322.922753190@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 9ca0e58cb752b09816f56f7a3147a39773d5e831 ]

There are only two differences between the two functions:

- btrfs_orig_bbio_end_io() does extra error propagation
  This is mostly to allow tolerance for write errors.

- btrfs_orig_bbio_end_io() does extra pending_ios check
  This check can handle both the original bio, or the cloned one.
  (All accounting happens in the original one).

This makes btrfs_orig_bbio_end_io() a much safer call.
In fact we already had a double freeing error due to usage of
btrfs_bio_end_io() in the error path of btrfs_submit_chunk().

So just move the whole content of btrfs_orig_bbio_end_io() into
btrfs_bio_end_io().

For normal paths this brings no change, because they are already calling
btrfs_orig_bbio_end_io() in the first place.

For error paths (not only inside bio.c but also external callers), this
change will introduce extra checks, especially for external callers, as
they will error out without submitting the btrfs bio.

But considering it's already in the error path, such slower but much
safer checks are still an overall win.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: d48e1dea3931 ("btrfs: fix error propagation of split bios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index b4e31ae17cd95..e93d376796a28 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -120,12 +120,6 @@ static void __btrfs_bio_end_io(struct btrfs_bio *bbio)
 	}
 }
 
-void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
-{
-	bbio->bio.bi_status = status;
-	__btrfs_bio_end_io(bbio);
-}
-
 static void btrfs_orig_write_end_io(struct bio *bio);
 
 static void btrfs_bbio_propagate_error(struct btrfs_bio *bbio,
@@ -147,8 +141,9 @@ static void btrfs_bbio_propagate_error(struct btrfs_bio *bbio,
 	}
 }
 
-static void btrfs_orig_bbio_end_io(struct btrfs_bio *bbio)
+void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 {
+	bbio->bio.bi_status = status;
 	if (bbio->bio.bi_pool == &btrfs_clone_bioset) {
 		struct btrfs_bio *orig_bbio = bbio->private;
 
@@ -179,7 +174,7 @@ static int prev_repair_mirror(struct btrfs_failed_bio *fbio, int cur_mirror)
 static void btrfs_repair_done(struct btrfs_failed_bio *fbio)
 {
 	if (atomic_dec_and_test(&fbio->repair_count)) {
-		btrfs_orig_bbio_end_io(fbio->bbio);
+		btrfs_bio_end_io(fbio->bbio, fbio->bbio->bio.bi_status);
 		mempool_free(fbio, &btrfs_failed_bio_pool);
 	}
 }
@@ -326,7 +321,7 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
 	if (fbio)
 		btrfs_repair_done(fbio);
 	else
-		btrfs_orig_bbio_end_io(bbio);
+		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 }
 
 static void btrfs_log_dev_io_error(struct bio *bio, struct btrfs_device *dev)
@@ -360,7 +355,7 @@ static void btrfs_end_bio_work(struct work_struct *work)
 	if (is_data_bbio(bbio))
 		btrfs_check_read_bio(bbio, bbio->bio.bi_private);
 	else
-		btrfs_orig_bbio_end_io(bbio);
+		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 }
 
 static void btrfs_simple_end_io(struct bio *bio)
@@ -380,7 +375,7 @@ static void btrfs_simple_end_io(struct bio *bio)
 	} else {
 		if (bio_op(bio) == REQ_OP_ZONE_APPEND && !bio->bi_status)
 			btrfs_record_physical_zoned(bbio);
-		btrfs_orig_bbio_end_io(bbio);
+		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 	}
 }
 
@@ -394,7 +389,7 @@ static void btrfs_raid56_end_io(struct bio *bio)
 	if (bio_op(bio) == REQ_OP_READ && is_data_bbio(bbio))
 		btrfs_check_read_bio(bbio, NULL);
 	else
-		btrfs_orig_bbio_end_io(bbio);
+		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 
 	btrfs_put_bioc(bioc);
 }
@@ -424,7 +419,7 @@ static void btrfs_orig_write_end_io(struct bio *bio)
 	if (bio_op(bio) == REQ_OP_ZONE_APPEND && !bio->bi_status)
 		stripe->physical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 
-	btrfs_orig_bbio_end_io(bbio);
+	btrfs_bio_end_io(bbio, bbio->bio.bi_status);
 	btrfs_put_bioc(bioc);
 }
 
@@ -593,7 +588,7 @@ static void run_one_async_done(struct btrfs_work *work, bool do_free)
 
 	/* If an error occurred we just want to clean up the bio and move on. */
 	if (bio->bi_status) {
-		btrfs_orig_bbio_end_io(async->bbio);
+		btrfs_bio_end_io(async->bbio, async->bbio->bio.bi_status);
 		return;
 	}
 
@@ -765,11 +760,9 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		ASSERT(bbio->bio.bi_pool == &btrfs_clone_bioset);
 		ASSERT(remaining);
 
-		remaining->bio.bi_status = ret;
-		btrfs_orig_bbio_end_io(remaining);
+		btrfs_bio_end_io(remaining, ret);
 	}
-	bbio->bio.bi_status = ret;
-	btrfs_orig_bbio_end_io(bbio);
+	btrfs_bio_end_io(bbio, ret);
 	/* Do not submit another chunk */
 	return true;
 }
-- 
2.43.0



