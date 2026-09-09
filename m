Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F642238C1A;
	Wed,  9 Sep 2026 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962612; cv=none; b=pE/KCPzobAo35If4GS802pYvoYk78FobEqtcAvj1BdpG8JtGBr8CSrs2+whc/RWDeBC2HdfB38mOhnUqvrJpIpUtCggrNb3Pp75Sjv9oE4jqC5nzo9DbnuwrIG8uhwVNTCpPM8WYcwqnaY/QdroiGRqswZqMK/MjG5Snjf1aH0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962612; c=relaxed/simple;
	bh=tKFPQaQRQC/2es3N5Js83PXba8jE/zDWLKD1PXNv244=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXqaWUaFA192k+zi9RpmLBjNVrJKhKRdYVZEsioU82zbf08fGeWa41V9rl7zUaG+29+UccJHLlkZL8HH6Ty2vwnWles6iLpMC6dXT1XW1VtEqH+0Mx4HrGGw7QMQ9k2w746Zr57aZM8fFT9+V+5LImY9z9FJb95pLGUDPd+wW6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1cPLWAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1cPLWAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B211F00A3A;
	Wed,  9 Sep 2026 14:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962610;
	bh=sppy4hNHBWxtu39Hk5lrk91p7eOEA2nRU4D6mBZJjAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1cPLWAzksgCW4T78TGrVZuoZZl72an1vCY6iRCRW+66GBMlRnVVK3v603pFhkXVs
	 J6XIDRRojqhWB1KPwDgfZzqbOZGwbYMPEd1gLQXimNEfC1ofeZfE6HH9s5jJajPZpb
	 /8pXxjNuGnic7wuaJxRNZTCu2tb6A2tGHFdZ09uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 296/556] KVM: nVM: Ensure INVVPID is emulated on the correct physical CPU
Date: Wed,  9 Sep 2026 15:39:36 +0200
Message-ID: <20260909134241.100471557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 6d00e67326d831e6e610933a3800712f4ffe6ec1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6079,6 +6079,7 @@ static int handle_invvpid(struct kvm_vcp
 		u64 gla;
 	} operand;
 	int r, gpr_index;
+	int cpu;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_VPID) ||
@@ -6127,11 +6128,19 @@ static int handle_invvpid(struct kvm_vcp
 	 * and never explicitly flush vpid01.  INVVPID targets a VPID, not a
 	 * VMCS, and so whether or not the current vmcs12 has VPID enabled is
 	 * irrelevant (and there may not be a loaded vmcs12).
+	 *
+	 * If vmcs02 was last loaded on a different pCPU, then defer the flush
+	 * by invalidating the nested VPID tracking to ensure that KVM performs
+	 * the invalidation on the correct pCPU.
 	 */
-	if (type == VMX_VPID_EXTENT_INDIVIDUAL_ADDR)
+	cpu = get_cpu();
+	if (cpu != vmx->nested.vmcs02.cpu)
+		vmx->nested.last_vpid = 0;
+	else if (type == VMX_VPID_EXTENT_INDIVIDUAL_ADDR)
 		vpid_sync_vcpu_addr(nested_get_vpid02(vcpu), operand.gla);
 	else
 		vpid_sync_context(nested_get_vpid02(vcpu));
+	put_cpu();
 
 	/*
 	 * Sync the shadow page tables if EPT is disabled, L1 is invalidating


