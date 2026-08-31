Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEF1494828;
	Mon, 31 Aug 2026 13:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183519; cv=none; b=KpS+ANax8VD4/3f3FKVUw478wLbeHG1I7HnjicjTKiMSsuVnH2FfRuSYBU6MU4POdJ9ypObtzaHrlXH8z0wR6/NYNHaPn7wTeoV0uEIzGu9h1vp5VQR2D5usBG/7FxvK+4BP9f5Oi90Sco4R/Jm5MpgMQZie6shFr8f5d/XZj10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183519; c=relaxed/simple;
	bh=y2t1tUUj8oBBe85RMprUWvwjbMJk5uVtzuTwxLMubJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQWAYUM6jnUoqI7y+0Y9aHUSCTy6iQ9x94rw3KsYIZ8T0Lr5J+610hbrlnO1eIdMML0eTF2r9xrFcLL/I2tfWrTuCwTR7AI5Cef3h1VQnpoiIv2q2NwoQUoCscZfBl+Z53GuKwrPRkfJP3KKKhGD/3HojPKSBz4fz4pCDLdNrlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAnCdNv3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAnCdNv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52141F000E9;
	Mon, 31 Aug 2026 13:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183517;
	bh=kiX26y/R++yerJwgndllmSWuNs/DYllVct5XkNF88A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MAnCdNv3QLhuq1rySmg8mxnChDc/YjCUA/MOf8ZBEnHJd1eVA/DsdMATFikA/shoI
	 wPfHIpnRTUegQnjhcdNQP8gplyQKrecDMDN5iajm4LuWhfKjmVb+Ott5jTABtPnZnX
	 lZcJ5Y6IBMiimLFd8Y7bsCPYSY4raV/820I3ETxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 25/71] KVM: SEV: Wire up kvm_x86_ops.gmem_xxx() if and only if CONFIG_KVM_AMD_SEV=y
Date: Mon, 31 Aug 2026 15:33:50 +0200
Message-ID: <20260831133400.360480546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

commit 01a96ff30dde5127c37497f1e098e639e7ae152f upstream.

Wire up the SEV-SNP guest_memfd kvm_x86_ops hooks if and only if SEV is
actually enabled, and drop the now-unnecessary stubs.  Leaving the hooks
NULL allows the static call infrastructure to elide the CALL+RET, and more
importantly, referencing the hooks if and only if SEV support is enabled
will allow conditionally definining the hooks using their corresponding
HAVE_KVM_ARCH_GMEM_XXX Kconfig.

No functional change intended.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Link: https://patch.msgid.link/20260709204948.1988414-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    8 ++++----
 arch/x86/kvm/svm/svm.h |   10 ----------
 2 files changed, 4 insertions(+), 14 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5466,6 +5466,10 @@ struct kvm_x86_ops svm_x86_ops __initdat
 
 	.vm_copy_enc_context_from = sev_vm_copy_enc_context_from,
 	.vm_move_enc_context_from = sev_vm_move_enc_context_from,
+
+	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
+	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
 #endif
 	.check_emulate_instruction = svm_check_emulate_instruction,
 
@@ -5477,10 +5481,6 @@ struct kvm_x86_ops svm_x86_ops __initdat
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
-
-	.gmem_prepare = sev_gmem_prepare,
-	.gmem_invalidate = sev_gmem_invalidate,
-	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
 };
 
 /*
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -1036,16 +1036,6 @@ static inline int sev_cpu_init(struct sv
 static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
-static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
-{
-	return 0;
-}
-static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
-{
-	return 0;
-}
-
 static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 {
 	return NULL;


