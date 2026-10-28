Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210309;
	b=SFiJ+TNhojGpbSTfIv5IR39p9J19Sgi2T4OEsnQNblnNDRZw6OlTsrxUiR4ogLvT5/Ah
	 vJdrUJDYZjCuNTZIRDN1yKcGIgeaCX6yWvTDpOK8nHl6WUGWF1hDXALtZs4YWKYPlQn0s
	 oZXvszSZ6oWCyod+4ZEbCY7x2olOLqkL6tAOBBcyvEAgS6KhXf5swfiYV0jMHEyhrdyQF
	 EtgjNNmhn+2Aq2a4oh16ZoP5LL8/8Ql2sC/oTkWQZJ23AqSTUK9HoWV4WH5pEtf8KfaZD
	 3HMIt/XRbXAvenRwps1VBmAoI5hrTkDhcfVeJi73THktbJdKB81YyLxV2jTPTlE39lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IJcZZfx/WfqBzDzfRC5mK2rCB78XD5/AGvhyAYzk8HU=;
	b=t8k8NAl4nF2Esv5KHMxuwE8JYdkVVfnIG3ascfgyHBAhHPn9NFYRM3o1FNC5eXe6Z4+b
	 UDxTclS8LUOggbmKs68XJtZnb49KxllfGBTnKlLfpQ9ICEqF6/xZxguaTHfowaDBlfF7Y
	 fAaMgKa/6nOE5x0Zx6La9F9ZD6awGozRqJqfYTCQzHUB5Tx750uGXoajT0yIH9PwZ/xql
	 e0by4E4EMePfwPaLMa1y5KuloI0U5v2dkvfb5BTYvLamwkQlL5twF6eSxueb54x7cc9h+
	 dCfWeGRPM5ZDuCNf6mQYrpl8N4hIVFTb3bd/Hq5d/GBTYPibnWsMouZYqzJhicGxV+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yK0eimSy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF2F606A31A;
	Wed, 28 Oct 2026 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yK0eimSy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D106C1F01825;
	Wed, 28 Oct 2026 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210309;
	bh=IJcZZfx/WfqBzDzfRC5mK2rCB78XD5/AGvhyAYzk8HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yK0eimSyNFolJFil86oU2/OnJkMPuiW916YldeP/VGRMZ8sFcvR8aL9vZ41k7MtFp
	 r4osxkSzwtFJm6+fh1LORgQGC7bwfd5fXW5XluQJca0vtYsRDuaJaQGx/ps8lSqAUZ
	 ceOFX48z7gEiSBrYYMqRgkzEAZdMjwmuN6mp6vAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/168] io_uring/cancel: dont spin on local work the task cant run
Date: Wed, 28 Oct 2026 18:00:41 +0100
Message-ID: <20261028165945.574086131@linuxfoundation.org>
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

From: Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>

[ Upstream commit fddcf4c5321b3ea5f72166c3fd36a9d1c34f80c7 ]

io_uring_cancel_generic() refuses to sleep while any ring on the exiting
task's tctx has local work pending. It assumes the task is that ring's
submitter and that the next io_uring_try_cancel_requests() pass will run
the work. This does not hold for a ring that was still
IORING_SETUP_R_DISABLED when the task got its tctx node from
io_uring_create() or io_ringfd_register(). The submitter is set later by
IORING_REGISTER_ENABLE_RINGS, possibly from another task, and only the
submitter may run local work on an IORING_SETUP_DEFER_TASKRUN ring. To
the exiting task the work stays pending forever, the loop never reaches
schedule(), and the task trips the WARN_ON_ONCE() once and then spins in
do_exit().

An unprivileged user can set this up at will by creating a disabled
ring, having a child enable it and stop, posting to the ring with
IORING_OP_MSG_RING and exiting with a request in flight that only the
child can complete. The exiting thread burns a CPU until the child runs
or dies, and with panic_on_warn set the WARN panics the kernel.

Fix by skipping the sleep only when io_allowed_defer_tw_run() allows the
task to run the work. This is reasonable since work it cannot run cannot
complete any of its requests either, so nothing is lost by sleeping.
Drop the WARN_ON_ONCE() since handing a disabled ring to another thread
is a supported scenario, not a bug state.

Fixes: 360cd42c4e95 ("io_uring: optimise io_req_local_work_add")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
Link: https://patch.msgid.link/20261008191602.45101-1-cenzhang@linux.microsoft.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: replaced io_local_work_pending() with a direct !llist_empty() check on work_llist ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d4973d0d4e434..e74f49546961f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3491,12 +3491,11 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
 		io_run_task_work();
 		io_uring_drop_tctx_refs(current);
+		/* only skip the sleep for local work this task may run */
 		xa_for_each(&tctx->xa, index, node) {
-			if (!llist_empty(&node->ctx->work_llist)) {
-				WARN_ON_ONCE(node->ctx->submitter_task &&
-					     node->ctx->submitter_task != current);
+			if (!llist_empty(&node->ctx->work_llist) &&
+			    io_allowed_defer_tw_run(node->ctx))
 				goto end_wait;
-			}
 		}
 		/*
 		 * If we've seen completions, retry without waiting. This
-- 
2.53.0



