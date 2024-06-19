Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04022AD58;
	Wed, 19 Jun 2024 13:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802978; cv=none; b=edfLvnGniTc+/dllqf3lcs9u/vrKy9joD7h5cBPbrfLuAg9Cp1AcDxAd42Y3lAQlb4ezS2bHAwRx/jp6F6THYTJ3a1Dqio5Yzc2IR1kjkeQjOKmXGLStFpQCAkA1/DSIaGHvJIs0HSqEo/xqga43EySocfL/6Y3RQNcTxuW5804=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802978; c=relaxed/simple;
	bh=6nwRZph+1038JcjZUN1UV+HerMDg2OYB2DWqUXM88QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0wgYclx4sPuLhax5rjTi4CG2b2dzgcHNVPirZVqNpvtPTi2m5pJYXgc2tLd4eZb9Nbc3gonlVFtfwfuSWQTWwPZzi3pXgIifysSoGFLTHExtJl7iEgO1ksbLh2FMcbZPzOuDDN4CLzEtFWLNhtG5Y6o4+mJzcKTj/+EabUFLXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuDcY7Vr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuDcY7Vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA14C2BBFC;
	Wed, 19 Jun 2024 13:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802977;
	bh=6nwRZph+1038JcjZUN1UV+HerMDg2OYB2DWqUXM88QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuDcY7VrOAwHyYotbuwdBO2VWwm6AlIkQm0RtuWolfN6lM3cS6qqmR9vKemHmgRq3
	 MkFVQqgDMSuEjqgvkli+k6rhoNSOrEWFHXdDSglSAKKD1ECBkCQsVc7RliT924NQLq
	 pqaTp1hUEbkWPl/VssGI4hrCXVskSgEfDCH4Hitg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Shi <sl1589472800@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.9 080/281] io_uring/rsrc: dont lock while !TASK_RUNNING
Date: Wed, 19 Jun 2024 14:53:59 +0200
Message-ID: <20240619125612.921240719@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 54559642b96116b45e4b5ca7fd9f7835b8561272 upstream.

There is a report of io_rsrc_ref_quiesce() locking a mutex while not
TASK_RUNNING, which is due to forgetting restoring the state back after
io_run_task_work_sig() and attempts to break out of the waiting loop.

do not call blocking ops when !TASK_RUNNING; state=1 set at
[<ffffffff815d2494>] prepare_to_wait+0xa4/0x380
kernel/sched/wait.c:237
WARNING: CPU: 2 PID: 397056 at kernel/sched/core.c:10099
__might_sleep+0x114/0x160 kernel/sched/core.c:10099
RIP: 0010:__might_sleep+0x114/0x160 kernel/sched/core.c:10099
Call Trace:
 <TASK>
 __mutex_lock_common kernel/locking/mutex.c:585 [inline]
 __mutex_lock+0xb4/0x940 kernel/locking/mutex.c:752
 io_rsrc_ref_quiesce+0x590/0x940 io_uring/rsrc.c:253
 io_sqe_buffers_unregister+0xa2/0x340 io_uring/rsrc.c:799
 __io_uring_register io_uring/register.c:424 [inline]
 __do_sys_io_uring_register+0x5b9/0x2400 io_uring/register.c:613
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xd8/0x270 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x6f/0x77

Reported-by: Li Shi <sl1589472800@gmail.com>
Fixes: 4ea15b56f0810 ("io_uring/rsrc: use wq for quiescing")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/77966bc104e25b0534995d5dbb152332bc8f31c0.1718196953.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -250,6 +250,7 @@ __cold static int io_rsrc_ref_quiesce(st
 
 		ret = io_run_task_work_sig(ctx);
 		if (ret < 0) {
+			__set_current_state(TASK_RUNNING);
 			mutex_lock(&ctx->uring_lock);
 			if (list_empty(&ctx->rsrc_ref_list))
 				ret = 0;


