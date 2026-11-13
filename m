Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590022;
	b=qDPAmEKblDWNTXDWp8+/Wda6liAw14S41UqXR9BxL7EMQwN+2dMLF3URSToaHi5YASZY
	 mUV188XGMXrckCbGf7t7h93BkAaR3Bxd5Q8ErzdBDl+0FxElFxby8vWd389buj9RpDN2H
	 KungTGAJtzvRu/K9h1o1fAK+FDws4MacZkIE6rx0jMSoQm9Yi9Fs3rSbZEj+sWE3F9ZrY
	 7IwOpOcLqElJ2vl2gnpAHEJTP/D6vl4EOgodcRn2y4T23bnsD2bdoObkXEPsxIr6O/h8c
	 Pbo3/AO5hmF2cUYsXDHxeS6ZqyVPKQa+V8ehBYsKZxk93U4yzX/W2XZ4fVvo8kbq4VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MtlHTnv/ZYu64kGel6w1hhIAorr+Lx+9ITnUNSUCMAI=;
	b=cJ6t7RVtImfdXFLJL1L8hUADoiY8988vC3IVWlGGW3z6zQAkXbpcYcCE53o80V8jJhUy
	 /OcIVY3Z/CftwYKyCRZkeKzyzEx/EytZnCcpOA2u6KRjCAEqzjj/l599o4nAvPYBvjksb
	 t5g4jAy6pVKkx6dlR00PLm9qIpm1WLahxeiKKBAvOjTOz13lCAF3pzYvByb4LCEiS5fm9
	 q0XcOzNySiIP7DfvxVd0vFEaEtEkArQ64COgre1XDufEoKaFK4Xgnt5quDKH8vqVTeB5S
	 UmqKz38HUxP041xqBQZ8NXZEUFJjEqKTSADsW9NRV5CL26BOp4gBk7IVFtYpcXaTPmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2h8ZwTz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C31606A890;
	Fri, 13 Nov 2026 17:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2h8ZwTz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361621F000C4;
	Fri, 13 Nov 2026 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590022;
	bh=MtlHTnv/ZYu64kGel6w1hhIAorr+Lx+9ITnUNSUCMAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2h8ZwTzCrtAREfxaCFWDtUOjIl+Zh29wZ9dEku+hz8qp4ndAoIMhUC6+WbtYmpt9
	 MnHmx0+MEve9+M7OfE1K34uFF1XJr+Dwrr5NiENAjv4Vs7uGxc+EQzsaDWkInIMEmF
	 MX5VI6RWMsWNQVE6ZihtgPdAlzJqn3yXEgrMNGis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/686] io_uring/sqpoll: do the return-to-userspace work in the SQPOLL thread
Date: Fri, 13 Nov 2026 10:43:16 -0500
Message-ID: <20261113153823.073298227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

Commit f013b695506491c5202a412a6568313549c81f50 upstream.

The SQPOLL thread never returns to userspace. io_sq_tw() runs its
task_work, but the rest of resume_user_mode_work(), like memory.high
reclaim and block cgroup throttling, only runs when the thread exits.
So memory.high reclaim only happens inside a charge, with sqd->lock and
ctx->uring_lock held, and not at all if the charges can't block.

This used to work. The loop called io_run_task_work(), which does this
work since commit b5d3ae202fbf ("io_uring: handle TIF_NOTIFY_RESUME
when checking for task_work"). Commit af5d68f8892f ("io_uring/sqpoll:
manage task_work privately") replaced that call with io_sq_tw().

Call resume_user_mode_work() at the top of the loop when
TIF_NOTIFY_RESUME is set, with sqd->lock dropped. It runs once per pass,
so a pass that charges two or more batches still reclaims inside the
charge, as before.

Tested in a VM with memory.high=64M and swap on zram. An SQPOLL ring
reads 256M from /dev/zero into untouched memory, 64K at a time. Before,
the thread made 337 calls to __mem_cgroup_handle_over_high(), all from
inside the charge. After, it makes 704, all from the top of the loop.
memory.peak stays at 64M. With 1M reads, 296 of its 385 calls still come
from inside the charge. Both runs take about 50% longer, and the extra
time is in the handler, which now runs more often. Without memory.high
pressure, the test never calls resume_user_mode_work() and the times
do not change. Lockdep showed no warnings, also with io_uring_register()
racing for sqd->lock.

Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Cc: stable@vger.kernel.org
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20261101022146.309201-1-shakeel.butt@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 1d31a4b1a9aaa..66405f4630e71 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -358,6 +358,18 @@ static int io_sq_thread(void *data)
 			timeout = jiffies + sqd->sq_thread_idle;
 		}
 
+		/*
+		 * The SQPOLL thread never returns to userspace, so do the
+		 * return-to-userspace work, like memory.high reclaim, here.
+		 * It can sleep for a long time, so drop sqd->lock.
+		 */
+		if (test_thread_flag(TIF_NOTIFY_RESUME)) {
+			mutex_unlock(&sqd->lock);
+			resume_user_mode_work(NULL);
+			mutex_lock(&sqd->lock);
+			sqd->sq_cpu = raw_smp_processor_id();
+		}
+
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);
-- 
2.53.0



