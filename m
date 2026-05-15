Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8D530568A;
	Fri, 15 May 2026 16:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861470; cv=none; b=epqbaqXAjDl77m9c9/iqADXc3TkTM/vf50+ukKosO0Mhn4PJCEOd4inmw1zed8ie+yA9tppWICDkFkxqnluisxApSHQ3TdgvmiFfDKnnIreIoVtXZ7Pd42c7CK4LcWoz+MHFwo91Ibdvb38NL9Q/AcOQkAIDr2YuVuPhDvBnK38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861470; c=relaxed/simple;
	bh=45bGw0tzXu190AbsTWr0tzZ5nFh9+O3m5Gq4h2gKxVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CKxAp1y0RzBLvn0wJIys0AeOor0UFtTDTvpNi9T/tq/roBM2MK0A/KNo7zx5uTKay3Sq9gm23wdBOOQgZhUGjvtMwKYGySJcmcgXR6SJxR4mrl0Z1EiWDj7MbKikrM/AwKhffLRV0VgzOvs7C9k2h3XG0oF88gh1Bwd9HtifbkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqe8FN62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqe8FN62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F53DC2BCB0;
	Fri, 15 May 2026 16:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861470;
	bh=45bGw0tzXu190AbsTWr0tzZ5nFh9+O3m5Gq4h2gKxVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqe8FN629csB1j3WiY6Q82JfBbhjhp9+PKQrxZd1qceKiF2obmaPCiu4G3LDSuoUR
	 Zk8Zig3gSpsmh1+UEUv1jN92gWwf8D+jl7aqJCoA1YvL0hSiNITMOwFjJUxLiz45o5
	 VlsaPvC0sUT2bZl7lcIS2uQIEebtOfmrDR8S93T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 289/474] f2fs: fix fiemap boundary handling when read extent cache is incomplete
Date: Fri, 15 May 2026 17:46:38 +0200
Message-ID: <20260515154721.253438745@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit 95e159ad3e52f7478cfd22e44ec37c9f334f8993 upstream.

f2fs_fiemap() calls f2fs_map_blocks() to obtain the block mapping a
file, and then merges contiguous mappings into extents. If the mapping
is found in the read extent cache, node blocks do not need to be read.
However, in the following scenario, a contiguous extent can be split
into two extents:

$ dd if=/dev/zero of=data.128M bs=1M count=128
$ losetup -f data.128M
$ mkfs.f2fs /dev/loop0 -f
$ mount -o mode=lfs /dev/loop0 /mnt/f2fs/
$ cd /mnt/f2fs/
$ dd if=/dev/zero of=data.72M bs=1M count=72 && sync
$ dd if=/dev/zero of=data.4M bs=1M count=4 && sync
$ dd if=/dev/zero of=data.4M bs=1M count=2 seek=2 conv=notrunc && sync
$ echo 3 > /proc/sys/vm/drop_caches
$ dd if=/dev/zero of=data.4M bs=1M count=2 seek=0 conv=notrunc && sync
$ dd if=/dev/zero of=data.4M bs=1M count=2 seek=0 conv=notrunc && sync
$ f2fs_io fiemap 0 1024 data.4M
Fiemap: offset = 0 len = 1024
logical addr.    physical addr.   length           flags
0	0000000000000000 0000000006400000 0000000000200000 00001000
1	0000000000200000 0000000006600000 0000000000200000 00001001

Although the physical addresses of the ranges 0～2MB and 2M～4MB are
contiguous, the mapping for the 2M～4MB range is not present in memory.
When the physical addresses for the 0～2MB range are updated, no merge
happens because the adjacent mapping is missing from the in-memory
cache. As a result, fiemap reports two separate extents instead of a
single contiguous one.

The root cause is that the read extent cache does not guarantee that all
blocks of an extent are present in memory. Therefore, when the extent
length returned by f2fs_map_blocks_cached() is smaller than maxblocks,
the remaining mappings are retrieved via f2fs_get_dnode_of_data() to
ensure correct fiemap extent boundary handling.

Cc: stable@kernel.org
Fixes: cd8fc5226bef ("f2fs: remove the create argument to f2fs_map_blocks")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1543,8 +1543,26 @@ int f2fs_map_blocks(struct inode *inode,
 	if (!maxblocks)
 		return 0;
 
-	if (!map->m_may_create && f2fs_map_blocks_cached(inode, map, flag))
-		goto out;
+	if (!map->m_may_create && f2fs_map_blocks_cached(inode, map, flag)) {
+		struct extent_info ei;
+
+		/*
+		 * 1. If map->m_multidev_dio is true, map->m_pblk cannot be
+		 * waitted by f2fs_wait_on_block_writeback_range() and are not
+		 * mergeable.
+		 * 2. If pgofs hits the read extent cache, it means the mapping
+		 * is already cached in the extent cache, but it is not
+		 * mergeable, and there is no need to query the mapping again
+		 * via f2fs_get_dnode_of_data().
+		 */
+		pgofs =	(pgoff_t)map->m_lblk + map->m_len;
+		if (map->m_len == maxblocks ||
+			map->m_multidev_dio ||
+			f2fs_lookup_read_extent_cache(inode, pgofs, &ei))
+			goto out;
+		ofs = map->m_len;
+		goto map_more;
+	}
 
 	map->m_bdev = inode->i_sb->s_bdev;
 	map->m_multidev_dio =
@@ -1555,7 +1573,8 @@ int f2fs_map_blocks(struct inode *inode,
 
 	/* it only supports block size == page size */
 	pgofs =	(pgoff_t)map->m_lblk;
-	end = pgofs + maxblocks;
+map_more:
+	end = (pgoff_t)map->m_lblk + maxblocks;
 
 next_dnode:
 	if (map->m_may_create) {


