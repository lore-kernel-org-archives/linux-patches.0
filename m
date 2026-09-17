Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FD53DD879;
	Thu, 17 Sep 2026 18:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671401; cv=none; b=U1RuYPBC1lMDwCqpo+wBUymmhPcct/kSgfuC1+s60AAzpe5VbPyL+EyaVg4103InV6N0HRAyqsiYFzF3zDtAKK2Tbou2pdNGwOzQA2QP9xH7v/gpZ9ViG0GYHyHzkR8RN6TEYOJU0MrJdBd62GD5QEYkhxWiLXsAAL67Cqc/fsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671401; c=relaxed/simple;
	bh=GnMNeioFumpTqN7gdMrBdvqak1XwWIvaMlTTTRG3sIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8wp2ayjPbAMQ4G/Nc6avsGswZrvqFW+pptCpZvn5yzOLtpmnf7+NcMYdq4K0wAaqSCMYwBdocKrhlwdgfdRwKVZnVNtDZwAPkkWUz27I3/HGXIrRLS2l0Vsluu+AjkMbTA7pLLPDPciKLoHcnN1tV6Y2jtOPOZNkC/NkZ+bCQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwJLh16Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwJLh16Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D397C1F000FF;
	Thu, 17 Sep 2026 18:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671399;
	bh=k8b8+0O5Lhx2lS8cjHSwRCy39tF/UQrSl5//kGZToAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwJLh16ZdyZv0jOH7MFvc4WL4PHzerzshTgttE0HIgGuCsi6LxQahGYM0pAADA530
	 p5JHWLnUCZCy+seXQ1OYbRhJmX7Hz7OKFLiKnE/mXdLwwfRjncPDHtWwousVHGMppq
	 iWaHl5nIyOyVRtFBA5tWqqDlpijtAqXA7iAZf6mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0961/1102] KVM: SEV: Wire up kvm_x86_ops.gmem_xxx() if and only if CONFIG_KVM_AMD_SEV=y
Date: Thu, 17 Sep 2026 16:15:04 +0100
Message-ID: <20260917151604.793688913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit 01a96ff30dde5127c37497f1e098e639e7ae152f ]

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
[ adapted gmem_max_mapping_level hook to the older private_max_mapping_level API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    8 ++++----
 arch/x86/kvm/svm/svm.h |   10 ----------
 2 files changed, 4 insertions(+), 14 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5303,6 +5303,10 @@ static struct kvm_x86_ops svm_x86_ops __
 
 	.vm_copy_enc_context_from = sev_vm_copy_enc_context_from,
 	.vm_move_enc_context_from = sev_vm_move_enc_context_from,
+
+	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
+	.private_max_mapping_level = sev_private_max_mapping_level,
 #endif
 	.check_emulate_instruction = svm_check_emulate_instruction,
 
@@ -5314,10 +5318,6 @@ static struct kvm_x86_ops svm_x86_ops __
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
-
-	.gmem_prepare = sev_gmem_prepare,
-	.gmem_invalidate = sev_gmem_invalidate,
-	.private_max_mapping_level = sev_private_max_mapping_level,
 };
 
 /*
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -791,16 +791,6 @@ static inline int sev_dev_get_attr(u32 g
 #define max_sev_asid 0
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
 static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
-static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
-{
-	return 0;
-}
-static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
-{
-	return 0;
-}
-
 #endif
 
 /* vmenter.S */


