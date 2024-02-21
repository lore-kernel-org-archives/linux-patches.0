Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E2B76C99;
	Wed, 21 Feb 2024 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523918; cv=none; b=go5R/fOpI+ca2KtrPTFvsDJ9Kntm2Zpuu364MS1iShZ9pLuvGJFRf3idqZKskDSFgZBrzvTV9dap4QdP18RFzvqZA1Tr3Z42KBoHHmMRunPNvnOjZ2vNJlNKz1jWVzTMM7Kh10V/qxlwEJ9PVESn7kW2621e/2N4Gu5lcZaFzaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523918; c=relaxed/simple;
	bh=owHilLRJS5egEkwvXCPYqvS89BN6dYWstivygXv2o5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjdcsdVNavUz7xIdI4+TkP4HPGsl1gbsUGQeK1zHXdPJgHBczHx9L9+JBoFsSxrVVP5zJTY2mf2XFPLFE3qR5W0tCfMVHzmod1R9JGXY4v/NlhkN2pt9cc+fsNxJKg8BOng5LAKSWG6IxHD5GcpFOANTF9uaXtqIpDMDa8W1yX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBJh1Ww+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBJh1Ww+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FFAC433C7;
	Wed, 21 Feb 2024 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523918;
	bh=owHilLRJS5egEkwvXCPYqvS89BN6dYWstivygXv2o5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBJh1Ww+eoxBx4Qt1KZNu4GGGaHnvpRoZQfAaXxjGEAy+w6vcKd9YGfnz374vBxGM
	 1aS2gEpYikRrOURFYUHZZ5GpcAVmsaoq+ZEWb1d90fhGatyJk+4I4WaHGhx9r87ynQ
	 vTSM0HwqXGwgnMmPRNITnViOmOCjj3eyYKwgJ0fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Anand Jain <anand.jain@oracle.com>,
	Omar Sandoval <osandov@fb.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/379] btrfs: avoid copying BTRFS_ROOT_SUBVOL_DEAD flag to snapshot of subvolume being deleted
Date: Wed, 21 Feb 2024 14:04:29 +0100
Message-ID: <20240221125957.568153839@linuxfoundation.org>
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

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit 3324d0547861b16cf436d54abba7052e0c8aa9de ]

Sweet Tea spotted a race between subvolume deletion and snapshotting
that can result in the root item for the snapshot having the
BTRFS_ROOT_SUBVOL_DEAD flag set. The race is:

Thread 1                                      | Thread 2
----------------------------------------------|----------
btrfs_delete_subvolume                        |
  btrfs_set_root_flags(BTRFS_ROOT_SUBVOL_DEAD)|
                                              |btrfs_mksubvol
                                              |  down_read(subvol_sem)
                                              |  create_snapshot
                                              |    ...
                                              |    create_pending_snapshot
                                              |      copy root item from source
  down_write(subvol_sem)                      |

This flag is only checked in send and swap activate, which this would
cause to fail mysteriously.

create_snapshot() now checks the root refs to reject a deleted
subvolume, so we can fix this by locking subvol_sem earlier so that the
BTRFS_ROOT_SUBVOL_DEAD flag and the root refs are updated atomically.

CC: stable@vger.kernel.org # 4.14+
Reported-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c6b861f5bcfe..250b6064876d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4008,6 +4008,8 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 	u64 root_flags;
 	int ret;
 
+	down_write(&fs_info->subvol_sem);
+
 	/*
 	 * Don't allow to delete a subvolume with send in progress. This is
 	 * inside the inode lock so the error handling that has to drop the bit
@@ -4019,25 +4021,25 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 		btrfs_warn(fs_info,
 			   "attempt to delete subvolume %llu during send",
 			   dest->root_key.objectid);
-		return -EPERM;
+		ret = -EPERM;
+		goto out_up_write;
 	}
 	if (atomic_read(&dest->nr_swapfiles)) {
 		spin_unlock(&dest->root_item_lock);
 		btrfs_warn(fs_info,
 			   "attempt to delete subvolume %llu with active swapfile",
 			   root->root_key.objectid);
-		return -EPERM;
+		ret = -EPERM;
+		goto out_up_write;
 	}
 	root_flags = btrfs_root_flags(&dest->root_item);
 	btrfs_set_root_flags(&dest->root_item,
 			     root_flags | BTRFS_ROOT_SUBVOL_DEAD);
 	spin_unlock(&dest->root_item_lock);
 
-	down_write(&fs_info->subvol_sem);
-
 	ret = may_destroy_subvol(dest);
 	if (ret)
-		goto out_up_write;
+		goto out_undead;
 
 	btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
 	/*
@@ -4047,7 +4049,7 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 	 */
 	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv, 5, true);
 	if (ret)
-		goto out_up_write;
+		goto out_undead;
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
@@ -4109,15 +4111,17 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 	inode->i_flags |= S_DEAD;
 out_release:
 	btrfs_subvolume_release_metadata(root, &block_rsv);
-out_up_write:
-	up_write(&fs_info->subvol_sem);
+out_undead:
 	if (ret) {
 		spin_lock(&dest->root_item_lock);
 		root_flags = btrfs_root_flags(&dest->root_item);
 		btrfs_set_root_flags(&dest->root_item,
 				root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
 		spin_unlock(&dest->root_item_lock);
-	} else {
+	}
+out_up_write:
+	up_write(&fs_info->subvol_sem);
+	if (!ret) {
 		d_invalidate(dentry);
 		btrfs_prune_dentries(dest);
 		ASSERT(dest->send_in_progress == 0);
-- 
2.43.0



