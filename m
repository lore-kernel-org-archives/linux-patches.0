Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F07428ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C24C433EF;
	Mon, 12 Dec 2022 13:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852497;
	bh=P2NcJ3/LgoirCpBku+9bcoktAcZnBkl+pkjVjJyvkaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpULnZmzVOjlkOn7mvUZZvs+zL1ZWv5g5XZei6x5ANqgm2XUzz5VF+2uptfRpSpvQ
	 fwLTYtA1LOo0NDZbLJwQDAAiVSpE+8/9OcJ2tGp35g7Fv+IEKxGVlQUBBDsUQveuJs
	 ptWbBkUFAt62YyIopeCHcu52ehFYzrsBj8iifl80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 066/157] io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()
Date: Mon, 12 Dec 2022 14:16:54 +0100
Message-Id: <20221212130937.232228492@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit 998b30c3948e4d0b1097e639918c5cff332acac5 upstream.

Syzkaller reports a NULL deref bug as follows:

 BUG: KASAN: null-ptr-deref in io_tctx_exit_cb+0x53/0xd3
 Read of size 4 at addr 0000000000000138 by task file1/1955

 CPU: 1 PID: 1955 Comm: file1 Not tainted 6.1.0-rc7-00103-gef4d3ea40565 #75
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0xcd/0x134
  ? io_tctx_exit_cb+0x53/0xd3
  kasan_report+0xbb/0x1f0
  ? io_tctx_exit_cb+0x53/0xd3
  kasan_check_range+0x140/0x190
  io_tctx_exit_cb+0x53/0xd3
  task_work_run+0x164/0x250
  ? task_work_cancel+0x30/0x30
  get_signal+0x1c3/0x2440
  ? lock_downgrade+0x6e0/0x6e0
  ? lock_downgrade+0x6e0/0x6e0
  ? exit_signals+0x8b0/0x8b0
  ? do_raw_read_unlock+0x3b/0x70
  ? do_raw_spin_unlock+0x50/0x230
  arch_do_signal_or_restart+0x82/0x2470
  ? kmem_cache_free+0x260/0x4b0
  ? putname+0xfe/0x140
  ? get_sigframe_size+0x10/0x10
  ? do_execveat_common.isra.0+0x226/0x710
  ? lockdep_hardirqs_on+0x79/0x100
  ? putname+0xfe/0x140
  ? do_execveat_common.isra.0+0x238/0x710
  exit_to_user_mode_prepare+0x15f/0x250
  syscall_exit_to_user_mode+0x19/0x50
  do_syscall_64+0x42/0xb0
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0023:0x0
 Code: Unable to access opcode bytes at 0xffffffffffffffd6.
 RSP: 002b:00000000fffb7790 EFLAGS: 00000200 ORIG_RAX: 000000000000000b
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  </TASK>
 Kernel panic - not syncing: panic_on_warn set ...

This happens because the adding of task_work from io_ring_exit_work()
isn't synchronized with canceling all work items from eg exec. The
execution of the two are ordered in that they are both run by the task
itself, but if io_tctx_exit_cb() is queued while we're canceling all
work items off exec AND gets executed when the task exits to userspace
rather than in the main loop in io_uring_cancel_generic(), then we can
find current->io_uring == NULL and hit the above crash.

It's safe to add this NULL check here, because the execution of the two
paths are done by the task itself.

Cc: stable@vger.kernel.org
Fixes: d56d938b4bef ("io_uring: do ctx initiated file note removal")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20221206093833.3812138-1-harshit.m.mogalapalli@oracle.com
[axboe: add code comment and also put an explanation in the commit msg]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2560,8 +2560,10 @@ static __cold void io_tctx_exit_cb(struc
 	/*
 	 * When @in_idle, we're in cancellation and it's racy to remove the
 	 * node. It'll be removed by the end of cancellation, just ignore it.
+	 * tctx can be NULL if the queueing of this task_work raced with
+	 * work cancelation off the exec path.
 	 */
-	if (!atomic_read(&tctx->in_idle))
+	if (tctx && !atomic_read(&tctx->in_idle))
 		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }


