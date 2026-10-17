Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87014382F25;
	Sat, 17 Oct 2026 17:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259001; cv=none; b=PcRmQtRMsvYC0V+SD1aXb9fYgP6nWGTE+C1JXhdqLXItp6fWOLYEH/j27m4PVajvlcOyRRxI1WiVFHo0T9DU6S01NiKp6rxPWPNFZ+vYatmrLhpJZRZWu6F8qF+YjEt6Sk+Bz9vg1UJUIDecT6U+FrNuLlZpbcWrSBMugOiKWk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259001; c=relaxed/simple;
	bh=FZG0mQf/AkmBDNvpB4clojAR+9qrMTDBwBaLTlz71BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYFA9mrUEdWXJZD7HzhFVdZAvXouVshzqE7rrTTtSYc4S6aRUr6ijkZw926taHcXfun5/1bMOGjkd9HKja8UJ3SUjf/nrl4/52il80Vi62ZBWSsAYRn6OqQPtw0cDRx+4NOVkNASKaGvyaUgMkdWVefKEqgmIMUX2ovkciKnubA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uj4eMV14; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uj4eMV14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D532A1F000C4;
	Sat, 17 Oct 2026 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259000;
	bh=tEPB/vt05dJwK89rNYYqHw5SJuQCTMxUW07ixgx0Jvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uj4eMV14SjeJHZmnVs/lTquY57UHXg4VgKDQb4kZQHYHuATNoIhS+s6q1eLjm6DWm
	 B0VX9Ot1hUesxWKwwKgERbbHDIQzShkYQxsfxKgBPvq4KD3Y6X7ACG52HRM2L1SgyP
	 Gad1Yl1OuCMIgdtkY0+cIdgNLestO4Peu9UdsbOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1070/1674] KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state
Date: Sat, 17 Oct 2026 17:55:42 +0200
Message-ID: <20261017160458.587447726@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2f2312c422fd2695da772cecb30c69994b795964 ]

Put all vmcs12 pages if KVM synthesizes a nested VM-Exit due to invalid
guest while emulating VMLAUNCH or VMRESUME.  The invalid guest state path
doesn't use nested_vmx_vmexit() as that API is intended to be used if and
only if L2 is active, and the open coded equivalent neglects to put the
vmcs12 pages.  Failure to put the vmcs12 pages leaks any pinned pages
(and/or mappings) if L1 retries VMLAUNCH/VMRESUME.

Note, the !from_vmenter scenario doesn't suffer the same problem, as
vmx_get_nested_state_pages() only gets/pins/maps the vmcs12 pages if L2 is
active, i.e. if a "full" VM-Exit is guaranteed before KVM will retry
getting vmcs12 pages.

Fixes: 96c66e87deee ("KVM/nVMX: Use kvm_vcpu_map when mapping the virtual APIC page")
Fixes: 3278e0492554 ("KVM/nVMX: Use kvm_vcpu_map when mapping the posted interrupt descriptor table")
Fixes: fe1911aa443e ("KVM: nVMX: Use kvm_vcpu_map() to get/pin vmcs12's APIC-access page")
Reported-by: Minh Nguyen <minhnguyen.080505@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a130e2d70c481..2561f2288dc1b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3571,6 +3571,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (!from_vmentry)
 		return NVMX_VMENTRY_VMEXIT;
 
+	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	vmx->nested.pi_desc = NULL;
+
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason.full;
 	if (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
-- 
2.53.0



