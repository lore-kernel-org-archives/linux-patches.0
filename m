Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015165;
	b=SEyDZyO7lkrn6ahUe/WuT1hIXhJBz+BmTpXUyAW3ibsdMyjcg3HFdLa6rizeBzr0uRKP
	 5oNdsY+3+RUlcJ0w+naosyWw1ZvfK0heH4IJ9OAPcNUEZzdVxYEF+ht1otBIGWfg7ujsu
	 IdfsUSOs8Zo65t78mozcnw+E4h62n7KGO8aKtNW/BGi8oXHJ4ZE+LavcDzLgj82vU6JaH
	 QGNWSCarfwngdOZ/7uRxFbqrqMrUiLV23HNBnouMdlmi1F4UONpeDrRFbfRD6oBUJ0UTz
	 MisaG/JiGirNbTelYPlpQDuu4mBF2Yv70pYaLc9ohCyUqkPEGLhRbWo2npRjL1jCQMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tp26Z9v+h8PMND71A/bgtwl5w1hHVAXslU1QP3++fGg=;
	b=epEukbANYk4GyhYZiiivYvI3zj/xw0luFZZb1xBFFAOjg0hIF2Rs443fMpqpIMIJTigB
	 9k1DHFgPnqRO4SH+rris9MdU8XJnQphEIXROuqtgNVOVM5HEG6hCsyRPwA2vVFXA3UNny
	 NWY5EXOUiHl/gSOdpM9IAChlDKsUazDmjTkyjrRQr/FZMgPyWFhjkxtm2CR61NHsJFYbQ
	 o6Ds4ONc0lhEpBM10K/Ffr492hWDHMCBBDC1v884lGQR0fdygv4shIRhTRaqjVGV9qHip
	 GdXm//43z3tfAOYcmaGSsFWHV9o7Tkqt32EXbH9mS4ByrAxCrjF+0srSbB1sEd8YSLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RtiuNCD0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C938260A2616;
	Wed, 18 Nov 2026 15:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RtiuNCD0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280191F000CB;
	Wed, 18 Nov 2026 15:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015165;
	bh=Tp26Z9v+h8PMND71A/bgtwl5w1hHVAXslU1QP3++fGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtiuNCD02sH4cFdyk5H8YQwBTSUrN2wmftKMSb5iPx2YmiYrEP/lUJFEtgmCU9Tvx
	 r8o7vaGEVuB7xmv+E5h0jXTFCxOSUzXIn6LhIVOytd//eIJ5nwC14hZFfevbK/BNUD
	 +UYxGq4ZCbllPKP2KG84EIpvPyq8pwh9O1W0r3uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0034/2651] btrfs: use a shared helper to calculate data checksum for a bio
Date: Wed, 18 Nov 2026 15:21:14 +0100
Message-ID: <20261118150249.202418807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 64978a4eced2b8f769cdfc27d68c6710e9c92627 ]

Since we are already calculating data checksum using bio interface,
extract the generation part into btrfs_csum_one_bio_block(), and use that
to replace the paddrs[] array based solution in csum_one_bio().

This will reduce 128 bytes on-stack memory usage for csum_one_bio().

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: d00b85308abe ("btrfs: raid56: do not verify the content if there is no data checksum")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h |  2 ++
 fs/btrfs/file-item.c   | 19 +++++------------
 fs/btrfs/inode.c       | 46 +++++++++++++++++++++++++-----------------
 3 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 171f96bdb8aa7..e137a99151bd0 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -515,6 +515,8 @@ int btrfs_check_block_csum(struct btrfs_fs_info *fs_info, phys_addr_t paddr, u8
 			   const u8 * const csum_expected);
 bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio, const struct bvec_iter *orig_iter,
 			    struct btrfs_device *dev);
