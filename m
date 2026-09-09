Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3B6581251;
	Wed,  9 Sep 2026 14:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964300; cv=none; b=tdiPHhOL0hG5JtbJ3ZHLdQNhaeVu+dHk+px+2b0/7qjuoNJGoJ6xSFXhbdn7hVvTqalqXIKy6gHEGnrhFYztNMGSui7Kh0Ge0+OrRZGPLJQ+U2W6EtcznBsah/x47hzGps5Tle9DfNU7r+g9NngxGbuSsNvz5NzrPyAtkvR6HZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964300; c=relaxed/simple;
	bh=JSM906yrOKthxOxIB10ODcGOSaxZXa6ieBeyKA77c70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5nlxea29uxBNYSXwRKSSt2RgmZmfN5epqEa9Cj4Rm1fbsn8u5O/eO5c51wRn23YhGuwYH4Ebm8rtpvlW6uzFKlBxk92g/3w6fsS2KnwtwfyYtjoRlug26JbcYq3FMlxrxsZ4Qm5ZryoZbZmf+hz0B7Q3halXXx5YgWgkSg96iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R75fmIVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R75fmIVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79291F00A3A;
	Wed,  9 Sep 2026 14:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964298;
	bh=04GD7kydHJzwJewzpci3jaYJS2UY3voVBsPQUyOqdlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R75fmIVpAX4MrkcpgY+YETxv16l/NXbXoEVP2o8MBEPMdJkGgwpw4qckBD5qsmL3E
	 XI24E+G1dmFb+sqw1QTndplQmOm7FRu/KmBMn6M8OOn/sgOiONO8KVtEzGDkMVsYZf
	 3Tf++LDPUth9Jov8wqiLYvndx382fQ90qZas29ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 358/583] f2fs: fix to avoid potential section-unaligned pinfile
Date: Wed,  9 Sep 2026 15:40:43 +0200
Message-ID: <20260909134250.409119955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit d0a481fad5c7a3a56ecf54a099651216869f4d0a upstream.

Blocks of pinfile may not aligned to section size due to wrong use
on pinfile, result in heavy overhead of GC, let avoid this by
adding additional check condition in f2fs_setattr().

- truncate -s 8mb pinfile
: random checkpoint may persist filesize w/ inode
- fallocate -o 0 -l 8mb pinfile
 - f2fs_fallocate
  - f2fs_expand_inode_data
   - f2fs_allocate_pinning_section
   - f2fs_map_blocks
    - f2fs_map_lock
    - __allocate_data_block
    - file_need_truncate
    : w/ FADVISE_TRUNC_BIT, we can expect unaligned mapping can be
      truncated while open() if f2fs is not umount abnormally
    - f2fs_map_unlock
    : following f2fs checkpoint and sudden power-cut

- mount
- open pinfile
 - f2fs_file_open
  - finish_preallocate_blocks
   - truncate_setsize
   : filesize is 8mb
   - f2fs_truncate
   : can only truncate block outside filesize, rather than truncating
     unaligned blocks inside filesize

Fixes: f5a53edcf01e ("f2fs: support aligned pinned file")
Cc: stable@kernel.org
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1094,17 +1094,23 @@ int f2fs_setattr(struct mnt_idmap *idmap
 			!IS_ALIGNED(attr->ia_size,
 			F2FS_BLK_TO_BYTES(fi->i_cluster_size)))
 			return -EINVAL;
-		/*
-		 * To prevent scattered pin block generation, we don't allow
-		 * smaller/equal size unaligned truncation for pinned file.
-		 * We only support overwrite IO to pinned file, so don't
-		 * care about larger size truncation.
-		 */
-		if (f2fs_is_pinned_file(inode) &&
-			attr->ia_size <= i_size_read(inode) &&
-			!IS_ALIGNED(attr->ia_size,
-			F2FS_BLK_TO_BYTES(CAP_BLKS_PER_SEC(sbi))))
-			return -EINVAL;
+
+		if (f2fs_is_pinned_file(inode)) {
+			/*
+			 * It may break section-aligned fallocate recovery
+			 * mechanism, so do not allow larger size truncation.
+			 */
+			if (attr->ia_size > i_size_read(inode))
+				return -EINVAL;
+			/*
+			 * To prevent scattered pin block generation, we don't
+			 * allow smaller/equal size unaligned truncation for
+			 * pinned file.
+			 */
+			else if (!IS_ALIGNED(attr->ia_size,
+				F2FS_BLK_TO_BYTES(CAP_BLKS_PER_SEC(sbi))))
+				return -EINVAL;
+		}
 	}
 
 	if (is_quota_modification(idmap, inode, attr)) {


