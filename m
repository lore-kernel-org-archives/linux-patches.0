Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A413451DA;
	Sat, 17 Oct 2026 17:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259864; cv=none; b=Rf5gOoXsqcCkNRRxgs2isyjrQbq35Gi4zMgHQTjvR06eK8yd6gv+y8V3WFxdJf6HOtOtTZDwIDqMzR9/MlhaLU9Fg76XlfXZdkY5O3cwsm4mEXScBQX1pc0FhQtTqAoaxtzLu1ei/qFlFZE7D/nidD06cyPAxmKIN5D9i3CpIgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259864; c=relaxed/simple;
	bh=UDc95Eit/cH4odf8PCbES8CM9mhC05xJ72NdbUhAH34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4r+EF3iC+cpG/omi9jVxdzwoLazXHUK8hUAzNmkAmZfePDPNRXW5LLYeaUHbzvzFWZWPxY65AAkM+IN7HQ5TktDfdEXEROC51QFq+DExJaX/u7eLlAinLLOXdq/14EK3XiJlskMFcNTdEXpyBnXcmG4a+nd53dW/pzIHrO48sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPYiBA74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPYiBA74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8881F000C5;
	Sat, 17 Oct 2026 17:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259863;
	bh=dOdXblx4mpux5CZ/d7kQrWdTe3PTy9U+DeIdTETqV0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPYiBA74C7OJa4/v0X90wj7dgcIl7g743ay9prifX5Ou/VTi36zbDbKJ9N2VdRUHq
	 D+z67m8UYNczPiRJFvHlaBiw/Z567/oBAqDoctxzE3UX4eAaY+REPsk2s4iOZsFC+t
	 tfvqrM87eyULTJBh/VaulfHWQt7HNqejMKkzWgNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1354/1674] KVM: nVM: Ensure INVVPID is emulated on the correct physical CPU
Date: Sat, 17 Oct 2026 18:00:26 +0200
Message-ID: <20261017160505.919766723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit 6d00e67326d831e6e610933a3800712f4ffe6ec1 ]

When emulating INVVPID, KVM executes INVVPID on the physical CPU using
vpid02 (instead of the L1 assigned VPID), after doing some validations
on the operands. However, it is possible that the physical CPU KVM
executes INVVPID on is different from the CPU L2 is running on.

For example, in the following scenario:
- L2 runs on CPU #1 and exits to L1 (vmx->nested.vmcs02.cpu=1)
- L1 migrates to CPU #2 and executes INVVPID
- KVM executes INVVPID on CPU #2
- L1 migrates back to CPU #1 and runs L2 (vmx->nested.vmcs02.cpu=1)

The TLB entries on CPU #1 are never invalidated, because INVVPID was
executed on CPU #2, and vmcs02 never ran on a different pCPU (i.e.
vmx_vcpu_load_vmcs() will *not* request KVM_REQ_TLB_FLUSH).

Ensure that INVVPID is being executed on the same pCPU that L2 last ran
on, and if not, fallback to clearing last_vpid=0 to trigger a full VPID
flush on the next nested VM-Enter (as KVM will detect L1 using a
different VPID for L2). If L2 ends up running on a different pCPU, KVM
will flush the TLB anyway through vmx_vcpu_load_vmcs().

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://patch.msgid.link/20260616214652.2157032-4-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2561f2288dc1b..2d9cfdfa78061 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5855,6 +5855,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	} operand;
 	u16 vpid02;
 	int r, gpr_index;
+	int cpu;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_VPID) ||
@@ -5896,6 +5897,10 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	 * and never explicitly flush vpid01.  INVVPID targets a VPID, not a
 	 * VMCS, and so whether or not the current vmcs12 has VPID enabled is
 	 * irrelevant (and there may not be a loaded vmcs12).
+	 *
+	 * If vmcs02 was last loaded on a different pCPU, then defer the flush
+	 * by invalidating the nested VPID tracking to ensure that KVM performs
+	 * the invalidation on the correct pCPU.
 	 */
 	vpid02 = nested_get_vpid02(vcpu);
 	switch (type) {
@@ -5904,17 +5909,32 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		    is_noncanonical_address(operand.gla, vcpu))
 			return nested_vmx_fail(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		vpid_sync_vcpu_addr(vpid02, operand.gla);
+		cpu = get_cpu();
+		if (cpu != vmx->nested.vmcs02.cpu)
+			vmx->nested.last_vpid = 0;
+		else
+			vpid_sync_vcpu_addr(vpid02, operand.gla);
+		put_cpu();
 		break;
 	case VMX_VPID_EXTENT_SINGLE_CONTEXT:
 	case VMX_VPID_EXTENT_SINGLE_NON_GLOBAL:
 		if (!operand.vpid)
 			return nested_vmx_fail(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		vpid_sync_context(vpid02);
+		cpu = get_cpu();
+		if (cpu != vmx->nested.vmcs02.cpu)
+			vmx->nested.last_vpid = 0;
+		else
+			vpid_sync_context(vpid02);
+		put_cpu();
 		break;
 	case VMX_VPID_EXTENT_ALL_CONTEXT:
-		vpid_sync_context(vpid02);
+		cpu = get_cpu();
+		if (cpu != vmx->nested.vmcs02.cpu)
+			vmx->nested.last_vpid = 0;
+		else
+			vpid_sync_context(vpid02);
+		put_cpu();
 		break;
 	default:
 		WARN_ON_ONCE(1);
-- 
2.53.0



