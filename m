Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212024;
	b=N1ahRKaMq4Yiu0//SzxiQneWjA4+VvffFaCvbNj9uQTPl5kWvtYLsMnpg7OM+NBzk+X9
	 TdFyyklrocb9a/zGxKR3gswSHNzksK7Sw9KZbgv7DhG/md4owhjCuq+RMU0eEz+zHLgLF
	 wWr+4msffaWpFIstxAW/xFxRR1hjqdBG7NOdF5fC9Iq0OHLgm6QGZtQn8Vw2QANfvxape
	 JHCwyCs2AYvOo9u7fGn5GoFjNHjK/pCkv8ckEEVslylTG6gBSnsJ5dd1akbXUujGXoL5h
	 RX8Fj17Cm78rBMCNuTN8Vv8u+9hpG3Os+5xvMgPP0GQLJXzj+zK4tP9fb6IT4dEmExg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iIugvdKwdqboNa+o44RoFeAPiS215GbthdS509zguYA=;
	b=rGfdfe0r3dQjRCDX1Npubufmbn+xhzvfCEw8J+uycz/bmwbha5ElusTNSOJ208B2fzUZ
	 fhxf0Bvcm78A45SDCj0ZD68r00LnrSAcQ3P9OyzGmj4mEA3vhSAy2oE3u/UPE6+icY9RY
	 Lb7H7w7Fe9BqwxiGceDm7BI465sPNC3PThbsFLyGR8Du3AclvGSbfsvdBWtraIveg26Gx
	 I6Ry50zrapRAsAZ/E3leHUYzlnj5uAs69DkWg2y7TVRJeEcX/9m+UkQ4H2MdgQH9EUBz/
	 yoxACJgvO0chUvlws9rj+vQcc1VjR7REvdibtagtBcaQduTSfEHQOyE8CYuFZJ/1HJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syTgx1oF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F24A606A31C;
	Wed, 28 Oct 2026 18:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syTgx1oF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6621F01828;
	Wed, 28 Oct 2026 18:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212024;
	bh=iIugvdKwdqboNa+o44RoFeAPiS215GbthdS509zguYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syTgx1oFa4yZ00K2ckSTB9nllvL7hSgQziTuqEH6NNQXSMFuSfvLENUn749dpKKEF
	 ugbuEvTCZq+/g8kqL7HPT2QD3QHcbrXgKRZ+HUV+u5bv4UpwSoBlpQajYcTfuXCA/y
	 jrT3phT7pseaY+Hx+d6W9bpK/xWVFiAwTl9QKmyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.1 0012/1887] io_uring/wait: look at all CQ waiters on wake up
Date: Wed, 28 Oct 2026 17:35:08 +0100
Message-ID: <20261028170459.502909680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

[ 6.1: io_wake_function() lives in io_uring/io_uring.c ]
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
@@ -2368,7 +2368,8 @@ static int io_wake_function(struct wait_
 	 */
 	if (io_should_wake(iowq) || io_has_work(ctx))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
-	return -1;
+	/* keep going, a waiter further down may be content with less */
+	return 0;
 }
 
 int io_run_task_work_sig(struct io_ring_ctx *ctx)


