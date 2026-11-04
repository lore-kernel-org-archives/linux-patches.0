Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826814;
	b=svoPhQlEV3sXSlJOiWWbITEe4NnNMvzO/K31RIkZObpa9Gv8PT1jak6+1uLR+IIPfFlw
	 XK6u7sO67HL1pE4WkugtHMnJR2BeS8WFtXJbjlUEis8ptEmYuFBhZI6yVaXNzpy1BlM98
	 bm+zrmQCBplycmCjxpA1I3gcHvqDVzKFFpVsvo2XsewG7amezXCxrWVNUfUy2Ehv6/LIM
	 t7NpV9jR56pyeN5M1tonczOMpw3SOl/ICK+Jb3pjLj0wtHdpKrhFroPbwCLPJySoNGXTp
	 /u3H+fpIOd4W+/ELtxtLa3keowKO0V1SlZVfubkfkn4eNifsKApTy5+SS/l3iq9ByEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bLo64trbT3JggTuw+eHNoKrLuFxyEpO/+BAM81tw8rk=;
	b=XiAapdiofXaWKY968LQs8wuYnBk/q5gqg3KmuZlMCipKFIY8o5adPIdTqEtrn0xVotcs
	 A+TEIjvW4hJUteciIEZRTI6FDwPKbhMqot0q+ff/6TusmtDNPFOJ3igz43DFmAH7S7pjz
	 q40JzUpScklCqTs11KxqrfXvIoDhL48+YVNmY0vM97MWdPQARMfBahmhiU6d4AttMrGOT
	 6N6a2NQ2aFhPH9YarNN0JwT3Ab+XzMAS/+9aTln5iZXQPjluRUQrzOy76HFkwYdOY4exQ
	 LJzdTJOojyO37XFjfsc/N6YSyXXKhh2eH/nWy06A3ZLuMKJIPaEhXJ5m/Y15m0Kxj4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=niwu2drd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4BA606A338;
	Wed,  4 Nov 2026 21:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=niwu2drd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEF01F0093A;
	Wed,  4 Nov 2026 21:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826814;
	bh=bLo64trbT3JggTuw+eHNoKrLuFxyEpO/+BAM81tw8rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niwu2drdaH/cGYM6Lc6Fqw2WijL1HO2WaKgSh1EzmVhKwkFZ4jc9FwPsURz6PXDFE
	 JXddY6L97Md1dnKeDoI3kWjRwWnKQQZScJ5fjhjYwFQNDhFIL7iS23GpfaibvcH1Br
	 eWHGKMXYU1EuNFPSU+07fDMkKZ0lTc7AquzcNfKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 024/547] io_uring/cancel: rearm local work wake up before sleep
Date: Wed,  4 Nov 2026 16:03:28 -0500
Message-ID: <20261104211039.047116521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 76a82c666abf155ad52d5f41043eac77dd3e41d8 ]

io_uring_try_cancel_requests() sets ->cq_wait_nr to 1 so that the next
io_req_local_work_add() wakes the cancelling task. The add that takes the
count to zero is the only one that wakes, later ones see a count <= 0 and
return. io_uring_cancel_generic() however only becomes
TASK_INTERRUPTIBLE much later, so the one wake up can be spent on a
running task. That is fine as long as the entry of that add is still
queued, as the io_local_work_pending() check then skips the sleep. It is
not if the add was delayed after queueing its entry:

CPU0 (submitter in exec or exit)      CPU1 (io_req_local_work_add)
                                      mpscq_push(req A)
io_uring_try_cancel_requests()
  io_run_local_work()  // runs req A
io_uring_try_cancel_requests()
  atomic_set(&ctx->cq_wait_nr, 1)
                                      atomic_read(&ctx->cq_wait_nr) == 1
                                      count taken, wake_up_state()
                                        // task is running, no-op
prepare_to_wait(TASK_INTERRUPTIBLE)
io_local_work_pending() == false
schedule()
                                      mpscq_push(req B)
                                      cq_wait_nr <= 0, return

Only the sleeping task can run req B, so it is stuck in execve() until a
signal happens to wake it. An exiting task doesn't even get that.

Arm the count again once the task state is set and before the work list
is checked, for the rings whose local work this task is the one to run.

Fixes: d46ab2c98aba ("io_uring: switch local task_work to a mpscq")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-8-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 4f706aff14fc2..03b1f1f3fad16 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -636,8 +636,18 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		io_uring_drop_tctx_refs(current);
 		/* only skip the sleep for local work this task may run */
 		xa_for_each(&tctx->xa, index, node) {
-			if (io_local_work_pending(node->ctx) &&
-			    io_allowed_defer_tw_run(node->ctx))
+			if (!(node->ctx->flags & IORING_SETUP_DEFER_TASKRUN) ||
+			    !io_allowed_defer_tw_run(node->ctx))
+				continue;
+			/*
+			 * The wake up io_uring_try_cancel_requests() asked for
+			 * may have been issued while we were still running. Ask
+			 * again now that it can't be missed.
+			 */
+			atomic_set(&node->ctx->cq_wait_nr, 1);
+			/* pairs with the xchg() in mpscq_push() */
+			smp_mb();
+			if (io_local_work_pending(node->ctx))
 				goto end_wait;
 		}
 		/*
-- 
2.53.0



