Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC867157E8F;
	Mon, 29 Jan 2024 17:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548374; cv=none; b=kZjS/gP5NtZskss9RHfS4WViYxJBLLugHQ2fQD2mT7Km46cWnpvSZNbTHYDVTO26GrDzAuodT1Hp/nlDB+ahPSg/5NvsvQkQenGauRe7hx8QxclPyF1vxovCwkHrXreP2hDBuGodZgGKelGRpH/3G8P4dvr5sg+iZRJoYgp2Xrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548374; c=relaxed/simple;
	bh=KiNyiMxqhyQQv+/3152hs+nyYeMrwyPUIeBgvNq1DMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gy+S4fPa636WyQ2296fDQqcO9otHIKtIXEcPejq3kmTIYj7ROzEDDZE8brLKxaEb/NRJJdyf5ZJ6NoFneO/UALkH1nMHEGQrcxJSbICQddpedkxsSQBZi5Ii4f1JjRVvH8LDikEi1Pc2UgkKjIhMkiiVhmc9r16FjuwsZwEOUyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm60t5DV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm60t5DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75761C433F1;
	Mon, 29 Jan 2024 17:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548374;
	bh=KiNyiMxqhyQQv+/3152hs+nyYeMrwyPUIeBgvNq1DMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm60t5DVXLDcT20FutmtkXHK5D65vkqGH6HHwM6dxahrzVDzYNLU0KRT/pBvHIalV
	 3Qe+gOzjqOKYOvkuEtzdnk1X+IL+PAI0rwPvVZNitJ4f2b5ltC2+KI8U0I9Z0WZ29c
	 fdmNfSLApygv9rAeIYMlRNmG75tBsyDzve7pSAlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Anand Jain <anand.jain@oracle.com>,
	Omar Sandoval <osandov@fb.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 115/185] btrfs: avoid copying BTRFS_ROOT_SUBVOL_DEAD flag to snapshot of subvolume being deleted
Date: Mon, 29 Jan 2024 09:05:15 -0800
Message-ID: <20240129170002.292630459@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Sandoval <osandov@fb.com>

commit 3324d0547861b16cf436d54abba7052e0c8aa9de upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4689,6 +4689,8 @@ int btrfs_delete_subvolume(struct inode
 	u64 root_flags;
 	int ret;
 
+	down_write(&fs_info->subvol_sem);
+
 	/*
 	 * Don't allow to delete a subvolume with send in progress. This is
 	 * inside the inode lock so the error handling that has to drop the bit
@@ -4700,25 +4702,25 @@ int btrfs_delete_subvolume(struct inode
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
@@ -4728,7 +4730,7 @@ int btrfs_delete_subvolume(struct inode
 	 */
 	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv, 5, true);
 	if (ret)
-		goto out_up_write;
+		goto out_undead;
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
@@ -4794,15 +4796,17 @@ out_end_trans:
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


