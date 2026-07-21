Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9919F415F15;
	Tue, 21 Jul 2026 17:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656266; cv=none; b=SvJh3O4qJ5CdCZW7X6mRWms0DSCbGFqg0A0G/ZCQMgyzNsbeP9RN5bFSXKiWdELXr/zvpTwHU8jC1GLwqAKwbu114kH+qWBSqChQbr0sqqwNJQEANr3fITmnb2XaYnSNjcb23FDTCKGBKGXeBDb4jt975dn1fuq4kL9/Nsd7YIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656266; c=relaxed/simple;
	bh=kJVmyS5G2DV5KeXRnzykrtB3oqI+lT9AdassfKW3m+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dh/F3GhvhFeRz27BA7ohDKyIKgJ3aw+UQpi96d+GJUV/IitltHGSpImCfi7MYwlZ0uDoyDOLeDO6x86V35661zU8BNU3jFxPApYhiuTowVGEHhlMxq9EHvBDUndLRf7fJiZa9B7EPMA7CV3oVO271K74JNW/g7GV9+vAMQXujMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GA/Av03O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GA/Av03O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD571F00A3A;
	Tue, 21 Jul 2026 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656265;
	bh=p0tquU0hDfFYeJHaXxLFMT1J5cyorZa+dhyca1K1e2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GA/Av03ODhRfllVzbkvy64/mNgk2KeaxoZAf06pHSh0veHAOrntOm8dV3EzGccmty
	 Y+XXq8vXdkptNwLE5FH4Cvvd2OiLsiwB57Jmxa1d89sVHuTQyR2xL1aqNpHbNWBwEk
	 /0nqLq8QOuANhFo1drBHn37b/u4C0ZO30NSw2/EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0320/1611] lockdep/selftests: Restore migrate_disable() state on PREEMPT_RT
Date: Tue, 21 Jul 2026 17:07:16 +0200
Message-ID: <20260721152522.280988394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit d8c897b20bf4d4cbb1e935a8ceb666bcc0f82580 ]

The lockdep selftests deliberately run unbalanced locking patterns.
dotest() restores the task state they leave behind before running the
next testcase.

On PREEMPT_RT, spin_lock() uses migrate_disable() instead of disabling
preemption. dotest() cleans up the resulting migration-disabled state, but
that cleanup is still guarded by CONFIG_SMP.

That used to match the scheduler data model, where migration_disabled was
also CONFIG_SMP-only. The commit referenced below made SMP scheduler state
unconditional, so CONFIG_SMP=n PREEMPT_RT kernels with
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y report success from the selftests and
then trip over stale current->migration_disabled state:

  releasing a pinned lock
  bad: scheduling from the idle thread!
  Kernel panic - not syncing: Fatal exception

Save and restore current->migration_disabled for every PREEMPT_RT build.

Fixes: cac5cefbade9 ("sched/smp: Make SMP unconditional")
Assisted-by: Codex:gpt-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260523185123.17482-2-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/locking-selftest.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index ed99344317f50d..7605a0da4eb613 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -1431,9 +1431,7 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 {
 	int saved_preempt_count = preempt_count();
 #ifdef CONFIG_PREEMPT_RT
-#ifdef CONFIG_SMP
 	int saved_mgd_count = current->migration_disabled;
-#endif
 	int saved_rcu_count = current->rcu_read_lock_nesting;
 #endif
 
@@ -1471,10 +1469,8 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	preempt_count_set(saved_preempt_count);
 
 #ifdef CONFIG_PREEMPT_RT
-#ifdef CONFIG_SMP
 	while (current->migration_disabled > saved_mgd_count)
 		migrate_enable();
-#endif
 
 	while (current->rcu_read_lock_nesting > saved_rcu_count)
 		rcu_read_unlock();
-- 
2.53.0



