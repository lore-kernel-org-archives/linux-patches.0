Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216472;
	b=bRP3DaejzRvNoogYLNxNWyUlF0tG/PwOaw5UU6uwk7A9AwUSFEmDw9ns0kiidWcQB3oE
	 Z3g7itH9qbP5vRXzAIioS3lrFjN4XbShjdhE9eDwRiH6pXRJH+35NEQqTrYo8vArCAYlO
	 CxRG54ZUNk9syJeCf0ilf07zoBrR6kNlJKyOToCq48PMhlI3cPM1kIPVPjuZ5dnZt7GPK
	 fQGtdN4Hevb9JaVlUpqDxPjur/eE2gXstwX6CHTidGPa56+ezKj6pRaoYQt3xoBwkSBdY
	 qP6nJOyvjHs0B4/lDVLCfCuwa5kTVfQepVfWrQGLn2ly2BNWsIacgqbwog9S41rv4Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L0I67ogcU4rF4z/NbDd2PRRDr9UkXIGnalwKEDR5ILQ=;
	b=5SVxTfy203jP2JfPjfh5uVrbdAeeaXgMgwSWzhAEgBGiYHFw2TOAIcJh85qBsojLfRQ3
	 S37lUsRHD80GYI3FWGqaWwFJcDcAeClPX6wUyUXENKVcW7LrlkxEnb3EtMkwxAOLTW6wx
	 jYCjK2T+6fEL02I9MO/JyiwOD5yQuCfNIfSvd/mo12s057pYE2p7/ByfR60fwgLoYMsP7
	 2uonuXrvqGNfsAe4G1QoabO9g4U7fZhzFn3YjPnWBZw/mnPWlQYgbARNbdmXg7Gi0YocL
	 +alIkIKjTkFbmECjtisspFFQBLrpdNRhb8AaLlkyaX8B4haW+bsrQuCEHH834npWIrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WpLtKtNG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE8F606A321;
	Wed, 28 Oct 2026 19:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WpLtKtNG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81861F01825;
	Wed, 28 Oct 2026 19:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216472;
	bh=L0I67ogcU4rF4z/NbDd2PRRDr9UkXIGnalwKEDR5ILQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WpLtKtNG7ibM2zBmHwYpKHFSIRSeJqcue2NzQk/3UWDVh/PNoEaL0e93zjspKk4B0
	 nCN57a7r4G8hAC3/tbVnoeuw2fE1aRuj96gA3kr/wghtORawziwJyPQ+mqcfsmz3Sb
	 HAaewxKL0VhwyaP1z9/cE/34qyx4EoTEo91MLVV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1569/1887] btrfs: always wait for ordered extents to avoid OE races
Date: Wed, 28 Oct 2026 18:01:05 +0100
Message-ID: <20261028170535.171662733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit ec78575dde998c21be7e0cb2503b5620f34b6255 ]

