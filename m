Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105A378F49;
	Mon,  6 Jan 2025 15:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176855; cv=none; b=pYwZnmcGyWf1ecv//U+K9u0/ajFlL876vPeoX29Mxn+Nqj8ErU1xIUe4sgqsSBb/Vl9RUfjfzONhSGh+RCKnFFGnYLEVGD5WS43P0xqSvNnWxa/g6LJARR8Ih+QYMC34zEgWM1jyozugBCZX2tTIiCHw4wDOj4cEUKd1QyApFKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176855; c=relaxed/simple;
	bh=xD/bRRp1N+B2Za8iMprsLnljw+34XAEgtmPiCJV2Ee8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1UrNLFWEhMjQOTHedOC1GJc3xHhTC/kXZBVQ5vKWUSS1IWVavj/L1p4AyR7YuCNS5jrQ2+8f4ZTVAsDxEThA2Sd51zohH55TJHX8a3GyFvBl84deB2A8msiWlV0OQGa/wts/+VAPxlfbIA8Q00n+4ia4dQxAtasaEtxjH9PrhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlcFuKsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlcFuKsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BFAC4CED2;
	Mon,  6 Jan 2025 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176854;
	bh=xD/bRRp1N+B2Za8iMprsLnljw+34XAEgtmPiCJV2Ee8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlcFuKsweJjdPiDl4oetQie4R//7l6GpM+rr0YO+PrRiE02pZ8qwAMJDYxqGKM2Cg
	 TN4L7dLiipvhK0B29KE6aFB3EzycROEkrkk069PgrgxDB/RLDImxBxQ9uJCzp/T/R7
	 gcbTIT9lELopyXYgLXy7BE4HZEF6mXgZMdplS1Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 51/81] btrfs: rename and export __btrfs_cow_block()
Date: Mon,  6 Jan 2025 16:16:23 +0100
Message-ID: <20250106151131.359847294@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 347934eb5198..a02b41106257 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -404,13 +404,13 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
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
@@ -559,7 +559,7 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 }
 
 /*
- * cows a single block, see __btrfs_cow_block for the real work.
+ * COWs a single block, see btrfs_force_cow_block() for the real work.
  * This version of it has extra checks so that a block isn't COWed more than
  * once per transaction, as long as it hasn't been written yet
  */
@@ -612,8 +612,8 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	 * Also We don't care about the error, as it's handled internally.
 	 */
 	btrfs_qgroup_trace_subtree_after_cow(trans, root, buf);
-	ret = __btrfs_cow_block(trans, root, buf, parent,
-				 parent_slot, cow_ret, search_start, 0, nest);
+	ret = btrfs_force_cow_block(trans, root, buf, parent, parent_slot,
+				    cow_ret, search_start, 0, nest);
 
 	trace_btrfs_cow_block(root, buf, *cow_ret);
 
@@ -764,11 +764,11 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
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
index cab023927b43..da8986e0c422 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3032,6 +3032,13 @@ int btrfs_cow_block(struct btrfs_trans_handle *trans,
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



