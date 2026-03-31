Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8880C3F7A8B;
	Tue, 31 Mar 2026 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975434; cv=none; b=l8IGQBl87eWQJp5kvgw9icze/pp0CvSKtVbePFe/FGvtMbfDR5Nz/5mMGtYhZGaAb9QuTtzTWBLP+C6H0sXZD0a4JrqxksSu4fZUr8djOs7tLF0CF5FduL1S8Uv6XDdUW1xLZhoGS92PpQRQdQ82wkmRzQU6l/YTYusEU+9loZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975434; c=relaxed/simple;
	bh=RTLk4NfRjMcILSS3/+sjhhes+pzlCbNEGFlhZFzdbBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNrMcAK0OE6yA5KlzUs0c+ZMZ32kKxZXmaS6ZEazugo5T8FTzdv7lvBEP4x1EtJ7mVJJlxZW6oF6M5txPY7J/TIcDQdWAQGaHQoNmtqzbiinqnG0Haj8xqVynTE1O6otJ+Rk9n6BvcFV1n0oST4/rejR6iFy9MHDtaJJLE7sRh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DM9DZ/YE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DM9DZ/YE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F156C19423;
	Tue, 31 Mar 2026 16:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975434;
	bh=RTLk4NfRjMcILSS3/+sjhhes+pzlCbNEGFlhZFzdbBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DM9DZ/YEWsA9MHTnLott0MDRAJozMu1cK8FBsPZZVOShcr3aoGcTjkWD9vykY/PUS
	 /5YjsFGhlA4M9UkjpXY3IE90XicvC1ApyD6/6J3RpK3qutjE260YtIL6qMaaNhZvXq
	 CzcXinfsXCI+ytOFDllRd1B3sf0c5QKNcTJKBey8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.19 293/342] ext4: do not check fast symlink during orphan recovery
Date: Tue, 31 Mar 2026 18:22:06 +0200
Message-ID: <20260331161809.720175714@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5449,18 +5449,36 @@ struct inode *__ext4_iget(struct super_b
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


