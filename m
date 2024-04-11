Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8602763A2;
	Thu, 11 Apr 2024 10:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831859; cv=none; b=cuNuzBWCBRXeSB9UbYn0yE82HF63FuhYEUtvqoaN93DuKahUqIXggY/9fFPewCtpwQwKNU8HZf2y++ifePtcCgHBPm1ykdyxW8kb/5uRHoeKOLoooG0E8hS3uy5fPd2nToJplHE1A7iX3xsEcm7QDg3tMutDop1Fu18fBGHexho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831859; c=relaxed/simple;
	bh=XaFOv2Hby/3JHgy+nhPdw5XZgc6yrAdFVXkQWvQEJXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5Cs3syCtgL1n0qgGvNqt9RhZ7e7hZ4mRDn2IgMvBN1PF78zAVTDOD9TTDkVJu3x9cNb1hqdc2TQTwlen1UiZi5zHptb+kaUm5SF1gdksry3czDZgRYj/Nb4YzCCZE1NKk7E7fteR8w2x5NOMfFZTV21b8WZAwcabOoy+p5FtBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12LRXLcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12LRXLcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA4CC433F1;
	Thu, 11 Apr 2024 10:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831859;
	bh=XaFOv2Hby/3JHgy+nhPdw5XZgc6yrAdFVXkQWvQEJXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12LRXLcUARKV9dN1W+cJA1Yr/zjLD7g1z30+Sa0mBTXUkK1Z1eZ2J4GD9o/sskhjt
	 NDR32IgVKOzS9E5/aKVsUhX9CGHrkrf9u2iAOLEIwX002lkexxcovlCGGNTeY3VfnL
	 9ytN8gvdJEbGNZ5ZNSjGFleuAUts0yxdPC6LjcP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: [PATCH 5.10 143/294] KVM/VMX: Use BT+JNC, i.e. EFLAGS.CF to select VMRESUME vs. VMLAUNCH
Date: Thu, 11 Apr 2024 11:55:06 +0200
Message-ID: <20240411095439.959936805@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

From: Sean Christopherson <seanjc@google.com>

commit 706a189dcf74d3b3f955e9384785e726ed6c7c80 upstream.

Use EFLAGS.CF instead of EFLAGS.ZF to track whether to use VMRESUME versus
VMLAUNCH.  Freeing up EFLAGS.ZF will allow doing VERW, which clobbers ZF,
for MDS mitigations as late as possible without needing to duplicate VERW
for both paths.

  [ pawan: resolved merge conflict in __vmx_vcpu_run in backport. ]

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-5-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/run_flags.h |    7 +++++--
 arch/x86/kvm/vmx/vmenter.S   |    6 +++---
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/vmx/run_flags.h
+++ b/arch/x86/kvm/vmx/run_flags.h
@@ -2,7 +2,10 @@
 #ifndef __KVM_X86_VMX_RUN_FLAGS_H
 #define __KVM_X86_VMX_RUN_FLAGS_H
 
-#define VMX_RUN_VMRESUME	(1 << 0)
-#define VMX_RUN_SAVE_SPEC_CTRL	(1 << 1)
+#define VMX_RUN_VMRESUME_SHIFT		0
+#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT	1
+
+#define VMX_RUN_VMRESUME		BIT(VMX_RUN_VMRESUME_SHIFT)
+#define VMX_RUN_SAVE_SPEC_CTRL		BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
 
 #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -77,7 +77,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov (%_ASM_SP), %_ASM_AX
 
 	/* Check if vmlaunch or vmresume is needed */
-	testb $VMX_RUN_VMRESUME, %bl
+	bt   $VMX_RUN_VMRESUME_SHIFT, %bx
 
 	/* Load guest registers.  Don't clobber flags. */
 	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
@@ -99,8 +99,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
-	/* Check EFLAGS.ZF from 'testb' above */
-	jz .Lvmlaunch
+	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
+	jnc .Lvmlaunch
 
 	/*
 	 * After a successful VMRESUME/VMLAUNCH, control flow "magically"


