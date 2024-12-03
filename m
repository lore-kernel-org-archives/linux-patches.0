Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF4C1F75BB;
	Tue,  3 Dec 2024 15:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240313; cv=none; b=Etcvudn1pp3hxrQz2ogs2Ay9Z6By5UnZUO8sGpnJz04fgBsjnn/m3mstRyNqvLspWOmAUjc+gsU/JAmIamdDnILosGL/YOtdTclFohnH0WV9krz+esfh1ZQUKnJBBwHSRgRXv/gW8NAVsvOk864D9yn3QrhvTVGWZwnEvMsDmHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240313; c=relaxed/simple;
	bh=4DIpyHLrIopycnD9+37sgoDdeWdXB3/8F95KOpHKKl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o37gNi1DMPRAjIeyLq9qg0Zv4vLNu8hwyncAWrj3Bt7VAorYNZszHGN9ofONhXPW5O4cG0u9UvfmpLrQzofCei2UzFi4tX4Fk3blLMZDOGcuMBycCfrqbJdsF3KFZLq6jm83y7ErzxpmlCm1RLvWWpxK3C0t/gPdbxqFjHSdMW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvUWjE77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvUWjE77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5B8C4CECF;
	Tue,  3 Dec 2024 15:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240312;
	bh=4DIpyHLrIopycnD9+37sgoDdeWdXB3/8F95KOpHKKl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvUWjE77pT2fvGvgk3hPUACUywu6NxGpKJc2gBkBFm9FY79l2uq2hOHv5m/e5/beJ
	 9Ca06nxWhYXXSLK9ePcMHV+2864KTBd02ZSeo3cQOUB1lEMLDqCQNjxFUrBh/fETSG
	 cCDmUjybnCQTqIL9vimVj/REfLlKxYxdOGzjyQJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+061d370693bdd99f9d34@syzkaller.appspotmail.com,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/826] rcu/kvfree: Fix data-race in __mod_timer / kvfree_call_rcu
Date: Tue,  3 Dec 2024 15:36:36 +0100
Message-ID: <20241203144746.164328251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

[ Upstream commit a23da88c6c80e41e0503e0b481a22c9eea63f263 ]

KCSAN reports a data race when access the krcp->monitor_work.timer.expires
variable in the schedule_delayed_monitor_work() function:

<snip>
BUG: KCSAN: data-race in __mod_timer / kvfree_call_rcu

read to 0xffff888237d1cce8 of 8 bytes by task 10149 on cpu 1:
 schedule_delayed_monitor_work kernel/rcu/tree.c:3520 [inline]
 kvfree_call_rcu+0x3b8/0x510 kernel/rcu/tree.c:3839
 trie_update_elem+0x47c/0x620 kernel/bpf/lpm_trie.c:441
 bpf_map_update_value+0x324/0x350 kernel/bpf/syscall.c:203
 generic_map_update_batch+0x401/0x520 kernel/bpf/syscall.c:1849
 bpf_map_do_batch+0x28c/0x3f0 kernel/bpf/syscall.c:5143
 __sys_bpf+0x2e5/0x7a0
 __do_sys_bpf kernel/bpf/syscall.c:5741 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5739 [inline]
 __x64_sys_bpf+0x43/0x50 kernel/bpf/syscall.c:5739
 x64_sys_call+0x2625/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:322
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

write to 0xffff888237d1cce8 of 8 bytes by task 56 on cpu 0:
 __mod_timer+0x578/0x7f0 kernel/time/timer.c:1173
 add_timer_global+0x51/0x70 kernel/time/timer.c:1330
 __queue_delayed_work+0x127/0x1a0 kernel/workqueue.c:2523
 queue_delayed_work_on+0xdf/0x190 kernel/workqueue.c:2552
 queue_delayed_work include/linux/workqueue.h:677 [inline]
 schedule_delayed_monitor_work kernel/rcu/tree.c:3525 [inline]
 kfree_rcu_monitor+0x5e8/0x660 kernel/rcu/tree.c:3643
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0x483/0x9a0 kernel/workqueue.c:3310
 worker_thread+0x51d/0x6f0 kernel/workqueue.c:3391
 kthread+0x1d1/0x210 kernel/kthread.c:389
 ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 56 Comm: kworker/u8:4 Not tainted 6.12.0-rc2-syzkaller-00050-g5b7c893ed5ed #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: events_unbound kfree_rcu_monitor
<snip>

kfree_rcu_monitor() rearms the work if a "krcp" has to be still
offloaded and this is done without holding krcp->lock, whereas
the kvfree_call_rcu() holds it.

Fix it by acquiring the "krcp->lock" for kfree_rcu_monitor() so
both functions do not race anymore.

Reported-by: syzbot+061d370693bdd99f9d34@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/ZxZ68KmHDQYU0yfD@pc636/T/
Fixes: 8fc5494ad5fa ("rcu/kvfree: Move need_offload_krc() out of krcp->lock")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index b1f883fcd9185..3e486ccaa4ca3 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3511,7 +3511,7 @@ static int krc_count(struct kfree_rcu_cpu *krcp)
 }
 
 static void
-schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp)
+__schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp)
 {
 	long delay, delay_left;
 
@@ -3525,6 +3525,16 @@ schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp)
 	queue_delayed_work(system_unbound_wq, &krcp->monitor_work, delay);
 }
 
+static void
+schedule_delayed_monitor_work(struct kfree_rcu_cpu *krcp)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&krcp->lock, flags);
+	__schedule_delayed_monitor_work(krcp);
+	raw_spin_unlock_irqrestore(&krcp->lock, flags);
+}
+
 static void
 kvfree_rcu_drain_ready(struct kfree_rcu_cpu *krcp)
 {
@@ -3836,7 +3846,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 
 	// Set timer to drain after KFREE_DRAIN_JIFFIES.
 	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING)
-		schedule_delayed_monitor_work(krcp);
+		__schedule_delayed_monitor_work(krcp);
 
 unlock_return:
 	krc_this_cpu_unlock(krcp, flags);
-- 
2.43.0



