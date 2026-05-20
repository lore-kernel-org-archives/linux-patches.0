Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FAB3F6C4C;
	Wed, 20 May 2026 18:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300009; cv=none; b=V5WHUWJ1+0ZNXbPLaG/JM9Mtrcc7GFafwBIh5y5V1oWPdLpFPVcgyEhbIItl6J8sep3P6fXOZeXFoeBE+7avFNwJrKLhiJRGrugZVT1V5hnjwhHVqjPORtmjRkEEa1nSheOs4ogmSjEKPvebH4i2xNVy+pnwPIyNAaH5zTW6syc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300009; c=relaxed/simple;
	bh=freQma6BfS7Lj5jdm5nQuVtsKB1ZaD6OXPufZSbQRxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9LyFWOvFkQpyOeidtJK2HpM6iOAElDakG09EYTBii7yW0lDpi5IuDy0jkCQWrAILUHxa172Nf62KScZcMmwTnF/SU+6u/RVV8Ch37vlJe/qmAiVU8b7pBYSTLj7J6KJD6txHjV+gZUwDGr5FPGHcgkOYVvwnuIYr8h71nWtGiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abA4Ln8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abA4Ln8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2BC1F000E9;
	Wed, 20 May 2026 18:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300007;
	bh=tT/mrnIG78VP5genPm6vRQdlQcx6Qlc2j19742gRlAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abA4Ln8pwZAdgjygxO5ro2q1snS3giukL4zH77RYnZ9mWoQ/5S2awBK2ogiFL0YNB
	 CdEs8MpHaSIZkpQuMf3EZgwZFxMrEG2DS9Ibze0gPwdb/GsuwFp5HiHeAFzqXajevz
	 2yb4FqPOlgn2SXgLPop1jGUWXz4nf9CvQFRz+1EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/666] btrfs: pass struct btrfs_inode to clone_copy_inline_extent()
Date: Wed, 20 May 2026 18:13:44 +0200
Message-ID: <20260520162111.519483821@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 65a66afd1ee5b2770fde296663baa0f79af56bc7 ]

Pass a struct btrfs_inode to clone_copy_inline_extent() as it's an
internal interface, allowing to remove some use of BTRFS_I.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: b48c980b6a7e ("btrfs: fix deadlock between reflink and transaction commit when using flushoncommit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/reflink.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index f0824c948cb70..8640dbf1aefa4 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -165,7 +165,7 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
  * the source inode to destination inode when possible. When not possible we
  * copy the inline extent's data into the respective page of the inode.
  */
-static int clone_copy_inline_extent(struct inode *dst,
+static int clone_copy_inline_extent(struct btrfs_inode *inode,
 				    struct btrfs_path *path,
 				    struct btrfs_key *new_key,
 				    const u64 drop_start,
@@ -175,8 +175,8 @@ static int clone_copy_inline_extent(struct inode *dst,
 				    char *inline_data,
 				    struct btrfs_trans_handle **trans_out)
 {
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(dst);
-	struct btrfs_root *root = BTRFS_I(dst)->root;
+	struct btrfs_root *root = inode->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	const u64 aligned_end = ALIGN(new_key->offset + datal,
 				      fs_info->sectorsize);
 	struct btrfs_trans_handle *trans = NULL;
@@ -185,12 +185,12 @@ static int clone_copy_inline_extent(struct inode *dst,
 	struct btrfs_key key;
 
 	if (new_key->offset > 0) {
-		ret = copy_inline_to_page(BTRFS_I(dst), new_key->offset,
+		ret = copy_inline_to_page(inode, new_key->offset,
 					  inline_data, size, datal, comp_type);
 		goto out;
 	}
 
-	key.objectid = btrfs_ino(BTRFS_I(dst));
+	key.objectid = btrfs_ino(inode);
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
@@ -205,7 +205,7 @@ static int clone_copy_inline_extent(struct inode *dst,
 				goto copy_inline_extent;
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-		if (key.objectid == btrfs_ino(BTRFS_I(dst)) &&
+		if (key.objectid == btrfs_ino(inode) &&
 		    key.type == BTRFS_EXTENT_DATA_KEY) {
 			/*
 			 * There's an implicit hole at file offset 0, copy the
@@ -214,7 +214,7 @@ static int clone_copy_inline_extent(struct inode *dst,
 			ASSERT(key.offset > 0);
 			goto copy_to_page;
 		}
-	} else if (i_size_read(dst) <= datal) {
+	} else if (i_size_read(&inode->vfs_inode) <= datal) {
 		struct btrfs_file_extent_item *ei;
 
 		ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
@@ -236,7 +236,7 @@ static int clone_copy_inline_extent(struct inode *dst,
 	 * We have no extent items, or we have an extent at offset 0 which may
 	 * or may not be inlined. All these cases are dealt the same way.
 	 */
-	if (i_size_read(dst) > datal) {
+	if (i_size_read(&inode->vfs_inode) > datal) {
 		/*
 		 * At the destination offset 0 we have either a hole, a regular
 		 * extent or an inline extent larger then the one we want to
@@ -270,7 +270,7 @@ static int clone_copy_inline_extent(struct inode *dst,
 	drop_args.start = drop_start;
 	drop_args.end = aligned_end;
 	drop_args.drop_cache = true;
-	ret = btrfs_drop_extents(trans, root, BTRFS_I(dst), &drop_args);
+	ret = btrfs_drop_extents(trans, root, inode, &drop_args);
 	if (ret)
 		goto out;
 	ret = btrfs_insert_empty_item(trans, root, path, new_key, size);
@@ -281,9 +281,9 @@ static int clone_copy_inline_extent(struct inode *dst,
 			    btrfs_item_ptr_offset(path->nodes[0],
 						  path->slots[0]),
 			    size);
-	btrfs_update_inode_bytes(BTRFS_I(dst), datal, drop_args.bytes_found);
-	btrfs_set_inode_full_sync(BTRFS_I(dst));
-	ret = btrfs_inode_set_file_extent_range(BTRFS_I(dst), 0, aligned_end);
+	btrfs_update_inode_bytes(inode, datal, drop_args.bytes_found);
+	btrfs_set_inode_full_sync(inode);
+	ret = btrfs_inode_set_file_extent_range(inode, 0, aligned_end);
 out:
 	if (!ret && !trans) {
 		/*
@@ -318,7 +318,7 @@ static int clone_copy_inline_extent(struct inode *dst,
 	 */
 	btrfs_release_path(path);
 
-	ret = copy_inline_to_page(BTRFS_I(dst), new_key->offset,
+	ret = copy_inline_to_page(inode, new_key->offset,
 				  inline_data, size, datal, comp_type);
 	goto out;
 }
@@ -526,7 +526,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 				goto out;
 			}
 
-			ret = clone_copy_inline_extent(inode, path, &new_key,
+			ret = clone_copy_inline_extent(BTRFS_I(inode), path, &new_key,
 						       drop_start, datal, size,
 						       comp, buf, &trans);
 			if (ret)
-- 
2.53.0



