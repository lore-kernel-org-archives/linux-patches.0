Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9F31C3BFC;
	Wed,  9 Sep 2026 14:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964006; cv=none; b=L7giaXTAQAW38/g2S/IR3BfM1qCU0rJijygoPrQde/0r+P8YbtVPQx2QrkDVJ1scEWcPUA96jy5ogouYrFauAkcO0LVJUPCQLGV7uwnJFkWJA2EVC72CJMpFNTbHwJvMBh1TpyKRC6onhNhCweePqbe2SRd5GzrGmsa4Ath5vJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964006; c=relaxed/simple;
	bh=n2YI3wOP8AFLo7M6J20I+Hn8GwPCYxqDOuCho1rNtN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3Ye77XYFVhbt3F7BbTJOr+k9z+CgxpxkAFbgFHJZSpg0Te++tdW6/AZYd7fB0KnQaEm8bJGtbKnjw9taCgERd8bi3ejvohIfwB8x4Gh1DMbhjn2uTGJSXHa8bSzbUhLEqUdttyPgVFNTHAfBHJ5kEOXyxEclG+GOgFWU07HkXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+OiCmn7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+OiCmn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D22B1F00A3A;
	Wed,  9 Sep 2026 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964004;
	bh=7MBoLARrai49EGWlKcPBz/UH8RWNdTBx/+4x9NjHe88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+OiCmn76HVkabvqtOT2XCkvD6+qnCsWhUv5q/SabMIoLEhsby3WNnSm5MrFepGJ2
	 szl6qMimfcUUyMPE0pnOYJgsZRLvVadYBWPFQjGKHx091qEOOO3ufFQcdaK5NxPQo7
	 /3Hex+tEx78UFbhl3Z/45JELcgh+/mGyiOTH/NbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 231/583] KVM: nVMX: Decouple INVVPID operand checks from flushing of vpid02
Date: Wed,  9 Sep 2026 15:38:36 +0200
Message-ID: <20260909134246.160490864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -6151,7 +6151,6 @@ static int handle_invvpid(struct kvm_vcp
 		u64 vpid;
 		u64 gla;
 	} operand;
-	u16 vpid02;
 	int r, gpr_index;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
@@ -6186,8 +6185,15 @@ static int handle_invvpid(struct kvm_vcp
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
@@ -6195,33 +6201,10 @@ static int handle_invvpid(struct kvm_vcp
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


