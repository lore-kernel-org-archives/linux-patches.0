Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035922;
	b=LK4cjj2mbNNtqSGfHN10BpZFZy9CiaTf7Ci7clsbav3SROzmvG8PynCdR0iGVmFiWdoJ
	 FEyfj0ozSXaWHZcp64JrZmxDJI9TFusZx8/hG/GOEwRQDwGjuv/QVQQOuYrD7QXiNNpP7
	 sFWJ4NTCDhxizsVjBc8yIEDEi4R3Ljk52mOrW/rkIe1UFvM7X6D0L/TvNWoSj1UjJOngy
	 3LHfKohuHRlYzOzyelxH5lQWc3tUQcPItppAUxTYKPy6ut+PzYJ5O/a5gRimxJtTw/E76
	 L8woPNuXvASUWgD6G73K5JUGo55jhQzSXpLolGQ+qgjU052+UKWIJQeTaxskn3iB3eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHPGD1B512BOYFMQidB12cfOkSt/eUaaJ7BCGWl9bVU=;
	b=z9diM9YO9KQHsxqr2UpGR7fKUWsE9uoqgqk5YPpcKieI5d0efmBtYyy7yzRKutRkdzXL
	 Tf3hr2pZaGZS2bXX9zbjJGAeq6cYBsAJpNiMUcHR521d4mdBzeeBP6RMN7oJplb5oCRVV
	 vECoPIyYIiYC5d6UmueZTyMneAM9FCqaHcIe2R68DDvM/Q11OEtYyC0UOiDosqNnxxh+Q
	 4cJK1+YGLVVqhDjIKm1XoqQZ03Q4l642F0HnAASuoK92gXHFilwj7Y0J5SZuojN/msEok
	 M6WZsYwPNM+4/WmKl6XUdt1/V3jvKU6K2WjhHgfYeq39RomNueTjDfYcWizaJDC+o8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpVh36fE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC396606A90A;
	Wed, 18 Nov 2026 21:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpVh36fE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC361F000C4;
	Wed, 18 Nov 2026 21:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035922;
	bh=ZHPGD1B512BOYFMQidB12cfOkSt/eUaaJ7BCGWl9bVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpVh36fEgIxHA6SoxcevZlh57e/gNCOOjSCsg5pdM4TWuhSswW+f8jzYWC8R82oxU
	 Z3V9OJR2Yucx5QYI6fZe77WuG3XpYHkhX5ZwlxNrQnQbXboftrC3PcyIzokk40F996
	 OhOmKZDJNB6Ph2wigVJ4jDHgBu9B8UJ2xb0S60ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0873/3318] f2fs: compress: fix to handle race between truncate and writeback
Date: Wed, 18 Nov 2026 15:24:55 +0100
Message-ID: <20261118150345.490782433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit c0337e331b065074ce20e4258a578e07dd7e4083 ]

fsstress reports a kernel BUG in f2fs_truncate_partial_cluster():

kernel BUG at fs/f2fs/compress.c:1238!
RIP: 0010:f2fs_truncate_partial_cluster+0x292/0x2a0
Call Trace:
 <TASK>
 f2fs_truncate+0xf6/0x210
 f2fs_setattr+0x6b7/0x770
 notify_change+0x33b/0x520
 do_truncate+0xc2/0xf0
 vfs_truncate+0x153/0x1d0
 ksys_truncate+0x78/0xd0
 __x64_sys_truncate+0x16/0x20
 do_syscall_64+0xbe/0x540

The root cause is that Thread A (truncate) and Thread B (background
writeback or fsync) can race as follows:

Thread A                             Thread B
- f2fs_setattr
 - f2fs_truncate
  - f2fs_truncate_blocks
   - f2fs_truncate_partial_cluster
    - f2fs_is_compressed_cluster
      return 1
                                     - f2fs_write_cache_pages
                                      - f2fs_write_multi_pages
                                       - f2fs_write_raw_pages
                                        - f2fs_write_single_data_page
                                          dn.data_blkaddr != COMPRESS_ADDR
                                          (cluster converted to normal)
    - f2fs_prepare_compress_overwrite
     - f2fs_is_compressed_cluster
       return 0
     - return 0
    - f2fs_bug_on(sbi, err == 0): BUG!

Writeback path does not acquire i_gc_rwsem or filemap_invalidate_lock.
When a compressed cluster fails compression during writeback, it is
overwritten with raw data blocks. If Thread A checked
f2fs_is_compressed_cluster() before the conversion, but calls
f2fs_prepare_compress_overwrite() after the conversion,
f2fs_prepare_compress_overwrite() returns 0 because the cluster is no
longer a compressed cluster.

To fix this, remove the f2fs_bug_on() and retry checking the cluster status
when f2fs_prepare_compress_overwrite() returns 0, so that it can fall back
to f2fs_do_truncate_blocks() to handle it as a normal cluster.

Cc: stable@kernel.org
Fixes: 3265d3db1f16 ("f2fs: support partial truncation on compressed inode")
Reviewed-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 7a7e6f8e6970e..edca00f601c00 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1182,6 +1182,7 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 							log_cluster_size;
 	int err;
 
+repeat:
 	err = f2fs_is_compressed_cluster(inode, start_idx);
 	if (err < 0)
 		return err;
@@ -1193,12 +1194,11 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 	/* truncate compressed cluster */
 	err = f2fs_prepare_compress_overwrite(inode, &pagep,
 						start_idx, &fsdata);
-
-	/* should not be a normal cluster */
-	f2fs_bug_on(F2FS_I_SB(inode), err == 0);
-
-	if (err <= 0)
+	if (err < 0)
 		return err;
+	else if (err == 0)
+		/* the cluster became non-compressed one due to race case */
+		goto repeat;
 
 	if (err > 0) {
 		struct page **rpages = fsdata;
-- 
2.53.0



