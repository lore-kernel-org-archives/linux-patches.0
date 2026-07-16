Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7EF424645;
	Thu, 16 Jul 2026 14:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211433; cv=none; b=MsJIkJ7rUzvk03xVj5pMK9/CJiNuxxkvhL7wDbDKBmGu5cxSff2qaW6H5XMAUMa5uFcn8RPz7mml4evIJTy80tFfZfkdwZpx0rz/YIacnL9gwiYUIMyKng6P3YbYcAxE0cPfMcKSBiFmNT/JB/SvhacsESPHOyIOz4GCmCgKSCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211433; c=relaxed/simple;
	bh=VE240+SNYvearYol1VPh9aSN0MCCLtEWTufQ4RP8UrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZBMwak4vmk4VIhdzbz3BLHwuw2ss6w6k2VcRs+shO3+8ObMGfWX/II2NyTzI8gLvuOlU/Nd8llX/A67pZsGKRzTqQJcvH3ORMX2VeZvb+MVOO8YTXDleM/agygaIqkiJQ6PjpUy3howQ0n7XVuJTFOUPLmBNNRY/Md7ckhCPkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9RwsGLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9RwsGLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8701F00A3F;
	Thu, 16 Jul 2026 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211432;
	bh=mIhaAnALC4k+r6Lyg9LNu22ysY0L88p2TkQ2r9cuaWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9RwsGLMxdmTWlke/vyOTK0QR4tfEf6hYb5UFkSzmtGSui9/0bQZYhSkENDsQ54YJ
	 0BQBX/K9U3GqHNyGa/VLrXUx7sO8u+GmErO+5QsoMaI9xDn9emW/SqRPqYCDxD/YAa
	 RUKtU1X/PbcCt+J6NpGEEzHD6F05nk36vQ1RTJq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikunj A. Dadhania" <nikunj@amd.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 427/480] KVM: x86: Ensure vendors exit handler runs before fastpath userspace exits
Date: Thu, 16 Jul 2026 15:32:54 +0200
Message-ID: <20260716133054.052094359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 0ffedf43910e44b76c2c1db4e9fbf12b268190c1 upstream.

Move the handling of fastpath userspace exits into vendor code to ensure
KVM runs vendor specific operations that need to run before userspace gains
control of the vCPU.  E.g. for VMX (and soon to be for SVM as well), KVM
needs to flush the PML buffer prior to exiting to userspace, otherwise any
memory written by the final KVM_RUN might never be flagged as dirty.

Note, waiting to snapshot CR0 and CR3 until svm_handle_exit() is flawed in
general, as that risks consuming stale state in a fastpath handler.  That
will be addressed in a future change.

Fixes: f7f39c50edb9 ("KVM: x86: Exit to userspace if fastpath triggers one on instruction skip")
Cc: stable@vger.kernel.org
Cc: Nikunj A. Dadhania <nikunj@amd.com>
Reviewed-by: Nikunj A. Dadhania <nikunj@amd.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://patch.msgid.link/20260423162628.490962-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    3 +++
 arch/x86/kvm/vmx/vmx.c |    3 +++
 arch/x86/kvm/x86.c     |    3 ---
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3569,6 +3569,9 @@ static int svm_handle_exit(struct kvm_vc
 			vcpu->arch.cr3 = svm->vmcb->save.cr3;
 	}
 
+	if (unlikely(exit_fastpath == EXIT_FASTPATH_EXIT_USERSPACE))
+		return 0;
+
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6499,6 +6499,9 @@ static int __vmx_handle_exit(struct kvm_
 	if (enable_pml && !is_guest_mode(vcpu))
 		vmx_flush_pml_buffer(vcpu);
 
+	if (unlikely(exit_fastpath == EXIT_FASTPATH_EXIT_USERSPACE))
+		return 0;
+
 	/*
 	 * KVM should never reach this point with a pending nested VM-Enter.
 	 * More specifically, short-circuiting VM-Entry to emulate L2 due to
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11498,9 +11498,6 @@ static int vcpu_enter_guest(struct kvm_v
 	if (vcpu->arch.apic_attention)
 		kvm_lapic_sync_from_vapic(vcpu);
 
-	if (unlikely(exit_fastpath == EXIT_FASTPATH_EXIT_USERSPACE))
-		return 0;
-
 	r = kvm_x86_call(handle_exit)(vcpu, exit_fastpath);
 	return r;
 


