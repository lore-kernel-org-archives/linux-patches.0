Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062842;
	b=p/EZkTpq7O7Xxsx0PTztlyyXbhxbGUOhxwHWS+Z7TQv648HkIH2n2LeQg5HeRtPIFSqv
	 a05MN+eO495BFgnXWlZB/2Wu/XjrGTdnf4WTYwZXXUBY+49ZF1DBI83hf0tPIvUpRfjDi
	 ZiWSREYw5kJduLNWWqM5h4yT+sHsw4WNEn4ctnmCssiP0tOZOiUz20yYkF/UkbsI/TkFG
	 1TqLuDrP/WaSYVm7FnFXxKr81+iCd3WLVIOLSuDhOWRWcGa3M/yMo2jRG1E+jjgiDOT4r
	 smgxdhYCt2fEgIMyu2RDs9pX+WfHx0tSdymy6qCn9tzgj8902gM4lOGbCHstmONrTBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9q7T9KcQJKQiICxGbS8UnX/EYsWrSmNZqbZf/RZkiPI=;
	b=R0WGfLnq7lWHFKihwLUOq5HLz0hOwM7BzYeNpAKm6JAP1NFVsmn7Pa0wVvHf2dKuzOlm
	 pFhUxJNIBoPiI5wVFQ4/2MTd4gK9il02ltE3GEaIbiKA3VKbD+C0zAqc5EQ+QlBCEhIhr
	 VthK0Cp2no+ljFZB1EV/YpNcVe80cPHrzvgqdvJVkHaLpV1oSoo62eWgUWENd3njWATTq
	 8DSW3ZFOLfQ4IqRFetZnWcBmWBKaxDNwarf1pNavEheiMn1HSp1KlO9A16WceikwIEIWn
	 9rehGl229yIupbnv5dOr21Blg3lUy7pitryg/ee79sy/5zm9H3WYbFnshQQ3R9L7Iug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHqmtr7S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7916606A334;
	Sat,  7 Nov 2026 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHqmtr7S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746A31F0089F;
	Sat,  7 Nov 2026 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062841;
	bh=9q7T9KcQJKQiICxGbS8UnX/EYsWrSmNZqbZf/RZkiPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHqmtr7SuL2mnEn93Kw0LRFSVnbw8wGFsT3KpOMrZC6/R4OoXq+QyD40sCs7aERbr
	 i75iwdf8veLF0PfEuiLafhEYDIaLVtRA0Wnob8lTjOdWVO2RHlkgehiUyBX8kGJgUT
	 0JYiJ3TQAF69E9H33UndPLlg2wPvgjhIHR3i3C+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/869] f2fs: compress: fix to handle race between truncate and writeback
Date: Sat,  7 Nov 2026 08:46:58 -0500
Message-ID: <20261107134857.035258360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0399db98fccfc..8fea48dc50bad 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1219,6 +1219,7 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 	int i;
 	int err;
 
+repeat:
 	err = f2fs_is_compressed_cluster(inode, start_idx);
 	if (err < 0)
 		return err;
@@ -1230,12 +1231,11 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
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
 
 	rpages = fsdata;
 
-- 
2.53.0



