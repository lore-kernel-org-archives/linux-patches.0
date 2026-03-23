Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EE0282F0F;
	Mon, 23 Mar 2026 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279444; cv=none; b=O9E7cRfnWy3IMR1RAhdK1T+qjaSqQOk2hx70zNDf/uvN0HBx9xuCKghsVPIymOE8hFpL4sxBNeIu8HbnPEluDByJ6y4h1WYiC/w7tI1GebZ9d3698mbqLZ+WppNTJtatlgXhKNu50AgypgM3sOE4OB3Na2LY/7cgQ/jVYUDp37A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279444; c=relaxed/simple;
	bh=QDYkY1iwNPn1/rLgGN+6EjgGu57H/e7iVkhyIdhnc6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0mQZRtn0b7q+3CdY2ogQEixxIliNeeTjrvWQaUSigNxnQXdOkWlJYfoit45XV6H8MeYlGgRyZu76y1P0hRPRNEvO8b7LAuJQLM1/z599bSSGsSXjIVHSKS0RTxX5yVMmqpwFXiZ0LZ9jy1tKdRiCjYZq4A/mJfLK57gaxIcQoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCu2KTTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCu2KTTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1572CC4CEF7;
	Mon, 23 Mar 2026 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279444;
	bh=QDYkY1iwNPn1/rLgGN+6EjgGu57H/e7iVkhyIdhnc6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCu2KTTcDYXV0x/Yj+NixFfcVcJ1mt0MCKX5rkx9P9e5kOE+T/sdHmyJDv5k7vh/c
	 3Ju8g2r6yBVUyGzbN+IHjel7yu4OAVHj1AwEDP61a4WXvhZzS8GxQ/hIxnxoRiwFDB
	 iLlIiTbUX5E/Aj+r6Mu6IsHibUr8CCZ0zHrz1fm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/481] ext4: make ext4_es_remove_extent() return void
Date: Mon, 23 Mar 2026 14:40:21 +0100
Message-ID: <20260323134526.187172309@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit ed5d285b3f2a9a37ff778c5e440daf49351fcc4d ]

Now ext4_es_remove_extent() never fails, so make it return void.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230424033846.4732-10-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 22784ca541c0 ("ext4: subdivide EXT4_EXT_DATA_VALID1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c        | 34 ++++++----------------------------
 fs/ext4/extents_status.c | 12 ++++++------
 fs/ext4/extents_status.h |  4 ++--
 fs/ext4/inline.c         | 12 ++----------
 fs/ext4/inode.c          |  8 ++------
 5 files changed, 18 insertions(+), 52 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1df7174774694..af4cae13685d7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4463,15 +4463,8 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
-retry:
-	err = ext4_es_remove_extent(inode, last_block,
-				    EXT_MAX_BLOCKS - last_block);
-	if (err == -ENOMEM) {
-		memalloc_retry_wait(GFP_ATOMIC);
-		goto retry;
-	}
-	if (err)
-		return err;
+	ext4_es_remove_extent(inode, last_block, EXT_MAX_BLOCKS - last_block);
+
 retry_remove_space:
 	err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
 	if (err == -ENOMEM) {
@@ -5419,13 +5412,7 @@ static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_discard_preallocations(inode, 0);
-
-	ret = ext4_es_remove_extent(inode, punch_start,
-				    EXT_MAX_BLOCKS - punch_start);
-	if (ret) {
-		up_write(&EXT4_I(inode)->i_data_sem);
-		goto out_stop;
-	}
+	ext4_es_remove_extent(inode, punch_start, EXT_MAX_BLOCKS - punch_start);
 
 	ret = ext4_ext_remove_space(inode, punch_start, punch_stop - 1);
 	if (ret) {
@@ -5611,12 +5598,7 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 		ext4_free_ext_path(path);
 	}
 
-	ret = ext4_es_remove_extent(inode, offset_lblk,
-			EXT_MAX_BLOCKS - offset_lblk);
-	if (ret) {
-		up_write(&EXT4_I(inode)->i_data_sem);
-		goto out_stop;
-	}
+	ext4_es_remove_extent(inode, offset_lblk, EXT_MAX_BLOCKS - offset_lblk);
 
 	/*
 	 * if offset_lblk lies in a hole which is at start of file, use
@@ -5675,12 +5657,8 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 	BUG_ON(!inode_is_locked(inode1));
 	BUG_ON(!inode_is_locked(inode2));
 
-	*erp = ext4_es_remove_extent(inode1, lblk1, count);
-	if (unlikely(*erp))
-		return 0;
-	*erp = ext4_es_remove_extent(inode2, lblk2, count);
-	if (unlikely(*erp))
-		return 0;
+	ext4_es_remove_extent(inode1, lblk1, count);
+	ext4_es_remove_extent(inode2, lblk2, count);
 
 	while (count) {
 		struct ext4_extent *ex1, *ex2, tmp_ex;
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 592229027af72..862a8308cd9b0 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1494,10 +1494,10 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
  * @len - number of blocks to remove
  *
  * Reduces block/cluster reservation count and for bigalloc cancels pending
- * reservations as needed. Returns 0 on success, error code on failure.
+ * reservations as needed.
  */
-int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
-			  ext4_lblk_t len)
+void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
+			   ext4_lblk_t len)
 {
 	ext4_lblk_t end;
 	int err = 0;
@@ -1505,14 +1505,14 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	struct extent_status *es = NULL;
 
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
-		return 0;
+		return;
 
 	trace_ext4_es_remove_extent(inode, lblk, len);
 	es_debug("remove [%u/%u) from extent status tree of inode %lu\n",
 		 lblk, len, inode->i_ino);
 
 	if (!len)
-		return err;
+		return;
 
 	end = lblk + len - 1;
 	BUG_ON(end < lblk);
@@ -1539,7 +1539,7 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 
 	ext4_es_print_tree(inode);
 	ext4_da_release_space(inode, reserved);
-	return 0;
+	return;
 }
 
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 481ec4381bee6..1d1247bbfd477 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -133,8 +133,8 @@ extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 				 ext4_lblk_t len, ext4_fsblk_t pblk,
 				 unsigned int status);
-extern int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
-				 ext4_lblk_t len);
+extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
+				  ext4_lblk_t len);
 extern void ext4_es_find_extent_range(struct inode *inode,
 				      int (*match_fn)(struct extent_status *es),
 				      ext4_lblk_t lblk, ext4_lblk_t end,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index a1fb99d2b472b..c15ea7589945f 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -2004,16 +2004,8 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 		 * the extent status cache must be cleared to avoid leaving
 		 * behind stale delayed allocated extent entries
 		 */
-		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
-retry:
-			err = ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-			if (err == -ENOMEM) {
-				memalloc_retry_wait(GFP_ATOMIC);
-				goto retry;
-			}
-			if (err)
-				goto out_error;
-		}
+		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+			ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
 
 		/* Clear the content in the xattr space. */
 		if (inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bf1f8319e2d74..79619f3db984f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4134,12 +4134,8 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_preallocations(inode, 0);
 
-		ret = ext4_es_remove_extent(inode, first_block,
-					    stop_block - first_block);
-		if (ret) {
-			up_write(&EXT4_I(inode)->i_data_sem);
-			goto out_stop;
-		}
+		ext4_es_remove_extent(inode, first_block,
+				      stop_block - first_block);
 
 		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 			ret = ext4_ext_remove_space(inode, first_block,
-- 
2.51.0



