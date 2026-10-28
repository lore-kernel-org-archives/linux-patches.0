Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209828;
	b=KlBKmh9TpZGxkd5WR+lbZ/ECroakafhF6yGktUijq0rHD0HsFiu9XH6TZxlfGmy5aUDI
	 230g77vaa+VIcSAzbLa2X0IgCortsUfGnAvoZEKoXTxjp7jIuAFWzpwQJMCeAgipDfG+4
	 J8P0Coi77/kLzgZ3Nf93qqSH5wEqbbBAhJcDilX6ZmTmOHJVSGYdUDPRde4YkoSj8pIQF
	 RhXnwmTS6TAcEAO4ftER0VK54x6kBQOBNIdSrfwWrBe43YIqtwDM1JXDUfcFnDLpAGpf3
	 eNCV/zt/hCQbZymy7Vom6zy88zMj2MTk6jSTnq7O+LmXrAjgGHhCOs5xMbBweZ8g8dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f9pVE12hO8Y1RV/ipFInn0X+zXFQGA4xXITiltE88GE=;
	b=Qa4r9Br4mMRV0STjfOlzf/tWsdSGBHi2bPvSVhXf2h6+EqBxq1dPLWKmOEMT53PZAmX1
	 pgcc3LfueZH9MiZP3/qZ165sdH3i8E13VgHijylwdmBQLR8DzTJ04pWUQ41lYtGfypfsy
	 iiuD8BD/F6+7HOGtT+At44t/sHhNL4q6MI2fIPHCJixdtgfIqfCB1tidTDxU2jN40qmec
	 jG5net7tUEbL4pDQz7D7paa+Y2CW4webC3X4b/BYKElqFxJ5SDH+09RCGc/VMBdF1mP60
	 d5b/qwRQfKi9R3HHCfbyDCq512FYIrHiQq2QSa/rp0soGi5xmiP+ctSiD/lViUo+8Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e9KQYOZ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459E6606A31C;
	Wed, 28 Oct 2026 17:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e9KQYOZ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966421F01825;
	Wed, 28 Oct 2026 17:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209828;
	bh=f9pVE12hO8Y1RV/ipFInn0X+zXFQGA4xXITiltE88GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9KQYOZ4he+t0fjYIpOOcfF3TTAWiyUt9VHPtL5eg/ygRfxhnqh8Mf+UNxUNTl9Ws
	 kZ4nB3dnNk3whqhI9vJAWa3ZUTdFnjVFTjWBr5x6BTEx33sQf6roMqIr7NWc85mweC
	 41fkJy4M3IXzCIW7RGUVjjtUE062VMhMCscf9Iko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 045/109] io_uring/cmd: dont leave list poison in ->hash_node
Date: Wed, 28 Oct 2026 18:00:29 +0100
Message-ID: <20261028165943.423031612@linuxfoundation.org>
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

Commit 4c83e39f4d1944d7146fd06094f2c8053238d55c upstream.

io_uring_cmd_del_cancelable() uses hlist_del() to take a command off
->cancelable_uring_cmd, which leaves LIST_POISON1/2 behind in
->hash_node. Requests are recycled through the request cache without
being reinitialised, and not every user of ->hash_node sets it up before
it is used:

If a vectored futex wait is woken while futex_wait_multiple_setup() is
still queueing the futexes, io_futexv_wait() doesn't add the request to
->futex_list, and leaves the completion to the task_work queued by the
wake up. io_futexv_complete() ends in __io_futex_complete(), whose
hlist_del_init() is fine for a request that is unhashed, which is how all
other users of the node leave it. If the request was a cancelable
uring_cmd in its previous life, e.g. a ublk FETCH_REQ, it writes through
LIST_POISON2:

  Oops: general protection fault, probably for non-canonical address
  KASAN: maybe wild-memory-access in range [0xdead000000000120-...]
  RIP: 0010:io_futexv_complete+0x219/0x420
  Call Trace:
   tctx_task_work_run+0x804/0x950
   tctx_task_work+0x71/0xa0
   task_work_run+0x118/0x200

Leave the node unhashed.

Fixes: 93b8cc60c37b ("io_uring: cancelable uring_cmd")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-2-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -87,7 +87,7 @@ static void io_uring_cmd_del_cancelable(
 
 	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
 	io_ring_submit_lock(ctx, issue_flags);
-	hlist_del(&req->hash_node);
+	hlist_del_init(&req->hash_node);
 	io_ring_submit_unlock(ctx, issue_flags);
 }
 


