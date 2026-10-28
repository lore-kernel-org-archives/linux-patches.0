Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207943;
	b=4MBURyN455vUFWhPstiodjC9MraogXFNhxkS4BmR4LXm+x+JxlpxRUJu1zkrL5yeF+Uv
	 ZuKAFFnMZ7kWqBnFgDZdP1w6QrrIPGveRFvtG87GOwU1UgbJrdS4nRI2VL52qMtaPf82T
	 I3aQbtmaD8PFOpLCfwUA5JFoPpykRfmoQzzl94hXi/VKxfq/LyslL6Fg/sCTU9sF++GUI
	 GSBq2dZegIuQE27mXaXQR5fFprKGrESnLG7yLoSulOwYpwO8AhW2S7pF/86st9mDpBKv/
	 yiBfjxg2oBVxAsw0L82t98BQxFwdxSeEfuMGLLr9rN7dBO39yMEoWVacQ0eGINYpaoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HulGuEwwGiRuezV+9q8NogfkdadbAMNUT4xV1ZeE3HU=;
	b=qVSVn/kiM7BYKLnLvoaxsclkMg9Qln7xz40ZWmIaCse/+m1Jjyxyk5mcBnPxo0MPC9Jv
	 gFzQbfZStW9CqcW3L/x9HC/BZebjECd2qjYzpzPk5PpCRv6c7o+tLtMj+S/zg/+3G100w
	 ul1iiQPym9oXcyKP6KxuQEXeV/nuenjKZ1gSpqd5WTmONzN7jSkYWf9/FEPakmOg7IY3V
	 DzKWph876GzmFnpkmIPwmYMPdBz9DptZ3LJ5h0v8SNCNXwz1Q4AxVYmk0D1IMiDeODfwD
	 CrVUPf6Za18hVmBnfkanrCiMuCVCSxykqyl5sV0TykfOyivTM5OZe0slHbNdsPOwVWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mcGuFaBf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E53606A31D;
	Wed, 28 Oct 2026 17:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mcGuFaBf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68971F01825;
	Wed, 28 Oct 2026 17:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207943;
	bh=HulGuEwwGiRuezV+9q8NogfkdadbAMNUT4xV1ZeE3HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcGuFaBf4uhC/g1jzUPMWb564jwvYiyfLizLr8IrNTfusqOEzCsI9agDBi6hQCK5t
	 Y03SoBu7mS4m9t/NnOioE8l5YSbZA3WgVRUTf34pN33iUxU83v+yLDvRcD/iIYitsz
	 JjKtYWeXZXkvN/7OSxCkTpCkf7TRI6cajqDZuTUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 194/247] io_uring/cmd: dont leave list poison in ->hash_node
Date: Wed, 28 Oct 2026 17:59:57 +0100
Message-ID: <20261028165952.012772377@linuxfoundation.org>
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
@@ -85,7 +85,7 @@ static void io_uring_cmd_del_cancelable(
 
 	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
 	io_ring_submit_lock(ctx, issue_flags);
-	hlist_del(&req->hash_node);
+	hlist_del_init(&req->hash_node);
 	io_ring_submit_unlock(ctx, issue_flags);
 }
 


