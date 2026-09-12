Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B4B311597;
	Sat, 12 Sep 2026 10:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208650; cv=none; b=hjVP9A78Sqp7EleI+KV0uAhI/pNVNsTxCVeIG59OGKBatYUpVjL/8jbPswwylojZLU1hAaXw1ukMILryeKvbA2uIgN/IMFTeJAMeoavqHJLKURImdjwLivI98xtJuxqTVvegloIRrmoSnsVIkaPgQYw1h/mMHOmJD2TqUhnKtKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208650; c=relaxed/simple;
	bh=YL5+k7ned+2Uih06GBlZkP+kGoV1Qw66YeUe4ZiR//Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wti/IXQT+ZyxGSMoAi7G6h4lV4KnFp62xFzvUy/zn/ZszNCwRHR6eyb04FjmfFjs8ZltMCcyXkf/elPye45M78n/IL2GUBvNPJyx6GAcMOnGVKv4lSVANJi3SKKfhblpYGpJzBr1ESNL7sZM8SXZxj9lwrwuUgWlUg1XPgXa8Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ap6gCG9T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ap6gCG9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF791F000FF;
	Sat, 12 Sep 2026 10:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208649;
	bh=WEblcjs/7O5kElC6ZByfjHslUhWUGStEhbMFqJmumYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ap6gCG9TUxnQrnQXX2zZLkWN2vsFAwoXJ/XwSseqX7cuE6oOmH/lLEfitj9OotrVF
	 T0Q4cH/xfVZGgW90nYVVex3OKGCaC100yZaKui2DRblyuX7heJCPq5eR0mYda6w/Sm
	 xI27+ompPMc8wO9EifTGvVqZ5ZtLBupLZ7UCJhUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Itai Handler <itai.handler@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0661/1518] rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs
Date: Sat, 12 Sep 2026 08:47:10 +0200
Message-ID: <20260912065638.387441139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Itai Handler <itai.handler@gmail.com>

[ Upstream commit 27d73e81195b395270117ff77c47be2ed9b09b12 ]

rcu_all_qs() and rcu_note_context_switch() read/clear the per-CPU
->rcu_urgent_qs and ->rcu_need_heavy_qs flags with plain raw_cpu_read()
and this_cpu_write(), while the RCU core clears them with WRITE_ONCE() in
rcu_disable_urgency_upon_qs().  KCSAN flags the resulting same-CPU race:

  BUG: KCSAN: data-race in rcu_all_qs / rcu_disable_urgency_upon_qs

It is benign -- the flags are advisory and rcu_all_qs() re-reads
->rcu_urgent_qs with smp_load_acquire() before acting on it -- but these
are the last unmarked accesses to the two flags; every other access
already uses READ_ONCE()/WRITE_ONCE()/smp_*.  Mark them to match.  No
functional change.

Reproduced on a PREEMPT_NONE, CONFIG_KCSAN_INTERRUPT_WATCHER=y kernel with
a pthreads program whose threads (two per CPU) loop reading a large file:

	for (;;) {
		int fd = open("/proc/kallsyms", O_RDONLY);
		while (read(fd, buf, sizeof(buf)) > 0)
			;
		close(fd);
	}

The read()s drive cond_resched() -> rcu_all_qs() while the busy CPUs keep
the grace period urgent, so the RCU core clears the flags concurrently.

Fixes: 2dba13f0b6c2 ("rcu: Switch urgent quiescent-state requests to rcu_data structure")
Signed-off-by: Itai Handler <itai.handler@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cafb1cc8eff84..41e32b015a64e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -973,7 +973,7 @@ void rcu_all_qs(void)
 {
 	unsigned long flags;
 
-	if (!raw_cpu_read(rcu_data.rcu_urgent_qs))
+	if (!READ_ONCE(*raw_cpu_ptr(&rcu_data.rcu_urgent_qs)))
 		return;
 	preempt_disable();  // For CONFIG_PREEMPT_COUNT=y kernels
 	/* Load rcu_urgent_qs before other flags. */
@@ -981,8 +981,8 @@ void rcu_all_qs(void)
 		preempt_enable();
 		return;
 	}
-	this_cpu_write(rcu_data.rcu_urgent_qs, false);
-	if (unlikely(raw_cpu_read(rcu_data.rcu_need_heavy_qs))) {
+	WRITE_ONCE(*this_cpu_ptr(&rcu_data.rcu_urgent_qs), false);
+	if (unlikely(READ_ONCE(*this_cpu_ptr(&rcu_data.rcu_need_heavy_qs)))) {
 		local_irq_save(flags);
 		rcu_momentary_eqs();
 		local_irq_restore(flags);
@@ -1002,8 +1002,8 @@ void rcu_note_context_switch(bool preempt)
 	/* Load rcu_urgent_qs before other flags. */
 	if (!smp_load_acquire(this_cpu_ptr(&rcu_data.rcu_urgent_qs)))
 		goto out;
-	this_cpu_write(rcu_data.rcu_urgent_qs, false);
-	if (unlikely(raw_cpu_read(rcu_data.rcu_need_heavy_qs)))
+	WRITE_ONCE(*this_cpu_ptr(&rcu_data.rcu_urgent_qs), false);
+	if (unlikely(READ_ONCE(*this_cpu_ptr(&rcu_data.rcu_need_heavy_qs))))
 		rcu_momentary_eqs();
 out:
 	rcu_tasks_qs(current, preempt);
-- 
2.53.0



