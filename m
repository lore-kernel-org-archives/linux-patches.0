Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686D218657
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23BAC433CB;
	Wed, 20 Sep 2023 11:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210722;
	bh=YoDaYVT3x6lc3QZS/5HISEwu9a556qikLXUdlDzOxLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6ljfagH0IEG1ML6vFA8HTg/zVLgTtixDLdS3hJGSNRu8b9w5ZU5B41AhB7bksW/A
	 +2wk1xu4/Y0C/6cM2DKu56EHqd+z01/Z0domXi5FAq/C+M64G2WJbA/aIFbm5n2xxl
	 SdY6GI0MyhdI4+/ShS/RsCfj+d28yUTWovu1OjG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.5 180/211] btrfs: fix a compilation error if DEBUG is defined in btree_dirty_folio
Date: Wed, 20 Sep 2023 13:30:24 +0200
Message-ID: <20230920112851.457336641@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 5e0e879926c1ce7e1f5e0dfaacaf2d105f7d8a05 upstream.

[BUG]
After commit 72a69cd03082 ("btrfs: subpage: pack all subpage bitmaps
into a larger bitmap"), the DEBUG section of btree_dirty_folio() would
no longer compile.

[CAUSE]
If DEBUG is defined, we would do extra checks for btree_dirty_folio(),
mostly to make sure the range we marked dirty has an extent buffer and
that extent buffer is dirty.

For subpage, we need to iterate through all the extent buffers covered
by that page range, and make sure they all matches the criteria.

However commit 72a69cd03082 ("btrfs: subpage: pack all subpage bitmaps
into a larger bitmap") changes how we store the bitmap, we pack all the
16 bits bitmaps into a larger bitmap, which would save some space.

This means we no longer have btrfs_subpage::dirty_bitmap, instead the
dirty bitmap is starting at btrfs_subpage_info::dirty_offset, and has a
length of btrfs_subpage_info::bitmap_nr_bits.

[FIX]
Although I'm not sure if it still makes sense to maintain such code, at
least let it compile.

This patch would let us test the bits one by one through the bitmaps.

CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -525,6 +525,7 @@ static bool btree_dirty_folio(struct add
 		struct folio *folio)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(mapping->host->i_sb);
+	struct btrfs_subpage_info *spi = fs_info->subpage_info;
 	struct btrfs_subpage *subpage;
 	struct extent_buffer *eb;
 	int cur_bit = 0;
@@ -538,18 +539,19 @@ static bool btree_dirty_folio(struct add
 		btrfs_assert_tree_write_locked(eb);
 		return filemap_dirty_folio(mapping, folio);
 	}
+
+	ASSERT(spi);
 	subpage = folio_get_private(folio);
 
-	ASSERT(subpage->dirty_bitmap);
-	while (cur_bit < BTRFS_SUBPAGE_BITMAP_SIZE) {
+	for (cur_bit = spi->dirty_offset;
+	     cur_bit < spi->dirty_offset + spi->bitmap_nr_bits;
+	     cur_bit++) {
 		unsigned long flags;
 		u64 cur;
-		u16 tmp = (1 << cur_bit);
 
 		spin_lock_irqsave(&subpage->lock, flags);
-		if (!(tmp & subpage->dirty_bitmap)) {
+		if (!test_bit(cur_bit, subpage->bitmaps)) {
 			spin_unlock_irqrestore(&subpage->lock, flags);
-			cur_bit++;
 			continue;
 		}
 		spin_unlock_irqrestore(&subpage->lock, flags);
@@ -562,7 +564,7 @@ static bool btree_dirty_folio(struct add
 		btrfs_assert_tree_write_locked(eb);
 		free_extent_buffer(eb);
 
-		cur_bit += (fs_info->nodesize >> fs_info->sectorsize_bits);
+		cur_bit += (fs_info->nodesize >> fs_info->sectorsize_bits) - 1;
 	}
 	return filemap_dirty_folio(mapping, folio);
 }


