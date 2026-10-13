Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DCB4F6499;
	Tue, 13 Oct 2026 12:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894734; cv=none; b=j2dD7dLADh9u98FI4u3Q7P2Xl3+kYzxEaP591HgJOUCbJ/5rS/bAnZrw4pOfhJs7TtWXCJdPLVdDU8/Sp1Xvc9WrYJaSvUBYB1m1gZQkZet9F5moOoATsf1y4v8YWqGUsyS0J4XfEanvkF7x/7PJuvDC4/PJcIoAsDZnB69T/5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894734; c=relaxed/simple;
	bh=ZGoFJnpJ/UDg8LjmctmqnvtQll9n5jH63a2xRWXi5vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj9+Nvh0xLXcltNcREEJu/3CmM0iWciLFRXv31UzIcxOSvLXXqF8vij7sf1DS16GHRXY8W7ZJG0asqwdsM838I61TE2vsm5K/uoBNPPxqXpGS3o9UiUwYRtjzFogOl/OSrtBcgDO4842SBhwOi33TlmQqW0Qgia+hCoGhgZsh9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eXxywjD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eXxywjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD1C1F000FF;
	Tue, 13 Oct 2026 12:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894733;
	bh=43l1O24j+HE/YPgDSp6pH5H5l0Puu/A3wG4WHrxrzWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0eXxywjDbDSmcai8RuscM7k12KZmCmT/NdB+rYwmTENE/6YRuKxw0NafeyIebxvgX
	 qVyaldwbn8EnER2F130uGORtmrw04gGWVvFVnWl6kj4DDQAlXaPaQCpsaiKexcV+gW
	 1Do+6ok0+RNvrML83mcGz5eMhaoZDypNC3iF1mqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/497] KVM: arm64: nv: Delay freeing of shadow S2 structures until VM destruction
Date: Tue, 13 Oct 2026 13:32:51 +0200
Message-ID: <20261013112907.981637616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit e5843f4effaa2ffac3e789ecd4456403564961d4 ]

We free the shadow S2 structures from kvm_arch_flush_shadow_all(), which
is a Bad Idea(tm). Freeing the page tables is fair game (this is what
this callback is for), but freeing the container that could still be
referenced by another part of the system is not great.

Instead, grow separate destructors that gets called when we tear the VM
down for good. From there, we can nuke both the individual MMUs as well
as the global array that points to them, safe in the knowledge that the
vcpus themselves have been destroyed already.

Fixes: 4f128f8e1aaac ("KVM: arm64: nv: Support multiple nested Stage-2 mmu structures")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
Link: https://patch.msgid.link/20260911162203.1919330-3-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/arm.c                |  4 ++--
 arch/arm64/kvm/nested.c             | 15 ++++++++++-----
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index d9250fa8cdd03..ae3a285e99d06 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -65,6 +65,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 
 extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
 extern int kvm_init_nested(struct kvm *kvm);
+extern void kvm_destroy_nested(struct kvm *kvm);
 extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
 extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ec229e6a0b731..2a156ddf0c314 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -218,7 +218,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 err_uninit_mmu:
 	kvm_uninit_stage2_mmu(kvm);
-	kvfree(kvm->arch.nested_mmus);
+	kvm_destroy_nested(kvm);
 err_free_cpumask:
 	free_cpumask_var(kvm->arch.supported_cpus);
 err_unshare_kvm:
@@ -275,7 +275,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	kvm_unshare_hyp(kvm, kvm + 1);
 
-	kvfree(kvm->arch.nested_mmus);
+	kvm_destroy_nested(kvm);
 	kvm_arm_teardown_hypercalls(kvm);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index aae70f62133a6..45836a9c001d1 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -37,6 +37,15 @@ int kvm_init_nested(struct kvm *kvm)
 	return kvm->arch.nested_mmus ? 0 : -ENOMEM;
 }
 
+void kvm_destroy_nested(struct kvm *kvm)
+{
+	for (int i = 0; i < kvm->arch.nested_mmus_size; i+= S2_MMU_PER_VCPU)
+		kvfree(kvm->arch.nested_mmus[i]);
+
+	kvm->arch.nested_mmus_size = 0;
+	kvfree(kvm->arch.nested_mmus);
+}
+
 static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 {
 	/*
@@ -788,16 +797,12 @@ void kvm_nested_s2_flush(struct kvm *kvm)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	for (int i = kvm->arch.nested_mmus_size - 1; i >= 0; i--) {
+	for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (!WARN_ON(atomic_read(&mmu->refcnt)))
 			kvm_free_stage2_pgd(mmu);
-
-		if ((i % S2_MMU_PER_VCPU) == 0)
-			kvfree(mmu);
 	}
-	kvm->arch.nested_mmus_size = 0;
 	kvm_uninit_stage2_mmu(kvm);
 }
 
-- 
2.53.0



