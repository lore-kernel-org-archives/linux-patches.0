Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6FA3A6B6F;
	Thu, 17 Sep 2026 15:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659677; cv=none; b=oteAH2NrKfFe9Qg1cnNv0BWfRJWfFjT51MxtlB7qdCQ63fWncbjvKsN6vf7mbN8D/nO6xwFQJvJcN+oF1EKOvgjWQNk2DEvM+gk3UvN96SDWacpJ0XCdav5L4WRj1u+S/rBZ962YTZ0jMUEvzOzhKoUDkoBQBTzZLwd9x2A0JnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659677; c=relaxed/simple;
	bh=Vu8Y+tkwT8U6brBqNx53uJUj7CjTHDCbgWE3OPd6xog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nr+IcHA9s+lUe7S0gNr/EFBk8EzslzSJcFVxaZ8EdBKQ/EA41F0xzsdfpPFRGugeNSCTtGp2aVIj+LZbIryGk5K6UEksm0kLV5AxaLTnnpCwVQUPWJuWzNYahuLNSaqCMT/wZJyPhoz3GTLtfr3f9hn/PaZAyCsWfoLxoBVf8eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIwhFBeZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIwhFBeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E281F00898;
	Thu, 17 Sep 2026 15:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659667;
	bh=vAxF1ffWIG/AzDWXQRyfcU79jM86M4mGtanhFiHTOos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pIwhFBeZjYKg2Y3AW2xCGwOs9st+3VE7h4Zhw+dt9xJ32AyJLte5JwiESeOro/HW2
	 l12DE+f+ZshBjlCsaODY5QoE3O4DPV9JU5MdBH2EtkqIdlHkamj4t8owyK8+LOsG56
	 UFTivkLjV23mE0VR76GE+aQQnR447RSRdjbVtREQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 294/733] powerpc/entry: Fix irq_soft_mask corruption on replayed interrupt exit
Date: Thu, 17 Sep 2026 16:10:02 +0100
Message-ID: <20260917151358.742748411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>

[ Upstream commit 63a7531ca31f9f097d9cc1cc3fe86ae683cdabdd ]

When __replay_soft_interrupts() replays a pending interrupt (e.g.
PACA_IRQ_DEC -> timer_interrupt), it calls the handler directly with a
synthetic pt_regs. The DEFINE_INTERRUPT_HANDLER_ASYNC wrapper around
each handler calls arch_interrupt_async_exit_prepare() on the way out,
which calls arch_interrupt_exit_prepare() -> local_irq_disable() ->
arch_local_irq_disable(), which does:

    irq_soft_mask_set(IRQS_DISABLED)   /* 0x1 */

This unconditionally overwrites irq_soft_mask with IRQS_DISABLED (0x1),
stripping the IRQS_PMI_DISABLED (0x2) bit. The result is that
irq_soft_mask is 0x1 instead of IRQS_ALL_DISABLED (0x3) when the
handler returns to __replay_soft_interrupts().

For a normally-taken interrupt this is harmless: the next interrupt
always enters through arch_interrupt_enter_prepare() which
unconditionally sets irq_soft_mask to IRQS_ALL_DISABLED. But during
replay, next_interrupt() is called directly between replayed handlers
without going back through arch_interrupt_enter_prepare(), so the
stripped bit is never restored. next_interrupt() then fires a WARNING:

    WARNING: arch/powerpc/kernel/irq_64.c:75
    WARN_ON(irq_soft_mask_return() != IRQS_ALL_DISABLED)

The warning was observed early in boot on a POWER10 pseries guest
during kmem_cache_init_late(), where a spinlock release triggers
interrupt replay that processes a pending timer interrupt.

Debugger state confirming the bug:
  Before timer_interrupt(&regs):
    irq_soft_mask = 0x3 (IRQS_ALL_DISABLED)   correct
    irq_happened  = 0x41 (HARD_DIS|REPLAYING)  correct
  After timer_interrupt(&regs) returns:
    irq_soft_mask = 0x1 (IRQS_DISABLED)        WRONG - PMI bit stripped
    irq_happened  = 0x41                        unchanged

The fix is to replace local_irq_disable() with hard_irq_disable().

hard_irq_disable() is the right primitive here for two reasons:

1. On PPC64 (hw_irq.h:301) it calls irq_soft_mask_set_return(IRQS_ALL_DISABLED),
   setting the soft mask to 0x3 (both IRQS_DISABLED and IRQS_PMI_DISABLED),
   which preserves the PMI bit and fixes the WARNING. The additional
   work it does (__hard_irq_disable(), PACA_IRQ_HARD_DIS |=) is
   redundant but safe since both are already set at this point in the
   exit path; the trace_hardirqs_off() inside is guarded by
   if (!arch_irqs_disabled_flags(flags)) so it will not double-fire.

2. On PPC32 (hw_irq.h:467) hard_irq_disable() maps to
   arch_local_irq_disable() -> __hard_irq_disable(), which clears
   MSR[EE] in hardware. This is exactly correct: PPC32 has no soft-mask
   PACA mechanism, so the hardware disable is the right way to satisfy
   irqentry_exit()'s requirement. This also fixes a build error on PPC32
   where irq_soft_mask_set() is only defined under CONFIG_PPC64:

       arch/powerpc/include/asm/entry-common.h:273: error: implicit
       declaration of function 'irq_soft_mask_set'

   Using hard_irq_disable() requires no #ifdef and is consistent with
   how the rest of the entry code (e.g. entry-common.h:463) handles the
   same PPC32/PPC64 split.

Fixes: 334f3f6d7a16 ("powerpc/entry: Disable interrupts before irqentry_exit")
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/all/6f9bfb0f-b14c-468e-bb9f-c157d120d0dc@linux.ibm.com/
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260904090858.128563-1-mkchauras@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/entry-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/entry-common.h b/arch/powerpc/include/asm/entry-common.h
index 94083516df574..80b07750b531b 100644
--- a/arch/powerpc/include/asm/entry-common.h
+++ b/arch/powerpc/include/asm/entry-common.h
@@ -270,7 +270,7 @@ static inline void arch_interrupt_exit_prepare(struct pt_regs *regs)
 	}
 
 	/* irqentry_exit expects to be called with interrupts disabled */
-	local_irq_disable();
+	hard_irq_disable();
 }
 
 static inline void arch_interrupt_async_enter_prepare(struct pt_regs *regs)
-- 
2.53.0



