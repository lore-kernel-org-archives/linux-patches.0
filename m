Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39FE399352;
	Mon, 23 Mar 2026 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276939; cv=none; b=OD1wipB6FThBkJngvIDrObuS3qAtZbqIlde4/1NBF1zpxMpMiSNfpOmiswjPyJBJ3asBsQvCXV6jafsCpgOJnN/hODbwbqYv0vmpEArqYfCyHA1DjQAvYb/sdzElqwc/DXZCT6pi4+aW/4a0sZogjmYqjeJ/u4H3AloqkAP19nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276939; c=relaxed/simple;
	bh=Qr5DbG0KPSWCH+ZnzwtBcsrUs0H8H2Wk0hhHbiZkm78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Krqm+Ui8C183FwLlmZY6JDAVQ6OveqfMAh2v4ewsASNi8Qi9cUAJ7nw91jvQ6T21XeIX6AL/YYnTOrH/nQINMdVInHC7D2E35Gnl5XKWl9ClmCD23X0bVxy9YgBliYwQY/I2KxiTDrhEMzLTXiyJOEwMLbWHreiV0aq1oSv1Sec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0wvLm77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0wvLm77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6DAC4CEF7;
	Mon, 23 Mar 2026 14:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276939;
	bh=Qr5DbG0KPSWCH+ZnzwtBcsrUs0H8H2Wk0hhHbiZkm78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0wvLm77GzY91/qVho0oj3rDeHN4cph/4xCCOeyKaJtz/dkSG9qEq/UebwxMPyr/Y
	 YpJfvJk53N3yDk6nsaQ4xb3oqYB4yYH12xx27swnzfNdielnWp48NwfeNsJO60D1ng
	 rkLhlYE2+Qg1O4pcFhp6Ydy0/N84oy4ahx2gjkEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 262/460] KVM: x86: Allow vendor code to disable quirks
Date: Mon, 23 Mar 2026 14:44:18 +0100
Message-ID: <20260323134532.923863678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit a4dae7c7a41d803a05192015b2d47aca8aca4abf ]

In some cases, the handling of quirks is split between platform-specific
code and generic code, or it is done entirely in generic code, but the
relevant bug does not trigger on some platforms; for example,
this will be the case for "ignore guest PAT".  Allow unaffected vendor
modules to disable handling of a quirk for all VMs via a new entry in
kvm_caps.

Such quirks remain available in KVM_CAP_DISABLE_QUIRKS2, because that API
tells userspace that KVM *knows* that some of its past behavior was bogus
or just undesirable.  In other words, it's plausible for userspace to
refuse to run if a quirk is not listed by KVM_CAP_DISABLE_QUIRKS2, so
preserve that and make it part of the API.

As an example, mark KVM_X86_QUIRK_CD_NW_CLEARED as auto-disabled on
Intel systems.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e2ffe85b6d2b ("KVM: x86: Introduce KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/svm/svm.c          |    1 +
 arch/x86/kvm/x86.c              |    2 ++
 arch/x86/kvm/x86.h              |    1 +
 4 files changed, 7 insertions(+)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2388,6 +2388,9 @@ int memslot_rmap_alloc(struct kvm_memory
 	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
 	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS)
 
+#define KVM_X86_CONDITIONAL_QUIRKS		\
+	 KVM_X86_QUIRK_CD_NW_CLEARED
+
 /*
  * KVM previously used a u32 field in kvm_run to indicate the hypercall was
  * initiated from long mode. KVM now sets bit 0 to indicate long mode, but the
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5563,6 +5563,7 @@ static __init int svm_hardware_setup(voi
 	 */
 	allow_smaller_maxphyaddr = !npt_enabled;
 
+	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_CD_NW_CLEARED;
 	return 0;
 
 err:
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9782,6 +9782,7 @@ int kvm_x86_vendor_init(struct kvm_x86_i
 		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
+	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
 
 	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
 
@@ -12780,6 +12781,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
+	kvm->arch.disabled_quirks = kvm_caps.inapplicable_quirks;
 
 	ret = kvm_page_track_init(kvm);
 	if (ret)
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -32,6 +32,7 @@ struct kvm_caps {
 	u64 supported_xcr0;
 	u64 supported_xss;
 	u64 supported_perf_cap;
+	u64 inapplicable_quirks;
 };
 
 struct kvm_host_values {


