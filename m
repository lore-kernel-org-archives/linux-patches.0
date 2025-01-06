Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3564815B0E2;
	Mon,  6 Jan 2025 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177033; cv=none; b=NnTfu/MNrII2HJEncr5aIljL5/dGoBcoOQAbxzpVQMSaw7ZC4TMSaDV7TQ1NSiUOue1k3Qe3MwlI8nEpn0F2P+2h8j2GtZge3fW06SWwMkOiUD98cA7/vXGws6spSezfPLo54Afz4TgV72JrzjLr7z2ZVte+nHZadMTd4pXCtXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177033; c=relaxed/simple;
	bh=b4TnB7AwrQBEmvmhg1R9qPnZXbAAXOKM9i7M1JlSU0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYTSn3mkgEEFyTX7eDs2pIfpDICvsFQi9E0LVmBFrUiyorrk9bJD078Fss5zc7rvMhpwU95ruxOPHYpNq1M/gRwlVV7S9M/hmb6K9KamV/GsGj62IpPTR6pD9TqcTBixVz3yr01fneN5Q4KnSELGNr3EifJDh2B7txte9qk9/6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6TAK4co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6TAK4co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1084C4CEDF;
	Mon,  6 Jan 2025 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177033;
	bh=b4TnB7AwrQBEmvmhg1R9qPnZXbAAXOKM9i7M1JlSU0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6TAK4co9v23AdQEJPp7o15Aajqi9WLhLvv6tnIwSySNjooCh8HeXLW7MO6/NjQYQ
	 DliCsAh5bGo2JYNHzZ24t5Df7sUgrK8Nu7/kGG1N7mRDlQxbO7Kv3mwwkhxxqdjamI
	 NT/W81qFY0Sa5gy93Y4RPedbMqduw3lRb9rbFMZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/222] ext4: partial zero eof block on unaligned inode size extension
Date: Mon,  6 Jan 2025 16:13:45 +0100
Message-ID: <20250106151151.405495844@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit c7fc0366c65628fd69bfc310affec4918199aae2 ]

Using mapped writes, it's technically possible to expose stale
post-eof data on a truncate up operation. Consider the following
example:

$ xfs_io -fc "pwrite 0 2k" -c "mmap 0 4k" -c "mwrite 2k 2k" \
	-c "truncate 8k" -c "pread -v 2k 16" <file>
...
00000800:  58 58 58 58 58 58 58 58 58 58 58 58 58 58 58 58  XXXXXXXXXXXXXXXX
...

This shows that the post-eof data written via mwrite lands within
EOF after a truncate up. While this is deliberate of the test case,
behavior is somewhat unpredictable because writeback does post-eof
zeroing, and writeback can occur at any time in the background. For
example, an fsync inserted between the mwrite and truncate causes
the subsequent read to instead return zeroes. This basically means
that there is a race window in this situation between any subsequent
extending operation and writeback that dictates whether post-eof
data is exposed to the file or zeroed.

To prevent this problem, perform partial block zeroing as part of
the various inode size extending operations that are susceptible to
it. For truncate extension, zero around the original eof similar to
how truncate down does partial zeroing of the new eof. For extension
via writes and fallocate related operations, zero the newly exposed
range of the file to cover any partial zeroing that must occur at
the original and new eof blocks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Link: https://patch.msgid.link/20240919160741.208162-2-bfoster@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c |  7 ++++++-
 fs/ext4/inode.c   | 51 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f2341d99d09f..32218ac7f50f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4475,7 +4475,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	int depth = 0;
 	struct ext4_map_blocks map;
 	unsigned int credits;
-	loff_t epos;
+	loff_t epos, old_size = i_size_read(inode);
 
 	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
 	map.m_lblk = offset;
@@ -4534,6 +4534,11 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 			if (ext4_update_inode_size(inode, epos) & 0x1)
 				inode_set_mtime_to_ts(inode,
 						      inode_get_ctime(inode));
