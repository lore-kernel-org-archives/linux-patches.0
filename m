Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A23025B0B5;
	Sat, 30 May 2026 18:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166767; cv=none; b=s1e6KVCo7pHAabEnnn+cf8+t8G5GdtotbOLjeRN3/VcHPVb20Fw4yAvxR5wpdlFJ1QGuqe/95vQL1KkH+wVY/Ntfm2s4aaIUrm7+gTly6NLpKlbU/+3ywG9q/c7fEjWEb45niPQLrjiuaqQOyVFg6nO5G2sESYx70MiL/efAlqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166767; c=relaxed/simple;
	bh=LI9HXvnzhLnK2obWM2Hy0R8dVZV8FcmOFNWZg2UEzas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PX87Vk3tT0QFFGiGNQQTVP85jjECPGyiJh5IEL9WAM56JElMMatUpX3nPbffFskxXFzxKeAljsymXk1qOM9OlbxReFwMNV9+uOQN4GbJWMI7KLRq6Z9VpSicnAObV9HHX5KJyIXOMnuqihjqLZULdmFUDP/fBgplKJrVrMNnpNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRifDosd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRifDosd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7AC1F00893;
	Sat, 30 May 2026 18:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166764;
	bh=EyUdiCUhajJPxWmBCGEJnM4Yzlh83T4bUsxrMIbDdtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRifDosdxi0WneN3XXB1UX+HL7dbc/FuF3bIhgDVHuxFlRpMVFOWjy17ak5zuzEIp
	 lu/fEFS2rTrDcK86N6dq/azWEUnlG0AfKZSCLZYlSadqqIyl68VmrZW0EpSdopQTTk
	 f86nsvNBrJtrxN++VyLo33WM40bt8gEunlNfBWrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 463/589] btrfs: merge PAGE_CLEAR_DIRTY and PAGE_SET_WRITEBACK to PAGE_START_WRITEBACK
Date: Sat, 30 May 2026 18:05:44 +0200
Message-ID: <20260530160236.837222381@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 6869b0a8be775e920be54ee9b69a743ca20d8332 ]

PAGE_CLEAR_DIRTY and PAGE_SET_WRITEBACK are two defines used in
__process_pages_contig(), to let the function know to clear page dirty
bit and then set page writeback.

However page writeback and dirty bits are conflicting (at least for
sector size == PAGE_SIZE case), this means these two have to be always
updated together.

