Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA01D478E47;
	Sat, 12 Sep 2026 11:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213624; cv=none; b=DSInWanxR72YCMohde8v4WbKVYrUPN6NQW7RKYFeEJReDjmZGRkAfZ0RQyIO151D5y1PdmYcBWX9YoN6zuUT/yvXSakUdrHpcAIBdcBRcQR9E/xI4Twm6jbjXcM7jm/oO9brtG3AJrNV/iH9VecbGu4TBwomBQGj5S88QWh/jSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213624; c=relaxed/simple;
	bh=91KoelJ8sqJlsmdLsS9X48OCmEx8IjEzTKYNy8jipOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfG6UzZAZd54OnLXA3fWTF1j/qoTgzTo/lLOPcEthKMzesKOHnV5+3PMK4j+KfziHmS2NGYlZzMlznRRm1BkflUSpwsdKtEWwGIqjAvx/X8BBlK7vnEqzm3jtewV5vrheS5QRAnFcKybKLCPbQHI0Zbf/1LctVShuZDJOR0S2mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llCsj98h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llCsj98h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37AA1F000FF;
	Sat, 12 Sep 2026 11:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213620;
	bh=YWcAHUciJS4H19Yma2rPtxh5C08EOgFGau3S4EhuTWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llCsj98hqvpblYDFprlHZxPtoKP7LghSVFWucn5M8cImKwcWLt+AAKU1CyVv5HDVJ
	 RFXHfY1rpkRQfZB5XFbICZI5Hb8N8QRh8y8afF/n1EDUT26b79nWtk8ZuRcnctzjyq
	 RtYyOJWbBOeU8ooygCGBJfoLGfgsCmDn5kAwdW1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0159/1376] KVM: nVM: Ensure INVVPID is emulated on the correct physical CPU
Date: Sat, 12 Sep 2026 08:43:05 +0200
Message-ID: <20260912065611.094548126@linuxfoundation.org>
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
@@ -5990,6 +5990,7 @@ static int handle_invvpid(struct kvm_vcp
 		u64 gla;
 	} operand;
 	int r, gpr_index;
+	int cpu;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_VPID) ||
@@ -6038,11 +6039,19 @@ static int handle_invvpid(struct kvm_vcp
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


