Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F72157E6B;
	Wed, 30 Jul 2025 09:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868845; cv=none; b=VE+INFirNLP1TnEK6z1lSyFUm8i/NhjI/PVMAjJPv8YdLiYyWOXF9NycsuJZj4nXCNVYK6U84h7N/Bb2xca3cBWlvTr0eas7GQ00q/Xx6Tt/dJ8WJjazVwFJDLEF0PiPIK/D2+gVa0AfOtO5Ln7rzSOCsAtrcqw3at3ms0sgvKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868845; c=relaxed/simple;
	bh=R4zNsmU58Kc+mZmf8tvyi9JE6qb0U9t/6t7WW0ibrI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wz0Hp4ofnufPZv5lpTo+8wKEtxMd2NRPMPfXK0Il8F8cZLvF8uZTDJZRtx6+V3UHtXZzNZRkc5nFFjUE7nzsWharAxO2l/MkZC2nSlJm6ZotLBDKMMKYNcmoWXIQHSR+NQx4YC/sTgmkxF9vXgPjuvFWc2cIQTYXiABbu5MoDyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJ9cTuBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJ9cTuBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA98C4CEF5;
	Wed, 30 Jul 2025 09:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868845;
	bh=R4zNsmU58Kc+mZmf8tvyi9JE6qb0U9t/6t7WW0ibrI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJ9cTuBvGoJq9xh5YRTUls43Elb6eC+yRq0mz4yvVuN2G9spXBdb55HqHF33YSSTr
	 V3K39Nm23PXYYn/Dua9RYQEfOGUwe95qbYD6CVUWrWCADu+IlmrLqZqMm081xgegSk
	 SLzCVsIfpl5YM5uzDGoCUCbINJXhRgM15+5Tb4mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/117] ext4: move out inode_lock into ext4_fallocate()
Date: Wed, 30 Jul 2025 11:36:00 +0200
Message-ID: <20250730093237.331104562@linuxfoundation.org>
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

[ Upstream commit ea3f17efd36b56c5839289716ba83eaa85893590 ]

Currently, all five sub-functions of ext4_fallocate() acquire the
inode's i_rwsem at the beginning and release it before exiting. This
process can be simplified by factoring out the management of i_rwsem
into the ext4_fallocate() function.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20241220011637.1157197-10-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 29ec9bed2395 ("ext4: fix incorrect punch max_end")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   90 ++++++++++++++++--------------------------------------
 fs/ext4/inode.c   |   13 +++----
 2 files changed, 33 insertions(+), 70 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4579,23 +4579,18 @@ static long ext4_zero_range(struct file
 	int ret, flags, credits;
 
 	trace_ext4_zero_range(inode, offset, len, mode);
+	WARN_ON_ONCE(!inode_is_locked(inode));
 
-	inode_lock(inode);
-
-	/*
-	 * Indirect files do not support unwritten extents
-	 */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
+	/* Indirect files do not support unwritten extents */
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+		return -EOPNOTSUPP;
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 	    (end > inode->i_size || end > EXT4_I(inode)->i_disksize)) {
 		new_size = end;
 		ret = inode_newsize_ok(inode, new_size);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	/* Wait all existing dio workers, newcomers will block on i_rwsem */
@@ -4603,7 +4598,7 @@ static long ext4_zero_range(struct file
 
 	ret = file_modified(file);
 	if (ret)
-		goto out;
+		return ret;
 
 	/*
 	 * Prevent page faults from reinstantiating pages we have released
@@ -4685,8 +4680,6 @@ out_handle:
 	ext4_journal_stop(handle);
 out_invalidate_lock:
 	filemap_invalidate_unlock(mapping);
-out:
-	inode_unlock(inode);
 	return ret;
 }
 
@@ -4700,12 +4693,11 @@ static long ext4_do_fallocate(struct fil
 	int ret;
 
 	trace_ext4_fallocate_enter(inode, offset, len, mode);
+	WARN_ON_ONCE(!inode_is_locked(inode));
 
 	start_lblk = offset >> inode->i_blkbits;
 	len_lblk = EXT4_MAX_BLOCKS(len, offset, inode->i_blkbits);
 
-	inode_lock(inode);
-
 	/* We only support preallocation for extent-based files only. */
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 		ret = -EOPNOTSUPP;
@@ -4737,7 +4729,6 @@ static long ext4_do_fallocate(struct fil
 					EXT4_I(inode)->i_sync_tid);
 	}
 out:
-	inode_unlock(inode);
 	trace_ext4_fallocate_exit(inode, offset, len_lblk, ret);
 	return ret;
 }
