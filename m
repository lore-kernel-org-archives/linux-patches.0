Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46FB8F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608C1C433C8;
	Sun, 16 Jul 2023 20:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539503;
	bh=j6fBRN9bWiBkfpkH7rPAm72yA90tBFIwCR6ZDEV8Pmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJnThBlQI0bPjX2Dktt+z8q+Wt9OQ+3+38lmvgDwnc3aY92/OZXLSXD+oZaFDViyf
	 Z4Mz+L0zNYB1DM00AGdW8Epsqb9zhTHRmTKALWuBh3+OkI+4U1xEg8PL9V4xX+Gagy
	 PeKm2gFf6NZSI/4u9OFoFAo9AFpMei2JAGfzB4kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/591] md/raid1-10: submit write io directly if bitmap is not enabled
Date: Sun, 16 Jul 2023 21:42:50 +0200
Message-ID: <20230716194924.684087413@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 9640741e8d369..8bbeeec70905c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -993,7 +993,6 @@ static int md_bitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
 	return set;
 }
 
-
 /* this gets called when the md device is ready to unplug its underlying
  * (slave) device queues -- before we let any writes go down, we need to
  * sync the dirty pages of the bitmap file to disk */
@@ -1003,8 +1002,7 @@ void md_bitmap_unplug(struct bitmap *bitmap)
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



