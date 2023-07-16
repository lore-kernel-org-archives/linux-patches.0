Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2478F8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C60C433C8;
	Sun, 16 Jul 2023 19:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537281;
	bh=adfKIM5CzYMTao6OdyE7sOtlXuM7bnsJE46lWd/FQYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwOlgIx3gxE7rK8Ok8MHd2pttvc8WirMAShitZMC9CX/S+w3koLwlGkTCKCTuv3PJ
	 HgcHxS4oKs4JhVIADIDaaMq76DgGY2PhcLAPvIbD76gAUJ+l9fPC6QT/urxMogG8rY
	 l8qCARJGCLCw7NXpZiBb91hQ6CV4wD1yU6Y2/aWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 040/800] md/raid1-10: submit write io directly if bitmap is not enabled
Date: Sun, 16 Jul 2023 21:38:13 +0200
Message-ID: <20230716194950.025025971@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 7db922bae3abdf0a1db81ef7228cc0b996a0c1e3 ]

Commit 6cce3b23f6f8 ("[PATCH] md: write intent bitmap support for raid10")
add bitmap support, and it changed that write io is submitted through
daemon thread because bitmap need to be updated before write io. And
later, plug is used to fix performance regression because all the write io
will go to demon thread, which means io can't be issued concurrently.

However, if bitmap is not enabled, the write io should not go to daemon
thread in the first place, and plug is not needed as well.

Fixes: 6cce3b23f6f8 ("[PATCH] md: write intent bitmap support for raid10")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230529131106.2123367-5-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c |  4 +---
 drivers/md/md-bitmap.h |  7 +++++++
 drivers/md/raid1-10.c  | 13 +++++++++++--
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 358a064959028..ea226a37b110a 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1016,7 +1016,6 @@ static int md_bitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
 	return set;
 }
 
-
 /* this gets called when the md device is ready to unplug its underlying
  * (slave) device queues -- before we let any writes go down, we need to
  * sync the dirty pages of the bitmap file to disk */
@@ -1026,8 +1025,7 @@ void md_bitmap_unplug(struct bitmap *bitmap)
 	int dirty, need_write;
 	int writing = 0;
 
-	if (!bitmap || !bitmap->storage.filemap ||
-	    test_bit(BITMAP_STALE, &bitmap->flags))
+	if (!md_bitmap_enabled(bitmap))
 		return;
 
 	/* look at each page to see if there are any set bits that need to be
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index cfd7395de8fd3..3a4750952b3a7 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -273,6 +273,13 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 			     sector_t *lo, sector_t *hi, bool clear_bits);
 void md_bitmap_free(struct bitmap *bitmap);
 void md_bitmap_wait_behind_writes(struct mddev *mddev);
+
+static inline bool md_bitmap_enabled(struct bitmap *bitmap)
+{
+	return bitmap && bitmap->storage.filemap &&
+	       !test_bit(BITMAP_STALE, &bitmap->flags);
+}
+
 #endif
 
 #endif
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 506299bd55cb6..73cc3cb9154d8 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -131,9 +131,18 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
 				      blk_plug_cb_fn unplug)
 {
 	struct raid1_plug_cb *plug = NULL;
-	struct blk_plug_cb *cb = blk_check_plugged(unplug, mddev,
-						   sizeof(*plug));
+	struct blk_plug_cb *cb;
+
+	/*
+	 * If bitmap is not enabled, it's safe to submit the io directly, and
+	 * this can get optimal performance.
+	 */
+	if (!md_bitmap_enabled(mddev->bitmap)) {
+		raid1_submit_write(bio);
+		return true;
+	}
 
+	cb = blk_check_plugged(unplug, mddev, sizeof(*plug));
 	if (!cb)
 		return false;
 
-- 
2.39.2



