Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209822;
	b=2nm2AQlaJLxymBnjHWN+pP4p1AW7gjbzv5wPLnSiAYNzwDaIpSmGm77kwE15qrzpUdBr
	 zCopRCJFCFItAtx1/T604uV1z8BydNZvMduCOEW+V4zfLEchMSrEnKSXpiLryn6DW2dws
	 GVLAp79ETNTkmYzPDAbMMtcyA7dG/bULv64lwOWmtQsqOXSHk/v1ZnPNS0uRK7Ay3yE72
	 4Pdz+UCQPvFwaQZ66dBNADLnshp+U5uq12RxW+T9fI0sU+3j346n7MFuW9B8gHzy3MCWP
	 DwD+xshSac7FJjFZo5GLPryD751P87VEuyfuWqSkI3BKlDzV3YPDr7qefq4VLDUzrPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x+HxWpUAw7BulpMbSN9DdoJND0rt37DJLspz0rxDvlU=;
	b=NXCwMa/nqvWobfwVUhWk/zOmlgQwpAQ5uR6ngR//ZnpTk0UqpCf8wchqqORG7BSEg9LA
	 NKK4EnHYicIcefRHNorrHQUBFPifmlyMvth2uCsHcrohwA0NGAGr9MSHP3Ev6p2aKpB2N
	 rMAHuc/t2F6yGAFSEtN76Qccl8UseeI7WxFBOpls4E1tW0Ay8MSu1xmwnJTxTQgoWJkDm
	 MMIotGRjhEozKtJux4Qs9P9shBpvLSeXAH+mtUjTTi/6fB6vkS2lHoOxItJrVCJ+2KVzS
	 lcn/hJUJ9IcBbL+HbK0yXxMEThcirJuILdgmJKTOnOe8klasW575NxGUFdpYzeqgJ0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSwYhp8H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9B6606A31D;
	Wed, 28 Oct 2026 17:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSwYhp8H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3621F01828;
	Wed, 28 Oct 2026 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209822;
	bh=x+HxWpUAw7BulpMbSN9DdoJND0rt37DJLspz0rxDvlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSwYhp8HH2INIR5FwuVgmYVMMEaT9IJjK9H8uyoEDsU5KdwO5jIGHP/GbF1gONDe+
	 sX7j5e5ilX9R5k07nYjvJL92ino7VuZ3lMzT9vme5mq964rgBvhcVc8BPDU+/P5acr
	 S9+qCTQbPKbACOeCJHd1+n3u+PmI9QcznBJisurA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 043/109] io-wq: order the exit bit against worker creation task work
Date: Wed, 28 Oct 2026 18:00:27 +0100
Message-ID: <20261028165943.377231070@linuxfoundation.org>
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
@@ -1320,6 +1320,8 @@ static bool io_task_work_match(struct ca
 void io_wq_exit_start(struct io_wq *wq)
 {
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+	/* Pairs with task_work_add() in io_queue_worker_create(). */
+	smp_mb__after_atomic();
 }
 
 static void io_wq_cancel_tw_create(struct io_wq *wq)


