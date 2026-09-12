Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996E748F024;
	Sat, 12 Sep 2026 18:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238143; cv=none; b=utlncYb9SbzcIxorifMyGYUhIFtCKNjc741hPWoXAbtgwSZadeWQEdHqf2iLSNapZFp4Tyvl2fQ8PncM1drNgteVwfmJLNU7ho2VWYxzJY+WNHzsOEZgdo7FFDS9AAEktrtWf39uwTnDfYbLq1q8KX94voUMUUB9GDue0ZrkKVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238143; c=relaxed/simple;
	bh=P40P25SpcsjaOsvDEuhK8XCHcazadkEFB3pph5cn3R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiMHgYYSMRcWYmbo+jy/eBbaKeGwGvzsjfyTklvi7Gs9T7zn6YWj4Y+kJ1e1ZgS5006R1c/Nnga+5j7Rt50nDI59NIheHb0Sa+13yo+8Hu6JJe02p+r0Bsvl71k5tbXNRkkJIfAyUigBbexFjZ5XAdoym2Vazs4fDMVj0KsVmhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQYK5D8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQYK5D8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC091F000FF;
	Sat, 12 Sep 2026 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238139;
	bh=6LxH2sHm+nOgMMEVOJfIAR/dJlN9VZRFGoh9xlq8SC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQYK5D8JFPBooZ6otHVff5MWIpGinZRPY/9pixyhcpduhDOe2Ob2QSuh0QBiRI/Mi
	 hh7zErchQHC+gkJLZyLtqQOtrkw3bQhptFJn+GUQdcA1CVtgokrA0nDQGbD4rw+K83
	 AygS+YWiTLwMMu0/J3T9aw+JOqJw+8cqv9NyBj3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 358/935] f2fs: fix i_size when pinned fallocate partially fails
Date: Sat, 12 Sep 2026 08:56:28 +0200
Message-ID: <20260912065535.018944821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit 0f448bb3767ef6119f5cdeabcae3f10d6e75aed6 upstream.

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

Commit 4275b59673eb ("f2fs: fix to round down start offset of fallocate
for pin file") moved the allocation loop's start down to a section
boundary, but the error path still converts @expanded against @pg_start,
which holds the unrounded start.

@pg_start exists for that conversion: commit 88f2cfc5fa90 ("f2fs: fix to
update last i_size if fallocate partially succeeds") added it as an
immutable base because map.m_lblk moves every round.  Each round now maps
exactly sec_blks blocks starting from rounddown(pg_start, sec_blks), so
pg_start + expanded overshoots the last allocated block by
pg_start % sec_blks, and a partial failure leaves i_size covering a tail
that was never allocated.  Nothing corrects that afterwards either, since
file_dont_truncate() has already cleared FADVISE_TRUNC_BIT.

It needs a start offset that is not section aligned plus a fallocate that
hits ENOSPC partway, so the error path runs with expanded > 0.  On an
80 MiB image with 2 MiB sections:

  truncate -s 80M img
  mkfs.f2fs -s 1 -f img
  mount -o loop img /mnt
  touch /mnt/pinned
  f2fs_io pinfile set /mnt/pinned
  # 2093056 = block 511, so pg_start % sec_blks = 511
  f2fs_io fallocate 0 2093056 536870912 /mnt/pinned
  stat -c %s /mnt/pinned
  filefrag -v /mnt/pinned

The last extent ends at block 10737 either way.  Before, i_size is
46075904, block 11249, so 511 blocks of it were never allocated, and
filefrag does not mark the last extent eof.  After, i_size is 43982848,
block 10738, and eof is back.  A kernel from before that commit also
shows no overshoot.

Keep @pg_start pointing at where allocation actually begins.

Fixes: 4275b59673eb ("f2fs: fix to round down start offset of fallocate for pin file")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1701,8 +1701,9 @@ static int expand_inode_data(struct inod
 		block_t sec_len;
 
 		if (map.m_lblk % sec_blks) {
-			map.m_lblk = rounddown(map.m_lblk, sec_blks);
-			map.m_len = pg_end - map.m_lblk;
+			pg_start = rounddown(map.m_lblk, sec_blks);
+			map.m_lblk = pg_start;
+			map.m_len = pg_end - pg_start;
 			if (off_end)
 				map.m_len++;
 		}


