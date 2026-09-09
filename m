Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19705678EE;
	Wed,  9 Sep 2026 14:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962454; cv=none; b=HFq7CxzAxlJkkY6mlv+dabO32Qul5aFIH4lWfaE/9JbikKH8DIdZdVTXsQdfMuMmlY634gwH+M1h5/xL+HKsqyGOCd3xJ7KTqOBO0+fIiW648D87jKwu71jGoBSIpyjOtsFKii19Im9Jf2yfqBl51afvoj7ATmqdIToaw26wB5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962454; c=relaxed/simple;
	bh=EyHy3/FGI3v2hPYxgTb+IpG/hjxET0mTOZDclHyoG18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPLkbNNXXQZhZQJevR7lXOsn1HPGhN+U9KQRcoxqgj4UoVVI1/BTP9dwSw0b8+8go0N+a31FC67m1yaHKqn0xFmFkA+riv7Ogc1yklLJU/ZX9KFKbC40wKjgGBa64K5WRhLWe22ZH/++lOS/TtQ98xxF9NJUS/f6wTEFyEXzMn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nf1wk6m6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nf1wk6m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B9D1F00A3A;
	Wed,  9 Sep 2026 14:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962453;
	bh=24NVmIcUFo3gkbDR8G2FjXl6m5JKTVBUW/nI8qy4BEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nf1wk6m6t884F/GxthdMhS/jFPx9tHnZ1CxexSQ07lGzi8BYEVteEHuIHA/yMKydn
	 EXHptYEZTCCAGJHzbR5gz+ivClTYcTGhQmPfRsR7P8pnL+EGTinysghQIrx0YkIcey
	 3Ik+7OEu+gJiOdiTUw9Cy0GUUoascfkDvyfOO3Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 294/556] KVM: nVMX: Ensure KVM_REQ_GET_NESTED_STATE_PAGES is cleared on VM-Exit
Date: Wed,  9 Sep 2026 15:39:34 +0200
Message-ID: <20260909134241.031247110@linuxfoundation.org>
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
@@ -5076,8 +5076,9 @@ void __nested_vmx_vmexit(struct kvm_vcpu
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	kvm_warn_on_nested_run_pending(vcpu);
 
-#ifdef CONFIG_KVM_HYPERV
+	/* Note, "checking" the request also clears the request. */
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+#ifdef CONFIG_KVM_HYPERV
 		/*
 		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
 		 * Enlightened VMCS after migration and we still need to
@@ -5085,8 +5086,8 @@ void __nested_vmx_vmexit(struct kvm_vcpu
 		 * the first L2 run.
 		 */
 		(void)nested_get_evmcs_page(vcpu);
-	}
 #endif
+	}
 
 	/* Service pending TLB flush requests for L2 before switching to L1. */
 	kvm_service_local_tlb_flush_requests(vcpu);


