Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211983;
	b=vPYZUNEMtLzIe7SsjmK0Rkyy+64pPVG+EhBovQ8u9O7q2Im7geFg0oelmepxpoMshdl9
	 x1efYrFEAp+1nvZz68rtEjE3v6aopB2WD65KZax+TD7PbcA073LlN76czwwRcBJqdL8PC
	 rk8zmG2iC7XV/T5k4Ag9e2yS+HxiCXXUZXslgwnULWiM23Wy6Cfbd68uB0YJqqQyIf4rJ
	 lfOOJhD742y1Ks7YnCJGh6+MRQjezeqs9BYzpf2ahj4H68ZcYBLKv7/mOwcyLH2iY/LP4
	 eU8vh+Vj6FeR/3rnqGPkYVlpAuy4Qe2RhnmlcjbVdRnxgMCZutXK+uhIYauo0dbayzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aaWigY0IgcgIjApK7WhKBDGepyPizgTIYoAV21nnzAA=;
	b=12oJkxqGIwzEs7qOIRnAUCy8RmlOsJ3NJ7rcMNNALS9TMQD5VpqvcJ9bpE6eipnMv2g6
	 sWiTXqFYrapsCB4z2I60T8u6fOhzk9WMA8+Y4UujQX3cUbjPW1jrGIKg946IuXBYzaP2i
	 bIj97akKe/AXxL1ruPExhdleqSUb2d0kGirtSnHue/zUuAhGrmYvdAmVDtRlRP2hnSLv4
	 KF9fWSP1fea6D5hFIcSI3xxvrasi6H43Hd7dN4ZlMqATt6YFzHqNG80f3qtoMcu/F8yi6
	 sJ5Mtd91CmerdzwnOPBBy8cVKIcMF8JSm5L6g95U0OYPnUU+3TaLPN+iYp2EeL+OR7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0xiriH5B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AC2606A31D;
	Wed, 28 Oct 2026 18:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0xiriH5B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B131F01825;
	Wed, 28 Oct 2026 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211983;
	bh=aaWigY0IgcgIjApK7WhKBDGepyPizgTIYoAV21nnzAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0xiriH5B2Mkbz3lNgwJNe99HFxlssygg0JLaieGQ1iABX5n/8haGGBTHAtZKnyCWi
	 NHoRBQs1J0LcbyjIqrhKBDEbLaSUET+6R6AY9vrK0/Qtai33IRmH3B2bDZweqo6hpn
	 Of60Q0Y5hn8SrsFAT16CB36irOtq6MJWlO8mm5M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 570/571] io-wq: order the exit bit against worker creation task work
Date: Wed, 28 Oct 2026 18:01:57 +0100
Message-ID: <20261028170021.566961617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 0e5663856b69219ef2f02e04bac9f5c5be19718a upstream.

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
@@ -1224,6 +1224,8 @@ static bool io_task_work_match(struct ca
 void io_wq_exit_start(struct io_wq *wq)
 {
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+	/* Pairs with task_work_add() in io_queue_worker_create(). */
+	smp_mb__after_atomic();
 }
 
 static void io_wq_cancel_tw_create(struct io_wq *wq)


