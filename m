Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99F52E736D;
	Tue, 21 Jul 2026 17:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654556; cv=none; b=PkLpX1i0iIbCEmKOw1+ZArlwMU8pSvp1zV4T9/kQnACCtH2sZBoD7FKTSd9PZjgIZkUFPLNPGN1i1aCqCx47y4DrWJHMbqYgUtlneJq5438FifDiPAM0wI4YCOfQhyRMCy/FghBUYeWNNnlI2U9LdSEZIF/L3WYyhpjzS3ghDDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654556; c=relaxed/simple;
	bh=+AbEgWjeuP9b75em4fm2hcNxK6qdgXzC3dwt4gs1Bkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyTmx+Z14Lso7gEjbesEVNg3+oVwtWjz2DQigm/g1aZZDvzrvHwYw+Dd562SFU35QQNIXbhIuQ/WOOmGub2bFBkjGJscq/wLhzFF9FashMm0B7tDbJBhVMdK/Je/frXlZ14V0bfXm5Td++Uo43+kbdkvDD6azdlDNeHjYgeMCx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q05Bk8QW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q05Bk8QW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4181F000E9;
	Tue, 21 Jul 2026 17:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654554;
	bh=zOpnFFaFdCA++Vg+bGrpQ1I4eeU/4CU+tGPhtNnm7Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q05Bk8QW4aIGs682653tz9MePUJeFJ5XJI2B5UxsWgq0PhlkA3TvvMKjjnBVEOSY9
	 jDLiv4qHI7oVSC1kHBR/itDN3Y0qfoteLwtrpAiV6oGwTBgQdka0//yQg7bx82R2oE
	 5MBE7grta4PDQfxT4ORBaytWYZoHFosgox2EbTEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 7.1 1747/2077] net/9p: fix infinite loop in p9_client_rpc on fatal signal
Date: Tue, 21 Jul 2026 17:23:40 +0200
Message-ID: <20260721152633.952495325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit 6b4f48728faa8bb514368f7eacda05565dea8696 upstream.

When p9_client_rpc() is called with type P9_TFLUSH and the transport
has no peer (e.g. fd transport backed by pipes with no 9p server),
a fatal signal causes an infinite loop:

  again:
	err = io_wait_event_killable(req->wq, ...)
	/* SIGKILL wakes the task, returns -ERESTARTSYS */

	if (err == -ERESTARTSYS && c->status == Connected &&
		type == P9_TFLUSH) {
		sigpending = 1;
		clear_thread_flag(TIF_SIGPENDING);
		goto again;
	}

clear_thread_flag() clears TIF_SIGPENDING before jumping back to
io_wait_event_killable(). signal_pending_state() checks TIF_SIGPENDING,
finds it zero, and the task goes to sleep again. The task can only wake
on the next signal delivery that calls signal_wake_up() and sets
TIF_SIGPENDING again. When that happens the loop repeats, clears
TIF_SIGPENDING, and sleeps again indefinitely.

This is triggered in practice by coredump_wait(): when a thread in a
multi-threaded process causes a coredump (e.g. via SIGSYS from Syscall
User Dispatch), coredump_wait() sends SIGKILL to all other threads and
waits for them to call mm_release(). If one of those threads is blocked
in p9_client_rpc() over an fd transport with no peer, it enters the
P9_TFLUSH loop and never calls mm_release(), so coredump_wait() stalls
forever:

INFO: task syz.0.18:676 blocked for more than 143 seconds.
      Not tainted 6.12.77+ #1
task:syz.0.18 state:D stack:27600 pid:676 tgid:673 ppid:630 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5344 [inline]
 __schedule+0xcb4/0x5d50 kernel/sched/core.c:6724
 __schedule_loop kernel/sched/core.c:6801 [inline]
 schedule+0xe5/0x350 kernel/sched/core.c:6816
 schedule_timeout+0x253/0x290 kernel/time/timer.c:2593
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common+0x409/0x600 kernel/sched/completion.c:116
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion_state+0x1d/0x40 kernel/sched/completion.c:264
 coredump_wait fs/coredump.c:448 [inline]
 do_coredump+0x854/0x4350 fs/coredump.c:629
 get_signal+0x1425/0x2730 kernel/signal.c:2903
 arch_do_signal_or_restart+0x81/0x880 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xf9/0x160 kernel/entry/common.c:218
 do_syscall_64+0x102/0x220 arch/x86/entry/common.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fix: check fatal_signal_pending() before clearing TIF_SIGPENDING in the
P9_TFLUSH retry loop. At that point TIF_SIGPENDING is still set, so
fatal_signal_pending() works correctly. If a fatal signal is pending,
jump to recalc_sigpending to restore TIF_SIGPENDING and return
-ERESTARTSYS to the caller.

The same defect is present in stable kernels back to 5.4. On those
kernels the infinite loop is broken earlier by a second SIGKILL from
the parent process (e.g. kill_and_wait() retrying after a timeout),
resulting in a zombie process and a shutdown delay rather than a
permanent D-state hang, but the underlying flaw is the same.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 91b8534fa8f5 ("9p: make rpc code common and rework flush code")
Closes: https://syzkaller.appspot.com/bug?extid=3ce7863f8fc836a427e7
Cc: stable@vger.kernel.org
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Message-ID: <20260415155237.182891-1-kovalev@altlinux.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/client.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -600,6 +600,8 @@ again:
 
 	if (err == -ERESTARTSYS && c->status == Connected &&
 	    type == P9_TFLUSH) {
+		if (fatal_signal_pending(current))
+			goto recalc_sigpending;
 		sigpending = 1;
 		clear_thread_flag(TIF_SIGPENDING);
 		goto again;


