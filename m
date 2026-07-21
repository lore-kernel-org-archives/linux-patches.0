Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CC8388E40;
	Tue, 21 Jul 2026 19:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660878; cv=none; b=lj0Ah9daf+KfhzMaYiczbEpEbSagtMQSnnRQLyLUBnVzXomvdVfq23hAHRHK5Dq2xWgjaxQID23H5If52jl9Fh39BoAHeOtO7FOtHHGtXYWHg/2FcKaXBsVu02hNUlwa/b/Za0/25VULBkzuZZ/VEPACPOai6JCEpvdNGghwhF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660878; c=relaxed/simple;
	bh=4dXwCqu/I2y3/ken2NoRLD44/VlsZxtzOhkLBmTtLPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koElCBALLaRIyWuSg5xreuQav1tJUK8i6eF1LXg9EFJfZDOjQ9RfmIaas8asZV4Xiaetdepjy4PImHJmTeQCFWV9oMuJmM93KVqgTpcH56M+od4dg8jsMiXMi+4i/cSpQSDA5BeGxD/Eh8BHJuydwcI56Dphw9hmkvCfN8AsBCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsbjX7R5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsbjX7R5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0362E1F000E9;
	Tue, 21 Jul 2026 19:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660877;
	bh=V2qSRv5giMEbC1aVGJHXB8G6bP4tAdt1HHsO6fLOm5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsbjX7R5PjGpCWcUL6aycspoG+GDzD0NA7BZ9NnJ0Ey/2H3F+SaUuSO79spapPYEC
	 YWVFl4cDy5xWwWqc+cY+dxukn1avv2q3fooIcapdmFn/YgaXE2b0YecfjWCfehd8J7
	 u3tIl5j+ua5kllIuuHADFZ0fSb6dcAWwPzO7BzLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1144/2077] md/raid1: honor REQ_NOWAIT when waiting for behind writes
Date: Tue, 21 Jul 2026 17:13:37 +0200
Message-ID: <20260721152619.804983718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit a286cb88ddb26c5f4377859d8e77233d9181eb82 ]

raid1 supports REQ_NOWAIT reads by avoiding waits in the barrier path
through wait_read_barrier(). However, a read can still block on a
WriteMostly device when the array uses a bitmap and there are
outstanding behind writes.

In that case raid1 unconditionally calls wait_behind_writes(), which
may sleep until all behind writes complete. As a result, a REQ_NOWAIT
read can block despite the caller explicitly requesting non-blocking
behavior.

This ensures that raid1 consistently honors REQ_NOWAIT reads across all
paths that may otherwise wait for behind writes.

Fixes: 5aa705039c4f ("md: raid1 add nowait support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260611083514.754922-1-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c   |  9 +++++++--
 drivers/md/md-bitmap.h   |  2 +-
 drivers/md/md-llbitmap.c | 13 ++++++++-----
 drivers/md/md.c          |  2 +-
 drivers/md/raid1.c       | 10 +++++++---
 5 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 028b9ca8ce52db..1206e31f323ad8 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2063,18 +2063,23 @@ static void bitmap_end_behind_write(struct mddev *mddev)
 		 bitmap->mddev->bitmap_info.max_write_behind);
 }
 
-static void bitmap_wait_behind_writes(struct mddev *mddev)
+static bool bitmap_wait_behind_writes(struct mddev *mddev, bool nowait)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
 	/* wait for behind writes to complete */
 	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
+		if (nowait)
+			return false;
+
 		pr_debug("md:%s: behind writes in progress - waiting to stop.\n",
 			 mdname(mddev));
 		/* need to kick something here to make sure I/O goes? */
 		wait_event(bitmap->behind_wait,
 			   atomic_read(&bitmap->behind_writes) == 0);
 	}
+
+	return true;
 }
 
 static void bitmap_destroy(struct mddev *mddev)
@@ -2084,7 +2089,7 @@ static void bitmap_destroy(struct mddev *mddev)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
-	bitmap_wait_behind_writes(mddev);
+	bitmap_wait_behind_writes(mddev, false);
 	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		mddev_destroy_serial_pool(mddev, NULL);
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 214f623c7e790b..f46674bdfeb918 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -98,7 +98,7 @@ struct bitmap_operations {
 
 	void (*start_behind_write)(struct mddev *mddev);
 	void (*end_behind_write)(struct mddev *mddev);
-	void (*wait_behind_writes)(struct mddev *mddev);
+	bool (*wait_behind_writes)(struct mddev *mddev, bool nowait);
 
 	md_bitmap_fn *start_write;
 	md_bitmap_fn *end_write;
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1adc5b11782164..5a4e2abaa75770 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1574,16 +1574,19 @@ static void llbitmap_end_behind_write(struct mddev *mddev)
 		wake_up(&llbitmap->behind_wait);
 }
 
-static void llbitmap_wait_behind_writes(struct mddev *mddev)
+static bool llbitmap_wait_behind_writes(struct mddev *mddev, bool nowait)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
 
-	if (!llbitmap)
-		return;
+	if (llbitmap && atomic_read(&llbitmap->behind_writes) > 0) {
+		if (nowait)
+			return false;
 
-	wait_event(llbitmap->behind_wait,
-		   atomic_read(&llbitmap->behind_writes) == 0);
+		wait_event(llbitmap->behind_wait,
+			   atomic_read(&llbitmap->behind_writes) == 0);
+	}
 
+	return true;
 }
 
 static ssize_t bits_show(struct mddev *mddev, char *page)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 518d1d9c22031f..6d1ddbdbbf8d29 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7049,7 +7049,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 static void mddev_detach(struct mddev *mddev)
 {
 	if (md_bitmap_enabled(mddev, false))
-		mddev->bitmap_ops->wait_behind_writes(mddev);
+		mddev->bitmap_ops->wait_behind_writes(mddev, false);
 	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index eb72dd31380ab3..9a3df3cb7bdfe8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1341,6 +1341,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	int max_sectors;
 	int rdisk;
 	bool r1bio_existed = !!r1_bio;
+	bool nowait = bio->bi_opf & REQ_NOWAIT;
 
 	/*
 	 * An md cloned bio indicates we are in the error path.
@@ -1360,8 +1361,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 * Still need barrier for READ in case that whole
 	 * array is frozen.
 	 */
-	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
-				bio->bi_opf & REQ_NOWAIT)) {
+	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
 		bio_wouldblock_error(bio);
 		return;
 	}
@@ -1402,7 +1402,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		 * over-take any writes that are 'behind'
 		 */
 		mddev_add_trace_msg(mddev, "raid1 wait behind writes");
-		mddev->bitmap_ops->wait_behind_writes(mddev);
+		if (!mddev->bitmap_ops->wait_behind_writes(mddev, nowait)) {
+			bio_wouldblock_error(bio);
+			set_bit(R1BIO_Returned, &r1_bio->state);
+			goto err_handle;
+		}
 	}
 
 	if (max_sectors < bio_sectors(bio)) {
-- 
2.53.0



