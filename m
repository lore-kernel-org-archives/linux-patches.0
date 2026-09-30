Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB99D51DAF2;
	Wed, 30 Sep 2026 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792825; cv=none; b=VF6/ulZ3ycR0e1FodVtjA7K9Fg6Kn8RUIo76TStoi7ciQQeEu0hzvYKH38iy2WDjT1eVg60HWbNU41llvS04MCyQjeTP4ABAdoQ8DejkKGvU6zviLpF6Oa020j2AFY/qpoxaCrzSs5jOtK7W5tedcjSPGFSyKf8MS55OcasJS9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792825; c=relaxed/simple;
	bh=neCXbSDjmhrCsgnGVOYuNUYyCq8Gdhv/7egDuScyEL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szze6E4KVArUa79yQotMpzvV67wrOsDm9SmGckfVoAiN0S4nTQT/895/PFL70KoOXkrW39wM5PFrMbQPr6WAwu0tRZwS9q+s9QOJtcaiTyWqJRdNOXYifCpgttEkhz0xcr7LDIvwAAZzJOn9aXXa19qB9eVwAB03j9pEX0qN42A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9wbO+af; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9wbO+af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207231F000FF;
	Wed, 30 Sep 2026 18:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792823;
	bh=h/76ZZi8E/5XXK3Y0pLQedc3mTco1N/PPjraagnx55s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9wbO+afcYTZGTUkfl6yeMcdIkWfX0shU7lvlvdGsTQ2hq34VrX7a1OqHoMNVXfex
	 JkNrpaB/QPKW08C+8dnxd7udijDjMJObKZymbNUPc+EP6IJVHQeRApfTnlfRnKgbWI
	 ExGXy/zLUutigwBT8wF4HR+Rk9CNo8FUsR3UKuFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/395] KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2
Date: Wed, 30 Sep 2026 17:25:01 +0200
Message-ID: <20260930152341.475336790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 4f16c5fc8dc4c5596e3777ab9f449a54e3f85fd5 ]

pkvm_init_features_from_host() takes KVM_ARCH_FLAG_GUEST_HAS_SVE and
KVM_ARM_VCPU_SVE from the host separately, but pkvm_vcpu_init_sve()
tests the bit while vcpu_has_sve() reads the flag. A host that sets the
flag without the bit gets a vCPU with a NULL sve_state that the world
switch loads the guest's SVE state from.

Derive the flag from the bit, and drop the protected path's copy of the
host's flag, which is dead code since protected VMs are not allowed SVE.

Fixes: 41d6028e28bd ("KVM: arm64: Convert the SVE guest vcpu flag to a vm flag")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260825085948.1674721-5-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 43195083fe7d0..6eade6babbbd4 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -353,7 +353,7 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		if (test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &host_arch_flags))
 			hyp_vm->kvm.arch.midr_el1 = host_kvm->arch.midr_el1;
 
-		return;
+		goto out;
 	}
 
 	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE))
@@ -372,13 +372,14 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC))
 		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
 
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE)) {
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE))
 		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
-		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
-	}
 
 	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
+out:
+	__assign_bit(KVM_ARCH_FLAG_GUEST_HAS_SVE, &kvm->arch.flags,
+		     kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_SVE));
 }
 
 static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
-- 
2.53.0