+			if (epos > old_size) {
+				pagecache_isize_extended(inode, old_size, epos);
+				ext4_zero_partial_blocks(handle, inode,
+						     old_size, epos - old_size);
+			}
 		}
 		ret2 = ext4_mark_inode_dirty(handle, inode);
 		ext4_update_inode_fsync_trans(handle, inode, 1);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 04f25a04f35a..19d7bcf16ebb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1328,8 +1328,10 @@ static int ext4_write_end(struct file *file,
 	folio_unlock(folio);
 	folio_put(folio);
 
-	if (old_size < pos && !verity)
+	if (old_size < pos && !verity) {
 		pagecache_isize_extended(inode, old_size, pos);
+		ext4_zero_partial_blocks(handle, inode, old_size, pos - old_size);
+	}
 	/*
 	 * Don't mark the inode dirty under folio lock. First, it unnecessarily
 	 * makes the holding time of folio lock longer. Second, it forces lock
@@ -1445,8 +1447,10 @@ static int ext4_journalled_write_end(struct file *file,
 	folio_unlock(folio);
 	folio_put(folio);
 
-	if (old_size < pos && !verity)
+	if (old_size < pos && !verity) {
 		pagecache_isize_extended(inode, old_size, pos);
+		ext4_zero_partial_blocks(handle, inode, old_size, pos - old_size);
+	}
 
 	if (size_changed) {
 		ret2 = ext4_mark_inode_dirty(handle, inode);
@@ -2971,7 +2975,8 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	loff_t old_size = inode->i_size;
 	bool disksize_changed = false;
-	loff_t new_i_size;
+	loff_t new_i_size, zero_len = 0;
+	handle_t *handle;
 
 	if (unlikely(!folio_buffers(folio))) {
 		folio_unlock(folio);
@@ -3015,18 +3020,21 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	folio_unlock(folio);
 	folio_put(folio);
 
-	if (old_size < pos)
+	if (pos > old_size) {
 		pagecache_isize_extended(inode, old_size, pos);
+		zero_len = pos - old_size;
+	}
 
-	if (disksize_changed) {
-		handle_t *handle;
+	if (!disksize_changed && !zero_len)
+		return copied;
 
-		handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
-		if (IS_ERR(handle))
-			return PTR_ERR(handle);
-		ext4_mark_inode_dirty(handle, inode);
-		ext4_journal_stop(handle);
-	}
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+	if (zero_len)
+		ext4_zero_partial_blocks(handle, inode, old_size, zero_len);
+	ext4_mark_inode_dirty(handle, inode);
+	ext4_journal_stop(handle);
 
 	return copied;
 }
@@ -5437,6 +5445,14 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		}
 
 		if (attr->ia_size != inode->i_size) {
+			/* attach jbd2 jinode for EOF folio tail zeroing */
+			if (attr->ia_size & (inode->i_sb->s_blocksize - 1) ||
+			    oldsize & (inode->i_sb->s_blocksize - 1)) {
+				error = ext4_inode_attach_jinode(inode);
+				if (error)
+					goto err_out;
+			}
+
 			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
 			if (IS_ERR(handle)) {
 				error = PTR_ERR(handle);
@@ -5447,12 +5463,17 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 				orphan = 1;
 			}
 			/*
-			 * Update c/mtime on truncate up, ext4_truncate() will
-			 * update c/mtime in shrink case below
+			 * Update c/mtime and tail zero the EOF folio on
+			 * truncate up. ext4_truncate() handles the shrink case
+			 * below.
 			 */
-			if (!shrink)
+			if (!shrink) {
 				inode_set_mtime_to_ts(inode,
 						      inode_set_ctime_current(inode));
+				if (oldsize & (inode->i_sb->s_blocksize - 1))
+					ext4_block_truncate_page(handle,
+							inode->i_mapping, oldsize);
+			}
 
 			if (shrink)
 				ext4_fc_track_range(handle, inode,
-- 
2.39.5



