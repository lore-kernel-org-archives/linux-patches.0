Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEB55632B5;
	Wed,  9 Sep 2026 14:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964009; cv=none; b=qQPWlkCH+2+3aEyAFrleycVjyUSxnP0yj9/pP6g85zVmThwub9aCvpJvG+z/mULXZFrDBAJeaMVIjCQP22NPLBlc8agZfRTQXWbTKg4jP2V96mT+B6D+4UDLia89EbC/J3ngRnF5Xalj+hd2VqUvPXwRNzj1uwG7dfdDO/Uzh/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964009; c=relaxed/simple;
	bh=zGGgN8Jl8OdlszSnl3FrKMgQYWM01ix1hItqxAaXJHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSJypjyUy2pyXVDo+eljXd82ZWo6NTqenrw/7Csqi0dE0A/iS2W5o+ak7EAhn3JeP+dNmFscCPFbmbvy4xdNPqqAjXnQDwdKkJK33iYkOYrMXenPaoZOjtw8XZmx0YMROoxIoiFyOcaR1Axt5fuA9QqqKl5E+YNx4Gk4wSABrRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9klHI5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9klHI5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423C21F00A3A;
	Wed,  9 Sep 2026 14:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964007;
	bh=k2lh957+enbEXFiukLX7mz246tp8eN9N/iWZDY8724w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9klHI5ZWc9VNKtf7qeicMy2NgdO4vWqG6nXdxq0tQctw5QpyzSWJJg+41ZncA1iD
	 e18Rp87z+PDzVTtqGxZRkpXxcweqaGV3s4rRiUGHP+t03ZzmkaTf4YotTA94idcFoQ
	 d2gcIeEO8lH/9jH2eMTfCU/4UB7kEkV+acEY8zIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 232/583] KVM: nVMX: Ensure KVM_REQ_GET_NESTED_STATE_PAGES is cleared on VM-Exit
Date: Wed,  9 Sep 2026 15:38:37 +0200
Message-ID: <20260909134246.192537328@linuxfoundation.org>
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

commit 11722439fb206c88e6f31be54173efa9880b4ccb upstream.

Always check and clear KVM_REQ_GET_NESTED_STATE_PAGES when emulating a
nested VM-Exit to ensure the request is cleared, even when KVM was built
with CONFIG_KVM_HYPERV=n, as KVM subtly relies on the "check" to clear
the flag and thus avoid double-mapping the vmcs12 pages, e.g. if KVM
manages to bail from VM-Enter without processing the request, and then
emulates VMLAUNCH or VMRESUME.

Fixes: b4f69df0f65e ("KVM: x86: Make Hyper-V emulation optional")
Cc: stable@vger.kernel.org
Reported-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260724004757.131420-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5135,8 +5135,9 @@ void __nested_vmx_vmexit(struct kvm_vcpu
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-#ifdef CONFIG_KVM_HYPERV
+	/* Note, "checking" the request also clears the request. */
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+#ifdef CONFIG_KVM_HYPERV
 		/*
 		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
 		 * Enlightened VMCS after migration and we still need to
@@ -5144,8 +5145,8 @@ void __nested_vmx_vmexit(struct kvm_vcpu
 		 * the first L2 run.
 		 */
 		(void)nested_get_evmcs_page(vcpu);
-	}
 #endif
+	}
 
 	/* Service pending TLB flush requests for L2 before switching to L1. */
 	kvm_service_local_tlb_flush_requests(vcpu);


