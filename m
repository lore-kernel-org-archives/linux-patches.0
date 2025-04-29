Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132822472B9;
	Tue, 29 Apr 2025 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949116; cv=none; b=DT6uxYhDXeezpaXLnH1FCdD6jEAvZm/xpXpX2se/gg5DsHlTrmOs/61fqjxIcN8fZvzghFdOCxn8ho4+NEziRavQ0OJHKGYw80vLfm50Xott9zk726LNwp/Vmqf1Rpavt7wgGF0Aw2yHtA+RltDHieAg4v6gTDzOPMthwWZjRDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949116; c=relaxed/simple;
	bh=yB9smf1BhpI1O6Y8VmKuY/8GHhQoiLuPmYkC4BaSBMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAbT+FuzzQ/0d0Pzl19wJSLSejqwomAoH1hcD8pZCcTnlS8qROJ9PId7xfuu9orK3PWCvKNgO9XEWmW7FtmYlPaLeWCCKdjBazyKlS0Qm7MtGuzrr5+g3dmWqZ0iXwFWH5bXqOfeObGWNGuvyZ69iMyavh7OSg6nDe4EEAc0Py0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryfothja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryfothja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F317C4CEE3;
	Tue, 29 Apr 2025 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949115;
	bh=yB9smf1BhpI1O6Y8VmKuY/8GHhQoiLuPmYkC4BaSBMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryfothjaoGg7l5XYzejs2LHn8Qo7TbmE/S8533w4HcUis1Dt4iX9yE6p/iyBVLE4Z
	 QedvpS5NiFPDcs31ArboJPPO1dqAvlZg1lFYtFMdhWnvKRx+y/rI6Yarjy540heg0k
	 dmH4niEMmJeKJSC/oRWn0tbqa/tyyEKhCTztAOOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5.15 189/373] arm64/fpsimd: Track the saved FPSIMD state type separately to TIF_SVE
Date: Tue, 29 Apr 2025 18:41:06 +0200
Message-ID: <20250429161130.938015837@linuxfoundation.org>
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

[ Upstream commit baa8515281b30861cff3da7db70662d2a25c6440 ]

When we save the state for the floating point registers this can be done
in the form visible through either the FPSIMD V registers or the SVE Z and
P registers. At present we track which format is currently used based on
TIF_SVE and the SME streaming mode state but particularly in the SVE case
this limits our options for optimising things, especially around syscalls.
Introduce a new enum which we place together with saved floating point
state in both thread_struct and the KVM guest state which explicitly
states which format is active and keep it up to date when we change it.

At present we do not use this state except to verify that it has the
expected value when loading the state, future patches will introduce
functional changes.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115094640.112848-3-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: fix conflicts due to earlier backports ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/fpsimd.h    |    3 +
 arch/arm64/include/asm/kvm_host.h  |   12 +++++++
 arch/arm64/include/asm/processor.h |    6 +++
 arch/arm64/kernel/fpsimd.c         |   58 +++++++++++++++++++++++++++----------
 arch/arm64/kernel/process.c        |    3 +
 arch/arm64/kernel/ptrace.c         |    3 +
 arch/arm64/kernel/signal.c         |    3 +
 arch/arm64/kvm/fpsimd.c            |    3 +
 8 files changed, 74 insertions(+), 17 deletions(-)

