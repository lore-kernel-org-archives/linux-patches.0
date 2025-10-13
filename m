Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5C230BB96;
	Mon, 13 Oct 2025 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367756; cv=none; b=pZE9HLhEYzNyX3AE01vrnLIZF6IwD4h8fxCGy7W8uEk+u0UGj7Ix0YC/QkPvLXV27vnDOapjXeHO2PBCSHzE50YwfoX1kMn4y8nneUa5imFMrHht5wP0ZATc5dI586hU6aq4yJFouz4plAEn6W1hySCu2PNSZVBluh4ThlXeju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367756; c=relaxed/simple;
	bh=T/F15lxdCsJTtEbTcUe3OrU9kQhV3wrBuFRjlKHnDH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8yI0ALuihv4y2H36LaKnV1mTgs4qLwSdsMIX2Xazow87MzrCj0C7NIqhIOvwlLA80WJsvfykJ9UVLBPZChdwXPSSw2/Z/IldkzfuVkXA3tI2ZQZ6kqcpHVZoeaZcDbxpaeCs7sJuQKHSIv2eBM2psJCc2d3MqJv/x1NLsFWN0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HS9kWZfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HS9kWZfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAA0C4CEFE;
	Mon, 13 Oct 2025 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367756;
	bh=T/F15lxdCsJTtEbTcUe3OrU9kQhV3wrBuFRjlKHnDH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HS9kWZfNpyf+flhF93sRGVWHm/281ZUQZmFsO4oD5YVGV1fE9BU9QmYT3Zie4//KV
	 dsBs5u6hGR3sZmThnQG3+AobSnNsmgpWp8quYAwXtLy16TDdcOICPta6B8oogUf4rj
	 786KNwFOXUxOqzygRlJykoyZpTJ+XxigensStKMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangzijie <wangzijie1@honor.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/196] f2fs: fix zero-sized extent for precache extents
Date: Mon, 13 Oct 2025 16:45:13 +0200
Message-ID: <20251013144319.722477791@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangzijie <wangzijie1@honor.com>

[ Upstream commit 8175c864391753b210f3dcfae1aeed686a226ebb ]

Script to reproduce:
f2fs_io write 1 0 1881 rand dsync testfile
f2fs_io fallocate 0 7708672 4096 testfile
f2fs_io write 1 1881 1 rand buffered testfile
fsync testfile
umount
mount
f2fs_io precache_extents testfile

When the data layout is something like this:
dnode1:                     dnode2:
[0]      A                  [0]    NEW_ADDR
[1]      A+1                [1]    0x0
...
[1016]   A+1016
[1017]   B (B!=A+1017)      [1017] 0x0

During precache_extents, we map the last block(valid blkaddr) in dnode1:
map->m_flags |= F2FS_MAP_MAPPED;
map->m_pblk = blkaddr(valid blkaddr);
map->m_len = 1;
then we goto next_dnode, meet the first block in dnode2(hole), goto sync_out:
map->m_flags & F2FS_MAP_MAPPED == true, and we make zero-sized extent:

map->m_len = 1
ofs = start_pgofs - map->m_lblk = 1882 - 1881 = 1
ei.fofs = start_pgofs = 1882
ei.len = map->m_len - ofs = 1 - 1 = 0

Rebased on patch[1], this patch can cover these cases to avoid zero-sized extent:
A,B,C is valid blkaddr
case1:
dnode1:                     dnode2:
[0]      A                  [0]    NEW_ADDR
[1]      A+1                [1]    0x0
...                         ....
[1016]   A+1016
[1017]   B (B!=A+1017)      [1017] 0x0

case2:
dnode1:                     dnode2:
[0]      A                  [0]    C (C!=B+1)
[1]      A+1                [1]    C+1
...                         ....
[1016]   A+1016
[1017]   B (B!=A+1017)      [1017] 0x0

case3:
dnode1:                     dnode2:
[0]      A                  [0]    C (C!=B+2)
[1]      A+1                [1]    C+1
...                         ....
[1015]   A+1015
[1016]   B (B!=A+1016)
[1017]   B+1                [1017] 0x0

[1] https://lore.kernel.org/linux-f2fs-devel/20250912081250.44383-1-chao@kernel.org/

Fixes: c4020b2da4c9 ("f2fs: support F2FS_IOC_PRECACHE_EXTENTS")
Signed-off-by: wangzijie <wangzijie1@honor.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 0e119218ebf74..fe23ebfc88ea1 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1751,9 +1751,10 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map, int flag)
 		if (map->m_flags & F2FS_MAP_MAPPED) {
 			unsigned int ofs = start_pgofs - map->m_lblk;
 
-			f2fs_update_read_extent_cache_range(&dn,
-				start_pgofs, map->m_pblk + ofs,
-				map->m_len - ofs);
+			if (map->m_len > ofs)
+				f2fs_update_read_extent_cache_range(&dn,
+					start_pgofs, map->m_pblk + ofs,
+					map->m_len - ofs);
 		}
 		if (map->m_next_extent)
 			*map->m_next_extent = is_hole ? pgofs + 1 : pgofs;
-- 
2.51.0



