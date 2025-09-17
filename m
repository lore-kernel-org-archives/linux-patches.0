Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427EF302CDC;
	Wed, 17 Sep 2025 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113331; cv=none; b=a6uXtcN3yJvChc03EI+QZrB1eT2TgF7gsVANqNS2PqtX4GSCg4aUxKf/aqVEYDeUzEu9WF2U9KdlfBRjSKCL2j1iinG0mPRoY1YDrkrNujxfHMvrNWmzaUsSq+G49aEE6Ddy9azrLg0JKjRnJ1J3xehw6yM/evi3MWmPcGI9PE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113331; c=relaxed/simple;
	bh=CK074iQUMUKFyDN5QZMp62WVpvyeQvZ8Jb3ifmjPF/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wjg/8Jayy5bFrRXCfIlSSfcXkzDnD2jdKMgLgoqfHIlBrHAHsiCKtv/6ebfwbFZyA6I2gy89z0zvXDn7b0UT9U5WRwLPe0zhFzQK56DtJbaGopiPS1DjgOIZ5yiLb1wIo6iap5e9lrUwebv4HLQbkAtO+Wpxd8o+rViFSm6hpkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtADsFw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtADsFw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1010C4CEF0;
	Wed, 17 Sep 2025 12:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113331;
	bh=CK074iQUMUKFyDN5QZMp62WVpvyeQvZ8Jb3ifmjPF/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtADsFw5FL3Z53rm8hckwOS9UBJc+Y0KWqf7fRmK7eWpJRx9IP+0hXmuBnX8OmSyH
	 AqsSGczJ9N5AbpR//gvoNldYNDWYnOzZJaW0WlZHMFspAF7Vh2QVOIcBLPPx5x03Ob
	 8sY/R+wMyyBPcOnclx0JO/+LY0eWkQRb48Oeu/GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	Leo Martins <loemra.dev@gmail.com>,
	Omar Sandoval <osandov@fb.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 053/140] btrfs: fix subvolume deletion lockup caused by inodes xarray race
Date: Wed, 17 Sep 2025 14:33:45 +0200
Message-ID: <20250917123345.602931052@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Sandoval <osandov@fb.com>

commit f6a6c280059c4ddc23e12e3de1b01098e240036f upstream.

There is a race condition between inode eviction and inode caching that
can cause a live struct btrfs_inode to be missing from the root->inodes
xarray. Specifically, there is a window during evict() between the inode
being unhashed and deleted from the xarray. If btrfs_iget() is called
for the same inode in that window, it will be recreated and inserted
into the xarray, but then eviction will delete the new entry, leaving
nothing in the xarray:

Thread 1                          Thread 2
---------------------------------------------------------------
evict()
  remove_inode_hash()
                                  btrfs_iget_path()
                                    btrfs_iget_locked()
                                    btrfs_read_locked_inode()
                                      btrfs_add_inode_to_root()
  destroy_inode()
    btrfs_destroy_inode()
      btrfs_del_inode_from_root()
        __xa_erase

In turn, this can cause issues for subvolume deletion. Specifically, if
an inode is in this lost state, and all other inodes are evicted, then
btrfs_del_inode_from_root() will call btrfs_add_dead_root() prematurely.
If the lost inode has a delayed_node attached to it, then when
btrfs_clean_one_deleted_snapshot() calls btrfs_kill_all_delayed_nodes(),
it will loop forever because the delayed_nodes xarray will never become
empty (unless memory pressure forces the inode out). We saw this
manifest as soft lockups in production.

Fix it by only deleting the xarray entry if it matches the given inode
(using __xa_cmpxchg()).

Fixes: 310b2f5d5a94 ("btrfs: use an xarray to track open inodes in a root")
Cc: stable@vger.kernel.org # 6.11+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Co-authored-by: Leo Martins <loemra.dev@gmail.com>
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5634,7 +5634,17 @@ static void btrfs_del_inode_from_root(st
 	bool empty = false;
 
 	xa_lock(&root->inodes);
-	entry = __xa_erase(&root->inodes, btrfs_ino(inode));
+	/*
+	 * This btrfs_inode is being freed and has already been unhashed at this
+	 * point. It's possible that another btrfs_inode has already been
+	 * allocated for the same inode and inserted itself into the root, so
+	 * don't delete it in that case.
+	 *
+	 * Note that this shouldn't need to allocate memory, so the gfp flags
+	 * don't really matter.
+	 */
+	entry = __xa_cmpxchg(&root->inodes, btrfs_ino(inode), inode, NULL,
+			     GFP_ATOMIC);
 	if (entry == inode)
 		empty = xa_empty(&root->inodes);
 	xa_unlock(&root->inodes);


