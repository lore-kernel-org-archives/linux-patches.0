Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241BA17990
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AexsM5yE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD3CC433C7;
	Mon,  9 Oct 2023 13:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856865;
	bh=Wn5efIWwdQmr19telkzoAZSH2RzFVaphy37OdhRvsAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AexsM5yEc7VedXAEp++8rrrC+lvJanVGQZ+ct3ecFebW1ouDo9t/p3O+nfyWfbdc2
	 UbnTlW3RY0YZ/owxVIB3lC6KLmORMW6Ouw4rn+qymIQ5gylnLaHzOGyBvSha+JPfeB
	 lgFTCT/cgZZt6J0h/DdCTncbnSXKntGmjTMFTt9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 017/163] btrfs: dont clear uptodate on write errors
Date: Mon,  9 Oct 2023 14:59:41 +0200
Message-ID: <20231009130124.490534308@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit b595d25996329427b2c09d4b90395a165fb3ef8e ]

We have been consistently seeing hangs with generic/648 in our subpage
GitHub CI setup.  This is a classic deadlock, we are calling
btrfs_read_folio() on a folio, which requires holding the folio lock on
the folio, and then finding a ordered extent that overlaps that range
and calling btrfs_start_ordered_extent(), which then tries to write out
the dirty page, which requires taking the folio lock and then we
deadlock.

The hang happens because we're writing to range [1271750656, 1271767040),
page index [77621, 77622], and page 77621 is !Uptodate.  It is also Dirty,
so we call btrfs_read_folio() for 77621 and which does
btrfs_lock_and_flush_ordered_range() for that range, and we find an ordered
extent which is [1271644160, 1271746560), page index [77615, 77621].
The page indexes overlap, but the actual bytes don't overlap.  We're
holding the page lock for 77621, then call
btrfs_lock_and_flush_ordered_range() which tries to flush the dirty
page, and tries to lock 77621 again and then we deadlock.

The byte ranges do not overlap, but with subpage support if we clear
uptodate on any portion of the page we mark the entire thing as not
uptodate.

We have been clearing page uptodate on write errors, but no other file
system does this, and is in fact incorrect.  This doesn't hurt us in the
!subpage case because we can't end up with overlapped ranges that don't
also overlap on the page.

Fix this by not clearing uptodate when we have a write error.  The only
thing we should be doing in this case is setting the mapping error and
carrying on.  This makes it so we would no longer call
btrfs_read_folio() on the page as it's uptodate and eliminates the
deadlock.

With this patch we're now able to make it through a full fstests run on
our subpage blocksize VMs.

Note for stable backports: this probably goes beyond 6.1 but the code
has been cleaned up and clearing the uptodate bit must be verified on
each version independently.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 9 +--------
 fs/btrfs/inode.c     | 4 ----
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 009c322c5418d..d8461c9aa2445 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -533,10 +533,8 @@ static void end_bio_extent_writepage(struct btrfs_bio *bbio)
 				   bvec->bv_offset, bvec->bv_len);
 
 		btrfs_finish_ordered_extent(bbio->ordered, page, start, len, !error);
-		if (error) {
-			btrfs_page_clear_uptodate(fs_info, page, start, len);
+		if (error)
 			mapping_set_error(page->mapping, error);
-		}
 		btrfs_page_clear_writeback(fs_info, page, start, len);
 	}
 
@@ -1508,8 +1506,6 @@ static int __extent_writepage(struct page *page, struct btrfs_bio_ctrl *bio_ctrl
 	if (ret) {
 		btrfs_mark_ordered_io_finished(BTRFS_I(inode), page, page_start,
 					       PAGE_SIZE, !ret);
-		btrfs_page_clear_uptodate(btrfs_sb(inode->i_sb), page,
-					  page_start, PAGE_SIZE);
 		mapping_set_error(page->mapping, ret);
 	}
 	unlock_page(page);
@@ -1676,8 +1672,6 @@ static void extent_buffer_write_end_io(struct btrfs_bio *bbio)
 		struct page *page = bvec->bv_page;
 		u32 len = bvec->bv_len;
 
-		if (!uptodate)
-			btrfs_page_clear_uptodate(fs_info, page, start, len);
 		btrfs_page_clear_writeback(fs_info, page, start, len);
 		bio_offset += len;
 	}
@@ -2256,7 +2250,6 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 		if (ret) {
 			btrfs_mark_ordered_io_finished(BTRFS_I(inode), page,
 						       cur, cur_len, !ret);
-			btrfs_page_clear_uptodate(fs_info, page, cur, cur_len);
 			mapping_set_error(page->mapping, ret);
 		}
 		btrfs_page_unlock_writer(fs_info, page, cur, cur_len);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b126394ca3dde..0f4498dfa30c9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1162,9 +1162,6 @@ static int submit_uncompressed_range(struct btrfs_inode *inode,
 			btrfs_mark_ordered_io_finished(inode, locked_page,
 						       page_start, PAGE_SIZE,
 						       !ret);
-			btrfs_page_clear_uptodate(inode->root->fs_info,
-						  locked_page, page_start,
-						  PAGE_SIZE);
 			mapping_set_error(locked_page->mapping, ret);
 			unlock_page(locked_page);
 		}
@@ -2951,7 +2948,6 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 		mapping_set_error(page->mapping, ret);
 		btrfs_mark_ordered_io_finished(inode, page, page_start,
 					       PAGE_SIZE, !ret);
-		btrfs_page_clear_uptodate(fs_info, page, page_start, PAGE_SIZE);
 		clear_page_dirty_for_io(page);
 	}
 	btrfs_page_clear_checked(fs_info, page, page_start, PAGE_SIZE);
-- 
2.40.1



