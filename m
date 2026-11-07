Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063474;
	b=GS43SsUyFxrYrpLIvpThBvXZ/CrHEvXIOrayU+IQ7ZPgiWXgS+P54xqUA6d9w72BrGhB
	 jXj36CZGmaMtwY0iYBWvAGEtkbdyC0KuhiixtcT6PBCh5whFWdqIbulNy2CTP//TwzSth
	 xHSddVsLh1MlxjhdH5NTLTqT0LY+7+PGcGZqiniZgLOVCsEnMGGMaP4LG75DnYvfZ/W9o
	 nwqOw4X1jiVfNjpLVTEv4CDSiVtUcOXdVuLp6DMV9XEwCiK2ilqtBtWkZ84JTSiN3kJDX
	 WcPOc+3yk1m7Uhf86Hz3840r6M/54nBPHZ3Q1MjOQU2STdSe0UIuDLz+B74VOWbCCpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0M5j6z0bDeORBrGozY8sz20zwCM2DEN7akictxmFHRE=;
	b=Ad3TG0YC1BM+GxgmiBARc4AoJ51dyqVnkc5/i71gRhC1f9A5+rp3HVYOaqp4AluiX3QN
	 +ozabY0pm9vpHlCT4jXZjTdBBDGgc9aMsH0spZexu3BUONz1ipT0W5ndIDj3quwSMbeWO
	 TeTktTWUxmsW4Oflxk78jNf0E1ypQtdeLMFqmJg2l+jGoLc91hqlMfh01SAIGh/cRSk5S
	 EqI64SC3nJyB4tGPkQi0CJJ+veFsWkB15a5Bc9fANAThuwZOcvyMKw8rZQLeps5x3NlYl
	 ELP+QkL3daOKn3P6WrJbN4Xtyrew95KdjKvUzy2mFVgEzHNBY5hiV/8Q6cJBQKrwF6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HITMYt3i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BE860A6F75;
	Sat,  7 Nov 2026 14:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HITMYt3i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC03B1F008A4;
	Sat,  7 Nov 2026 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063473;
	bh=0M5j6z0bDeORBrGozY8sz20zwCM2DEN7akictxmFHRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HITMYt3iD7v7GUEoFSnDMCfsAI0bJyMoVNQ8SshHUfQAdocyomMv+R1DBKqbakukQ
	 jL2xYadeDe3BtPhCPQhNBZ2xf/2myjRDzc8hD67eixu7YKsgtYClNO78F/eDjK60KE
	 vrwsyUGH38yODJHhGhJFFDhDWoM1HzuSiwO7TmAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 625/869] alpha: load the MMU context when switch_mm() switches the current task
Date: Sat,  7 Nov 2026 08:55:07 -0500
Message-ID: <20261107134914.204077053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 9b8be19d5dc9525a408942e2e8012873199e7455 ]

ev5_switch_mm() only prepares the incoming PCB. The context is installed
by PAL_swpctx, which alpha_switch_to() issues against that PCB on the way
out of the scheduler.

Direct callers reach switch_mm() without going through alpha_switch_to():
kthread_use_mm(), which borrows an mm for the current kernel thread,
sched_force_init_mm() on the CPU-hotplug teardown path, and
do_shoot_lazy_tlb(), which switches to init_mm from an IPI. None explicitly
loads the context, so the task can carry on running under whatever was
loaded before. For kthread_use_mm(), current->mm then names the borrowed
mm even though its context has not been loaded. The other two callers
change active_mm while leaving current->mm NULL.

The stale page-table root need not be swapper_pg_dir; it may belong to a
user process that ran on the CPU earlier, and the kthread's user accesses
can then read and write that process's memory wherever the stale mappings
allow. Translations taken that way can also end up tagged with the
borrowed mm's ASN: ev5_switch_mm() writes that ASN into the PCB, which the
next PAL_swpctx installs against the stale ptbr. An address the stale
tables do not map faults instead, and since do_page_fault() resolves
faults against current->mm without reloading the context, the same access
can fault again on return.

sched_force_init_mm() needs CONFIG_HOTPLUG_CPU and do_shoot_lazy_tlb()
needs CONFIG_MMU_LAZY_TLB_SHOOTDOWN. Alpha selects neither, so only
kthread_use_mm() is reachable in practice. Test the caller's identity
rather than special-casing individual callers.

The scheduler passes the incoming task, which is not current until
alpha_switch_to() runs; all three direct callers pass current. Test for
that and load the context the way activate_mm() does. All three run with
interrupts disabled across the switch, so this completes before any
shootdown can be taken and needs no asn_lock handshake.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Tested-by: Matt Turner <mattst88@gmail.com>
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-2-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/mmu_context.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/mmu_context.h b/arch/alpha/include/asm/mmu_context.h
index eee8fe836a59e..d366f89fee585 100644
--- a/arch/alpha/include/asm/mmu_context.h
+++ b/arch/alpha/include/asm/mmu_context.h
@@ -130,6 +130,8 @@ __get_new_mm_context(struct mm_struct *mm, long cpu)
 	return next;
 }
 
+extern void __load_new_mm_context(struct mm_struct *);
+
 __EXTERN_INLINE void
 ev5_switch_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm,
 	      struct task_struct *next)
@@ -139,6 +141,16 @@ ev5_switch_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm,
 	unsigned long mmc;
 	long cpu = smp_processor_id();
 
+	/*
+	 * kthread_use_mm(), sched_force_init_mm() and do_shoot_lazy_tlb()
+	 * switch current's mm without alpha_switch_to(), which loads the
+	 * context. The latter two require options Alpha does not select.
+	 */
+	if (next == current) {
+		__load_new_mm_context(next_mm);
+		return;
+	}
+
 #ifdef CONFIG_SMP
 	cpu_data[cpu].asn_lock = 1;
 	barrier();
@@ -160,7 +172,6 @@ ev5_switch_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm,
 	task_thread_info(next)->pcb.asn = mmc & HARDWARE_ASN_MASK;
 }
 
-extern void __load_new_mm_context(struct mm_struct *);
 asmlinkage void do_page_fault(unsigned long address, unsigned long mmcsr,
 			      long cause, struct pt_regs *regs);
 
-- 
2.53.0



