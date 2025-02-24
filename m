Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A344B17579;
	Mon, 24 Feb 2025 14:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408274; cv=none; b=n9beg2xUSzfLJt+psxlLut/mKf4C00Cxjtv/Xo15G0lbnZqh9AplsJVaubcWQCvb9yHITJ6+ONMdpOAW8u8emVwoFA/DomvD5qY+RUtw77j3ExGc6YrJQR3E8uAUdkxNyy37ZC1mXhF7hjH7MyyfEImLoAcv10qOn7tZPQ8RBd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408274; c=relaxed/simple;
	bh=YrKHugiqNFG+OV7OcfxlHb/aaB+ZGHmvN9pWBAq2n2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opzQeIAcB0oItvCgMM0KZKBI/F3g7ndfWUp1u50BEE5OybqUSL5M9TQbvCBV9wPHAha2wZTwTP4D7R83kqzPPBApO/kV014Qy2iY99kZ/5EUQ/gMzD3cXlRCIvR+v96p94gpoYQ8MTesuR74JQnwKZJBpKBJfb1YU7U4cs8Hh0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVGl5MwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVGl5MwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB7CC4CED6;
	Mon, 24 Feb 2025 14:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408274;
	bh=YrKHugiqNFG+OV7OcfxlHb/aaB+ZGHmvN9pWBAq2n2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVGl5MwNbKkB5QuoIGOyI+ltZJwrB9AVrEvAQPNDxuVIH2wnAF9kYhLyaxIB9hiRG
	 dWwj2n7aA/DbFi55Y765tiYn0t43z7ecsCiV0Upqa5fJOW87sLCt220xMRb43LMdzT
	 cKiLEUgHpp5InK0MsCBU6mQAOrU+xA5bv89tMxII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/154] btrfs: unify to use writer locks for subpage locking
Date: Mon, 24 Feb 2025 15:33:29 +0100
Message-ID: <20250224142607.474438408@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 336e69f3025fb70db9d0dfb7f36ac79887bf5341 ]

Since commit d7172f52e993 ("btrfs: use per-buffer locking for
extent_buffer reading"), metadata read no longer relies on the subpage
reader locking.

This means we do not need to maintain a different metadata/data split
for locking, so we can convert the existing reader lock users by:

- add_ra_bio_pages()
  Convert to btrfs_folio_set_writer_lock()

- end_folio_read()
  Convert to btrfs_folio_end_writer_lock()

- begin_folio_read()
  Convert to btrfs_folio_set_writer_lock()

- folio_range_has_eb()
  Remove the subpage->readers checks, since it is always 0.

- Remove btrfs_subpage_start_reader() and btrfs_subpage_end_reader()

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 8bf334beb349 ("btrfs: fix double accounting race when extent_writepage_io() failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/compression.c |  3 +-
 fs/btrfs/extent_io.c   | 10 ++-----
 fs/btrfs/subpage.c     | 62 ++----------------------------------------
 fs/btrfs/subpage.h     | 13 ---------
 4 files changed, 5 insertions(+), 83 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 90aef2627ca27..64eaf74fbebc8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -545,8 +545,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		 * subpage::readers and to unlock the page.
 		 */
 		if (fs_info->sectorsize < PAGE_SIZE)
-			btrfs_subpage_start_reader(fs_info, folio, cur,
-						   add_size);
+			btrfs_folio_set_writer_lock(fs_info, folio, cur, add_size);
 		folio_put(folio);
 		cur += add_size;
 	}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8222ae6f29af5..5d6b3b812593d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -438,7 +438,7 @@ static void end_folio_read(struct folio *folio, bool uptodate, u64 start, u32 le
 	if (!btrfs_is_subpage(fs_info, folio->mapping))
 		folio_unlock(folio);
 	else
-		btrfs_subpage_end_reader(fs_info, folio, start, len);
+		btrfs_folio_end_writer_lock(fs_info, folio, start, len);
 }
 
 /*
@@ -495,7 +495,7 @@ static void begin_folio_read(struct btrfs_fs_info *fs_info, struct folio *folio)
 		return;
 
 	ASSERT(folio_test_private(folio));
-	btrfs_subpage_start_reader(fs_info, folio, folio_pos(folio), PAGE_SIZE);
+	btrfs_folio_set_writer_lock(fs_info, folio, folio_pos(folio), PAGE_SIZE);
 }
 
 /*
@@ -2507,12 +2507,6 @@ static bool folio_range_has_eb(struct btrfs_fs_info *fs_info, struct folio *foli
 		subpage = folio_get_private(folio);
 		if (atomic_read(&subpage->eb_refs))
 			return true;
-		/*
-		 * Even there is no eb refs here, we may still have
-		 * end_folio_read() call relying on page::private.
-		 */
-		if (atomic_read(&subpage->readers))
-			return true;
 	}
 	return false;
 }
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 99341e98bbcc7..0587a7d7b5e81 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -140,12 +140,10 @@ struct btrfs_subpage *btrfs_alloc_subpage(const struct btrfs_fs_info *fs_info,
 		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&ret->lock);
