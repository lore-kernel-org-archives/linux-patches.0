Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3048240F754;
	Fri,  4 Sep 2026 05:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498693; cv=none; b=EPK8LZ3/7sqTSq7LWqFgVbroTtjOgI+7rN12Sm6Ljj5BLt/rSA7jyQDPuw5rmNpT3PNOo8fUGsE3I+gH+583LdFPTFqDZGoVmGTr/aA934xq8Rnwj+T1zpkCAKz2uBeASmLHcaPTsK+XNbfr+CbWB+GWis+FwAziuNTU5oR6KU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498693; c=relaxed/simple;
	bh=21hBjnNjrL24lcABIUnExADjtZV+fM+3nazTUyewsMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEVsxdHRUfNDl7ijwBKsSocFKhCpeCUfg7N8qTnstaQLanX5DLgeSB8kJr9MV+AHuEC8kda68p71Zt+JwpJ6OWqNhPuiQ/9JD5FI2FcyWixcjli76lPC+Xho2w+5VyFvW/GKbpf7Yz84M3nKHht/4kdzKUpzyGGmTFSx94Syy74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CiBW2kX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CiBW2kX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CEF1F00A3D;
	Fri,  4 Sep 2026 05:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498691;
	bh=xjGKGQT1TB48SLFuHh9BapCYkGwCVz8Xc1geTmovq4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0CiBW2kX+PAWc8yO6GkvNlMdrZHb7TLsTiZtvPPJHvm55f0JKkpAaWXLsn/iR0OvG
	 uMKgAUgbi++f9TeZtvm1bQy0a7YcbDQvxaoupfOPFUfpRY8ir5JOZyjA9Fws3xmOsd
	 15dHdBcxDzoYJF97OkRh99EGf3vDBWi2stbQx1sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 7.2 126/713] nilfs2: fix slab-out-of-bounds in nilfs_direct_propagate after truncation
Date: Fri,  4 Sep 2026 06:51:34 +0200
Message-ID: <20260904045806.659292149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 45662dedb8f272ef7f16e69f13424c4bd0399240 upstream.

Shuangpeng Bai reported that KASAN detected a slab-out-of-bounds error
in nilfs_direct_propagate() during testing.

Analysis revealed that after truncating a file, a node block immediately
below the B-tree root was not deleted.  Instead, it remained in the B-tree
node cache in a dirty state.  The log writer subsequently detected this
block and incorrectly invoked nilfs_direct_propagate() on it, which is
designed to handle only data blocks in direct mapping.

B-tree nodes in the cache are managed by virtual block numbers, and their
logical keys typically exceed the range expected by direct mapping.
Consequently, processing such a node as a direct mapping entry triggers
a slab-out-of-bounds access.

The root cause is that when a B-tree mapping collapses into a direct
mapping during truncation, an intermediate node block pointed to by the
root node is left behind as garbage instead of being explicitly deleted.

This resolves the issue by adding a nilfs_btree_discard() operation
to delete the remaining intermediate node block during the conversion.
A 'deform' flag is added to the bop_delete interface to explicitly signal
that the deletion is part of a mapping transformation.  This allows the
B-tree mapping implementation to perform the necessary cleanup and
discarding of the residual node structure that would be otherwise be left
orphaned after the transition.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/r/08A3603A-ADB6-484C-9015-9AC1340E6FB8@gmail.com
Fixes: 36a580eb489f ("nilfs2: direct block mapping")
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/bmap.c   |    2 +-
 fs/nilfs2/bmap.h   |    2 +-
 fs/nilfs2/btree.c  |   39 ++++++++++++++++++++++++++++++++-------
 fs/nilfs2/direct.c |    4 ++--
 4 files changed, 36 insertions(+), 11 deletions(-)

--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -175,7 +175,7 @@ static int nilfs_bmap_do_delete(struct n
 			return ret;
 	}
 
