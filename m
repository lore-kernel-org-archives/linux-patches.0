Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829228;
	b=CLcoZs8989zkwxx07djXrxO77Bb8y8o2nSCslhFri0Bqzu7OCsGS2+mnkANb/0ZjTl/9
	 GbE6eN55cNfvIRAc43ZkQZ7Lk919pRMQqR2MIOhnhX8x03ZNjyVg30dxTbAkaG3vwZ+T9
	 aJSPZ2YUeCVoKVr8V/KYhMzMY3kXeRLtcwQXeLeSUblQkdqewWTt1i/enc2RIL1wffjyy
	 y4AVt2qwhH27/0awHXZZ6vKIFMXeqw4Q/IPAVjzLVDTW8x/WZqhnyC9OYaCFULrQGkyT1
	 WR3zreYlf4Guvig4DrQ9rc7aBRPX4biOhK8A3I2Old3vdPRTQfvGy31EVmOyAOsmpuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+1qE8OOTlTc6bV78Stlv3gAmsFEWM1fjsxOjcYQDw2E=;
	b=q1nwguJ5fHf5qX56AJlKmJZihBtp5VSm9JjbtXCRQ2xkiooUGVo69F6xIQO/QTiVQTh9
	 MaVChj5U75Mf7XJJGtHm4X9zFR/OEHPV9+JynnIbrMmwwnk3263EMK7l4Ay5LZDkNBwaU
	 Xa7sclT4TSyDk8rYHppQLTplN3MWm7EzRtddbs2M7WNGytTZE906XQfOwYiqIbxmSTdiD
	 f1n0z6XhDyI9hIadjd0Xh2dU8kg8c0etMJndbs764+LlusIKRSRZ7x6t+/HHSuWfmaHKj
	 74xei4p5G17GPJKZQZxleLIbJv+EfnBi4VoXvz8u7CRgaMH3haamefWRW/c/DLxvxLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9MQv27+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34566070A88;
	Wed,  4 Nov 2026 21:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9MQv27+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D08A1F000C1;
	Wed,  4 Nov 2026 21:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829227;
	bh=+1qE8OOTlTc6bV78Stlv3gAmsFEWM1fjsxOjcYQDw2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9MQv27+cguqURbRa2t4oPldiTTlucpJk/8l/mOjILWt6xeTcQbu2gpSu3vBDiVZ6
	 m+wYAbueneShesultSQR+XimOkRTnPku3MuJoTxSlcG8R/NO+qr/TvEyTvNSAExN1U
	 d95KEASCWxu7ycHPG5O7afTqy9X69CPmlJsEMVFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 529/547] io_uring: free the task context after a grace period
Date: Wed,  4 Nov 2026 16:11:53 -0500
Message-ID: <20261104211053.421385917@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

Commit 9f5315d3f4368590c9fe06d4313b7247470bcf15 upstream.

A task other than the owner can free a request, io_ring_exit_work()
running the local task_work of a DEFER_TASKRUN ring for example, or
io_do_iopoll() reaping completions. io_put_task() then takes the else
branch:

    percpu_counter_sub(&tctx->inflight, 1);
    if (unlikely(atomic_read(&tctx->in_cancel)))
            wake_up(&tctx->wait);
    put_task_struct(tctx->task);

The first line is what lets the owner leave io_uring_cancel_generic(),
and on exec it frees the tctx right after. Nothing holds that off for
the remaining three lines, the task reference only covers a tctx freed
along with the task_struct. It used to work out because
io_uring_del_tctx_node() took the uring_lock that the freeing side holds
across io_put_task(), until that moved to tctx_lock.

Free the tctx with kfree_rcu(), and enter an RCU read section in
io_put_task() before the count is dropped.

Fixes: 5623eb1ed035 ("io_uring/tctx: add separate lock for list of tctx's in ctx")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    3 +++
 io_uring/io_uring.c            |    2 ++
 io_uring/tctx.c                |    2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -161,6 +161,9 @@ struct io_uring_task {
 	/* drains ->task_list once the task can no longer run task_work */
 	struct work_struct		fallback_work;
 
+	/* the tctx is freed after a grace period, see io_put_task() */
+	struct rcu_head			rcu;
+
 	struct { /* task_work */
 		struct mpscq		task_list;
 		struct callback_head	task_work;
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -634,6 +634,8 @@ static inline void io_put_task(struct io
 	if (likely(tctx->task == current)) {
 		tctx->cached_refs++;
 	} else {
+		guard(rcu)();
+
 		percpu_counter_sub(&tctx->inflight, 1);
 		if (unlikely(atomic_read(&tctx->in_cancel)))
 			wake_up(&tctx->wait);
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -64,7 +64,7 @@ void io_uring_free_tctx(struct task_stru
 		WARN_ON_ONCE(tctx->cached_refs);
 
 		percpu_counter_destroy(&tctx->inflight);
-		kfree(tctx);
+		kfree_rcu(tctx, rcu);
 		tsk->io_uring = NULL;
 	}
 }


