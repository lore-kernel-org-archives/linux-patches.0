Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA5D4315A;
	Sun,  7 Sep 2025 20:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277558; cv=none; b=NRzzbawo3nLe513H9WeXqiVoRm+S7suQIts1sXKuw4cQC788IYk7XbotMDD0LUioWEkTga7V3yT5WPiYn7Q4zBr55efy5QfjJzEZiMrlavePJcStERqx1jF/lp1HBIrtYJfRdEBFkOAh+FR7IAPxDka7y8CUB3dgW8sDedZJ8Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277558; c=relaxed/simple;
	bh=NQ4I6HPCNFMEjsWBfWBVxfqu0cB9Yv6IjWr2trosU9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHCzv34R6cAkThFcYH2FoW9lPqlL4viEVUfqVOJxak4tzSGPxD6tycvtsW1AzRE5Z8FrexHgUBzdW3d1V3K6GkvW3hr4HEvvpgOA9qHllGFgG7WDHNsoqGQIZdnLA1yrKVqlGcT7tDjgVYQnc4EHEPwQO3ICZLlqEPMjfhvF/XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iergAT8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iergAT8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32160C4CEF0;
	Sun,  7 Sep 2025 20:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277558;
	bh=NQ4I6HPCNFMEjsWBfWBVxfqu0cB9Yv6IjWr2trosU9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iergAT8FHG3gajWs/st8+5SAA38FtvKsnGLIRvAlZa1Qyr0R1N6wkVJ7NLysm4F1i
	 aFDemScM+k50bYw+2l5ncJm3VlFx4hpgnTw808gFkh6fEKncuXa5eRrYFhBbqXw6JL
	 dYf6EQEkqo4V9rm9bZxsWkC1UPLazPFbmiCAVzhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+72db9ee39db57c3fecc5@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 051/183] net_sched: gen_estimator: fix est_timer() vs CONFIG_PREEMPT_RT=y
Date: Sun,  7 Sep 2025 21:57:58 +0200
Message-ID: <20250907195616.994885296@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 7d426a8e29f30..f112156db587b 100644
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



