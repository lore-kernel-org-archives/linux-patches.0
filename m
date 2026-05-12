Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7DC3EDE55;
	Tue, 12 May 2026 18:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609110; cv=none; b=hAoloxu8DxoRo6Ok8cECQhSyp9Ub56CUac9KOeRiJUI2G3KVBQE08GKrNJntvDyTbAvMWPUsyrtwr86cHy8KucHkld7EYH3gjPeStBv8FQFSWmPY8POSWjrSlVCKRhpMFSAfZCaGyjnDuQTq+yCFZsLmkyyUbPHKffy2eOAkilU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609110; c=relaxed/simple;
	bh=l+nzudSWE+PHcN7VCPX1bDXn96XjO3FJlA/HKkOC+NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfFaXKK+ueXH10QF0LhmCXzd6MUeq013fKKxUEjM9qtchLyT2K/3hAvVXXLEsXGLe3MbnCRBFCfnR7E2J987Eo5bg9Shm9zwPFIHVYFxfFS32NZauUH867T1xKNkwruv6rf8W+U8oArYN2ldrAqNjH3U5rexVASLZEq5BjmEKtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izMN8+rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izMN8+rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EB1C2BCFB;
	Tue, 12 May 2026 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609110;
	bh=l+nzudSWE+PHcN7VCPX1bDXn96XjO3FJlA/HKkOC+NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izMN8+rnZqAYnm2196bcuzEk1i1G1c8pDU/UJTL4JknCODvjL1LobHr2NYWJwofQ8
	 Spr07garvzMOHwsfTrnQTdJpU6loaF5aU/R1twNl3haV+ZWM+WnqzuelDmJgCw0YFe
	 XiamzwQdD/pV3MEnIyTwWlCBPMlYECbw3C3eLXqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Femmer <robert.femmer@x41-dsec.de>,
	Christian Reitter <invd@inhq.net>,
	Michael Rodler <michael.rodler@x41-dsec.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 067/307] io_uring/tw: serialize ctx->retry_llist with ->uring_lock
Date: Tue, 12 May 2026 19:37:42 +0200
Message-ID: <20260512173941.535381714@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 17666e2d7592c3e85260cafd3950121524acc2c5 upstream.

The DEFER_TASKRUN local task work paths all run under ctx->uring_lock,
which serializes them with each other and with the rest of the ring's
hot paths. io_move_task_work_from_local() is the exception - it's called
from io_ring_exit_work() on a kworker without holding the lock and from
the iopoll cancelation side right after dropping it.

->work_llist is fine with this, as it's only ever updated via the
expected paths. But the ->retry_llist is updated while runing, and hence
it could potentially race between normal task_work running and the
task-has-exited shutdown path.

Simply grab ->uring_lock while moving the local work to the fallback
list for exit purposes, which nicely serializes it across both the
normal additions and the exit prune path.

Cc: stable@vger.kernel.org
Fixes: f46b9cdb22f7 ("io_uring: limit local tw done")
Reported-by: Robert Femmer <robert.femmer@x41-dsec.de>
Reported-by: Christian Reitter <invd@inhq.net>
Reported-by: Michael Rodler <michael.rodler@x41-dsec.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/tw.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -273,8 +273,18 @@ void io_req_task_work_add_remote(struct
 
 void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
-	struct llist_node *node = llist_del_all(&ctx->work_llist);
+	struct llist_node *node;
 
+	/*
+	 * Running the work items may utilize ->retry_llist as a means
+	 * for capping the number of task_work entries run at the same
+	 * time. But that list can potentially race with moving the work
+	 * from here, if the task is exiting. As any normal task_work
+	 * running holds ->uring_lock already, just guard this slow path
+	 * with ->uring_lock to avoid racing on ->retry_llist.
+	 */
+	guard(mutex)(&ctx->uring_lock);
+	node = llist_del_all(&ctx->work_llist);
 	__io_fallback_tw(node, false);
 	node = llist_del_all(&ctx->retry_llist);
 	__io_fallback_tw(node, false);


