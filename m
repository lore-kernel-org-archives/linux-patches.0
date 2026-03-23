Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F16C3B19DA;
	Mon, 23 Mar 2026 14:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276942; cv=none; b=lrAhlJNw3oQxKY2fik+gOp/tagd3+gCq9l9wnmQ0lDCf+9AeVZi0RNycSj2j6xyyebgqWN3N5xR4+A3G75Tf8QPLt1rj2IUr1ctD3ab5+qe/0395BnpyphF+znkNj4VI3hfkC7utr5PvUDNf2TsnCnUt2tQUN+IbjLORSjY1cb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276942; c=relaxed/simple;
	bh=vVuI9J2q8g7SP8yB3gDG8FuljByx7uf4191ekjRO35w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4PHQlpoKliMNdwiukoRHklunwApBD91VuADc//9bMo6uC5inqNlJZFa/wTaaQiZgqSXOHcw9Rz+XZhxyQ+mOeB5lyUNSMEnC6kB7nKVKDZtIq+NBVSYakB8oaTVsbxqz4i+IWxPANL6Yf/moqoRaPoRWl9daOL5mtselBrRZJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3Aa0pHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3Aa0pHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10575C4CEF7;
	Mon, 23 Mar 2026 14:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276942;
	bh=vVuI9J2q8g7SP8yB3gDG8FuljByx7uf4191ekjRO35w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3Aa0pHvLPVEHTA1BQqf39N777RaqV1TO5Kciy7KI1b2/WFuprsr5jZpS+ed/ckjJ
	 sd09uGaC1FtSrTMadphF612DM7EOM66dI2oRGBT0Jb9PMlzoj34sliNI+bpjZRtP87
	 uIBwtkbB4Kte61Ak6lJ5fiJViJt8ke08ulXpq70M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Zhao <yan.y.zhao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/460] KVM: x86: Introduce supported_quirks to block disabling quirks
Date: Mon, 23 Mar 2026 14:44:19 +0100
Message-ID: <20260323134532.946469906@linuxfoundation.org>
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

From: Yan Zhao <yan.y.zhao@intel.com>

[ Upstream commit bd7d5362b4c4ac8b951385867a0fadfae0ba3c07 ]

Introduce supported_quirks in kvm_caps to store platform-specific force-enabled
quirks.

No functional changes intended.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
[Remove unsupported quirks at KVM_ENABLE_CAP time. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e2ffe85b6d2b ("KVM: x86: Introduce KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    9 +++++----
 arch/x86/kvm/x86.h |    2 ++
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4801,7 +4801,7 @@ int kvm_vm_ioctl_check_extension(struct
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
 	case KVM_CAP_DISABLE_QUIRKS2:
-		r = KVM_X86_VALID_QUIRKS;
+		r = kvm_caps.supported_quirks;
 		break;
 	case KVM_CAP_X86_NOTIFY_VMEXIT:
 		r = kvm_caps.has_notify_vmexit;
@@ -6534,11 +6534,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 	switch (cap->cap) {
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = -EINVAL;
-		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
+		if (cap->args[0] & ~kvm_caps.supported_quirks)
 			break;
 		fallthrough;
 	case KVM_CAP_DISABLE_QUIRKS:
-		kvm->arch.disabled_quirks |= cap->args[0];
+		kvm->arch.disabled_quirks |= cap->args[0] & kvm_caps.supported_quirks;
 		r = 0;
 		break;
 	case KVM_CAP_SPLIT_IRQCHIP: {
@@ -9782,6 +9782,7 @@ int kvm_x86_vendor_init(struct kvm_x86_i
 		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
+	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
 	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
 
 	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
@@ -12781,7 +12782,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 	/* Decided by the vendor code for other VM types.  */
 	kvm->arch.pre_fault_allowed =
 		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
-	kvm->arch.disabled_quirks = kvm_caps.inapplicable_quirks;
+	kvm->arch.disabled_quirks = kvm_caps.inapplicable_quirks & kvm_caps.supported_quirks;
 
 	ret = kvm_page_track_init(kvm);
 	if (ret)
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -32,6 +32,8 @@ struct kvm_caps {
 	u64 supported_xcr0;
 	u64 supported_xss;
 	u64 supported_perf_cap;
+
+	u64 supported_quirks;
 	u64 inapplicable_quirks;
 };
 


