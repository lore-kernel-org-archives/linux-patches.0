Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DCC189BB0;
	Sun,  7 Sep 2025 20:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276966; cv=none; b=c4Zf+Q4vH8YqXixZ/eAw4GrRgfljBqmiw7zFlfvHaRRD4Mt2h6y/qQETXUCbFEGA1VnAxk86SWSphkGEyI4iVsXa6XFP8cRXhV4VT2ltgACUK6OLA6veXIf8MxZrGkee5vDhssCOUkowg+GLWqIumZO/mOU4bWRJD58ejdW7QFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276966; c=relaxed/simple;
	bh=ZnjixwBOWFw2rrdxVhbNle6xnR+NaMLkbYLyt0gizaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCcaYW0MWyU/RF2LcTH4pUklTCmLU629IwmUjJ2HHxo5VbwmjedRsJFhpyLcbjUWxPO8rrFN+QHZJIOkhHKxdZom425zKIYhdOtyFWkFguVNfl2nIjdW2HS6MVcqW0FWbXqG4q5uUKlKU2NgKWjLVCv+fzzPa8aXK7qbJKr3kDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNfaxVvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNfaxVvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEACC4CEF0;
	Sun,  7 Sep 2025 20:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276966;
	bh=ZnjixwBOWFw2rrdxVhbNle6xnR+NaMLkbYLyt0gizaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNfaxVvc5lm8oS2aQeVggZRakxNRnRAuJv0nMTGqRAtIyLsuh2kKwl+NUAjMfb4Ab
	 YqMhxwJqKkB7UG4IRRTLxgx0FtsEDS9ouFtp5byoPFizll0ZzZaCgeRqSw/+WmebWd
	 Pq0HVmuciNWZv55Im8vSz5EwlPPm5kd3dtgHnf3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72db9ee39db57c3fecc5@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/175] net_sched: gen_estimator: fix est_timer() vs CONFIG_PREEMPT_RT=y
Date: Sun,  7 Sep 2025 21:57:20 +0200
Message-ID: <20250907195615.917372355@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9f74c0ea9b26d1505d55b61e36b1623dd347e1d1 ]

syzbot reported a WARNING in est_timer() [1]

Problem here is that with CONFIG_PREEMPT_RT=y, timer callbacks
can be preempted.

Adopt preempt_disable_nested()/preempt_enable_nested() to fix this.

[1]
 WARNING: CPU: 0 PID: 16 at ./include/linux/seqlock.h:221 __seqprop_assert include/linux/seqlock.h:221 [inline]
 WARNING: CPU: 0 PID: 16 at ./include/linux/seqlock.h:221 est_timer+0x6dc/0x9f0 net/core/gen_estimator.c:93
Modules linked in:
CPU: 0 UID: 0 PID: 16 Comm: ktimers/0 Not tainted syzkaller #0 PREEMPT_{RT,(full)}
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
 RIP: 0010:__seqprop_assert include/linux/seqlock.h:221 [inline]
 RIP: 0010:est_timer+0x6dc/0x9f0 net/core/gen_estimator.c:93
Call Trace:
 <TASK>
  call_timer_fn+0x17e/0x5f0 kernel/time/timer.c:1747
  expire_timers kernel/time/timer.c:1798 [inline]
  __run_timers kernel/time/timer.c:2372 [inline]
  __run_timer_base+0x648/0x970 kernel/time/timer.c:2384
  run_timer_base kernel/time/timer.c:2393 [inline]
  run_timer_softirq+0xb7/0x180 kernel/time/timer.c:2403
  handle_softirqs+0x22c/0x710 kernel/softirq.c:579
  __do_softirq kernel/softirq.c:613 [inline]
  run_ktimerd+0xcf/0x190 kernel/softirq.c:1043
  smpboot_thread_fn+0x53f/0xa60 kernel/smpboot.c:160
  kthread+0x70e/0x8a0 kernel/kthread.c:463
  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fixes: d2d6422f8bd1 ("x86: Allow to enable PREEMPT_RT.")
Reported-by: syzbot+72db9ee39db57c3fecc5@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/68adf6fa.a70a0220.3cafd4.0000.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20250827162352.3960779-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gen_estimator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 412816076b8bc..392f1cb5cc479 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -90,10 +90,12 @@ static void est_timer(struct timer_list *t)
 	rate = (b_packets - est->last_packets) << (10 - est->intvl_log);
 	rate = (rate >> est->ewma_log) - (est->avpps >> est->ewma_log);
 
+	preempt_disable_nested();
 	write_seqcount_begin(&est->seq);
 	est->avbps += brate;
 	est->avpps += rate;
 	write_seqcount_end(&est->seq);
+	preempt_enable_nested();
 
 	est->last_bytes = b_bytes;
 	est->last_packets = b_packets;
-- 
2.50.1



