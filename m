Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FA11C461D;
	Tue, 27 Aug 2024 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770992; cv=none; b=Jyj5b+I/DE/Xy9iFVwOn2xnORiBcOy4RgVBNKFN3thC+x35qWqjHIc7fuzIwuLR8px7putG15F0BC96ln3OrAtm9YE+s+yheZke5v88UDvn24GmcQ7FXd5mZ6edV+tJUOcB9fG4uFz2Uen3QlYQjxIXXTQ6eNOtnDNJiYKnVCeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770992; c=relaxed/simple;
	bh=5yax7yNoXJqXPxjJ+8DlZkcKk2hqj8mevbINnZj9sgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyJLYd0OmCMTOM7F9a9yKdyRWzHQGwF7RzsnHlhyb/ETSWv8yQGkLfHNB0CYryDdVbPmEkixG0j5Tcaz8eUZCMUxLz6afH6PwsOZ5pbhX/jV7L44cxxsxvQo/hcJQBySk6WJ4DiP79JX5DbUvtNkcpu2QTNxmqYZS+lFwmZuQ9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8B6M+Hc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8B6M+Hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87785C61049;
	Tue, 27 Aug 2024 15:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770992;
	bh=5yax7yNoXJqXPxjJ+8DlZkcKk2hqj8mevbINnZj9sgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8B6M+HcXTgvtCSatE7AZyLHq27GO7hcSDtQd07TROyitk9a1zPpNKQWN9EM3Gq9v
	 F8067mtilJ24IYNiR0bG/xissNFSIj3L8GTi7aMGYSI4jQLBMoPs0OJYgFNwfqiE/Y
	 xDsXr/BOpj2/hxBmz9s56O1AgRfvEsmkHlIyDjRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Len Brown <len.brown@intel.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 054/273] mm/memory-failure: use raw_spinlock_t in struct memory_failure_cpu
Date: Tue, 27 Aug 2024 16:36:18 +0200
Message-ID: <20240827143835.457067906@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

commit d75abd0d0bc29e6ebfebbf76d11b4067b35844af upstream.

The memory_failure_cpu structure is a per-cpu structure.  Access to its
content requires the use of get_cpu_var() to lock in the current CPU and
disable preemption.  The use of a regular spinlock_t for locking purpose
is fine for a non-RT kernel.

Since the integration of RT spinlock support into the v5.15 kernel, a
spinlock_t in a RT kernel becomes a sleeping lock and taking a sleeping
lock in a preemption disabled context is illegal resulting in the
following kind of warning.

  [12135.732244] BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
  [12135.732248] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 270076, name: kworker/0:0
  [12135.732252] preempt_count: 1, expected: 0
  [12135.732255] RCU nest depth: 2, expected: 2
    :
  [12135.732420] Hardware name: Dell Inc. PowerEdge R640/0HG0J8, BIOS 2.10.2 02/24/2021
  [12135.732423] Workqueue: kacpi_notify acpi_os_execute_deferred
  [12135.732433] Call Trace:
  [12135.732436]  <TASK>
  [12135.732450]  dump_stack_lvl+0x57/0x81
  [12135.732461]  __might_resched.cold+0xf4/0x12f
  [12135.732479]  rt_spin_lock+0x4c/0x100
  [12135.732491]  memory_failure_queue+0x40/0xe0
  [12135.732503]  ghes_do_memory_failure+0x53/0x390
  [12135.732516]  ghes_do_proc.constprop.0+0x229/0x3e0
  [12135.732575]  ghes_proc+0xf9/0x1a0
  [12135.732591]  ghes_notify_hed+0x6a/0x150
  [12135.732602]  notifier_call_chain+0x43/0xb0
  [12135.732626]  blocking_notifier_call_chain+0x43/0x60
  [12135.732637]  acpi_ev_notify_dispatch+0x47/0x70
  [12135.732648]  acpi_os_execute_deferred+0x13/0x20
  [12135.732654]  process_one_work+0x41f/0x500
  [12135.732695]  worker_thread+0x192/0x360
  [12135.732715]  kthread+0x111/0x140
  [12135.732733]  ret_from_fork+0x29/0x50
  [12135.732779]  </TASK>

Fix it by using a raw_spinlock_t for locking instead.

Also move the pr_err() out of the lock critical section and after
put_cpu_ptr() to avoid indeterminate latency and the possibility of sleep
with this call.

[longman@redhat.com: don't hold percpu ref across pr_err(), per Miaohe]
  Link: https://lkml.kernel.org/r/20240807181130.1122660-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20240806164107.1044956-1-longman@redhat.com
Fixes: 0f383b6dc96e ("locking/spinlock: Provide RT variant")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2406,7 +2406,7 @@ struct memory_failure_entry {
 struct memory_failure_cpu {
 	DECLARE_KFIFO(fifo, struct memory_failure_entry,
 		      MEMORY_FAILURE_FIFO_SIZE);
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	struct work_struct work;
 };
 
@@ -2432,20 +2432,22 @@ void memory_failure_queue(unsigned long
 {
 	struct memory_failure_cpu *mf_cpu;
 	unsigned long proc_flags;
+	bool buffer_overflow;
 	struct memory_failure_entry entry = {
 		.pfn =		pfn,
 		.flags =	flags,
 	};
 
 	mf_cpu = &get_cpu_var(memory_failure_cpu);
-	spin_lock_irqsave(&mf_cpu->lock, proc_flags);
-	if (kfifo_put(&mf_cpu->fifo, entry))
+	raw_spin_lock_irqsave(&mf_cpu->lock, proc_flags);
+	buffer_overflow = !kfifo_put(&mf_cpu->fifo, entry);
+	if (!buffer_overflow)
 		schedule_work_on(smp_processor_id(), &mf_cpu->work);
-	else
+	raw_spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
+	put_cpu_var(memory_failure_cpu);
+	if (buffer_overflow)
 		pr_err("buffer overflow when queuing memory failure at %#lx\n",
 		       pfn);
-	spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
-	put_cpu_var(memory_failure_cpu);
 }
 EXPORT_SYMBOL_GPL(memory_failure_queue);
 
@@ -2458,9 +2460,9 @@ static void memory_failure_work_func(str
 
 	mf_cpu = container_of(work, struct memory_failure_cpu, work);
 	for (;;) {
-		spin_lock_irqsave(&mf_cpu->lock, proc_flags);
+		raw_spin_lock_irqsave(&mf_cpu->lock, proc_flags);
 		gotten = kfifo_get(&mf_cpu->fifo, &entry);
-		spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
+		raw_spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
 		if (!gotten)
 			break;
 		if (entry.flags & MF_SOFT_OFFLINE)
@@ -2490,7 +2492,7 @@ static int __init memory_failure_init(vo
 
 	for_each_possible_cpu(cpu) {
 		mf_cpu = &per_cpu(memory_failure_cpu, cpu);
-		spin_lock_init(&mf_cpu->lock);
+		raw_spin_lock_init(&mf_cpu->lock);
 		INIT_KFIFO(mf_cpu->fifo);
 		INIT_WORK(&mf_cpu->work, memory_failure_work_func);
 	}


