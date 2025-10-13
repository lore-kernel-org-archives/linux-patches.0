Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BA72FE577;
	Mon, 13 Oct 2025 15:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367733; cv=none; b=a5ZMOvTO3C5p+bXbHOz89CIbt9+jHqXap5ab5ygEqCDjpCWnmipB+m2Dtrf5zCSWOQ2Fmwyxl0TRK+6XVM1vNgm2OMvowNXmvHfLj9Y2SlHUQMEQ7hm1XaFIxtA8Ek9xmgoe7ZmXk46VpA2FA0N2KYFjc5JPPIwF8AUpS/yPjZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367733; c=relaxed/simple;
	bh=wDw1bX5QUi/7O/acn/0pNtWdZQRc58UiObEDy2Doz8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdF1WSfe3j58kx5fmYetn62+/1xZeDEJVPodfJeoi/+ot87EHYhioXLS9AK3NcUjrU8Kijv/ofI8xrzY1iNcwg9DBTo21Wktv7KSoX7A3GEvJeRZMgVOJvh3eHqMHXZFytnnZzJVhUW6igYlbqbIqLm1NAGycms85vLwL4uU9b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbpJmH/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbpJmH/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9166C4CEE7;
	Mon, 13 Oct 2025 15:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367733;
	bh=wDw1bX5QUi/7O/acn/0pNtWdZQRc58UiObEDy2Doz8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbpJmH/IWxNuAPttkWjgjcAfoj0PtTwC6Q+NSZZmDuo100AqEcHzs4t4kgAelqkdt
	 BjMA8iCxuRoILQTZBboVYCKmM1ClxZDSH3t2/HEFzfPt9HIGLs00GRtL+00RM9k7Kk
	 pObNYkequEIB5ctletA06dJp1TqlN8YONdMXOSic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/196] f2fs: fix to update map->m_next_extent correctly in f2fs_map_blocks()
Date: Mon, 13 Oct 2025 16:45:06 +0200
Message-ID: <20251013144319.471427679@linuxfoundation.org>
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
index d37104aa847a7..0e119218ebf74 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1756,7 +1756,7 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map, int flag)
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



