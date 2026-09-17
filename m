Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591B0436BC9;
	Thu, 17 Sep 2026 19:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671671; cv=none; b=R6VxJ1VWyFVks9MmBriLIo1aIZ2Yl/9cS22WuOSuJfy9t0lqKAg4ZssNQcEK1F4uxp++/cPEnJpqoo1Qpn5r445IhVaYAVoLvVl0znqv3zWeq5cRAFSfF03mWQmkqnZyIn7HQfPcZGcGo2HBoHV7PKzinDnMx+kAC1aeqQ0GhoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671671; c=relaxed/simple;
	bh=Lnys4zZ+tcv/na8q1z11/vytlk1SNl+1N2IsGcr9sds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvGPl6vmNHAVYuahvSYOa7I/w1RktXFoHU2CZrUjvde+W4nznJ/nFwltV33yVd9qv7XFCa6zxr54gsjX/9OlxdiYiiOFRUiSCT4nPY9BQx7OYALLKO338mTazE3FRCi/FdEmAWk9m0dBYoKdJRJBbYSa1IspsYJIy9nyPooHM+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8gYsRde; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8gYsRde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7CC1F000FF;
	Thu, 17 Sep 2026 19:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671636;
	bh=lYCdPLW/EYUZxSqzlHWn4vEQOh8aOdXHdS+fuxFFDe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8gYsRde3kEcEChvcTo5Kwr8VlZbJV7UaOx8ToOIaXQhw+Ck9yPDuyWaF4VDwM1EY
	 2N2sXOhBOgVw/y+gX712GwjaQ9RCmhicJMrF4fuajRoE1hA6OH3VBgtb18mROsA0nt
	 jUeK/N4a99HIWpPYX9FbyP+p+e+Ztj5CtHAwsXZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1040/1102] btrfs: move btrfs_is_empty_uuid() from ioctl.c into fs.c
Date: Thu, 17 Sep 2026 16:16:23 +0100
Message-ID: <20260917151606.898625505@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a5b3f117daead61c3c9c88cd1159d38fa4ad1362 ]

It's a generic helper not specific to ioctls and used in several places,
so move it out from ioctl.c and into fs.c. While at it change its return
type from int to bool and declare the loop variable in the loop itself.

This also slightly reduces the module's size.

Before this change:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  1781492	 161037	  16920	1959449	 1de619	fs/btrfs/btrfs.ko

