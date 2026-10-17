Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E30035E93B;
	Sat, 17 Oct 2026 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260458; cv=none; b=KX0MjKBSf6DooJ2JhUxKH1sFBPsGDC9tZlrfRxuBN/2yaEZCFy4OxdsDk0x0diVvGuEv0zw+zWkiti2UfCw6P6n826uJWWrROrIsakuJf2F3AJxdA53pLKIFbhoujna7AxwXy6MD2kRPyDcvsGLCIeHbFce06jum6yzBS7WU8e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260458; c=relaxed/simple;
	bh=h2kqyl+lV0zpOfue0BFth/FgIkxc/lHd3mL2APUZDT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYIhsWyr2zY5/tKLHHR6JDPfgjJ85Ma1K+wdjaV35E/ridqs+1B7wwB/QYZdl1msnrotPDs80WqXTdiMSCC2a/iEVE9jiVAjT0oyuhjfpqvcgVtDFSkTu1704zIfB42pGje06J8Et8dV/Xat/5MmBveJ+ABemi8L2l4rnwPb+3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I845K1EZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I845K1EZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8151F000C4;
	Sat, 17 Oct 2026 18:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260456;
	bh=GXYg7WKDPrzpA1n9/P/bsAmJwIvWi7svj6weWOLHXG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I845K1EZOhvxmIYB1zFhcW83Y4Gva2+v1857wk48jm6asFC/nkOz671CF+CBEdxVZ
	 bLM9GC6EXJBUpM245dSZUw9sVijGNbGgEcTCaC3VENtaXs9hyHw1a/9ul7aIZttyJJ
	 WS/2wsIfYup/HQMaoByRlFcWLjU34K+5WqIYRObE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1552/1674] net: mscc: ocelot: Fix use-after-free caused by cyclic delayed work
Date: Sat, 17 Oct 2026 18:03:44 +0200
Message-ID: <20261017160510.939671917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit bc9ea787079671cb19a8b25ff9f02be5ef6bfcf5 ]

The origin code calls cancel_delayed_work() in ocelot_stats_deinit()
to cancel the cyclic delayed work item ocelot->stats_work. However,
cancel_delayed_work() may fail to cancel the work item if it is already
executing. While destroy_workqueue() does wait for all pending work items
in the work queue to complete before destroying the work queue, it cannot
prevent the delayed work item from being rescheduled within the
ocelot_check_stats_work() function. This limitation exists because the
delayed work item is only enqueued into the work queue after its timer
expires. Before the timer expiration, destroy_workqueue() has no visibility
of this pending work item. Once the work queue appears empty,
destroy_workqueue() proceeds with destruction. When the timer eventually
expires, the delayed work item gets queued again, leading to the following
warning:

workqueue: cannot queue ocelot_check_stats_work on wq ocelot-switch-stats
WARNING: CPU: 2 PID: 0 at kernel/workqueue.c:2255 __queue_work+0x875/0xaf0
...
RIP: 0010:__queue_work+0x875/0xaf0
...
RSP: 0018:ffff88806d108b10 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000101 RCX: 0000000000000027
RDX: 0000000000000027 RSI: 0000000000000004 RDI: ffff88806d123e88
RBP: ffffffff813c3170 R08: 0000000000000000 R09: ffffed100da247d2
R10: ffffed100da247d1 R11: ffff88806d123e8b R12: ffff88800c00f000
R13: ffff88800d7285c0 R14: ffff88806d0a5580 R15: ffff88800d7285a0
FS:  0000000000000000(0000) GS:ffff8880e5725000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe18e45ea10 CR3: 0000000005e6c000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 ? kasan_report+0xc6/0xf0
 ? __pfx_delayed_work_timer_fn+0x10/0x10
 ? __pfx_delayed_work_timer_fn+0x10/0x10
 call_timer_fn+0x25/0x1c0
 __run_timer_base.part.0+0x3be/0x8c0
 ? __pfx_delayed_work_timer_fn+0x10/0x10
 ? rcu_sched_clock_irq+0xb06/0x27d0
 ? __pfx___run_timer_base.part.0+0x10/0x10
 ? try_to_wake_up+0xb15/0x1960
 ? _raw_spin_lock_irq+0x80/0xe0
 ? __pfx__raw_spin_lock_irq+0x10/0x10
 tmigr_handle_remote_up+0x603/0x7e0
 ? __pfx_tmigr_handle_remote_up+0x10/0x10
 ? sched_balance_trigger+0x1c0/0x9f0
 ? sched_tick+0x221/0x5a0
 ? _raw_spin_lock_irq+0x80/0xe0
 ? __pfx__raw_spin_lock_irq+0x10/0x10
 ? tick_nohz_handler+0x339/0x440
 ? __pfx_tmigr_handle_remote_up+0x10/0x10
 __walk_groups.isra.0+0x42/0x150
 tmigr_handle_remote+0x1f4/0x2e0
 ? __pfx_tmigr_handle_remote+0x10/0x10
 ? ktime_get+0x60/0x140
 ? lapic_next_event+0x11/0x20
 ? clockevents_program_event+0x1d4/0x2a0
 ? hrtimer_interrupt+0x322/0x780
 handle_softirqs+0x16a/0x550
 irq_exit_rcu+0xaf/0xe0
 sysvec_apic_timer_interrupt+0x70/0x80
 </IRQ>
...

The following diagram reveals the cause of the above warning:

CPU 0 (remove)             | CPU 1 (delayed work callback)
mscc_ocelot_remove()       |
  ocelot_deinit()          | ocelot_check_stats_work()
    ocelot_stats_deinit()  |
      cancel_delayed_work()|   ...
                           |   queue_delayed_work()
      destroy_workqueue()  | (wait a time)
                           | __queue_work() //UAF

The above scenario actually constitutes a UAF vulnerability.

The ocelot_stats_deinit() is only invoked when initialization
failure or resource destruction, so we must ensure that any
delayed work items cannot be rescheduled.

Replace cancel_delayed_work() with disable_delayed_work_sync()
to guarantee proper cancellation of the delayed work item and
ensure completion of any currently executing work before the
workqueue is deallocated.

A deadlock concern was considered: ocelot_stats_deinit() is called
in a process context and is not holding any locks that the delayed
work item might also need. Therefore, the use of the _sync() variant
is safe here.

This bug was identified through static analysis. To reproduce the
issue and validate the fix, I simulated ocelot-switch device by
writing a kernel module and prepared the necessary resources for
the virtual ocelot-switch device's probe process. Then, removing
the virtual device will trigger the mscc_ocelot_remove() function,
which in turn destroys the workqueue.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20251001011149.55073-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index c018783757fb2..8dff857b0536d 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -984,6 +984,6 @@ int ocelot_stats_init(struct ocelot *ocelot)
 
 void ocelot_stats_deinit(struct ocelot *ocelot)
 {
-	cancel_delayed_work(&ocelot->stats_work);
+	cancel_delayed_work_sync(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 }
-- 
2.53.0



