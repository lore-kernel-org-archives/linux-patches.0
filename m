Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37EF332ECC;
	Mon, 29 Dec 2025 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025911; cv=none; b=hCRmTGAFoXVCnyn55cDll0dtJeRCJKjPIRRFudl/vr8w5B4CxJlGD8ax7QZJtgNBoj1zdfKJkDYwYI+C5FTKyBFHU2Yej5DupgoWsR2dx622fnJ4wNFMKKX3wSX+Ic37TRkyOQTETb1RUHBmbRVUf7daLEMaCRPWMKr+eqbjmvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025911; c=relaxed/simple;
	bh=cL3IPmv7UaeL8ff0WVA/slw61l6Dk8KJBdOetauvd9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqq6bAbZi0Wnf2iA6b1RLGTiIvJbgWZ70OMNBAJFlTtQgyFEIUtDzwVFtYDV+X4W37o/IaJqWHRKV2riM4AR0a9WAXHDaxfaefpgCFPlT/oCIoF5YsdWB/TE4gKld5y2h0yai0FoixGp9FbzbylNu6i2n7mL/LthB39kpGQWdBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnJKZGN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnJKZGN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E518C4CEF7;
	Mon, 29 Dec 2025 16:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025910;
	bh=cL3IPmv7UaeL8ff0WVA/slw61l6Dk8KJBdOetauvd9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnJKZGN+F6a9Wxl+8iRXKnx4Wq/iY4nxEhIbVOopKvslnlwpgEp+NBw3WEhnkIB4I
	 VXi495raM/n81eNKAHmmVIgH71Lc7vMRTDbYMerGoR7p+hpj5XHipNix+GFK/xvnmE
	 76+eVsrupaj79N0OPumdylTdGhnedMACMRtQdgtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Gao <chao.gao@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 349/430] KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Exit
Date: Mon, 29 Dec 2025 17:12:31 +0100
Message-ID: <20251229160737.169774097@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Dongli Zhang <dongli.zhang@oracle.com>

commit 29763138830916f46daaa50e83e7f4f907a3236b upstream.

If an APICv status updated was pended while L2 was active, immediately
refresh vmcs01's controls instead of pending KVM_REQ_APICV_UPDATE as
kvm_vcpu_update_apicv() only calls into vendor code if a change is
necessary.

E.g. if APICv is inhibited, and then activated while L2 is running:

  kvm_vcpu_update_apicv()
  |
  -> __kvm_vcpu_update_apicv()
     |
     -> apic->apicv_active = true
      |
      -> vmx_refresh_apicv_exec_ctrl()
         |
         -> vmx->nested.update_vmcs01_apicv_status = true
          |
          -> return

Then L2 exits to L1:

  __nested_vmx_vmexit()
  |
  -> kvm_make_request(KVM_REQ_APICV_UPDATE)

  vcpu_enter_guest(): KVM_REQ_APICV_UPDATE
  -> kvm_vcpu_update_apicv()
     |
     -> __kvm_vcpu_update_apicv()
        |
        -> return // because if (apic->apicv_active == activate)

Reported-by: Chao Gao <chao.gao@intel.com>
Closes: https://lore.kernel.org/all/aQ2jmnN8wUYVEawF@intel.com
Fixes: 7c69661e225c ("KVM: nVMX: Defer APICv updates while L2 is active until L1 is active")
Cc: stable@vger.kernel.org
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
[sean: write changelog]
Link: https://patch.msgid.link/20251205231913.441872-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -19,6 +19,7 @@
 #include "trace.h"
 #include "vmx.h"
 #include "smm.h"
+#include "x86_ops.h"
 
 static bool __read_mostly enable_shadow_vmcs = 1;
 module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
@@ -5216,7 +5217,7 @@ void __nested_vmx_vmexit(struct kvm_vcpu
 
 	if (vmx->nested.update_vmcs01_apicv_status) {
 		vmx->nested.update_vmcs01_apicv_status = false;
-		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+		vmx_refresh_apicv_exec_ctrl(vcpu);
 	}
 
 	if (vmx->nested.update_vmcs01_hwapic_isr) {


