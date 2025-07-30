Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0C9266591;
	Wed, 30 Jul 2025 09:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868834; cv=none; b=cXxHqEbTmcAFTdrYFAVfuWckzUXRywbnnWKUTAMfVfvj2ovf3EhIpRuQaU/eB+C8B+9z2YMeGimgusTraUB9YzCq0jG3oZL0g/IGcz6ODvtK1rph7qUzUGS6wNaMEtECw13JAOe8fz4ypm9W1v7sjBpkDwlGrQILoCbtgqyqWwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868834; c=relaxed/simple;
	bh=5m25iK/mibKwK/7DfvXncdhzj2NnfvUPbUTnnyAmq8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAtD4bumjjAXPfLZPiAtCem6BcqO7ScldMqTDn9XejDc+ow3HIQxvT5+LdyeIlGingCsOmPL7/uMvd5SOe2qYYJI0BheDerp97GmiiMdbRFL7PyV98hts7A9V5g9mQGycAJmOPa206cvuL3Xk9P09NoqN2fNXTg8q3BtwPwXt98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWJ/gWdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWJ/gWdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D311C4CEF5;
	Wed, 30 Jul 2025 09:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868833;
	bh=5m25iK/mibKwK/7DfvXncdhzj2NnfvUPbUTnnyAmq8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWJ/gWdo2Y5sCYnid3dN+xMu/TQ6lbVTmli+DP8F+NZBHm6/obs6ncUpcVAqeMWJx
	 iOnXr6kuICuC/NZ/FAv5O1sQ+q8FvMNlMl1A+vlrfNWOaYdjQ1lGsn6EkasNq3FEUF
	 0nsn7coKJidRncdpnAJ3xDC+S51ChytKlhz7fxhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/117] ext4: refactor ext4_collapse_range()
Date: Wed, 30 Jul 2025 11:35:57 +0200
Message-ID: <20250730093237.202041525@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 162e3c5ad1672ef41dccfb28ad198c704b8aa9e7 ]

