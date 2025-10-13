Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7540231064A;
	Mon, 13 Oct 2025 15:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369782; cv=none; b=er+qyUg9F0iiuyEcTx4/m7V2fzVn0ipb66Z1q6osguzlqr1UVJuOEkTeD5xLfTH84kmdacTdKws3acO82OdFbnmrM0gz5/GfpV1ZR6Im/Rl2cTu8rXrIAQxVxrWkA71KUb+9nVhLysd8rpGD4ssg8fTXzV5nZHJ2AHwsTuxZ72k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369782; c=relaxed/simple;
	bh=HHdfDKRJuZ6+h8i++Xxaa20leAT/7IzZH+P+BBMDQ14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0W5gHF+Zp47STHS8fuiAvQcTcBe0NfRkAk4Fg0WiX9tVZzC7wXkhUQ+OPQrmoyzvz44EqTAVnn3+mrSamIeKkAUeeb/8BUbSmJi445bxWHFUOghfs5lUDB749UlpjAQmIETm2fdd3DOYqr+7QYEH5T0U0l6hD3mfAAKQMiPqWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ORd05+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ORd05+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01506C4CEE7;
	Mon, 13 Oct 2025 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369782;
	bh=HHdfDKRJuZ6+h8i++Xxaa20leAT/7IzZH+P+BBMDQ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ORd05+2m4HyloAgP1pQzjEoitS0LkqPQSqRL6bps34PbnHISudG7kYxTVkhmysP7
	 5LwKjUMweJgFGwZsVnhY7gVv6Z6cmIvT6HZCfYzi82dAmakG66K7uMaZj2xhaSvMCL
	 sW8XB2MJ6/s9/MyvuQlZyCS1KgYp1EsA8FNC5NfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 366/563] f2fs: fix to update map->m_next_extent correctly in f2fs_map_blocks()
Date: Mon, 13 Oct 2025 16:43:47 +0200
Message-ID: <20251013144424.536160670@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 7961e0ddfca3a..838eae39d3b19 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1783,7 +1783,7 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map, int flag)
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



