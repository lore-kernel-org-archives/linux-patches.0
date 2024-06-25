Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EC01465B7;
	Tue, 25 Jun 2024 09:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308871; cv=none; b=sp9o26sB1562lXQe8GPrCeJcjqN0MfMNxt+0B6SrCM7Gsn1EzEBXjVHFzv7QynkOitSLNHm7gWWkr2kLzKOyvK6rSc1msUhIwk+9cwBzpFYmBBaz/9dpqH8+4ReTYKPJbC0VXTbx2aHiK9uWhrpyZ2devGHUwf9vjcO+CuG/gBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308871; c=relaxed/simple;
	bh=sWfsXbumU5esEK2FrrH0mJKYdHGVSc+wk5xe+/EL+B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2KZzgLYSREstKsTGzhYx+ferz3XEnHmxf/wTwbArl+yQSyjR+wbezPAlEhO7DDrqATICsrh27lqigXIpxFeKpHWO5bETGFCu1jIHJ5VHHdt9NpNBgWNz33hHzoSlfPif3jfivY99/8AyTe/obSDljPGv9eiZZrwGxNX1F3Fi6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCJManLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCJManLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F48C32786;
	Tue, 25 Jun 2024 09:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308871;
	bh=sWfsXbumU5esEK2FrrH0mJKYdHGVSc+wk5xe+/EL+B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCJManLetmq00HO7Lxc1FX3/3mzCCo7gRZahBmkUVkbeK0ywYiq0+3f5/LPlkDkvx
	 N6THCdGmJWGE38/gy3NmgPZTJsr930qzISDFYZq0LN8MZPxlbs+tnvzUIzXM1Dpk27
	 /UdcHAzgIs22dOjL8gdbRudhDR+ldhySIGF0DJno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/192] rcutorture: Fix invalid context warning when enable srcu barrier testing
Date: Tue, 25 Jun 2024 11:31:20 +0200
Message-ID: <20240625085537.475621305@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit 668c0406d887467d53f8fe79261dda1d22d5b671 ]

When the torture_type is set srcu or srcud and cb_barrier is
non-zero, running the rcutorture test will trigger the
following warning:

