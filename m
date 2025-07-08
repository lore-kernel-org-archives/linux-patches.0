Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8110A1548C;
	Tue,  8 Jul 2025 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992268; cv=none; b=cse+fQ2gWonLAOwkgfpiCJyQh3KVIPBayE+Rv7swG4PtCbr+ZuuqgW+jVQ7eR70vvTaS4Xz6kslQjjCAN+TT+2gmZoN53MJDjaJImtdx4PMAvUWtRu+2dlj1AtzsJygiBT2cAAP1EFuWlLw65qfcKJRIxMlQCBBdX3Y7hwkmb4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992268; c=relaxed/simple;
	bh=VuzVjdJSMKcgYDJ8i8bdum2F+43P+xwZl0qSQgO3pYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+ncBFAR7uXilscr89wZ+sH0prH0HzvkPC/ICSjFMLjCPWGbE/u8d09VgvFEu8VAQKAb6UemZk0LwP/DX7YAuaSP3IVLoi0iqdBf5zQE+G+qsF6/8Xij7BBycBOdrpnRcXshBpJqQantf+ZA6RUZwBtxzhW1YniibFW6m8xnJVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8eEcYLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8eEcYLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082BDC4CEED;
	Tue,  8 Jul 2025 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992268;
	bh=VuzVjdJSMKcgYDJ8i8bdum2F+43P+xwZl0qSQgO3pYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8eEcYLaWtpwJJQEmhfHpDM9KwHjkZm3nJgtI6L4al06ulhlj7Ea/CHE3RqfWiBhx
	 zRSQC/rOikanA/6yxyc4W1tqdzU/FEg9NGd4re5mwr/vU7CUZEONTDBJYaPLSxDVNb
	 587HtkYXAHrUdgdRbzz4o4d3oafGXPmFCqgYWT2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/132] btrfs: propagate last_unlink_trans earlier when doing a rmdir
Date: Tue,  8 Jul 2025 18:22:25 +0200
Message-ID: <20250708162231.700229666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c2c07ad194c0d..cee1a11959c51 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4617,7 +4617,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	int ret = 0;
 	struct btrfs_trans_handle *trans;
-	u64 last_unlink_trans;
 	struct fscrypt_name fname;
 
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
@@ -4643,6 +4642,23 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		goto out_notrans;
 	}
 
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
 		ret = btrfs_unlink_subvol(trans, BTRFS_I(dir), dentry);
 		goto out;
@@ -4652,27 +4668,11 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (ret)
 		goto out;
 
-	last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
-
 	/* now the directory is empty */
 	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
 				 &fname.disk_name);
-	if (!ret) {
+	if (!ret)
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
 out_notrans:
-- 
2.39.5



