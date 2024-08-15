Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1C919FA99;
	Thu, 15 Aug 2024 13:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729948; cv=none; b=gwvcwXLkYZ08HPuF0bXuBJzSDFwUidOi/7p5ka0bm1u4DirCc+kvEcl0gYTWyBRCgMD6C0ClUcAgW5P35c/PzD4BdKYnyUKDnn/UeFXhXVzgOgwSUdLQSg6Hw3zMnlEwGRl8i6zwtqYuT1zPlNU1mgUVUTg8wtlC25D1cW01f0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729948; c=relaxed/simple;
	bh=yml992Xpcgw3fs9s1sy+ckPq7ZSiDfP07T6eA4+M5B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWoG/oC35EctK0a2J/4S0VBUHCRT1mB91I5J01stZznnKSXWb3/s1dihul+1dXLotCKjKkApfG3PFtRCvDbLYCMisoUQt7Yj//Bb130Jr0vx5izOWUehFBKeNn7cn8R9h3GVYZsxJbYSjTCBJZTlzfD/zX0irvm5UUZXNAtZNJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0ZwMFsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0ZwMFsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52414C32786;
	Thu, 15 Aug 2024 13:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729948;
	bh=yml992Xpcgw3fs9s1sy+ckPq7ZSiDfP07T6eA4+M5B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0ZwMFsrLI3RHLlNz+GiKJdZ0XOJvVKZVAJK6v9GDkWbGKIabyrWiTaDBX6pxihe3
	 O4Z6OLn3l8eAF3dThIfaGfPsoZsOTIApjcyRV6caZW505ViOth01jHyAystfHvvdEw
	 GLkCW6E7yK+spSoV7iABl5LW+T7YXjC+aMzKpFq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 257/484] nilfs2: handle inconsistent state in nilfs_btnode_create_block()
Date: Thu, 15 Aug 2024 15:21:55 +0200
Message-ID: <20240815131951.328785931@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 4811f7af6090e8f5a398fbdd766f903ef6c0d787 upstream.

Syzbot reported that a buffer state inconsistency was detected in
nilfs_btnode_create_block(), triggering a kernel bug.

It is not appropriate to treat this inconsistency as a bug; it can occur
if the argument block address (the buffer index of the newly created
block) is a virtual block number and has been reallocated due to
corruption of the bitmap used to manage its allocation state.

So, modify nilfs_btnode_create_block() and its callers to treat it as a
possible filesystem error, rather than triggering a kernel bug.

Link: https://lkml.kernel.org/r/20240725052007.4562-1-konishi.ryusuke@gmail.com
Fixes: a60be987d45d ("nilfs2: B-tree node cache")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=89cc4f2324ed37988b60
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/btnode.c |   25 ++++++++++++++++++++-----
 fs/nilfs2/btree.c  |    4 ++--
 2 files changed, 22 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -51,12 +51,21 @@ nilfs_btnode_create_block(struct address
 
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
 	if (unlikely(!bh))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (unlikely(buffer_mapped(bh) || buffer_uptodate(bh) ||
 		     buffer_dirty(bh))) {
-		brelse(bh);
-		BUG();
+		/*
+		 * The block buffer at the specified new address was already
+		 * in use.  This can happen if it is a virtual block number
+		 * and has been reallocated due to corruption of the bitmap
+		 * used to manage its allocation state (if not, the buffer
+		 * clearing of an abandoned b-tree node is missing somewhere).
+		 */
+		nilfs_error(inode->i_sb,
+			    "state inconsistency probably due to duplicate use of b-tree node block address %llu (ino=%lu)",
+			    (unsigned long long)blocknr, inode->i_ino);
+		goto failed;
 	}
 	memset(bh->b_data, 0, i_blocksize(inode));
 	bh->b_bdev = inode->i_sb->s_bdev;
@@ -67,6 +76,12 @@ nilfs_btnode_create_block(struct address
 	unlock_page(bh->b_page);
 	put_page(bh->b_page);
 	return bh;
+
+failed:
+	unlock_page(bh->b_page);
+	put_page(bh->b_page);
+	brelse(bh);
+	return ERR_PTR(-EIO);
 }
 
 int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
@@ -217,8 +232,8 @@ retry:
 	}
 
 	nbh = nilfs_btnode_create_block(btnc, newkey);
-	if (!nbh)
-		return -ENOMEM;
+	if (IS_ERR(nbh))
+		return PTR_ERR(nbh);
 
 	BUG_ON(nbh == obh);
 	ctxt->newbh = nbh;
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -63,8 +63,8 @@ static int nilfs_btree_get_new_block(con
 	struct buffer_head *bh;
 
 	bh = nilfs_btnode_create_block(btnc, ptr);
-	if (!bh)
-		return -ENOMEM;
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 
 	set_buffer_nilfs_volatile(bh);
 	*bhp = bh;


