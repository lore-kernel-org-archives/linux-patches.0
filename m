Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D819379DCA;
	Mon,  4 Mar 2024 21:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588515; cv=none; b=Fvfn0JIBaTsMciuZFjr+7lsnSer9UvV7yr8K9ix38WzcABPz/yk9PqrgLflmD+ls+X/RCb66JlxpjC9N0QWRkSul+L/UV78zXm809Cq3KySH/IM0wWNqYNLn/WEXhpU1HzzIOlk33Pu72Nvz0KT0UMRTaoX9qkss/NSf9foVnWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588515; c=relaxed/simple;
	bh=+t9jAqwQn+lJSk/fjJV0fBuvR2fTZMy4bgfnAx5eKnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwCQgv70AowD7Wf8Tg2bxpcT5eI7iKy5/diEd4bOxLPRIA5rGYmewz0D59C9oETBruCSi8QU16o/J/RwmJ3J5AqahT3HI8s23j20abukVcEsjDQCoWnUnc5b1poKTk8ZT23HuapajP7OXNgmmN3Fm6uFqDRJHYmOorxBHpt+NCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQHiwhtc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQHiwhtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66072C433F1;
	Mon,  4 Mar 2024 21:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588515;
	bh=+t9jAqwQn+lJSk/fjJV0fBuvR2fTZMy4bgfnAx5eKnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQHiwhtciwAJMbmdR6nrKffh0hgewCf0E26dxI1uJHd+9ycwGxuTyNRpo/WnBJQYd
	 KoSQZOhXV4rfpTcaW+dJonS5NgKkJzIN0QU+OiVfbWyYr6JM3z5V84RDJ9eK3N0E5n
	 ZvwLheRhuuwtEWLApZNmxQGDf8IDO61eFOn1KZBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 137/143] KVM/VMX: Move VERW closer to VMentry for MDS mitigation
Date: Mon,  4 Mar 2024 21:24:17 +0000
Message-ID: <20240304211554.291959903@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-6-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmenter.S |    3 +++
 arch/x86/kvm/vmx/vmx.c     |   20 ++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -161,6 +161,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
+	/* Clobbers EFLAGS.ZF */
+	CLEAR_CPU_BUFFERS
+
 	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
 	jnc .Lvmlaunch
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -387,7 +387,16 @@ static __always_inline void vmx_enable_f
 
 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
 {
-	vmx->disable_fb_clear = (host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
+	/*
+	 * Disable VERW's behavior of clearing CPU buffers for the guest if the
+	 * CPU isn't affected by MDS/TAA, and the host hasn't forcefully enabled
+	 * the mitigation. Disabling the clearing behavior provides a
+	 * performance boost for guests that aren't aware that manually clearing
+	 * CPU buffers is unnecessary, at the cost of MSR accesses on VM-Entry
+	 * and VM-Exit.
+	 */
+	vmx->disable_fb_clear = !cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF) &&
+				(host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
 				!boot_cpu_has_bug(X86_BUG_MDS) &&
 				!boot_cpu_has_bug(X86_BUG_TAA);
 
@@ -7226,11 +7235,14 @@ static noinstr void vmx_vcpu_enter_exit(
 
 	guest_state_enter_irqoff();
 
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


