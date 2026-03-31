Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8D430AABE;
	Tue, 31 Mar 2026 17:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976864; cv=none; b=jvpbp60gYl++KYv8fAbizMAjC9r+7ktSmqUABzEMQxgsyS4V4/jRD+61xZXpvHVy4K9l0ahEYkjClkPxNNmdR9UT+LR7SYCZnhwPx6jqnN3Q/f3RcNg9+FLKSD12o6EV1uLxsUFkwJz1FixLB1/wHKggoljtO7DCBLidNpNBL8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976864; c=relaxed/simple;
	bh=g16lM5dgg3GWPs48XqRVmdN/YW8T9G1F/IfImlcNeK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WB24/hQYU93oWcFSfKo818Z7wM9xI6r8L51akCYG5xg8Q0ol1uJBc7eT52YLgXiq0qI7ROXsr8F7ES5nQ2b5kVkmyBdckK/hlLlJj+036XZgmQJX4C9+sklvxDwvyI43P+Y7m4NoCzAL8m8qD9hMfmX3MU24jlpxGKzed1Y8GkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrSkyxbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrSkyxbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1306CC19423;
	Tue, 31 Mar 2026 17:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976864;
	bh=g16lM5dgg3GWPs48XqRVmdN/YW8T9G1F/IfImlcNeK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrSkyxbbqVnDQwZUuIDYMa25omqIBQIYlT5JN5IuCp6qjUIyA3xuT6vAfKq89iyrg
	 6EXQDHRsrUDwVybsBpL2XLn+4IkeOY74bki+/Q73fhXSWWMk29lG0uMf9go9E+Urh3
	 uYLt5t9/0jxGHdJcqIyDcpIyRfBJdiXzOUIcadjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 257/309] ext4: do not check fast symlink during orphan recovery
Date: Tue, 31 Mar 2026 18:22:40 +0200
Message-ID: <20260331161803.031440152@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 84e21e3fb8fd99ea460eb7274584750d11cf3e9f upstream.

Commit '5f920d5d6083 ("ext4: verify fast symlink length")' causes the
generic/475 test to fail during orphan cleanup of zero-length symlinks.

  generic/475  84s ... _check_generic_filesystem: filesystem on /dev/vde is inconsistent

The fsck reports are provided below:

  Deleted inode 9686 has zero dtime.
  Deleted inode 158230 has zero dtime.
  ...
  Inode bitmap differences:  -9686 -158230
  Orphan file (inode 12) block 13 is not clean.
  Failed to initialize orphan file.

In ext4_symlink(), a newly created symlink can be added to the orphan
list due to ENOSPC. Its data has not been initialized, and its size is
zero. Therefore, we need to disregard the length check of the symbolic
link when cleaning up orphan inodes. Instead, we should ensure that the
nlink count is zero.

Fixes: 5f920d5d6083 ("ext4: verify fast symlink length")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260131091156.1733648-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5465,18 +5465,36 @@ struct inode *__ext4_iget(struct super_b
 			inode->i_op = &ext4_encrypted_symlink_inode_operations;
 		} else if (ext4_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext4_fast_symlink_inode_operations;
-			if (inode->i_size == 0 ||
-			    inode->i_size >= sizeof(ei->i_data) ||
-			    strnlen((char *)ei->i_data, inode->i_size + 1) !=
-								inode->i_size) {
-				ext4_error_inode(inode, function, line, 0,
-					"invalid fast symlink length %llu",
-					 (unsigned long long)inode->i_size);
-				ret = -EFSCORRUPTED;
-				goto bad_inode;
+
+			/*
+			 * Orphan cleanup can see inodes with i_size == 0
+			 * and i_data uninitialized. Skip size checks in
+			 * that case. This is safe because the first thing
+			 * ext4_evict_inode() does for fast symlinks is
+			 * clearing of i_data and i_size.
+			 */
+			if ((EXT4_SB(sb)->s_mount_state & EXT4_ORPHAN_FS)) {
+				if (inode->i_nlink != 0) {
+					ext4_error_inode(inode, function, line, 0,
+						"invalid orphan symlink nlink %d",
+						inode->i_nlink);
+					ret = -EFSCORRUPTED;
+					goto bad_inode;
+				}
+			} else {
+				if (inode->i_size == 0 ||
+				    inode->i_size >= sizeof(ei->i_data) ||
+				    strnlen((char *)ei->i_data, inode->i_size + 1) !=
+						inode->i_size) {
+					ext4_error_inode(inode, function, line, 0,
+						"invalid fast symlink length %llu",
+						(unsigned long long)inode->i_size);
+					ret = -EFSCORRUPTED;
+					goto bad_inode;
+				}
+				inode_set_cached_link(inode, (char *)ei->i_data,
+						      inode->i_size);
 			}
-			inode_set_cached_link(inode, (char *)ei->i_data,
-					      inode->i_size);
 		} else {
 			inode->i_op = &ext4_symlink_inode_operations;
 		}


