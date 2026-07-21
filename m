Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6F746C4A0;
	Tue, 21 Jul 2026 15:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649099; cv=none; b=uYJTYsh7j5bMQgAons6LSgp2k1fmur/Abdl6r2V5Hjaf6FtA/yYQU/Ta8uhMS1esDaW1vjGMSp7T43FC7NdBRKqclvgi6vacQ8fiJcR0EfOPanblC4fGg4r3aB9x5Ymmb7fjYeq+Bw2Wx3py7SeiDLfVgaGCuLrfLvAQH3hynIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649099; c=relaxed/simple;
	bh=ttOG87OVke/TKr4v/rW4iuNdWpc2DRuZo8sr6i17Eac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6bdFe/6uvC3QqAWKNfm9dRyUYQxiWg8UuCRV6LC0u2BntEXQmgnla45Pr8xTQSqWxcvcub5THkz9nctEYO9Q1VweBCsQtUOJkpvQbmfIRdWeKKoHgR3yHANVIx7p/+TvsvJPTGFwln5dyR22gzwlt+LEAlZChGBbZpwcGn9Jrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0Kig2Ot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0Kig2Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2FB1F000E9;
	Tue, 21 Jul 2026 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649097;
	bh=v42+emtvq9vh4Lk7VdZenvdcXb6RXXb9zmU92l7cC4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0Kig2OteAR7LvydL++Z31k2gteplgtqBEKOg9HnXr3wn1LS6dMDV7fRojnLgWUjq
	 tZccBnB4Z02GdQEveFmJdhtq4pXdj+5v64GcSZaU+G4qxtOyWsb8G+xZbG9npYLDqQ
	 nPVDPti77XJeYNE2nCkdv0aeVjq62dSAP511M9k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0447/2077] lockdep/selftests: Restore migrate_disable() state on PREEMPT_RT
Date: Tue, 21 Jul 2026 17:02:00 +0200
Message-ID: <20260721152603.317956558@linuxfoundation.org>
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
index d939403331b5a6..cb806b628352b9 100644
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



