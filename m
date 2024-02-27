Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A45913B2B4;
	Tue, 27 Feb 2024 13:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042008; cv=none; b=nCorMY0IKeukPXNUSbjC9GBDzTlluE28Hj+qKihe2BvWghKfmKbesx/qPDrQINNFa44RbyT0d8ZHJaqXkMfKRBI7Pcxa/9gbJtIKQqspJJKHL6+zPqew+t2xTcNI0ldxfso8ZsLv84pS9A2Z9CJlx40D/fPlOkdnGP7ykgFqRyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042008; c=relaxed/simple;
	bh=JGGmXv/Bq1YKaPofXFXZ0edKoaihVi6nnokPjtqZswc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdUZFPl25bZ8as/A3saQPL7YEGrDFVSMbXNHMfMGxcfjMzPmMa7AAuhB83t3P2hAbfzYz4IJu3yei97SJTGRJruRe23WOqKzXwgUV5o8m3+66gw5mcOzdihKkZjjFZyoXZ8tUfcZe0CbtS2wz6LKdUaNphB9D9EizwSSIIwIKL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLxXHWCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLxXHWCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDF2C433F1;
	Tue, 27 Feb 2024 13:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042008;
	bh=JGGmXv/Bq1YKaPofXFXZ0edKoaihVi6nnokPjtqZswc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLxXHWCPOMsi92EqSxLUiQBin0SISw2mae3g83k26+DjlzpgAWolurLlR9hphBfPU
	 bT/t9AfuvXmdu6vPBVmf1fARcgRa3MDfXoa0IZRB/92mpAkPVEPSRYD48yzhRWdetz
	 Bj/Ggyh7/8dR3R6LO8yKlmFCAC+jLQmNcRdhlsbk=
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
Subject: [PATCH 6.6 145/299] fs/aio: Restrict kiocb_set_cancel_fn() to I/O submitted via libaio
Date: Tue, 27 Feb 2024 14:24:16 +0100
Message-ID: <20240227131630.535091139@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c           |    9 ++++++++-
 include/linux/fs.h |    2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -594,6 +594,13 @@ void kiocb_set_cancel_fn(struct kiocb *i
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
 
@@ -1463,7 +1470,7 @@ static int aio_prep_rw(struct kiocb *req
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
@@ -352,6 +352,8 @@ enum rw_hint {
  * unrelated IO (like cache flushing, new IO generation, etc).
  */
 #define IOCB_DIO_CALLER_COMP	(1 << 22)
+/* kiocb is a read or write operation submitted by fs/aio.c. */
+#define IOCB_AIO_RW		(1 << 23)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \


