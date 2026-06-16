Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C530526B0A9;
	Tue, 16 Jun 2026 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623239; cv=none; b=AdC0VhpmaxwldGU0klJgkgzBcbvotf2iKi214Sgq8ymzNT7kYRJVPdKM4wQUqVDdkYEe7UnNZmcpQ5oBRniFrjYoCEwaW97Sra4nojex/U0bcPtDdRGmJtw3TG8OKVRBsX8sgEt2crJXWE3+K8+BydXvXlOqCOP4f2r45sJVY8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623239; c=relaxed/simple;
	bh=wrIsw6Fd3LBdNlg444Yl+bnS+76ROdtFMxp36izius4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1HvC5PAj2HX1KukpJxwgP/BngMGBmUbmjJFZrLDvf29GYadS/xYT8EbCC5N7QjNAdObkPN/carGeaVhKSNPm9aX0G5tZk5EbgPfLVIT3v2dbyb7Sgz4KdXI6Kii34ZKbW9nla+VakXeZrvwXU3UE/AcqNVMoDVuvr7mD+ReCtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuxzdFJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuxzdFJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D2B1F000E9;
	Tue, 16 Jun 2026 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623238;
	bh=TbeTjazUGzd9G3CYLQcnrtaacj10TwaO3AjXz1zA3ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuxzdFJpw3Tozc0K13ylOBmEfnqiNa+4S0DDM7DJmqDVA02FCObZlbISz9VdYuVTA
	 8UshFQOqBJtefBrm7qHn5OPUVqoPeZnTw4Z6HVpJg5NtDpe+cK1bVIJNRr9fu+ymR5
	 pWq7CbanWRA8jJTUH2aOJINrcNItfLwL4LqvU4v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 078/378] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
Date: Tue, 16 Jun 2026 20:25:09 +0530
Message-ID: <20260616145114.285011628@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit 90918794a4e2c3b440f8fcf3847765a8b1d81b25 ]

When a multi-threaded process receives a stop signal (e.g., SIGSTOP),
do_signal_stop() sets JOBCTL_STOP_PENDING and JOBCTL_STOP_CONSUME on all
threads and sets signal->group_stop_count to the number of threads. If
one of the threads concurrently calls execve(), de_thread() invokes
zap_other_threads() to kill all other threads. zap_other_threads()
aborts the pending group stop by resetting signal->group_stop_count to 0
and clears the JOBCTL_PENDING_MASK for all other threads. However, it
fails to clear the job control flags for the calling thread.

When execve() completes, the calling thread returns to user mode and
checks for pending signals. Seeing the stale JOBCTL_STOP_PENDING flag,
it calls do_signal_stop(), which invokes task_participate_group_stop().
Since JOBCTL_STOP_CONSUME is still set, it attempts to decrement the
already-zero signal->group_stop_count, triggering a warning:

sig->group_stop_count == 0
WARNING: CPU: 1 PID: 6475 at kernel/signal.c:373
task_participate_group_stop+0x215/0x2d0
Call Trace:
 <TASK>
 do_signal_stop+0x3be/0x5c0 kernel/signal.c:2619
 get_signal+0xa8c/0x1330 kernel/signal.c:2884
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x8c/0x4d0 kernel/entry/common.c:98
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fix this race condition by clearing the JOBCTL_PENDING_MASK for the
calling thread in zap_other_threads(), ensuring it does not retain any
stale job control state after the thread group is destroyed. This aligns
with other functions that tear down a thread group and abort group
stops, such as zap_process() and complete_signal(), which correctly
clear these flags for all threads including the current one.

Fixes: 39efa3ef3a37 ("signal: Use GROUP_STOP_PENDING to stop once for a single group stop")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b109633ea805cac54a61
Link: https://syzkaller.appspot.com/ai_job?id=d70208cc-862b-4fe3-bf02-3031e10cd0b3
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Link: https://patch.msgid.link/20260521142240.2973022-1-nogikh@google.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index d65d0fe24bfb8c..1c9b5bf8126e01 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1340,6 +1340,7 @@ int zap_other_threads(struct task_struct *p)
 	int count = 0;
 
 	p->signal->group_stop_count = 0;
+	task_clear_jobctl_pending(p, JOBCTL_PENDING_MASK);
 
 	for_other_threads(p, t) {
 		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
-- 
2.53.0



