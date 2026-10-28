Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207790;
	b=RfNP7cCU74q7yQe3VtG4tn4pDwIgR4FwOtV2q8MV79t+5qNsnhA8CjVvePoQfzHBqaIF
	 1yC4NvbyY7lwUskgETuJYiLhAdKDvqgnLFfX/g5hi3Mpx/dWcSj+vrYhvYBUue3fVgD6l
	 fPToXs9YqNPhKcfOMiV85pLMv1fLjKJDG+sfAVeoCcgBPBVPWNg/ZSWew+IXjErOgNA8r
	 I887vKGLBfOVgwtIlVHnUPMQOqzF/MCQSYLi7Z1iC59d5VdQZBuRCmGBaGjUaLy8evH0+
	 ZVBlvXZS9I998/Va2pCX0HK435U+sN/BEwUj/Dw5WFhqSZL0mLKJUmuG374fN3VOydg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HCZ/Vvs9fZZIk3lMn4vmVRa/ue8KAIqOgiHcV4i/NoE=;
	b=JyWLsmoYxmrWIMU/3ZlpQXAKCAo0cC7jiqUOAv/AdHBGBzdFfSLyZWtiqUU8HgtTV8Sh
	 GrKiHhroPVoz8s3Taj31g5EOt/Vm9n/uZpqkYxAlOv+bMM6iKfPc08sle6UHDVJREpVCp
	 Z0zpggkc7YUaOTk98V0OvrmMO6MH1ek+g7JkG/vKEz+iqGkrPlem5Er9Ev4oUVSyNwmy1
	 f5LhS82BWKo2qXb5Zso1Xg3oUEPGTIWEzKDour+s9jMWaLl/qboha4BkbybRQWgYWAIa7
	 oi0IVh4pNCp+rPlaN+fNKnw7fjFDxpvpHlBruYXSCiWs5HIPAnltTRjvucaRfAJzOaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2kjT5voo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0616606A31D;
	Wed, 28 Oct 2026 17:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2kjT5voo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226FA1F01828;
	Wed, 28 Oct 2026 17:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207789;
	bh=HCZ/Vvs9fZZIk3lMn4vmVRa/ue8KAIqOgiHcV4i/NoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2kjT5voo7wFA8l++v3V60c3/wsn9o9lVB+aVWOFVXlp8hCTGyCaPoz6cFTBsDjTqj
	 MQfxq2emsjixJDoWvijUxbuG0xijW/irlo+7nhGbS4eQZBGXqkHvE1Z4JWcFRKAHpr
	 EweysDoOSLLHoujnqDf+SGDNJ+ma9S5N5MiBSZQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/247] io_uring/cancel: dont spin on local work the task cant run
Date: Wed, 28 Oct 2026 17:59:04 +0100
Message-ID: <20261028165950.748102276@linuxfoundation.org>
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
[ sashal: Used !llist_empty(&node->ctx->work_llist) instead of the unavailable io_local_work_pending() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0076c7599c947..68a21552a186f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3190,12 +3190,11 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
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



