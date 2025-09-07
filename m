Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512434315A;
	Sun,  7 Sep 2025 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277436; cv=none; b=NnHU/MaIGJZbDXtmd5Pc0BqXDHeYm32JbB8WMaInsZ7f8eiwVjLifH5/dZChuSbjL0AoBdV0+LdowZle/49bEIRM/63lQzfJuRkjTVy+wamVQ7m3qr7GJpkRakeV0vaEqALl928UStjg2c86Yq83z9guXvzvtfxRjSPpWdREYcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277436; c=relaxed/simple;
	bh=j+gv+qSU/uHkExRxRuaL5XlBZUs1d6tIfUepxb+nb90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKcay/ebh0BnNsU4NP3emxJh0ddgtiq8/nbsmjNYyqEB7Phao9cKPdeqUEPNRSe7zR5tgCdXQ3ur35a+N9MFtrWwBpzh7sCtfZiALWufIBnhaUwmiuN1i26jmHH3XResnewmeH8ht5bPiGrUVh/LS9KG+YW5G0+Ma7iHHJGmzzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gl5BqeI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gl5BqeI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA001C4CEF0;
	Sun,  7 Sep 2025 20:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277436;
	bh=j+gv+qSU/uHkExRxRuaL5XlBZUs1d6tIfUepxb+nb90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gl5BqeI7K/v40KxdARGqBQctldQPQedCQ4JaPBfO8Mc87nqgMXihFKGnA0bPYyzSw
	 TeXD7RXRfp95IKQbpnxAqkt1n/MYNrtdyqtPYmMkD900rcg4jvQFa98FyCMfIGw4Wn
	 RH7qndm/bJs0MLWbdOq3hxnUcVAUrh0OQ2oxSPxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 015/183] btrfs: clear block dirty if submit_one_sector() failed
Date: Sun,  7 Sep 2025 21:57:22 +0200
Message-ID: <20250907195616.153413575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 4bcd3061e8154606af7f721cb75ca04ffe191a12 ]

[BUG]
If submit_one_sector() failed, the block will be kept dirty, but with
their corresponding range finished in the ordered extent.

This means if a writeback happens later again, we can hit the following
problems:

- ASSERT(block_start != EXTENT_MAP_HOLE) in submit_one_sector()
  If the original extent map is a hole, then we can hit this case, as
  the new ordered extent failed, we will drop the new extent map and
  re-read one from the disk.

- DEBUG_WARN() in btrfs_writepage_cow_fixup()
  This is because we no longer have an ordered extent for those dirty
  blocks. The original for them is already finished with error.

[CAUSE]
The function submit_one_sector() is not following the regular error
handling of writeback.  The common practice is to clear the folio dirty,
start and finish the writeback for the block.

This is normally done by extent_clear_unlock_delalloc() with
PAGE_START_WRITEBACK | PAGE_END_WRITEBACK flags during
run_delalloc_range().

So if we keep those failed blocks dirty, they will stay in the page
cache and wait for the next writeback.

And since the original ordered extent is already finished and removed,
depending on the original extent map, we either hit the ASSERT() inside
submit_one_sector(), or hit the DEBUG_WARN() in
btrfs_writepage_cow_fixup().

[FIX]
Follow the regular error handling to clear the dirty flag for the block,
start and finish writeback for that block instead.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3711a5d073423..fac4000a5bcae 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1483,7 +1483,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 
 /*
  * Return 0 if we have submitted or queued the sector for submission.
- * Return <0 for critical errors.
+ * Return <0 for critical errors, and the sector will have its dirty flag cleared.
  *
  * Caller should make sure filepos < i_size and handle filepos >= i_size case.
  */
@@ -1506,8 +1506,17 @@ static int submit_one_sector(struct btrfs_inode *inode,
 	ASSERT(filepos < i_size);
 
 	em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
-	if (IS_ERR(em))
+	if (IS_ERR(em)) {
+		/*
+		 * When submission failed, we should still clear the folio dirty.
+		 * Or the folio will be written back again but without any
+		 * ordered extent.
+		 */
+		btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
+		btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
+		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
 		return PTR_ERR(em);
+	}
 
 	extent_offset = filepos - em->start;
 	em_end = btrfs_extent_map_end(em);
@@ -1637,8 +1646,8 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	 * Here we set writeback and clear for the range. If the full folio
 	 * is no longer dirty then we clear the PAGECACHE_TAG_DIRTY tag.
 	 *
-	 * If we hit any error, the corresponding sector will still be dirty
-	 * thus no need to clear PAGECACHE_TAG_DIRTY.
+	 * If we hit any error, the corresponding sector will have its dirty
+	 * flag cleared and writeback finished, thus no need to handle the error case.
 	 */
 	if (!submitted_io && !error) {
 		btrfs_folio_set_writeback(fs_info, folio, start, len);
-- 
2.50.1