[  163.910989][    C1] BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
[  163.910994][    C1] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/1
[  163.910999][    C1] preempt_count: 10001, expected: 0
[  163.911002][    C1] RCU nest depth: 0, expected: 0
[  163.911005][    C1] INFO: lockdep is turned off.
[  163.911007][    C1] irq event stamp: 30964
[  163.911010][    C1] hardirqs last  enabled at (30963): [<ffffffffabc7df52>] do_idle+0x362/0x500
[  163.911018][    C1] hardirqs last disabled at (30964): [<ffffffffae616eff>] sysvec_call_function_single+0xf/0xd0
[  163.911025][    C1] softirqs last  enabled at (0): [<ffffffffabb6475f>] copy_process+0x16ff/0x6580
[  163.911033][    C1] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  163.911038][    C1] Preemption disabled at:
[  163.911039][    C1] [<ffffffffacf1964b>] stack_depot_save_flags+0x24b/0x6c0
[  163.911063][    C1] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W          6.8.0-rc4-rt4-yocto-preempt-rt+ #3 1e39aa9a737dd024a3275c4f835a872f673a7d3a
[  163.911071][    C1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
[  163.911075][    C1] Call Trace:
[  163.911078][    C1]  <IRQ>
[  163.911080][    C1]  dump_stack_lvl+0x88/0xd0
[  163.911089][    C1]  dump_stack+0x10/0x20
[  163.911095][    C1]  __might_resched+0x36f/0x530
[  163.911105][    C1]  rt_spin_lock+0x82/0x1c0
[  163.911112][    C1]  spin_lock_irqsave_ssp_contention+0xb8/0x100
[  163.911121][    C1]  srcu_gp_start_if_needed+0x782/0xf00
[  163.911128][    C1]  ? _raw_spin_unlock_irqrestore+0x46/0x70
[  163.911136][    C1]  ? debug_object_active_state+0x336/0x470
[  163.911148][    C1]  ? __pfx_srcu_gp_start_if_needed+0x10/0x10
[  163.911156][    C1]  ? __pfx_lock_release+0x10/0x10
[  163.911165][    C1]  ? __pfx_rcu_torture_barrier_cbf+0x10/0x10
[  163.911188][    C1]  __call_srcu+0x9f/0xe0
[  163.911196][    C1]  call_srcu+0x13/0x20
[  163.911201][    C1]  srcu_torture_call+0x1b/0x30
[  163.911224][    C1]  rcu_torture_barrier1cb+0x4a/0x60
[  163.911247][    C1]  __flush_smp_call_function_queue+0x267/0xca0
[  163.911256][    C1]  ? __pfx_rcu_torture_barrier1cb+0x10/0x10
[  163.911281][    C1]  generic_smp_call_function_single_interrupt+0x13/0x20
[  163.911288][    C1]  __sysvec_call_function_single+0x7d/0x280
[  163.911295][    C1]  sysvec_call_function_single+0x93/0xd0
[  163.911302][    C1]  </IRQ>
[  163.911304][    C1]  <TASK>
[  163.911308][    C1]  asm_sysvec_call_function_single+0x1b/0x20
[  163.911313][    C1] RIP: 0010:default_idle+0x17/0x20
[  163.911326][    C1] RSP: 0018:ffff888001997dc8 EFLAGS: 00000246
[  163.911333][    C1] RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffffffffae618b51
[  163.911337][    C1] RDX: 0000000000000000 RSI: ffffffffaea80920 RDI: ffffffffaec2de80
[  163.911342][    C1] RBP: ffff888001997dc8 R08: 0000000000000001 R09: ffffed100d740cad
[  163.911346][    C1] R10: ffffed100d740cac R11: ffff88806ba06563 R12: 0000000000000001
[  163.911350][    C1] R13: ffffffffafe460c0 R14: ffffffffafe460c0 R15: 0000000000000000
[  163.911358][    C1]  ? ct_kernel_exit.constprop.3+0x121/0x160
[  163.911369][    C1]  ? lockdep_hardirqs_on+0xc4/0x150
[  163.911376][    C1]  arch_cpu_idle+0x9/0x10
[  163.911383][    C1]  default_idle_call+0x7a/0xb0
[  163.911390][    C1]  do_idle+0x362/0x500
[  163.911398][    C1]  ? __pfx_do_idle+0x10/0x10
[  163.911404][    C1]  ? complete_with_flags+0x8b/0xb0
[  163.911416][    C1]  cpu_startup_entry+0x58/0x70
[  163.911423][    C1]  start_secondary+0x221/0x280
[  163.911430][    C1]  ? __pfx_start_secondary+0x10/0x10
[  163.911440][    C1]  secondary_startup_64_no_verify+0x17f/0x18b
[  163.911455][    C1]  </TASK>

This commit therefore use smp_call_on_cpu() instead of
smp_call_function_single(), make rcu_torture_barrier1cb() invoked
happens on task-context.

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 263457305d36a..781146600aa49 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -3013,11 +3013,12 @@ static void rcu_torture_barrier_cbf(struct rcu_head *rcu)
 }
 
 /* IPI handler to get callback posted on desired CPU, if online. */
-static void rcu_torture_barrier1cb(void *rcu_void)
+static int rcu_torture_barrier1cb(void *rcu_void)
 {
 	struct rcu_head *rhp = rcu_void;
 
 	cur_ops->call(rhp, rcu_torture_barrier_cbf);
+	return 0;
 }
 
 /* kthread function to register callbacks used to test RCU barriers. */
@@ -3043,11 +3044,9 @@ static int rcu_torture_barrier_cbs(void *arg)
 		 * The above smp_load_acquire() ensures barrier_phase load
 		 * is ordered before the following ->call().
 		 */
-		if (smp_call_function_single(myid, rcu_torture_barrier1cb,
-					     &rcu, 1)) {
-			// IPI failed, so use direct call from current CPU.
+		if (smp_call_on_cpu(myid, rcu_torture_barrier1cb, &rcu, 1))
 			cur_ops->call(&rcu, rcu_torture_barrier_cbf);
-		}
+
 		if (atomic_dec_and_test(&barrier_cbs_count))
 			wake_up(&barrier_wq);
 	} while (!torture_must_stop());
-- 
2.43.0



