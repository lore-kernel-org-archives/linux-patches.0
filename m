Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCE8384245;
	Tue, 10 Mar 2026 11:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140774; cv=none; b=Fp7mV6ik4MOTpJYHOgIl6s9zT6/JG0rV0VfjdEb+DlMKplFmyd6K32+eg40X6V95ed0ldoWsDNUjfZ9Qv6WqHFiRVJR4ctzeR1+wMAxUHbWpSkoWex0kdXAm0FiDvq+K6boXtYolHFdMedlODODQX3fgw5Kst1ikbQnlMLUhmUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140774; c=relaxed/simple;
	bh=fGHyqMoLE0JclhqODGPxUjhe3lXaBFVKGY4aBNvsiGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EM1xCaa92vXX/yXEL1U750ZBf4YBIyUOe6N1XyTuahesFw+lD3YKDBDBOcO9Zv8+L7pqLou1piXgoa/kEdAfV7PWn9Cus1js+yQ+y5XRo/cS89SlEF5D3CF6ipO24j1b3RXGX2f+ZmUG+ks990yAOHNxQS3Tdw0c3VAVqdWv9Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2N4Q1Wy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2N4Q1Wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5C4C2BC86;
	Tue, 10 Mar 2026 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140774;
	bh=fGHyqMoLE0JclhqODGPxUjhe3lXaBFVKGY4aBNvsiGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2N4Q1WyATIHqJpedxJ1RHe1j8vwXL+B6IoKCWLhrhxKYHff68Z066nLOTr2T2KyJ
	 azpbQxpIWscbwswYLmAmQI3PcAl+AU94VIXihcvrdiTfpStplxd4YP8aBN5DaJNruv
	 +1TBWNWyyrXMx+xKeeo1HdrGJrOXLBAmhrfvHGx15kBted00iTl0/Ye9NDSqByPw1D
	 IogTjoUk+UXicxgl2nzdafmeFliSv/+eJa5qFFTEdCTvN9Bsnv2oHJoBtoKHcZHTyP
	 ov1zCl1OrhWhIaKFBiV/Yfqc8UXNOH3yz4VGLM8J1u6T6g6A4b8DGAtm92jZbCmB7O
	 KIXj5jFW+q02w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 007/311] KVM: arm64: Fix ID register initialization for non-protected pKVM guests
Date: Tue, 10 Mar 2026 07:00:54 -0400
Message-ID: <5f065e58f814339dbf1f0ad2b6f9468513bdf80f.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fuad Tabba <tabba@google.com>

[ Upstream commit 7e7c2cf0024d89443a7af52e09e47b1fe634ab17 ]

In protected mode, the hypervisor maintains a separate instance of
the `kvm` structure for each VM. For non-protected VMs, this structure is
initialized from the host's `kvm` state.

Currently, `pkvm_init_features_from_host()` copies the
`KVM_ARCH_FLAG_ID_REGS_INITIALIZED` flag from the host without the
underlying `id_regs` data being initialized. This results in the
hypervisor seeing the flag as set while the ID registers remain zeroed.

Consequently, `kvm_has_feat()` checks at EL2 fail (return 0) for
non-protected VMs. This breaks logic that relies on feature detection,
such as `ctxt_has_tcrx()` for TCR2_EL1 support. As a result, certain
system registers (e.g., TCR2_EL1, PIR_EL1, POR_EL1) are not
saved/restored during the world switch, which could lead to state
corruption.

Fix this by explicitly copying the ID registers from the host `kvm` to
the hypervisor `kvm` for non-protected VMs during initialization, since
we trust the host with its non-protected guests' features. Also ensure
`KVM_ARCH_FLAG_ID_REGS_INITIALIZED` is cleared initially in
`pkvm_init_features_from_host` so that `vm_copy_id_regs` can properly
initialize them and set the flag once done.

Fixes: 41d6028e28bd ("KVM: arm64: Convert the SVE guest vcpu flag to a vm flag")
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260213143815.1732675-4-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 35 ++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 12b2acfbcfd14..59a0102218189 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -345,6 +345,7 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
 		hyp_vm->kvm.arch.flags = host_arch_flags;
+		hyp_vm->kvm.arch.flags &= ~BIT_ULL(KVM_ARCH_FLAG_ID_REGS_INITIALIZED);
 
 		bitmap_copy(kvm->arch.vcpu_features,
 			    host_kvm->arch.vcpu_features,
@@ -471,6 +472,35 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	return ret;
 }
 
+static int vm_copy_id_regs(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+	const struct kvm *host_kvm = hyp_vm->host_kvm;
+	struct kvm *kvm = &hyp_vm->kvm;
+
+	if (!test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &host_kvm->arch.flags))
+		return -EINVAL;
+
+	if (test_and_set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
+		return 0;
+
+	memcpy(kvm->arch.id_regs, host_kvm->arch.id_regs, sizeof(kvm->arch.id_regs));
+
+	return 0;
+}
+
+static int pkvm_vcpu_init_sysregs(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	int ret = 0;
+
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		kvm_init_pvm_id_regs(&hyp_vcpu->vcpu);
+	else
+		ret = vm_copy_id_regs(hyp_vcpu);
+
+	return ret;
+}
+
 static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 			      struct pkvm_hyp_vm *hyp_vm,
 			      struct kvm_vcpu *host_vcpu)
@@ -490,8 +520,9 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 
-	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
-		kvm_init_pvm_id_regs(&hyp_vcpu->vcpu);
+	ret = pkvm_vcpu_init_sysregs(hyp_vcpu);
+	if (ret)
+		goto done;
 
 	ret = pkvm_vcpu_init_traps(hyp_vcpu);
 	if (ret)
-- 
2.51.0

