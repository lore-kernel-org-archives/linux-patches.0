Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D89A147C60;
	Wed, 19 Jun 2024 12:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801931; cv=none; b=A3+iisklOr+NaTo66TcPqUV5aOGDOAR96Z+RTvvHWArM/ekhEA0aLuZrzHqTs9n3lJ6LCEhKR8zhD8xZEs2cNtwq0xbSo66SDRiDbEF1WOCb8SvlRiXq8NTWuzW/LjIxZ46qXcUfsRTg0uTjg+sQsr0P8T62O70q4Nh5ISXx4k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801931; c=relaxed/simple;
	bh=1LmvkUhxMkT6EkfciRLy9MBPNmiRIhunrzEkJ0DQINk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJRNHxnVl7n6DRmx1vPZm4Nvw71CSxjSqbieuHIu3P95H+M5fyzVwK1nqawvJb0WbEgOyCVty5BGB4DIJ/+XpvNVuvG9xUuJOr2wh7yrB3DcqxwuCIdvwS05KJw1TZ3XtwJl6AEgCmmuFCtmmliFLNTnNpjfG/R1lTCkNN3vzA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcfYKC3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcfYKC3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD5BC2BBFC;
	Wed, 19 Jun 2024 12:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801930;
	bh=1LmvkUhxMkT6EkfciRLy9MBPNmiRIhunrzEkJ0DQINk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcfYKC3ZBOPRCyDgM2M6cDZuOjPI17x7no9hGpV/pao6RUcDum4+L8hu8VVmAFzIZ
	 uQ0XpKaQfu3iaV17hIC991Qv1VQqF2Mt2aaDJSU0PMogVjzWhgiTu6u0s1M3S8HRlq
	 3oDYe/SSeyXVt4dSX1msjW8F/MBMzx7qxTfRL4P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/267] KVM: SEV: Do not intercept accesses to MSR_IA32_XSS for SEV-ES guests
Date: Wed, 19 Jun 2024 14:52:56 +0200
Message-ID: <20240619125607.327017916@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Roth <michael.roth@amd.com>

[ Upstream commit a26b7cd2254695f8258cc370f33280db0a9a3813 ]

When intercepts are enabled for MSR_IA32_XSS, the host will swap in/out
the guest-defined values while context-switching to/from guest mode.
However, in the case of SEV-ES, vcpu->arch.guest_state_protected is set,
so the guest-defined value is effectively ignored when switching to
guest mode with the understanding that the VMSA will handle swapping
in/out this register state.

However, SVM is still configured to intercept these accesses for SEV-ES
guests, so the values in the initial MSR_IA32_XSS are effectively
read-only, and a guest will experience undefined behavior if it actually
tries to write to this MSR. Fortunately, only CET/shadowstack makes use
of this register on SEV-ES-capable systems currently, which isn't yet
widely used, but this may become more of an issue in the future.

Additionally, enabling intercepts of MSR_IA32_XSS results in #VC
exceptions in the guest in certain paths that can lead to unexpected #VC
nesting levels. One example is SEV-SNP guests when handling #VC
exceptions for CPUID instructions involving leaf 0xD, subleaf 0x1, since
they will access MSR_IA32_XSS as part of servicing the CPUID #VC, then
generate another #VC when accessing MSR_IA32_XSS, which can lead to
guest crashes if an NMI occurs at that point in time. Running perf on a
guest while it is issuing such a sequence is one example where these can
be problematic.

Address this by disabling intercepts of MSR_IA32_XSS for SEV-ES guests
if the host/guest configuration allows it. If the host/guest
configuration doesn't allow for MSR_IA32_XSS, leave it intercepted so
that it can be caught by the existing checks in
kvm_{set,get}_msr_common() if the guest still attempts to access it.

Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
Cc: Alexey Kardashevskiy <aik@amd.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-Id: <20231016132819.1002933-4-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: b7e4be0a224f ("KVM: SEV-ES: Delegate LBR virtualization to the processor")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 19 +++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  2 +-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0e643d7a06d9e..f809dcfacc8a3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2994,6 +2994,25 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 
 		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
 	}
+
+	/*
+	 * For SEV-ES, accesses to MSR_IA32_XSS should not be intercepted if
+	 * the host/guest supports its use.
+	 *
+	 * guest_can_use() checks a number of requirements on the host/guest to
+	 * ensure that MSR_IA32_XSS is available, but it might report true even
+	 * if X86_FEATURE_XSAVES isn't configured in the guest to ensure host
+	 * MSR_IA32_XSS is always properly restored. For SEV-ES, it is better
+	 * to further check that the guest CPUID actually supports
+	 * X86_FEATURE_XSAVES so that accesses to MSR_IA32_XSS by misbehaved
+	 * guests will still get intercepted and caught in the normal
+	 * kvm_emulate_rdmsr()/kvm_emulated_wrmsr() paths.
+	 */
+	if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
+	else
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 0, 0);
 }
 
 void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9e084e22a12f7..08f1397138c80 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -103,6 +103,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTTOIP,		.always = false },
+	{ .index = MSR_IA32_XSS,			.always = false },
 	{ .index = MSR_EFER,				.always = false },
 	{ .index = MSR_IA32_CR_PAT,			.always = false },
 	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 53bc4b0e388be..fb0ac8497fb20 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	46
+#define MAX_DIRECT_ACCESS_MSRS	47
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.43.0



