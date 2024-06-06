Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2FB197A81;
	Thu,  6 Jun 2024 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683007; cv=none; b=XNyOIPXcsdYATHHi/hP1mLI2MPE0tZHu84Xcy0pUUHNfUAF1vrnNgf2Gkqm2ai+WEZ5nswhumqepr9M/LqO67E4AJr3wW0FA7JhH2nZteNgFzG0UQ7kpgAm9u3AWH5OU+lNMwhkN6NUlX0nqQhPoNWYOvtuLKvNh4yOaKo7UZV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683007; c=relaxed/simple;
	bh=bitw/NDyHYdot8opRQ+dikPj3j3/wAmLB9ofpn+t74s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfLTwsJKamkYQgG0ZVKOpT523tV2m5+JkPU8H1b7w2aVRFyetQeUGP9pBBUWsUf67lc9My+kvyh06biO3Pp/6pnJ61IB+iYMF4aW6izDD6cHX7k92Esb77TWKPkZMSI9zWC8AqNC0cPlqEqRkopPTPerG5IIu3SVCUbZ/oHoakY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgXj425y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgXj425y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D6AC4AF0C;
	Thu,  6 Jun 2024 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683006;
	bh=bitw/NDyHYdot8opRQ+dikPj3j3/wAmLB9ofpn+t74s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgXj425y0FeECWtMi3grosqbI+Rb4Jwg6yqgi+d7TcQ7v9LcsgSGKDZf55cnu4w7s
	 hJqeOaYxnAXZD03stJIKrgrnXU0PhTJQhJvtPORx27faiVR/t0wJ+5oQkJ8O0g4qnW
	 CNVKneOWo/3765653uNee7eduJLttje3YMq6WBfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 214/374] KVM: arm64: Destroy mpidr_data for late vCPU creation
Date: Thu,  6 Jun 2024 16:03:13 +0200
Message-ID: <20240606131658.978339880@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

[ Upstream commit ce5d2448eb8fe83aed331db53a08612286a137dd ]

A particularly annoying userspace could create a vCPU after KVM has
computed mpidr_data for the VM, either by racing against VGIC
initialization or having a userspace irqchip.

In any case, this means mpidr_data no longer fully describes the VM, and
attempts to find the new vCPU with kvm_mpidr_to_vcpu() will fail. The
fix is to discard mpidr_data altogether, as it is only a performance
optimization and not required for correctness. In all likelihood KVM
will recompute the mappings when KVM_RUN is called on the new vCPU.

Note that reads of mpidr_data are not guarded by a lock; promote to RCU
to cope with the possibility of mpidr_data being invalidated at runtime.

Fixes: 54a8006d0b49 ("KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240508071952.2035422-1-oliver.upton@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 50 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c4a0a35e02c72..6cda738a41577 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -195,6 +195,23 @@ void kvm_arch_create_vm_debugfs(struct kvm *kvm)
 	kvm_sys_regs_create_debugfs(kvm);
 }
 
+static void kvm_destroy_mpidr_data(struct kvm *kvm)
+{
+	struct kvm_mpidr_data *data;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	data = rcu_dereference_protected(kvm->arch.mpidr_data,
+					 lockdep_is_held(&kvm->arch.config_lock));
+	if (data) {
+		rcu_assign_pointer(kvm->arch.mpidr_data, NULL);
+		synchronize_rcu();
+		kfree(data);
+	}
+
+	mutex_unlock(&kvm->arch.config_lock);
+}
+
 /**
  * kvm_arch_destroy_vm - destroy the VM data structure
  * @kvm:	pointer to the KVM struct
@@ -209,7 +226,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	if (is_protected_kvm_enabled())
 		pkvm_destroy_hyp_vm(kvm);
 
-	kfree(kvm->arch.mpidr_data);
+	kvm_destroy_mpidr_data(kvm);
+
 	kfree(kvm->arch.sysreg_masks);
 	kvm_destroy_vcpus(kvm);
 
@@ -395,6 +413,13 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
 
+	/*
+	 * This vCPU may have been created after mpidr_data was initialized.
+	 * Throw out the pre-computed mappings if that is the case which forces
+	 * KVM to fall back to iteratively searching the vCPUs.
+	 */
+	kvm_destroy_mpidr_data(vcpu->kvm);
+
 	err = kvm_vgic_vcpu_init(vcpu);
 	if (err)
 		return err;
@@ -594,7 +619,8 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
 
 	mutex_lock(&kvm->arch.config_lock);
 
-	if (kvm->arch.mpidr_data || atomic_read(&kvm->online_vcpus) == 1)
+	if (rcu_access_pointer(kvm->arch.mpidr_data) ||
+	    atomic_read(&kvm->online_vcpus) == 1)
 		goto out;
 
 	kvm_for_each_vcpu(c, vcpu, kvm) {
@@ -631,7 +657,7 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
 		data->cmpidr_to_idx[index] = c;
 	}
 
-	kvm->arch.mpidr_data = data;
+	rcu_assign_pointer(kvm->arch.mpidr_data, data);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
 }
@@ -2470,21 +2496,27 @@ static int __init init_hyp_mode(void)
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu = NULL;
+	struct kvm_mpidr_data *data;
 	unsigned long i;
 
 	mpidr &= MPIDR_HWID_BITMASK;
 
-	if (kvm->arch.mpidr_data) {
-		u16 idx = kvm_mpidr_index(kvm->arch.mpidr_data, mpidr);
+	rcu_read_lock();
+	data = rcu_dereference(kvm->arch.mpidr_data);
 
-		vcpu = kvm_get_vcpu(kvm,
-				    kvm->arch.mpidr_data->cmpidr_to_idx[idx]);
+	if (data) {
+		u16 idx = kvm_mpidr_index(data, mpidr);
+
+		vcpu = kvm_get_vcpu(kvm, data->cmpidr_to_idx[idx]);
 		if (mpidr != kvm_vcpu_get_mpidr_aff(vcpu))
 			vcpu = NULL;
+	}
 
+	rcu_read_unlock();
+
+	if (vcpu)
 		return vcpu;
-	}
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (mpidr == kvm_vcpu_get_mpidr_aff(vcpu))
-- 
2.43.0



