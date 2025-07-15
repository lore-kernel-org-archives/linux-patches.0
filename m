Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EF52E54BB;
	Tue, 15 Jul 2025 13:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586235; cv=none; b=ljuy30vyPUfONC/2/RVQBU2j1d89weY8UczPpvsMKcyPqrVhLBRLpErs8OzUE0//aoIWLIZHsJhUm4H9/jZlwUQVADUetYUn8qBJBTYV60HvU6E+EnjDSzvuj5WhGgAqtGXlkuy9f1Us6aeuM/5lyC2bOM+Cz5z6w3f3/WHAm2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586235; c=relaxed/simple;
	bh=Fptg0aXQ0JMwsu42umfPm/2plK0E6lYZ5FYDiber4m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6DFQh1Evml9iURro/1BY57cKaDRwY3ccY3FJtElF5BXTVJqmbJyJBJNxFzrhy4CTyXrtIQLsmgc2n4j80IvxNdhQwLZJnf+BpWXF4ZfE88PDIFb8Opyze9Ntv64YDcELwaWiGgglYsoqyr5l8mSOQ0MRV9zByAoj2JbsnDWV90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4Sl2S7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4Sl2S7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F53C4CEE3;
	Tue, 15 Jul 2025 13:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586234;
	bh=Fptg0aXQ0JMwsu42umfPm/2plK0E6lYZ5FYDiber4m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4Sl2S7FJmOb/rbwZO/dAKJzqrrVDBA1TMfeYa1hZ7t1UWRpCkKoFB9CUqZ0SuqEy
	 6XgBEZS6q0dOHNwD67Ad1dwIQ/B0mjjfkpTAYLSCoSANTqHJv1XfEX1MTjuzemsPL/
	 Y00xj8JRkhgLduf7+leNHoC/o43j50Xxvyq4YjA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/77] btrfs: propagate last_unlink_trans earlier when doing a rmdir
Date: Tue, 15 Jul 2025 15:13:34 +0200
Message-ID: <20250715130753.117094590@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

[ Upstream commit c466e33e729a0ee017d10d919cba18f503853c60 ]

In case the removed directory had a snapshot that was deleted, we are
propagating its inode's last_unlink_trans to the parent directory after
we removed the entry from the parent directory. This leaves a small race
window where someone can log the parent directory after we removed the
entry and before we updated last_unlink_trans, and as a result if we ever
try to replay such a log tree, we will fail since we will attempt to
remove a snapshot during log replay, which is currently not possible and
results in the log replay (and mount) to fail. This is the type of failure
described in commit 1ec9a1ae1e30 ("Btrfs: fix unreplayable log after
snapshot delete + parent dir fsync").

So fix this by propagating the last_unlink_trans to the parent directory
before we remove the entry from it.

Fixes: 44f714dae50a ("Btrfs: improve performance on fsync against new inode after rename/unlink")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e3e5bd4fb477a..60079099e24b9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4655,7 +4655,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	int err = 0;
 	struct btrfs_trans_handle *trans;
-	u64 last_unlink_trans;
 
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
@@ -4666,6 +4665,23 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
+	/*
+	 * Propagate the last_unlink_trans value of the deleted dir to its
+	 * parent directory. This is to prevent an unrecoverable log tree in the
+	 * case we do something like this:
+	 * 1) create dir foo
+	 * 2) create snapshot under dir foo
+	 * 3) delete the snapshot
+	 * 4) rmdir foo
+	 * 5) mkdir foo
+	 * 6) fsync foo or some file inside foo
+	 *
+	 * This is because we can't unlink other roots when replaying the dir
+	 * deletes for directory foo.
+	 */
+	if (BTRFS_I(inode)->last_unlink_trans >= trans->transid)
+		BTRFS_I(dir)->last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
+
 	if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 		err = btrfs_unlink_subvol(trans, dir, dentry);
 		goto out;
@@ -4675,28 +4691,12 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (err)
 		goto out;
 
-	last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
-
 	/* now the directory is empty */
 	err = btrfs_unlink_inode(trans, BTRFS_I(dir),
 			BTRFS_I(d_inode(dentry)), dentry->d_name.name,
 			dentry->d_name.len);
-	if (!err) {
+	if (!err)
 		btrfs_i_size_write(BTRFS_I(inode), 0);
-		/*
-		 * Propagate the last_unlink_trans value of the deleted dir to
-		 * its parent directory. This is to prevent an unrecoverable
-		 * log tree in the case we do something like this:
-		 * 1) create dir foo
-		 * 2) create snapshot under dir foo
-		 * 3) delete the snapshot
-		 * 4) rmdir foo
-		 * 5) mkdir foo
-		 * 6) fsync foo or some file inside foo
-		 */
-		if (last_unlink_trans >= trans->transid)
-			BTRFS_I(dir)->last_unlink_trans = last_unlink_trans;
-	}
 out:
 	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(BTRFS_I(dir)->root->fs_info);
-- 
2.39.5



