Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2003317A309;
	Fri,  7 Aug 2026 15:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116607; cv=none; b=ceoYzkG4aJTAKxIIqm2Ns/hpufbEqyFb9nWRHFOioIpEl+V3SME67vCOnrYz9Uy5mv0IGl/KW8rZ/uQJURUBqDt27xeZEqTb7nIRrUVZc8bQW6a90+Er9fC4jQQsCqwOrmoDukTpG8/QJCaa6GS6inecou+IVlFMUYbrHUo3vlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116607; c=relaxed/simple;
	bh=6M+YIIBhKSx20YUduVNJVW7hnpHtIHPMEh+YMt7t6EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9sYfgctqW2kwUwd8JxlUmQO+AXZcPvKS5tYayv0PzfprGoVQd227vIOfZICFngzTfH2BkcbFlRicdhebPA16Yj7hiK9Sr9HY07nAxZvVU0Nu31EYXcjzBtcQmpeNNikLczgsEWHPzzK+8rtf+p12ZuExMgK3x96p+RKOrrCU2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnbWXBs/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnbWXBs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823CA1F000E9;
	Fri,  7 Aug 2026 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116606;
	bh=rZrNop2sZGQfBuquENjvsjJWsPr/qqEM/uK0OS9JDlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnbWXBs/pDlDIWsARE/6PHc4aQj2HvNFQPUb8fTuYo4JNywf4TaQudcEKAQfXRARs
	 8CqjNrpa5eDY5nfahhJDIaPPgbZtfnE/u6cU1JhEw25yqzpCVJx9PYn35O7gC3Ay27
	 XgwnggLiSb2qCzIBk6sFz8mV267rCMjK6zfZ6iQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AHN SEOK-YOUNG <iamsyahn@gmail.com>,
	Teng Liu <27rabbitlt@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 028/438] btrfs: warn about extent buffer that can not be released
Date: Fri,  7 Aug 2026 16:33:44 +0200
Message-ID: <20260807143428.608967499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 83f7e52b7ed1c3e03b79123e20b6f6adf8d886bb ]

When we unmount the fs or during mount failures, btrfs will call
invalidate_inode_pages() to release all btree inode folios.

However that function can return -EBUSY if any folios can not be
invalidated.
This can be caused by:

- Some extent buffers are still held by btrfs
  This is a logic error, as we should release all tree root nodes
  during unmount and mount failure handling.

- Some extent buffers are under readahead and haven't yet finished
  These are much rarer but valid cases.
  In that case we should wait for those extent buffers.

Introduce a new helper invalidate_and_check_btree_folios() which will:

- Call invalidate_inode_pages2() and catch its return value
  If it returned 0 as expected, that's great and we can call it a day.

- Otherwise go through each extent buffer in buffer_tree
  Increase the ref by one first for the eb we're checking.
  This is to ensure the eb won't be freed after the readahead is
  finished.

  For ebs that still have EXTENT_BUFFER_READING flag, wait for them to
  finish first.

  After waiting for the readahead, check the refs of the eb and if it's
  still dirty.

  If the eb ref count is greater than 2 (one for the buffer tree, one
  held by us), it means we are still holding the extent buffer somewhere
  else, which is a code bug.

  If the eb is still dirty, it means a bug in transaction handling, e.g.
  the bug fixed by patch "btrfs: only release the dirty pages io tree
  after successful writes".

  For either case, show a warning message about the eb, including its
  bytenr, owner, refs and flags.
  And if it's a debug build, also trigger WARN_ON_ONCE() so that fstests
  can properly catch such situation.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221270
Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
CC: Teng Liu <27rabbitlt@gmail.com>
Tested-by: Teng Liu <27rabbitlt@gmail.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 51a0e8399858 ("btrfs: skip global block reserve accounting for rescue mounts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c   | 53 ++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/extent_io.c |  6 -----
 fs/btrfs/extent_io.h |  6 +++++
 3 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ab92b35fa3cc1..833965b06f90e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3276,6 +3276,55 @@ static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
 	return false;
 }
 
+/*
+ * Try to wait for any metadata readahead, and invalidate all btree folios.
+ *
+ * If the invalidation failed, report any dirty/held extent buffers.
+ */
+static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
+{
+	unsigned long index = 0;
+	struct extent_buffer *eb;
+	int ret;
+
+	ret = invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	if (likely(ret == 0))
+		return;
+
+	/*
+	 * Some btree pages can not be invalidated, this happens when some tree
+	 * blocks are still held (either by readahead or some task is holding a ref).
+	 */
+	rcu_read_lock();
+	xa_for_each(&fs_info->buffer_tree, index, eb) {
+		/* Increase the ref so that the eb won't disappear. */
+		if (!refcount_inc_not_zero(&eb->refs))
+			continue;
+		rcu_read_unlock();
+
+		/* Wait for any readahead first. */
+		if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
+			wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
+				       TASK_UNINTERRUPTIBLE);
+		/*
+		 * The refs threshold is 2, one held by us at the beginning
+		 * of the loop, one for the ownership in the buffer tree.
+		 */
+		if (unlikely(refcount_read(&eb->refs) > 2 || extent_buffer_under_io(eb))) {
+			WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
+			btrfs_warn(fs_info,
+			"unable to release extent buffer %llu owner %llu gen %llu refs %u flags 0x%lx",
+				   eb->start, btrfs_header_owner(eb),
+				   btrfs_header_generation(eb),
+				   refcount_read(&eb->refs), eb->bflags);
+		}
+		free_extent_buffer(eb);
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+}
+
 int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices)
 {
 	u32 sectorsize;
@@ -3706,7 +3755,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (fs_info->data_reloc_root)
 		btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_root);
 	free_root_pointers(fs_info, true);
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	invalidate_and_check_btree_folios(fs_info);
 
 fail_sb_buffer:
 	btrfs_stop_all_workers(fs_info);
@@ -4445,7 +4494,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 * We must make sure there is not any read request to
 	 * submit after we stop all workers.
 	 */
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	invalidate_and_check_btree_folios(fs_info);
 	btrfs_stop_all_workers(fs_info);
 
 	/*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f0bfa8a6218a7..741fd1d4ab2ea 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2877,12 +2877,6 @@ bool try_release_extent_mapping(struct folio *folio, gfp_t mask)
 	return try_release_extent_state(io_tree, folio);
 }
 
-static int extent_buffer_under_io(const struct extent_buffer *eb)
-{
-	return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
-		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
-}
-
 static bool folio_range_has_eb(struct folio *folio)
 {
 	struct btrfs_folio_state *bfs;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b310a5145cf69..7b4152387d886 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -327,6 +327,12 @@ static inline bool extent_buffer_uptodate(const struct extent_buffer *eb)
 	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 }
 
+static inline bool extent_buffer_under_io(const struct extent_buffer *eb)
+{
+	return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
+		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+}
+
 int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
 			 unsigned long start, unsigned long len);
 void read_extent_buffer(const struct extent_buffer *eb, void *dst,
-- 
2.53.0



