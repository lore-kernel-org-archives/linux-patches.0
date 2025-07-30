Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C31D255F5C;
	Wed, 30 Jul 2025 09:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868989; cv=none; b=nX1Oq8+eG3zVhwDhJIYfB5fJqE7PFrb5YnnY1HbA2jsy2XkEDSNMF0uIwBszg/MycQAcKAswSjuRj1WJOmJMheat/WVLY9UUwLuJIvqhT+PGh3wkeSe5sOErX71v5E65yU47zCOGuRZXfb8JWPClbbl5cvS6gQYfyxqKYB1fpNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868989; c=relaxed/simple;
	bh=gHwKynjdf3UoztL2GcQ5MGSxGUEShrrih9KRaCI1JSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYpgf9NU9oHX5pG+JlzeOabycfRIKSsBd4hzzxQtHWCmc0HANphKGRSSXhdKuNfqE9pBq9iq3vVfLDJXIGnNRtWaSiJ0B3bd9eXjKTYgPZOhnpEnAKTrgp/rMEQjEWeabgdFMR2jNFwuwjCQ2lWblLe/vdRK38TFut+tRzjQYFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rB9lFC1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rB9lFC1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4974C4CEF5;
	Wed, 30 Jul 2025 09:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868989;
	bh=gHwKynjdf3UoztL2GcQ5MGSxGUEShrrih9KRaCI1JSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rB9lFC1wtsCWJ6ZVhc7SpmrgPegHABxGShehCLAccmcLyhV4+IxrJ13paIkqYVMhl
	 VIOD8q//vVWzlNU5xqZlCNi57C6d5IZ61lqOmq0RGQidTwnSPSUecb8qyOm6DXI12E
	 R+m9qXxWtrJGO4qVBFjK+ew5WQji4H9HVS/sa9OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xin Li (Intel)" <xin@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 01/92] x86/traps: Initialize DR7 by writing its architectural reset value
Date: Wed, 30 Jul 2025 11:35:09 +0200
Message-ID: <20250730093230.687699289@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Li (Intel) <xin@zytor.com>

commit fa7d0f83c5c4223a01598876352473cb3d3bd4d7 upstream.

Initialize DR7 by writing its architectural reset value to always set
bit 10, which is reserved to '1', when "clearing" DR7 so as not to
trigger unanticipated behavior if said bit is ever unreserved, e.g. as
a feature enabling flag with inverted polarity.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Sean Christopherson <seanjc@google.com>
Tested-by: Sohil Mehta <sohil.mehta@intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250620231504.2676902-3-xin%40zytor.com
[ context adjusted: no KVM_DEBUGREG_AUTO_SWITCH flag test" ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/debugreg.h |   19 +++++++++++++++----
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kernel/cpu/common.c    |    2 +-
 arch/x86/kernel/kgdb.c          |    2 +-
 arch/x86/kernel/process_32.c    |    2 +-
 arch/x86/kernel/process_64.c    |    2 +-
 arch/x86/kvm/x86.c              |    4 ++--
 7 files changed, 22 insertions(+), 11 deletions(-)

--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -9,6 +9,14 @@
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
 
+/*
+ * Define bits that are always set to 1 in DR7, only bit 10 is
+ * architecturally reserved to '1'.
+ *
+ * This is also the init/reset value for DR7.
+ */
+#define DR7_FIXED_1	0x00000400
+
 DECLARE_PER_CPU(unsigned long, cpu_dr7);
 
 #ifndef CONFIG_PARAVIRT_XXL
@@ -100,8 +108,8 @@ static __always_inline void native_set_d
 
 static inline void hw_breakpoint_disable(void)
 {
-	/* Zero the control register for HW Breakpoint */
-	set_debugreg(0UL, 7);
+	/* Reset the control register for HW Breakpoint */
+	set_debugreg(DR7_FIXED_1, 7);
 
 	/* Zero-out the individual HW breakpoint address registers */
 	set_debugreg(0UL, 0);
@@ -125,9 +133,12 @@ static __always_inline unsigned long loc
 		return 0;
 
 	get_debugreg(dr7, 7);
-	dr7 &= ~0x400; /* architecturally set bit */
+
+	/* Architecturally set bit */
+	dr7 &= ~DR7_FIXED_1;
 	if (dr7)
-		set_debugreg(0, 7);
+		set_debugreg(DR7_FIXED_1, 7);
+
 	/*
 	 * Ensure the compiler doesn't lower the above statements into
 	 * the critical section; disabling breakpoints late would not
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -31,6 +31,7 @@
 
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
+#include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/mtrr.h>
 #include <asm/msr-index.h>
@@ -247,7 +248,6 @@ enum x86_intercept_stage;
 #define DR7_BP_EN_MASK	0x000000ff
 #define DR7_GE		(1 << 9)
 #define DR7_GD		(1 << 13)
-#define DR7_FIXED_1	0x00000400
 #define DR7_VOLATILE	0xffff2bff
 
 #define KVM_GUESTDBG_VALID_MASK \
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2220,7 +2220,7 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard)
 static void initialize_debug_regs(void)
 {
 	/* Control register first -- to make sure everything is disabled. */
-	set_debugreg(0, 7);
+	set_debugreg(DR7_FIXED_1, 7);
 	set_debugreg(DR6_RESERVED, 6);
 	/* dr5 and dr4 don't exist */
 	set_debugreg(0, 3);
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -385,7 +385,7 @@ static void kgdb_disable_hw_debug(struct
 	struct perf_event *bp;
 
 	/* Disable hardware debugging while we are in kgdb: */
-	set_debugreg(0UL, 7);
+	set_debugreg(DR7_FIXED_1, 7);
 	for (i = 0; i < HBP_NUM; i++) {
 		if (!breakinfo[i].enabled)
 			continue;
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -93,7 +93,7 @@ void __show_regs(struct pt_regs *regs, e
 
 	/* Only print out debug registers if they are in their non-default state. */
 	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
-	    (d6 == DR6_RESERVED) && (d7 == 0x400))
+	    (d6 == DR6_RESERVED) && (d7 == DR7_FIXED_1))
 		return;
 
 	printk("%sDR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -132,7 +132,7 @@ void __show_regs(struct pt_regs *regs, e
 
 	/* Only print out debug registers if they are in their non-default state. */
 	if (!((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
-	    (d6 == DR6_RESERVED) && (d7 == 0x400))) {
+	    (d6 == DR6_RESERVED) && (d7 == DR7_FIXED_1))) {
 		printk("%sDR0: %016lx DR1: %016lx DR2: %016lx\n",
 		       log_lvl, d0, d1, d2);
 		printk("%sDR3: %016lx DR6: %016lx DR7: %016lx\n",
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10979,7 +10979,7 @@ static int vcpu_enter_guest(struct kvm_v
 		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 
 	if (unlikely(vcpu->arch.switch_db_regs)) {
-		set_debugreg(0, 7);
+		set_debugreg(DR7_FIXED_1, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
 		set_debugreg(vcpu->arch.eff_db[2], 2);
@@ -10988,7 +10988,7 @@ static int vcpu_enter_guest(struct kvm_v
 		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
 			kvm_x86_call(set_dr6)(vcpu, vcpu->arch.dr6);
 	} else if (unlikely(hw_breakpoint_active())) {
-		set_debugreg(0, 7);
+		set_debugreg(DR7_FIXED_1, 7);
 	}
 
 	vcpu->arch.host_debugctl = get_debugctlmsr();


