Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF97527815E;
	Mon, 13 Oct 2025 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369385; cv=none; b=LMSXJcTz7ennOBGSandczrFywKdTR6/tiuC60w0tKoaL9vWRMIu+O5RZifb9oVhw5RNZJokMBkMbIYCCpk+Tjy2CjUUFb5YbOC184Cl3CL+9ljJ4d08dGFqMrI94/VA8/Q8/MdpF1YGItVIrN0KfuPP0JYJZFVjAoyjcO6i/0cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369385; c=relaxed/simple;
	bh=pO9NkoGEKubVnledsZnxsW+4BOwJbIZ2RcyyjQSbOgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLyJn1oInVoyWVHYJGdXW3c/VTRwWGPE+lDwll1H/pGjkvvCukx6FjVlPRkml1gPmsJrT7HXizozizAYIIjQYbI0t2g29/PWQgSYRDkJ0HQVUsV6w/xfl5VawmuzmSUkL1loWM7d/pKp3dhalhOQ74Au6GDDkzCqTC665As+P0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9imFLSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9imFLSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A298C4CEE7;
	Mon, 13 Oct 2025 15:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369384;
	bh=pO9NkoGEKubVnledsZnxsW+4BOwJbIZ2RcyyjQSbOgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9imFLSjUWB6GMmsEvx1yQcakFqHToSe3xsYIvAXo105jlipKUtEUtu5kkNgihvUf
	 wbrsey7eidLczQSDxaounsgo94yZJX85G3qTH6iruaE682Yb/pCFIVr3gEvZBENyeX
	 xI873hr6TY3Kki174OmtQ5VL+CyhOYLvKeC5p7E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Prusakowski <jprusakowski@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 226/563] f2fs: fix to zero data after EOF for compressed file correctly
Date: Mon, 13 Oct 2025 16:41:27 +0200
Message-ID: <20251013144419.469122808@linuxfoundation.org>
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

[ Upstream commit 0b2cd5092139f499544c77b5107a74e5fdb3a386 ]

generic/091 may fail, then it bisects to the bad commit ba8dac350faf
("f2fs: fix to zero post-eof page").

What will cause generic/091 to fail is something like below Testcase #1:
1. write 16k as compressed blocks
2. truncate to 12k
3. truncate to 20k
4. verify data in range of [12k, 16k], however data is not zero as
expected

Script of Testcase #1
mkfs.f2fs -f -O extra_attr,compression /dev/vdb
mount -t f2fs -o compress_extension=* /dev/vdb /mnt/f2fs
dd if=/dev/zero of=/mnt/f2fs/file bs=12k count=1
dd if=/dev/random of=/mnt/f2fs/file bs=4k count=1 seek=3 conv=notrunc
sync
truncate -s $((12*1024)) /mnt/f2fs/file
truncate -s $((20*1024)) /mnt/f2fs/file
dd if=/mnt/f2fs/file of=/mnt/f2fs/data bs=4k count=1 skip=3
od /mnt/f2fs/data
umount /mnt/f2fs

Analisys:
in step 2), we will redirty all data pages from #0 to #3 in compressed
cluster, and zero page #3,
in step 3), f2fs_setattr() will call f2fs_zero_post_eof_page() to drop
all page cache post eof, includeing dirtied page #3,
in step 4) when we read data from page #3, it will decompressed cluster
and extra random data to page #3, finally, we hit the non-zeroed data
post eof.

However, the commit ba8dac350faf ("f2fs: fix to zero post-eof page") just
let the issue be reproduced easily, w/o the commit, it can reproduce this
bug w/ below Testcase #2:
1. write 16k as compressed blocks
2. truncate to 8k
3. truncate to 12k
4. truncate to 20k
5. verify data in range of [12k, 16k], however data is not zero as
expected

Script of Testcase #2
mkfs.f2fs -f -O extra_attr,compression /dev/vdb
mount -t f2fs -o compress_extension=* /dev/vdb /mnt/f2fs
dd if=/dev/zero of=/mnt/f2fs/file bs=12k count=1
dd if=/dev/random of=/mnt/f2fs/file bs=4k count=1 seek=3 conv=notrunc
sync
truncate -s $((8*1024)) /mnt/f2fs/file
truncate -s $((12*1024)) /mnt/f2fs/file
truncate -s $((20*1024)) /mnt/f2fs/file
echo 3 > /proc/sys/vm/drop_caches
dd if=/mnt/f2fs/file of=/mnt/f2fs/data bs=4k count=1 skip=3
od /mnt/f2fs/data
umount /mnt/f2fs

Anlysis:
in step 2), we will redirty all data pages from #0 to #3 in compressed
cluster, and zero page #2 and #3,
in step 3), we will truncate page #3 in page cache,
in step 4), expand file size,
in step 5), hit random data post eof w/ the same reason in Testcase #1.

Root Cause:
In f2fs_truncate_partial_cluster(), after we truncate partial data block
on compressed cluster, all pages in cluster including the one post eof
will be dirtied, after another tuncation, dirty page post eof will be
dropped, however on-disk compressed cluster is still valid, it may
include non-zero data post eof, result in exposing previous non-zero data
post eof while reading.

Fix:
In f2fs_truncate_partial_cluster(), let change as below to fix:
- call filemap_write_and_wait_range() to flush dirty page
- call truncate_pagecache() to drop pages or zero partial page post eof
- call f2fs_do_truncate_blocks() to truncate non-compress cluster to
  last valid block

Fixes: 3265d3db1f16 ("f2fs: support partial truncation on compressed inode")
Reported-by: Jan Prusakowski <jprusakowski@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 6cd8902849cf6..72bc05b913af7 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1246,19 +1246,28 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 		for (i = cluster_size - 1; i >= 0; i--) {
 			struct folio *folio = page_folio(rpages[i]);
 			loff_t start = (loff_t)folio->index << PAGE_SHIFT;
+			loff_t offset = from > start ? from - start : 0;
 
-			if (from <= start) {
-				folio_zero_segment(folio, 0, folio_size(folio));
-			} else {
-				folio_zero_segment(folio, from - start,
-						folio_size(folio));
+			folio_zero_segment(folio, offset, folio_size(folio));
+
+			if (from >= start)
 				break;
-			}
 		}
 
 		f2fs_compress_write_end(inode, fsdata, start_idx, true);
+
+		err = filemap_write_and_wait_range(inode->i_mapping,
+				round_down(from, cluster_size << PAGE_SHIFT),
+				LLONG_MAX);
+		if (err)
+			return err;
+
+		truncate_pagecache(inode, from);
+
+		err = f2fs_do_truncate_blocks(inode,
+				round_up(from, PAGE_SIZE), lock);
 	}
-	return 0;
+	return err;
 }
 
 static int f2fs_write_compressed_pages(struct compress_ctx *cc,
-- 
2.51.0



