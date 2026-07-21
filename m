Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201884DB566;
	Tue, 21 Jul 2026 15:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649102; cv=none; b=ZGggbaYIWNo1ke10n+3MNC9RyqRSgPd2rcXofcHOXZ3jWSNOIs3lSKCicGWIZSzu8216Jq3nTjamdpXQ7SKiVE4224Rb8XdgvsuGSBOYLK0nj8NyHZGkYaRswjy0/V7VTy8MZTEdr9U1XTEJkk3abhHRcfXVOfgoI/7ZeAT/BPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649102; c=relaxed/simple;
	bh=8/vSysLe888arzcg2ixFuhQ7/kmnZfUnpfaBCyO40A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcyY5I02ZDCdDWzhEz1Tbqv+JhmirvkGNTfbOqjvmHHbc1uhDSikZaeSwdUBH5l/E03qMfK/mhXWkGtv5dWggwVo0I9BrTqth0AYAsWLYmj5X8mn2efRZCDnKfbEdsgR5ocOHygjmlEcThwHTsTDMhAwwviD8yngSUq/happXY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQIV26z4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQIV26z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855FC1F00A3A;
	Tue, 21 Jul 2026 15:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649100;
	bh=NlfMAWCbd3xL2CR7SpB1LLWEG2/RaS1ujpvGxlHJg/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQIV26z4rSH3dmR6bPRvydaSlfu9qz9Z2WQwtvAUzwXF9tHgdSYRcSckW5ZJjzt9Y
	 Baot1vUptHTrGFR1+QYGR6WLBDW4lCrmExeaVt9UmLrXWisXvTbdyluq16FwMmXr3g
	 tcClOOqMd1AJOnd1LRTXmaNiiqkl2krfOa3x5qC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0448/2077] lockdep/selftests: Restore sched_rt_mutex state on PREEMPT_RT
Date: Tue, 21 Jul 2026 17:02:01 +0200
Message-ID: <20260721152603.341740063@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 06961d60a0e410bf8df69ccff7eb1bd824912b8f ]

The WW-mutex selftests deliberately exercise failing lock paths. On
PREEMPT_RT, some of those paths enter the RT-mutex scheduler helpers.

The change referenced by the Fixes tag made those helpers track RT-mutex
scheduling state in current->sched_rt_mutex. The bit is normally cleared by
the matching post-schedule helper, but some WW-mutex selftests disable
the runtime debug_locks flag before that happens. With debug_locks cleared,
lockdep_assert() does not evaluate the expression that clears the bit,
leaving stale state for the next testcase.

With CONFIG_PREEMPT_RT=y and CONFIG_DEBUG_LOCKING_API_SELFTESTS=y, that
stale state produces warnings such as:

  WARNING: kernel/sched/core.c:7557 at rt_mutex_pre_schedule+0x26/0x2d
  RIP: 0010:rt_mutex_pre_schedule+0x26/0x2d

Save and restore current->sched_rt_mutex around each testcase, matching the
existing PREEMPT_RT cleanup for task-local migration and RCU state.

Fixes: d14f9e930b90 ("locking/rtmutex: Use rt_mutex specific scheduler helpers")
Assisted-by: Codex:gpt-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260523185123.17482-3-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/locking-selftest.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index cb806b628352b9..bfafe1204c7b6f 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -1433,6 +1433,7 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 #ifdef CONFIG_PREEMPT_RT
 	int saved_mgd_count = current->migration_disabled;
 	int saved_rcu_count = current->rcu_read_lock_nesting;
+	int saved_sched_rt_mutex = current->sched_rt_mutex;
 #endif
 
 	WARN_ON(irqs_disabled());
@@ -1469,6 +1470,8 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	preempt_count_set(saved_preempt_count);
 
 #ifdef CONFIG_PREEMPT_RT
+	current->sched_rt_mutex = saved_sched_rt_mutex;
+
 	while (current->migration_disabled > saved_mgd_count)
 		migrate_enable();
 
-- 
2.53.0