-	return bmap->b_ops->bop_delete(bmap, key);
+	return bmap->b_ops->bop_delete(bmap, key, false);
 }
 
 /**
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -63,7 +63,7 @@ struct nilfs_bmap_operations {
 	int (*bop_lookup_contig)(const struct nilfs_bmap *, __u64, __u64 *,
 				 unsigned int);
 	int (*bop_insert)(struct nilfs_bmap *, __u64, __u64);
-	int (*bop_delete)(struct nilfs_bmap *, __u64);
+	int (*bop_delete)(struct nilfs_bmap *bmap, __u64 key, bool deform);
 	void (*bop_clear)(struct nilfs_bmap *);
 
 	int (*bop_propagate)(struct nilfs_bmap *, struct buffer_head *);
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1425,6 +1425,28 @@ static void nilfs_btree_shrink(struct ni
 	path[level].bp_bh = NULL;
 }
 
+/**
+ * nilfs_btree_discard - discard the last node for the mapping transformation
+ * @btree: bmap struct of btree
+ * @path: array of nilfs_btree_path struct
+ * @level: level of the B-tree node being operated on
+ * @keyp: argument for passing a key (unused)
+ * @ptrp: argument for passing a pointer (unused)
+ */
+static void nilfs_btree_discard(struct nilfs_bmap *btree,
+				struct nilfs_btree_path *path, int level,
+				__u64 *keyp, __u64 *ptrp)
+{
+	struct nilfs_btree_node *root = nilfs_btree_get_root(btree);
+
+	nilfs_btree_node_delete(root, 0, NULL, NULL,
+				NILFS_BTREE_ROOT_NCHILDREN_MAX);
+	nilfs_btree_node_set_level(root, level);
+
+	nilfs_btnode_delete(path[level].bp_bh);
+	path[level].bp_bh = NULL;
+}
+
 static void nilfs_btree_nop(struct nilfs_bmap *btree,
 			    struct nilfs_btree_path *path,
 			    int level, __u64 *keyp, __u64 *ptrp)
@@ -1435,7 +1457,7 @@ static int nilfs_btree_prepare_delete(st
 				      struct nilfs_btree_path *path,
 				      int *levelp,
 				      struct nilfs_bmap_stats *stats,
-				      struct inode *dat)
+				      struct inode *dat, bool deform)
 {
 	struct buffer_head *bh;
 	struct nilfs_btree_node *node, *parent, *sib;
@@ -1522,15 +1544,17 @@ static int nilfs_btree_prepare_delete(st
 			if (nilfs_btree_node_get_nchildren(node) - 1 <=
 			    NILFS_BTREE_ROOT_NCHILDREN_MAX) {
 				path[level].bp_op = nilfs_btree_shrink;
-				stats->bs_nblocks += 2;
-				level++;
-				path[level].bp_op = nilfs_btree_nop;
-				goto shrink_root_child;
+			} else if (deform) {
+				path[level].bp_op = nilfs_btree_discard;
 			} else {
 				path[level].bp_op = nilfs_btree_do_delete;
 				stats->bs_nblocks++;
 				goto out;
 			}
+			stats->bs_nblocks += 2;
+			level++;
+			path[level].bp_op = nilfs_btree_nop;
+			goto shrink_root_child;
 		}
 	}
 
@@ -1581,7 +1605,7 @@ static void nilfs_btree_commit_delete(st
 		nilfs_bmap_set_dirty(btree);
 }
 
-static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key)
+static int nilfs_btree_delete(struct nilfs_bmap *btree, __u64 key, bool deform)
 
 {
 	struct nilfs_btree_path *path;
@@ -1601,7 +1625,8 @@ static int nilfs_btree_delete(struct nil
 
 	dat = NILFS_BMAP_USE_VBN(btree) ? nilfs_bmap_get_dat(btree) : NULL;
 
-	ret = nilfs_btree_prepare_delete(btree, path, &level, &stats, dat);
+	ret = nilfs_btree_prepare_delete(btree, path, &level, &stats, dat,
+			deform);
 	if (ret < 0)
 		goto out;
 	nilfs_btree_commit_delete(btree, path, level, dat);
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -144,7 +144,7 @@ static int nilfs_direct_insert(struct ni
 	return ret;
 }
 
-static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key)
+static int nilfs_direct_delete(struct nilfs_bmap *bmap, __u64 key, bool deform)
 {
 	union nilfs_bmap_ptr_req req;
 	struct inode *dat;
@@ -234,7 +234,7 @@ int nilfs_direct_delete_and_convert(stru
 	/* no need to allocate any resource for conversion */
 
 	/* delete */
-	ret = bmap->b_ops->bop_delete(bmap, key);
+	ret = bmap->b_ops->bop_delete(bmap, key, true);
 	if (ret < 0)
 		return ret;
 


