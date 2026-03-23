Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAE4399352;
	Mon, 23 Mar 2026 14:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276932; cv=none; b=Q+YSpnpkvfJmru1ZYMHMm1bhA/QUCfq5Ezi3b9s7uBGRhxiGOSpcM1luw6qcFiB2+FmHPVy63TwEz+rnNOOpGFd3+5c6cXkF6XZepxQtd5rpXwUPwzi+CaTWLSZs/eXnrxQh6bSFODLVT9zkH13eTvsUrPl27kGL6O8JI1LWQZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276932; c=relaxed/simple;
	bh=Ia2pqSN+108z8geIkSUtjYI2X1Y2l50XNcMxw8qlWJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDCw4WkMbhduZiuVPweVztSBMfFdEIB/rTvKQIAldfCr/1l1CD0YwRaX1c7ocn1wGTvWXJxOEGrHEM0AvVf5UGunG3I33yKfXd2cn0tUbdG+Ip9FBxri2MhZnK3KaoXGRJcrR3mMAINkoA1MYdkLGdCKZ3YJ+Szp7aGbDGfKds0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxTjjEpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxTjjEpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F701C4CEF7;
	Mon, 23 Mar 2026 14:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276931;
	bh=Ia2pqSN+108z8geIkSUtjYI2X1Y2l50XNcMxw8qlWJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxTjjEpv05vKi4PUNSVp6EoQd+eGnD3yL1eGyrEtnxpaiQYZKutLouBt6aKdvEZei
	 CLO/IxdZd3mvqWSPGyNXMygmVdHCgkXFxn6Hruo0R0kN/cVOFA7oTjpc7AgQLIf1FT
	 4zZEBdR70xBrsVkZpZdOH/a8GT93nrE7hG/HefVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/460] KVM: x86: Co-locate initialization of feature MSRs in kvm_arch_vcpu_create()
Date: Mon, 23 Mar 2026 14:44:15 +0100
Message-ID: <20260323134532.850198722@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2142ac663a6a72ac868d0768681b1355e3a703eb ]

Bunch all of the feature MSR initialization in kvm_arch_vcpu_create() so
that it can be easily quirked in a future patch.

No functional change intended.

Link: https://lore.kernel.org/r/20240802185511.305849-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: e2ffe85b6d2b ("KVM: x86: Introduce KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12383,6 +12383,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 
 	kvm_async_pf_hash_reset(vcpu);
 
+	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
+	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
 	kvm_pmu_init(vcpu);
 
@@ -12397,8 +12399,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 	if (r)
 		goto free_guest_fpu;
 
-	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
-	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	kvm_xen_init_vcpu(vcpu);
 	vcpu_load(vcpu);
 	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);


