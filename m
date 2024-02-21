Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556E455E5E;
	Wed, 21 Feb 2024 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523912; cv=none; b=EgDFYc/MIyUgY74Iej78OI4nICJVr6QwPYE1QAXHA5yYX1IsifZnjxannEy4ocnkGXqav4i99W7R/W39y2RIe1tYvXe11gcskg1a1cFIz10MW+Cx1djViI5WjjdNpeoZR2bIRrXDDTr7GKcFvkJd/LDAQJYLck0uWWPIpzs2/5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523912; c=relaxed/simple;
	bh=vTMlVpJYk8QdYmWbihrNJ31JMs6e9vvvPBMnuRzKEAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=le8JR4w3LINcQdT3xtzNTdjSmfuo0JLbX6I3rQvMWtnb+9tdorvBn88Nf98BxPOdV9Tt+ERPVK0y1r24jTjUlJrkGzJvprPbuAAKD8duN4+Qounio9y2/D4OPTg8KjGlAeHXFhIigHVXyrFgLdmJZOmfyWtITTWiLMUZVE9ZTHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNBV4h3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNBV4h3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E68C433C7;
	Wed, 21 Feb 2024 13:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523912;
	bh=vTMlVpJYk8QdYmWbihrNJ31JMs6e9vvvPBMnuRzKEAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNBV4h3z9yZLBzO6RpeZ/1Cw6uO9AVVfZwI6MvgRLHBjHdhHDgYwbVrfcdrQBt8yL
	 BWlrZ1v8Nl9J1ycHEMepquFMuQ2DsMQ3I97DQJOE6z1m2Dyn44RVL+fl/PDNWjL03X
	 HndMLwGqWishWEWifXBG7XZWEk/ZLmqqhfBir/Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nborisov@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/379] btrfs: remove err variable from btrfs_delete_subvolume
Date: Wed, 21 Feb 2024 14:04:28 +0100
Message-ID: <20240221125957.539486757@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit ee0d904fd9c5662c58a737c77384f8959fdc8d12 ]

Use only a single 'ret' to control whether we should abort the
transaction or not. That's fine, because if we abort a transaction then
btrfs_end_transaction will return the same value as passed to
btrfs_abort_transaction. No semantic changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 3324d0547861 ("btrfs: avoid copying BTRFS_ROOT_SUBVOL_DEAD flag to snapshot of subvolume being deleted")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c900a39666e3..c6b861f5bcfe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4007,7 +4007,6 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 	struct btrfs_block_rsv block_rsv;
 	u64 root_flags;
 	int ret;
-	int err;
 
 	/*
 	 * Don't allow to delete a subvolume with send in progress. This is
@@ -4036,8 +4035,8 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 
 	down_write(&fs_info->subvol_sem);
 
-	err = may_destroy_subvol(dest);
-	if (err)
+	ret = may_destroy_subvol(dest);
+	if (ret)
 		goto out_up_write;
 
 	btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
@@ -4046,13 +4045,13 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 	 * two for dir entries,
 	 * two for root ref/backref.
 	 */
-	err = btrfs_subvolume_reserve_metadata(root, &block_rsv, 5, true);
-	if (err)
+	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv, 5, true);
+	if (ret)
 		goto out_up_write;
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
+		ret = PTR_ERR(trans);
 		goto out_release;
 	}
 	trans->block_rsv = &block_rsv;
@@ -4062,7 +4061,6 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 
 	ret = btrfs_unlink_subvol(trans, dir, dentry);
 	if (ret) {
-		err = ret;
 		btrfs_abort_transaction(trans, ret);
 		goto out_end_trans;
 	}
@@ -4080,7 +4078,6 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 					dest->root_key.objectid);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
-			err = ret;
 			goto out_end_trans;
 		}
 	}
@@ -4090,7 +4087,6 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 				  dest->root_key.objectid);
 	if (ret && ret != -ENOENT) {
 		btrfs_abort_transaction(trans, ret);
-		err = ret;
 		goto out_end_trans;
 	}
 	if (!btrfs_is_empty_uuid(dest->root_item.received_uuid)) {
@@ -4100,7 +4096,6 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 					  dest->root_key.objectid);
 		if (ret && ret != -ENOENT) {
 			btrfs_abort_transaction(trans, ret);
-			err = ret;
 			goto out_end_trans;
 		}
 	}
@@ -4111,14 +4106,12 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
 	ret = btrfs_end_transaction(trans);
-	if (ret && !err)
-		err = ret;
 	inode->i_flags |= S_DEAD;
 out_release:
 	btrfs_subvolume_release_metadata(root, &block_rsv);
 out_up_write:
 	up_write(&fs_info->subvol_sem);
-	if (err) {
+	if (ret) {
 		spin_lock(&dest->root_item_lock);
 		root_flags = btrfs_root_flags(&dest->root_item);
 		btrfs_set_root_flags(&dest->root_item,
@@ -4136,7 +4129,7 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 		}
 	}
 
-	return err;
+	return ret;
 }
 
 static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
-- 
2.43.0



