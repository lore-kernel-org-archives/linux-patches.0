Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B849F155A4E;
	Tue, 29 Apr 2025 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950684; cv=none; b=Ndb2q0dTHONVHdJiIXN9CAbDkMDW3QHid2Rrhg5grNJfmnNiwzNsJ2j9H21ewfLgVlWtW2NfkHqtY3OF54VAjv8xyVHTY4jduau+FTeoIsQ/ebz3e0TBPUhZ07W6z3ifqLTEeO+bsN81ASFzf9EMrILP2PmkGug5jig2k90qdqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950684; c=relaxed/simple;
	bh=6V0WTA4g7637Mw2x3CthB9AVLfIX7lBeWNL9hBLiQXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TesTdyrDu/k+n8Fcket+WSAM+0YYvSmr5iKyEPHkJctp+oJm8d7mB8SHDq+YssN5ZPQ7E/jPWdOGVKH+XsivQ0ZCtwWzsRSWbBIJShakqmpYcgg99m3LvZGlL8lVJzhD0Dhnrl6PcmEX2aiSdZnQoMwwDgTnj9FX+A2/o/B5ecU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIElRP1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIElRP1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5750C4CEE3;
	Tue, 29 Apr 2025 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950684;
	bh=6V0WTA4g7637Mw2x3CthB9AVLfIX7lBeWNL9hBLiQXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIElRP1qy4WmTl3HhJsoSbcsyr4lK4A8+RuerKkByWWRSB0vwT1loceV3v78IN6su
	 S9B10lTQ9Bb3dVmTpDaNK9c4BpepJlKcHtF/YOI3KhOfQJ0jGwKwRoXHPki52kku3F
	 1JmkUS3awno1J9jrUAw4tnWGG3GglU6ygV9Fv8as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/204] timekeeping: Add a lockdep override in tick_freeze()
Date: Tue, 29 Apr 2025 18:44:21 +0200
Message-ID: <20250429161106.483698315@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 92e250c624ea37fde64bfd624fd2556f0d846f18 ]

tick_freeze() acquires a raw spinlock (tick_freeze_lock). Later in the
callchain (timekeeping_suspend() -> mc146818_avoid_UIP()) the RTC driver
acquires a spinlock which becomes a sleeping lock on PREEMPT_RT.  Lockdep
complains about this lock nesting.

Add a lockdep override for this special case and a comment explaining
why it is okay.

Reported-by: Borislav Petkov <bp@alien8.de>
Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/all/20250404133429.pnAzf-eF@linutronix.de
Closes: https://lore.kernel.org/all/20250330113202.GAZ-krsjAnurOlTcp-@fat_crate.local/
Closes: https://lore.kernel.org/all/CAP-bSRZ0CWyZZsMtx046YV8L28LhY0fson2g4EqcwRAVN1Jk+Q@mail.gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-common.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 7f2b17fc8ce40..ecdb8c2b2cab2 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -495,6 +495,7 @@ void tick_resume(void)
 
 #ifdef CONFIG_SUSPEND
 static DEFINE_RAW_SPINLOCK(tick_freeze_lock);
+static DEFINE_WAIT_OVERRIDE_MAP(tick_freeze_map, LD_WAIT_SLEEP);
 static unsigned int tick_freeze_depth;
 
 /**
@@ -514,9 +515,22 @@ void tick_freeze(void)
 	if (tick_freeze_depth == num_online_cpus()) {
 		trace_suspend_resume(TPS("timekeeping_freeze"),
 				     smp_processor_id(), true);
+		/*
+		 * All other CPUs have their interrupts disabled and are
+		 * suspended to idle. Other tasks have been frozen so there
+		 * is no scheduling happening. This means that there is no
+		 * concurrency in the system at this point. Therefore it is
+		 * okay to acquire a sleeping lock on PREEMPT_RT, such as a
+		 * spinlock, because the lock cannot be held by other CPUs
+		 * or threads and acquiring it cannot block.
+		 *
+		 * Inform lockdep about the situation.
+		 */
+		lock_map_acquire_try(&tick_freeze_map);
 		system_state = SYSTEM_SUSPEND;
 		sched_clock_suspend();
 		timekeeping_suspend();
+		lock_map_release(&tick_freeze_map);
 	} else {
 		tick_suspend_local();
 	}
@@ -538,8 +552,16 @@ void tick_unfreeze(void)
 	raw_spin_lock(&tick_freeze_lock);
 
 	if (tick_freeze_depth == num_online_cpus()) {
+		/*
+		 * Similar to tick_freeze(). On resumption the first CPU may
+		 * acquire uncontended sleeping locks while other CPUs block on
+		 * tick_freeze_lock.
+		 */
+		lock_map_acquire_try(&tick_freeze_map);
 		timekeeping_resume();
 		sched_clock_resume();
+		lock_map_release(&tick_freeze_map);
+
 		system_state = SYSTEM_RUNNING;
 		trace_suspend_resume(TPS("timekeeping_freeze"),
 				     smp_processor_id(), false);
-- 
2.39.5



