Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590030;
	b=nQteO8grzdSvgr+qmeuPAYMkvQ0jyHb4ItqhqWRM1+F8rXllCybgCj/tpF6zlV78dXlI
	 OBWQBTD1vikssHYAG1HTwJBhQmn0+r2thysN5XxWyzWg9kY61cQMq/ia5o0mM8jFWKQ6S
	 WcvSPwlXJx0363GEpkofMhqvjsoZkR81CqI0tH5KGwV4RgXKAIXPJ+ozfbcE6JdW5bwtO
	 LvUQuj0o1itBnjqKKNNYzhCqgXO/jtBx/qDx7HLz19tRT6BZYPKpeww5MO7WPe7HUehHi
	 QSFqjEabbyICn+IGWbacEI2YJ8Ovetb146YtSXhJ4rr+IrBWYzgQUiqzu0kgpuXvkYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Snc79xF5bd3JckoCm7xdFmDJ1Btr43q0Ujhf2WL3fIM=;
	b=0VoXETk5an2wB5wjJ1iF8SvypNcJdlf6Kmf9efOtNe/FvFoK8QYFr5ReT/85X6MGxDLt
	 i2sZ6oVCFZjE6RUCei5xMNTO+qY7U7MGq7oLYGOwWAkJOZp+hQAc3y3M8L6HKH52ETVoP
	 Fjm+aHX7ZHGTEnJ4SA/TERZnVohU8OB+Qs9OuUz3W0uC5tw1+SYGQv2N3gW0m5eRd/vMo
	 9EtDC+sfbPEgQYAdvx3v4Amq2oqTHGUpeP1vrQ+wd2cG0VFzdrcaJSWjXRKyWlJ7Lj0Gr
	 qt9BQWVX8vDKBnqUJV3aGGSa4FB3VRmsRCAvcg+vX/aoykYYzcxTbBOMHYnvYlrUX6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hAIjPuHh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DCF60A3814;
	Fri, 13 Nov 2026 17:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hAIjPuHh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DBC1F000CB;
	Fri, 13 Nov 2026 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590029;
	bh=Snc79xF5bd3JckoCm7xdFmDJ1Btr43q0Ujhf2WL3fIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAIjPuHhcZg5lQ8bm7punsQ0werUSC8iIhURYVvKFEN9ZcLfU6L4Nn4kes8YZIJNl
	 Uy5PZHwoJW44OjXLfJ1r44daXNDiLQldofp3PIAHfDvU1nc0T/3Iooca+0c49SElH7
	 5xc+LB8Q+2vOlwhhR3CQfxvEDiuKJ2kp0kPthHBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuansheng Yang <0xbeac@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/686] io_uring/rsrc: hold uring_lock across index-alloc put_user
Date: Fri, 13 Nov 2026 10:43:21 -0500
Message-ID: <20261113153823.226229023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Yuansheng Yang <0xbeac@gmail.com>

Commit d7c7037253f6935af243570635d71b4920b5a4ea upstream.

io_files_update_with_index_alloc() installs a fixed file via
io_fixed_fd_install(), which drops ->uring_lock when the request runs on
io-wq, then put_user()s the allocated slot back to userspace. If that
faults, the error path calls __io_close_fixed() by slot index after
re-taking the lock.

The slot can be closed and reused between the install and that cleanup:
another fixed CLOSE plus open/accept/pipe/socket, or a FILES_UPDATE, can
put an unrelated file into the same slot. The error path then removes
that file instead of the one this request installed, ending an unrelated
file's fixed-table reference early. This is a correctness/DoS issue, not
a use-after-free: fixed-file requests hold an io_rsrc_node reference, so
the node and file stay alive until they are done.

Hold ->uring_lock across __io_fixed_fd_install() and put_user(), and do
the failure cleanup with io_fixed_fd_remove() under the same lock. This
is the same class as the io_pipe_fixed() fix in a3d7ee11289f. Faulting
while holding ->uring_lock is fine, the registration paths already do
it.

Fixes: a7c41b4687f5 ("io_uring: let IORING_OP_FILES_UPDATE support choosing fixed file slots")
Signed-off-by: Yuansheng Yang <0xbeac@gmail.com>
Link: https://patch.msgid.link/20261104154655.81876-1-0xbeac@gmail.com
[axboe: various touch-ups]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.18 uses copy_to_user() for the slot rather than put_user()]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 41e5755bd9aac..7170b3f001d41 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -429,11 +429,12 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
 	__s32 __user *fds = u64_to_user_ptr(up->arg);
+	struct io_ring_ctx *ctx = req->ctx;
 	unsigned int done;
 	struct file *file;
 	int ret, fd;
 
-	if (!req->ctx->file_table.data.nr)
+	if (!ctx->file_table.data.nr)
 		return -ENXIO;
 
 	for (done = 0; done < up->nr_args; done++) {
@@ -447,15 +448,25 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 			ret = -EBADF;
 			break;
 		}
-		ret = io_fixed_fd_install(req, issue_flags, file,
-					  IORING_FILE_INDEX_ALLOC);
-		if (ret < 0)
+		/*
+		 * Hold the lock across the copy_to_user(), if it's dropped the
+		 * slot can be closed and reused before the error path runs.
+		 */
+		io_ring_submit_lock(ctx, issue_flags);
+		ret = __io_fixed_fd_install(ctx, file,
+					    IORING_FILE_INDEX_ALLOC);
+		if (ret < 0) {
+			io_ring_submit_unlock(ctx, issue_flags);
+			fput(file);
 			break;
+		}
 		if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
-			__io_close_fixed(req->ctx, issue_flags, ret);
+			io_fixed_fd_remove(ctx, ret);
+			io_ring_submit_unlock(ctx, issue_flags);
 			ret = -EFAULT;
 			break;
 		}
+		io_ring_submit_unlock(ctx, issue_flags);
 	}
 
 	if (done)
-- 
2.53.0