@@ -4772,9 +4763,8 @@ long ext4_fallocate(struct file *file, i
 
 	inode_lock(inode);
 	ret = ext4_convert_inline_data(inode);
-	inode_unlock(inode);
 	if (ret)
-		return ret;
+		goto out_inode_lock;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		ret = ext4_punch_hole(file, offset, len);
@@ -4786,7 +4776,8 @@ long ext4_fallocate(struct file *file, i
 		ret = ext4_zero_range(file, offset, len, mode);
 	else
 		ret = ext4_do_fallocate(file, offset, len, mode);
-
+out_inode_lock:
+	inode_unlock(inode);
 	return ret;
 }
 
@@ -5291,36 +5282,27 @@ static int ext4_collapse_range(struct fi
 	int ret;
 
 	trace_ext4_collapse_range(inode, offset, len);
-
-	inode_lock(inode);
+	WARN_ON_ONCE(!inode_is_locked(inode));
 
 	/* Currently just for extent based files */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		return -EOPNOTSUPP;
 	/* Collapse range works only on fs cluster size aligned regions. */
-	if (!IS_ALIGNED(offset | len, EXT4_CLUSTER_SIZE(sb))) {
-		ret = -EINVAL;
-		goto out;
-	}
-
+	if (!IS_ALIGNED(offset | len, EXT4_CLUSTER_SIZE(sb)))
+		return -EINVAL;
 	/*
 	 * There is no need to overlap collapse range with EOF, in which case
 	 * it is effectively a truncate operation
 	 */
-	if (end >= inode->i_size) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (end >= inode->i_size)
+		return -EINVAL;
 
 	/* Wait for existing dio to complete */
 	inode_dio_wait(inode);
 
 	ret = file_modified(file);
 	if (ret)
-		goto out;
+		return ret;
 
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
@@ -5395,8 +5377,6 @@ out_handle:
 	ext4_journal_stop(handle);
 out_invalidate_lock:
 	filemap_invalidate_unlock(mapping);
-out:
-	inode_unlock(inode);
 	return ret;
 }
 
@@ -5422,39 +5402,27 @@ static int ext4_insert_range(struct file
 	loff_t start;
 
 	trace_ext4_insert_range(inode, offset, len);
-
-	inode_lock(inode);
+	WARN_ON_ONCE(!inode_is_locked(inode));
 
 	/* Currently just for extent based files */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		return -EOPNOTSUPP;
 	/* Insert range works only on fs cluster size aligned regions. */
-	if (!IS_ALIGNED(offset | len, EXT4_CLUSTER_SIZE(sb))) {
-		ret = -EINVAL;
-		goto out;
-	}
-
+	if (!IS_ALIGNED(offset | len, EXT4_CLUSTER_SIZE(sb)))
+		return -EINVAL;
 	/* Offset must be less than i_size */
-	if (offset >= inode->i_size) {
-		ret = -EINVAL;
-		goto out;
-	}
-
+	if (offset >= inode->i_size)
+		return -EINVAL;
 	/* Check whether the maximum file size would be exceeded */
-	if (len > inode->i_sb->s_maxbytes - inode->i_size) {
-		ret = -EFBIG;
-		goto out;
-	}
+	if (len > inode->i_sb->s_maxbytes - inode->i_size)
+		return -EFBIG;
 
 	/* Wait for existing dio to complete */
 	inode_dio_wait(inode);
 
 	ret = file_modified(file);
 	if (ret)
-		goto out;
+		return ret;
 
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
@@ -5555,8 +5523,6 @@ out_handle:
 	ext4_journal_stop(handle);
 out_invalidate_lock:
 	filemap_invalidate_unlock(mapping);
-out:
-	inode_unlock(inode);
 	return ret;
 }
 
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3997,15 +3997,14 @@ int ext4_punch_hole(struct file *file, l
 	loff_t end = offset + length;
 	handle_t *handle;
 	unsigned int credits;
-	int ret = 0;
+	int ret;
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
-
-	inode_lock(inode);
+	WARN_ON_ONCE(!inode_is_locked(inode));
 
 	/* No need to punch hole beyond i_size */
 	if (offset >= inode->i_size)
-		goto out;
+		return 0;
 
 	/*
 	 * If the hole extends beyond i_size, set the hole to end after
@@ -4025,7 +4024,7 @@ int ext4_punch_hole(struct file *file, l
 	if (!IS_ALIGNED(offset | end, sb->s_blocksize)) {
 		ret = ext4_inode_attach_jinode(inode);
 		if (ret < 0)
-			goto out;
+			return ret;
 	}
 
 	/* Wait all existing dio workers, newcomers will block on i_rwsem */
@@ -4033,7 +4032,7 @@ int ext4_punch_hole(struct file *file, l
 
 	ret = file_modified(file);
 	if (ret)
-		goto out;
+		return ret;
 
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
@@ -4109,8 +4108,6 @@ out_handle:
 	ext4_journal_stop(handle);
 out_invalidate_lock:
 	filemap_invalidate_unlock(mapping);
-out:
-	inode_unlock(inode);
 	return ret;
 }
 


