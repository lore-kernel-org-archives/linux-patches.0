Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215293;
	b=G5V8n01rF3ODHZqpoeclqSiCMJ2dUx/J8z/qX4FGnVPM+dA73WmzYGGTHSjJUZsAoxCp
	 jzZPPufP5COWtavs03louhxX/DKPJxOQejBUUahWdy7DxdQyN1ZkCKumRKnMeIyfyGeaX
	 LVQCz+uTnjsFh7O8Vv8NiFl6lclurLlsXixP4APmycmpx1ss28kvtopx2Zpi3HDUqKuCR
	 lXY3J+ETyMStIMl/ihkmobL2N75FJJAA9+GsAJfaLVCX2cs4H8dEDlDJQ66mqo9yCBlAy
	 D3MmGoBXIXZovXMuNnMzxZZYMr6JSyYB65EUs4OzhmSyFGNLXY1P4VfhPpj/vBQzpgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4mMikkrRRRm14fAWywiKmwnkkLDF0YfFaF8kcFrla3M=;
	b=OPLjgir1qsWNBhnCcdiXZLcCLMa5ZXxnOjDvLCXx7CO2yeGysuM3qdWaa2W9rWAaL67H
	 amF1BKJ3Ocvkdu5uJxOikWGpfYFMwHfcmfTB0h1sWGn5KXc4U9IIwqCA24bzBIiyofaOx
	 pw5EhEhPxxnmbf+e9fbuourtxrS3OlFym7uxBBkPfBQVN2sgCb9jdOjWou4+bjhf7r+91
	 AWg7nz0JPshsL5Q3Ni37edgmQCUratJH0SHlbahV+E2PTY879Qd7yvcKcVFSkE3BvgAXH
	 hW87oDdCK+3EHW1/LlPznGefV0LJYUe+ThNk9iMxHAu7GQSaNSyCHB1PTekEQ5k6mTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQwBibEz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0401606A31A;
	Wed, 28 Oct 2026 19:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQwBibEz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2D41F01825;
	Wed, 28 Oct 2026 19:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215292;
	bh=4mMikkrRRRm14fAWywiKmwnkkLDF0YfFaF8kcFrla3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQwBibEzr52jT8e3m280HBgt6nmuevIh4MHQYSU9IbXTSDzEQmg7XiC1r9KerpAD6
	 sbJ7EQ9Q9w2DgA4QE1eluVRC3EEzSy6pV7+7bkIxL3FZz2y4HGfiQ9YS+TFeAt9Wip
	 nDsW/OWQutnzhtCRuUVYGSFhovlmrKMhrRMHdIP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1160/1887] KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state
Date: Wed, 28 Oct 2026 17:54:16 +0100
Message-ID: <20261028170525.801588074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7febe4f2ee06f..5726ab567f615 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3543,6 +3543,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
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



