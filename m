Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDFC29D26C;
	Tue, 17 Mar 2026 17:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767046; cv=none; b=kIoQBpvA1Jmh2euz1CsxoOxefCKTJcEELHw3pmLLBxvJSE8IBakYy73ffJbXRAJt1GlKEbPofS/Bq97f8mUF/XmBk+TjmhSns/2djkEo4y3qYWJgTdsHeUiM9IatU3HBrIK1CdwmUUaEpARZqEawKIrblsGgru53CAVST7JRO9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767046; c=relaxed/simple;
	bh=oWm5LCrrBwFxIRh58tkHvrO+AvBJVnZVHJ/np1mcKBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6oEFQbMBA24OBcODL4HUfugzec4J0k7hdnZh5qT0tUIaRXCAJGllTyWst7dMIMvjmGNVe3mEuhnMmv25htWereL9uwWbcWLUDSCotVf566FLGcPBsKRSVYRkR90IirNil/tUBz8DIQREk5V7cdzZmUFL1xCJt7tj12A39BUU5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSeDAH+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSeDAH+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA44C4CEF7;
	Tue, 17 Mar 2026 17:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767045;
	bh=oWm5LCrrBwFxIRh58tkHvrO+AvBJVnZVHJ/np1mcKBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSeDAH+IGZqT5dU3RJjqxpNsUcN9tHmmJJjkjEbhYJ0nv/Fu44xdPfsL7T6SqBQ9W
	 sLTkKVJIyt98V/4kJ7llEDsdsCGm+Ys4vPx5q8En4IhZ7qoE7SzoykKl20NVs1Cbpm
	 OcWINsRkJAFoVV3CwFxegOw0H/uQsiLmYb5FbjDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 374/378] KVM: arm64: gic: Set vgic_model before initing private IRQs
Date: Tue, 17 Mar 2026 17:35:31 +0100
Message-ID: <20260317163020.739581176@linuxfoundation.org>
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

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

[ Upstream commit 9435c1e1431003e23aa34ef8e46c30d09c3dbcb5 ]

Different GIC types require the private IRQs to be initialised
differently. GICv5 is the culprit as it supports both a different
number of private IRQs, and all of these are PPIs (there are no
SGIs). Moreover, as GICv5 uses the top bits of the interrupt ID to
encode the type, the intid also needs to computed differently.

Up until now, the GIC model has been set after initialising the
private IRQs for a VCPU. Move this earlier to ensure that the GIC
model is available when configuring the private IRQs. While we're at
it, also move the setting of the in_kernel flag and implementation
revision to keep them grouped together as before.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20260128175919.3828384-7-sascha.bischoff@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Stable-dep-of: ac6769c8f948 ("KVM: arm64: Eagerly init vgic dist/redist on vgic creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -140,6 +140,10 @@ int kvm_vgic_create(struct kvm *kvm, u32
 		goto out_unlock;
 	}
 
+	kvm->arch.vgic.in_kernel = true;
+	kvm->arch.vgic.vgic_model = type;
+	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		ret = vgic_allocate_private_irqs_locked(vcpu, type);
 		if (ret)
@@ -156,10 +160,6 @@ int kvm_vgic_create(struct kvm *kvm, u32
 		goto out_unlock;
 	}
 
-	kvm->arch.vgic.in_kernel = true;
-	kvm->arch.vgic.vgic_model = type;
-	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;
-
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
 	aa64pfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_GIC;


