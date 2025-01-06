Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E781A13B59A;
	Mon,  6 Jan 2025 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178948; cv=none; b=ikT1t6w09xbKHh/33LgO7QXTkW3cD4ExlsQxAYhwtGWNKXL+dNd02K29vz7IVWQ+Y4yZ4ZPf9J6xEnV5u5QPQZyE04M1QYdw7NalrbtmhuSAInEnTu75iIf2R17Y4iiAelzsouGxQfXWMzsMY/vqBg4+N5UEMTdnGn8nTaHaWEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178948; c=relaxed/simple;
	bh=cDrnrY5ZItaFZ+Z19TLw3orhUN77RboH/VXBFfyTDM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuiUx7PYZNAf+6UpcuEWWhXIJRzpPOawzVmTkXMbHbf/In6nyoQXGpN/W8hphT1MPFgoV9HrzSlYt31KCJ/7gXEE8sC2UwSHbiawSZDymYbOnNlTcfm+tJBKRvquDeMf7evO957ouu1ziQ3FQirFnkArU8vMYo2zUB+xbzp9+XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATbEXRuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATbEXRuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518D3C4CED2;
	Mon,  6 Jan 2025 15:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178947;
	bh=cDrnrY5ZItaFZ+Z19TLw3orhUN77RboH/VXBFfyTDM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATbEXRuZjAYL12CWv+43R7EpoSC1T1bBz619IS2ameYybXeKCkWzfEZ+wAJJg+BV+
	 BvdAjpltWDp9LWFwHOAksB1fnmjfe5whyJwqXYg7XLLx0HpSW2ywTlpaO45O9anSEK
	 EZOaNs4TNMKhOyAjPSFdBpBz2m71IThbyEh9wCGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/168] btrfs: rename and export __btrfs_cow_block()
Date: Mon,  6 Jan 2025 16:17:33 +0100
Message-ID: <20250106151143.913139524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 345f205af619..42562c61f52e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -386,13 +386,13 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
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
@@ -541,7 +541,7 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 }
 
 /*
- * cows a single block, see __btrfs_cow_block for the real work.
+ * COWs a single block, see btrfs_force_cow_block() for the real work.
  * This version of it has extra checks so that a block isn't COWed more than
  * once per transaction, as long as it hasn't been written yet
  */
@@ -594,8 +594,8 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	 * Also We don't care about the error, as it's handled internally.
 	 */
 	btrfs_qgroup_trace_subtree_after_cow(trans, root, buf);
-	ret = __btrfs_cow_block(trans, root, buf, parent,
-				 parent_slot, cow_ret, search_start, 0, nest);
+	ret = btrfs_force_cow_block(trans, root, buf, parent, parent_slot,
+				    cow_ret, search_start, 0, nest);
 
 	trace_btrfs_cow_block(root, buf, *cow_ret);
 
@@ -746,11 +746,11 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
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
index 17ebcf19b444..61ec4ba5414d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2885,6 +2885,13 @@ int btrfs_cow_block(struct btrfs_trans_handle *trans,
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



