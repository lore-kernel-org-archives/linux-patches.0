Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B88722AE68;
	Tue, 29 Apr 2025 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949119; cv=none; b=HTLih0n1x2wKo9QBHH2XaQfpDGKKhXo0h+MKhSmyKZZwy8w6f/qbA/4lvU05OU2eB6S3Jj6Je3Mv1F42JRndnXGMWBCYaNepDcGw2Zh8w/L1+xWHX40OE0LDeHW9qyV7+m2WdTipU4nK3S23zaC5KMFdXY0yIBcIE6raMrrRsbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949119; c=relaxed/simple;
	bh=VDBe95ajWgIC8KXQs6Ntvo+nBTxcb3nRa/jMdrITgNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCbb7pIVdrBVr6jklZFXX5XeGPzxiFrIg4qu2FoGNg3bdysr7IirTVRwMeEAmF4EvR7Jaq5NktoWA2JXV8lI0sT+HLJBk28YBi/YdBjE+0q8d81MhDBIaP6HuJrG73yRdIo9WQuLz2JoPxfC0s4tUpzXpLVAckf8WNakHClZKSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ps2KvdMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ps2KvdMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F58C4CEE3;
	Tue, 29 Apr 2025 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949119;
	bh=VDBe95ajWgIC8KXQs6Ntvo+nBTxcb3nRa/jMdrITgNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ps2KvdMsUXX/QbKyxOeFRPgP4NUDaLAhcRkjhjopZzd69ncoLeBLNfzTdSLFrL4ZZ
	 JuE0bXe4unXl6TSH4s/GeyRF36PM4U2fSSTuZr0kiV2yz7Q8xQhkoSc5mW5erZSUAC
	 7RCcs9AcbbEQJWHfkgceCGjb5v8tD5Aw8P6Nwi7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5.15 190/373] arm64/fpsimd: Have KVM explicitly say which FP registers to save
Date: Tue, 29 Apr 2025 18:41:07 +0200
Message-ID: <20250429161130.980478217@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit deeb8f9a80fdae5a62525656d65c7070c28bd3a4 ]

In order to avoid needlessly saving and restoring the guest registers KVM
relies on the host FPSMID code to save the guest registers when we context
switch away from the guest. This is done by binding the KVM guest state to
the CPU on top of the task state that was originally there, then carefully
managing the TIF_SVE flag for the task to cause the host to save the full
SVE state when needed regardless of the needs of the host task. This works
well enough but isn't terribly direct about what is going on and makes it
much more complicated to try to optimise what we're doing with the SVE
register state.

Let's instead have KVM pass in the register state it wants saving when it
binds to the CPU. We introduce a new FP_STATE_CURRENT for use
during normal task binding to indicate that we should base our
decisions on the current task. This should not be used when
actually saving. Ideally we might want to use a separate enum for
the type to save but this enum and the enum values would then
need to be named which has problems with clarity and ambiguity.

In order to ease any future debugging that might be required this patch
does not actually update any of the decision making about what to save,
it merely starts tracking the new information and warns if the requested
state is not what we would otherwise have decided to save.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115094640.112848-4-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/fpsimd.h    |    2 
 arch/arm64/include/asm/processor.h |    1 
 arch/arm64/kernel/fpsimd.c         |   79 ++++++++++++++++++++++++++-----------
 arch/arm64/kvm/fpsimd.c            |   13 +++++-
 4 files changed, 70 insertions(+), 25 deletions(-)

