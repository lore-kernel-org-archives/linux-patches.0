Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414ED17E015;
	Fri, 15 Nov 2024 06:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653329; cv=none; b=sZ3ZU6IoFdf6oxyY0cLHS/54RigQJHJQgYCwv4Oxc9YG2H32DJQiRcFyVpgz0NxfyiNG6Cd36IukbyIzsPo0zlBGIWJBHqsLB8XXAnSPlFs/bdl+YuTJ2w2lqmWF5w9/CKWp04RcrI5lS4CedNUrUYgvJ8ICU6D6jOOWq1nu4/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653329; c=relaxed/simple;
	bh=f+bEM/hYf8t30vwV0ZDCysL83ozuDkpLDYHH36iL6g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWCbmOGRqvOLEnp8bYOmKnvWIsb1Pq4WYj+P+jVUWqirhURFxQFm6duRegytoyijmwzMvSYHdz1F1zHW+DWXu45x7sHebcZvQcfZUAXT17fsDe/A9o/U4t1RyDcqdq4nLk17RT5rLY1FZu1vNZoAUQg23oHAt37kXWuYC2BIw9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfCIHk75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfCIHk75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B3BC4CECF;
	Fri, 15 Nov 2024 06:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653329;
	bh=f+bEM/hYf8t30vwV0ZDCysL83ozuDkpLDYHH36iL6g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfCIHk75kPLNQ8jWZvIZufKsivKcrG6Rv6YDoCit00cdUkHi4jY7Ui/QwOe9LYi8o
	 NGJgsJX7V+oN5fiOidi4xgEcYgoRuCHi4czrhk8h378qZVcws+NmRncsYcBojUvFTC
	 LATC9U38FVEtDggvI/7hu4q0tqfYwwCG5gyNMOjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 54/63] LoongArch: KVM: Mark hrtimer to expire in hard interrupt context
Date: Fri, 15 Nov 2024 07:38:17 +0100
Message-ID: <20241115063727.860350366@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 73adbd92f3223dc0c3506822b71c6b259d5d537b ]

Like commit 2c0d278f3293f ("KVM: LAPIC: Mark hrtimer to expire in hard
interrupt context") and commit 9090825fa9974 ("KVM: arm/arm64: Let the
timer expire in hardirq context on RT"), On PREEMPT_RT enabled kernels
unmarked hrtimers are moved into soft interrupt expiry mode by default.
Then the timers are canceled from an preempt-notifier which is invoked
with disabled preemption which is not allowed on PREEMPT_RT.

The timer callback is short so in could be invoked in hard-IRQ context.
So let the timer expire on hard-IRQ context even on -RT.

This fix a "scheduling while atomic" bug for PREEMPT_RT enabled kernels:

 BUG: scheduling while atomic: qemu-system-loo/1011/0x00000002
 Modules linked in: amdgpu rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat ns
 CPU: 1 UID: 0 PID: 1011 Comm: qemu-system-loo Tainted: G        W          6.12.0-rc2+ #1774
 Tainted: [W]=WARN
 Hardware name: Loongson Loongson-3A5000-7A1000-1w-CRB/Loongson-LS3A5000-7A1000-1w-CRB, BIOS vUDK2018-LoongArch-V2.0.0-prebeta9 10/21/2022
 Stack : ffffffffffffffff 0000000000000000 9000000004e3ea38 9000000116744000
         90000001167475a0 0000000000000000 90000001167475a8 9000000005644830
         90000000058dc000 90000000058dbff8 9000000116747420 0000000000000001
         0000000000000001 6a613fc938313980 000000000790c000 90000001001c1140
         00000000000003fe 0000000000000001 000000000000000d 0000000000000003
         0000000000000030 00000000000003f3 000000000790c000 9000000116747830
         90000000057ef000 0000000000000000 9000000005644830 0000000000000004
         0000000000000000 90000000057f4b58 0000000000000001 9000000116747868
         900000000451b600 9000000005644830 9000000003a13998 0000000010000020
         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
         ...
 Call Trace:
 [<9000000003a13998>] show_stack+0x38/0x180
 [<9000000004e3ea34>] dump_stack_lvl+0x84/0xc0
 [<9000000003a71708>] __schedule_bug+0x48/0x60
 [<9000000004e45734>] __schedule+0x1114/0x1660
 [<9000000004e46040>] schedule_rtlock+0x20/0x60
 [<9000000004e4e330>] rtlock_slowlock_locked+0x3f0/0x10a0
 [<9000000004e4f038>] rt_spin_lock+0x58/0x80
 [<9000000003b02d68>] hrtimer_cancel_wait_running+0x68/0xc0
 [<9000000003b02e30>] hrtimer_cancel+0x70/0x80
 [<ffff80000235eb70>] kvm_restore_timer+0x50/0x1a0 [kvm]
 [<ffff8000023616c8>] kvm_arch_vcpu_load+0x68/0x2a0 [kvm]
 [<ffff80000234c2d4>] kvm_sched_in+0x34/0x60 [kvm]
 [<9000000003a749a0>] finish_task_switch.isra.0+0x140/0x2e0
 [<9000000004e44a70>] __schedule+0x450/0x1660
 [<9000000004e45cb0>] schedule+0x30/0x180
 [<ffff800002354c70>] kvm_vcpu_block+0x70/0x120 [kvm]
 [<ffff800002354d80>] kvm_vcpu_halt+0x60/0x3e0 [kvm]
 [<ffff80000235b194>] kvm_handle_gspr+0x3f4/0x4e0 [kvm]
 [<ffff80000235f548>] kvm_handle_exit+0x1c8/0x260 [kvm]

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/timer.c | 7 ++++---
 arch/loongarch/kvm/vcpu.c  | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index 74a4b5c272d60..32dc213374bea 100644
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -161,10 +161,11 @@ static void _kvm_save_timer(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_is_blocking(vcpu)) {
 
 		/*
-		 * HRTIMER_MODE_PINNED is suggested since vcpu may run in
-		 * the same physical cpu in next time
+		 * HRTIMER_MODE_PINNED_HARD is suggested since vcpu may run in
+		 * the same physical cpu in next time, and the timer should run
+		 * in hardirq context even in the PREEMPT_RT case.
 		 */
-		hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED_HARD);
 	}
 }
 
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 6905283f535b9..9218fc521c22d 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1144,7 +1144,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.vpid = 0;
 	vcpu->arch.flush_gpa = INVALID_GPA;
 
-	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
+	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED_HARD);
 	vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
 
 	vcpu->arch.handle_exit = kvm_handle_exit;
-- 
2.43.0