--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -47,7 +47,8 @@ extern void fpsimd_update_current_state(
 extern void fpsimd_kvm_prepare(void);
 
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
-				     void *sve_state, unsigned int sve_vl);
+				     void *sve_state, unsigned int sve_vl,
+				     enum fp_type *type);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_save_and_flush_cpu_state(void);
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -280,7 +280,19 @@ struct vcpu_reset_state {
 
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
+
+	/*
+	 * Guest floating point state
+	 *
+	 * The architecture has two main floating point extensions,
+	 * the original FPSIMD and SVE.  These have overlapping
+	 * register views, with the FPSIMD V registers occupying the
+	 * low 128 bits of the SVE Z registers.  When the core
+	 * floating point code saves the register state of a task it
+	 * records which view it saved in fp_type.
+	 */
 	void *sve_state;
+	enum fp_type fp_type;
 	unsigned int sve_max_vl;
 
 	/* Stage 2 paging state used by the hardware on next switch */
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -115,6 +115,11 @@ struct debug_info {
 #endif
 };
 
+enum fp_type {
+	FP_STATE_FPSIMD,
+	FP_STATE_SVE,
+};
+
 struct cpu_context {
 	unsigned long x19;
 	unsigned long x20;
@@ -145,6 +150,7 @@ struct thread_struct {
 		struct user_fpsimd_state fpsimd_state;
 	} uw;
 
+	enum fp_type		fp_type;	/* registers FPSIMD or SVE? */
 	unsigned int		fpsimd_cpu;
 	void			*sve_state;	/* SVE registers, if any */
 	unsigned int		sve_vl;		/* SVE vector length */
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -117,6 +117,7 @@ struct fpsimd_last_state_struct {
 	struct user_fpsimd_state *st;
 	void *sve_state;
 	unsigned int sve_vl;
+	enum fp_type *fp_type;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -243,14 +244,6 @@ static void sve_free(struct task_struct
  *    The task can execute SVE instructions while in userspace without
  *    trapping to the kernel.
  *
- *    When stored, Z0-Z31 (incorporating Vn in bits[127:0] or the
- *    corresponding Zn), P0-P15 and FFR are encoded in in
- *    task->thread.sve_state, formatted appropriately for vector
- *    length task->thread.sve_vl.
- *
- *    task->thread.sve_state must point to a valid buffer at least
- *    sve_state_size(task) bytes in size.
- *
  *    During any syscall, the kernel may optionally clear TIF_SVE and
  *    discard the vector state except for the FPSIMD subset.
  *
@@ -260,7 +253,15 @@ static void sve_free(struct task_struct
  *    do_sve_acc() to be called, which does some preparation and then
  *    sets TIF_SVE.
  *
- *    When stored, FPSIMD registers V0-V31 are encoded in
+ * During any syscall, the kernel may optionally clear TIF_SVE and
+ * discard the vector state except for the FPSIMD subset.
+ *
+ * The data will be stored in one of two formats:
+ *
+ *  * FPSIMD only - FP_STATE_FPSIMD:
+ *
+ *    When the FPSIMD only state stored task->thread.fp_type is set to
+ *    FP_STATE_FPSIMD, the FPSIMD registers V0-V31 are encoded in
  *    task->thread.uw.fpsimd_state; bits [max : 128] for each of Z0-Z31 are
  *    logically zero but not stored anywhere; P0-P15 and FFR are not
  *    stored and have unspecified values from userspace's point of
@@ -270,6 +271,19 @@ static void sve_free(struct task_struct
  *    task->thread.sve_state does not need to be non-NULL, valid or any
  *    particular size: it must not be dereferenced.
  *
+ *  * SVE state - FP_STATE_SVE:
+ *
+ *    When the full SVE state is stored task->thread.fp_type is set to
+ *    FP_STATE_SVE and Z0-Z31 (incorporating Vn in bits[127:0] or the
+ *    corresponding Zn), P0-P15 and FFR are encoded in in
+ *    task->thread.sve_state, formatted appropriately for vector
+ *    length task->thread.sve_vl or, if SVCR.SM is set,
+ *    task->thread.sme_vl. The storage for the vector registers in
+ *    task->thread.uw.fpsimd_state should be ignored.
+ *
+ *    task->thread.sve_state must point to a valid buffer at least
+ *    sve_state_size(task) bytes in size.
+ *
  *  * FPSR and FPCR are always stored in task->thread.uw.fpsimd_state
  *    irrespective of whether TIF_SVE is clear or set, since these are
  *    not vector length dependent.
@@ -287,12 +301,15 @@ static void task_fpsimd_load(void)
 	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!have_cpu_fpsimd_context());
 
-	if (IS_ENABLED(CONFIG_ARM64_SVE) && test_thread_flag(TIF_SVE))
+	if (IS_ENABLED(CONFIG_ARM64_SVE) && test_thread_flag(TIF_SVE)) {
+		WARN_ON_ONCE(current->thread.fp_type != FP_STATE_SVE);
 		sve_load_state(sve_pffr(&current->thread),
 			       &current->thread.uw.fpsimd_state.fpsr,
 			       sve_vq_from_vl(current->thread.sve_vl) - 1);
-	else
+	} else {
+		WARN_ON_ONCE(current->thread.fp_type != FP_STATE_FPSIMD);
 		fpsimd_load_state(&current->thread.uw.fpsimd_state);
+	}
 }
 
 /*
@@ -324,8 +341,11 @@ static void fpsimd_save(void)
 			sve_save_state((char *)last->sve_state +
 						sve_ffr_offset(last->sve_vl),
 				       &last->st->fpsr);
-		} else
+			*last->fp_type = FP_STATE_SVE;
+		} else {
 			fpsimd_save_state(last->st);
+			*last->fp_type = FP_STATE_FPSIMD;
+		}
 	}
 }
 
@@ -624,8 +644,10 @@ int sve_set_vector_length(struct task_st
 	}
 
 	fpsimd_flush_task_state(task);
-	if (test_and_clear_tsk_thread_flag(task, TIF_SVE))
+	if (test_and_clear_tsk_thread_flag(task, TIF_SVE)) {
 		sve_to_fpsimd(task);
+		task->thread.fp_type = FP_STATE_FPSIMD;
+	}
 
 	if (task == current)
 		put_cpu_fpsimd_context();
@@ -1079,6 +1101,8 @@ void fpsimd_flush_thread(void)
 			current->thread.sve_vl_onexec = 0;
 	}
 
+	current->thread.fp_type = FP_STATE_FPSIMD;
+
 	put_cpu_fpsimd_context();
 }
 
@@ -1125,8 +1149,10 @@ void fpsimd_kvm_prepare(void)
 	 */
 	get_cpu_fpsimd_context();
 
-	if (test_and_clear_thread_flag(TIF_SVE))
+	if (test_and_clear_thread_flag(TIF_SVE)) {
 		sve_to_fpsimd(current);
+		current->thread.fp_type = FP_STATE_FPSIMD;
+	}
 
 	put_cpu_fpsimd_context();
 }
@@ -1145,6 +1171,7 @@ static void fpsimd_bind_task_to_cpu(void
 	last->st = &current->thread.uw.fpsimd_state;
 	last->sve_state = current->thread.sve_state;
 	last->sve_vl = current->thread.sve_vl;
+	last->fp_type = &current->thread.fp_type;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	if (system_supports_sve()) {
@@ -1159,7 +1186,7 @@ static void fpsimd_bind_task_to_cpu(void
 }
 
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
-			      unsigned int sve_vl)
+			      unsigned int sve_vl, enum fp_type *type)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1170,6 +1197,7 @@ void fpsimd_bind_state_to_cpu(struct use
 	last->st = st;
 	last->sve_state = sve_state;
 	last->sve_vl = sve_vl;
+	last->fp_type = type;
 }
 
 /*
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -307,6 +307,9 @@ int arch_dup_task_struct(struct task_str
 	dst->thread.sve_state = NULL;
 	clear_tsk_thread_flag(dst, TIF_SVE);
 
+
+	dst->thread.fp_type = FP_STATE_FPSIMD;
+
 	/* clear any pending asynchronous tag fault raised by the parent */
 	clear_tsk_thread_flag(dst, TIF_MTE_ASYNC_FAULT);
 
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -829,6 +829,7 @@ static int sve_set(struct task_struct *t
 		ret = __fpr_set(target, regset, pos, count, kbuf, ubuf,
 				SVE_PT_FPSIMD_OFFSET);
 		clear_tsk_thread_flag(target, TIF_SVE);
+		target->thread.fp_type = FP_STATE_FPSIMD;
 		goto out;
 	}
 
@@ -848,6 +849,7 @@ static int sve_set(struct task_struct *t
 	if (!target->thread.sve_state) {
 		ret = -ENOMEM;
 		clear_tsk_thread_flag(target, TIF_SVE);
+		target->thread.fp_type = FP_STATE_FPSIMD;
 		goto out;
 	}
 
@@ -858,6 +860,7 @@ static int sve_set(struct task_struct *t
 	 */
 	fpsimd_sync_to_sve(target);
 	set_tsk_thread_flag(target, TIF_SVE);
+	target->thread.fp_type = FP_STATE_SVE;
 
 	BUILD_BUG_ON(SVE_PT_SVE_OFFSET != sizeof(header));
 	start = SVE_PT_SVE_OFFSET;
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -207,6 +207,7 @@ static int restore_fpsimd_context(struct
 	__get_user_error(fpsimd.fpcr, &ctx->fpcr, err);
 
 	clear_thread_flag(TIF_SVE);
+	current->thread.fp_type = FP_STATE_FPSIMD;
 
 	/* load the hardware registers from the fpsimd_state structure */
 	if (!err)
@@ -271,6 +272,7 @@ static int restore_sve_fpsimd_context(st
 
 	if (sve.head.size <= sizeof(*user->sve)) {
 		clear_thread_flag(TIF_SVE);
+		current->thread.fp_type = FP_STATE_FPSIMD;
 		goto fpsimd_only;
 	}
 
@@ -303,6 +305,7 @@ static int restore_sve_fpsimd_context(st
 		return -EFAULT;
 
 	set_thread_flag(TIF_SVE);
+	current->thread.fp_type = FP_STATE_SVE;
 
 fpsimd_only:
 	/* copy the FP and status/control registers */
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -95,7 +95,8 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
 		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fp_regs,
 					 vcpu->arch.sve_state,
-					 vcpu->arch.sve_max_vl);
+					 vcpu->arch.sve_max_vl,
+					 &vcpu->arch.fp_type);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));


