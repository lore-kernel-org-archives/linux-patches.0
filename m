Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F9546AF31;
	Wed, 20 May 2026 18:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303027; cv=none; b=KF74n7Bg5YuaIUII3gd3dvhkrPwyHTZ/2CbnyaXI4P0TU+idkaTxDWjfGs4XE/KTI+dFRkJ1nBbc5xCcP3fxym53fikkvzOBGruCm7TvxbKzI1v29eb8L3ESkOc+PUxcLeTA0OsFyRIwpyqayYBorP+M3mqaFJhoaZSmEKPCJEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303027; c=relaxed/simple;
	bh=+EPJYcVNYncFxYlHCMWcahEWuPEjxv3ONgtVRbCQpDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emWFbQcFYH1WAxiSV3J6gP/U6GfrIKdgqN13H5tUMgB6GKviRzTMahcTSh6EP3Lqi4X4hKEnqAZOxVRDyAvLSLSzm3SHN6q5Lt3c4OyZcdLH5qgc2BGDvimQ8BRekD7/qVM8Y34DccaZ2hJlI9DpDsXnh7S+Sf1ogqDe9zs3j1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eiSct0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eiSct0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622DA1F00893;
	Wed, 20 May 2026 18:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303024;
	bh=g1wpJoQO8/P3khu50Zni3FcYzpJkIEm9TRAJeCeTxuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0eiSct0doaXWQluhpirFMQlokLZugAWhlRfDFn4qzYmGmHgQMQFt9xnCUBGsB959X
	 cqDJHVt4g9kw8gg3Yp7ZlnDB9WR0d4FrJEMvz9+O/Ahj6nii2tWzouvS5Pnm6KDUAb
	 hnYIvaPOKvQbWBuQ64UVaPn2FuY2Ln4GjvO8i/fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 491/508] btrfs: use btrfs inodes in btrfs_rmdir() to avoid so much usage of BTRFS_I()
Date: Wed, 20 May 2026 18:25:14 +0200
Message-ID: <20260520162109.234320465@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 98060e1611177ddc842601a58258876ab435fdbf ]

Almost everywhere we want to use a btrfs inode and therefore we have a
lot of calls to BTRFS_I(), making the code more verbose. Instead use btrfs
inode local variables to avoid so much use of BTRFS_I().

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 999757231c49 ("btrfs: fix missing last_unlink_trans update when removing a directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4623,32 +4623,33 @@ out_up_write:
 	return ret;
 }
 
-static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
+static int btrfs_rmdir(struct inode *vfs_dir, struct dentry *dentry)
 {
-	struct inode *inode = d_inode(dentry);
-	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_inode *dir = BTRFS_I(vfs_dir);
+	struct btrfs_inode *inode = BTRFS_I(d_inode(dentry));
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int ret = 0;
 	struct btrfs_trans_handle *trans;
 	struct fscrypt_name fname;
 
-	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
+	if (inode->vfs_inode.i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
-	if (btrfs_ino(BTRFS_I(inode)) == BTRFS_FIRST_FREE_OBJECTID) {
+	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
 		if (unlikely(btrfs_fs_incompat(fs_info, EXTENT_TREE_V2))) {
 			btrfs_err(fs_info,
 			"extent tree v2 doesn't support snapshot deletion yet");
 			return -EOPNOTSUPP;
 		}
-		return btrfs_delete_subvolume(BTRFS_I(dir), dentry);
+		return btrfs_delete_subvolume(dir, dentry);
 	}
 
-	ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
+	ret = fscrypt_setup_filename(vfs_dir, &dentry->d_name, 1, &fname);
 	if (ret)
 		return ret;
 
 	/* This needs to handle no-key deletions later on */
 
-	trans = __unlink_start_trans(BTRFS_I(dir));
+	trans = __unlink_start_trans(dir);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_notrans;
@@ -4668,22 +4669,22 @@ static int btrfs_rmdir(struct inode *dir
 	 * This is because we can't unlink other roots when replaying the dir
 	 * deletes for directory foo.
 	 */
-	if (BTRFS_I(inode)->last_unlink_trans >= trans->transid)
-		btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
+	if (inode->last_unlink_trans >= trans->transid)
+		btrfs_record_snapshot_destroy(trans, dir);
 
-	if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
-		ret = btrfs_unlink_subvol(trans, BTRFS_I(dir), dentry);
+	if (unlikely(btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
+		ret = btrfs_unlink_subvol(trans, dir, dentry);
 		goto out;
 	}
 
-	ret = btrfs_orphan_add(trans, BTRFS_I(inode));
+	ret = btrfs_orphan_add(trans, inode);
 	if (ret)
 		goto out;
 
 	/* now the directory is empty */
-	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(inode), &fname.disk_name);
+	ret = btrfs_unlink_inode(trans, dir, inode, &fname.disk_name);
 	if (!ret)
-		btrfs_i_size_write(BTRFS_I(inode), 0);
+		btrfs_i_size_write(inode, 0);
 out:
 	btrfs_end_transaction(trans);
 out_notrans:


