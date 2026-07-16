Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7FE435522;
	Thu, 16 Jul 2026 14:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212420; cv=none; b=IEn6y3NXt1Ksfnt3qg0IqAASFgOcmKn2lU8lGfmXLAn8iVzJyx8DOsQ/5cTOhbsDrhRHHe5zL2v0dhoMrG8qutdOshi38H6cJ/uKmY3T5cAIoSUDvNgOwo1TP2dHuaJ93Oi1I3HMDdoL7u+1qHE//W4Z1AUV1VbuAEBs5L8Czls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212420; c=relaxed/simple;
	bh=zUgp3gw5ni9Jr7qzYnVwARb6fG6YvR0JKQ68yzPSAZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBiJRyzgPUukQaqgyjLKntV3zrnIHGlzvl45HNehhRhiLyeRxw7U8ubir4vHOdCYUGTIiAkYWC7Bd21EqwNK34wM8o4OS2z5MPFcMBs+YWbor/UGW/hh2htjJ2pur/Omhn/VJJlsvCUNM0GbLGetKR8bme/7BzDy7bxzJKBDg2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3cq8ZpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3cq8ZpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C82A1F000E9;
	Thu, 16 Jul 2026 14:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212418;
	bh=4+jRsl1GX86w5nK/UGiODZwWumyLVN0YzQQve2mdyqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3cq8ZpBY+zamkdtzx1LB6k5lvqhNVRKA10qpebDkjXFWJ/8BlYiehZ7SVP9uRkem
	 Ldx8NwqE14fC6viiU5rUoipPd0JmMZpxzmmFvEcGrBHCccTpTGkLBSdvjN/ACYjohC
	 IjDPx42atDYtbfO4SIjpVlRXrRtGIsW+uST87ktI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikunj A. Dadhania" <nikunj@amd.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 319/349] KVM: x86: Ensure vendors exit handler runs before fastpath userspace exits
Date: Thu, 16 Jul 2026 15:34:13 +0200
Message-ID: <20260716133040.454212383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3662,6 +3662,9 @@ static int svm_handle_exit(struct kvm_vc
 			vcpu->arch.cr3 = svm->vmcb->save.cr3;
 	}
 
+	if (unlikely(exit_fastpath == EXIT_FASTPATH_EXIT_USERSPACE))
+		return 0;
+
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6452,6 +6452,9 @@ static int __vmx_handle_exit(struct kvm_
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
@@ -11199,9 +11199,6 @@ static int vcpu_enter_guest(struct kvm_v
 	if (vcpu->arch.apic_attention)
 		kvm_lapic_sync_from_vapic(vcpu);
 
-	if (unlikely(exit_fastpath == EXIT_FASTPATH_EXIT_USERSPACE))
-		return 0;
-
 	r = kvm_x86_call(handle_exit)(vcpu, exit_fastpath);
 	return r;
 


