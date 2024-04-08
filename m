Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AA72E405;
	Mon,  8 Apr 2024 13:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582571; cv=none; b=QhIkKVm8smg1Ta0a7ikZENL3u5rMQJ5wRPfpLbQaOqPj0FrKIxMpLFh678sRg0P62dWznufDAx2nT0YfhcfPi9K7Dlh98YX/OyCdPwK6SsocziZDWA+3uFI1uqiQehZFS9PiAifQJpXEFjclZsKuxm7f3jyvvGWpK8H8oMYQVU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582571; c=relaxed/simple;
	bh=fphR6i2459EuaPZxRNe5UYlD4oEFTMsQeHR53IfANEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMY2B4fLssyNQKQirZ6TI2OoEzv511+wKv5rD7oUqGWFRfQ8gYRJvtv+KjIhiMggxJ4ekQ8jRHE7iDek+jF1pnywcVVaknP14o7lP7Ms951o1lagxLwvxSdr8HZslcLjJ3h/Xo4ywQ8+cnnBqIT6/v7M5nITCUouQtWwbRKVeVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhV8kCdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhV8kCdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF32C433C7;
	Mon,  8 Apr 2024 13:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582570;
	bh=fphR6i2459EuaPZxRNe5UYlD4oEFTMsQeHR53IfANEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhV8kCdZ0hLJpYEPcDzj1cjw0Nswf8OGnNE2ktZRBRyhd0fj5VgqOMx/zc0CXNyCq
	 YlemVYvY4OIwE4K5lompljBT+wOLleF4r6ZJgKzFBXWkgv1nCxNx+v32Iy7Gk88RbF
	 Go+zTeR3oD7VB9AIXqyc96hZZIhkPy5p5+s2Gfjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 156/690] KVM/VMX: Move VERW closer to VMentry for MDS mitigation
Date: Mon,  8 Apr 2024 14:50:22 +0200
Message-ID: <20240408125405.175237747@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 43fb862de8f628c5db5e96831c915b9aebf62d33 upstream.

During VMentry VERW is executed to mitigate MDS. After VERW, any memory
access like register push onto stack may put host data in MDS affected
CPU buffers. A guest can then use MDS to sample host data.

Although likelihood of secrets surviving in registers at current VERW
callsite is less, but it can't be ruled out. Harden the MDS mitigation
by moving the VERW mitigation late in VMentry path.

Note that VERW for MMIO Stale Data mitigation is unchanged because of
the complexity of per-guest conditional VERW which is not easy to handle
that late in asm with no GPRs available. If the CPU is also affected by
MDS, VERW is unconditionally executed late in asm regardless of guest
having MMIO access.

  [ pawan: conflict resolved in backport ]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-6-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmenter.S |    3 +++
 arch/x86/kvm/vmx/vmx.c     |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -99,6 +99,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
+	/* Clobbers EFLAGS.ZF */
+	CLEAR_CPU_BUFFERS
+
 	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
 	jnc .Lvmlaunch
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -398,7 +398,8 @@ static __always_inline void vmx_enable_f
 
 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
 {
-	vmx->disable_fb_clear = vmx_fb_clear_ctrl_available;
+	vmx->disable_fb_clear = !cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF) &&
+		vmx_fb_clear_ctrl_available;
 
 	/*
 	 * If guest will not execute VERW, there is no need to set FB_CLEAR_DIS
@@ -6747,11 +6748,14 @@ static noinstr void vmx_vcpu_enter_exit(
 {
 	kvm_guest_enter_irqoff();
 
-	/* L1D Flush includes CPU buffer clear to mitigate MDS */
+	/*
+	 * L1D Flush includes CPU buffer clear to mitigate MDS, but VERW
+	 * mitigation for MDS is done late in VMentry and is still
+	 * executed in spite of L1D Flush. This is because an extra VERW
+	 * should not matter much after the big hammer L1D Flush.
+	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
-		mds_clear_cpu_buffers();
 	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
 		 kvm_arch_has_assigned_device(vcpu->kvm))
 		mds_clear_cpu_buffers();


