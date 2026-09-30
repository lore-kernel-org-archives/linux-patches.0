Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B474511E66;
	Wed, 30 Sep 2026 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786914; cv=none; b=CFuGfkieSXiQokrIY7b/uddCfZRFdeOfQfHLPjFIWv78QpIu45Zez6DxyPEaPBNy8A7vcTVOqzGx5jXuK76LqiUZi0IXH/x+0GKaaeXc8zZpEE2WBlt4ND3YtIVToh3IxVJoqK/xlrq031y5lfhNxNi/3i+G4DoapjXpdrvfaLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786914; c=relaxed/simple;
	bh=d+h449J1SkzyBp5wwztOj0iSdx9VEzooaeCqSbIaDRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0bG0CCju0477IFH/6fKzy9lxaf5SU/RlSbeCbrDxwqAWGFvnmOitIPmJIok0l0wwL5TLpbDymMThqFHiGecn1x9IFH72rcdHkmsY7FXHCK9RVeNZPGL7Z/sltDRhLbbVQZXouTY/9DyyzaoZJ5BL/virZZY3JFVcCPtrdmmxsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oMKGT+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oMKGT+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954D61F000FF;
	Wed, 30 Sep 2026 16:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786913;
	bh=S78R3gr+Qp3DoJegFiyRHgiyLMEWOXkyoamPFd2Ulow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1oMKGT+IVYHa01JfCiPvGVDYI/fYKaTa6ulIOh9Bq89ozD5/NxEY1xANVzl+Mpoxt
	 WJZU4zuBSI3H+83O7dkHqFIRDSUX+6rob2s84zV10+LKN3YnQOQ1TZt8A4j7Vupg7l
	 yMpN5tDEL222C8lc8jxl3lKwqGqIU6u6LwMqxwd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 045/457] KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2
Date: Wed, 30 Sep 2026 17:22:30 +0200
Message-ID: <20260930152347.008672258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 73e6ee059eebb..53532f0c41628 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -360,7 +360,7 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		if (test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &host_arch_flags))
 			hyp_vm->kvm.arch.midr_el1 = host_kvm->arch.midr_el1;
 
-		return;
+		goto out;
 	}
 
 	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE))
@@ -379,13 +379,14 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
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



