Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FA4369990;
	Sat, 12 Sep 2026 08:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200590; cv=none; b=inl/vukehEXNmx/yMKuWSK6NVzNk195SYnNGhwbfVGKlun1Qlx5tG+uEEGcr1+glTlYTxHM57L32hlWO1wRTM/RT9Vf7JRtgABGYL2mP716B96WerzupKnfjvyh3HwCLM6YOSCcKY35E82BWxWiL+BslBzv4diLeoFFiJnGUID4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200590; c=relaxed/simple;
	bh=8n0nii7PJ5kRE9EYtp9iCQJsJUX9CRM/0KaMq43/AGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUcEYePARh/icW02KUS/3iVYGBszP9b1NBeMpfXasrwBAfNqpOrdABhPLru9Zn3dzWug0zAX8bcduq7bpsMsggZlaMhuiblIjGX+1JhykhZFWeoHVGlBog/jW8GWEk+pKuSia4pTGEFLO95IKX7vCyctOJb5WNic2ECDd3kes80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm9fOzbk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm9fOzbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C351F000FF;
	Sat, 12 Sep 2026 08:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200589;
	bh=HNAbvN8CLQjLIQgGUr8bHUxak3HX05wxsIkoo/c1ax8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm9fOzbkO4WkyInTRHG4DjazfFV3evSckq21Dyef+qNzhQzrDUlXAoQltsfw7OB0g
	 TZMKRjOeLbIBHrXdhaHpzZjFiEoQDwxXbMsL7aOVcEFWzp4FmqGM7kpj54kmy8wOfO
	 5u7gD546Dy5s74UgoilWlW8xbFLfZpX5nckYMLug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Itai Handler <itai.handler@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0778/1815] rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs
Date: Sat, 12 Sep 2026 08:42:08 +0200
Message-ID: <20260912065707.173065974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 95ad967adcf3c..608f732866476 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -970,7 +970,7 @@ void rcu_all_qs(void)
 {
 	unsigned long flags;
 
-	if (!raw_cpu_read(rcu_data.rcu_urgent_qs))
+	if (!READ_ONCE(*raw_cpu_ptr(&rcu_data.rcu_urgent_qs)))
 		return;
 	preempt_disable();  // For CONFIG_PREEMPT_COUNT=y kernels
 	/* Load rcu_urgent_qs before other flags. */
@@ -978,8 +978,8 @@ void rcu_all_qs(void)
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
@@ -999,8 +999,8 @@ void rcu_note_context_switch(bool preempt)
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