This means we can merge PAGE_CLEAR_DIRTY and PAGE_SET_WRITEBACK to
PAGE_START_WRITEBACK.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 82323b1a7088 ("btrfs: fix double-decrement of bytes_may_use in submit_one_async_extent()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c |  4 ++--
 fs/btrfs/extent_io.h | 12 ++++++------
 fs/btrfs/inode.c     | 28 ++++++++++------------------
 3 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3d0b854e0c19d..38405087cc842 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1983,10 +1983,10 @@ static int __process_pages_contig(struct address_space *mapping,
 				pages_locked++;
 				continue;
 			}
-			if (page_ops & PAGE_CLEAR_DIRTY)
+			if (page_ops & PAGE_START_WRITEBACK) {
 				clear_page_dirty_for_io(pages[i]);
-			if (page_ops & PAGE_SET_WRITEBACK)
 				set_page_writeback(pages[i]);
+			}
 			if (page_ops & PAGE_SET_ERROR)
 				SetPageError(pages[i]);
 			if (page_ops & PAGE_END_WRITEBACK)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e8ab48e5f282d..03aa1e6b3d332 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -34,12 +34,12 @@ enum {
 
 /* these are flags for __process_pages_contig */
 #define PAGE_UNLOCK		(1 << 0)
-#define PAGE_CLEAR_DIRTY	(1 << 1)
-#define PAGE_SET_WRITEBACK	(1 << 2)
-#define PAGE_END_WRITEBACK	(1 << 3)
-#define PAGE_SET_PRIVATE2	(1 << 4)
-#define PAGE_SET_ERROR		(1 << 5)
-#define PAGE_LOCK		(1 << 6)
+/* Page starts writeback, clear dirty bit and set writeback bit */
+#define PAGE_START_WRITEBACK	(1 << 1)
+#define PAGE_END_WRITEBACK	(1 << 2)
+#define PAGE_SET_PRIVATE2	(1 << 3)
+#define PAGE_SET_ERROR		(1 << 4)
+#define PAGE_LOCK		(1 << 5)
 
 /*
  * page->private values.  Every page that is controlled by the extent
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7e66ebb91af78..6d2d799a0ed25 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -642,8 +642,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 						     NULL,
 						     clear_flags,
 						     PAGE_UNLOCK |
-						     PAGE_CLEAR_DIRTY |
-						     PAGE_SET_WRITEBACK |
+						     PAGE_START_WRITEBACK |
 						     page_error_op |
 						     PAGE_END_WRITEBACK);
 
@@ -884,8 +883,7 @@ static noinline void submit_compressed_extents(struct async_chunk *async_chunk)
 				async_extent->start +
 				async_extent->ram_size - 1,
 				NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
-				PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
-				PAGE_SET_WRITEBACK);
+				PAGE_UNLOCK | PAGE_START_WRITEBACK);
 		if (btrfs_submit_compressed_write(inode, async_extent->start,
 				    async_extent->ram_size,
 				    ins.objectid,
@@ -921,9 +919,8 @@ static noinline void submit_compressed_extents(struct async_chunk *async_chunk)
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DELALLOC_NEW |
 				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
-				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
-				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK |
-				     PAGE_SET_ERROR);
+				     PAGE_UNLOCK | PAGE_START_WRITEBACK |
+				     PAGE_END_WRITEBACK | PAGE_SET_ERROR);
 	free_async_extent_pages(async_extent);
 	kfree(async_extent);
 	goto again;
@@ -1020,8 +1017,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DELALLOC_NEW | EXTENT_DEFRAG |
 				     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
-				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
-				     PAGE_END_WRITEBACK);
+				     PAGE_START_WRITEBACK | PAGE_END_WRITEBACK);
 			*nr_written = *nr_written +
 			     (end - start + PAGE_SIZE) / PAGE_SIZE;
 			*page_started = 1;
@@ -1143,8 +1139,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 out_unlock:
 	clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
 		EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV;
-	page_ops = PAGE_UNLOCK | PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
-		PAGE_END_WRITEBACK;
+	page_ops = PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK;
 	/*
 	 * If we reserved an extent for our delalloc range (or a subrange) and
 	 * failed to create the respective ordered extent, then it means that
@@ -1269,9 +1264,8 @@ static int cow_file_range_async(struct btrfs_inode *inode,
 		unsigned clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC |
 			EXTENT_DELALLOC_NEW | EXTENT_DEFRAG |
 			EXTENT_DO_ACCOUNTING;
-		unsigned long page_ops = PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
-			PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK |
-			PAGE_SET_ERROR;
+		unsigned long page_ops = PAGE_UNLOCK | PAGE_START_WRITEBACK |
+					 PAGE_END_WRITEBACK | PAGE_SET_ERROR;
 
 		extent_clear_unlock_delalloc(inode, start, end, locked_page,
 					     clear_bits, page_ops);
@@ -1468,8 +1462,7 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 					     EXTENT_LOCKED | EXTENT_DELALLOC |
 					     EXTENT_DO_ACCOUNTING |
 					     EXTENT_DEFRAG, PAGE_UNLOCK |
-					     PAGE_CLEAR_DIRTY |
-					     PAGE_SET_WRITEBACK |
+					     PAGE_START_WRITEBACK |
 					     PAGE_END_WRITEBACK);
 		return -ENOMEM;
 	}
@@ -1782,8 +1775,7 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 					     locked_page, EXTENT_LOCKED |
 					     EXTENT_DELALLOC | EXTENT_DEFRAG |
 					     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
-					     PAGE_CLEAR_DIRTY |
-					     PAGE_SET_WRITEBACK |
+					     PAGE_START_WRITEBACK |
 					     PAGE_END_WRITEBACK);
 	btrfs_free_path(path);
 	return ret;
-- 
2.53.0



