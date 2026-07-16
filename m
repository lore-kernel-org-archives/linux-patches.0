Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADE1330D35;
	Thu, 16 Jul 2026 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210160; cv=none; b=aUAtSloDlmkuYQdDiIh1tNkpPFJ3w/zLslJx5Z1IDA/sNGGaq1j+H+zBAqYjqMkcglUL1+4CCr8dO72rsdgBd06FvJCeWFKeeYmnSa2oK0V57PUG8Q+W8Bn9f95OMhtg3jss3AUXXxRuCYGqoZUW+Q5RatzVtjS4qCjEJipBrws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210160; c=relaxed/simple;
	bh=biDiJeld+8Povbn6GnMpVWQT0etvFcy3m6UFzUG6w2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tH6xXBhQqgS5kUwyluapIf+sUOpd89k9R6Rlmqb8P9/IM7oJ+W+TECWdB63P7Rem4Wx8kfN8lJgmELgGpuyUNk/hEseqEXkxmEZ9LrHtItxyNi/ZKrtS0PXy1uRrRMfwrGxBg4wLmJCJE4EiQmeSg0YL8wffegUKQd0eOgpxLRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyxIVXpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyxIVXpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D53E1F00A3A;
	Thu, 16 Jul 2026 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210158;
	bh=/Il+6BokU2asFD0rH1FoDusSFQWLCy2VAuIe39M75/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XyxIVXpQoaAPfa6pKxfBrw5jDLyeB+HAq1d+HsjFeXRT8DhUnc/MFWfPPGlbuVh+9
	 cLNID2yMxYhlXAksYRhFdFGtC1TSZO5mlLu45qw3vuA/aghLM8W8EYWWyGY1VIUZmP
	 p6adW3gHRYjkj/EEnmG/WAtjEm55DkrZv5+eyTf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikunj A. Dadhania" <nikunj@amd.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 461/518] KVM: x86: Ensure vendors exit handler runs before fastpath userspace exits
Date: Thu, 16 Jul 2026 15:32:09 +0200
Message-ID: <20260716133057.932433058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3663,6 +3663,9 @@ static int svm_handle_exit(struct kvm_vc
 			vcpu->arch.cr3 = svm->vmcb->save.cr3;
 	}
 
+	if (unlikely(exit_fastpath == EXIT_FASTPATH_EXIT_USERSPACE))
+		return 0;
+
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6698,6 +6698,9 @@ static int __vmx_handle_exit(struct kvm_
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
@@ -11578,9 +11578,6 @@ static int vcpu_enter_guest(struct kvm_v
 	if (vcpu->arch.apic_attention)
 		kvm_lapic_sync_from_vapic(vcpu);
 
-	if (unlikely(exit_fastpath == EXIT_FASTPATH_EXIT_USERSPACE))
-		return 0;
-
 	r = kvm_x86_call(handle_exit)(vcpu, exit_fastpath);
 	return r;
 


