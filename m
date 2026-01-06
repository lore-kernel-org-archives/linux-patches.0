Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5EC339862;
	Tue,  6 Jan 2026 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720407; cv=none; b=qnNrwuNgXnkVWEHAZWwlfbRBg/HGSIkiXgt+7uIcZt3R3DC0Xd0fXKu7IOMBUALbIF2EQuh/u2pLMpAjlcpBgLt4Z1poBgRPX8XvL+2a3zYl0Y7xJR+hYUu15bTZMd8xiKIY0/tRCfVsmBw0BDpFPiXJCJllBCJkuKB8QIrSaWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720407; c=relaxed/simple;
	bh=cN7fanC7cHDOlP0AXtr+KP5vZWH058GZXy7CwW+dBZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nb0ps/yjitHm0FQMWBTEtsXQm7BXVSCNmLIQqaSqt3Fql3TDYfzli759hXFMVFfmrwX0nX1q9Lwc3/9CN9XzYmrc0/y8cpzgtEUIvCAkQFh9p7n5uiDaMxqxQ226AwH1/Usa6inO6izjta2zhNoxJ7J7Q9a6/76pXfv1d7B/Hak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3OD72PI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3OD72PI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EA2C116C6;
	Tue,  6 Jan 2026 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720406;
	bh=cN7fanC7cHDOlP0AXtr+KP5vZWH058GZXy7CwW+dBZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3OD72PIPaIcxdiPx0X9KeNsP1951H0GxmsGHpBEJWVC7K/MtUpT0ksbIHup32i0V
	 5BTSO0sK5+Q8uXz0NsQk3Wnv3Ep/if+jJyFNX5gPW8PRVgxAGR/cN2CJQFjkjKX0Oh
	 qvqUthAy72lwmInhaVa6qhJgP/fpXONKONTziZtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Gao <chao.gao@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 227/567] KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Exit
Date: Tue,  6 Jan 2026 18:00:09 +0100
Message-ID: <20260106170459.710282769@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -18,6 +18,7 @@
 #include "trace.h"
 #include "vmx.h"
 #include "smm.h"
+#include "x86_ops.h"
 
 static bool __read_mostly enable_shadow_vmcs = 1;
 module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
@@ -5051,7 +5052,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *
 
 	if (vmx->nested.update_vmcs01_apicv_status) {
 		vmx->nested.update_vmcs01_apicv_status = false;
-		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+		vmx_refresh_apicv_exec_ctrl(vcpu);
 	}
 
 	if (vmx->nested.update_vmcs01_hwapic_isr) {


