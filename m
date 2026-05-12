Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC92374187;
	Tue, 12 May 2026 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609653; cv=none; b=q7IESVrXkLd9c+el0zR+vzZAAdfvKUiAddgVF2BbyRsqyknwKCLFfO5glZEhoZqAeqG+cG6qb5AFIDaNPpHQ/CtXtLSTXGdWlzU/krtL08gaFtjmWEoCldWAYufTdziOa7jl8pjTHSyPjURIvPVGFzQ5HA1p35h2VplCJINCx5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609653; c=relaxed/simple;
	bh=WkGujt5aU8l0c3VwyYcXRtbn5IqgSLaadENxFd02UEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYpSO0EDWxO6Qj9ELP2+2PpFfVCiYA20f1yxNvpbtHQFk4w4m//6x+K9IL8+OTz3Rf2TMQrJKYv4xTRjLgvY9eJUhUOV/wTu6Er7eAA0vw25ygNOYqFmA99t36pNsH+Jck7Pu/v2MgnOaokybtAm5E+Eu6SrCVMoMtwo1xH2QYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGVP0SlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGVP0SlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74131C2BCB0;
	Tue, 12 May 2026 18:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609653;
	bh=WkGujt5aU8l0c3VwyYcXRtbn5IqgSLaadENxFd02UEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGVP0SlG9dabgEX/SZWsrHd2uNW6gXobeEkRVcFgJHz5Meyti4XMfde/KwcoKyVF5
	 ixP0I3Tq1J8SesK8n8K8Qym/BST9q+sM4Q1+nRuAlEAgLpVsx+sZ36DbqAqTq7Rl6n
	 wzmqVvOKYhudGdOnENIkQqSLap8C0ha1W3Lbe3Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 278/307] KVM: arm64: Wake-up from WFI when iqrchip is in userspace
Date: Tue, 12 May 2026 19:41:13 +0200
Message-ID: <20260512173945.993705345@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 4ce98bf0865c349e7026ad9c14f48da264920953 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -805,6 +805,10 @@ int kvm_arch_vcpu_runnable(struct kvm_vc
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF | HCR_VSE);
 
+	irq_lines |= (!irqchip_in_kernel(v->kvm) &&
+		      (kvm_timer_should_notify_user(v) ||
+		       kvm_pmu_should_notify_user(v)));
+
 	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
 		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
 }


