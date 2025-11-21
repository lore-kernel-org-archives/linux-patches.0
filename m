Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536212765FF;
	Fri, 21 Nov 2025 13:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731538; cv=none; b=s0+jD5qnPlZuiiAFbRLBhr/SwlnA6LfVV8uWKdR3oKOgA/lkqFwKjY1vgZ8H463uWEaBZDKQ/Fp9+t6s7rgbyVtidKhSJHV0UdzT+B9V4s1JfcyUYIuUrPGOhXxg1U8+RAw+PYGE5JyciffFjwfK9QiBgmioMIpQrAnpKBMrXmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731538; c=relaxed/simple;
	bh=R6ZXdNhwz/epibZwwSqxQdeddRt9I9jqVekoPzh6Kmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTApocK3Fkk4P1Yj8VZbF8ZxeU7/r+3kEe6qr8fMitkvbJTX/9zJbU2j/cDFvbtneEdWibe+h8ZnY3GMsZC/VOG1V1O/NkjpNcOHZyxSyXhm9Vm126uq+iNP+wEjba6ST84vuTacysUFfMxRDsKjT44RVD5y/cjmKu4wje/vczA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAcNv3yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAcNv3yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D13C4CEFB;
	Fri, 21 Nov 2025 13:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731537;
	bh=R6ZXdNhwz/epibZwwSqxQdeddRt9I9jqVekoPzh6Kmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAcNv3ylzDeDsNhplqEYUFZ2UvEaPXJKJlRgqJ/QRLJeO6BdyestC577b8XSi3Spv
	 iwao05LMbDnAnS1/63RKeHAhLQiFOj9X/PvHdYwh4eSMe3ApfAyL97QRghNFFZQMAA
	 D9OXTGFv0toK5KcUp6E3ymUpdkosL68YCHxJE22Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 243/247] KVM: x86: Rename local "ecx" variables to "msr" and "pmc" as appropriate
Date: Fri, 21 Nov 2025 14:13:10 +0100
Message-ID: <20251121130203.460176356@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit ec400f6c2f2703cb6c698dd00b28cfdb8ee5cdcc ]

Rename "ecx" variables in {RD,WR}MSR and RDPMC helpers to "msr" and "pmc"
respectively, in anticipation of adding support for the immediate variants
of RDMSR and WRMSRNS, and to better document what the variables hold
(versus where the data originated).

No functional change intended.

Link: https://lore.kernel.org/r/20250805202224.1475590-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 9d7dfb95da2c ("KVM: VMX: Inject #UD if guest tries to execute SEAMCALL or TDCALL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1579,10 +1579,10 @@ EXPORT_SYMBOL_GPL(kvm_get_dr);
 
 int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
 {
-	u32 ecx = kvm_rcx_read(vcpu);
+	u32 pmc = kvm_rcx_read(vcpu);
 	u64 data;
 
-	if (kvm_pmu_rdpmc(vcpu, ecx, &data)) {
+	if (kvm_pmu_rdpmc(vcpu, pmc, &data)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
@@ -2033,23 +2033,23 @@ static int kvm_msr_user_space(struct kvm
 
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 {
-	u32 ecx = kvm_rcx_read(vcpu);
+	u32 msr = kvm_rcx_read(vcpu);
 	u64 data;
 	int r;
 
-	r = kvm_get_msr_with_filter(vcpu, ecx, &data);
+	r = kvm_get_msr_with_filter(vcpu, msr, &data);
 
 	if (!r) {
-		trace_kvm_msr_read(ecx, data);
+		trace_kvm_msr_read(msr, data);
 
 		kvm_rax_write(vcpu, data & -1u);
 		kvm_rdx_write(vcpu, (data >> 32) & -1u);
 	} else {
 		/* MSR read failed? See if we should ask user space */
-		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_RDMSR, 0,
+		if (kvm_msr_user_space(vcpu, msr, KVM_EXIT_X86_RDMSR, 0,
 				       complete_fast_rdmsr, r))
 			return 0;
-		trace_kvm_msr_read_ex(ecx);
+		trace_kvm_msr_read_ex(msr);
 	}
 
 	return kvm_x86_call(complete_emulated_msr)(vcpu, r);
@@ -2058,23 +2058,23 @@ EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
 
 int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 {
-	u32 ecx = kvm_rcx_read(vcpu);
+	u32 msr = kvm_rcx_read(vcpu);
 	u64 data = kvm_read_edx_eax(vcpu);
 	int r;
 
-	r = kvm_set_msr_with_filter(vcpu, ecx, data);
+	r = kvm_set_msr_with_filter(vcpu, msr, data);
 
 	if (!r) {
-		trace_kvm_msr_write(ecx, data);
+		trace_kvm_msr_write(msr, data);
 	} else {
 		/* MSR write failed? See if we should ask user space */
-		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_WRMSR, data,
+		if (kvm_msr_user_space(vcpu, msr, KVM_EXIT_X86_WRMSR, data,
 				       complete_fast_msr_access, r))
 			return 0;
 		/* Signal all other negative errors to userspace */
 		if (r < 0)
 			return r;
-		trace_kvm_msr_write_ex(ecx, data);
+		trace_kvm_msr_write_ex(msr, data);
 	}
 
 	return kvm_x86_call(complete_emulated_msr)(vcpu, r);


