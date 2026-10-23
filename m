Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774324;
	b=d7lQQHzRtI118X0RbtcBoRDCgjFh+PmkUx7YE1k6kqGu5dwsERcG36Nu5tgQUw231NA9
	 u93YRPo502255RVn3QeNd3W/gAc3qn4oMmr8njFerklFBSeU6hk0iwpHdWHSyS0ksLjKA
	 n2es6p/oIPjIJ+TdJ+w1LZfbJyxXCO6Zryhiue5eEqbZrKJjleK/OBbPvD1GUIVLdCP1s
	 tpbEHgpOAYqAmedHRQJzsm/KP/wfA7LQRe7O4/jYy/Ug4tIowRYog6Ds6DV2OoEZNsNaz
	 6XLP/zFsGGZwBq1zB6cHXc5s+Mi2bU5Hq82SbHuLDZeow9xw0dOrs2UAbpn8wq0MZVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I/Z4ZYl6vK7Z3okpm9zoDGKDA3h82hlkjxeR5jSuq84=;
	b=ySOECcf1/boNFf/YFBPU9NlCZuJ9yNrh/ShEq32CQAAoD50h9T2v337RkvN/GLUgdRLA
	 iBJhiHDJ9odFpzOawCzFEsfeMTAwmwmZVTFIN6En5YpInyJMc7ryNbhlgOCCExQ+952UZ
	 FJ/29SS00iE19oVV2YXru5UlXa3jlB3C0LtQvJYF5J7eQ/sMTufHbtwWWIfmzyekmgjU8
	 4HTnNgvXPyo43PIjc+7H/uC1v60dUyIg4E5nZApZryvyFkPiCkS2GYdcM2n5K6npt3AQ9
	 0TUD5xUz//GkEqJsPRb5ULCsErjbw+f3coT6D78qkVrIak/FwV632ZfZJrQAPTK/mmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gc8Mcb41;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FCC606A31E;
	Fri, 23 Oct 2026 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gc8Mcb41
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218D11F01825;
	Fri, 23 Oct 2026 16:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774323;
	bh=I/Z4ZYl6vK7Z3okpm9zoDGKDA3h82hlkjxeR5jSuq84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gc8Mcb41S5VB71XwwUICTmz5oc3peZikCNEMTNWuXPSZ+ey1jTqDXakZywQ0lkhK0
	 K6PWYQ17fUDHB1XejjB+NVtifcPIwDHM/z38hwbW7Hgfm9nBvWopyDptnW5Oan4B6S
	 3n3pi593hODyFYN5rY43E3pWK7uFIjxtEc0Qdr/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/193] io_uring/cancel: dont spin on local work the task cant run
Date: Fri, 23 Oct 2026 18:37:37 +0200
Message-ID: <20261023163718.475614677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: "Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -625,12 +625,11 @@ __cold void io_uring_cancel_generic(bool
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


