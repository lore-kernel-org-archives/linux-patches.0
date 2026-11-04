Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826913;
	b=LoK/mc5T+KlL9ncl+rPZ6rKzPToOuVHaBQJb3cnl/MG2bIeoWQFaDB/b06j14/Frc7kS
	 8gcTbVRhoMk1zJiZz1cY8nNN5v6fANu/AbIIbiz0EVRqPePaAl8Gdg/1EsAuCJOx0OHoR
	 XxcSLW1lo7gU4T9epH+ql7FQYrI4Y61P/ZeuTr1A1e0ljFXSflgo9/mbLVqvpj476fVwJ
	 RKLSE/Vq9yBAp50HP2BDPwjzC6yGHDUGRTkNuRBE2OTN4qbGbNldVfTUVaz98JdURkEJD
	 t39MIabcm7Cw0N+YAwHGR6w2dstjwnPbCFw7z8cR2I5bEm6/f7W2wxX8Yzv8GL7mb/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sa+vXbPmBKUJVPnLzFPff1LlCphyv8wSPiUuYMravaE=;
	b=gN7AxITPDWBiePnffgnkTLysxwTQd4EVl0sv2SAUWnRYWP07WFlVR7Xb2H+2g6wPcmFw
	 ia6im1QHaJDVD0G2BOcXDlQluDwFQk5O/MHYxwbpz9fXQZ7Ru3z+/0PuQEvwa6G6zR962
	 NgBSZz8hgAwZzFsB74ANEt9J4kXhuAsy2JQolIqtbg/dIN5tVZut3wVNOQ9LrlvyfWut5
	 WC310wdrJUn+IpPwaocgkxRaZjbZLtuoFsjBkMNbmBYCSqLF5HD0HU4wRPqeGY9BmN4ng
	 xhXrBFrXZjDWFWDXz4TUySPV1VsF7mJr6z7TMQd4cY8OGCblG8F4ms0qKyqxINBI0xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FweKXAhH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED52A6084B6E;
	Wed,  4 Nov 2026 21:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FweKXAhH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780A61F0093A;
	Wed,  4 Nov 2026 21:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826912;
	bh=Sa+vXbPmBKUJVPnLzFPff1LlCphyv8wSPiUuYMravaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FweKXAhHo2ePz3Jpm9ONfghgycPqIAo88omjnjFHfNaxAl1PeKhZQIwMvTSfx+tKa
	 4nz7r8hPw4TfHumYthQfMJ02zm8YQZ8TWPH6hacE6CkmpkdQtEIKZFfdCYe8EexZAH
	 Dwnq/VbY95jOlEA1LAwqxSTzaABBW4EJhv2emIiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 054/547] io_uring/openclose: keep the lock in io_pipe_fixed()
Date: Wed,  4 Nov 2026 16:03:58 -0500
Message-ID: <20261104211039.829859470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a3d7ee11289f657aa9af826d8f0844221292a27a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/openclose.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index c71242915dade..24cf3ce2e2bc3 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -375,13 +375,16 @@ static int io_pipe_fixed(struct io_kiocb *req, struct file **files,
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
-- 
2.53.0



