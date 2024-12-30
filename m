Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A60C15E8B;
	Mon, 30 Dec 2024 15:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573661; cv=none; b=elWdmmJkojAPXHxfrOc5Z365Lgod40XvxVmNKyKB13D+Ig/ITs/APgGJOuoO9FNR44Rj2RrJRfas+8X/Dn9Wxxcbzir7lpZDssQNWjzjFuG0W/2+YnfYzODS0pC//EBqVAZIzhCwMtx40hyQ0ALYbN0yHSiA+2p9Nxm/sNhiiIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573661; c=relaxed/simple;
	bh=Gr0tPT5fFAfOMyLLA1R8kEcFzFZ/3EmP3gN8u30kAs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qb9w/Top4Y7yu4WSG9mZZ+1qZLuv+iYhT4SoXlB0wlQzpc/mzdEdoDU12XcrsdgA1puS8R3Py6Miloo17k71YSQ1x1ea4oBU6PcldpmMr/sVFMXIfGOV+6k+mm5+TbHSPr9rQIwocefz9zrbaigC6sPpAdK93hcEe5RU2eHATjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2clL4rM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2clL4rM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD73C4CED0;
	Mon, 30 Dec 2024 15:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573661;
	bh=Gr0tPT5fFAfOMyLLA1R8kEcFzFZ/3EmP3gN8u30kAs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2clL4rMECB93JDU23M2HyldolPqWCUKQ+x8xy/6qxNqb6Lar/Oaiw3PFBXsCsvJQ
	 acdK6eXpwwTExYBPH56X9CL/drGXUgmhRgXQeWnksug/W5FSiWcJ25bTK4lDcUkRXW
	 P4tFrkSSPvnRcxc2ELU38ZA3DgzeRgP72VKRkxsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kun Hu <huk23@m.fudan.edu.cn>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 51/60] io_uring/sqpoll: fix sqpoll error handling races
Date: Mon, 30 Dec 2024 16:43:01 +0100
Message-ID: <20241230154209.211130245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit e33ac68e5e21ec1292490dfe061e75c0dbdd3bd4 upstream.

BUG: KASAN: slab-use-after-free in __lock_acquire+0x370b/0x4a10 kernel/locking/lockdep.c:5089
Call Trace:
<TASK>
...
_raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
class_raw_spinlock_irqsave_constructor include/linux/spinlock.h:551 [inline]
try_to_wake_up+0xb5/0x23c0 kernel/sched/core.c:4205
io_sq_thread_park+0xac/0xe0 io_uring/sqpoll.c:55
io_sq_thread_finish+0x6b/0x310 io_uring/sqpoll.c:96
io_sq_offload_create+0x162/0x11d0 io_uring/sqpoll.c:497
io_uring_create io_uring/io_uring.c:3724 [inline]
io_uring_setup+0x1728/0x3230 io_uring/io_uring.c:3806
...

Kun Hu reports that the SQPOLL creating error path has UAF, which
happens if io_uring_alloc_task_context() fails and then io_sq_thread()
manages to run and complete before the rest of error handling code,
which means io_sq_thread_finish() is looking at already killed task.

Note that this is mostly theoretical, requiring fault injection on
the allocation side to trigger in practice.

Cc: stable@vger.kernel.org
Reported-by: Kun Hu <huk23@m.fudan.edu.cn>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0f2f1aa5729332612bd01fe0f2f385fd1f06ce7c.1735231717.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -345,6 +345,7 @@ int io_sqpoll_wait_sq(struct io_ring_ctx
 __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 				struct io_uring_params *p)
 {
+	struct task_struct *task_to_put = NULL;
 	int ret;
 
 	/* Retain compatibility with failing for an invalid attach attempt */
@@ -425,6 +426,7 @@ __cold int io_sq_offload_create(struct i
 		}
 
 		sqd->thread = tsk;
+		task_to_put = get_task_struct(tsk);
 		ret = io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
 		if (ret)
@@ -435,11 +437,15 @@ __cold int io_sq_offload_create(struct i
 		goto err;
 	}
 
+	if (task_to_put)
+		put_task_struct(task_to_put);
 	return 0;
 err_sqpoll:
 	complete(&ctx->sq_data->exited);
 err:
 	io_sq_thread_finish(ctx);
+	if (task_to_put)
+		put_task_struct(task_to_put);
 	return ret;
 }
 


