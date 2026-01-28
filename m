Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F23D3093A8;
	Wed, 28 Jan 2026 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616008; cv=none; b=QKgibAljppODNML90TnJPpB57nez08qiAhVGag7WWDmQm6HJD07uvpMpxQgv6hZve/newg6ogJBpBzbhRGAK2j1x25WAUsDiJqyTS57q5FQBfWLWD5/FYjuqy8yDUAB1PHTyxoqGK6+KxXjj/qMiz2R2h6pCpHOjLsnjnKItsK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616008; c=relaxed/simple;
	bh=rprHAku0AAvzzm5u/28k78rVU4bs0Ba5jP/3QOog8hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iosl7sxjpzLO8/mIMmEu5mylnqDn1tuoYK60/oAG9LvmL4/RLb/F1vg351xs+NY021pElCJXQM218MvguHA4LK2yioZSFw63FRpIe4iUpbddcfSz34AEIszQH91un+vB4lB6s2pKLdf5EYxc4VIJdsocp97PYUAyRgfnsLv7w8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGpsFurA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGpsFurA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988F7C4CEF1;
	Wed, 28 Jan 2026 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616008;
	bh=rprHAku0AAvzzm5u/28k78rVU4bs0Ba5jP/3QOog8hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGpsFurAlhK0pjZXImQBX/MKoEyagHskZMYfQCnQl6hGFlSk8iUVGAGfkFKiHVrcJ
	 BPLx40Dd06mEMOfS4T0zQmi2wz07/gB94UrgK7jmzMymJ6YmUqP4M4lVX9hGlho7DL
	 aGNY9WiaGavfc5IH79xH6wLgEQ9o2ZfBWPTzh59A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 180/227] arm64/fpsimd: signal: Fix restoration of SVE context
Date: Wed, 28 Jan 2026 16:23:45 +0100
Message-ID: <20260128145350.925207006@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit d2907cbe9ea0a54cbe078076f9d089240ee1e2d9 upstream.

When SME is supported, Restoring SVE signal context can go wrong in a
few ways, including placing the task into an invalid state where the
kernel may read from out-of-bounds memory (and may potentially take a
fatal fault) and/or may kill the task with a SIGKILL.

(1) Restoring a context with SVE_SIG_FLAG_SM set can place the task into
    an invalid state where SVCR.SM is set (and sve_state is non-NULL)
    but TIF_SME is clear, consequently resuting in out-of-bounds memory
    reads and/or killing the task with SIGKILL.

    This can only occur in unusual (but legitimate) cases where the SVE
    signal context has either been modified by userspace or was saved in
    the context of another task (e.g. as with CRIU), as otherwise the
    presence of an SVE signal context with SVE_SIG_FLAG_SM implies that
    TIF_SME is already set.

    While in this state, task_fpsimd_load() will NOT configure SMCR_ELx
    (leaving some arbitrary value configured in hardware) before
    restoring SVCR and attempting to restore the streaming mode SVE
    registers from memory via sve_load_state(). As the value of
    SMCR_ELx.LEN may be larger than the task's streaming SVE vector
    length, this may read memory outside of the task's allocated
    sve_state, reading unrelated data and/or triggering a fault.

    While this can result in secrets being loaded into streaming SVE
    registers, these values are never exposed. As TIF_SME is clear,
    fpsimd_bind_task_to_cpu() will configure CPACR_ELx.SMEN to trap EL0
    accesses to streaming mode SVE registers, so these cannot be
    accessed directly at EL0. As fpsimd_save_user_state() verifies the
    live vector length before saving (S)SVE state to memory, no secret
    values can be saved back to memory (and hence cannot be observed via
    ptrace, signals, etc).

    When the live vector length doesn't match the expected vector length
    for the task, fpsimd_save_user_state() will send a fatal SIGKILL
    signal to the task. Hence the task may be killed after executing
    userspace for some period of time.

(2) Restoring a context with SVE_SIG_FLAG_SM clear does not clear the
    task's SVCR.SM. If SVCR.SM was set prior to restoring the context,
    then the task will be left in streaming mode unexpectedly, and some
    register state will be combined inconsistently, though the task will
    be left in legitimate state from the kernel's PoV.

    This can only occur in unusual (but legitimate) cases where ptrace
    has been used to set SVCR.SM after entry to the sigreturn syscall,
    as syscall entry clears SVCR.SM.

    In these cases, the the provided SVE register data will be loaded
    into the task's sve_state using the non-streaming SVE vector length
    and the FPSIMD registers will be merged into this using the
    streaming SVE vector length.

Fix (1) by setting TIF_SME when setting SVCR.SM. This also requires
ensuring that the task's sme_state has been allocated, but as this could
contain live ZA state, it should not be zeroed. Fix (2) by clearing
SVCR.SM when restoring a SVE signal context with SVE_SIG_FLAG_SM clear.

For consistency, I've pulled the manipulation of SVCR, TIF_SVE, TIF_SME,
and fp_type earlier, immediately after the allocation of
sve_state/sme_state, before the restore of the actual register state.
This makes it easier to ensure that these are always modified
consistently, even if a fault is taken while reading the register data
from the signal context. I do not expect any software to depend on the
exact state restored when a fault is taken while reading the context.

Fixes: 85ed24dad290 ("arm64/sme: Implement streaming SVE signal handling")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/signal.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -449,12 +449,28 @@ static int restore_sve_fpsimd_context(st
 	if (user->sve_size < SVE_SIG_CONTEXT_SIZE(vq))
 		return -EINVAL;
 
+	if (sm) {
+		sme_alloc(current, false);
+		if (!current->thread.sme_state)
+			return -ENOMEM;
+	}
+
 	sve_alloc(current, true);
 	if (!current->thread.sve_state) {
 		clear_thread_flag(TIF_SVE);
 		return -ENOMEM;
 	}
 
+	if (sm) {
+		current->thread.svcr |= SVCR_SM_MASK;
+		set_thread_flag(TIF_SME);
+	} else {
+		current->thread.svcr &= ~SVCR_SM_MASK;
+		set_thread_flag(TIF_SVE);
+	}
+
+	current->thread.fp_type = FP_STATE_SVE;
+
 	err = __copy_from_user(current->thread.sve_state,
 			       (char __user const *)user->sve +
 					SVE_SIG_REGS_OFFSET,
@@ -462,12 +478,6 @@ static int restore_sve_fpsimd_context(st
 	if (err)
 		return -EFAULT;
 
-	if (flags & SVE_SIG_FLAG_SM)
-		current->thread.svcr |= SVCR_SM_MASK;
-	else
-		set_thread_flag(TIF_SVE);
-	current->thread.fp_type = FP_STATE_SVE;
-
 	err = read_fpsimd_context(&fpsimd, user);
 	if (err)
 		return err;


