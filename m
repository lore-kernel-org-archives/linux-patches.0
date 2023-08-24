Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60A52890D
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF29CC433C7;
	Thu, 24 Aug 2023 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692886528;
	bh=m34dcTHPMSS6n4BVRcRs2osf6gaO0M3cDkAVsJO2cvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbXUuonWdXcl5b/AvSif7+GvTVZ1IvzsWEQZ1sUY5Y9Q58fHyXgEzVKOF3xQ48RUG
	 PUrvvH+P760PFhdhlebU3UjZ1Ru1h7fMkUt0VjAJz+cb+31U3BtAZ05Hpkk+qngIH+
	 FD5Av2SR8mlJPWGSuoW4KncrauPEAF1psUicPqWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.1 11/15] x86/CPU/AMD: Fix the DIV(0) initial fix attempt
Date: Thu, 24 Aug 2023 16:15:07 +0200
Message-ID: <20230824141447.701590552@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824141447.155846739@linuxfoundation.org>
References: <20230824141447.155846739@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov (AMD) <bp@alien8.de>

commit f58d6fbcb7c848b7f2469be339bc571f2e9d245b upstream.

Initially, it was thought that doing an innocuous division in the #DE
handler would take care to prevent any leaking of old data from the
divider but by the time the fault is raised, the speculation has already
advanced too far and such data could already have been used by younger
operations.

Therefore, do the innocuous division on every exit to userspace so that
userspace doesn't see any potentially old data from integer divisions in
kernel space.

Do the same before VMRUN too, to protect host data from leaking into the
guest too.

Fixes: 77245f1c3c64 ("x86/CPU/AMD: Do not leak quotient data after a division by 0")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230811213824.10025-1-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/entry-common.h |    1 +
 arch/x86/kernel/cpu/amd.c           |    1 +
 arch/x86/kernel/traps.c             |    2 --
 arch/x86/kvm/svm/svm.c              |    2 ++
 4 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -92,6 +92,7 @@ static inline void arch_exit_to_user_mod
 static __always_inline void arch_exit_to_user_mode(void)
 {
 	mds_user_clear_cpu_buffers();
+	amd_clear_divider();
 }
 #define arch_exit_to_user_mode arch_exit_to_user_mode
 
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1295,3 +1295,4 @@ void noinstr amd_clear_divider(void)
 	asm volatile(ALTERNATIVE("", "div %2\n\t", X86_BUG_DIV0)
 		     :: "a" (0), "d" (0), "r" (1));
 }
+EXPORT_SYMBOL_GPL(amd_clear_divider);
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -206,8 +206,6 @@ DEFINE_IDTENTRY(exc_divide_error)
 {
 	do_error_trap(regs, 0, "divide error", X86_TRAP_DE, SIGFPE,
 		      FPE_INTDIV, error_get_trap_addr(regs));
-
-	amd_clear_divider();
 }
 
 DEFINE_IDTENTRY(exc_overflow)
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3947,6 +3947,8 @@ static noinstr void svm_vcpu_enter_exit(
 
 	guest_state_enter_irqoff();
 
+	amd_clear_divider();
+
 	if (sev_es_guest(vcpu->kvm))
 		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
 	else


