Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35ABBA52
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145FCC433EF;
	Tue,  7 Mar 2023 19:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216178;
	bh=KCEuBy+vQlq+l6jOKnFcuSzdCEdjOiwxyU8c70mIZxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdaElJu1QNRElKjtTpsvC90rKQfg66qf3Ta73+keqOuWlVanA9XibKrANe10ZZSOJ
	 G1p45PV3UEVMoVaL7qj9CWJTDuZit1KuoHPY1OfyoLvdn6giyfPqwPgRK9JXE7ay9+
	 y1Q0yuEdWG2aH5UKOKBpZzI+AN4Z06b9puxpGokQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Vineeth Pillai <viremana@linux.microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 5.15 469/567] KVM: SVM: hyper-v: placate modpost section mismatch error
Date: Tue,  7 Mar 2023 18:03:25 +0100
Message-Id: <20230307165926.208565593@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

commit 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b upstream.

modpost reports section mismatch errors/warnings:
WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)
WARNING: modpost: vmlinux.o: section mismatch in reference: svm_hv_hardware_setup (section: .text) -> (unknown) (section: .init.data)

This "(unknown) (section: .init.data)" all refer to svm_x86_ops.

Tag svm_hv_hardware_setup() with __init to fix a modpost warning as the
non-stub implementation accesses __initdata (svm_x86_ops), i.e. would
generate a use-after-free if svm_hv_hardware_setup() were actually invoked
post-init.  The helper is only called from svm_hardware_setup(), which is
also __init, i.e. lack of __init is benign other than the modpost warning.

Fixes: 1e0c7d40758b ("KVM: SVM: hyper-v: Remote TLB flush for SVM")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vineeth Pillai <viremana@linux.microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20230222073315.9081-1-rdunlap@infradead.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm_onhyperv.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -48,7 +48,7 @@ static inline void svm_hv_init_vmcb(stru
 		hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
 }
 
-static inline void svm_hv_hardware_setup(void)
+static inline __init void svm_hv_hardware_setup(void)
 {
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
@@ -112,7 +112,7 @@ static inline void svm_hv_init_vmcb(stru
 {
 }
 
-static inline void svm_hv_hardware_setup(void)
+static inline __init void svm_hv_hardware_setup(void)
 {
 }
 


