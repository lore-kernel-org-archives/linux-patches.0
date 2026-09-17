Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800213B7752;
	Thu, 17 Sep 2026 19:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671705; cv=none; b=DpzEhPRDGBa16V5ruq4pTnFYZ3sbLLzCmVvN2X75jbGiZ5UBO+sv+o9gOTZu+ujlZ7hqaUJGmtFQc1uSLCw4cBtCUZtUYepZu1dKSHd2v/2qCwoc72AnZzv5S80C8tHDqIglH35ICdYOWDGv5zMrjEw7kEM6Y4//2VLnTOLT6Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671705; c=relaxed/simple;
	bh=ME0Kj3l0V7JqhKS2iO+HLLrjyMX8f3O8he6WGvRj3kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JziNGqbZGSQgxwvWRPHWHWBjdqjHcy22+kHUlLozfOcA1dOZegPo2qyYLf4m+XdS/gQh8nBhGPoY2iwTq1LNOIYmE809wftk/W4md8FJzJRkdGssyETOttrOY4jnOBJ9HqyzEXSAGDwTaBNiIQZwuRK71MnGQqsUul2goFqIQeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rx0Gvo23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rx0Gvo23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F761F000FF;
	Thu, 17 Sep 2026 19:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671704;
	bh=iyITG1QNo9UoAKTNMeioYBLNizmhSxywCOZ/VZumRKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rx0Gvo23rcuJdtmjZD52nTMxwtznAj7I0W57z50va+zJLmXr9LBSpY/qFMFcoPr6C
	 8hxRxhJNNVMWtwPluFFYkjj5j83HosFmY4QLoVcJ2+C6pD1DhMo9dCCwwQ1DlQxWlU
	 B/Du+GK9aP3Rht99WnD6neeCnWZA1NcQTsQ6GY8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1046/1102] btrfs: pass struct btrfs_inode to btrfs_sync_inode_flags_to_i_flags()
Date: Thu, 17 Sep 2026 16:16:29 +0100
Message-ID: <20260917151607.058086081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 4f27a693940bcf313d17792ac4ec13a83f71cf25 ]

Pass a struct btrfs_inode to btrfs_sync_inode_flags_to_i_flags() as it's
an internal interface.

Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 15f7c86215e8 ("btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c  |    4 ++--
 fs/btrfs/ioctl.c  |   19 +++++++++----------
 fs/btrfs/ioctl.h  |    4 ++--
 fs/btrfs/verity.c |    4 ++--
 4 files changed, 15 insertions(+), 16 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3975,7 +3975,7 @@ cache_acl:
 		break;
 	}
 
-	btrfs_sync_inode_flags_to_i_flags(inode);
+	btrfs_sync_inode_flags_to_i_flags(BTRFS_I(inode));
 	return 0;
 }
 
@@ -6212,7 +6212,7 @@ static void btrfs_inherit_iflags(struct
 			inode->flags |= BTRFS_INODE_NODATASUM;
 	}
 
-	btrfs_sync_inode_flags_to_i_flags(&inode->vfs_inode);
+	btrfs_sync_inode_flags_to_i_flags(inode);
 }
 
 int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -166,25 +166,24 @@ static unsigned int btrfs_inode_flags_to
 /*
  * Update inode->i_flags based on the btrfs internal flags.
  */
-void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
+void btrfs_sync_inode_flags_to_i_flags(struct btrfs_inode *inode)
 {
-	struct btrfs_inode *binode = BTRFS_I(inode);
 	unsigned int new_fl = 0;
 
-	if (binode->flags & BTRFS_INODE_SYNC)
+	if (inode->flags & BTRFS_INODE_SYNC)
 		new_fl |= S_SYNC;
-	if (binode->flags & BTRFS_INODE_IMMUTABLE)
+	if (inode->flags & BTRFS_INODE_IMMUTABLE)
 		new_fl |= S_IMMUTABLE;
-	if (binode->flags & BTRFS_INODE_APPEND)
+	if (inode->flags & BTRFS_INODE_APPEND)
 		new_fl |= S_APPEND;
-	if (binode->flags & BTRFS_INODE_NOATIME)
+	if (inode->flags & BTRFS_INODE_NOATIME)
 		new_fl |= S_NOATIME;
-	if (binode->flags & BTRFS_INODE_DIRSYNC)
+	if (inode->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
-	if (binode->ro_flags & BTRFS_INODE_RO_VERITY)
+	if (inode->ro_flags & BTRFS_INODE_RO_VERITY)
 		new_fl |= S_VERITY;
 
-	set_mask_bits(&inode->i_flags,
+	set_mask_bits(&inode->vfs_inode.i_flags,
 		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
 		      S_VERITY, new_fl);
 }
@@ -395,7 +394,7 @@ update_flags:
 		mapping_clear_stable_writes(inode->vfs_inode.i_mapping);
 	else
 		mapping_set_stable_writes(inode->vfs_inode.i_mapping);
-	btrfs_sync_inode_flags_to_i_flags(&inode->vfs_inode);
+	btrfs_sync_inode_flags_to_i_flags(inode);
 	inode_inc_iversion(&inode->vfs_inode);
 	inode_set_ctime_current(&inode->vfs_inode);
 	ret = btrfs_update_inode(trans, inode);
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -9,8 +9,8 @@ struct file;
 struct dentry;
 struct mnt_idmap;
 struct fileattr;
-struct inode;
 struct io_uring_cmd;
+struct btrfs_inode;
 struct btrfs_fs_info;
 struct btrfs_ioctl_balance_args;
 
@@ -20,7 +20,7 @@ int btrfs_fileattr_get(struct dentry *de
 int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		       struct dentry *dentry, struct fileattr *fa);
 int btrfs_ioctl_get_supported_features(void __user *arg);
-void btrfs_sync_inode_flags_to_i_flags(struct inode *inode);
+void btrfs_sync_inode_flags_to_i_flags(struct btrfs_inode *inode);
 void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
 				     struct btrfs_ioctl_balance_args *bargs);
 
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -485,7 +485,7 @@ static int rollback_verity(struct btrfs_
 		goto out;
 	}
 	inode->ro_flags &= ~BTRFS_INODE_RO_VERITY;
-	btrfs_sync_inode_flags_to_i_flags(&inode->vfs_inode);
+	btrfs_sync_inode_flags_to_i_flags(inode);
 	ret = btrfs_update_inode(trans, inode);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
@@ -552,7 +552,7 @@ static int finish_verity(struct btrfs_in
 		goto out;
 	}
 	inode->ro_flags |= BTRFS_INODE_RO_VERITY;
-	btrfs_sync_inode_flags_to_i_flags(&inode->vfs_inode);
+	btrfs_sync_inode_flags_to_i_flags(inode);
 	ret = btrfs_update_inode(trans, inode);
 	if (ret)
 		goto end_trans;


