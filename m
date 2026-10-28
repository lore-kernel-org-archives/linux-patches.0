Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207182;
	b=Z7mRc1snGhMgKqQnpGV0yEJfRUb2U+148kPOhLS0n7Bo++YVEnil+3O+CrNceb43ZJ9G
	 ieemPPrRaLyaqYUe4VjRDecXjmUQSI7ZSYZCy9eU9hdLjMX2fiay3g1xOyo0XX3JqezqP
	 RJCx78UriY3cmi3G0sBVGW7C6qFKenAXgZmRtnD0OhfuNl/dQ2zVvNt1a9DbiT3XiGsjv
	 ssIZdaoLWtwRLptwXTqI2P4uj7Cconceph7PBCtGH3U04nxMWgmTqOqkOI0ZIvZbfwzIY
	 qRQZrni4HRD9iWQOhnT7rnRr+NbWuXqTNRT/Cq+tZGYxqXAgrUgrw0J6memxAO21V/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IfnO+ra8jf+kc8Ol/XZi7l0+1VM/xzfmvFBW98OfKM0=;
	b=DfSpijTqTTzoqbQ88Eo3AUm5Fi8PaG/wgeYMu9vUJvPD8gy8z7Ss1e2ko5nawee6TWyv
	 NqbtLQ1Pfov+fFbNitaAJSfe8Sr+Lo0X1RBxagGd3faAcB27BWE2KGpcRZELc7JiccxCU
	 MoROV2N3gY/mLJlScdaEBqlj14fCSi3AzTh3+AQfahDqllJWKHZdtgHNXYQ4VfCt6Syva
	 y8ODCm+8Fmj0mBy5fhny5zc7Sv5GAndezzozMAgFnbNDO9toQ5NlrKgvYwk554n6rl5+d
	 bjWSnm1QwHA/gP00DlwEgbcefxORiRPB3NSeLOi02PWZ6QhNDsOcSNBvHweMqcixfUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rysf3mtP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6655606A31F;
	Wed, 28 Oct 2026 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rysf3mtP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CD71F031E0;
	Wed, 28 Oct 2026 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207181;
	bh=IfnO+ra8jf+kc8Ol/XZi7l0+1VM/xzfmvFBW98OfKM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rysf3mtPg3XSFrgFkfJRdyWjD1UdUaMmyu17Ft+KcF9pHl0a+31G02IZOlTGKLl4h
	 g14/SCR7ylFgwYZO1p+IIcVufFq9Xi+DVlCflPOPqdanZd9T00Ts0bflK0aAGpafGM
	 CmwI+h6xHyqKUAjwXXTGgEL48Tmx2KNI7ylJkb8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 16/88] io-wq: order the exit bit against worker creation task work
Date: Wed, 28 Oct 2026 17:59:24 +0100
Message-ID: <20261028165942.497675794@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

Commit 0e5663856b69219ef2f02e04bac9f5c5be19718a upstream.

io_wq_exit_workers() cancels task work for queued worker creation with
task_work_cancel_match(). That has a plain load of task->task_works.

io_queue_worker_create() adds the new entry and tests IO_WQ_BIT_EXIT to
cancel it if the workqueue is already on its way out.

That must be ordered. task_work_add() has a full barrier via cmpxchg().
But io_wq_exit_start() sets the bit with set_bit() which doesn't have
any memory ordering.

So afaict, on weakly ordered architectures the exiting task may load
task_works before the store of the bit is visible. The other side tests
the bit before the store is visible as well. So the entry remains queued
with worker_refs and the exiting task waits on worker_done indefinitely.

If the task still has rings then io_uring_del_tctx_node() provides the
barrier via test_and_set_bit() in io_wq_set_exit_on_idle(). When it
has closed all rings though that barrier is gone.

Add the barrier after the set_bit().

Fixes: 71a85387546e ("io-wq: check for wq exit after adding new worker task_work")
Cc: stable@vger.kernel.org
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-4-8e4adb1619e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1319,6 +1319,8 @@ static bool io_task_work_match(struct ca
 void io_wq_exit_start(struct io_wq *wq)
 {
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+	/* Pairs with task_work_add() in io_queue_worker_create(). */
+	smp_mb__after_atomic();
 }
 
 static void io_wq_cancel_tw_create(struct io_wq *wq)


