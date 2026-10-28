Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207986;
	b=jrEhOCaaDTGIdDqkqD0yjsY7331YfcNQP8EmJByvLbjbyz0CEbiIunHa2uUJlW042WVg
	 Tcmoy2C692eoMsHY5V7SFnmE21saZDOUpCmInNDnmXLukkU+aWp8tbLXsWgqsWKs1AWqJ
	 gPKLl2lWBtUhU771EohhwB3q2+6Egk0sS9WkKm0sJEwc4/TYx6si+cbTKVEzZuiaeaDye
	 g+cb6T+RH6lyDmjN/4P7ng7zmPmFg+XLygH4Sj7Jazvweryz8ymZK3HUbJc2OxPjA8Mgq
	 qflA1rf0uHESYJIK7llrDY1NvvCRB0F8OC8vEJJOEFj4PjJkNMnvR/ASDELcw8jgEEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WxEHKYDMZpd7OFaJQNbyO49TYGFe1uB4eahBM+RBbTI=;
	b=USGJrifZ0O01sOB6nM4ZRGKCOOhn+gcB1BffAnYJ2WfjdCcDOwyKgeqr9uUiLfIWKd0Z
	 HChtE0QhhHBri8PuRabiwiiFwgWdL6kfSXkeVfiIMKN8uLnmmHlm1YZkSJx7wNaJgp5DO
	 TG3gfF3jCAVPVB+D3pFKVDWGOevwWToLGaGaFk7wCrC28dD6GVAWkiFg0VIycMjApC+tN
	 EGTdz0XiisLljckKIKNq0x6mpxCQfWyeDKCDNQ+H0D2htkDloEmJ5yqb/Mt201mxkSk8c
	 twniOsRTsBQ+5elZzVCiwc/dcvLcz3w29HrLcR1li3ZchmRhK+6+R/ZBUJg+pA5M0lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U88qyZPZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AE7606A322;
	Wed, 28 Oct 2026 17:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U88qyZPZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0DF1F01828;
	Wed, 28 Oct 2026 17:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207986;
	bh=WxEHKYDMZpd7OFaJQNbyO49TYGFe1uB4eahBM+RBbTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U88qyZPZWImw5HhUySfbbS5Jwb/8SLp8BpMNCHzHZKpxJHGBqIQ5glUi5JzETD0yg
	 i8FByyf1EZb1otRP9J+LU9Kgn1hYOA5Og506sJiYfo/ZE8/FdSxKAN+DY/82OUlYzT
	 DFvG7tksk0rXHlzVhRJS7BMGrvPAzwLq9O7U9cxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.12 208/247] io_uring/wait: look at all CQ waiters on wake up
Date: Wed, 28 Oct 2026 18:00:11 +0100
Message-ID: <20261028165952.346603779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

[ 6.12: io_wake_function() is in io_uring.c ]
Fixes: bda521624e75 ("io_uring: make CQ ring wakeups be more efficient")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-20-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2384,7 +2384,8 @@ static int io_wake_function(struct wait_
 	 */
 	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
-	return -1;
+	/* keep going, a waiter further down may be content with less */
+	return 0;
 }
 
 int io_run_task_work_sig(struct io_ring_ctx *ctx)


