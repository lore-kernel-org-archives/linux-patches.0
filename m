Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E96A47A0C7;
	Sat, 12 Sep 2026 11:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213614; cv=none; b=T/TIkzo4GykITy9hWBVhjYj6FRfNjGKJskRDbk3q4pz2AKu+kCfeUHXQ0ekcvLKptSX4m91McYqnRQ/QP+Vl9vhcZrnZgdWGgzOwvg8jQdgBCNMKRVCQnZyNluIBMkf5kL9vqrwAuNO/89hhfSrLVAu+JXRB0e7uwsMMG6W9aEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213614; c=relaxed/simple;
	bh=YLzIS9hFgxwhcQG7Wu7zMi17nPTKrP+MJQ6UVySH6aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItSwwWW7YRs9aGvsq4gHpdhnX0PZr/gdOn6EW64dAem81bLkeVReEfio89jzhQAu8sdvGJ+DLRYMWKG2zIkENS0GNRsMnBc0wiZ9XyOn803Kd9L6HfC++GmvPHXTUhiSVQQeF/EIlbJH9jyRTYWmrMeRLbOgWCAa4yPwCahdrEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2RcOSIH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2RcOSIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F561F000FF;
	Sat, 12 Sep 2026 11:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213610;
	bh=m5lX19Is7yc8wCOaGTByYu4vOYN0Ugz2wmHczaflcbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2RcOSIH6QqBI0ljUv7nQ2k1Vc5XPlMsXi1w9ehPGqA1EBVmZa42XRuG+bzGWz3fK
	 D1NrgvxivVVUQ6KiZz44YN3GJhsoj+eubX8kCtKblCb20qpwWmviWhmnK6gyeuNMcr
	 uU4yAUKH0ormPFOWHU8yi5fExFowML7Wie29yTnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0157/1376] KVM: nVMX: Ensure KVM_REQ_GET_NESTED_STATE_PAGES is cleared on VM-Exit
Date: Sat, 12 Sep 2026 08:43:03 +0200
Message-ID: <20260912065611.049514261@linuxfoundation.org>
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
@@ -4962,8 +4962,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-#ifdef CONFIG_KVM_HYPERV
+	/* Note, "checking" the request also clears the request. */
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+#ifdef CONFIG_KVM_HYPERV
 		/*
 		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
 		 * Enlightened VMCS after migration and we still need to
@@ -4971,8 +4972,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *
 		 * the first L2 run.
 		 */
 		(void)nested_get_evmcs_page(vcpu);
-	}
 #endif
+	}
 
 	/* Service pending TLB flush requests for L2 before switching to L1. */
 	kvm_service_local_tlb_flush_requests(vcpu);