[BUG]
Syzbot reported a bug that there can be conflicting OEs for the same
range:

  BTRFS critical (device loop4): panic in insert_ordered_extent:264: overlapping ordered extents, existing oe file_offset 16384 num_bytes 430080 flags 0x1089, new oe file_offset 16384 num_bytes 430080 flags 0x80 (errno=-17 Object alrea[  179.162726][ T6897] BTRFS critical (device loop4): panic in insert_ordered_extent:264: overlapping ordered extents, existing oe file_offset 16384 num_bytes 430080 flags 0x1089, new oe file_offset 16384 num_bytes 430080 flags 0x80 (errno=-17 Object already exists)
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/ordered-data.c:264!
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
  RIP: 0010:btrfs_alloc_ordered_extent+0x943/0xad0
  Call Trace:
   <TASK>
   cow_file_range+0x744/0x12a0
   fallback_to_cow+0x5ea/0xa00
   run_delalloc_nocow+0x110c/0x17a0
   btrfs_run_delalloc_range+0xbe4/0x1c20
   writepage_delalloc+0x104d/0x1ba0
   btrfs_writepages+0x1667/0x28b0
   do_writepages+0x338/0x560
   filemap_fdatawrite_range+0x1f2/0x300
   btrfs_fdatawrite_range+0x54/0xf0
   btrfs_direct_write+0x6a0/0xc30
   btrfs_do_write_iter+0x329/0x790
   do_iter_readv_writev+0x624/0x8d0
   vfs_writev+0x34c/0x990
   __se_sys_pwritev2+0x17a/0x2a0
   do_syscall_64+0x174/0x580
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  ---[ end trace 0000000000000000 ]---

[CAUSE]
Since commit ff66fe666233 ("btrfs: fix incorrect buffered IO fallback
for append direct writes"), if the direct IO finished short, we will
revert the isize back to the original one, so that append writes can be
respected during the buffered fallback.

Normally we rely on lock_and_cleanup_extent_if_need() function during
buffered writeback to wait for any existing ordered extents.

But that ordered extent waiting only happens if the start_pos is inside
the isize.
Since we have reverted the isize during failed direct IO, we will not
wait for any ordered extents.

This means we can have a race where the direct IO OE is still in the
tree, finished but not yet removed, then we're inserting the OE for the
buffered write, causing the above crash.

[FIX]
Make the OE wait to be unconditional, to handle the reverted isize
situation.

And since lock_and_cleanup_extent_if_need() now either lock the
extents or return -EAGAIN, also remove the branches that handles
no-extent-locked cases, and rename it to remove the "_if_need" suffix.

The following micro benchmark shows the runtime difference for
btrfs_buffered_write(), doing `xfs_io -f -c "pwrite 0 1m"` workload,
all values are the average runtime in nano seconds.

      function runtime              |   before    |     after
 -----------------------------------+-------------+---------------
 lock_and_cleanup_extent_if_need()  |     58.2    |    183.0
 btrfs_buffered_write()             |   2115.6    |   2973.3

The overall runtime of btrfs_buffered_write() is still pretty
tiny (still less than 3 micro seconds), I'd say the extra cost is still
acceptable.

An alternative to fix this problem is to wait ordered extents during
iomap_end() where the isize revert is done.

But that solution will break nowait requirement, as if a nowait direct
IO finished short, we have to wait for the OEs unconditionally or the
next append buffered IO can still hit the same problem.

So here we have to move the wait cost to buffered write, but at least
the code is slightly more streamline.

Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
Fixes: ff66fe666233 ("btrfs: fix incorrect buffered IO fallback for append direct writes")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 103 ++++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 61 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0970ec776ff8e..d34407035b6a1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -949,69 +949,63 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
 
 /*
  * This function locks the extent and properly waits for data=ordered extents
- * to finish before allowing the pages to be modified if need.
+ * to finish before allowing the pages to be modified.
  *
  * The return value:
- * 1 - the extent is locked
- * 0 - the extent is not locked, and everything is OK
+ * 0 - the extent is locked
  * -EAGAIN - need re-prepare the pages
  * the other < 0 number - Something wrong happens
  */
 static noinline int
-lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
-				size_t num_pages, loff_t pos,
-				size_t write_bytes,
-				u64 *lockstart, u64 *lockend, bool nowait,
-				struct extent_state **cached_state)
+lock_and_cleanup_extent(struct btrfs_inode *inode, struct page **pages,
+			size_t num_pages, loff_t pos,
+			size_t write_bytes,
+			u64 *lockstart, u64 *lockend, bool nowait,
+			struct extent_state **cached_state)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct btrfs_ordered_extent *ordered;
 	u64 start_pos;
 	u64 last_pos;
 	int i;
-	int ret = 0;
 
 	start_pos = round_down(pos, fs_info->sectorsize);
 	last_pos = round_up(pos + write_bytes, fs_info->sectorsize) - 1;
 
-	if (start_pos < inode->vfs_inode.i_size) {
-		struct btrfs_ordered_extent *ordered;
-
-		if (nowait) {
-			if (!try_lock_extent(&inode->io_tree, start_pos, last_pos)) {
-				for (i = 0; i < num_pages; i++) {
-					unlock_page(pages[i]);
-					put_page(pages[i]);
-					pages[i] = NULL;
-				}
-
-				return -EAGAIN;
-			}
-		} else {
-			lock_extent(&inode->io_tree, start_pos, last_pos, cached_state);
-		}
-
-		ordered = btrfs_lookup_ordered_range(inode, start_pos,
-						     last_pos - start_pos + 1);
-		if (ordered &&
-		    ordered->file_offset + ordered->num_bytes > start_pos &&
-		    ordered->file_offset <= last_pos) {
-			unlock_extent(&inode->io_tree, start_pos, last_pos,
-				      cached_state);
+	if (nowait) {
+		if (!try_lock_extent(&inode->io_tree, start_pos, last_pos)) {
 			for (i = 0; i < num_pages; i++) {
 				unlock_page(pages[i]);
 				put_page(pages[i]);
+				pages[i] = NULL;
 			}
-			btrfs_start_ordered_extent(ordered, 1);
-			btrfs_put_ordered_extent(ordered);
+
 			return -EAGAIN;
 		}
-		if (ordered)
-			btrfs_put_ordered_extent(ordered);
+	} else {
+		lock_extent(&inode->io_tree, start_pos, last_pos, cached_state);
+	}
 
-		*lockstart = start_pos;
-		*lockend = last_pos;
-		ret = 1;
+	ordered = btrfs_lookup_ordered_range(inode, start_pos,
+					     last_pos - start_pos + 1);
+	if (ordered &&
+	    ordered->file_offset + ordered->num_bytes > start_pos &&
+	    ordered->file_offset <= last_pos) {
+		unlock_extent(&inode->io_tree, start_pos, last_pos,
+			      cached_state);
+		for (i = 0; i < num_pages; i++) {
+			unlock_page(pages[i]);
+			put_page(pages[i]);
+		}
+		btrfs_start_ordered_extent(ordered, 1);
+		btrfs_put_ordered_extent(ordered);
+		return -EAGAIN;
 	}
+	if (ordered)
+		btrfs_put_ordered_extent(ordered);
+
+	*lockstart = start_pos;
+	*lockend = last_pos;
 
 	/*
 	 * We should be called after prepare_pages() which should have locked
@@ -1020,7 +1014,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 	for (i = 0; i < num_pages; i++)
 		WARN_ON(!PageLocked(pages[i]));
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -1214,7 +1208,6 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		size_t copied;
 		size_t dirty_sectors;
 		size_t num_sectors;
-		int extents_locked;
 
 		/*
 		 * Fault pages before locking them in prepare_pages
@@ -1298,17 +1291,15 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 			break;
 		}
 
-		extents_locked = lock_and_cleanup_extent_if_need(
-				BTRFS_I(inode), pages,
-				num_pages, pos, write_bytes, &lockstart,
-				&lockend, nowait, &cached_state);
-		if (extents_locked < 0) {
-			if (!nowait && extents_locked == -EAGAIN)
+		ret = lock_and_cleanup_extent(BTRFS_I(inode), pages,
+					       num_pages, pos, write_bytes, &lockstart,
+					       &lockend, nowait, &cached_state);
+		if (ret < 0) {
+			if (!nowait && ret == -EAGAIN)
 				goto again;
 
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
 						       reserve_bytes);
-			ret = extents_locked;
 			break;
 		}
 
@@ -1361,18 +1352,8 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 					dirty_pages, pos, copied,
 					&cached_state, only_release_metadata);
 
-		/*
-		 * If we have not locked the extent range, because the range's
-		 * start offset is >= i_size, we might still have a non-NULL
-		 * cached extent state, acquired while marking the extent range
-		 * as delalloc through btrfs_dirty_pages(). Therefore free any
-		 * possible cached extent state to avoid a memory leak.
-		 */
-		if (extents_locked)
-			unlock_extent(&BTRFS_I(inode)->io_tree, lockstart,
-				      lockend, &cached_state);
-		else
-			free_extent_state(cached_state);
+		unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+			      &cached_state);
 
 		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes);
 		if (ret) {
-- 
2.53.0



