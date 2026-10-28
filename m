Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207295;
	b=V6T/uaMexfyZHpdOa5HAHJywRznVjYXgPNX03GR5b2KDlUtI62hMdZhGb4nnmotQXitJ
	 uOHcdN5FjfJQeDJ68fWhFB096+qXfNWH4CXWUJODmo7GkPsaha3D/e+enyi8ZW12u8+mR
	 oiK7FafTaR7+zskzuC0NdHptgCwmU03JMBvXNR+4LnY1g0ON9JvqxFWnBuMVfGUhGzC6S
	 Dp9Y4DxpI8yuNhUGY0NI6M6F8WxEgK+huiMFX0Ay6FMYpK5nOeohRFy5f47+Yh/x83pp/
	 NjRVQ7hz1YW2n9/DUgBMKsO+3jyzX6FiziofyYp7LrtVgokuSF83Lsg3+ueZIhVGJGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k642+lewdlUaLAYsWBO5IdvgZOFyTm5nH1MUwA11VYg=;
	b=NHmv92nZ4+pQmnfJRKxW6TyJKo8GQKzoR36ldAJIZb0aatMXtWQ6fJwhsKdApkxBdk4D
	 8vjMT+TVfzWShmpKpN5GNHiXUJ7fmo3H0F3710zb6kadhtaup9Wr/bZ6WQPZWKeNDnKCX
	 nqWtn/e45bnK2FUprcQwGMzcuuX9cPimlD0jcggzv4VxXHI109stbQJUaM52uP9uBCfHP
	 Qxa2Som6/dxoFCK+5OwuSJyx5ucXtKIHqU1ASgDauAfeCdvzYtHkfgnp/eOK6otIWkUHs
	 j/z7yFcyQVlaNSUdUN9VeZMeug5mFquqF2lTnEOCMnSN3ZRTt1YJMVHQUav3JjSAbfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hJG+/9ec";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3D5606A31C;
	Wed, 28 Oct 2026 17:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJG+/9ec
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6043F1F031E1;
	Wed, 28 Oct 2026 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207294;
	bh=k642+lewdlUaLAYsWBO5IdvgZOFyTm5nH1MUwA11VYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJG+/9eclGEaNBt3z2sv6IgWW7Nh+AZdDgYFJvrx+kbq/AK/hM/+cBg0ifLnmFGVi
	 /88D5klvo9ShIagWcZwHZkrAhFUL2uMQtcGX6H02B/wcu3DYZMfd9Y6C7sk1TYJfK1
	 4sCmJEp3T2hmO0L1v44krcjScOWLUYoNpF6GJ5to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 54/88] io_uring/openclose: keep the lock in io_pipe_fixed()
Date: Wed, 28 Oct 2026 18:00:02 +0100
Message-ID: <20261028165943.384483676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit a3d7ee11289f657aa9af826d8f0844221292a27a upstream.

io_pipe_fixed() installs both ends of the pipe in the fixed file table,
drops ->uring_lock, and copies the slot numbers to the application. If
that faults, it takes the lock again and removes whatever is in these
slots.

If the request is run by io-wq the lock really is dropped in between, and
the slots are visible to everybody else. By the time the error path gets
to them, they may have been closed and reused, by IORING_OP_CLOSE and a
direct open or accept, or by IORING_REGISTER_FILES_UPDATE. Then a file is
removed from the table that has nothing to do with the failed request.

Do the copy with the lock held. Faulting in user memory under
->uring_lock is fine, the registration paths do it all the time.

Fixes: 53db8a71ecb4 ("io_uring: add support for IORING_OP_PIPE")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-38-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/openclose.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -375,13 +375,16 @@ static int io_pipe_fixed(struct io_kiocb
 	fds[1] = alloc_slot ? ret : slot - 1;
 	files[1] = NULL;
 
-	io_ring_submit_unlock(ctx, issue_flags);
-
-	if (!copy_to_user(p->fds, fds, sizeof(fds)))
+	/*
+	 * Hang on to the lock. If this fails, the slots have to be cleared, and
+	 * they must still hold what was put there.
+	 */
+	if (!copy_to_user(p->fds, fds, sizeof(fds))) {
+		io_ring_submit_unlock(ctx, issue_flags);
 		return 0;
+	}
 
 	ret = -EFAULT;
-	io_ring_submit_lock(ctx, issue_flags);
 err:
 	if (fds[0] != -1)
 		io_fixed_fd_remove(ctx, fds[0]);


