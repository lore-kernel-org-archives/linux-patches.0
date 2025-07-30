Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F5B255F5C;
	Wed, 30 Jul 2025 09:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868840; cv=none; b=p9UsRJvD2CQVl9cec/vLsa6Nn2fZkw3BWGb0/lfcRLSmX8iyt7Or/fPl1MtzuhwiNjWcKc93InDgUfiK9sE2m1Cv9hQV2ViEebPlPFlQXDNobwqP6it3pApfLXD7Z407T9shac1ZV3vHzI10nhogGHSxh4r/iVcFY5H+clFZWOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868840; c=relaxed/simple;
	bh=QrOFzoNlhFRFRileKoK8rJ4TvvLrsIFEbN8mdeBk8UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i68gamEfh6XH2Op9GNsP5266VZ/Vp9BrzCfnE7aNeXFSZ6GXPhLo6Cba1X7LdT7WktiKCndSb6W3/CDAQWHL25JrI7bPsUhHzxMRpN2vdBm4KnA0syUKGFRikZ1eBYLIwe+O8W/kEJRQ4s/6M3PKtYMpz9aM3Urj6hFOdl0ieGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EU4Wg697; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EU4Wg697"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01132C4CEF5;
	Wed, 30 Jul 2025 09:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868840;
	bh=QrOFzoNlhFRFRileKoK8rJ4TvvLrsIFEbN8mdeBk8UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EU4Wg697OjdxTN1BYdudVF+kpW1zreepvA80DbEo9BX3F0pFe3QMU9oBwev4WFduH
	 fDKV4h+NbWItER075ATmbYiZrkpkD7bdgklq/yqoLgWh0itxvStE9Z84TXSa8ttPcs
	 82WIizjENyecSuviDk9U4nQdqgFXg5IusEmLTf6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/117] ext4: factor out ext4_do_fallocate()
Date: Wed, 30 Jul 2025 11:35:59 +0200
Message-ID: <20250730093237.290345462@linuxfoundation.org>
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

[ Upstream commit fd2f764826df5489b849a8937b5a093aae5b1816 ]

Now the real job of normal fallocate are open coded in ext4_fallocate(),
factor out a new helper ext4_do_fallocate() to do the real job, like
others functions (e.g. ext4_zero_range()) in ext4_fallocate() do, this
can make the code more clear, no functional changes.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20241220011637.1157197-9-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 29ec9bed2395 ("ext4: fix incorrect punch max_end")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |  125 +++++++++++++++++++++++++-----------------------------
 1 file changed, 60 insertions(+), 65 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4690,6 +4690,58 @@ out:
 	return ret;
 }
 
+static long ext4_do_fallocate(struct file *file, loff_t offset,
+			      loff_t len, int mode)
+{
+	struct inode *inode = file_inode(file);
+	loff_t end = offset + len;
+	loff_t new_size = 0;
+	ext4_lblk_t start_lblk, len_lblk;
+	int ret;
+
+	trace_ext4_fallocate_enter(inode, offset, len, mode);
+
+	start_lblk = offset >> inode->i_blkbits;
+	len_lblk = EXT4_MAX_BLOCKS(len, offset, inode->i_blkbits);
+
+	inode_lock(inode);
+
+	/* We only support preallocation for extent-based files only. */
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	    (end > inode->i_size || end > EXT4_I(inode)->i_disksize)) {
+		new_size = end;
+		ret = inode_newsize_ok(inode, new_size);
+		if (ret)
+			goto out;
+	}
+
+	/* Wait all existing dio workers, newcomers will block on i_rwsem */
+	inode_dio_wait(inode);
+
+	ret = file_modified(file);
+	if (ret)
+		goto out;
+
+	ret = ext4_alloc_file_blocks(file, start_lblk, len_lblk, new_size,
+				     EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
+	if (ret)
+		goto out;
+
+	if (file->f_flags & O_SYNC && EXT4_SB(inode->i_sb)->s_journal) {
+		ret = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
+					EXT4_I(inode)->i_sync_tid);
+	}
+out:
+	inode_unlock(inode);
+	trace_ext4_fallocate_exit(inode, offset, len_lblk, ret);
+	return ret;
+}
+
 /*
  * preallocate space for a file. This implements ext4's fallocate file
  * operation, which gets called from sys_fallocate system call.
@@ -4700,12 +4752,7 @@ out:
 long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
-	loff_t new_size = 0;
-	unsigned int max_blocks;
-	int ret = 0;
-	int flags;
-	ext4_lblk_t lblk;
-	unsigned int blkbits = inode->i_blkbits;
+	int ret;
 
 	/*
 	 * Encrypted inodes can't handle collapse range or insert
@@ -4727,71 +4774,19 @@ long ext4_fallocate(struct file *file, i
 	ret = ext4_convert_inline_data(inode);
 	inode_unlock(inode);
 	if (ret)
-		goto exit;
+		return ret;
 
-	if (mode & FALLOC_FL_PUNCH_HOLE) {
+	if (mode & FALLOC_FL_PUNCH_HOLE)
 		ret = ext4_punch_hole(file, offset, len);
-		goto exit;
-	}
-
-	if (mode & FALLOC_FL_COLLAPSE_RANGE) {
+	else if (mode & FALLOC_FL_COLLAPSE_RANGE)
 		ret = ext4_collapse_range(file, offset, len);
-		goto exit;
-	}
-
-	if (mode & FALLOC_FL_INSERT_RANGE) {
+	else if (mode & FALLOC_FL_INSERT_RANGE)
 		ret = ext4_insert_range(file, offset, len);
-		goto exit;
-	}
-
-	if (mode & FALLOC_FL_ZERO_RANGE) {
+	else if (mode & FALLOC_FL_ZERO_RANGE)
 		ret = ext4_zero_range(file, offset, len, mode);
-		goto exit;
-	}
-	trace_ext4_fallocate_enter(inode, offset, len, mode);
-	lblk = offset >> blkbits;
-
-	max_blocks = EXT4_MAX_BLOCKS(len, offset, blkbits);
-	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
-
-	inode_lock(inode);
-
-	/*
-	 * We only support preallocation for extent-based files only
-	 */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-	    (offset + len > inode->i_size ||
-	     offset + len > EXT4_I(inode)->i_disksize)) {
-		new_size = offset + len;
-		ret = inode_newsize_ok(inode, new_size);
-		if (ret)
-			goto out;
-	}
-
-	/* Wait all existing dio workers, newcomers will block on i_rwsem */
-	inode_dio_wait(inode);
-
-	ret = file_modified(file);
-	if (ret)
-		goto out;
+	else
+		ret = ext4_do_fallocate(file, offset, len, mode);
 
-	ret = ext4_alloc_file_blocks(file, lblk, max_blocks, new_size, flags);
-	if (ret)
-		goto out;
-
-	if (file->f_flags & O_SYNC && EXT4_SB(inode->i_sb)->s_journal) {
-		ret = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
-					EXT4_I(inode)->i_sync_tid);
-	}
-out:
-	inode_unlock(inode);
-	trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
-exit:
 	return ret;
 }
 


