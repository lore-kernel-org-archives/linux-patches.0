Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A352FFDEA;
	Tue, 17 Mar 2026 17:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767050; cv=none; b=KsRL/sWeombwGPNK7bbjOmk3sBiLj1hcVlfMEAwtkfPcS3ODk9m+GuuPT+/E2lNaAjJsUF2ILXhEbQuazQCR9wMr6L/4/1dITGIJAKwkMLne2CWgo6Bq0MkUAukIqHhZM2foKjq0dXyIvpqrN7I0DuWxdsgo+qVVvy/6RAacgWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767050; c=relaxed/simple;
	bh=6FZWtxum59yeIgs420F93N4GNPme0hIIG2af+ODBVGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8bYkPLa3o7nxt/5EGKu0Km1BeqCAEKeJ47hU4SgE74Qxv4tNENls3I2iCdyYMS/LpGHLIc62QYgb5OM8QyOaScFJrvQ5FAPh/Ce7s1DeL9aXTzD8ZaH/nFFH+Uc2Ua0Q8Q9zh2c2QpNd0KRzmgxYynsmI9ZvVqfUMf0bopcXHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKSAKjWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKSAKjWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18512C4CEF7;
	Tue, 17 Mar 2026 17:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767050;
	bh=6FZWtxum59yeIgs420F93N4GNPme0hIIG2af+ODBVGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKSAKjWVB6aa2jRevw0WVUDFzMFI+aAMeHaeHe7Og4xSiL27NEbahzg3ww//V8zpF
	 7HXvQdSqabDo11JJbrihKeIWa8qMFALrAxLPf8lheKD9Qya4Bt5FfJfizwk8FU+70h
	 C0XSesM4mLJ6jaZBFksx+v8DnVxxH+2MGrtHndcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 375/378] KVM: arm64: Eagerly init vgic dist/redist on vgic creation
Date: Tue, 17 Mar 2026 17:35:32 +0100
Message-ID: <20260317163020.776734857@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit ac6769c8f948dff33265c50e524aebf9aa6f1be0 ]

If vgic_allocate_private_irqs_locked() fails for any odd reason,
we exit kvm_vgic_create() early, leaving dist->rd_regions uninitialised.

kvm_vgic_dist_destroy() then comes along and walks into the weeds
trying to free the RDs. Got to love this stuff.

Solve it by moving all the static initialisation early, and make
sure that if we fail halfway, we're in a reasonable shape to
perform the rest of the teardown. While at it, reset the vgic model
on failure, just in case...

Reported-by: syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com
Tested-by: syzbot+f6a46b038fc243ac0175@syzkaller.appspotmail.com
Fixes: b3aa9283c0c50 ("KVM: arm64: vgic: Hoist SGI/PPI alloc from vgic_init() to kvm_create_vgic()")
Link: https://lore.kernel.org/r/69a2d58c.050a0220.3a55be.003b.GAE@google.com
Link: https://patch.msgid.link/20260228164559.936268-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-init.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -143,6 +143,21 @@ int kvm_vgic_create(struct kvm *kvm, u32
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
 	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;
+	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
+
+	aa64pfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_GIC;
+	pfr1 = kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
+
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V2) {
+		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
+	} else {
+		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
+		aa64pfr0 |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
+		pfr1 |= SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
+	}
+
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
+	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		ret = vgic_allocate_private_irqs_locked(vcpu, type);
@@ -157,25 +172,10 @@ int kvm_vgic_create(struct kvm *kvm, u32
 			vgic_cpu->private_irqs = NULL;
 		}
 
+		kvm->arch.vgic.vgic_model = 0;
 		goto out_unlock;
 	}
 
-	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
-
-	aa64pfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_GIC;
-	pfr1 = kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
-
-	if (type == KVM_DEV_TYPE_ARM_VGIC_V2) {
-		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
-	} else {
-		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
-		aa64pfr0 |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
-		pfr1 |= SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
-	}
-
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
-	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
-
 	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap = system_supports_direct_sgis();
 


