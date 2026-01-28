Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69664274FE3;
	Wed, 28 Jan 2026 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614481; cv=none; b=o6ssZRrLkzFkZ/7YWvsqF4o2ZHTMGqulFwqXTLSsBpdfGOi8kpwMx3Sws/s783N5r9Hz7RpfvGnewG2n3WDZ8EOeC3zzMQFevI01cO9kKjsc3t1eNvNFf80Oe39xWMu6JLX+E6TOKBpX8qWUFgxyZeVeRBzqLNz9MYafwQW60LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614481; c=relaxed/simple;
	bh=8cu4racVZMjn1zt3ORWeh1P908Hoy6wCQi3tQ8bUDu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kO4EoX37hbsmBUa+e/CWh7lRgmePkVfGkjGwRsniJHZc7dxDgY+DBtZBubxEV7BQIitXM0tYAEQmVhvvjNQamXGD3oyrYunvmOgmFRCWGq+3MsRMp2MfDckO+OK4L/bGXhk7OUeJnY0/kTTOEtgOAv2acAnjjv2CfoTlrathOSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etr9Kelw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etr9Kelw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482EEC2BC86;
	Wed, 28 Jan 2026 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614480;
	bh=8cu4racVZMjn1zt3ORWeh1P908Hoy6wCQi3tQ8bUDu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etr9KelwD7HfnPgUn1suH4QrnFRYpt1tfomeWaUaCMfavFb1rrBg9PV8TupxCca/P
	 XqMkVgnK8YpIDgJkuJFPzIm/sOsSD5j1fuI95FcpBmbBn7cwLMEvFwaRWxBOqRLg/D
	 6DY3s16KqLKAfA+uPykoqNpO9+tQEqum/ofoAO30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 150/254] io_uring/io-wq: check IO_WQ_BIT_EXIT inside work run loop
Date: Wed, 28 Jan 2026 16:22:06 +0100
Message-ID: <20260128145350.209913026@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 10dc959398175736e495f71c771f8641e1ca1907 upstream.

Currently this is checked before running the pending work. Normally this
is quite fine, as work items either end up blocking (which will create a
new worker for other items), or they complete fairly quickly. But syzbot
reports an issue where io-wq takes seemingly forever to exit, and with a
bit of debugging, this turns out to be because it queues a bunch of big
(2GB - 4096b) reads with a /dev/msr* file. Since this file type doesn't
support ->read_iter(), loop_rw_iter() ends up handling them. Each read
returns 16MB of data read, which takes 20 (!!) seconds. With a bunch of
these pending, processing the whole chain can take a long time. Easily
longer than the syzbot uninterruptible sleep timeout of 140 seconds.
This then triggers a complaint off the io-wq exit path:

INFO: task syz.4.135:6326 blocked for more than 143 seconds.
      Not tainted syzkaller #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.135       state:D stack:26824 pid:6326  tgid:6324  ppid:5957   task_flags:0x400548 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1139/0x6150 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6960
 schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common+0x2fc/0x4e0 kernel/sched/completion.c:121
 io_wq_exit_workers io_uring/io-wq.c:1328 [inline]
 io_wq_put_and_exit+0x271/0x8a0 io_uring/io-wq.c:1356
 io_uring_clean_tctx+0x10d/0x190 io_uring/tctx.c:203
 io_uring_cancel_generic+0x69c/0x9a0 io_uring/cancel.c:651
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x2ce/0x2bd0 kernel/exit.c:911
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1112
 get_signal+0x2671/0x26d0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x8f/0x7e0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x8c/0x540 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x4ee/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa02738f749
RSP: 002b:00007fa0281ae0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fa0275e6098 RCX: 00007fa02738f749
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fa0275e6098
RBP: 00007fa0275e6090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa0275e6128 R14: 00007fff14e4fcb0 R15: 00007fff14e4fd98

There's really nothing wrong here, outside of processing these reads
will take a LONG time. However, we can speed up the exit by checking the
IO_WQ_BIT_EXIT inside the io_worker_handle_work() loop, as syzbot will
exit the ring after queueing up all of these reads. Then once the first
item is processed, io-wq will simply cancel the rest. That should avoid
syzbot running into this complaint again.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/68a2decc.050a0220.e29e5.0099.GAE@google.com/
Reported-by: syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -554,9 +554,9 @@ static void io_worker_handle_work(struct
 	__releases(&acct->lock)
 {
 	struct io_wq *wq = worker->wq;
-	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 
 	do {
+		bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 		struct io_wq_work *work;
 
 		/*


