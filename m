Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A376ADD;
	Wed,  5 Mar 2025 17:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197089; cv=none; b=RqQTiyMo8QDIfr4+D+WVJRWWj5H6VJU0YfLYi/HBE3Js87Zup3yhKT683dB09Nx7h7LyLzZcLEzK8AjPKxJJwimCNcGzGMt1Jz8eIJeomS9UrADYGRxSVhbhbamn5i6ctW3IE4mf3dU5TH+bR0/CoRlwxTVeVqnLjAMDCOFcwBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197089; c=relaxed/simple;
	bh=G4lm0y7sIQ5mgS2JQX7S3pQGH3i0IUo0cLg3KhKE9bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjJUT5eLzK5aapMjQwjF4ameJDaCavUTtCdTQkRWcbBm2rJ8fiiSIYOewiBax/52chdzqyQAa7xGCnUdnwivScA0VvBVdi8A5yv2/9KsEmk1neqbL1FhkU28vRKU5oFQdN71esGIo1RRgcOgtHsIFUT3FsW1zsPTJ8ejK8360q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/mG/yD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/mG/yD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3DDC4CED1;
	Wed,  5 Mar 2025 17:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197089;
	bh=G4lm0y7sIQ5mgS2JQX7S3pQGH3i0IUo0cLg3KhKE9bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/mG/yD++yMfJa+BC5Xyw5uozdX2nECCaVGyHKwCWkzww1tcWq6pCudP2LYKhHW+Y
	 PSP0nwKLaIf6Wr7bW78Efsf8CexadQ6onP+yGjMH6JO+2C0fMYmySBsVUgk2JQ0+Zk
	 05MZqmG72bO9xBX8ClxMW63f4p4j37PdCr73GNvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/176] md/md-bitmap: add sync_size into struct md_bitmap_stats
Date: Wed,  5 Mar 2025 18:46:16 +0100
Message-ID: <20250305174505.748319783@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 736268447d3e1..bddf4f3d27a77 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2025,10 +2025,15 @@ EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
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
@@ -2036,6 +2041,7 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(md_bitmap_get_stats);
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		  int chunksize, int init)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 00ac4c3ecf4d9..7b7a701f74be7 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -235,6 +235,7 @@ struct bitmap {
 
 struct md_bitmap_stats {
 	unsigned long	missing_pages;
+	unsigned long	sync_size;
 	unsigned long	pages;
 	struct file	*file;
 };
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index a0d3f6c397707..7484bb83171a9 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1185,18 +1185,21 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
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
@@ -1225,15 +1228,18 @@ static int cluster_check_sync_size(struct mddev *mddev)
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



