Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207238;
	b=sVrJNXQT3u6ozuDRp3TDplLWdfseklWO4AmoHaeMlGTkTlLzx/kU7ZVL51/UzWiQFQxa
	 2QIw8ZQJJwJ24AfVESAj21VSVJFMUTLsYr1ArfbiDnFqzchpYP+2ejqk9RunbcCRXJFPt
	 Nx+zeaJPDaEeORDCK+DuO65tFzu9bZZN7TF3EAx1W/I5Q5KYxxfG7EZCx8cirER0NRUBj
	 HGHsu5aP/8s1QIuL6cCLXmngsaFaiVJ0UuzMxr9PIl7EN03Klfb1LlU0mlRldONp0zWDP
	 GI8/AL66/7iSFvtpJq2Vd9tg1W4+2MGdqlShH7nAb3HHssyASFVivDAGTf+0v8OdFfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bPBfGOEZSR1t/Qr98G2O6q+V8xNJmMuhiBbGe2nbjdY=;
	b=AHp18Ob7Iw+YyqnfqumJ/2G0J+DzvEahojHpyf0OGDg+TJL6r9hIwdWoDJJputr/nO0x
	 1kNxMoMClVXLP2DC2CdIDEp4h1ggA0BWPJJTcJLMzEi2LHHCheubKcIV3iOuhfENWGa46
	 7SQrpxSBiCOvHTUlAGIKcIwHMRhZzz33OS3TmPVIX6LP308xuk76sawDuilrF6pQa0WTh
	 2LEjw7KIuonvnbVjQFKg+hZA1K8pU8w8D2ScB8/BBDNTA3UkWLL+dj9egH/lmMRoLz+dg
	 MHxj+lQLOQvZGbFin9UDjfzR2Y0+Dbf8lE9aKYo8ULcxS4PS0l2uxCAez7d0awv04Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1aTdfLnQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D44B606A320;
	Wed, 28 Oct 2026 17:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1aTdfLnQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1FF1F01828;
	Wed, 28 Oct 2026 17:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207238;
	bh=bPBfGOEZSR1t/Qr98G2O6q+V8xNJmMuhiBbGe2nbjdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1aTdfLnQVInVU14Wzg7tL0QInwzdXPdAI+kAm/mPwfFvRj0Ltsu1u3+leMMTyClIM
	 q8w7w5yrhhxZLoABg6t6iTNkA0e02AzVKtF9P/6bOqL+2EmTjv7BWQ7BMJCdR1C5ya
	 JlsGtyR12p+UVHMFNdsGmoepCJ2NO/Z6xtxymbdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 36/88] io_uring/wait: look at all CQ waiters on wake up
Date: Wed, 28 Oct 2026 17:59:44 +0100
Message-ID: <20261028165942.962907984@linuxfoundation.org>
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

Commit 356f92f2412686f822383b784fa102924407457a upstream.

io_wake_function() returns -1 if the waiter it is called for doesn't have
enough events yet, which makes __wake_up_common() stop walking the wait
queue. That assumes that the waiters behind it can't be satisfied either.
Each waiter has its own target though, computed from the min_complete it
passed in:

  thread A: io_uring_enter(GETEVENTS, min_complete = 10)  // queued first
  thread B: io_uring_enter(GETEVENTS, min_complete = 1)
  one CQE is posted: A isn't woken, and B isn't even considered

B keeps sleeping with the event it asked for sitting in the CQ ring, until
A's demand is met or a timeout or signal ends the wait.

Return 0 to carry on with the next waiter. Only waiters whose condition
is met are woken, like before.

Fixes: bda521624e75 ("io_uring: make CQ ring wakeups be more efficient")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-20-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/wait.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -26,7 +26,8 @@ static int io_wake_function(struct wait_
 	 */
 	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
-	return -1;
+	/* keep going, a waiter further down may be content with less */
+	return 0;
 }
 
 int io_run_task_work_sig(struct io_ring_ctx *ctx)


