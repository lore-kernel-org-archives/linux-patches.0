Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428346088F;
	Mon,  6 Jan 2025 15:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178442; cv=none; b=G0t48foy8K4kwOl1fxl6wHE6Lbv45GBH98pcuwWjtSHyK4vppZq1roGXGaOJ8xbCW4D9gb/Th0k5+myX1ErZmq7Mz9/HZaccz/ZQOtFSkbyZETL0y+8HpkH0q+n8J3mrYrneUQH76eywbEDIyadwiovfFNAG95tNxAIxHETrAlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178442; c=relaxed/simple;
	bh=4eSyPqUBhvi/AeBcJ33/aj5uA3o4Ffx/EpnkW/vd0+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDMI734Kon4mvSoiMZTrwP6DODsBXJZvVp1Zede4q7MWfm3SMzDWQUjJHm9/iI6BgTKnUFu3MQFw1Ix0PrmIOQDxSUkGCi7gMNDa/SCZ5cscKwn8LOxwYoxzUHT50loVTJhlFugvMKiLvTyI4vzy8RRtQt04dymh2xvAxakl7j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/QBp9zI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/QBp9zI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2F1C4CED2;
	Mon,  6 Jan 2025 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178442;
	bh=4eSyPqUBhvi/AeBcJ33/aj5uA3o4Ffx/EpnkW/vd0+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/QBp9zIO9+NSK39yacr8xMDqJJe7Aea8Py9w33aHdO7WNTSkhI30EirMKHEXEZqc
	 qITR/0PPNScKU8lgw4WxRmbvxND9f+LgININbajgIYU40/rqXFMYWA00vACwVCeATs
	 eRH4V8aUTxfBVB9zfe3geTzcWD6onn8gvxYFNDr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/138] btrfs: rename and export __btrfs_cow_block()
Date: Mon,  6 Jan 2025 16:17:22 +0100
Message-ID: <20250106151137.697153186@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 95f93bc4cbcac6121a5ee85cd5019ee8e7447e0b ]

Rename and export __btrfs_cow_block() as btrfs_force_cow_block(). This is
to allow to move defrag specific code out of ctree.c and into defrag.c in
one of the next patches.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 44f52bbe96df ("btrfs: fix use-after-free when COWing tree bock and tracing is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 30 +++++++++++++++---------------
 fs/btrfs/ctree.h |  7 +++++++
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c71b02beb358..a376e42de9b2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1009,13 +1009,13 @@ static struct extent_buffer *alloc_tree_block_no_bg_flush(
  * bytes the allocator should try to find free next to the block it returns.
  * This is just a hint and may be ignored by the allocator.
  */
-static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
-			     struct extent_buffer *buf,
-			     struct extent_buffer *parent, int parent_slot,
-			     struct extent_buffer **cow_ret,
-			     u64 search_start, u64 empty_size,
-			     enum btrfs_lock_nesting nest)
+int btrfs_force_cow_block(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct extent_buffer *buf,
+			  struct extent_buffer *parent, int parent_slot,
+			  struct extent_buffer **cow_ret,
+			  u64 search_start, u64 empty_size,
+			  enum btrfs_lock_nesting nest)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_disk_key disk_key;
@@ -1469,7 +1469,7 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 }
 
 /*
- * cows a single block, see __btrfs_cow_block for the real work.
+ * COWs a single block, see btrfs_force_cow_block() for the real work.
  * This version of it has extra checks so that a block isn't COWed more than
  * once per transaction, as long as it hasn't been written yet
  */
@@ -1511,8 +1511,8 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	 * Also We don't care about the error, as it's handled internally.
 	 */
 	btrfs_qgroup_trace_subtree_after_cow(trans, root, buf);
-	ret = __btrfs_cow_block(trans, root, buf, parent,
-				 parent_slot, cow_ret, search_start, 0, nest);
+	ret = btrfs_force_cow_block(trans, root, buf, parent, parent_slot,
+				    cow_ret, search_start, 0, nest);
 
 	trace_btrfs_cow_block(root, buf, *cow_ret);
 
@@ -1678,11 +1678,11 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 			search_start = last_block;
 
 		btrfs_tree_lock(cur);
-		err = __btrfs_cow_block(trans, root, cur, parent, i,
-					&cur, search_start,
-					min(16 * blocksize,
-					    (end_slot - i) * blocksize),
-					BTRFS_NESTING_COW);
+		err = btrfs_force_cow_block(trans, root, cur, parent, i,
+					    &cur, search_start,
+					    min(16 * blocksize,
+						(end_slot - i) * blocksize),
+					    BTRFS_NESTING_COW);
 		if (err) {
 			btrfs_tree_unlock(cur);
 			free_extent_buffer(cur);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3ddb09f2b168..7ad3091db571 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2713,6 +2713,13 @@ int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		    struct extent_buffer *parent, int parent_slot,
 		    struct extent_buffer **cow_ret,
 		    enum btrfs_lock_nesting nest);
+int btrfs_force_cow_block(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct extent_buffer *buf,
+			  struct extent_buffer *parent, int parent_slot,
+			  struct extent_buffer **cow_ret,
+			  u64 search_start, u64 empty_size,
+			  enum btrfs_lock_nesting nest);
 int btrfs_copy_root(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      struct extent_buffer *buf,
-- 
2.39.5



