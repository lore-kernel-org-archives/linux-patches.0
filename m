Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96D03BB24;
	Tue,  3 Dec 2024 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236724; cv=none; b=YRCbXrackFBQnV5T4nZavddi8wDG5dyQZ8zgF269czjwdEjJ210uf2zH8k2J7Zp8QCTml9PpDD0jKf+jOpet4nhGeLMIcWBMTStHD3V+FRUoau4yreqydMyLIZdqiLezOr1mPPZwbBT8l78lnayk4DLJtc+nJMmHSlrubN+V2wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236724; c=relaxed/simple;
	bh=3AQvMDMTyRLrgQ2nWOn+ud4ZcczDFSQzkmc+ImIm0F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pi1tdswXGA8lW3pfF/s/NbOFD+7hE2I48mb7u/ClDvf3/J5Iv5Z+w9iPHeHrdjPkQvfpHnUH4xavyCN6XqHxZLrPJcryq3I/Nxgj5nv87xlJkIutRN1LyQq4Z2cKGArNXrWi4vp6dZRyAvM71P3M1Z/z+1uMwuj9+Ac4tIv8Vmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jvl32WfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jvl32WfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D006C4CECF;
	Tue,  3 Dec 2024 14:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236723;
	bh=3AQvMDMTyRLrgQ2nWOn+ud4ZcczDFSQzkmc+ImIm0F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jvl32WfLc4EhUJ4sXibEEZxuH9qDYvU5R4D7O3ke/HJOfxjcKv+ZVeN6zodW6kCjf
	 gph3+v3uZXVxhoGwmVj5RtYHsGQ1n/r2yXKDfid3KsJYf7mRd2kHsDbVgkFPxAqU0p
	 gW8c1hSXmwRH7EExHeVEljQHa8B95i3I0wKvuaqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+a73e253cca4f0230a5a5@syzkaller.appspotmail.com,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Joseph Qi <jiangqi903@gmail.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 068/138] ocfs2: fix uninitialized value in ocfs2_file_read_iter()
Date: Tue,  3 Dec 2024 15:31:37 +0100
Message-ID: <20241203141926.161492175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit adc77b19f62d7e80f98400b2fca9d700d2afdd6f ]

Syzbot has reported the following KMSAN splat:

BUG: KMSAN: uninit-value in ocfs2_file_read_iter+0x9a4/0xf80
 ocfs2_file_read_iter+0x9a4/0xf80
 __io_read+0x8d4/0x20f0
 io_read+0x3e/0xf0
 io_issue_sqe+0x42b/0x22c0
 io_wq_submit_work+0xaf9/0xdc0
 io_worker_handle_work+0xd13/0x2110
 io_wq_worker+0x447/0x1410
 ret_from_fork+0x6f/0x90
 ret_from_fork_asm+0x1a/0x30

Uninit was created at:
 __alloc_pages_noprof+0x9a7/0xe00
 alloc_pages_mpol_noprof+0x299/0x990
 alloc_pages_noprof+0x1bf/0x1e0
 allocate_slab+0x33a/0x1250
 ___slab_alloc+0x12ef/0x35e0
 kmem_cache_alloc_bulk_noprof+0x486/0x1330
 __io_alloc_req_refill+0x84/0x560
 io_submit_sqes+0x172f/0x2f30
 __se_sys_io_uring_enter+0x406/0x41c0
 __x64_sys_io_uring_enter+0x11f/0x1a0
 x64_sys_call+0x2b54/0x3ba0
 do_syscall_64+0xcd/0x1e0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Since an instance of 'struct kiocb' may be passed from the block layer
with 'private' field uninitialized, introduce 'ocfs2_iocb_init_rw_locked()'
and use it from where 'ocfs2_dio_end_io()' might take care, i.e. in
'ocfs2_file_read_iter()' and 'ocfs2_file_write_iter()'.

Link: https://lkml.kernel.org/r/20241029091736.1501946-1-dmantipov@yandex.ru
Fixes: 7cdfc3a1c397 ("ocfs2: Remember rw lock level during direct io")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+a73e253cca4f0230a5a5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a73e253cca4f0230a5a5
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/aops.h | 2 ++
 fs/ocfs2/file.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 3494a62ed749c..c1c2189029903 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -86,6 +86,8 @@ enum ocfs2_iocb_lock_bits {
 	OCFS2_IOCB_NUM_LOCKS
 };
 
+#define ocfs2_iocb_init_rw_locked(iocb) \
+	(iocb->private = NULL)
 #define ocfs2_iocb_clear_rw_locked(iocb) \
 	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
 #define ocfs2_iocb_rw_locked_level(iocb) \
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 9062002fd56c6..08cd712b433c8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2412,6 +2412,8 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	} else
 		inode_lock(inode);
 
+	ocfs2_iocb_init_rw_locked(iocb);
+
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
@@ -2558,6 +2560,8 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	if (!direct_io && nowait)
 		return -EOPNOTSUPP;
 
+	ocfs2_iocb_init_rw_locked(iocb);
+
 	/*
 	 * buffered reads protect themselves in ->readpage().  O_DIRECT reads
 	 * need locks to protect pending reads from racing with truncate.
-- 
2.43.0