-	if (type == BTRFS_SUBPAGE_METADATA) {
+	if (type == BTRFS_SUBPAGE_METADATA)
 		atomic_set(&ret->eb_refs, 0);
-	} else {
-		atomic_set(&ret->readers, 0);
+	else
 		atomic_set(&ret->writers, 0);
-	}
 	return ret;
 }
 
@@ -221,62 +219,6 @@ static void btrfs_subpage_assert(const struct btrfs_fs_info *fs_info,
 	__start_bit;							\
 })
 
-void btrfs_subpage_start_reader(const struct btrfs_fs_info *fs_info,
-				struct folio *folio, u64 start, u32 len)
-{
-	struct btrfs_subpage *subpage = folio_get_private(folio);
-	const int start_bit = subpage_calc_start_bit(fs_info, folio, locked, start, len);
-	const int nbits = len >> fs_info->sectorsize_bits;
-	unsigned long flags;
-
-
-	btrfs_subpage_assert(fs_info, folio, start, len);
-
-	spin_lock_irqsave(&subpage->lock, flags);
-	/*
-	 * Even though it's just for reading the page, no one should have
-	 * locked the subpage range.
-	 */
-	ASSERT(bitmap_test_range_all_zero(subpage->bitmaps, start_bit, nbits));
-	bitmap_set(subpage->bitmaps, start_bit, nbits);
-	atomic_add(nbits, &subpage->readers);
-	spin_unlock_irqrestore(&subpage->lock, flags);
-}
-
-void btrfs_subpage_end_reader(const struct btrfs_fs_info *fs_info,
-			      struct folio *folio, u64 start, u32 len)
-{
-	struct btrfs_subpage *subpage = folio_get_private(folio);
-	const int start_bit = subpage_calc_start_bit(fs_info, folio, locked, start, len);
-	const int nbits = len >> fs_info->sectorsize_bits;
-	unsigned long flags;
-	bool is_data;
-	bool last;
-
-	btrfs_subpage_assert(fs_info, folio, start, len);
-	is_data = is_data_inode(BTRFS_I(folio->mapping->host));
-
-	spin_lock_irqsave(&subpage->lock, flags);
-
-	/* The range should have already been locked. */
-	ASSERT(bitmap_test_range_all_set(subpage->bitmaps, start_bit, nbits));
-	ASSERT(atomic_read(&subpage->readers) >= nbits);
-
-	bitmap_clear(subpage->bitmaps, start_bit, nbits);
-	last = atomic_sub_and_test(nbits, &subpage->readers);
-
-	/*
-	 * For data we need to unlock the page if the last read has finished.
-	 *
-	 * And please don't replace @last with atomic_sub_and_test() call
-	 * inside if () condition.
-	 * As we want the atomic_sub_and_test() to be always executed.
-	 */
-	if (is_data && last)
-		folio_unlock(folio);
-	spin_unlock_irqrestore(&subpage->lock, flags);
-}
-
 static void btrfs_subpage_clamp_range(struct folio *folio, u64 *start, u32 *len)
 {
 	u64 orig_start = *start;
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index 6289d6f65b87d..8488ea057b30b 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -45,14 +45,6 @@ enum {
 struct btrfs_subpage {
 	/* Common members for both data and metadata pages */
 	spinlock_t lock;
-	/*
-	 * Both data and metadata needs to track how many readers are for the
-	 * page.
-	 * Data relies on @readers to unlock the page when last reader finished.
-	 * While metadata doesn't need page unlock, it needs to prevent
-	 * page::private get cleared before the last end_page_read().
-	 */
-	atomic_t readers;
 	union {
 		/*
 		 * Structures only used by metadata
@@ -95,11 +87,6 @@ void btrfs_free_subpage(struct btrfs_subpage *subpage);
 void btrfs_folio_inc_eb_refs(const struct btrfs_fs_info *fs_info, struct folio *folio);
 void btrfs_folio_dec_eb_refs(const struct btrfs_fs_info *fs_info, struct folio *folio);
 
-void btrfs_subpage_start_reader(const struct btrfs_fs_info *fs_info,
-				struct folio *folio, u64 start, u32 len);
-void btrfs_subpage_end_reader(const struct btrfs_fs_info *fs_info,
-			      struct folio *folio, u64 start, u32 len);
-
 void btrfs_folio_end_writer_lock(const struct btrfs_fs_info *fs_info,
 				 struct folio *folio, u64 start, u32 len);
 void btrfs_folio_set_writer_lock(const struct btrfs_fs_info *fs_info,
-- 
2.39.5



