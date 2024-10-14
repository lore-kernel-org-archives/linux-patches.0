Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E284A1ABEC9;
	Mon, 14 Oct 2024 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919227; cv=none; b=le4cUWPm2B6Lwo40JjkJC+OHE++X2UrL/My0OiAxTlbDjv08sJWuS3lyoXWvK+PjbswyQ9cZa94wmw3wJw85CHMnWfLWgOXQ9DRqFMK8QM9l+HeDK46WDfQV9cJTV6BzSpyW+0dBVxLEiMgUr5bvoKRThq2ShPQ7DkqCMCn//zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919227; c=relaxed/simple;
	bh=7sFwfGsa7PK95W2D9bwWoKeL9FGr87iU+Khv/Ar+LWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdzfcj0Ql9xlITG0oYpRtZwFYRIKBQSRW5f7SAfzeKzP7P9Usuy0P8BZhpyB1MLCqTqEY9OsYu2zyYlB1EfBJ0jwQMBehN5a9LWw4NWSdsD4UmQ7c7kGXhATIBPgUx8pwu5pTAR4pQShamfXN9xmrxZtae0inRDOrBi6tWz5zzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MccOCTMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MccOCTMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4699BC4CEC3;
	Mon, 14 Oct 2024 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919226;
	bh=7sFwfGsa7PK95W2D9bwWoKeL9FGr87iU+Khv/Ar+LWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MccOCTMy4jST7NgP8Vnm1JF0injUh64hQ52ZgqgD+u+DEdifgEoKLJyjR7y7+qGwm
	 L78dQJu7Nbin+ZeDQhowMLktOQFQVLpX8hAnX38+44n4Sp2tmjqErGkMfIigVFF44k
	 Ta+ONgmT3zoIlOnjimIthg/CHm2g7GKLHEZnESGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 548/798] ext4: drop ppath from ext4_ext_replay_update_ex() to avoid double-free
Date: Mon, 14 Oct 2024 16:18:22 +0200
Message-ID: <20241014141239.526568886@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit 5c0f4cc84d3a601c99bc5e6e6eb1cbda542cce95 upstream.

When calling ext4_force_split_extent_at() in ext4_ext_replay_update_ex(),
the 'ppath' is updated but it is the 'path' that is freed, thus potentially
triggering a double-free in the following process:

ext4_ext_replay_update_ex
  ppath = path
  ext4_force_split_extent_at(&ppath)
    ext4_split_extent_at
      ext4_ext_insert_extent
        ext4_ext_create_new_leaf
          ext4_ext_grow_indepth
            ext4_find_extent
              if (depth > path[0].p_maxdepth)
                kfree(path)                 ---> path First freed
                *orig_path = path = NULL    ---> null ppath
  kfree(path)                               ---> path double-free !!!

So drop the unnecessary ppath and use path directly to avoid this problem.
And use ext4_find_extent() directly to update path, avoiding unnecessary
memory allocation and freeing. Also, propagate the error returned by
ext4_find_extent() instead of using strange error codes.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-8-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5926,7 +5926,7 @@ out:
 int ext4_ext_replay_update_ex(struct inode *inode, ext4_lblk_t start,
 			      int len, int unwritten, ext4_fsblk_t pblk)
 {
-	struct ext4_ext_path *path = NULL, *ppath;
+	struct ext4_ext_path *path;
 	struct ext4_extent *ex;
 	int ret;
 
@@ -5942,30 +5942,29 @@ int ext4_ext_replay_update_ex(struct ino
 	if (le32_to_cpu(ex->ee_block) != start ||
 		ext4_ext_get_actual_len(ex) != len) {
 		/* We need to split this extent to match our extent first */
-		ppath = path;
 		down_write(&EXT4_I(inode)->i_data_sem);
-		ret = ext4_force_split_extent_at(NULL, inode, &ppath, start, 1);
+		ret = ext4_force_split_extent_at(NULL, inode, &path, start, 1);
 		up_write(&EXT4_I(inode)->i_data_sem);
 		if (ret)
 			goto out;
-		kfree(path);
-		path = ext4_find_extent(inode, start, NULL, 0);
+
+		path = ext4_find_extent(inode, start, &path, 0);
 		if (IS_ERR(path))
-			return -1;
-		ppath = path;
+			return PTR_ERR(path);
 		ex = path[path->p_depth].p_ext;
 		WARN_ON(le32_to_cpu(ex->ee_block) != start);
+
 		if (ext4_ext_get_actual_len(ex) != len) {
 			down_write(&EXT4_I(inode)->i_data_sem);
-			ret = ext4_force_split_extent_at(NULL, inode, &ppath,
+			ret = ext4_force_split_extent_at(NULL, inode, &path,
 							 start + len, 1);
 			up_write(&EXT4_I(inode)->i_data_sem);
 			if (ret)
 				goto out;
-			kfree(path);
-			path = ext4_find_extent(inode, start, NULL, 0);
+
+			path = ext4_find_extent(inode, start, &path, 0);
 			if (IS_ERR(path))
-				return -EINVAL;
+				return PTR_ERR(path);
 			ex = path[path->p_depth].p_ext;
 		}
 	}


