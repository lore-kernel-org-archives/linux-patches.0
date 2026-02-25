Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB9B2797AC;
	Wed, 25 Feb 2026 01:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983730; cv=none; b=DUOi+EHfVkMkZfWYFm9a5vrCH3EjGU4vZZdmJU1qV0BBRM1q4diwqwrJNvrR8TOSYPkYhxVRpNZZN+vM3eILTDTi9ueJx4zlKqVt1Wx+u0snYI+SxftWCcr6L0f2MAePsplYrwpkAxqH5Huo2rl0dgIudSIM3joH1BORTdBldMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983730; c=relaxed/simple;
	bh=6rgRqGji+Hbeh8hrKCOOexE03YIeRwNNa4SzPYOVUxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhLsh+qSXHF83FfQlxaDatyaMll7a5aKerVm2vhCerIPH9lqoirnFQydfWT/mOrV+DzLiKU/kAehhHCH4Ubv/G3DpyopSeTWqo6bb6T3+r9OMaeAfKUkPUmIz5qNJJf6pUoEWKAqrpe3FyOXbn2J+yXF+k/I0Mz9wtp8YJt5I54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rh1CWi6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rh1CWi6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96C9C19424;
	Wed, 25 Feb 2026 01:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983730;
	bh=6rgRqGji+Hbeh8hrKCOOexE03YIeRwNNa4SzPYOVUxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rh1CWi6uV+IKPQ5oaiZqxnh3qNos9tvC/eAaY+OVfVCufafs9rBCE0In7uPNnuceV
	 TnPSKlDMSQOvrLfEgHhQCAthfpKvP/f88Bqg6mdAXob/X2lgEM5+OKQH0BCeox09Ri
	 r6Ozv0VE0opB7Ts5ps3r/3wb/m8supobeV3Oq4Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/641] btrfs: introduce btrfs_bio::async_csum
Date: Tue, 24 Feb 2026 17:15:51 -0800
Message-ID: <20260225012349.592996938@linuxfoundation.org>
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

[ Upstream commit dd57c78aec398717a2fa6488d87b1a6cd43c7d0d ]

[ENHANCEMENT]
Btrfs currently calculates data checksums then submits the bio.

