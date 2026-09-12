Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824ED5475F;
	Sat, 12 Sep 2026 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224178; cv=none; b=BWkROcHG1eIZywLnt1EIfNkhk2RNGHBztH7Fzj0LauzKuhKf+CleuMgVf9chnrE7SLSbZup4PRRFDuwCoSRVfA/tvj3CapjMweiVC95Vg53BQ8XrmFlACMeVj+S1L+/j4IfphS5B1GWNby+ZDBhZsHDb+oWHZ0mcxjxxOxQ7LMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224178; c=relaxed/simple;
	bh=E0ZLLfZ/09yQ9dNogDxXkX13i0N5tvWnUzVilPq+yJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bq8ii21hP6u0361QEGp4/bo1NcqBqR3gKLOhKjwj3wlmjoDneW0w1MJEmLwIqvRhUAlmADfyEo1bifZViprX6hpSLQ6PJjHzWsoric3Ha1kqFRAqINArp7BIm+/qrUyzmrwHjMWn7mLPh8hKRwiQ7dy+QKFWU/5OW0JmzrbbzI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyvckHei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyvckHei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557751F000FF;
	Sat, 12 Sep 2026 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224177;
	bh=T6014F/vQMaXj2cSV0AEeamNmnp2kwxLF3aAg6qhOHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyvckHeiOznbCioHbiuEPRQ2ePzqP8BPrl9qm7q54RmNbNaxByuDmMVZTWH79gB7K
	 /grJF/5A6qkJzvpWd6O6icSIIrN32xmidO/gRO7oCh2n3pH2ar+QsFK3m3Q12RolY9
	 68ddy0BseLBcyDWIP5AUhdif/745TF0bOwxT0d6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Itai Handler <itai.handler@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0939/1424] rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs
Date: Sat, 12 Sep 2026 08:56:11 +0200
Message-ID: <20260912065628.349934589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 8e8b44edcc97a..db59f4a0d26e6 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -962,7 +962,7 @@ void rcu_all_qs(void)
 {
 	unsigned long flags;
 
-	if (!raw_cpu_read(rcu_data.rcu_urgent_qs))
+	if (!READ_ONCE(*raw_cpu_ptr(&rcu_data.rcu_urgent_qs)))
 		return;
 	preempt_disable();  // For CONFIG_PREEMPT_COUNT=y kernels
 	/* Load rcu_urgent_qs before other flags. */
@@ -970,8 +970,8 @@ void rcu_all_qs(void)
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
@@ -991,8 +991,8 @@ void rcu_note_context_switch(bool preempt)
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



