Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207332;
	b=ZEzG7iLFXrU+KQGJGQ3gvfRbJUxeVQL6jgiLYOxn1LYzN3Oh/Cr6IJimL2uzr4zQVJD/
	 D/t5Nu+4ApcolIFxqT7NHVDmQkw1/d7Ay/+zdT2XULO3ZTimjk3MC38ixaGNbhlYH29kM
	 R0aaaJci1iVOYFkYU6Y4PCDjmB7OEgy/bDQSORbCPDXClrG6r2Hb5cEkU5Uu4ZrDyAbTC
	 iidFmy9S2NN0Sln7v2/++F2p1DS84l4CNQHdBTy2RgEMb6yfL5YoZ4Y07mqavmorj5Rsm
	 WPkxHk8ocVH/AlnF2gv8R9Pf+uxrDVdecfzoWlEmqE00cwc58oaJLdFIHRA3ZDQh8gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kpma37g0eBY4J5TRcKe3bXxsUMuxas2uwgCTTm6J150=;
	b=fKQpwpmyGWv3fVVWOfkiPCVuAR3toJBWHfOdPP2jORRNUHPWEQ+ed0THNtBZgjY2/42D
	 LdHcYOc0URN7MOmN55ylKUULhR3DHwOws+ObMudtRBtxM1cBr8lGvzyxTZHaiSNl6TSDK
	 ZR1F2wEv6wLfN2XZQVgv8VIL1/bfUUvXZtxKCDP5QqO8NHnDtc2dqr3zqah5HrkG7Y801
	 meYWGTbbaAJ7gjzowvJnf5LHNW89801o8uHcQpxqbj36JFS8yp3iOm6gTHsfw7L60LgiG
	 REMEBXuVh9L+FTgelh57bp3yqg+ZCyvurGv4Q5n1rGLbkeHl8HbeJVitLZDte90cn2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgfrVJ6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E61606A31A;
	Wed, 28 Oct 2026 17:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgfrVJ6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC9A1F01825;
	Wed, 28 Oct 2026 17:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207331;
	bh=kpma37g0eBY4J5TRcKe3bXxsUMuxas2uwgCTTm6J150=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgfrVJ6q7EbWhqapZ/7Vd2GykrLlt9TkqFqFrWh8amqbloyQYeZzgAkDnZqEtOW9c
	 39ASWNVo6+8tEk4k+4/vm5pOnqjmEEQ7lYAkkuixIGIZK/CIGC8p4LpbIqmselkAQf
	 MBJvRD1TsIz+IfxExfEQFJQXRh91PTSrmlWaoYYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 7.2 24/88] io_uring/cancel: rearm local work wake up before sleep
Date: Wed, 28 Oct 2026 17:59:32 +0100
Message-ID: <20261028165942.686871591@linuxfoundation.org>
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

Commit 76a82c666abf155ad52d5f41043eac77dd3e41d8 upstream.

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

[ 7.2: the loop still has the WARN_ON_ONCE() that commit fddcf4c5321b replaced in
  7.3; the new check makes it unreachable, so it is dropped ]
Fixes: d46ab2c98aba ("io_uring: switch local task_work to a mpscq")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-8-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -636,8 +636,18 @@ __cold void io_uring_cancel_generic(bool
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


