Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210287;
	b=guUvu/1Q1WKVuidrORrKVdPKnxK41F8lwY59duEv9TlaektzEXNEy9oMzUoUDWu25ZQb
	 UnnpmmI+6B0ixfhLSfo05bcp/Mpndpff39Gw/RRKT2vBvGtYdN1OA4hlmLzdSG+5ClxzW
	 JcpxtveY0nkScMl2c0Y4AdXkezd8Mz4CJjTGqTKCRPCGNfgffUpLxaiw2+rsAFxDdyKIH
	 y/Dcc5v3SlhYIIz2Eu791osJ8Jdu4csYyU0mDFDREiWWWkP0S7JibRlbmFyuHGgR7RLqv
	 6uhgsf2mD3bHofo4NFfwZ7eERYRsdq9aI0rPdYbdv4EKefkUU1mF7c7aBd7VLdjTIug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=htTp/tAasbaQF2gjxbJsmjcF/qCwaE1c2X8ZjcxGMrQ=;
	b=EKBAyDd45aEcatXPd/kaKIuRkleEcTur9+NGXWkctaG5iGHgU1Rdwo/Yi1z3wW2TH1IU
	 vsaVEAZSoVQf2+laVgNnOlYWhimm81ccsyYUvHGt2Uj8wrI48KOkOTb71jRi/vHeW98kD
	 sYW5jVFM2RKWEstOLgqJA5T7bH5GQ+B5R+a/RfxxuVYwXOYb3BwN2SlL7SjOl08tbUUcf
	 C+gOcCo/N1XB2Rddghpxbwbb+UCqRcH/Eq0/czvZw5W1FX4DRb4iDz6TfcYSqxEUw0a+l
	 vpBxt+iA4NzvCfUmyKnvKHVvxLjMHpLtjLNqj9yo3hLI5Sx1QlGf+LMKKR1APnoqnNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Fe/7/ebh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA531606A31D;
	Wed, 28 Oct 2026 17:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fe/7/ebh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B8D1F01825;
	Wed, 28 Oct 2026 17:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210286;
	bh=htTp/tAasbaQF2gjxbJsmjcF/qCwaE1c2X8ZjcxGMrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fe/7/ebhBIQlHMvG3Vei+DDEQPIuyncLZGCnten6HsUlL9g3/Gg8B9VqWEYQwkQ3M
	 vuzLFRkzRSx9BTmtzC1EjLjIBqyFhytzSCr+7XUBZUyp5ZCsTCN0+XQl/jPNDjVDn1
	 6n/FvcpMvyVs5BuZwXgESG6nCn4Fy2CbLpj2iRs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.6 140/168] io_uring/wait: look at all CQ waiters on wake up
Date: Wed, 28 Oct 2026 18:01:16 +0100
Message-ID: <20261028165946.398858215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ 6.6: io_wake_function() lives in io_uring/io_uring.c ]
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
@@ -2531,7 +2531,8 @@ static int io_wake_function(struct wait_
 	 */
 	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
-	return -1;
+	/* keep going, a waiter further down may be content with less */
+	return 0;
 }
 
 int io_run_task_work_sig(struct io_ring_ctx *ctx)


