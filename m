Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACC91714B7;
	Wed, 30 Jul 2025 09:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868824; cv=none; b=ry3Li+TadABVSj0OwN0VAQnjpFjUmPjBfat/z5WQoXnlECfFStEyeY8ZQwwXZbPE5SFMDMWAmhmZ6/UVkLcuDkbLCNQ7rERxIWkzNu+3MRmR9f0BR9k5rXYATJsazz7aqSsSrrczXIxKNUP/8BOxoFAf/PR86+pKn5UfjxHq/L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868824; c=relaxed/simple;
	bh=Pe2KLYrmqgj5IjrT8Mrw4FnaZrdqT04ot29IZACfRLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCNsaEZKd0qTJiya8KRyUCadeSFseW66pVrpCkqTDDRF2NOkkHC8bNUihtQ7lnnZRkXQzcR2F40PEVS0ZF+zMQhndj19Q4AMX/0M1GxyjOHksY0+T+7iBD4ZY/+iZyCUCtzYoKpAlVbIWUwRrFbKqEb78mH3qb0lbwh3MzMXaY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvRI3aYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvRI3aYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D24C4CEF5;
	Wed, 30 Jul 2025 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868824;
	bh=Pe2KLYrmqgj5IjrT8Mrw4FnaZrdqT04ot29IZACfRLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvRI3aYCbDTs6SSRTjEufpMAHuc3S1ZZnRRrlN5hYITPye4bRIfslnzjoxHuHSK4D
	 cQVpRO+90rgxy9iJKeX2nHK4wZp4bt+RvTT8+D0DiLoQP7rKXVkI3MSe7uBDRFu/eV
	 3KNZRljh9a9bVpmBJP6EbDGSsXtM57vERH7es6aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/117] ext4: dont explicit update times in ext4_fallocate()
Date: Wed, 30 Jul 2025 11:35:54 +0200
Message-ID: <20250730093237.084733249@linuxfoundation.org>
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

[ Upstream commit 73ae756ecdfa9684446134590eef32b0f067249c ]

After commit 'ad5cd4f4ee4d ("ext4: fix fallocate to use file_modified to
update permissions consistently"), we can update mtime and ctime
appropriately through file_modified() when doing zero range, collapse
rage, insert range and punch hole, hence there is no need to explicit
update times in those paths, just drop them.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20241220011637.1157197-3-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 29ec9bed2395 ("ext4: fix incorrect punch max_end")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    5 -----
 fs/ext4/inode.c   |    1 -
 2 files changed, 6 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4675,8 +4675,6 @@ static long ext4_zero_range(struct file
 			goto out_mutex;
 		}
 
-		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
-
 		ret = ext4_alloc_file_blocks(file, lblk, max_blocks, new_size,
 					     flags);
 		filemap_invalidate_unlock(mapping);
@@ -4700,7 +4698,6 @@ static long ext4_zero_range(struct file
 		goto out_mutex;
 	}
 
-	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	if (new_size)
 		ext4_update_inode_size(inode, new_size);
 	ret = ext4_mark_inode_dirty(handle, inode);
@@ -5431,7 +5428,6 @@ static int ext4_collapse_range(struct fi
 	up_write(&EXT4_I(inode)->i_data_sem);
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
-	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	ret = ext4_mark_inode_dirty(handle, inode);
 	ext4_update_inode_fsync_trans(handle, inode, 1);
 
@@ -5541,7 +5537,6 @@ static int ext4_insert_range(struct file
 	/* Expand file to avoid data loss if there is error while shifting */
 	inode->i_size += len;
 	EXT4_I(inode)->i_disksize += len;
-	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	ret = ext4_mark_inode_dirty(handle, inode);
 	if (ret)
 		goto out_stop;
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4113,7 +4113,6 @@ int ext4_punch_hole(struct file *file, l
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
 
-	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	ret2 = ext4_mark_inode_dirty(handle, inode);
 	if (unlikely(ret2))
 		ret = ret2;