Simplify ext4_collapse_range() and align its code style with that of
ext4_zero_range() and ext4_punch_hole(). Refactor it by: a) renaming
variables, b) removing redundant input parameter checks and moving
the remaining checks under i_rwsem in preparation for future
refactoring, and c) renaming the three stale error tags.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20241220011637.1157197-7-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 29ec9bed2395 ("ext4: fix incorrect punch max_end")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |  103 +++++++++++++++++++++++++-----------------------------
 1 file changed, 48 insertions(+), 55 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5288,43 +5288,36 @@ static int ext4_collapse_range(struct fi
 	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
-	ext4_lblk_t punch_start, punch_stop;
+	loff_t end = offset + len;
+	ext4_lblk_t start_lblk, end_lblk;
 	handle_t *handle;
 	unsigned int credits;
-	loff_t new_size, ioffset;
+	loff_t start, new_size;
 	int ret;
 
-	/*
-	 * We need to test this early because xfstests assumes that a
-	 * collapse range of (0, 1) will return EOPNOTSUPP if the file
-	 * system does not support collapse range.
-	 */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		return -EOPNOTSUPP;
+	trace_ext4_collapse_range(inode, offset, len);
 
-	/* Collapse range works only on fs cluster size aligned regions. */
-	if (!IS_ALIGNED(offset | len, EXT4_CLUSTER_SIZE(sb)))
-		return -EINVAL;
+	inode_lock(inode);
 
-	trace_ext4_collapse_range(inode, offset, len);
+	/* Currently just for extent based files */
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
-	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
-	punch_stop = (offset + len) >> EXT4_BLOCK_SIZE_BITS(sb);
+	/* Collapse range works only on fs cluster size aligned regions. */
+	if (!IS_ALIGNED(offset | len, EXT4_CLUSTER_SIZE(sb))) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	inode_lock(inode);
 	/*
 	 * There is no need to overlap collapse range with EOF, in which case
 	 * it is effectively a truncate operation
 	 */
-	if (offset + len >= inode->i_size) {
+	if (end >= inode->i_size) {
 		ret = -EINVAL;
-		goto out_mutex;
-	}
-
-	/* Currently just for extent based files */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		ret = -EOPNOTSUPP;
-		goto out_mutex;
+		goto out;
 	}
 
 	/* Wait for existing dio to complete */
@@ -5332,7 +5325,7 @@ static int ext4_collapse_range(struct fi
 
 	ret = file_modified(file);
 	if (ret)
-		goto out_mutex;
+		goto out;
 
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
@@ -5342,55 +5335,52 @@ static int ext4_collapse_range(struct fi
 
 	ret = ext4_break_layouts(inode);
 	if (ret)
-		goto out_mmap;
+		goto out_invalidate_lock;
 
 	/*
+	 * Write tail of the last page before removed range and data that
+	 * will be shifted since they will get removed from the page cache
+	 * below. We are also protected from pages becoming dirty by
+	 * i_rwsem and invalidate_lock.
 	 * Need to round down offset to be aligned with page size boundary
 	 * for page size > block size.
 	 */
-	ioffset = round_down(offset, PAGE_SIZE);
-	/*
-	 * Write tail of the last page before removed range since it will get
-	 * removed from the page cache below.
-	 */
-	ret = filemap_write_and_wait_range(mapping, ioffset, offset);
-	if (ret)
-		goto out_mmap;
-	/*
-	 * Write data that will be shifted to preserve them when discarding
-	 * page cache below. We are also protected from pages becoming dirty
-	 * by i_rwsem and invalidate_lock.
-	 */
-	ret = filemap_write_and_wait_range(mapping, offset + len,
-					   LLONG_MAX);
+	start = round_down(offset, PAGE_SIZE);
+	ret = filemap_write_and_wait_range(mapping, start, offset);
+	if (!ret)
+		ret = filemap_write_and_wait_range(mapping, end, LLONG_MAX);
 	if (ret)
-		goto out_mmap;
-	truncate_pagecache(inode, ioffset);
+		goto out_invalidate_lock;
+
+	truncate_pagecache(inode, start);
 
 	credits = ext4_writepage_trans_blocks(inode);
 	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
-		goto out_mmap;
+		goto out_invalidate_lock;
 	}
 	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
+	start_lblk = offset >> inode->i_blkbits;
+	end_lblk = (offset + len) >> inode->i_blkbits;
+
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_discard_preallocations(inode);
-	ext4_es_remove_extent(inode, punch_start, EXT_MAX_BLOCKS - punch_start);
+	ext4_es_remove_extent(inode, start_lblk, EXT_MAX_BLOCKS - start_lblk);
 
-	ret = ext4_ext_remove_space(inode, punch_start, punch_stop - 1);
+	ret = ext4_ext_remove_space(inode, start_lblk, end_lblk - 1);
 	if (ret) {
 		up_write(&EXT4_I(inode)->i_data_sem);
-		goto out_stop;
+		goto out_handle;
 	}
 	ext4_discard_preallocations(inode);
 
-	ret = ext4_ext_shift_extents(inode, handle, punch_stop,
-				     punch_stop - punch_start, SHIFT_LEFT);
+	ret = ext4_ext_shift_extents(inode, handle, end_lblk,
+				     end_lblk - start_lblk, SHIFT_LEFT);
 	if (ret) {
 		up_write(&EXT4_I(inode)->i_data_sem);
-		goto out_stop;
+		goto out_handle;
 	}
 
 	new_size = inode->i_size - len;
@@ -5398,16 +5388,19 @@ static int ext4_collapse_range(struct fi
 	EXT4_I(inode)->i_disksize = new_size;
 
 	up_write(&EXT4_I(inode)->i_data_sem);
-	if (IS_SYNC(inode))
-		ext4_handle_sync(handle);
 	ret = ext4_mark_inode_dirty(handle, inode);
+	if (ret)
+		goto out_handle;
+
 	ext4_update_inode_fsync_trans(handle, inode, 1);
+	if (IS_SYNC(inode))
+		ext4_handle_sync(handle);
 
-out_stop:
+out_handle:
 	ext4_journal_stop(handle);
-out_mmap:
+out_invalidate_lock:
 	filemap_invalidate_unlock(mapping);
-out_mutex:
+out:
 	inode_unlock(inode);
 	return ret;
 }


