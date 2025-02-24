Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15B0254855;
	Mon, 24 Feb 2025 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407983; cv=none; b=PgTRHpQIFzJsEamhICmCXeGze8NTjFSZL+WC+r6nHzs0gpmavVPZHUB4aAAC4qecrN0VqbisJXfeezI50bu3XrVPnHhojv9FrXN+erSGyJkXhrBYg7GGqoK3SUHwBMN1MNKcwH1RI2VExbN6xbkFc4Y9plI2oXszxpoHfTFkCBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407983; c=relaxed/simple;
	bh=xpGehIMNHL5StDJPfORy0/7nOfPzqPSXQNQlE33k9yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdFbXmUhuEpjZdfOCdqlOwgDwcUkQRWPOO8Zwr9n9MqVu2itsqwfk0iMOZUY1jwescGfdHMIKZoBvKyu6ssPVq+MxZ7IUwy49BJ5lG/4FY1FkSV/f2fCKOxK5eJk6LPDxBrehUDDK155sZpDc8G+DrHYHaw83ieksCsTUyBSjkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Um0NK8pW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Um0NK8pW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484C4C4CED6;
	Mon, 24 Feb 2025 14:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407982;
	bh=xpGehIMNHL5StDJPfORy0/7nOfPzqPSXQNQlE33k9yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Um0NK8pWeQY9lA7qodWOb20FjGWa1Wpu1BTf/wYnpTuShOqA+X0iXDEr96NTUa//N
	 SXzMEQpxrBHbokOesLWU8PK24j5uI9/G374VCpmdjkgLVgBQSlabm0qhrU4hQ4uNFx
	 QQwYbKpSUcfS6ZdxSCJqLkZ53pcWdVkyv0FKzfV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/140] md/md-bitmap: add sync_size into struct md_bitmap_stats
Date: Mon, 24 Feb 2025 15:33:52 +0100
Message-ID: <20250224142604.309617146@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit ec6bb299c7c3dd4ca1724d13d5f5fae3ee54fc65 ]

To avoid dereferencing bitmap directly in md-cluster to prepare
inventing a new bitmap.

BTW, also fix following checkpatch warnings:

WARNING: Deprecated use of 'kmap_atomic', prefer 'kmap_local_page' instead
WARNING: Deprecated use of 'kunmap_atomic', prefer 'kunmap_local' instead

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240826074452.1490072-7-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Stable-dep-of: 8d28d0ddb986 ("md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c  |  6 ++++++
 drivers/md/md-bitmap.h  |  1 +
 drivers/md/md-cluster.c | 34 ++++++++++++++++++++--------------
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index f7b02d87a6da7..80b0cd7b88995 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2115,10 +2115,15 @@ EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
 int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 {
 	struct bitmap_counts *counts;
+	bitmap_super_t *sb;
 
 	if (!bitmap)
 		return -ENOENT;
 
+	sb = kmap_local_page(bitmap->storage.sb_page);
+	stats->sync_size = le64_to_cpu(sb->sync_size);
+	kunmap_local(sb);
+
 	counts = &bitmap->counts;
 	stats->missing_pages = counts->missing_pages;
 	stats->pages = counts->pages;
@@ -2126,6 +2131,7 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(md_bitmap_get_stats);
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		  int chunksize, int init)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 60b86ee939081..840efd1b8a01c 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -236,6 +236,7 @@ struct bitmap {
 
 struct md_bitmap_stats {
 	unsigned long	missing_pages;
+	unsigned long	sync_size;
 	unsigned long	pages;
 	struct file	*file;
 };
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index ca4d3a8d5dd76..6a89f6b5d64f9 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1190,18 +1190,21 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
  */
 static int cluster_check_sync_size(struct mddev *mddev)
 {
-	int i, rv;
-	bitmap_super_t *sb;
-	unsigned long my_sync_size, sync_size = 0;
-	int node_num = mddev->bitmap_info.nodes;
 	int current_slot = md_cluster_ops->slot_number(mddev);
+	int node_num = mddev->bitmap_info.nodes;
 	struct bitmap *bitmap = mddev->bitmap;
-	char str[64];
 	struct dlm_lock_resource *bm_lockres;
+	struct md_bitmap_stats stats;
+	unsigned long sync_size = 0;
+	unsigned long my_sync_size;
+	char str[64];
+	int i, rv;
 
-	sb = kmap_atomic(bitmap->storage.sb_page);
-	my_sync_size = le64_to_cpu(sb->sync_size);
-	kunmap_atomic(sb);
+	rv = md_bitmap_get_stats(bitmap, &stats);
+	if (rv)
+		return rv;
+
+	my_sync_size = stats.sync_size;
 
 	for (i = 0; i < node_num; i++) {
 		if (i == current_slot)
@@ -1230,15 +1233,18 @@ static int cluster_check_sync_size(struct mddev *mddev)
 			md_bitmap_update_sb(bitmap);
 		lockres_free(bm_lockres);
 
-		sb = kmap_atomic(bitmap->storage.sb_page);
-		if (sync_size == 0)
-			sync_size = le64_to_cpu(sb->sync_size);
-		else if (sync_size != le64_to_cpu(sb->sync_size)) {
-			kunmap_atomic(sb);
+		rv = md_bitmap_get_stats(bitmap, &stats);
+		if (rv) {
+			md_bitmap_free(bitmap);
+			return rv;
+		}
+
+		if (sync_size == 0) {
+			sync_size = stats.sync_size;
+		} else if (sync_size != stats.sync_size) {
 			md_bitmap_free(bitmap);
 			return -1;
 		}
-		kunmap_atomic(sb);
 		md_bitmap_free(bitmap);
 	}
 
-- 
2.39.5



