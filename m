Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00307168C4;
	Mon, 27 May 2024 19:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837707; cv=none; b=ldIGXSCbkmKov8+Zn6yOiu3W6q6vVtk/dNiY1c3ttNtDSpeNL9sdIjCMiewePmpViIlRy8HbSCTrc0LQqlUD8KW2iKVhZZZQpK4VenLSx2z+42uREIKTQXgBl+Vj+uuzdw7k5iopMY7IZN8ZWqs8CbQ/xuSCJqgPuCISY5HzRPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837707; c=relaxed/simple;
	bh=8uz+mlROood/AlvE9hIdBceAkrooh3V/jg8OfucOzdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPpjaXUTcoRdzJ7mnwW3O4EQY8pp/hdbggiKmiS8Ie/hP7St1tr5DppLNWVYOETOJRn7vq/j4P4nKkrqtRGf0Dn3Liojf9K57QNFg/bYqdB3xDimOD4XYrD85vdExrf93rAiMmMFLngPoTWSyT6wJ9CQLZidJGLRfUNV/3LZ4/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKvro6Es; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKvro6Es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D60BC2BBFC;
	Mon, 27 May 2024 19:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837706;
	bh=8uz+mlROood/AlvE9hIdBceAkrooh3V/jg8OfucOzdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKvro6EsHCXQ03mQloV/iMUqWs+t/yAMRycoUFf3uXm4F7/6osCKPb9rxSlVivOuI
	 5yIu2Hn2+xwUAwWF8LIoGOXJvSXU7ZIRsLrr/fWRKw9zgw0ZQM2yLFc1xm0s+JWz6+
	 rQJsbzCm2CPGbfpOvhgUs6B/sqOq3o4K9U/UhBDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dce04ed6d1438ad69656@syzkaller.appspotmail.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 086/493] softirq: Fix suspicious RCU usage in __do_softirq()
Date: Mon, 27 May 2024 20:51:28 +0200
Message-ID: <20240527185633.135157229@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit 1dd1eff161bd55968d3d46bc36def62d71fb4785 ]

Currently, the condition "__this_cpu_read(ksoftirqd) == current" is used to
invoke rcu_softirq_qs() in ksoftirqd tasks context for non-RT kernels.

This works correctly as long as the context is actually task context but
this condition is wrong when:

     - the current task is ksoftirqd
     - the task is interrupted in a RCU read side critical section
     - __do_softirq() is invoked on return from interrupt

Syzkaller triggered the following scenario:

  -> finish_task_switch()
    -> put_task_struct_rcu_user()
      -> call_rcu(&task->rcu, delayed_put_task_struct)
        -> __kasan_record_aux_stack()
          -> pfn_valid()
            -> rcu_read_lock_sched()
              <interrupt>
                __irq_exit_rcu()
                -> __do_softirq)()
                   -> if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
                     __this_cpu_read(ksoftirqd) == current)
                     -> rcu_softirq_qs()
                       -> RCU_LOCKDEP_WARN(lock_is_held(&rcu_sched_lock_map))

The rcu quiescent state is reported in the rcu-read critical section, so
the lockdep warning is triggered.

Fix this by splitting out the inner working of __do_softirq() into a helper
function which takes an argument to distinguish between ksoftirqd task
context and interrupted context and invoke it from the relevant call sites
with the proper context information and use that for the conditional
invocation of rcu_softirq_qs().

Reported-by: syzbot+dce04ed6d1438ad69656@syzkaller.appspotmail.com
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240427102808.29356-1-qiang.zhang1211@gmail.com
Link: https://lore.kernel.org/lkml/8f281a10-b85a-4586-9586-5bbc12dc784f@paulmck-laptop/T/#mea8aba4abfcb97bbf499d169ce7f30c4cff1b0e3
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/softirq.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 210cf5f8d92c2..bd9716d7bb638 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -507,7 +507,7 @@ static inline bool lockdep_softirq_start(void) { return false; }
 static inline void lockdep_softirq_end(bool in_hardirq) { }
 #endif
 
-asmlinkage __visible void __softirq_entry __do_softirq(void)
+static void handle_softirqs(bool ksirqd)
 {
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
 	unsigned long old_flags = current->flags;
@@ -562,8 +562,7 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 		pending >>= softirq_bit;
 	}
 
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
-	    __this_cpu_read(ksoftirqd) == current)
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && ksirqd)
 		rcu_softirq_qs();
 
 	local_irq_disable();
@@ -583,6 +582,11 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 	current_restore_flags(old_flags, PF_MEMALLOC);
 }
 
+asmlinkage __visible void __softirq_entry __do_softirq(void)
+{
+	handle_softirqs(false);
+}
+
 /**
  * irq_enter_rcu - Enter an interrupt context with RCU watching
  */
@@ -918,7 +922,7 @@ static void run_ksoftirqd(unsigned int cpu)
 		 * We can safely run softirq on inline stack, as we are not deep
 		 * in the task stack here.
 		 */
-		__do_softirq();
+		handle_softirqs(true);
 		ksoftirqd_run_end();
 		cond_resched();
 		return;
-- 
2.43.0



