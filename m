Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056D7552927;
	Mon, 31 Aug 2026 13:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184017; cv=none; b=KUMAzVDsQ33UkTiJGimUSAVTIzMOC8565NTfDkDKlaxqg+0zVvx1X1yzHohHTq1y0Geg8drbalCZPBUYC1wrcMqjLOwuxwDGOZavzklRCcCZXzPUe32mIswFvkramdSWjwLVAZyIn9FAi+7zUG3aIlUt7BmKyfWVAPhrhk+uf+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184017; c=relaxed/simple;
	bh=DAYBb5jNtULab0HoyQfmSMDVhlq1x2rzyrm7cvsB3+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gezZjzgwjifhFPgfydN5mbTnCtVhlsKwy+QJUC9r4aEVd8FvOFnQ05zv2vhzHynM+ggwjwnot6NAMAlCTsYwuiu7acKZjmXdko9lp+Q5kFWjqWuVNpJoXb2K2kNKqFyguBFSE3UVknD1CCZl4sASuGetB3EcS+vYu04sAADGo6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vG0FsfUw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vG0FsfUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452241F00A3F;
	Mon, 31 Aug 2026 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184013;
	bh=IdKN8ZHakIG94ObvdDS7DFG1h+8gqtIhAO6B9lRe1ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vG0FsfUw7W7WgjlL/Ea7Y2YemyaEVcXXKa2EtYhZyo/KluyCL2Av3mUz4vRBrYRg6
	 1Kqu051HD9+HMoJZ6G7XQVDQ4tv+Sv5bf/fMcLshfUk0RbyAruWs2YkVLiu0unNE1y
	 cn7x8a1KfsH3Uuxs59X49t7S2xTsIyCHalGStQJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 44/83] KVM: SEV: Wire up kvm_x86_ops.gmem_xxx() if and only if CONFIG_KVM_AMD_SEV=y
Date: Mon, 31 Aug 2026 15:34:20 +0200
Message-ID: <20260831133401.752236970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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
@@ -5262,6 +5262,10 @@ struct kvm_x86_ops svm_x86_ops __initdat
 
 	.vm_copy_enc_context_from = sev_vm_copy_enc_context_from,
 	.vm_move_enc_context_from = sev_vm_move_enc_context_from,
+
+	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
+	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
 #endif
 	.check_emulate_instruction = svm_check_emulate_instruction,
 
@@ -5273,10 +5277,6 @@ struct kvm_x86_ops svm_x86_ops __initdat
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
@@ -906,16 +906,6 @@ static inline int sev_cpu_init(struct sv
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


