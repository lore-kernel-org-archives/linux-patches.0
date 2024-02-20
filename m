Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA56152DEA;
	Tue, 20 Feb 2024 20:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462794; cv=none; b=kXK/BZEesKNVElXRbuh8tMLP8t3q6LDmPr2JwpwgkTHKJzHHg7YtGNCzR9B/7qZ0RGy73/ygADDU2ycGvA0MSi9IaZADygoyRD4+ee370Y3LV/S0jtqwGCHtYcCo9d3ndHn3zrccTxaICVV+iUaAyFuZXhBfg0jwRDUBSl71Xfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462794; c=relaxed/simple;
	bh=28ZXkvLbmEulXBxFouN5XYR5aAOan7s8OtDj/vlDRxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJohj1OI72APIuvtP0SH1NkH5OeNzKD1SI+4YJfPfeHVPNKSDVRVXKH6mwaHctM5ubK0ufz7engiKUQEPWC72u93d8qwk8n43m1ptJfj84mKzuunC+H+IJNTnody3ZJPfSmEyof6iGH+hmFBuVXNjKvz2DYolYLSyDrQfxXQ/eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3lZ6SFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3lZ6SFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B105CC433C7;
	Tue, 20 Feb 2024 20:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462794;
	bh=28ZXkvLbmEulXBxFouN5XYR5aAOan7s8OtDj/vlDRxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3lZ6SFKsSigrdzqbuMwIi4ZG3F3TZOfF3NyP4ShRUNepB0ozGFunSCnWAE7j2CiP
	 g9hPNZD9FrlIP6BM92q0KuNiR3WYy6R0lvVLx6KzHPkQlGjC7w/Z9FQCmjCWFbHDdw
	 wmr3dkHx2Q/zfZcwIjPgFVEJamBdrAtk83MWke2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 009/197] btrfs: dont reserve space for checksums when writing to nocow files
Date: Tue, 20 Feb 2024 21:49:28 +0100
Message-ID: <20240220204841.360619184@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit feefe1f49d26bad9d8997096e3a200280fa7b1c5 upstream.

Currently when doing a write to a file we always reserve metadata space
for inserting data checksums. However we don't need to do it if we have
a nodatacow file (-o nodatacow mount option or chattr +C) or if checksums
are disabled (-o nodatasum mount option), as in that case we are only
adding unnecessary pressure to metadata reservations.

For example on x86_64, with the default node size of 16K, a 4K buffered
write into a nodatacow file is reserving 655360 bytes of metadata space,
as it's accounting for checksums. After this change, which stops reserving
space for checksums if we have a nodatacow file or checksums are disabled,
we only need to reserve 393216 bytes of metadata.

CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delalloc-space.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -243,7 +243,6 @@ static void btrfs_calculate_inode_block_
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
 	u64 reserve_size = 0;
 	u64 qgroup_rsv_size = 0;
-	u64 csum_leaves;
 	unsigned outstanding_extents;
 
 	lockdep_assert_held(&inode->lock);
@@ -258,10 +257,12 @@ static void btrfs_calculate_inode_block_
 						outstanding_extents);
 		reserve_size += btrfs_calc_metadata_size(fs_info, 1);
 	}
-	csum_leaves = btrfs_csum_bytes_to_leaves(fs_info,
-						 inode->csum_bytes);
-	reserve_size += btrfs_calc_insert_metadata_size(fs_info,
-							csum_leaves);
+	if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
+		u64 csum_leaves;
+
+		csum_leaves = btrfs_csum_bytes_to_leaves(fs_info, inode->csum_bytes);
+		reserve_size += btrfs_calc_insert_metadata_size(fs_info, csum_leaves);
+	}
 	/*
 	 * For qgroup rsv, the calculation is very simple:
 	 * account one nodesize for each outstanding extent
@@ -276,14 +277,20 @@ static void btrfs_calculate_inode_block_
 	spin_unlock(&block_rsv->lock);
 }
 
-static void calc_inode_reservations(struct btrfs_fs_info *fs_info,
+static void calc_inode_reservations(struct btrfs_inode *inode,
 				    u64 num_bytes, u64 disk_num_bytes,
 				    u64 *meta_reserve, u64 *qgroup_reserve)
 {
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	u64 nr_extents = count_max_extents(fs_info, num_bytes);
-	u64 csum_leaves = btrfs_csum_bytes_to_leaves(fs_info, disk_num_bytes);
+	u64 csum_leaves;
 	u64 inode_update = btrfs_calc_metadata_size(fs_info, 1);
 
+	if (inode->flags & BTRFS_INODE_NODATASUM)
+		csum_leaves = 0;
+	else
+		csum_leaves = btrfs_csum_bytes_to_leaves(fs_info, disk_num_bytes);
+
 	*meta_reserve = btrfs_calc_insert_metadata_size(fs_info,
 						nr_extents + csum_leaves);
 
@@ -335,7 +342,7 @@ int btrfs_delalloc_reserve_metadata(stru
 	 * everything out and try again, which is bad.  This way we just
 	 * over-reserve slightly, and clean up the mess when we are done.
 	 */
-	calc_inode_reservations(fs_info, num_bytes, disk_num_bytes,
+	calc_inode_reservations(inode, num_bytes, disk_num_bytes,
 				&meta_reserve, &qgroup_reserve);
 	ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_reserve, true,
 						 noflush);
@@ -356,7 +363,8 @@ int btrfs_delalloc_reserve_metadata(stru
 	spin_lock(&inode->lock);
 	nr_extents = count_max_extents(fs_info, num_bytes);
 	btrfs_mod_outstanding_extents(inode, nr_extents);
-	inode->csum_bytes += disk_num_bytes;
+	if (!(inode->flags & BTRFS_INODE_NODATASUM))
+		inode->csum_bytes += disk_num_bytes;
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
 
@@ -390,7 +398,8 @@ void btrfs_delalloc_release_metadata(str
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
 	spin_lock(&inode->lock);
-	inode->csum_bytes -= num_bytes;
+	if (!(inode->flags & BTRFS_INODE_NODATASUM))
+		inode->csum_bytes -= num_bytes;
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
 


