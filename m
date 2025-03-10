Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56BC233700;
	Mon, 10 Mar 2025 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626983; cv=none; b=HIK6h+QYO1WxjKk9/zGxZp8nsQaS9l6JKZVx2koyOoaWRZ/2mc2+W2SpTwjsD+T9q9TwztrFOVAjMPLpq3eD7phn9OtCwnVJUsvMEiZtW7TnYKp22obX5FoOebsJiECFpEWmKMEHM9BX3Mx+GS8KhxNOyKk16UiGY3C3NMzrBYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626983; c=relaxed/simple;
	bh=Mbyy0O265FrzhyeiqJjy/oGp4Pch4AI2k032BhkxjsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwvyehlGqUaASFVp+y26fhD0i99JB+WgHVpHFJZRxFJlD12WJw/i5bloRRqXEr1kinLOxBkIK1fhAvKW7rZqAMERyk0tkj+1K7o6dDPjB9UIvL+EqFuAKiTjxTCkwE59uxKrukukJtPZNCILnHQmImS7QjKHsXN/SSoUUXUx4bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSP5vrGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSP5vrGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3785C4CEE5;
	Mon, 10 Mar 2025 17:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626983;
	bh=Mbyy0O265FrzhyeiqJjy/oGp4Pch4AI2k032BhkxjsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSP5vrGz8sWdycT1mEhPsoiArux5xs3m+cQyLxlWoLabH3SLzlzmPJa6h0rr+Y+j9
	 lQR26NBWmjtoy3rYN8OzCBKr+33pgaYSbFSnL384t3VQTK3yox9BfPxsCuolTSIT56
	 02djdSGVWY+TeGjb4MZNmINUETmNyRd/frerEgjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen N Rao <naveen@kernel.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.13 173/207] KVM: SVM: Save host DR masks on CPUs with DebugSwap
Date: Mon, 10 Mar 2025 18:06:06 +0100
Message-ID: <20250310170454.669386919@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit b2653cd3b75f62f29b72df4070e20357acb52bc4 upstream.

When running SEV-SNP guests on a CPU that supports DebugSwap, always save
the host's DR0..DR3 mask MSR values irrespective of whether or not
DebugSwap is enabled, to ensure the host values aren't clobbered by the
CPU.  And for now, also save DR0..DR3, even though doing so isn't
necessary (see below).

SVM_VMGEXIT_AP_CREATE is deeply flawed in that it allows the *guest* to
create a VMSA with guest-controlled SEV_FEATURES.  A well behaved guest
can inform the hypervisor, i.e. KVM, of its "requested" features, but on
CPUs without ALLOWED_SEV_FEATURES support, nothing prevents the guest from
lying about which SEV features are being enabled (or not!).

If a misbehaving guest enables DebugSwap in a secondary vCPU's VMSA, the
CPU will load the DR0..DR3 mask MSRs on #VMEXIT, i.e. will clobber the
MSRs with '0' if KVM doesn't save its desired value.

Note, DR0..DR3 themselves are "ok", as DR7 is reset on #VMEXIT, and KVM
restores all DRs in common x86 code as needed via hw_breakpoint_restore().
I.e. there is no risk of host DR0..DR3 being clobbered (when it matters).
However, there is a flaw in the opposite direction; because the guest can
lie about enabling DebugSwap, i.e. can *disable* DebugSwap without KVM's
knowledge, KVM must not rely on the CPU to restore DRs.  Defer fixing
that wart, as it's more of a documentation issue than a bug in the code.

Note, KVM added support for DebugSwap on commit d1f85fbe836e ("KVM: SEV:
Enable data breakpoints in SEV-ES"), but that is not an appropriate Fixes,
as the underlying flaw exists in hardware, not in KVM.  I.e. all kernels
that support SEV-SNP need to be patched, not just kernels with KVM's full
support for DebugSwap (ignoring that DebugSwap support landed first).

Opportunistically fix an incorrect statement in the comment; on CPUs
without DebugSwap, the CPU does NOT save or load debug registers, i.e.

Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
Cc: stable@vger.kernel.org
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Kim Phillips <kim.phillips@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20250227012541.3234589-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4567,6 +4567,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *
 
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
 {
+	struct kvm *kvm = svm->vcpu.kvm;
+
 	/*
 	 * All host state for SEV-ES guests is categorized into three swap types
 	 * based on how it is handled by hardware during a world switch:
@@ -4590,10 +4592,15 @@ void sev_es_prepare_switch_to_guest(stru
 
 	/*
 	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
-	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
-	 * saves and loads debug registers (Type-A).
+	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU does
+	 * not save or load debug registers.  Sadly, on CPUs without
+	 * ALLOWED_SEV_FEATURES, KVM can't prevent SNP guests from enabling
+	 * DebugSwap on secondary vCPUs without KVM's knowledge via "AP Create".
+	 * Save all registers if DebugSwap is supported to prevent host state
+	 * from being clobbered by a misbehaving guest.
 	 */
-	if (sev_vcpu_has_debug_swap(svm)) {
+	if (sev_vcpu_has_debug_swap(svm) ||
+	    (sev_snp_guest(kvm) && cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP))) {
 		hostsa->dr0 = native_get_debugreg(0);
 		hostsa->dr1 = native_get_debugreg(1);
 		hostsa->dr2 = native_get_debugreg(2);


