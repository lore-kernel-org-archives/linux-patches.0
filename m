Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DEA3DD843;
	Tue, 12 May 2026 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608124; cv=none; b=u3x7XLjKOj3dwci6b2o/dWj6O6M1JfRTcF2HQqbjF5InmepcotaQOHLxVINVfHLXVRVOlpHj5bCgI/4WlNs8U98vRDaeJG6lt/VmGyPAfHnutosiVx9ZB49ipj5R4JeLGKIVfLQ9ZF6A6WDU6acB9PtxJBSwbbZJq7Rzq8StEEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608124; c=relaxed/simple;
	bh=Iyxl+h/mcxPf8wfF02BPSsPrDKnREFnN+sCB7Xic0gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zso8hUT1mzuKalVBvbR4wbfwL1WfUJFLzl3HnAbj7L0eNkbazA2kI3hJR/95h+ccGMsRD5637IfZWeU8rgdqzZEH66HtPa8ZyaMxKahMlH1KsE/8CqIXldFVa6nduZkA7RRRVpEldaAcf2NLnCWNpz0qcISt/YiKBAHqY+4F7Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teVK9hc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teVK9hc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CF8C2BCB0;
	Tue, 12 May 2026 17:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608124;
	bh=Iyxl+h/mcxPf8wfF02BPSsPrDKnREFnN+sCB7Xic0gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=teVK9hc3Y0uVynzFuafTAerhbhEtLjh89fqGTH9H/+H4PQr4x5Z/JV7yPDlNLC4ly
	 KBZ1sJvpKGUIl3dgZuacONUUr04mDbmvkeHdv3e/c68Nl+q7wl22f2B9OpC0lv7lFA
	 ogy+KZwqx94Md76eQ2Om5DVvzX9YyogeIkM+lFkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 165/206] f2fs: fix fiemap boundary handling when read extent cache is incomplete
Date: Tue, 12 May 2026 19:40:17 +0200
Message-ID: <20260512173936.357458732@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1564,8 +1564,26 @@ int f2fs_map_blocks(struct inode *inode,
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
@@ -1576,7 +1594,8 @@ int f2fs_map_blocks(struct inode *inode,
 
 	/* it only supports block size == page size */
 	pgofs =	(pgoff_t)map->m_lblk;
-	end = pgofs + maxblocks;
+map_more:
+	end = (pgoff_t)map->m_lblk + maxblocks;
 
 next_dnode:
 	if (map->m_may_create) {