After this change:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  1781340	 161037	  16920	1959297	 1de581	fs/btrfs/btrfs.ko

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 15f7c86215e8 ("btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/fs.c    |    9 +++++
 fs/btrfs/fs.h    |    2 +
 fs/btrfs/ioctl.c |   96 ++++++++++++++++++++++++-------------------------------
 fs/btrfs/ioctl.h |    1 
 4 files changed, 53 insertions(+), 55 deletions(-)

--- a/fs/btrfs/fs.c
+++ b/fs/btrfs/fs.c
@@ -5,6 +5,15 @@
 #include "fs.h"
 #include "accessors.h"
 
+bool __pure btrfs_is_empty_uuid(const u8 *uuid)
+{
+	for (int i = 0; i < BTRFS_UUID_SIZE; i++) {
+		if (uuid[i] != 0)
+			return false;
+	}
+	return true;
+}
+
 void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag,
 			     const char *name)
 {
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -994,6 +994,8 @@ void btrfs_exclop_balance(struct btrfs_f
 
 int btrfs_check_ioctl_vol_args_path(const struct btrfs_ioctl_vol_args *vol_args);
 
+bool __pure btrfs_is_empty_uuid(const u8 *uuid);
+
 /* Compatibility and incompatibility defines */
 void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag,
 			     const char *name);
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -256,15 +256,14 @@ int btrfs_fileattr_get(struct dentry *de
 int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		       struct dentry *dentry, struct fileattr *fa)
 {
-	struct inode *inode = d_inode(dentry);
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
-	struct btrfs_inode *binode = BTRFS_I(inode);
-	struct btrfs_root *root = binode->root;
+	struct btrfs_inode *inode = BTRFS_I(d_inode(dentry));
+	struct btrfs_root *root = inode->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_trans_handle *trans;
 	unsigned int fsflags, old_fsflags;
 	int ret;
 	const char *comp = NULL;
-	u32 binode_flags;
+	u32 inode_flags;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
@@ -272,8 +271,8 @@ int btrfs_fileattr_set(struct mnt_idmap
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
 
-	fsflags = btrfs_mask_fsflags_for_type(inode, fa->flags);
-	old_fsflags = btrfs_inode_flags_to_fsflags(binode);
+	fsflags = btrfs_mask_fsflags_for_type(&inode->vfs_inode, fa->flags);
+	old_fsflags = btrfs_inode_flags_to_fsflags(inode);
 	ret = check_fsflags(old_fsflags, fsflags);
 	if (ret)
 		return ret;
@@ -282,27 +281,27 @@ int btrfs_fileattr_set(struct mnt_idmap
 	if (ret)
 		return ret;
 
-	binode_flags = binode->flags;
+	inode_flags = inode->flags;
 	if (fsflags & FS_SYNC_FL)
-		binode_flags |= BTRFS_INODE_SYNC;
+		inode_flags |= BTRFS_INODE_SYNC;
 	else
-		binode_flags &= ~BTRFS_INODE_SYNC;
+		inode_flags &= ~BTRFS_INODE_SYNC;
 	if (fsflags & FS_IMMUTABLE_FL)
-		binode_flags |= BTRFS_INODE_IMMUTABLE;
+		inode_flags |= BTRFS_INODE_IMMUTABLE;
 	else
-		binode_flags &= ~BTRFS_INODE_IMMUTABLE;
+		inode_flags &= ~BTRFS_INODE_IMMUTABLE;
 	if (fsflags & FS_APPEND_FL)
-		binode_flags |= BTRFS_INODE_APPEND;
+		inode_flags |= BTRFS_INODE_APPEND;
 	else
-		binode_flags &= ~BTRFS_INODE_APPEND;
+		inode_flags &= ~BTRFS_INODE_APPEND;
 	if (fsflags & FS_NODUMP_FL)
-		binode_flags |= BTRFS_INODE_NODUMP;
+		inode_flags |= BTRFS_INODE_NODUMP;
 	else
-		binode_flags &= ~BTRFS_INODE_NODUMP;
+		inode_flags &= ~BTRFS_INODE_NODUMP;
 	if (fsflags & FS_NOATIME_FL)
-		binode_flags |= BTRFS_INODE_NOATIME;
+		inode_flags |= BTRFS_INODE_NOATIME;
 	else
-		binode_flags &= ~BTRFS_INODE_NOATIME;
+		inode_flags &= ~BTRFS_INODE_NOATIME;
 
 	/* If coming from FS_IOC_FSSETXATTR then skip unconverted flags */
 	if (!fa->flags_valid) {
@@ -314,32 +313,32 @@ int btrfs_fileattr_set(struct mnt_idmap
 	}
 
 	if (fsflags & FS_DIRSYNC_FL)
-		binode_flags |= BTRFS_INODE_DIRSYNC;
+		inode_flags |= BTRFS_INODE_DIRSYNC;
 	else
-		binode_flags &= ~BTRFS_INODE_DIRSYNC;
+		inode_flags &= ~BTRFS_INODE_DIRSYNC;
 	if (fsflags & FS_NOCOW_FL) {
-		if (S_ISREG(inode->i_mode)) {
+		if (S_ISREG(inode->vfs_inode.i_mode)) {
 			/*
 			 * It's safe to turn csums off here, no extents exist.
 			 * Otherwise we want the flag to reflect the real COW
 			 * status of the file and will not set it.
 			 */
-			if (inode->i_size == 0)
-				binode_flags |= BTRFS_INODE_NODATACOW |
-						BTRFS_INODE_NODATASUM;
+			if (inode->vfs_inode.i_size == 0)
+				inode_flags |= BTRFS_INODE_NODATACOW |
+					       BTRFS_INODE_NODATASUM;
 		} else {
-			binode_flags |= BTRFS_INODE_NODATACOW;
+			inode_flags |= BTRFS_INODE_NODATACOW;
 		}
 	} else {
 		/*
 		 * Revert back under same assumptions as above
 		 */
-		if (S_ISREG(inode->i_mode)) {
-			if (inode->i_size == 0)
-				binode_flags &= ~(BTRFS_INODE_NODATACOW |
-						  BTRFS_INODE_NODATASUM);
+		if (S_ISREG(inode->vfs_inode.i_mode)) {
+			if (inode->vfs_inode.i_size == 0)
+				inode_flags &= ~(BTRFS_INODE_NODATACOW |
+						 BTRFS_INODE_NODATASUM);
 		} else {
-			binode_flags &= ~BTRFS_INODE_NODATACOW;
+			inode_flags &= ~BTRFS_INODE_NODATACOW;
 		}
 	}
 
@@ -349,21 +348,21 @@ int btrfs_fileattr_set(struct mnt_idmap
 	 * things smaller.
 	 */
 	if (fsflags & FS_NOCOMP_FL) {
-		binode_flags &= ~BTRFS_INODE_COMPRESS;
-		binode_flags |= BTRFS_INODE_NOCOMPRESS;
+		inode_flags &= ~BTRFS_INODE_COMPRESS;
+		inode_flags |= BTRFS_INODE_NOCOMPRESS;
 	} else if (fsflags & FS_COMPR_FL) {
 
-		if (IS_SWAPFILE(inode))
+		if (IS_SWAPFILE(&inode->vfs_inode))
 			return -ETXTBSY;
 
-		binode_flags |= BTRFS_INODE_COMPRESS;
-		binode_flags &= ~BTRFS_INODE_NOCOMPRESS;
+		inode_flags |= BTRFS_INODE_COMPRESS;
+		inode_flags &= ~BTRFS_INODE_NOCOMPRESS;
 
 		comp = btrfs_compress_type2str(fs_info->compress_type);
 		if (!comp || comp[0] == 0)
 			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
 	} else {
-		binode_flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
+		inode_flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
 
 	/*
@@ -375,14 +374,14 @@ int btrfs_fileattr_set(struct mnt_idmap
 		return PTR_ERR(trans);
 
 	if (comp) {
-		ret = btrfs_set_prop(trans, BTRFS_I(inode), "btrfs.compression",
+		ret = btrfs_set_prop(trans, inode, "btrfs.compression",
 				     comp, strlen(comp), 0);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out_end_trans;
 		}
 	} else {
-		ret = btrfs_set_prop(trans, BTRFS_I(inode), "btrfs.compression",
+		ret = btrfs_set_prop(trans, inode, "btrfs.compression",
 				     NULL, 0, 0);
 		if (ret && ret != -ENODATA) {
 			btrfs_abort_transaction(trans, ret);
@@ -391,11 +390,11 @@ int btrfs_fileattr_set(struct mnt_idmap
 	}
 
 update_flags:
-	binode->flags = binode_flags;
-	btrfs_sync_inode_flags_to_i_flags(inode);
-	inode_inc_iversion(inode);
-	inode_set_ctime_current(inode);
-	ret = btrfs_update_inode(trans, BTRFS_I(inode));
+	inode->flags = inode_flags;
+	btrfs_sync_inode_flags_to_i_flags(&inode->vfs_inode);
+	inode_inc_iversion(&inode->vfs_inode);
+	inode_set_ctime_current(&inode->vfs_inode);
+	ret = btrfs_update_inode(trans, inode);
 
  out_end_trans:
 	btrfs_end_transaction(trans);
@@ -550,17 +549,6 @@ static noinline int btrfs_ioctl_fitrim(s
 	return ret;
 }
 
-int __pure btrfs_is_empty_uuid(const u8 *uuid)
-{
-	int i;
-
-	for (i = 0; i < BTRFS_UUID_SIZE; i++) {
-		if (uuid[i])
-			return 0;
-	}
-	return 1;
-}
-
 /*
  * Calculate the number of transaction items to reserve for creating a subvolume
  * or snapshot, not including the inode, directory entries, or parent directory.
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -19,7 +19,6 @@ int btrfs_fileattr_set(struct mnt_idmap
 		       struct dentry *dentry, struct fileattr *fa);
 int btrfs_ioctl_get_supported_features(void __user *arg);
 void btrfs_sync_inode_flags_to_i_flags(struct inode *inode);
-int __pure btrfs_is_empty_uuid(const u8 *uuid);
 void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
 				     struct btrfs_ioctl_balance_args *bargs);
 