+void btrfs_csum_one_bio_block(struct btrfs_fs_info *fs_info, struct bio *bio,
+			      const struct bvec_iter *orig_iter, u8 *csum);
 noinline int can_nocow_extent(struct btrfs_inode *inode, u64 offset, u64 *len,
 			      struct btrfs_file_extent *file_extent,
 			      bool nowait);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index cf50fd623f41a..581ca5653be93 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -801,25 +801,16 @@ static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src)
 {
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct bio *bio = &bbio->bio;
 	struct btrfs_ordered_sum *sums = bbio->sums;
-	struct bvec_iter iter = *src;
-	phys_addr_t paddr;
+	struct bvec_iter iter;
 	const u32 blocksize = fs_info->sectorsize;
-	const u32 step = min(blocksize, PAGE_SIZE);
-	const u32 nr_steps = blocksize / step;
-	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
-	u32 offset = 0;
 	int index = 0;
 
-	btrfs_bio_for_each_block(paddr, bio, &iter, step) {
-		paddrs[(offset / step) % nr_steps] = paddr;
-		offset += step;
+	for (iter = *src; iter.bi_size; bio_advance_iter(&bbio->bio, &iter, blocksize)) {
+		btrfs_csum_one_bio_block(fs_info, &bbio->bio, &iter,
+					 sums->sums + index);
 
-		if (IS_ALIGNED(offset, blocksize)) {
-			btrfs_calculate_block_csum_pages(fs_info, paddrs, sums->sums + index);
-			index += fs_info->csum_size;
-		}
+		index += fs_info->csum_size;
 	}
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f842884722081..c8479ffc8d1df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3546,6 +3546,32 @@ int btrfs_check_block_csum(struct btrfs_fs_info *fs_info, phys_addr_t paddr, u8
 	return 0;
 }
 
+/* Generate data checksum for a single fs block, pointed to by @orig_iter. */
+void btrfs_csum_one_bio_block(struct btrfs_fs_info *fs_info, struct bio *bio,
+			      const struct bvec_iter *orig_iter, u8 *csum)
+{
+	struct btrfs_csum_ctx cctx;
+	struct bvec_iter iter = *orig_iter;
+	const u32 blocksize = fs_info->sectorsize;
+	u32 cur = 0;
+
+	btrfs_csum_init(&cctx, fs_info->csum_type);
+	while (cur < blocksize) {
+		struct page *page = bio_iter_page(bio, iter);
+		const u32 pg_off = bio_iter_offset(bio, iter);
+		const u32 cur_len = min(bio_iter_len(bio, iter), blocksize - cur);
+		void *kaddr;
+
+		kaddr = kmap_local_page(page) + pg_off;
+		btrfs_csum_update(&cctx, kaddr, cur_len);
+		kunmap_local(kaddr);
+
+		bio_advance_iter_single(bio, &iter, cur_len);
+		cur += cur_len;
+	}
+	btrfs_csum_final(&cctx, csum);
+}
+
 /*
  * Verify the checksum of a single data sector, which can be scattered at
  * different noncontiguous pages.
@@ -3566,7 +3592,6 @@ bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio,
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct bvec_iter iter = *orig_iter;
-	struct btrfs_csum_ctx cctx;
 	const u32 blocksize = fs_info->sectorsize;
 	const u32 bio_offset = (iter.bi_sector - bbio->saved_iter.bi_sector) << SECTOR_SHIFT;
 	u64 file_offset = bbio->file_offset + bio_offset;
@@ -3591,22 +3616,7 @@ bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio,
 
 	csum_expected = bbio->csum + (bio_offset >> fs_info->sectorsize_bits) *
 				fs_info->csum_size;
-	btrfs_csum_init(&cctx, fs_info->csum_type);
-	while (cur < blocksize) {
-		struct page *page = bio_iter_page(&bbio->bio, iter);
-		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
-		const u32 cur_len = min(bio_iter_len(&bbio->bio, iter), blocksize - cur);
-		void *kaddr;
-
-		kaddr = kmap_local_page(page) + pg_off;
-		btrfs_csum_update(&cctx, kaddr, cur_len);
-		kunmap_local(kaddr);
-
-		bio_advance_iter_single(&bbio->bio, &iter, cur_len);
-		cur += cur_len;
-	}
-	btrfs_csum_final(&cctx, csum);
-
+	btrfs_csum_one_bio_block(fs_info, &bbio->bio, orig_iter, csum);
 	if (unlikely(memcmp(csum, csum_expected, fs_info->csum_size) != 0))
 		goto zeroit;
 	return true;
@@ -3616,8 +3626,6 @@ bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio,
 				    bbio->mirror_num);
 	if (dev)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_CORRUPTION_ERRS);
-	cur = 0;
-	iter = *orig_iter;
 	while (cur < blocksize) {
 		struct page *page = bio_iter_page(&bbio->bio, iter);
 		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
-- 
2.53.0



