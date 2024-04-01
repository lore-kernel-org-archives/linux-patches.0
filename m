Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B971CA8F;
	Mon,  1 Apr 2024 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987388; cv=none; b=FM7tUAeST1CEbsppD6wVbx3x9YMGFAW4KNLzxPhf6j297vD7BL5XkJwrZjPXGc0apqzHV6+l/wFW32UvgrkYntSTTWunbEyFnR+Tu4SYPpLpP+L5OrE6cZ4Al99DRvmCeFAnsgO6o/bFSGpCXKgSQap8EgoZpTezwFhQXH/KRa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987388; c=relaxed/simple;
	bh=K+hl92fBnA8CX9tPr3f9mPVnL+D6voGo2qhoEwv4nqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMYDGbgczKr26ZyyzzflQUVlgU8MzB+xlqtTFZzkm3Vc+BMvZLu/qLNEm6hpuVyCtTcyg3bzXZkohjBuqeGpIKv2SuDzdDm+jr5PyHIEnMGVd9jlIhLZgDG2x+Zp+8e8MwgMmNlsRxIQ298ICJlN17bAtA0sWz1+6qXbvitLG5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNx1Z3+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNx1Z3+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14731C433F1;
	Mon,  1 Apr 2024 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987388;
	bh=K+hl92fBnA8CX9tPr3f9mPVnL+D6voGo2qhoEwv4nqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNx1Z3+jesXnRVqD/FyiHWRxXM606ntJlNl0hkQDOW69spwG0CamZNtf/nTqAz5So
	 T8RGqBTaIJAf17e67GBJpwueJaJ4KNBfK4SjRC2ALTyIKGrK4riUiMn+9GiQv29/Mc
	 oMi11LST1G6EdEqjWHHisOje/VqXzMmETDOWbJi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 273/399] btrfs: handle errors returned from unpin_extent_cache()
Date: Mon,  1 Apr 2024 17:43:59 +0200
Message-ID: <20240401152557.332461167@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit c03c89f821e51325d0e592cf625cf5e0a26fa3a7 ]

We've had numerous attempts to let function unpin_extent_cache() return
void as it only returns 0. There are still error cases to handle so do
that, in addition to the verbose messages. The only caller
btrfs_finish_one_ordered() will now abort the transaction, previously it
let it continue which could lead to further problems.

Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 4dc1d69c2b10 ("btrfs: fix warning messages not printing interval at unpin_extent_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 10 +++++++++-
 fs/btrfs/inode.c      |  9 +++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index b61099bf97a82..f170e7122e747 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -291,6 +291,10 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
  * Called after an extent has been written to disk properly.  Set the generation
  * to the generation that actually added the file item to the inode so we know
  * we need to sync this extent when we call fsync().
+ *
+ * Returns: 0	     on success
+ * 	    -ENOENT  when the extent is not found in the tree
+ * 	    -EUCLEAN if the found extent does not match the expected start
  */
 int unpin_extent_cache(struct btrfs_inode *inode, u64 start, u64 len, u64 gen)
 {
@@ -308,14 +312,18 @@ int unpin_extent_cache(struct btrfs_inode *inode, u64 start, u64 len, u64 gen)
 "no extent map found for inode %llu (root %lld) when unpinning extent range [%llu, %llu), generation %llu",
 			   btrfs_ino(inode), btrfs_root_id(inode->root),
 			   start, len, gen);
+		ret = -ENOENT;
 		goto out;
 	}
 
-	if (WARN_ON(em->start != start))
+	if (WARN_ON(em->start != start)) {
 		btrfs_warn(fs_info,
 "found extent map for inode %llu (root %lld) with unexpected start offset %llu when unpinning extent range [%llu, %llu), generation %llu",
 			   btrfs_ino(inode), btrfs_root_id(inode->root),
 			   em->start, start, len, gen);
+		ret = -EUCLEAN;
+		goto out;
+	}
 
 	em->generation = gen;
 	em->flags &= ~EXTENT_FLAG_PINNED;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8151ad5f4650b..5ceb995709b56 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3127,8 +3127,13 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->disk_num_bytes);
 		}
 	}
-	unpin_extent_cache(inode, ordered_extent->file_offset,
-			   ordered_extent->num_bytes, trans->transid);
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
+
+	ret = unpin_extent_cache(inode, ordered_extent->file_offset,
+				 ordered_extent->num_bytes, trans->transid);
 	if (ret < 0) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
-- 
2.43.0



