Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207230;
	b=iQnqK9MuyhONQFsSihTJ+7ltqhLSLuYxeeTVSGhdtYUComky7yDbCINXygDUdMfTCMBc
	 dKg4RTGeVRfiXWGw9kmlPc3i8EZUJUKkB2JL/kAhosWKr7Tj59+iqhlzhl9WzIVXdMKMk
	 Hh+G90yrCYwKzIQPXDLx5y5g/hL2S0lZPsK2GIGxw2WWkkWIqpTod2bydAzZs/LRBnPeJ
	 1nNt4bBeHevHWWHYQBYc0Z2xbtXcL/WeYqaeWo+GNUQSZjQeTafXtsOO1p0prRQG/c3Wb
	 tMmYOgZEVcjfWTyhiXk1qSN4jwZWVnimzz33RT1EMpC0d0nX+7gPRIogfJKmowr1kGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yPyf7nJqvYeGUzaBhlq6rxkwgGytWuV4vUJvX43uUD0=;
	b=LsRKTTcO7OJiI0RhUugVDmiADkjeMBjzcpbYeyGk9b04lkSPX6B3i63zOxgANhRSRVBC
	 2Qegn0XaSm2UQhQ1Byep2XlDRmUep5/DRHvyOzoPu9ZMnB8EQ63ZlBr7hQa4yo87riIo2
	 ggmpQnN9sUc+OTmz1cTAojZXFqvmDZw80QdN3KhcrNj3ARzoio61UIRd7rpV1v/3QhYe9
	 VXkpodyiYk/cq646/NbJqoocoVnAq+nOzAJJuNXF0GlTx8ENfo975g02RSBk9LQLN/Rtn
	 2T3Kw/PHoJ3j7aizQll9/s4ADFfbF1qjqgJS7U8hIp6L2EFfv9hzfVaRcsj5/AYUXnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmNCSU+q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4784606A31C;
	Wed, 28 Oct 2026 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FmNCSU+q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026621F01825;
	Wed, 28 Oct 2026 17:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207229;
	bh=yPyf7nJqvYeGUzaBhlq6rxkwgGytWuV4vUJvX43uUD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmNCSU+qhKDCLLERVwRzM58o7isSlP6383hzwfFbQKtVUZfgVZB8TuVqke0dtN9dK
	 5mSGdyATeuxvBCYpIYYMNZrZ1m9JPTIguynRVac4VKVMnoqtj6A31u7g8+bXfOQKBz
	 gUv51pyvnoZsaVh4oKeGhVNT9c9wBTA0FwwIBrhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 33/88] io_uring/cancel: recognize "no timeout" on 32-bit
Date: Wed, 28 Oct 2026 17:59:41 +0100
Message-ID: <20261028165942.894129304@linuxfoundation.org>
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

Commit 3774e4d4c8533da2caae95556c4d635c7c4f45b8 upstream.

IORING_REGISTER_SYNC_CANCEL waits without a limit if both fields of
io_uring_sync_cancel_reg::timeout are -1. io_sync_cancel() compares them
with -1UL. They are of type long long. With a long of 32 bits -1UL is
4294967295, which is what it stays when it is converted for the
comparison, and the fields are never equal to it.

So { -1, -1 } is taken for a timeout. ktime_set() takes the nanoseconds as
an unsigned long, so what becomes of it is -1s + 4294967295ns = 3.29s.

If the request is being run by io-wq and can't be interrupted, the call
returns -ETIME after that time, rather than waiting for the request to be
gone. On i386, with a buffered read from a null_blk device that takes 4s
to complete a request, IOSQE_ASYNC, that is what each call does.

Fixes: 78a861b94959 ("io_uring: add sync cancelation API through io_uring_register()")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-17-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -319,7 +319,7 @@ int io_sync_cancel(struct io_ring_ctx *c
 	if (ret != -EALREADY)
 		goto out;
 
-	if (sc.timeout.tv_sec != -1UL || sc.timeout.tv_nsec != -1UL) {
+	if (sc.timeout.tv_sec != -1 || sc.timeout.tv_nsec != -1) {
 		struct timespec64 ts = {
 			.tv_sec		= sc.timeout.tv_sec,
 			.tv_nsec	= sc.timeout.tv_nsec


