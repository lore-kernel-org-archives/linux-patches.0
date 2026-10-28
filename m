Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209739;
	b=MacMkR2gwgUativgEIihjvRtUIHHeb/ULDXLgE/haNjCB0Bn/TzPFSLlHg+hqLgM1c6S
	 n/eteRLwpM0iBx6iZHlGlVMcpUaNm5vZmiDA9yV3NSHzzO4hZb73bcs2UuVos34VpHpIV
	 t7ZMUVji6YhYLrv73RT0aDfkDNYDXqHdpvX/iqqFeuIFId+DMmsyYvWfhsupbh3klS15w
	 CANgfnDBEWu1FTZuI4NYJj09Ws65HzMeOPdOcZQhdi4KsBzl17ziRBbproTG4M0w5X2cA
	 G9DcD7SNLY3nu53smGPCD/XiZjQ3o1HEQFqrW+5qdpdFCgs9lnzFsdHn4GMB3+zehaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L9Pto+Rj9sPHveUhTPbGIxhmosla8YuiGNp676TRkfQ=;
	b=WJ9FydAuy2KCuUAzqx9s2UW5yyR9yWLJ2TJF1HiZcPgEDhtdLiZJli5uQu4OVbS6Gaj5
	 GHCyUquJuorlQCw7dDaGAQuof9Hepd1bs0pdCcHYthRs6DwWCh3V6OqIrQ2iX0dLlb/52
	 M+k0W2Xo1ZtLvkdhg1gqvgUT5ZkFsad6A4FkYebDHxAo0O+i1RJcVROBHJjrylWJ6QevV
	 FJ2PgxGihC1YIxLzUsh5aasK+EAuBvSRQJgl7hQoAjd/ZskzCfBxoFzeW3pF0vkjb/ez8
	 jvBW/A/2vBo9dNrYDBydLUnzkOwh59ejoCWDHy7RCVh/KRSbHPr17tZEy9RVmwmHZRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k++CTzRC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98898606A321;
	Wed, 28 Oct 2026 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k++CTzRC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77571F01825;
	Wed, 28 Oct 2026 17:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209739;
	bh=L9Pto+Rj9sPHveUhTPbGIxhmosla8YuiGNp676TRkfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k++CTzRCF5ouYElL/vh0KXD1FSp3DqzaolmYyqMx6m3WruBAur9vuqE5uLQSoixYn
	 4uypWvb+c0xYAYYcwNnMreh8/gqHyCUcFSSzmtY12cPe7HywdmVxbXdHZOLRl94n3/
	 P7hMm8xIKpySIExSCA8KRDmY21YXK6rISD+D10fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.18 060/109] io_uring/wait: look at all CQ waiters on wake up
Date: Wed, 28 Oct 2026 18:00:44 +0100
Message-ID: <20261028165943.772273143@linuxfoundation.org>
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

[ 6.18: io_wake_function() lives in io_uring.c, there is no wait.c yet ]

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
@@ -2525,7 +2525,8 @@ static int io_wake_function(struct wait_
 	 */
 	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
-	return -1;
+	/* keep going, a waiter further down may be content with less */
+	return 0;
 }
 
 int io_run_task_work_sig(struct io_ring_ctx *ctx)


