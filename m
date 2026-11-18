Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046059;
	b=W3RNwVp6CReKHQgfKXUyEndf5Hu8RnpwcSdJUGmtX9+7y/nGEkV9BWEzzUiZmOVlgfsI
	 WN1YON9ty9geH7GLGLJoyBmPaTbm9ugH5BvAzhSlxctgFuZ8CgFebSlkiuWzK1ZmTJR2Q
	 eT6Y7l2o/M2nKVRZHVFro0wVGzDzyL/Q7Th/yzUV4LKGz6dA6KJOE5JFLB/rEXa8Yk9Rz
	 Boo9Q01lmBW9Ht3D6wUQOzhZCC5D1FbhJ9UUGWphrw42/SPfw165HqWF2DgsUV4K/x98O
	 k+YAMgGRBMMDAZBLE/CAVjQ/KkJmlKRPUFpUUmDNUbZKIt1vAGkEfGkpRYK/oTR7PBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2RDz/u2xrUI8M589Ua9SX4Fws972m8tVpv1FOrj/heo=;
	b=BkV0Li+azzRDJe0J1xxEUZcB8gmCnA2sckf1pA9fzOMa9IZMlViA0fVLzjNPazBmeAlF
	 yxIxQ+R2KYxPiT605Au2X8gt+BhmgHHvnX2SRlSZjiK9DZrdtFkruZ9xaDqTZ1ZeuUhNu
	 8LgTVwrA1FwNvtPtAnbUNHu0NavH2fz227pumQl66pVcsIrWqy+QkCc4aD+JPqhHAxeu8
	 eV9016lxdnHuNis62IcPl5tdQ8+/1DY5P4HH7mt/Fu/sYNR+MgXf3++kXUDk3lSkJRL9f
	 pZsI4F+ZdY4ez5j34gZ2fl1C3RbZ6W+sjYNGUME7ARYhQQb2s+19S20cfzaMKRief5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3fRh5B2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5AD606A33F;
	Wed, 18 Nov 2026 23:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3fRh5B2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DED01F000C4;
	Wed, 18 Nov 2026 23:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046059;
	bh=2RDz/u2xrUI8M589Ua9SX4Fws972m8tVpv1FOrj/heo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3fRh5B29q//BVEzc9i3gRtZyQqN+zIz4+rpslQQHL2uIjEKXlF6zptaJ8cHFtAlg
	 v9svQt5XV4ifm1wS3qgnvAFDDo/uoZkBupcW5UGNL/pe5X+8naen3wDy4GiA12Efxu
	 4NQoQkyn37ez9ExWRDuWz9dMH0MaShgLq6EdT6Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuansheng Yang <0xbeac@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1145/2857] io_uring/rsrc: hold uring_lock across index-alloc put_user
Date: Wed, 18 Nov 2026 15:36:19 +0100
Message-ID: <20261118150242.809248851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.1 uses copy_to_user() for the slot rather than put_user(), and
->file_data for the table check]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 6fd3dcaa3c426..eb91f5b289244 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -670,11 +670,12 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
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
@@ -688,15 +689,25 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
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



