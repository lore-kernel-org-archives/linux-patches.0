Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E1153A7;
	Fri,  6 Dec 2024 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497641; cv=none; b=mTvc/B2+4SJyyiZu2e9Vz8Ui3aebVEn1M2fyAhM4AeKRuUtqMcAdseWwcV+h3uyKwZCPG8eObpo0tTrUCnR095We99rxKBJ3UoRqTXQtzqEmoAmsGQZ0Y7ru1TnQ38EwudD5s6qb89+TKVnZ3AlFJO37hl/ABVT4OH5MWD8eJa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497641; c=relaxed/simple;
	bh=1j/YX4hGCFRHbM511GZ3jEjm+k2K7vwUz2DLDi4CTEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awZkjIbQ25K8M7hzUFoUY8BmZwJPMruyLxASaePnWQxUOQP0k9AlVMT8jBEW6z5FQ5wC1CZ2MyuBKogby4rKQNwxW7fdiZ3XRVPGbwdzAAYMm37y/9gxz+fu3QqEPDFsrG7rfhn4mmfNfZw+z1iNUTIBMRXs+Ja2i7bSYZs3v98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KegeMDBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KegeMDBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7816C4CED1;
	Fri,  6 Dec 2024 15:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497641;
	bh=1j/YX4hGCFRHbM511GZ3jEjm+k2K7vwUz2DLDi4CTEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KegeMDBqGhCD5LRRpCL49cL6qb8pMZHrIG9sDlv2JTU7OASwsni74Dp+3EZdA89zp
	 XdfRn9cPUuYW+kSgQgfs4I58bn0muQUPtHWW5b+EM40nLALI5mzq7EldJoofQAjEOx
	 AoOXne9LNNM44B7IK4ss9ayb/2OuB4j05D/KZjr8=
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
Subject: [PATCH 6.6 317/676] ocfs2: fix uninitialized value in ocfs2_file_read_iter()
Date: Fri,  6 Dec 2024 15:32:16 +0100
Message-ID: <20241206143705.726865449@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3a520117fa59f..a9ce7947228c8 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -70,6 +70,8 @@ enum ocfs2_iocb_lock_bits {
 	OCFS2_IOCB_NUM_LOCKS
 };
 
+#define ocfs2_iocb_init_rw_locked(iocb) \
+	(iocb->private = NULL)
 #define ocfs2_iocb_clear_rw_locked(iocb) \
 	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
 #define ocfs2_iocb_rw_locked_level(iocb) \
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e4acb795d1190..0585f281ff62f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2397,6 +2397,8 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	} else
 		inode_lock(inode);
 
+	ocfs2_iocb_init_rw_locked(iocb);
+
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
@@ -2543,6 +2545,8 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	if (!direct_io && nowait)
 		return -EOPNOTSUPP;
 
+	ocfs2_iocb_init_rw_locked(iocb);
+
 	/*
 	 * buffered reads protect themselves in ->read_folio().  O_DIRECT reads
 	 * need locks to protect pending reads from racing with truncate.
-- 
2.43.0



