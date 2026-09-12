Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9248A431A5C;
	Sat, 12 Sep 2026 11:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213606; cv=none; b=QpHlDWQZo3SPJGpz1Yy4s6V0BpIUzNNWrpEQJdEfkB5GssOvHvrO3vuiwLx8V3LsVkNDZEVZxWY3ldJjF6ldibj3IREjWRZaBt45EciwbF5iWCmVqK9M5JOx3GFfxLDDdn4OVNxk2fBW3yi7sfqb2lbtoUNrZJN0WxC+zg9cYps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213606; c=relaxed/simple;
	bh=2JqBRfU6cepxbqWf0rXczQtCCTicX5hDVRpwA2N0JcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rD8HfBMNM9umyp5M9WlwT606syt3njr9rdrqDy2TXbGhW37MAkJCtz9q3ttL53JHjYLDxGf0mb2NhE3agZlfzT8SQxdWvt6XQ6laQYuWFRixl3XUQlup/1FLVfBAulv7TLIcetv/zc6klY8C6A17uZi23u4NsephhuLmcPnBe/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DE+i1kZC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DE+i1kZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E481F000FF;
	Sat, 12 Sep 2026 11:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213605;
	bh=IczY6qHoUaZjLHOdKIqsHqRrerwc5nQmKOKlelMmzzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DE+i1kZCBBnanvscqKisKpgtIaPQi0ay5Q5UTDX9TascgF9LjdbMr87er1/k9WDLn
	 BTOlrud5kMW5Zx/NRH0Fhfj6VrntGPpP9IJfIhOIeIo6GP9Hfu6wCbzUJMVNl3ojB/
	 qQWan4KbU9AWEjnumasdroO/mxfAiQkC+uZBolZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0156/1376] KVM: nVMX: Decouple INVVPID operand checks from flushing of vpid02
Date: Sat, 12 Sep 2026 08:43:02 +0200
Message-ID: <20260912065611.025801569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

commit 32912404b4b1ee98400744941c78f019a63d6e8f upstream.

Separate the INVVPID operand checks from the actual flushing of vpid02 so
the flushing can be adjusted to do the right thing when vmcs02  was last
loaded on a different pCPU, without having to duplicate the logic across
multiple case-statements.

Opportunistically let the VM-Fail paths poke out past 80 chars.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://patch.msgid.link/20260616214652.2157032-3-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   43 +++++++++++++------------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5980,7 +5980,6 @@ static int handle_invvpid(struct kvm_vcp
 		u64 vpid;
 		u64 gla;
 	} operand;
-	u16 vpid02;
 	int r, gpr_index;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
@@ -6015,8 +6014,15 @@ static int handle_invvpid(struct kvm_vcp
 		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	if (operand.vpid >> 16)
-		return nested_vmx_fail(vcpu,
-			VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+		return nested_vmx_fail(vcpu, VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+
+	if (type != VMX_VPID_EXTENT_ALL_CONTEXT && !operand.vpid)
+		return nested_vmx_fail(vcpu, VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+
+	/* LAM doesn't apply to addresses that are inputs to TLB invalidation. */
+	if (type == VMX_VPID_EXTENT_INDIVIDUAL_ADDR &&
+	    is_noncanonical_invlpg_address(operand.gla, vcpu))
+		return nested_vmx_fail(vcpu, VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
 	/*
 	 * Always flush the effective vpid02, i.e. never flush the current VPID
@@ -6024,33 +6030,10 @@ static int handle_invvpid(struct kvm_vcp
 	 * VMCS, and so whether or not the current vmcs12 has VPID enabled is
 	 * irrelevant (and there may not be a loaded vmcs12).
 	 */
-	vpid02 = nested_get_vpid02(vcpu);
-	switch (type) {
-	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
-		/*
-		 * LAM doesn't apply to addresses that are inputs to TLB
-		 * invalidation.
-		 */
-		if (!operand.vpid ||
-		    is_noncanonical_invlpg_address(operand.gla, vcpu))
-			return nested_vmx_fail(vcpu,
-				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		vpid_sync_vcpu_addr(vpid02, operand.gla);
-		break;
-	case VMX_VPID_EXTENT_SINGLE_CONTEXT:
-	case VMX_VPID_EXTENT_SINGLE_NON_GLOBAL:
-		if (!operand.vpid)
-			return nested_vmx_fail(vcpu,
-				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		vpid_sync_context(vpid02);
-		break;
-	case VMX_VPID_EXTENT_ALL_CONTEXT:
-		vpid_sync_context(vpid02);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return kvm_skip_emulated_instruction(vcpu);
-	}
+	if (type == VMX_VPID_EXTENT_INDIVIDUAL_ADDR)
+		vpid_sync_vcpu_addr(nested_get_vpid02(vcpu), operand.gla);
+	else
+		vpid_sync_context(nested_get_vpid02(vcpu));
 
 	/*
 	 * Sync the shadow page tables if EPT is disabled, L1 is invalidating


