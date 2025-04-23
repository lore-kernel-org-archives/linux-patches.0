Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D47D283CA3;
	Wed, 23 Apr 2025 15:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422194; cv=none; b=DrcL1yovJO/WIuKFbMrypKbpHkq0M4XrkJZe80SE604UzCVf2pfVeHsfPKnOzUAfExeydBJmD34vhynjC4SPkE9HhytCtBSKTkBhKMc1PeacChp7CJ+6kxwtYXb/ThmjWuKcaThHZaQS4qHQHSN7EfZNw7kY4bLSIj2FLupOX9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422194; c=relaxed/simple;
	bh=hhFFYoxG622UhCS3jhy1chmqSM9DirIZ+vBmlC6Sk9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eC2r5qLfFGyfwhh5f1KvLaYB7xRaJUMWQk+hWbMIhYGfwQafpOBRbA+PzkuAjrRFaDtMinGHWgnxCF4QUlzI27TBMpls0qerL8Kca3T7K3do81SBHmJ5fg73H8oasgHFF+MirSNX9s4pwsay51neVTsmvOnIee9MT9qcMdWNLxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaNjA2OC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaNjA2OC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BA2C4CEE2;
	Wed, 23 Apr 2025 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422193;
	bh=hhFFYoxG622UhCS3jhy1chmqSM9DirIZ+vBmlC6Sk9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaNjA2OCBTnn41KPPWtzFkeAwNUacmDAwgDavlcP5VXd/BjqAGEorlae/3ZoJKBtF
	 qUms+L3YIU95H4ncnE45gi/2PUAOPMeDuYl+ioSv0p39yfGjOwjHg08WXQ3m+DcIsz
	 Cew9T3gWVSX8INVTKOD9ertJ4NDeRtmys1Pq93E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.1 253/291] KVM: arm64: Refactor exit handlers
Date: Wed, 23 Apr 2025 16:44:02 +0200
Message-ID: <20250423142634.768666265@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 9b66195063c5a145843547b1d692bd189be85287 ]

The hyp exit handling logic is largely shared between VHE and nVHE/hVHE,
with common logic in arch/arm64/kvm/hyp/include/hyp/switch.h. The code
in the header depends on function definitions provided by
arch/arm64/kvm/hyp/vhe/switch.c and arch/arm64/kvm/hyp/nvhe/switch.c
when they include the header.

This is an unusual header dependency, and prevents the use of
arch/arm64/kvm/hyp/include/hyp/switch.h in other files as this would
result in compiler warnings regarding missing definitions, e.g.

| In file included from arch/arm64/kvm/hyp/nvhe/hyp-main.c:8:
| ./arch/arm64/kvm/hyp/include/hyp/switch.h:733:31: warning: 'kvm_get_exit_handler_array' used but never defined
|   733 | static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu);
|       |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~
| ./arch/arm64/kvm/hyp/include/hyp/switch.h:735:13: warning: 'early_exit_filter' used but never defined
|   735 | static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code);
|       |             ^~~~~~~~~~~~~~~~~

Refactor the logic such that the header doesn't depend on anything from
the C files. There should be no functional change as a result of this
patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-7-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |   30 ++++++------------------------
 arch/arm64/kvm/hyp/nvhe/switch.c        |   27 +++++++++++++++------------
 arch/arm64/kvm/hyp/vhe/switch.c         |    8 +++-----
 3 files changed, 24 insertions(+), 41 deletions(-)

--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -398,23 +398,16 @@ static bool kvm_hyp_handle_dabt_low(stru
 
 typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
 
-static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu);
-
-static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code);
-
 /*
  * Allow the hypervisor to handle the exit with an exit handler if it has one.
  *
  * Returns true if the hypervisor handled the exit, and control should go back
  * to the guest, or false if it hasn't.
  */
-static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code,
+				       const exit_handler_fn *handlers)
 {
-	const exit_handler_fn *handlers = kvm_get_exit_handler_array(vcpu);
-	exit_handler_fn fn;
-
-	fn = handlers[kvm_vcpu_trap_get_class(vcpu)];
-
+	exit_handler_fn fn = handlers[kvm_vcpu_trap_get_class(vcpu)];
 	if (fn)
 		return fn(vcpu, exit_code);
 
@@ -444,20 +437,9 @@ static inline void synchronize_vcpu_psta
  * the guest, false when we should restore the host state and return to the
  * main run loop.
  */
-static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool __fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code,
+				      const exit_handler_fn *handlers)
 {
-	/*
-	 * Save PSTATE early so that we can evaluate the vcpu mode
-	 * early on.
-	 */
-	synchronize_vcpu_pstate(vcpu, exit_code);
-
-	/*
-	 * Check whether we want to repaint the state one way or
-	 * another.
-	 */
-	early_exit_filter(vcpu, exit_code);
-
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
@@ -487,7 +469,7 @@ static inline bool fixup_guest_exit(stru
 		goto exit;
 
 	/* Check if there's an exit handler and allow it to handle the exit. */
-	if (kvm_hyp_handle_exit(vcpu, exit_code))
+	if (kvm_hyp_handle_exit(vcpu, exit_code, handlers))
 		goto guest;
 exit:
 	/* Return to the host kernel and handle the exit */
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -209,21 +209,22 @@ static const exit_handler_fn *kvm_get_ex
 	return hyp_exit_handlers;
 }
 
-/*
- * Some guests (e.g., protected VMs) are not be allowed to run in AArch32.
- * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
- * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
- * hypervisor spots a guest in such a state ensure it is handled, and don't
- * trust the host to spot or fix it.  The check below is based on the one in
- * kvm_arch_vcpu_ioctl_run().
- *
- * Returns false if the guest ran in AArch32 when it shouldn't have, and
- * thus should exit to the host, or true if a the guest run loop can continue.
- */
-static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	const exit_handler_fn *handlers = kvm_get_exit_handler_array(vcpu);
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 
+	synchronize_vcpu_pstate(vcpu, exit_code);
+
+	/*
+	 * Some guests (e.g., protected VMs) are not be allowed to run in
+	 * AArch32.  The ARMv8 architecture does not give the hypervisor a
+	 * mechanism to prevent a guest from dropping to AArch32 EL0 if
+	 * implemented by the CPU. If the hypervisor spots a guest in such a
+	 * state ensure it is handled, and don't trust the host to spot or fix
+	 * it.  The check below is based on the one in
+	 * kvm_arch_vcpu_ioctl_run().
+	 */
 	if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu)) {
 		/*
 		 * As we have caught the guest red-handed, decide that it isn't
@@ -236,6 +237,8 @@ static void early_exit_filter(struct kvm
 		*exit_code &= BIT(ARM_EXIT_WITH_SERROR_BIT);
 		*exit_code |= ARM_EXCEPTION_IL;
 	}
+
+	return __fixup_guest_exit(vcpu, exit_code, handlers);
 }
 
 /* Switch to the guest for legacy non-VHE systems */
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -114,13 +114,11 @@ static const exit_handler_fn hyp_exit_ha
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
+static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	return hyp_exit_handlers;
-}
+	synchronize_vcpu_pstate(vcpu, exit_code);
 
-static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
-{
+	return __fixup_guest_exit(vcpu, exit_code, hyp_exit_handlers);
 }
 
 /* Switch to the guest for VHE systems running in EL2 */


