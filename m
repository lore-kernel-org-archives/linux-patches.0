Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0646A4FDE58;
	Mon, 31 Aug 2026 13:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183700; cv=none; b=ZRfhvIzk8W++d9eTlVXOiexa5xvB7h931xtmTMuyaHSM923xXp2b4xg443tRtWcIf4TxcVvqP9llxntJxdOpht2OtV2OapPg4i+KYV2PeCL3J/6WIwXsXwwvtQDJrqqDh5YlCcUOHFjC/7iwX2iw9cEoiFuaJphigqCkLfpGPU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183700; c=relaxed/simple;
	bh=GV2On4s5cufwSA7mJgnVInD5cKr0njoiwcLxTwLCuoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPgnEQ0UbkTJP2V6FRQLOK389YNyFrEFjlP2RoAaHTzXMwesnirZaKdxKxrihkRVdUL7i+rsQuDSDLPB1LOchitkV9ff3iChUYb9ZUujLZ5bFGyK0KQOF6NBNIrbkC55yRf1qblzss91iL8N06PpSRoQwOr+K7mgXF1eYKK/Os4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8EUQS/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8EUQS/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2CC1F00ACF;
	Mon, 31 Aug 2026 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183697;
	bh=21R2751j0qPVGYnYzJQp1HrC69RHWcH5KxFDqdcho6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8EUQS/1F8EBXJDoyeF+hib+C89a2BgqAXqNaA9rYWfnNxwYDQcWeAMJFiEzrwwER
	 SxG0jNwFWyUyKUcFg4s6SNiJHxBnuYRdoDYIzlSYYoQDiAkfcGWliVd9cUsgE+pCA3
	 YikRqpQWY0iH5LSz0r02cBAQNBAYSn9A6qKOxeZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 13/76] ext4: protect WRITE_ZEROES written extents with orphan list
Date: Mon, 31 Aug 2026 15:33:45 +0200
Message-ID: <20260831133359.864129005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit f7237a775c8f3e99e0e77b7c10fb626815fb2877 ]

In ext4_alloc_file_blocks(), the WRITE_ZEROES path converts unwritten
extents to written in one transaction, while i_disksize is updated to
cover them only in a later transaction. A crash in between leaves
written extents beyond i_disksize on disk, which fsck will complain
about.

To fix this, add the inode to the orphan list in the same handle that
does the conversion, and remove it once i_disksize has caught up.
Also add a sanity check to ensure conversion does not extend beyond EOF.

Since ext4_alloc_file_blocks() is called from the fallocate() path,
partial allocation is safe. On partial conversion failure, advance
i_disksize only up to the boundary of successfully converted blocks, so
that orphan cleanup sees a consistent state. Document this behavior in
the function comment.

Reported-by: Jan Kara <jack@suse.cz>
Closes: https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260729085918.3336221-3-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 69 insertions(+), 7 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4571,6 +4571,22 @@ retry_remove_space:
 	return err;
 }
 
+/*
+ * Pre-allocate blocks for the range [@offset, @offset + @len). Allocated
+ * blocks are marked as unwritten by default. If EXT4_GET_BLOCKS_ZERO is
+ * set, the allocated blocks are zeroed on disk and their extents are
+ * converted to written state.
+ *
+ * When @new_size is nonzero, the caller intends to extend the file, and
+ * the file size should be updated to the end of the allocated blocks.
+ *
+ * Allocation may partially succeed due to some non-fatal issues. In that
+ * case, i_disksize (and i_size) is advanced up to the successfully
+ * processed portion of the range.
+ *
+ * Return 0 on success, or a negative error code on failure or partial
+ * failure.
+ */
 static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 				  loff_t new_size, int flags)
 {
@@ -4585,6 +4601,7 @@ static int ext4_alloc_file_blocks(struct
 	loff_t epos = 0, old_size = i_size_read(inode);
 	unsigned int blkbits = inode->i_blkbits;
 	bool alloc_zero = false;
+	bool orphan = false;
 
 	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
 	map.m_lblk = offset >> blkbits;
@@ -4659,19 +4676,49 @@ retry:
 
 		if (alloc_zero &&
 		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
+			ext4_lblk_t converted;
+
+			WARN_ON_ONCE(map.m_lblk + map.m_len >
+				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
+
 			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
 						 map.m_len);
-			if (likely(!ret))
-				ret = ext4_convert_unwritten_extents(NULL,
+			if (unlikely(ret))
+				break;
+
+			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
+						    credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				break;
+			}
+
+			ret = ext4_convert_unwritten_extents(handle,
 					inode, (loff_t)map.m_lblk << blkbits,
-					(loff_t)map.m_len << blkbits, NULL);
+					(loff_t)map.m_len << blkbits,
+					&converted);
 			if (ret)
-				break;
+				map.m_len = converted;
+
+			/*
+			 * If blocks beyond i_disksize are converted, add
+			 * the inode to the orphan list and advance the epos.
+			 */
+			if (new_size && converted) {
+				ret2 = ext4_orphan_add(handle, inode);
+				ret = ret ? ret : ret2;
+				orphan = true;
+			}
+
+			ret3 = ext4_journal_stop(handle);
+			ret = ret ? ret : ret3;
 		}
 
 		map.m_lblk += map.m_len;
 		map.m_len = len_lblk = len_lblk - map.m_len;
 		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
+		if (ret)
+			break;
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
@@ -4687,11 +4734,23 @@ retry:
 	if (epos > new_size)
 		epos = new_size;
 
-	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
-	if (IS_ERR(handle))
-		return ret ? ret : PTR_ERR(handle);
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, 2);
+	if (IS_ERR(handle)) {
+		/*
+		 * The conversion has successfully completed. Not much to
+		 * do with the error here so just cleanup the orphan list
+		 * and hope for the best.
+		 */
+		if (orphan && inode->i_nlink)
+			ext4_orphan_del(NULL, inode);
+		ret2 = PTR_ERR(handle);
+		goto out;
+	}
 
 	ext4_update_inode_size(inode, epos);
+	if (orphan && inode->i_nlink)
+		ext4_orphan_del(handle, inode);
+
 	ret2 = ext4_mark_inode_dirty(handle, inode);
 	ext4_update_inode_fsync_trans(handle, inode, 1);
 	ret3 = ext4_journal_stop(handle);
@@ -4699,6 +4758,9 @@ retry:
 
 	if (epos > old_size)
 		pagecache_isize_extended(inode, old_size, epos);
+out:
+	if (ret2)
+		ext4_std_error(inode->i_sb, ret2);
 
 	return ret ? ret : ret2;
 }


