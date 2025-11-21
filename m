Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9323E2745E;
	Fri, 21 Nov 2025 13:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731829; cv=none; b=ELysCarG4nYMtrFGDh+Lceq1SNk+iauZ+Pl2r5+C31VtINPXz0GNt0VAk+PISiMT8VvmbKqdfvpDQkt11ZhEsSzyCTrjtTENMPs9wUjybeSJSegs4dVX+2BG1805tVqqwwDF2hny8dx7Y5mnczpL444JKUJhkSfU2wv49foH7fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731829; c=relaxed/simple;
	bh=TFxfTH+2U6FvZpFC8JAyiSsLVQ90u1ImHQf56bd7qX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vf/KPXLSyO3aAG081++5ltUfEBVdagLjMAf41MfjZGIpC93ihFOXy4uMHJQtZfhVlcyCUQ1SaNMnhV4cqd1Dzb2dQpXzenyg6L8vprih6EvDFD5WCf0v9nRr3hIpgxerD5SjaaiBSMO7By0Rb3H18qNmYKEZKuphjxG8h99h83c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrOTzi16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrOTzi16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBEAC4CEF1;
	Fri, 21 Nov 2025 13:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731829;
	bh=TFxfTH+2U6FvZpFC8JAyiSsLVQ90u1ImHQf56bd7qX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrOTzi164wCvP3fWQKAKhkxY2gncVtvIGFep10t0zw4dLzXWnCKDJSFKvwalRg2cu
	 hNmWn0+RbraswQmeGWMvxZjjqHzuB8AzvwzEUUmybwWwW0j12hFsEyR6wp+qfrgca9
	 S4wzyAxUh1fydiuSasgki1pP5jhwj3xI+ICaACY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/185] sched_ext: Fix unsafe locking in the scx_dump_state()
Date: Fri, 21 Nov 2025 14:12:03 +0100
Message-ID: <20251121130147.331728530@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang@linux.dev>

[ Upstream commit 5f02151c411dda46efcc5dc57b0845efcdcfc26d ]

For built with CONFIG_PREEMPT_RT=y kernels, the dump_lock will be converted
sleepable spinlock and not disable-irq, so the following scenarios occur:

inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
irq_work/0/27 [HC0[0]:SC0[0]:HE1:SE1] takes:
(&rq->__lock){?...}-{2:2}, at: raw_spin_rq_lock_nested+0x2b/0x40
{IN-HARDIRQ-W} state was registered at:
   lock_acquire+0x1e1/0x510
   _raw_spin_lock_nested+0x42/0x80
   raw_spin_rq_lock_nested+0x2b/0x40
   sched_tick+0xae/0x7b0
   update_process_times+0x14c/0x1b0
   tick_periodic+0x62/0x1f0
   tick_handle_periodic+0x48/0xf0
   timer_interrupt+0x55/0x80
   __handle_irq_event_percpu+0x20a/0x5c0
   handle_irq_event_percpu+0x18/0xc0
   handle_irq_event+0xb5/0x150
   handle_level_irq+0x220/0x460
   __common_interrupt+0xa2/0x1e0
   common_interrupt+0xb0/0xd0
   asm_common_interrupt+0x2b/0x40
   _raw_spin_unlock_irqrestore+0x45/0x80
   __setup_irq+0xc34/0x1a30
   request_threaded_irq+0x214/0x2f0
   hpet_time_init+0x3e/0x60
   x86_late_time_init+0x5b/0xb0
   start_kernel+0x308/0x410
   x86_64_start_reservations+0x1c/0x30
   x86_64_start_kernel+0x96/0xa0
   common_startup_64+0x13e/0x148

 other info that might help us debug this:
 Possible unsafe locking scenario:

        CPU0
        ----
   lock(&rq->__lock);
   <Interrupt>
     lock(&rq->__lock);

  *** DEADLOCK ***

 stack backtrace:
 CPU: 0 UID: 0 PID: 27 Comm: irq_work/0
 Call Trace:
  <TASK>
  dump_stack_lvl+0x8c/0xd0
  dump_stack+0x14/0x20
  print_usage_bug+0x42e/0x690
  mark_lock.part.44+0x867/0xa70
  ? __pfx_mark_lock.part.44+0x10/0x10
  ? string_nocheck+0x19c/0x310
  ? number+0x739/0x9f0
  ? __pfx_string_nocheck+0x10/0x10
  ? __pfx_check_pointer+0x10/0x10
  ? kvm_sched_clock_read+0x15/0x30
  ? sched_clock_noinstr+0xd/0x20
  ? local_clock_noinstr+0x1c/0xe0
  __lock_acquire+0xc4b/0x62b0
  ? __pfx_format_decode+0x10/0x10
  ? __pfx_string+0x10/0x10
  ? __pfx___lock_acquire+0x10/0x10
  ? __pfx_vsnprintf+0x10/0x10
  lock_acquire+0x1e1/0x510
  ? raw_spin_rq_lock_nested+0x2b/0x40
  ? __pfx_lock_acquire+0x10/0x10
  ? dump_line+0x12e/0x270
  ? raw_spin_rq_lock_nested+0x20/0x40
  _raw_spin_lock_nested+0x42/0x80
  ? raw_spin_rq_lock_nested+0x2b/0x40
  raw_spin_rq_lock_nested+0x2b/0x40
  scx_dump_state+0x3b3/0x1270
  ? finish_task_switch+0x27e/0x840
  scx_ops_error_irq_workfn+0x67/0x80
  irq_work_single+0x113/0x260
  irq_work_run_list.part.3+0x44/0x70
  run_irq_workd+0x6b/0x90
  ? __pfx_run_irq_workd+0x10/0x10
  smpboot_thread_fn+0x529/0x870
  ? __pfx_smpboot_thread_fn+0x10/0x10
  kthread+0x305/0x3f0
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x40/0x70
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>

This commit therefore use rq_lock_irqsave/irqrestore() to replace
rq_lock/unlock() in the scx_dump_state().

Fixes: 07814a9439a3 ("sched_ext: Print debug dump after an error exit")
Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index be2e836e10e93..ad1d438b3085c 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4966,7 +4966,7 @@ static void scx_dump_state(struct scx_exit_info *ei, size_t dump_len)
 		size_t avail, used;
 		bool idle;
 
-		rq_lock(rq, &rf);
+		rq_lock_irqsave(rq, &rf);
 
 		idle = list_empty(&rq->scx.runnable_list) &&
 			rq->curr->sched_class == &idle_sched_class;
@@ -5034,7 +5034,7 @@ static void scx_dump_state(struct scx_exit_info *ei, size_t dump_len)
 		list_for_each_entry(p, &rq->scx.runnable_list, scx.runnable_node)
 			scx_dump_task(&s, &dctx, p, ' ');
 	next:
-		rq_unlock(rq, &rf);
+		rq_unlock_irqrestore(rq, &rf);
 	}
 
 	if (seq_buf_has_overflowed(&s) && dump_len >= sizeof(trunc_marker))
-- 
2.51.0



