Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8B438399A;
	Tue, 21 Jul 2026 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654122; cv=none; b=GmlkV2xxGmugcPM9J5GGBECthzlo18I9ut4T0OvLuQaR3hD51oNu7ntjur3PMfY6sX0ZCmQa/2ChnW8t+fNrDH69Cb3i97BRKGdo2ye2lhVSvem6Ywx6c+29eTpNgcRbwBSkuHZfvN4ZFViqBufMGaxUp9+tzigpEWhLAM0ss90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654122; c=relaxed/simple;
	bh=3/CNlRsorFLRfU139IQU+l5Ui9799QY3geGz6JWocRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zsspn78qa9f6REJVjtJYehA7ehfLsJvO+e/AZLL8Y4q2OqxP8RVk2k/At0b4GTn1EUsjbkvzo8wEtrTomJ4xa/Hl3rGCS0gJ9eM8ikqNf+OAeninQ8AHfTPr48JZw+GsQg3LH5/oWVl0A2Z+D4IzO0J590YF75rHC0f5g0QWet8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBwPgCFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBwPgCFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66C51F000E9;
	Tue, 21 Jul 2026 17:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654121;
	bh=ucIsXhqJyRx0O8ChOW78i/EVe3oFbouxrlmqLoMmYX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBwPgCFhKPQ56MohF/J2xdznVwcGY/zzbm2Zlc7U+C6q4+Bs6f/4FlWT17xLGn3A9
	 V2uvuRXOJLmxW9fLdM0TGuzyxANp0cVr4iS3bol/PfBZDn61hjI89ww0Lpj8NOM2R2
	 fa4a4y0Hp8JNDHmbc+sfJ89G9w6VMFDeBBcIOMrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.1 1568/2077] KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state
Date: Tue, 21 Jul 2026 17:20:41 +0200
Message-ID: <20260721152629.763326298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 2f2312c422fd2695da772cecb30c69994b795964 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3747,6 +3747,8 @@ vmentry_fail_vmexit:
 	if (!from_vmentry)
 		return NVMX_VMENTRY_VMEXIT;
 
+	nested_put_vmcs12_pages(vcpu);
+
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason.full;
 	if (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx))


