Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046824;
	b=p2qga/3EGZZFnrsXLUbdspJDxmR4USXioaEhMi1eSTR1icmHvU+FgqVDShNzhUf1T4Lu
	 0Tc1YPvw4UVctuGI5bAwIv7HrBzWH57MsmxKQsVbWnQU1glp9rz3KpLlwXjAqJzpSGIQ/
	 IoOZ2ld+4u5tYKDF/PAxmBUHYgeUbUYtpPZNwQlCPJbLbSBkvBRyzttTJY8d2ytLjWDSP
	 mNywdikhMPVha8WBoqrMu/gmMEiaGkWLZ4H29H3h+vCCoREtgFRQFedx5zH/FZr4nZiGl
	 8SdBT0yfYGXjNSwnBCpjuFmiDMjC9+h0Hwq8IWVJQcENC51B1vLwniJzyejS/840E+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y2JpUzRCaBdqvsEtVjgJjOo8gys0WmeB4/KZAitoyTI=;
	b=Sw6mPIxb1oCS+M8dWKKWQDH+mUqFXSJejSyafT+zbYOKvXFGIueniguApbqfnVHCVciA
	 +wSvghv2XNbSludt7PQHIIvuty3vCaidjiBFS5QMSgPTXwh1uBun0yuSHIO0xwesj7qKS
	 74ZCMVEWeEPUt0EZeo+wOtFgXntaQqOxmIRjkR+ZrKLH+9n3w3OLPt2Ze/tiu0BY6vPF2
	 YAQwQKu+BiWtIFLJvJY+Xstdn0siiDdKec2fHGqjXy7uLhh3Ksf0RcU6ZsW33FgektVn4
	 l9O4Z5L1fSBS8CCYM9qy8cOq/LnxDkX4UEjV512+Kt2YM82XD6G6k/DAJ5cGaSlwv5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFk3iYKy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A70606A32F;
	Thu, 19 Nov 2026 00:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFk3iYKy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73C21F000C4;
	Thu, 19 Nov 2026 00:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046824;
	bh=Y2JpUzRCaBdqvsEtVjgJjOo8gys0WmeB4/KZAitoyTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFk3iYKyr59DD3drDcFW55bmGH+JQ1UrxCo5pcJO0fsG0UxQPzszWugPdbuS4yVh3
	 VZP6JzPJ7vW+kNp1qOxovxscasm9dP7VArXWb11YRlzbZPk37znQXDJ59rIRzsplR1
	 S2dJseWOZgr9GHS0qtqm4PGLPmO50VL0Aym3lUE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1417/2857] alpha: load the MMU context when switch_mm() switches the current task
Date: Wed, 18 Nov 2026 15:40:51 +0100
Message-ID: <20261118150252.347786365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 9b8be19d5dc9525a408942e2e8012873199e7455 ]

The 6.1.y header still contains ev4_switch_mm().  Retain it, and omit the
unrelated do_page_fault() declaration move.  Of the direct callers
described below, only kthread_use_mm() is present in this tree.

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
(cherry picked from commit 9b8be19d5dc9525a408942e2e8012873199e7455)
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/mmu_context.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/mmu_context.h b/arch/alpha/include/asm/mmu_context.h
index 7aeee0846dc9d..14f85e7e88387 100644
--- a/arch/alpha/include/asm/mmu_context.h
+++ b/arch/alpha/include/asm/mmu_context.h
@@ -132,6 +132,8 @@ __get_new_mm_context(struct mm_struct *mm, long cpu)
 	return next;
 }
 
+extern void __load_new_mm_context(struct mm_struct *);
+
 __EXTERN_INLINE void
 ev5_switch_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm,
 	      struct task_struct *next)
@@ -141,6 +143,15 @@ ev5_switch_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm,
 	unsigned long mmc;
 	long cpu = smp_processor_id();
 
+	/*
+	 * kthread_use_mm() switches current's mm without alpha_switch_to(),
+	 * which loads the context.
+	 */
+	if (next == current) {
+		__load_new_mm_context(next_mm);
+		return;
+	}
+
 #ifdef CONFIG_SMP
 	cpu_data[cpu].asn_lock = 1;
 	barrier();
@@ -182,8 +193,6 @@ ev4_switch_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm,
 	ev5_switch_mm(prev_mm, next_mm, next);
 }
 
-extern void __load_new_mm_context(struct mm_struct *);
-
 #ifdef CONFIG_SMP
 #define check_mmu_context()					\
 do {								\
-- 
2.53.0



