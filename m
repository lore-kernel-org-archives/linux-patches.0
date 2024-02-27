Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D750F13B2B4;
	Tue, 27 Feb 2024 14:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043660; cv=none; b=t6EdIU/oj/Qu1X36bLYfG6J9KT4Sef2FFl+wMwqukbwknNfBhmHMbF4qhv2PawOu2ZSB/ArWP/Gy7WCtB2IXQe7S8HvJ6B/1j8CM+mf4Nm+gncCmg9EBWdLP7K39kblOX3NM1MlWkFEqh44BWsRo0Zmcul7SQQ4dRTl6WxSa2lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043660; c=relaxed/simple;
	bh=K/LRQd2In2ISymX8pyARv9VB7RV1fGFI29kBNxYqSiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBJ2GFQZy3OxpV6qgnY17R97rhyTKKVQLNdEE6nmwu/yY+eJkcFJl/kh8+2VZNZc28b4pHKTZYEZziis+7lkbtS7xzZhwklgLsozV8Eg17q8oomV0Md1IK3MuzEIwkmMJn+yku7t+5iHsFL1pyssDjwpGJ/MaA/l0cwBrpPmOxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBGXBGKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBGXBGKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E0DC433F1;
	Tue, 27 Feb 2024 14:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043660;
	bh=K/LRQd2In2ISymX8pyARv9VB7RV1fGFI29kBNxYqSiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBGXBGKA+HAR10B7e7cmHqY8I1Q/J7O8B7pPtyjzAAMq5cLGTfSoN2aJHZxJkiJOW
	 2oh4ruVF+fZmwtULzld9BtfHxCOMsXTL+zeC1kI+hEJgv9Z9/ofqPBi3xZ3shn0s40
	 IYxwVAmpzmjrUHjOiEZ5Aw38LEA1ue0Ac79mqpqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Avi Kivity <avi@scylladb.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Bart Van Assche <bvanassche@acm.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 188/195] fs/aio: Restrict kiocb_set_cancel_fn() to I/O submitted via libaio
Date: Tue, 27 Feb 2024 14:27:29 +0100
Message-ID: <20240227131616.612391729@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit b820de741ae48ccf50dd95e297889c286ff4f760 upstream.

If kiocb_set_cancel_fn() is called for I/O submitted via io_uring, the
following kernel warning appears:

WARNING: CPU: 3 PID: 368 at fs/aio.c:598 kiocb_set_cancel_fn+0x9c/0xa8
Call trace:
 kiocb_set_cancel_fn+0x9c/0xa8
 ffs_epfile_read_iter+0x144/0x1d0
 io_read+0x19c/0x498
 io_issue_sqe+0x118/0x27c
 io_submit_sqes+0x25c/0x5fc
 __arm64_sys_io_uring_enter+0x104/0xab0
 invoke_syscall+0x58/0x11c
 el0_svc_common+0xb4/0xf4
 do_el0_svc+0x2c/0xb0
 el0_svc+0x2c/0xa4
 el0t_64_sync_handler+0x68/0xb4
 el0t_64_sync+0x1a4/0x1a8

Fix this by setting the IOCB_AIO_RW flag for read and write I/O that is
submitted by libaio.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240215204739.2677806-2-bvanassche@acm.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c           |    9 ++++++++-
 include/linux/fs.h |    2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -595,6 +595,13 @@ void kiocb_set_cancel_fn(struct kiocb *i
 	struct kioctx *ctx = req->ki_ctx;
 	unsigned long flags;
 
+	/*
+	 * kiocb didn't come from aio or is neither a read nor a write, hence
+	 * ignore it.
+	 */
+	if (!(iocb->ki_flags & IOCB_AIO_RW))
+		return;
+
 	if (WARN_ON_ONCE(!list_empty(&req->ki_list)))
 		return;
 
@@ -1476,7 +1483,7 @@ static int aio_prep_rw(struct kiocb *req
 	req->ki_complete = aio_complete_rw;
 	req->private = NULL;
 	req->ki_pos = iocb->aio_offset;
-	req->ki_flags = req->ki_filp->f_iocb_flags;
+	req->ki_flags = req->ki_filp->f_iocb_flags | IOCB_AIO_RW;
 	if (iocb->aio_flags & IOCB_FLAG_RESFD)
 		req->ki_flags |= IOCB_EVENTFD;
 	if (iocb->aio_flags & IOCB_FLAG_IOPRIO) {
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -337,6 +337,8 @@ enum rw_hint {
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+/* kiocb is a read or write operation submitted by fs/aio.c. */
+#define IOCB_AIO_RW		(1 << 23)
 
 struct kiocb {
 	struct file		*ki_filp;


