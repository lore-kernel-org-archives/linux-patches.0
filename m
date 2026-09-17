Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E509F4E2F19;
	Thu, 17 Sep 2026 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659321; cv=none; b=p5HF7a3CPbBtF63HcxpNR47MO7kle7aAhJWrZYSrKLjFPOYk2fRHVw8EIF5cClX9BvFl8mqlugypKe/lHfESSOrGfILjPRavKsXSLvmLQzNRcP36si6t6GcZIdGHkE+4aRUR/jUPZT6lrjV35pyz3lppkuFDmP2iiAR3o2loe3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659321; c=relaxed/simple;
	bh=7N8Fmoa/vyFC1FCsh5G2zbMvLhqJN2S2w6ex3x+scrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfauHFLllmVBrL6ROZ2+hEINCDGZp92b4Pb7Hnwgcvxwz419dMheBSdADCHmRN50kWxSZZk8oaY1AtfjCzaLvmzGBvPa0C7WOmz9dAdJVhCQLBuKn9Zww3eMZIwsEhJcsC+kPrH3Fcsjgwk4l4EwfdEASVxuJxmqLnUwpb/pe8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W97EQrcR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W97EQrcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F671F00893;
	Thu, 17 Sep 2026 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659315;
	bh=3Z0j1IzQZQy/3aHSjTQ+urtC2IZDMDECYYrbNHtCGCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W97EQrcRiWMZfio39Eb0JeUdcwi4yhyu/rRN+wOzcYRK7LNOpBBh4UhOw8c+IoP19
	 IU4uRBOgDVAJdXZ2DM8iQNVdKoBNmt54dSdImKlqlQQd9TAtmN508xVQFNuaIiH45W
	 ShG6cDSHhNFtOjp37xEHIPaIXpdvVmUpqPpJFvW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 216/733] powerpc: Do not restore KUAP in arch_exit_to_user_mode_prepare()
Date: Thu, 17 Sep 2026 16:08:44 +0100
Message-ID: <20260917151356.581176333@linuxfoundation.org>
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

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit c2549d749539487239475fbc8c614a1f9244d655 ]

KUAP means kernel cannot touch user memory unless it explicitly is
enabled. In the kernel it should stay AMR_KUAP_BLOCKED. While returning
to userspace just before RFI, kernel should restore the user AMR value
back.

Looks like GENERIC_ENTRY might be treating arch_exit_to_user_mode_prepare()
as the last architecture step before returning to userspace.
commit bee25f97ad24 ("powerpc: Enable GENERIC_ENTRY feature")
therefore called kuap_user_restore() from that hook. But on PowerPC that
is too early. After irqentry_exit() / syscall_exit_to_user_mode() we
still run platform specific exit routines.

e.g. code snippets showing both exception handling and system call
handling as the callers of function arch_exit_to_user_mode_prepare()
which does kuap_user_restore(). The below path shows that calling
kuap_user_restore() is too early when called from
arch_exit_to_user_mode_prepare().

Exception handling in exceptions-64s.S
=======================================

bl	CFUNC(do_page_fault)
	  ..DEFINE_INTERRUPT_HANDLER_ASYNC(do_page_fault)
	      arch_interrupt_async_enter_prepare(regs);
	      state = irqentry_enter(regs);
	      instrumentation_begin();
	      irq_enter_rcu();
	      handler(regs);
	      nap_adjust_return(regs);
	      irq_exit_rcu();
	      instrumentation_end();
	      arch_interrupt_async_exit_prepare(regs);
	      irqentry_exit(regs, state); 		   <<< too early
	        irqentry_exit_to_user_mode()
		  __exit_to_user_mode_prepare(regs, EXIT_TO_USER_MODE_WORK_IRQ);
		    arch_exit_to_user_mode_prepare(regs, ti_work);  <<< too early
b	interrupt_return_srr
		.. bl	CFUNC(interrupt_exit_user_prepare) <<< already calls kuap_user_restore

prep_irq_for_enabled_exit() retry can run kernel code with IRQs on. So
only when that routine is fully finished is when the user KUAP should be
fully restored which interrupt_exit_user_prepare() already takes care of
before returning.

Similarly for system call handling in interrupt_64.S
======================================================

	bl	CFUNC(system_call_exception)

.Lsyscall_exit:
	addi	r4,r1,STACK_INT_FRAME_REGS
	li	r5,0 /* !scv */
	bl	CFUNC(syscall_exit_prepare)
		  .. kuap_assert_locked();
		     syscall_exit_to_user_mode(regs); <<< too early
		       syscall_exit_to_user_mode_prepare(regs);  <<< too early
 		     kuap_user_restore(regs);         <<< already calls

syscall_exit_prepare(), which can enable IRQs, replay a pending
interrupt, and only then rfi. Those functions already restore KUAP
immediately before rfi.

Note that if we restore the user AMR too early like in the current code
as shown from the code snippets above, then we get the following warning
when CONFIG_PPC_KUAP_DEBUG is enabled:
  WARNING: arch/powerpc/include/asm/book3s/64/kup.h:293 at interrupt_exit_user_prepare+0x1a0/0x1c0
  Hardware name: IBM pSeries (emulated by qemu) POWER10 (architected)
  TRAP: 0700
  LR: c00000000000d8d4 CTR: c0000000021fe500
  MSR: <SF,EE,ME,IR,DR,RI,LE>  CR: 44000804  XER: 20040000
  interrupt_exit_user_prepare+0x1a0/0x1c0
  interrupt_return_srr_user+0x8/0x12c

Fixes: bee25f97ad24 ("powerpc: Enable GENERIC_ENTRY feature")
Fixes: 02565a782c1ee ("powerpc: Introduce syscall exit arch functions")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/52fee44fd23acf8e1c024ace668728e626a783a8.1788101609.git.ritesh.list@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/entry-common.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/entry-common.h b/arch/powerpc/include/asm/entry-common.h
index c5adb50063610..94083516df574 100644
--- a/arch/powerpc/include/asm/entry-common.h
+++ b/arch/powerpc/include/asm/entry-common.h
@@ -515,8 +515,14 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	local_paca->tm_scratch = regs->msr;
 #endif
-	/* Restore user access locks last */
-	kuap_user_restore(regs);
+	/*
+	 * Do not restore KUAP here. Generic entry might treat this as the last
+	 * arch step before userspace but PowerPC still has kernel work after
+	 * irqentry_exit()/syscall_exit_to_user_mode() i.e. in
+	 * interrupt_exit_user_prepare() / syscall_exit_prepare() may enable
+	 * IRQs and retry. Those functions restore KUAP immediately before rfi,
+	 * which is where it should belong.
+	 */
 }
 
 #define arch_exit_to_user_mode_prepare arch_exit_to_user_mode_prepare
-- 
2.53.0



