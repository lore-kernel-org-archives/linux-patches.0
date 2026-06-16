Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEAD4657CF;
	Tue, 16 Jun 2026 17:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629247; cv=none; b=gudZbh+SUEUPhQacuRJhB0j8audl20NnNaB3S78+FYKLcSBXFLmS1zfogmWYbkN/rnoDa72r8YWhnfjWoLIKHVaJ39fTRkPGWBuGgxNseGznuEQTYXz5JqfcT3YA1yz5MWXya5yP80nZY7L8Xlx8py4rX1wxw4qHlG8gltzclek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629247; c=relaxed/simple;
	bh=j2Z0DkYZT0Leg1Z3q23Tyu4ZZmdSHo1adOjv6MEr1gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVj/xKvp2i//8+TKSnJv1FEzwaqR3r68bf5uxD/zaYDYCNnUGGlgUU8UcaXaVlPG3Ts1TsSnWBX4Iv42Ye9WC2+mAAZEC1zAngtpoyvy1aqSPljoPosPGFnpoMIVX3B0MOUU/ZITu7Kvp+u2DONfMT7nWej9OiBBtS9k4EopOVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udVL88cQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udVL88cQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04DC1F000E9;
	Tue, 16 Jun 2026 17:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629246;
	bh=hCcTOj4810CM9bFsq3Wa9WSvOPkejx7xlJxPavdabZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=udVL88cQT1HXN7grTCPPTXDT8dtnZwmafhhMe8Vh6+cKm9BJwt+iw0Q7sVVXq69jH
	 TS+5KT+inMxQnoo+dleHKM0f1SH3RHNp0qemg4nX/RRc+R8dHnxwTj/XQUGuyGBIFe
	 w8941JZXpBvCCBCuyouPHuUMTRCIlD+66metoip8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/452] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
Date: Tue, 16 Jun 2026 20:27:55 +0530
Message-ID: <20260616145130.702910828@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
index 49c8c24b444d5e..3a484ea4bab658 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1382,6 +1382,7 @@ int zap_other_threads(struct task_struct *p)
 	int count = 0;
 
 	p->signal->group_stop_count = 0;
+	task_clear_jobctl_pending(p, JOBCTL_PENDING_MASK);
 
 	while_each_thread(p, t) {
 		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
-- 
2.53.0



