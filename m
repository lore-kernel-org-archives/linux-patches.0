Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2831253344;
	Wed,  5 Mar 2025 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198653; cv=none; b=N12v+xTUwbHvVVIaQAVYdJASb2qGp24SNeH/KUDnCYjBSx+PPwbVgvwICPYCgdEcbJpsDaPnukXSdBmLsZlicVNUyAIryrLUUodNApud+RAI/ShhGLZIOvcsCSxGFHs//jvsDiwLG4maZA8pxz7H8bJwTYsg+Uv+q2pXyN/Mdjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198653; c=relaxed/simple;
	bh=YJyU4NvcuG/hAhzrWzKSp3MaxMPskY+DGeYtj3Mcbl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dntSUQjB6g7/m9o3xBuVdevvuGde1PhDeJfELBZk2tk7afQYqcCahbfuOBx/XSyB38IMicM1c/X942VhmDy+wtaNoF4rQ4Rlg2+8vQCebHUQ4GTkY+UXp46elecy62ius1GBQ4qG6vcJOTgMHkggAqYlMsionUAOv1T3ql+07NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY6hhOmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY6hhOmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2537CC4CED1;
	Wed,  5 Mar 2025 18:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198653;
	bh=YJyU4NvcuG/hAhzrWzKSp3MaxMPskY+DGeYtj3Mcbl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mY6hhOmUcbTmhfLLEMUn5/O7DeGKvMR67IV13YGzKJUu1OR2IwPVCNZr6FqXMliVN
	 0boybwrSAjwFBXvjSEa7yVoiMDRfVoW4w2Z/f2LQ/6dayy8ffk53HvfAW+8uPpJN4A
	 krT1xe8ZPFj08yfBe7h1+6+SaUvnGF3S9TVWGcWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Shapovalov <intelfx@intelfx.name>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.13 103/157] btrfs: skip inodes without loaded extent maps when shrinking extent maps
Date: Wed,  5 Mar 2025 18:48:59 +0100
Message-ID: <20250305174509.445503506@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit c6c9c4d56483d941f567eb921434c25fc6086dfa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_map.c |   78 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 21 deletions(-)

--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1128,6 +1128,8 @@ static long btrfs_scan_inode(struct btrf
 	long nr_dropped = 0;
 	struct rb_node *node;
 
+	lockdep_assert_held_write(&tree->lock);
+
 	/*
 	 * Take the mmap lock so that we serialize with the inode logging phase
 	 * of fsync because we may need to set the full sync flag on the inode,
@@ -1139,28 +1141,12 @@ static long btrfs_scan_inode(struct btrf
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
@@ -1201,12 +1187,61 @@ next:
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
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -1214,9 +1249,10 @@ static long btrfs_scan_root(struct btrfs
 	long nr_dropped = 0;
 	u64 min_ino = fs_info->em_shrinker_last_ino + 1;
 
-	inode = btrfs_find_first_inode(root, min_ino);
+	inode = find_first_inode_to_shrink(root, min_ino);
 	while (inode) {
 		nr_dropped += btrfs_scan_inode(inode, ctx);
+		write_unlock(&inode->extent_tree.lock);
 
 		min_ino = btrfs_ino(inode) + 1;
 		fs_info->em_shrinker_last_ino = btrfs_ino(inode);
@@ -1228,7 +1264,7 @@ static long btrfs_scan_root(struct btrfs
 
 		cond_resched();
 
-		inode = btrfs_find_first_inode(root, min_ino);
+		inode = find_first_inode_to_shrink(root, min_ino);
 	}
 
 	if (inode) {


