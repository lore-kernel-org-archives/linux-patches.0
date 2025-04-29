Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A80211A0B;
	Tue, 29 Apr 2025 17:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946430; cv=none; b=fRUCBcvg1XKQmt0GDmUMNRwS9xWzyv4CqvPJTHdQ6dkEpLDTU8xY7iXnbJkVrobGOzHrIFcBk9Hrcpu8hNBxDVxjkFmUlntXv1SZ/Dg3scAZuZVRLWPK4My/gyzLSabE3gLpS2lZsSoknTW7j8M7odTsINO2KGbhT6uCllAdYAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946430; c=relaxed/simple;
	bh=PNY1mPED5HWJojudthxCYO5GKgvPV7SbtRwp+ldhnBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6tqxpwotf75nVIpXydIYtkjCnzz9uUwBIwDVnciYXLlfC0lDsnIgiXdfgRfcOP0wXsPN/uo5pwEHdeqs/Yp05AclOApEjMb+1y1LhCJTEmDYi0kD2I9ALd4EMkJ2OUODQLk3ka3i6exq6l9l1ObHvogsM1f+DexT9cFK6tBc+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRerBwp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRerBwp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3B8C4CEE3;
	Tue, 29 Apr 2025 17:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946430;
	bh=PNY1mPED5HWJojudthxCYO5GKgvPV7SbtRwp+ldhnBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRerBwp0t5dWKjOfO5WydmWPZDbXIOvxCpFK3D5t/bgWwHWirtyhXcVEhsGLqkgne
	 emhhWGH+2ql7HHfZCFxp8z0p3fzYfwN36Y/CMpf4gg6i2bagQv8rrQ64fspA1NIzKo
	 45V8QV6cyCLnGaX31wuKLqkq/cZlZKtgYGj7Ex/Y=
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
Subject: [PATCH 6.14 265/311] timekeeping: Add a lockdep override in tick_freeze()
Date: Tue, 29 Apr 2025 18:41:42 +0200
Message-ID: <20250429161131.883329566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index a47bcf71defcf..9a3859443c042 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -509,6 +509,7 @@ void tick_resume(void)
 
 #ifdef CONFIG_SUSPEND
 static DEFINE_RAW_SPINLOCK(tick_freeze_lock);
+static DEFINE_WAIT_OVERRIDE_MAP(tick_freeze_map, LD_WAIT_SLEEP);
 static unsigned int tick_freeze_depth;
 
 /**
@@ -528,9 +529,22 @@ void tick_freeze(void)
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
@@ -552,8 +566,16 @@ void tick_unfreeze(void)
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



