Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585341;
	b=t6d7aUeDCBHvwjCzLI/U0nYq1D9G8+FlU76eIqTNimutQdaVS32GTBmmIZRksO0FUi2E
	 MHGidX7zhnromGO1+xUtNRYW7OhHRX/Vbj3KAOeFZa27BQfUP6rjZ8ZeV9nluLAU/b5h/
	 9mUhKZUU0gxa7ZNYCM/dfcxOvYFHxP5f63sCUV/Jl1EVYg1iJhmEgZ2wfy6q8ataTkG8v
	 2I6dYbw99K+R71aebWOxZqb81ogGZCo72AU8K13vu+scv9JzcE+xCkDsXCPdbpg9UYBqo
	 rVekhfLwR6lheh1l+EDnZRhFavhbfgnLsUmUoMncaF+sOq/4cOv+GHB3ia55qC6fpDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GsgGfxvi8FEQ6fW/u7gsIBnxf5ZSV9F8HJEfIvEuhxE=;
	b=V/SY9m43oB+w3fNNTryQn4gwTe6Monl6Y9eFxf5I/BCSg9TiJtx8jjDDzFkoaiCCN9G2
	 KOinZIeY7lWhUCOMREAh6smWKKOsiHBE+6uaEK9TsYk7YPijXLra9pmzgtXuff0+z7HA+
	 ihVMFFzB4TElBew+ORviiH8mUtMfM08IQvyl+iS9vhXwz0uhU3YhlkClbZFgRcjt790u5
	 46gs1yNRD1lBWtieN+jiGy9sfJzM4nbERbX9nBYk0HR5XNkiuWWSzx1AMoiHGCexBgIXG
	 RVR/5tLHOCq+k1Fkw8VC+juyjuveY5cf2/SdOWn8DFMKP/SePmtbKYRNvY3LEvjcl9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kVUSSSU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E81160A2606;
	Fri, 13 Nov 2026 15:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVUSSSU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB1A1F000CD;
	Fri, 13 Nov 2026 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585340;
	bh=GsgGfxvi8FEQ6fW/u7gsIBnxf5ZSV9F8HJEfIvEuhxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVUSSSU/Q3b6LX66CWjYUXZ6KYva4OTj93j/iI3vOT9FbP1u1M7DlwDMhcnUzvpaH
	 vz7DGc7LqFG0KcYgGdLj8jf0PbUxFo6iU/ZTX5Fzb1rL/LBmiy49QY1exvc2TpZukY
	 ye+flESDayua7uPxD9Na4TcHcwticN1w0sgBiFs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 025/507] io_uring/sqpoll: do the return-to-userspace work in the SQPOLL thread
Date: Fri, 13 Nov 2026 10:45:29 -0500
Message-ID: <20261113153754.232732842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index e86658ede44be..d387488db2dec 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -349,6 +349,18 @@ static int io_sq_thread(void *data)
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
 			int ret;
-- 
2.53.0



