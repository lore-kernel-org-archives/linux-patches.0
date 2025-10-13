Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4164D257828;
	Mon, 13 Oct 2025 15:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368406; cv=none; b=jDhdJ+C4z62/CtS2b47GliupmECNRmICrf1TRkVz0E8qtr6jPAPWlb1sae2Wke31a+aRKJT2IIddqXvzPnqVE3U1xg57E6VKWuAchffUmOkHytvhpypZylJ/Qd4O6GMAe4cEa1MiUyua9JT2hg+ycuO3eDqGF3VNQhwymviK/Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368406; c=relaxed/simple;
	bh=cGada7c+6Rwi3TE2O4COZVEZdQlIO96zUCfZlbd6XBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHoyE8wuDHN+hyxWTWdxp05ZMIazBw6ab3wmI0H5P2KDENNg4p8ZhXzSpDsSRv5NjT9xpYB6ly8VjEaLIgz4J+jJ9K1v4ewm4zpfuzWoj5JVe00dpgVexr4loa9JqQ5hpeIScIrVoGYzgXQaSYJa0Zm0R185Kt/in+c0kaAA71o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAez9C1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAez9C1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69E9C4CEE7;
	Mon, 13 Oct 2025 15:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368406;
	bh=cGada7c+6Rwi3TE2O4COZVEZdQlIO96zUCfZlbd6XBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAez9C1lqNMNfMDevqY5x6vM1T/OE8KfG1mUN/p8afizfXDjhmkv6Eu3SDd5y0I7D
	 Fqoz3bNSvXUCeTAVkP8pl3IsD4Sv7T4KmIBUViy8pHIWJ1ATQYm0gai8XsDODiHpp5
	 fivx0V2s5uonGh8WmaANW71EXsEMczfrkZJpoZ0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/262] f2fs: fix to update map->m_next_extent correctly in f2fs_map_blocks()
Date: Mon, 13 Oct 2025 16:44:53 +0200
Message-ID: <20251013144331.559093002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

[ Upstream commit 869833f54e8306326b85ca3ed08979b7ad412a4a ]

Script to reproduce:
mkfs.f2fs -O extra_attr,compression /dev/vdb -f
mount /dev/vdb /mnt/f2fs -o mode=lfs,noextent_cache
cd /mnt/f2fs
f2fs_io write 1 0 1024 rand dsync testfile
xfs_io testfile -c "fsync"
f2fs_io write 1 0 512 rand dsync testfile
xfs_io testfile -c "fsync"
cd /
umount /mnt/f2fs
mount /dev/vdb /mnt/f2fs
f2fs_io precache_extents /mnt/f2fs/testfile
umount /mnt/f2fs

Tracepoint output:
f2fs_update_read_extent_tree_range: dev = (253,16), ino = 4, pgofs = 0, len = 512, blkaddr = 1055744, c_len = 0
f2fs_update_read_extent_tree_range: dev = (253,16), ino = 4, pgofs = 513, len = 351, blkaddr = 17921, c_len = 0
f2fs_update_read_extent_tree_range: dev = (253,16), ino = 4, pgofs = 864, len = 160, blkaddr = 18272, c_len = 0

During precache_extents, there is off-by-one issue, we should update
map->m_next_extent to pgofs rather than pgofs + 1, if last blkaddr is
valid and not contiguous to previous extent.

Fixes: c4020b2da4c9 ("f2fs: support F2FS_IOC_PRECACHE_EXTENTS")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index efc30626760a6..a008d70b9f5ec 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1786,7 +1786,7 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map, int flag)
 				map->m_len - ofs);
 		}
 		if (map->m_next_extent)
-			*map->m_next_extent = pgofs + 1;
+			*map->m_next_extent = is_hole ? pgofs + 1 : pgofs;
 	}
 	f2fs_put_dnode(&dn);
 unlock_out:
-- 
2.51.0



