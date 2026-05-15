Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E267122FF22;
	Fri, 15 May 2026 16:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861794; cv=none; b=RYUwzVYtRYl1addOOnlaIE2URI49z8TjALuLJLKVlsbCW4hclquW8UV51Y4NCw4Zt24v9reHHRtA6zVqe8AUHn9nPhMjMY/GmFO2dv6C7URPZHINtBPAn68kfEv7hsObkJHZkHZb3UpZMHFLPzt8FZ/YLVbyb8MdcQh/SK8I36k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861794; c=relaxed/simple;
	bh=jjtG1Nyz/NgiGHAluyChiMtTBwsohSMJVAc1EVFY780=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPxnocLmPDbv2YIvynThXmYXU8QDm95kybgS+H7k0+LYgjVJR7RJqnnnuqSKY9ax9m0Dp/laIdDr3vGwv/4E9z7EyuSyG2rZOldCmTqaRIcKD2FFSkjctMNILJncxAkYrMUIe8M6r/Aa+w4Hq9Cx9CRpP/083IQFdc3jFWHncI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKtOgkdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKtOgkdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A175C2BCB0;
	Fri, 15 May 2026 16:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861793;
	bh=jjtG1Nyz/NgiGHAluyChiMtTBwsohSMJVAc1EVFY780=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKtOgkdvXrtvvD+fhcB39VeDMGr/rukZBqh4QJ+eNWzU5tmxWT4pFfHE/DcLkOFaN
	 an9yfCo9nBdTlww3NDHoSSBWXae6GD4Lz/ID0hVB1ZV0zYVMI3Gw5cehVnFUJ6YNBC
	 yVix2MfbdvWPQZ0P0M5SbcVQil/P3BomzkKcGJ9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 463/474] KVM: arm64: Wake-up from WFI when iqrchip is in userspace
Date: Fri, 15 May 2026 17:49:32 +0200
Message-ID: <20260515154725.121657039@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 4ce98bf0865c349e7026ad9c14f48da264920953 upstream

It appears that there is nothing in the wake-up path that
evaluates whether the in-kernel interrupts are pending unless
we have a vgic.

This means that the userspace irqchip support has been broken for
about four years, and nobody noticed. It was also broken before
as we wouldn't wake-up on a PMU interrupt, but hey, who cares...

It is probably time to remove the feature altogether, because it
was a terrible idea 10 years ago, and it still is.

Fixes: b57de4ffd7c6d ("KVM: arm64: Simplify kvm_cpu_has_pending_timer()")
Link: https://patch.msgid.link/20260423163607.486345-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -557,6 +557,11 @@ int kvm_arch_vcpu_ioctl_set_mpstate(stru
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
+
+	irq_lines |= (!irqchip_in_kernel(v->kvm) &&
+		      (kvm_timer_should_notify_user(v) ||
+		       kvm_pmu_should_notify_user(v)));
+
 	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
 		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
 }


