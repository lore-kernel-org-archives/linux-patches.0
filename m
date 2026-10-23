Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774899;
	b=LRjgAy1RgmjQKO1Gj8lrOGkHWldpmdMq//XebIJst4sTk9X+uZMlwAckCi5jLDKVhCsC
	 SPXL8kkhMGYw1z2Yeyj/uBt5Z8mqxS0OJ/WFqp1IBRw7HwLZq2TGaMsvb0b9cKbcSHLYX
	 csSamtvmXw/dSHqxJc/oFblT429K0TjRoGcZSWNwjsFlat3Q0KR8f2hDSzApyl4bNnxmY
	 JxeMJSaWT4jMptGGIANR0IU7/fMnoZfWfew7Z3MYmVw5jEaqL7jtZHFxlYhIMy6s2n+Gx
	 8ygoTFPJzy/3a+LQJw/z6R+s5rhL4v+0Mf6dAABbRK+WDmuKEQNY9lb2UFsxJWLG94Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=51WSFqD2mbOEESpZYDBndqiZarRWWr2tFetm+U1NBmE=;
	b=20wg5fhAu+Vuom+ycJt5SrRUbb8Bq82guU0TZ6VaktkrtJ6C/XBgFNyA3u/NB7ESBuWk
	 NEXaPh4g2/OFXM4ap+5suUalF1EYWmG4jr8upInnfRzaxxGSEkswFJorGLw6lQDZPAQZa
	 a6xWV1bA576qQVzAd0ex7nbDV5fc0JmscP7pFnzcmQoXHxCVQWsmAXjtyro0gzOXt/RBZ
	 R0dGjrGaVk8EL2kQrxUCWVLo7RLnVg+lyIF1CmJemk4Fn01A9sMBu3wJ2vGa/BsiQqxs0
	 UFeEBDwIeORz8Z9MmgG8zLze7rIpqbc8ubjfJtdGjIZYXmVaBLVHpzFnmh5UgsdBCyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Je5IUFDm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88AC606A31D;
	Fri, 23 Oct 2026 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Je5IUFDm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1281F01825;
	Fri, 23 Oct 2026 17:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774898;
	bh=51WSFqD2mbOEESpZYDBndqiZarRWWr2tFetm+U1NBmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Je5IUFDmiDpZsGiLu6P88a81n85zYKC19MXIKd6CT5/o9A3AWRlCAdMDmMyCB0nDk
	 +WmxRbzHatthfX+feRA9ku/0mvaW6HiJ/5C/Au5lk4c9DlR3aFxow1YxSicT0SLGK8
	 lYXVrgoLWH5uxMJxKX0DiFWimsO+uBGD9kmkIeRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 195/242] io_uring/cancel: dont spin on local work the task cant run
Date: Fri, 23 Oct 2026 18:40:37 +0200
Message-ID: <20261023163718.404580812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

From: Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>

commit fddcf4c5321b3ea5f72166c3fd36a9d1c34f80c7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -634,12 +634,11 @@ __cold void io_uring_cancel_generic(bool
 		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
 		io_run_task_work();
 		io_uring_drop_tctx_refs(current);
+		/* only skip the sleep for local work this task may run */
 		xa_for_each(&tctx->xa, index, node) {
-			if (io_local_work_pending(node->ctx)) {
-				WARN_ON_ONCE(node->ctx->submitter_task &&
-					     node->ctx->submitter_task != current);
+			if (io_local_work_pending(node->ctx) &&
+			    io_allowed_defer_tw_run(node->ctx))
 				goto end_wait;
-			}
 		}
 		/*
 		 * If we've seen completions, retry without waiting. This


