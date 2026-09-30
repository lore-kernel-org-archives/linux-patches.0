Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357E054EEA7;
	Wed, 30 Sep 2026 17:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790146; cv=none; b=Jh9lcxfse0lV2tmlKa+gD7d/6oJxWErbVy7gJ/DwIsIOE/aqpo2xb5fNcj85pNX+RuztRo54AFneFwKFXr/ylaBGr1boGCx0fxQ9Kb4HA8xqcrXr09nHqFrGG8asxmVcmpbW6kaI3KC5Dqy5L4ogK3xkJ2RzYDOJwSHoSoGuEKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790146; c=relaxed/simple;
	bh=/ZD8PjY9nbFuFt0dOzAuoEF89+wLcQHzOqBh+8Hyh14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+uc6VOYxLzOubma1qytFC2c7mAm5DDRwJbLusFUZkj0RdS2u3f3eUIEvqb7vRvm/SFI20wvfYcTtQ56RScze5sUWgrNXEhPEWZ8+luyg9gqjiKMmPm6yh27HRPl1LTUmyywchnOPvIqklLIXTyfoz9HuiSAN+zOokq6RiIcaB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLfyBLcn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLfyBLcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7621F000FF;
	Wed, 30 Sep 2026 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790144;
	bh=2dJAS4DhYbyEWvW2mLqiCsXAlppChU+YVijWMLKLYsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLfyBLcn3GGQdP3w0N8lRRW8khZIyFTxG32nE5QzugJEKuei3ABSBjxB1HVXqch1Y
	 kgcoL5iRMBO6Shy/Q9RvGRM4WGZz/mc8gZSCEmtP0BSDin/aoP2EwKxRFc978balHt
	 3ZUHIPlvUDYfEcIKz5U3pVAhJsbKU8sJw5ID7Q74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 689/877] f2fs: fix to avoid potential section-unaligned pinfile
Date: Wed, 30 Sep 2026 17:26:40 +0200
Message-ID: <20260930152429.545413832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit d0a481fad5c7a3a56ecf54a099651216869f4d0a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1097,17 +1097,23 @@ int f2fs_setattr(struct mnt_idmap *idmap
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


