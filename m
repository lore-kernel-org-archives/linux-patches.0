Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A182D9792;
	Sat, 12 Sep 2026 15:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228585; cv=none; b=Jwm5BkKlSzoptnXISpqafXm01Hpl9CN9KepU6W3vy+6OXE/krAh2I+yolzpdn9hrzvsDM9E36HwOtuTefL8YV5+lBrzDygJeHaYYromEj2XJSLVCmMH+pa5vPzT771vHRQFZiRn8XBaDkj29Xyg/o385EoCAtmd9ETM9OveAgfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228585; c=relaxed/simple;
	bh=TrnEmCYF+337lsNyqJtf8lXYGItBcpozsEpDCT3fVdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSc7zZnANxsK6oI6IHm08zGAN8QSeQs1o9Idc6QjbPgELthy2AFLk+1McmOskQc/KdGSwpQjCDxC3TdxNxUuUqmGIiYRtZ2jddHEzIkHQZPCAYdFFJDN99ykJ7vhwALGcS5rfS3CmWzBoIet1YUA6TC4Nq2gfxRm4gS5zBHYs8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBmGCymg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBmGCymg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D110A1F000FF;
	Sat, 12 Sep 2026 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228584;
	bh=95D0ieq0N0EllvMB4ApI1xXss8vaVK6cVEVlEkgxiRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBmGCymgFHbSLemwqK6Ew6eq4Z9k9cQvIIL9nROU/qoduqFhNRJqYF72njSW9kqGz
	 zPXWqF26ilEoVNjT30Sb1nzqpEnUgFJWjklVZEIN07kF1MTYNBa2VdkfmzUoNxuGy3
	 veGGKeS4wYa3ULSyqBN090O1hMe16aVUlOQum5UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 0413/1191] f2fs: fix i_size when pinned fallocate partially fails
Date: Sat, 12 Sep 2026 08:52:21 +0200
Message-ID: <20260912065557.514169067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1792,8 +1792,9 @@ static int expand_inode_data(struct inod
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


