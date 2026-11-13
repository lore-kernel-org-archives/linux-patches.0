Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590911;
	b=q4ak1nMZVxVPDXNB1wh9WhYnZNcQrk81JeTr3z4LaGEnai/SFGaoH16ZomOvjq6j7xLG
	 fsw2pPurmbpI/FHId/PE034dda2bgwusAz3Wi3d+Szcr/bu6+v9uyLiaBiBMKRicw5u+g
	 /eLxjzrwzJdnzXQUdPbVPZ0fuZeauq6MyeVExXY4294i4nDiQxwsbhrroWU92/fVJ46s9
	 hYu09OvxdZBlK19QzsjlkaQVIQkdR76TH2skXDq1kHN2CtTJLR02+xn+Z9/sk19E5jzSl
	 QnwYcJzpdjypsy+YaxRh7QTJ3EF2Vh4p7iSTERU05zMfATVqadHevkVLqEpjSJF7oBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gbH1V/YR8qX2ot7CvgYPxtVBJnStstkuoAlou3ATJYg=;
	b=3oO0nN3+xyTr4vAjTccOOOUDK+jECMWnojuTGLKY495oasy3x5ezjIwvb9djj+XZ+/L5
	 oNR/rRpIE8tZj3yDfDgL0ALHchU/ATYiuhGeVcXiIzJG0B3Bi5aUOZmWKmYJiEbX7dC8u
	 xav4YMKRhkfGL5/pgsAK/Lc1eMBjgvVXCO4vlCSiCrT/ubFFWlEmN+T/nEhr+BLuLD0IH
	 HmL/Vi/KzTRFU3bZlk92EQDcJdoUCg66uCoXtAFaS4QpEskq5eLOBlTERVDXbVzwifn/z
	 y2QxnBQZgqe8/+xwbkt73fsnT9rXPNIAbosoZzPr3+2Wfnyu0/XqROprf0Iwt/6bcng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mIX6ikOH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073D1606E237;
	Fri, 13 Nov 2026 17:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mIX6ikOH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AA81F000C4;
	Fri, 13 Nov 2026 17:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590910;
	bh=gbH1V/YR8qX2ot7CvgYPxtVBJnStstkuoAlou3ATJYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIX6ikOHEoonChpxGPkehlCpsLquaaJZSXcnCCIwSi2fJZbxkLoyURdOea4PS5TRc
	 W7OG+3ipdNW6IOeTCxtUF/BBvz4zjMS34o6MdTqs1okKsHWdUZSycfNTVz8VKDn9WD
	 zyP3iCrelyMXLzENCJyzASnvp9pePQDuq4wfj7fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuansheng Yang <0xbeac@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/670] io_uring/rsrc: hold uring_lock across index-alloc put_user
Date: Fri, 13 Nov 2026 10:43:42 -0500
Message-ID: <20261113153813.486949018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.12 uses copy_to_user() for the slot rather than put_user(),
and ->file_data for the table check]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index ad7ad35545d6c..168c6987435ed 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -562,11 +562,12 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
 	__s32 __user *fds = u64_to_user_ptr(up->arg);
+	struct io_ring_ctx *ctx = req->ctx;
 	unsigned int done;
 	struct file *file;
 	int ret, fd;
 
-	if (!req->ctx->file_data)
+	if (!ctx->file_data)
 		return -ENXIO;
 
 	for (done = 0; done < up->nr_args; done++) {
@@ -580,15 +581,25 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
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