--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -48,7 +48,7 @@ extern void fpsimd_kvm_prepare(void);
 
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl,
-				     enum fp_type *type);
+				     enum fp_type *type, enum fp_type to_save);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_save_and_flush_cpu_state(void);
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -116,6 +116,7 @@ struct debug_info {
 };
 
 enum fp_type {
+	FP_STATE_CURRENT,	/* Save based on current task state. */
 	FP_STATE_FPSIMD,
 	FP_STATE_SVE,
 };
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -118,6 +118,7 @@ struct fpsimd_last_state_struct {
 	void *sve_state;
 	unsigned int sve_vl;
 	enum fp_type *fp_type;
+	enum fp_type to_save;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -269,7 +270,8 @@ static void sve_free(struct task_struct
  *    but userspace is discouraged from relying on this.
  *
  *    task->thread.sve_state does not need to be non-NULL, valid or any
- *    particular size: it must not be dereferenced.
+ *    particular size: it must not be dereferenced and any data stored
+ *    there should be considered stale and not referenced.
  *
  *  * SVE state - FP_STATE_SVE:
  *
@@ -282,7 +284,9 @@ static void sve_free(struct task_struct
  *    task->thread.uw.fpsimd_state should be ignored.
  *
  *    task->thread.sve_state must point to a valid buffer at least
- *    sve_state_size(task) bytes in size.
+ *    sve_state_size(task) bytes in size. The data stored in
+ *    task->thread.uw.fpsimd_state.vregs should be considered stale
+ *    and not referenced.
  *
  *  * FPSR and FPCR are always stored in task->thread.uw.fpsimd_state
  *    irrespective of whether TIF_SVE is clear or set, since these are
@@ -321,32 +325,57 @@ static void fpsimd_save(void)
 	struct fpsimd_last_state_struct const *last =
 		this_cpu_ptr(&fpsimd_last_state);
 	/* set by fpsimd_bind_task_to_cpu() or fpsimd_bind_state_to_cpu() */
+	bool save_sve_regs = false;
+	unsigned long vl;
 
 	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!have_cpu_fpsimd_context());
 
-	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
-		if (IS_ENABLED(CONFIG_ARM64_SVE) &&
-		    test_thread_flag(TIF_SVE)) {
-			if (WARN_ON(sve_get_vl() != last->sve_vl)) {
-				/*
-				 * Can't save the user regs, so current would
-				 * re-enter user with corrupt state.
-				 * There's no way to recover, so kill it:
-				 */
-				force_signal_inject(SIGKILL, SI_KERNEL, 0, 0);
-				return;
-			}
-
-			sve_save_state((char *)last->sve_state +
-						sve_ffr_offset(last->sve_vl),
-				       &last->st->fpsr);
-			*last->fp_type = FP_STATE_SVE;
-		} else {
-			fpsimd_save_state(last->st);
-			*last->fp_type = FP_STATE_FPSIMD;
+	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
+		return;
+
+	if (IS_ENABLED(CONFIG_ARM64_SVE) &&
+	    test_thread_flag(TIF_SVE)) {
+		if (WARN_ON(sve_get_vl() != last->sve_vl)) {
+			/*
+			 * Can't save the user regs, so current would
+			 * re-enter user with corrupt state.
+			 * There's no way to recover, so kill it:
+			 */
+			force_signal_inject(SIGKILL, SI_KERNEL, 0, 0);
+			return;
 		}
 	}
+
+	if (test_thread_flag(TIF_SVE)) {
+		save_sve_regs = true;
+		vl = last->sve_vl;
+	}
+
+	/*
+	 * Validate that an explicitly specified state to save is
+	 * consistent with the task state.
+	 */
+	switch (last->to_save) {
+	case FP_STATE_CURRENT:
+		break;
+	case FP_STATE_FPSIMD:
+		WARN_ON_ONCE(save_sve_regs);
+		break;
+	case FP_STATE_SVE:
+		WARN_ON_ONCE(!save_sve_regs);
+		break;
+	}
+
+	if (IS_ENABLED(CONFIG_ARM64_SVE) && save_sve_regs) {
+		sve_save_state((char *)last->sve_state +
+			       sve_ffr_offset(last->sve_vl),
+			       &last->st->fpsr);
+		*last->fp_type = FP_STATE_SVE;
+	} else {
+		fpsimd_save_state(last->st);
+		*last->fp_type = FP_STATE_FPSIMD;
+	}
 }
 
 /*
@@ -987,6 +1016,7 @@ void do_sve_acc(unsigned long esr, struc
 	} else {
 		fpsimd_to_sve(current);
 		fpsimd_flush_task_state(current);
+		current->thread.fp_type = FP_STATE_SVE;
 	}
 
 	put_cpu_fpsimd_context();
@@ -1172,6 +1202,7 @@ static void fpsimd_bind_task_to_cpu(void
 	last->sve_state = current->thread.sve_state;
 	last->sve_vl = current->thread.sve_vl;
 	last->fp_type = &current->thread.fp_type;
+	last->to_save = FP_STATE_CURRENT;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	if (system_supports_sve()) {
@@ -1186,7 +1217,8 @@ static void fpsimd_bind_task_to_cpu(void
 }
 
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
-			      unsigned int sve_vl, enum fp_type *type)
+			      unsigned int sve_vl, enum fp_type *type,
+			      enum fp_type to_save)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1198,6 +1230,7 @@ void fpsimd_bind_state_to_cpu(struct use
 	last->sve_state = sve_state;
 	last->sve_vl = sve_vl;
 	last->fp_type = type;
+	last->to_save = to_save;
 }
 
 /*
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -90,13 +90,24 @@ void kvm_arch_vcpu_load_fp(struct kvm_vc
  */
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 {
+	enum fp_type fp_type;
+
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+		if (vcpu_has_sve(vcpu))
+			fp_type = FP_STATE_SVE;
+		else
+			fp_type = FP_STATE_FPSIMD;
+
+		/*
+		 * Currently we do not support SME guests so SVCR is
+		 * always 0 and we just need a variable to point to.
+		 */
 		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fp_regs,
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl,
-					 &vcpu->arch.fp_type);
+					 &vcpu->arch.fp_type, fp_type);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));


