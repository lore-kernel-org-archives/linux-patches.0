Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3043B8BDB;
	Mon, 23 Mar 2026 16:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283364; cv=none; b=lwu1nWFjtkBzebsM9t/Ond+FdPw6PNLfZN1aJYgz0I29jN6Zoemoiu7ALr1ZqwUHw/FR909QlNDKio2NyRt1cvezygCQVJF1D1VzWvoMEKmcqo+S5CXmW2m4PRy0prIHqXpuLDDO68oh9bNpSFeizWgpGwZJoGSYY8lLAe0Lx0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283364; c=relaxed/simple;
	bh=QV1VzUubAT43jrPpkG6mle9g0+b3wQdRQqWPiiQNZCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bv82yCOMa5tyxvvMvpLgEHBS/W0sn0+PEVwCZ64T1ISVUO3iGOe8ldeZyK+y53r4+TA4onsEN24jmDxrdYTq3Vnbc6Ux1Sxhwt+VsMs/pIlzsnCwQwjrBIF9aqhClFsCjycVrDldjmXuN1yObjq1AaJM8YOzMZNR5p+O0yV/3F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2UPPJVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2UPPJVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E851CC2BC9E;
	Mon, 23 Mar 2026 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283364;
	bh=QV1VzUubAT43jrPpkG6mle9g0+b3wQdRQqWPiiQNZCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2UPPJVQLDO7cGqwsLMuc3Bd+ux1iFFLbULksvHylu92/ddvqitcFFs/JAwQUjbs2
	 nbmdlS4f4MlkcruV9nLKaId+bAWoT5R9K1CF2utOM75RhQFffSph3Y27+XQd7fWcxL
	 Cj6TT8wR9BM7WCK77wFA4wU/rDNz1nvCY4SIYoSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.1 469/481] f2fs: fix to trigger foreground gc during f2fs_map_blocks() in lfs mode
Date: Mon, 23 Mar 2026 14:47:31 +0100
Message-ID: <20260323134536.648404669@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 1005a3ca28e90c7a64fa43023f866b960a60f791 ]

w/ "mode=lfs" mount option, generic/299 will cause system panic as below:

------------[ cut here ]------------
kernel BUG at fs/f2fs/segment.c:2835!
Call Trace:
 <TASK>
 f2fs_allocate_data_block+0x6f4/0xc50
 f2fs_map_blocks+0x970/0x1550
 f2fs_iomap_begin+0xb2/0x1e0
 iomap_iter+0x1d6/0x430
 __iomap_dio_rw+0x208/0x9a0
 f2fs_file_write_iter+0x6b3/0xfa0
 aio_write+0x15d/0x2e0
 io_submit_one+0x55e/0xab0
 __x64_sys_io_submit+0xa5/0x230
 do_syscall_64+0x84/0x2f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0010:new_curseg+0x70f/0x720

The root cause of we run out-of-space is: in f2fs_map_blocks(), f2fs may
trigger foreground gc only if it allocates any physical block, it will be
a little bit later when there is multiple threads writing data w/
aio/dio/bufio method in parallel, since we always use OPU in lfs mode, so
f2fs_map_blocks() does block allocations aggressively.

In order to fix this issue, let's give a chance to trigger foreground
gc in prior to block allocation in f2fs_map_blocks().

Fixes: 36abef4e796d ("f2fs: introduce mode=lfs mount option")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ The context change is due to the commit 2f51ade9524c
("f2fs: f2fs_do_map_lock") in v6.3 which is irrelevant to 
the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1537,8 +1537,11 @@ int f2fs_map_blocks(struct inode *inode,
 	end = pgofs + maxblocks;
 
 next_dnode:
-	if (map->m_may_create)
+	if (map->m_may_create) {
+		if (f2fs_lfs_mode(sbi))
+			f2fs_balance_fs(sbi, true);
 		f2fs_do_map_lock(sbi, flag, true);
+	}
 
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);


