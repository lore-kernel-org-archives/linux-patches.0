Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3922C026C;
	Sat, 17 Oct 2026 16:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254229; cv=none; b=BZvxEEklNR4tQ6TyPKLnSNQltk0DKMMNCMV7c8mtAFUnqyXzPS4bwqPXYBnYkM/ACehWn+8XfUp7ulpySlVgzztzAJffieaTQzlNtoGPQe4Miqf6JWWF+S0NhfK7yxzNv1EKGxSRvlE8uQIQFAPDE92kaNfNXYao4XVdlBBTxb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254229; c=relaxed/simple;
	bh=oZzDAL3DRSQhPxM1PdPrkL3/pd5Ug9VHs92edw6KZkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccu1+PVxTMwRg/px8V7Ds/XAtabTqPoHDvDtDxIgxtb9NW3NTWMMigOWK6snPYAv2IIAFf5dg7uYp6HBVFyrVYWaPR3F4jjzfY1rPzfZgbJ/7UXl2PY0n6XqFfvH2/RIEdW/D5BLXU4r69GbRJ3Dx+TfnM869IfzA7u0aG1Uzo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZgXZ4py; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZgXZ4py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EE51F000C4;
	Sat, 17 Oct 2026 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254228;
	bh=x6yQrNRzES+wS9fCOBWp+GRmeSTdsyFLDrRNwcnFJsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZgXZ4pyHLWwdarLpi5yZIx3KRZxI5fAMATRZkdT1LerLxAIS/QIQyFTSbtcQnCyD
	 UtAKou3W4hOtJhGr/oskSQDiZldvXEeDngQY/UkshAP4Fhmm3FqqBgL0iAPKqkBNFN
	 K/7cuQ9wf5AJ6YQa/wWsL2oFlJrARjemrllQkrcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 376/869] KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state
Date: Sat, 17 Oct 2026 17:53:37 +0200
Message-ID: <20261017160046.755547745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index b2a0e36de0d32..bd9f41a78ec17 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3692,6 +3692,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (!from_vmentry)
 		return NVMX_VMENTRY_VMEXIT;
 
+	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	vmx->nested.pi_desc = NULL;
+
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason.full;
 	if (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx))
-- 
2.53.0