But after commit 968f19c5b1b7 ("btrfs: always fallback to buffered write
if the inode requires checksum"), any writes with data checksum will
fallback to buffered IO, meaning the content will not change during
writeback.

This means we're safe to calculate the data checksum and submit the bio
in parallel, and only need the following new behavior:

- Wait the csum generation to finish before calling btrfs_bio::end_io()
  Or this can lead to use-after-free for the csum generation worker.

- Save the current bi_iter for csum_one_bio()
  As the submission part can advance btrfs_bio::bio.bi_iter, if not
  saved csum_one_bio() may got an empty bi_iter and do not generate any
  checksum.

  Unfortunately this means we have to increase the size of btrfs_bio for
  16 bytes, but this is still acceptable.

As usual, such new feature is hidden behind the experimental flag.

[THEORETIC ANALYZE]
Consider the following theoretic hardware performance, which should be
more or less close to modern mainstream hardware:

	Memory bandwidth:	50GiB/s
	CRC32C bandwidth:	45GiB/s
	SSD bandwidth:		8GiB/s

Then write bandwidth with data checksum before the patch is:

	1 / ( 1 / 50 + 1 / 45 + 1 / 8) = 5.98 GiB/s

After the patch, the bandwidth is:

	1 / ( 1 / 50 + max( 1 / 45 + 1 / 8)) = 6.90 GiB/s

The difference is 15.32% improvement.

[REAL WORLD BENCHMARK]
I'm using a Zen5 (HX 370) as the host, the VM has 4GiB memory, 10 vCPUs, the
storage is backed by a PCIe gen3 x4 NVMe.

The test is a direct IO write, with 1MiB block size, write 7GiB data
into a btrfs mount with data checksum. Thus the direct write will
fallback to buffered one:

Vanilla Datasum:	1619.97 GiB/s
Patched Datasum:	1792.26 GiB/s
Diff			+10.6 %

In my case, the bottleneck is the storage, thus the improvement is not
reaching the theoretic one, but still some observable improvement.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: b39b26e017c7 ("btrfs: zoned: don't zone append to conventional zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c       | 21 ++++++++++++----
 fs/btrfs/bio.h       |  7 ++++++
 fs/btrfs/file-item.c | 60 +++++++++++++++++++++++++++++++-------------
 fs/btrfs/file-item.h |  2 +-
 4 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 52b8893f26f16..1286c1ac19404 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -105,6 +105,9 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 	/* Make sure we're already in task context. */
 	ASSERT(in_task());
 
+	if (bbio->async_csum)
+		wait_for_completion(&bbio->csum_done);
+
 	bbio->bio.bi_status = status;
 	if (bbio->bio.bi_pool == &btrfs_clone_bioset) {
 		struct btrfs_bio *orig_bbio = bbio->private;
@@ -538,7 +541,11 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
 {
 	if (bbio->bio.bi_opf & REQ_META)
 		return btree_csum_one_bio(bbio);
-	return btrfs_csum_one_bio(bbio);
+#ifdef CONFIG_BTRFS_EXPERIMENTAL
+	return btrfs_csum_one_bio(bbio, true);
+#else
+	return btrfs_csum_one_bio(bbio, false);
+#endif
 }
 
 /*
@@ -617,10 +624,14 @@ static bool should_async_write(struct btrfs_bio *bbio)
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	enum btrfs_offload_csum_mode csum_mode = READ_ONCE(fs_devices->offload_csum_mode);
 
-	if (csum_mode == BTRFS_OFFLOAD_CSUM_FORCE_OFF)
-		return false;
-
-	auto_csum_mode = (csum_mode == BTRFS_OFFLOAD_CSUM_AUTO);
+	if (csum_mode == BTRFS_OFFLOAD_CSUM_FORCE_ON)
+		return true;
+	/*
+	 * Write bios will calculate checksum and submit bio at the same time.
+	 * Unless explicitly required don't offload serial csum calculate and bio
+	 * submit into a workqueue.
+	 */
+	return false;
 #endif
 
 	/* Submit synchronously if the checksum implementation is fast. */
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index b7a0de6f97840..9a44b86d561b1 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -63,6 +63,9 @@ struct btrfs_bio {
 		struct {
 			struct btrfs_ordered_extent *ordered;
 			struct btrfs_ordered_sum *sums;
+			struct work_struct csum_work;
+			struct completion csum_done;
+			struct bvec_iter csum_saved_iter;
 			u64 orig_physical;
 		};
 
@@ -90,6 +93,10 @@ struct btrfs_bio {
 	 * scrub bios.
 	 */
 	bool is_scrub;
+
+	/* Whether the csum generation for data write is async. */
+	bool async_csum;
+
 	/*
 	 * This member must come last, bio_alloc_bioset will allocate enough
 	 * bytes for entire btrfs_bio but relies on bio being last.
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a42e6d54e7cd7..4b7c40f05e8f9 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -18,6 +18,7 @@
 #include "fs.h"
 #include "accessors.h"
 #include "file-item.h"
+#include "volumes.h"
 
 #define __MAX_CSUM_ITEMS(r, size) ((unsigned long)(((BTRFS_LEAF_DATA_SIZE(r) - \
 				   sizeof(struct btrfs_item) * 2) / \
@@ -764,21 +765,46 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
 	return ret;
 }
 
+static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src)
+{
+	struct btrfs_inode *inode = bbio->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
+	struct bio *bio = &bbio->bio;
+	struct btrfs_ordered_sum *sums = bbio->sums;
+	struct bvec_iter iter = *src;
+	phys_addr_t paddr;
+	const u32 blocksize = fs_info->sectorsize;
+	int index = 0;
+
+	shash->tfm = fs_info->csum_shash;
+
+	btrfs_bio_for_each_block(paddr, bio, &iter, blocksize) {
+		btrfs_calculate_block_csum(fs_info, paddr, sums->sums + index);
+		index += fs_info->csum_size;
+	}
+}
+
+static void csum_one_bio_work(struct work_struct *work)
+{
+	struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, csum_work);
+
+	ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
+	ASSERT(bbio->async_csum == true);
+	csum_one_bio(bbio, &bbio->csum_saved_iter);
+	complete(&bbio->csum_done);
+}
+
 /*
  * Calculate checksums of the data contained inside a bio.
  */
-int btrfs_csum_one_bio(struct btrfs_bio *bbio)
+int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 {
 	struct btrfs_ordered_extent *ordered = bbio->ordered;
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
 	struct bio *bio = &bbio->bio;
 	struct btrfs_ordered_sum *sums;
-	struct bvec_iter iter = bio->bi_iter;
-	phys_addr_t paddr;
-	const u32 blocksize = fs_info->sectorsize;
-	int index;
 	unsigned nofs_flag;
 
 	nofs_flag = memalloc_nofs_save();
@@ -789,21 +815,21 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio)
 	if (!sums)
 		return -ENOMEM;
 
+	sums->logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 	sums->len = bio->bi_iter.bi_size;
 	INIT_LIST_HEAD(&sums->list);
-
-	sums->logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
-	index = 0;
-
-	shash->tfm = fs_info->csum_shash;
-
-	btrfs_bio_for_each_block(paddr, bio, &iter, blocksize) {
-		btrfs_calculate_block_csum(fs_info, paddr, sums->sums + index);
-		index += fs_info->csum_size;
-	}
-
 	bbio->sums = sums;
 	btrfs_add_ordered_sum(ordered, sums);
+
+	if (!async) {
+		csum_one_bio(bbio, &bbio->bio.bi_iter);
+		return 0;
+	}
+	init_completion(&bbio->csum_done);
+	bbio->async_csum = true;
+	bbio->csum_saved_iter = bbio->bio.bi_iter;
+	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
+	schedule_work(&bbio->csum_work);
 	return 0;
 }
 
diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
index 0d59e830018a6..5645c5e3abdb7 100644
--- a/fs/btrfs/file-item.h
+++ b/fs/btrfs/file-item.h
@@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_ordered_sum *sums);
-int btrfs_csum_one_bio(struct btrfs_bio *bbio);
+int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
 int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit,
-- 
2.51.0



