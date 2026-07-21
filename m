Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6659847125C;
	Tue, 21 Jul 2026 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658419; cv=none; b=NE36I6Lwsb32ZeWu7Q6sqP/Y/eYREteki+34SMPowGdKu+CrZ6aiLU4K+JX+3vGeNWkNx8pVubQo4oJz9vgn04ktQf/P1VmLKRZT9DRZB6Sk6DBIg5AH5ivRydWUyoDa5gZldQjYWPTVD2vqG268Mu0NczmxnUO40PxHpHWY5xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658419; c=relaxed/simple;
	bh=ZJS6TjE9CxWBOVImnAdc7bsydzyOjcFn4yj+PwZ/lCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US1jlIe7MPdD7tx5qNFgTIg4SKI/0srRV2/O8JxKZBiyu0nNGfiT95xo497b4ICkSASGYkgyh/8an5W2ugBMqQ58g+6gkMZZqYeR1U5gEnUzyntAK1c0c4zwoDt0Zq9IIFebOAzV81xEBTHCEX9caRaTMrcb7BZKOm0qEnOjep0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTVUNY/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTVUNY/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F1C1F000E9;
	Tue, 21 Jul 2026 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658418;
	bh=rG+m9ZNQofCmjYDn51M6vT2VfbQdiiciHbzkVBPzHJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTVUNY/A8Ki5encnJ3YQHmeQmNSd96bwQQTyLFl22+dBdwC93NhgWayKFOGrJUeH1
	 9pxsi4or7njBFJ758ZPzfL5+/GB0iRfksBueXM30PsMf43v2y8/kt7vUywSPXsyKYY
	 Zu/29Ji0JoN3pYxtLjGE2QVggank3XaCgrhVtXxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 1136/1611] KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state
Date: Tue, 21 Jul 2026 17:20:52 +0200
Message-ID: <20260721152540.977363479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -3799,6 +3799,8 @@ vmentry_fail_vmexit:
 	if (!from_vmentry)
 		return NVMX_VMENTRY_VMEXIT;
 
+	nested_put_vmcs12_pages(vcpu);
+
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason.full;
 	if (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx))


