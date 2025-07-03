Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CEE2EE5F3;
	Thu,  3 Jul 2025 14:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554482; cv=none; b=GSpVcBZKY1RuXV2KZLq44YVZnRK0thKpi2wTaQMQM7xcwGy9AGddPIsfALZQg8iGCmEaRUQ2N1z+shkzbbdGqC9lutXcMjrCDlFx+lxEm0yJ62SCOlI8IYo3OvsJR3OYbzMt4W6IfzW3lt4ifUZU2pkpZM1k2TujsYG5mRvvHS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554482; c=relaxed/simple;
	bh=Xl8/croTMAR5ZIFJRyqzVZvfaMw/UNZ9XzdQ4/1A3Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rw+TCyBe1kwiFJQMXCIu0mavz3eg9ctFGkZCajE/gWzZ5Jjmk8FHVKnLtkyAANosWPgG6Hd6MT148xfq2VvHj+RkuvX4UgUM8G2gReoI++LxToeqMjM6z7/W+ziob76OR0yfbXrUf6brEwcvZG5EVDgp3LbLp6CVWUXw5Tv3nYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOnknggR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOnknggR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53248C4CEED;
	Thu,  3 Jul 2025 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554481;
	bh=Xl8/croTMAR5ZIFJRyqzVZvfaMw/UNZ9XzdQ4/1A3Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOnknggRtU9/N0k1dYCzWAdX+sBLuwqUXgpShfcj3Vi13clibXMm50Vt0rGr2wcOa
	 rtvi/a6DjT4g3O+9vG376NtHQix5bKLANIve246QJPNghKLmgHZRMEpMSNybatx2Fb
	 cUpL0OL71QAL5/2O/chnwrjeX6CEVnQev+CHpl9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Shapovalov <intelfx@intelfx.name>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/218] btrfs: skip inodes without loaded extent maps when shrinking extent maps
Date: Thu,  3 Jul 2025 16:42:30 +0200
Message-ID: <20250703144004.301677993@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit c6c9c4d56483d941f567eb921434c25fc6086dfa ]

If there are inodes that don't have any loaded extent maps, we end up
grabbing a reference on them and later adding a delayed iput, which wakes
up the cleaner and makes it do unnecessary work. This is common when for
example the inodes were open only to run stat(2) or all their extent maps
were already released through the folio release callback
(btrfs_release_folio()) or released by a previous run of the shrinker, or
directories which never have extent maps.

Reported-by: Ivan Shapovalov <intelfx@intelfx.name>
Tested-by: Ivan Shapovalov <intelfx@intelfx.name>
Link: https://lore.kernel.org/linux-btrfs/0414d690ac5680d0d77dfc930606cdc36e42e12f.camel@intelfx.name/
CC: stable@vger.kernel.org # 6.13+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 78 +++++++++++++++++++++++++++++++------------
 1 file changed, 57 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 1d93e1202c339..d67abf5f97a77 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1133,6 +1133,8 @@ static long btrfs_scan_inode(struct btrfs_inode *inode, struct btrfs_em_shrink_c
 	long nr_dropped = 0;
 	struct rb_node *node;
 
+	lockdep_assert_held_write(&tree->lock);
+
 	/*
 	 * Take the mmap lock so that we serialize with the inode logging phase
 	 * of fsync because we may need to set the full sync flag on the inode,
@@ -1144,28 +1146,12 @@ static long btrfs_scan_inode(struct btrfs_inode *inode, struct btrfs_em_shrink_c
 	 * to find new extents, which may not be there yet because ordered
 	 * extents haven't completed yet.
 	 *
-	 * We also do a try lock because otherwise we could deadlock. This is
-	 * because the shrinker for this filesystem may be invoked while we are
-	 * in a path that is holding the mmap lock in write mode. For example in
-	 * a reflink operation while COWing an extent buffer, when allocating
-	 * pages for a new extent buffer and under memory pressure, the shrinker
-	 * may be invoked, and therefore we would deadlock by attempting to read
-	 * lock the mmap lock while we are holding already a write lock on it.
+	 * We also do a try lock because we don't want to block for too long and
+	 * we are holding the extent map tree's lock in write mode.
 	 */
 	if (!down_read_trylock(&inode->i_mmap_lock))
 		return 0;
 
-	/*
-	 * We want to be fast so if the lock is busy we don't want to spend time
-	 * waiting for it - either some task is about to do IO for the inode or
-	 * we may have another task shrinking extent maps, here in this code, so
-	 * skip this inode.
-	 */
-	if (!write_trylock(&tree->lock)) {
-		up_read(&inode->i_mmap_lock);
-		return 0;
-	}
-
 	node = rb_first(&tree->root);
 	while (node) {
 		struct rb_node *next = rb_next(node);
@@ -1205,21 +1191,71 @@ static long btrfs_scan_inode(struct btrfs_inode *inode, struct btrfs_em_shrink_c
 			break;
 		node = next;
 	}
-	write_unlock(&tree->lock);
 	up_read(&inode->i_mmap_lock);
 
 	return nr_dropped;
 }
 
+static struct btrfs_inode *find_first_inode_to_shrink(struct btrfs_root *root,
+						      u64 min_ino)
+{
+	struct btrfs_inode *inode;
+	unsigned long from = min_ino;
+
+	xa_lock(&root->inodes);
+	while (true) {
+		struct extent_map_tree *tree;
+
+		inode = xa_find(&root->inodes, &from, ULONG_MAX, XA_PRESENT);
+		if (!inode)
+			break;
+
+		tree = &inode->extent_tree;
+
+		/*
+		 * We want to be fast so if the lock is busy we don't want to
+		 * spend time waiting for it (some task is about to do IO for
+		 * the inode).
+		 */
+		if (!write_trylock(&tree->lock))
+			goto next;
+
+		/*
+		 * Skip inode if it doesn't have loaded extent maps, so we avoid
+		 * getting a reference and doing an iput later. This includes
+		 * cases like files that were opened for things like stat(2), or
+		 * files with all extent maps previously released through the
+		 * release folio callback (btrfs_release_folio()) or released in
+		 * a previous run, or directories which never have extent maps.
+		 */
+		if (RB_EMPTY_ROOT(&tree->root)) {
+			write_unlock(&tree->lock);
+			goto next;
+		}
+
+		if (igrab(&inode->vfs_inode))
+			break;
+
+		write_unlock(&tree->lock);
+next:
+		from = btrfs_ino(inode) + 1;
+		cond_resched_lock(&root->inodes.xa_lock);
+	}
+	xa_unlock(&root->inodes);
+
+	return inode;
+}
+
 static long btrfs_scan_root(struct btrfs_root *root, struct btrfs_em_shrink_ctx *ctx)
 {
 	struct btrfs_inode *inode;
 	long nr_dropped = 0;
 	u64 min_ino = ctx->last_ino + 1;
 
-	inode = btrfs_find_first_inode(root, min_ino);
+	inode = find_first_inode_to_shrink(root, min_ino);
 	while (inode) {
 		nr_dropped += btrfs_scan_inode(inode, ctx);
+		write_unlock(&inode->extent_tree.lock);
 
 		min_ino = btrfs_ino(inode) + 1;
 		ctx->last_ino = btrfs_ino(inode);
@@ -1230,7 +1266,7 @@ static long btrfs_scan_root(struct btrfs_root *root, struct btrfs_em_shrink_ctx
 
 		cond_resched();
 
-		inode = btrfs_find_first_inode(root, min_ino);
+		inode = find_first_inode_to_shrink(root, min_ino);
 	}
 
 	if (inode) {
-- 
2.39.5



