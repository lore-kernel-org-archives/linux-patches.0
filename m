Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2311459EA;
	Mon, 24 Feb 2025 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408836; cv=none; b=F+gVSGrhSYsJ/CS5UW461XcEWXkZSLqIk8KDyzx+8vMwllTAPrztWA2VbBlSf6Bcv3ZgEXigNFEnzEc7XhavrpW4PkUXtzAQ+myWvJVzbRVmv83yGC9yayYjRMO7gbubBAKb1Z0PU4ZNfceLp3N87hU8RsJo/dbNFivZPCvJqm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408836; c=relaxed/simple;
	bh=HjAqguSbTjm9wPBQR4Wbz8alUSsAwFgJnyT0lLAxlvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ts6eAwS6Si+r+0mFMFOyhe1dIWYJ8si75zvZF4jt+gHeRCdT6F7TAnDTvlZ1iCSPGZ7VQxp8zBuBgT/TZz2qYpg8F1wtJWE1lPzrx+b2zlmYVKedVdLWB4oRCbWDZs3uaQ/EXl9tnCgG60n6tkZ/gx6GForPih6RwE73iZFJZGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNw7pnW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNw7pnW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52D7C4CED6;
	Mon, 24 Feb 2025 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408836;
	bh=HjAqguSbTjm9wPBQR4Wbz8alUSsAwFgJnyT0lLAxlvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNw7pnW60FlkihB1ChImqBIBJXMsWsRJVURszo7WLv8i2DD1acTOzhLLfbrzS5uE0
	 fJTSv/sSVFwWdjV7uFi8uQXH56owepdZ7JF6KBsdsi3yunXw7Ju9VLilNT/2D0V660
	 bBEt+St4AFc2qm5O4FvqAJD4pkbWPQq+5yoLFMzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 002/138] btrfs: use btrfs_inode in extent_writepage()
Date: Mon, 24 Feb 2025 15:33:52 +0100
Message-ID: <20250224142604.542622433@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 011a9a1f244656cc3cbde47edba2b250f794d440 ]

As extent_writepage() is internal helper we should use our inode type,
so change it from struct inode.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 8bf334beb349 ("btrfs: fix double accounting race when extent_writepage_io() failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d14ecbe24d775..299507c0008d9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1467,15 +1467,15 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
  */
 static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl)
 {
-	struct inode *inode = folio->mapping->host;
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_inode *inode = BTRFS_I(folio->mapping->host);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	const u64 page_start = folio_pos(folio);
 	int ret;
 	size_t pg_offset;
-	loff_t i_size = i_size_read(inode);
+	loff_t i_size = i_size_read(&inode->vfs_inode);
 	unsigned long end_index = i_size >> PAGE_SHIFT;
 
-	trace_extent_writepage(folio, inode, bio_ctrl->wbc);
+	trace_extent_writepage(folio, &inode->vfs_inode, bio_ctrl->wbc);
 
 	WARN_ON(!folio_test_locked(folio));
 
@@ -1499,13 +1499,13 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 	if (ret < 0)
 		goto done;
 
-	ret = writepage_delalloc(BTRFS_I(inode), folio, bio_ctrl);
+	ret = writepage_delalloc(inode, folio, bio_ctrl);
 	if (ret == 1)
 		return 0;
 	if (ret)
 		goto done;
 
-	ret = extent_writepage_io(BTRFS_I(inode), folio, folio_pos(folio),
+	ret = extent_writepage_io(inode, folio, folio_pos(folio),
 				  PAGE_SIZE, bio_ctrl, i_size);
 	if (ret == 1)
 		return 0;
@@ -1514,7 +1514,7 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 
 done:
 	if (ret) {
-		btrfs_mark_ordered_io_finished(BTRFS_I(inode), folio,
+		btrfs_mark_ordered_io_finished(inode, folio,
 					       page_start, PAGE_SIZE, !ret);
 		mapping_set_error(folio->mapping, ret);
 	}
-- 
2.39.5



