Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65484C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAFCC433C1;
	Mon, 14 Nov 2022 13:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431304;
	bh=s9fEc55BXvwXXTcLh4CpyL2TfaxJOw8NP0hSe6ox98s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qi/nInwyFK8eEhcrun72ZyYGmDq1ud/rL4achbHTlCp1w9NX2rgBtMGOawSHYo0Cf
	 wsUriZ5TSwLD0MlHEKP7M5fm04mncjbenVQ13ansvGE5XhVTu9fhpVIe3YwAzYX4Ct
	 1tVg0iPbG3MBmmk09v4ULP4L0/D8sAlft+lsyQXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 169/190] KVM: SVM: adjust register allocation for __svm_vcpu_run()
Date: Mon, 14 Nov 2022 13:46:33 +0100
Message-Id: <20221114124506.243159017@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Bonzini <pbonzini@redhat.com>

commit f7ef280132f9bf6f82acf5aa5c3c837206eef501 upstream.

32-bit ABI uses RAX/RCX/RDX as its argument registers, so they are in
the way of instructions that hardcode their operands such as RDMSR/WRMSR
or VMLOAD/VMRUN/VMSAVE.

In preparation for moving vmload/vmsave to __svm_vcpu_run(), keep
the pointer to the struct vcpu_svm in %rdi.  In particular, it is now
possible to load svm->vmcb01.pa in %rax without clobbering the struct
vcpu_svm pointer.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/vmenter.S |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -54,29 +54,29 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* Save @vmcb. */
 	push %_ASM_ARG1
 
-	/* Move @svm to RAX. */
-	mov %_ASM_ARG2, %_ASM_AX
+	/* Move @svm to RDI. */
+	mov %_ASM_ARG2, %_ASM_DI
+
+	/* "POP" @vmcb to RAX. */
+	pop %_ASM_AX
 
 	/* Load guest registers. */
-	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
-	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
-	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
-	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
-	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
-	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
+	mov VCPU_RCX(%_ASM_DI), %_ASM_CX
+	mov VCPU_RDX(%_ASM_DI), %_ASM_DX
+	mov VCPU_RBX(%_ASM_DI), %_ASM_BX
+	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
+	mov VCPU_RSI(%_ASM_DI), %_ASM_SI
 #ifdef CONFIG_X86_64
-	mov VCPU_R8 (%_ASM_AX),  %r8
-	mov VCPU_R9 (%_ASM_AX),  %r9
-	mov VCPU_R10(%_ASM_AX), %r10
-	mov VCPU_R11(%_ASM_AX), %r11
-	mov VCPU_R12(%_ASM_AX), %r12
-	mov VCPU_R13(%_ASM_AX), %r13
-	mov VCPU_R14(%_ASM_AX), %r14
-	mov VCPU_R15(%_ASM_AX), %r15
+	mov VCPU_R8 (%_ASM_DI),  %r8
+	mov VCPU_R9 (%_ASM_DI),  %r9
+	mov VCPU_R10(%_ASM_DI), %r10
+	mov VCPU_R11(%_ASM_DI), %r11
+	mov VCPU_R12(%_ASM_DI), %r12
+	mov VCPU_R13(%_ASM_DI), %r13
+	mov VCPU_R14(%_ASM_DI), %r14
+	mov VCPU_R15(%_ASM_DI), %r15
 #endif
-
-	/* "POP" @vmcb to RAX. */
-	pop %_ASM_AX
+	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
 	/* Enter guest mode */
 	sti


