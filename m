Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209785;
	b=oJ/p7Vs38RYMrhkw3Wz14PzRl1NAtyKHx1wXafTh0T8zqwMV6RbDxk6okZXUMmHBMF6W
	 vRSlKyLOxhMNKWLOR7kX8eVkSLvnSRdnZxWmanBkT4CI7u2mgHYOjnJxWxMTUFNqBgKbe
	 CVJrvOL4/nN6JcbcokA0b04q88D4dnAOEkQ+2ifsEDOEbK3deV+LjQHo/OTmzSWR7WYls
	 cckczhFSPEGqNJ3qZxtpGFUX9WKGfvUyEu1yHhjeTYDBPvxU25uHgulr6/VBYCaEYOetZ
	 7L4ybCJes61mJ9rc3I5FWKSIiQeAVNRcXAwxOqeGzDrzagLCcZNF12O4gJbC046ISBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pg8AUOaPwzdGRNr6YjohQ39BzBWLphLFFHzkU23hNyQ=;
	b=4EdvWQVsmOt1f46ALkwUzuVNhDEvJJTnEqAJ0MIfUsGudqY4iyooLBO3T6LvyiEnSRbu
	 oXnc4dBOhKQ4CRYlyeCEsmp/MF0vJi2niquWVRhTRSLz+ie7EUfayw/DCuv9oD77VOyVM
	 HVBzlhqRwONPL9xBf6c6bHeqoAiIov/BT+HHyply9JGn7Ix2YuK/1GgCiWtNrxte8sdi6
	 XIV56QgZrG9sZSxNB0Y1ikKyiwzCpZw46C9UQBj4TFI3wa2LdLmaEVZiKNWPAtgrhK2xk
	 DquF9/aOpMl/5eQaRf9j6AB0D607ROCkKTGBEN0ZBaSMgJWhr5Mq2oh9YrmarcH2uIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0Q/pMu2l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C54E606A31A;
	Wed, 28 Oct 2026 17:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Q/pMu2l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9421F01825;
	Wed, 28 Oct 2026 17:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209785;
	bh=Pg8AUOaPwzdGRNr6YjohQ39BzBWLphLFFHzkU23hNyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Q/pMu2lNGKb/X7F0pm3mKg0OJz/b1k2pXGlzbOd9THegJJciv9h1/YJvzFfWTjAi
	 C9LlyLyw1m2kBGAU7/dTlH/3aF1ifJSiNA/EfGhE5zBAnKppTcB6wUI8KGFDDidsp0
	 bKv+l4qdDgnwhbDEIxRG/p75WyBz/DhG5+MA4Q/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 075/109] io_uring/openclose: keep the lock in io_pipe_fixed()
Date: Wed, 28 Oct 2026 18:00:59 +0100
Message-ID: <20261028165944.123199150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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
@@ -366,13 +366,16 @@ static int io_pipe_fixed(struct io_kiocb
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


