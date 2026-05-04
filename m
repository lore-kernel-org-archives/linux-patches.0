Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50D13DE443;
	Mon,  4 May 2026 14:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903385; cv=none; b=aT/R9Z+9n55x1MnVeVkkq9I1/FH1QVhu9+7kxuC/E0O6NKwLwe/ffJu8tmQKqOcQ/HB3F0yqy79Fj0b4bg8dACX7WvaVQ8HnezzLncsGd2sbNCnwZQULe5VBQuaKP2v/zAmQpikhNpy4vVpFejXHOYSn1O/ECSGgAn7Kv+mwm00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903385; c=relaxed/simple;
	bh=QXIk368q8dN6epkzTJEwKG7woTxdkLzXMxJbCFxlE9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qitm7OYL6vR0r6lH9Ipj91RWP+S+SBGPE0KOIFlZUUC53GSLuSlQPaqcuct3U3ANNF3j+Edk5wNQg/figyLsXphGZ4j1Q2lRdJBD7VzehHnfF+scwo1pbKsy1N1chZanJJcpULj195fS1sqlL+FR7PG3oG77gaosNsk5ZmX1Bo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wy7/hEph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wy7/hEph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06737C2BCF4;
	Mon,  4 May 2026 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903385;
	bh=QXIk368q8dN6epkzTJEwKG7woTxdkLzXMxJbCFxlE9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wy7/hEphOZYI7H5Hi69wx3ph7clq2daptXTp3v3WKjl8DDFJLILlmmA0IS9XFF25F
	 s5bJYhAhqgWQTPooZ6TT/uD5D4slXxUqkOF644yi/9CwfJp3gSPdPQqxP7Fkr8+kl6
	 wZ7RlLppG5KnLxtqe5S8EaKWQHs0GYfIEgCQDG0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 214/307] KVM: SVM: Switch svm_copy_lbrs() to a macro
Date: Mon,  4 May 2026 15:51:39 +0200
Message-ID: <20260504135150.920885128@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 361dbe8173c460a2bf8aee23920f6c2dbdcabb94 upstream.

In preparation for using svm_copy_lbrs() with 'struct vmcb_save_area'
without a containing 'struct vmcb', and later even 'struct
vmcb_save_area_cached', make it a macro.

Macros are generally not preferred compared to functions, mainly due to
type-safety. However, in this case it seems like having a simple macro
copying a few fields is better than copy-pasting the same 5 lines of
code in different places.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-3-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    8 ++++----
 arch/x86/kvm/svm/svm.c    |    9 ---------
 arch/x86/kvm/svm/svm.h    |   10 +++++++++-
 3 files changed, 13 insertions(+), 14 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -721,10 +721,10 @@ static void nested_vmcb02_prepare_save(s
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
 		 */
-		svm_copy_lbrs(vmcb02, vmcb12);
+		svm_copy_lbrs(&vmcb02->save, &vmcb12->save);
 		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
 	} else {
-		svm_copy_lbrs(vmcb02, vmcb01);
+		svm_copy_lbrs(&vmcb02->save, &vmcb01->save);
 	}
 	vmcb_mark_dirty(vmcb02, VMCB_LBR);
 	svm_update_lbrv(&svm->vcpu);
@@ -1243,9 +1243,9 @@ int nested_svm_vmexit(struct vcpu_svm *s
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
 		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
-		svm_copy_lbrs(vmcb12, vmcb02);
+		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
 	} else {
-		svm_copy_lbrs(vmcb01, vmcb02);
+		svm_copy_lbrs(&vmcb01->save, &vmcb02->save);
 		vmcb_mark_dirty(vmcb01, VMCB_LBR);
 	}
 
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -841,15 +841,6 @@ static void svm_recalc_msr_intercepts(st
 	 */
 }
 
-void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
-{
-	to_vmcb->save.dbgctl		= from_vmcb->save.dbgctl;
-	to_vmcb->save.br_from		= from_vmcb->save.br_from;
-	to_vmcb->save.br_to		= from_vmcb->save.br_to;
-	to_vmcb->save.last_excp_from	= from_vmcb->save.last_excp_from;
-	to_vmcb->save.last_excp_to	= from_vmcb->save.last_excp_to;
-}
-
 static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
 	to_svm(vcpu)->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -713,8 +713,16 @@ static inline void *svm_vcpu_alloc_msrpm
 	return svm_alloc_permissions_map(MSRPM_SIZE, GFP_KERNEL_ACCOUNT);
 }
 
+#define svm_copy_lbrs(to, from)					\
+do {								\
+	(to)->dbgctl		= (from)->dbgctl;		\
+	(to)->br_from		= (from)->br_from;		\
+	(to)->br_to		= (from)->br_to;		\
+	(to)->last_excp_from	= (from)->last_excp_from;	\
+	(to)->last_excp_to	= (from)->last_excp_to;		\
+} while (0)
+
 void svm_vcpu_free_msrpm(void *msrpm);
-void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 void svm_enable_lbrv(struct kvm_vcpu *vcpu);
 void svm_update_lbrv(struct kvm_vcpu *vcpu);
 


