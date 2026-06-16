Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439773D7A14;
	Tue, 16 Jun 2026 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632911; cv=none; b=MnNYUIkrt2Oy2WqbHnu6p0k9yWVwZI0dZW8n1nbDcv5JX3cg2X0eIaDEtRIWwa5AlMRKrgFmPWNPu7H4wLa7rQOsrDx2q76UTiOL1AvuiwzhuxSMTKabO8RtgZ35+ZwVVM3rMH8FVanf0B5oA/fEJ+iP4TdP9OCvdr/ipcpepQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632911; c=relaxed/simple;
	bh=xZooL/XfzsV+x4YOJFDwurWVBcH5lPHwpWgiCxlmJEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7lIHX1ZnpJ9eGruD/vNDAka/PjXZBsitsfD90Ljjn2wck7v8YDmPuBnXV24zJe2eBdMAj7oz2OwsCx+RZi81YNMICDh6kFt9qGZkv3FN+KGBCKupXyDdRf7ATyhexSpvp2UjRoY/S9f3t03QExN6X6bDM5tIE2fVRybvJ/gKmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLYLnAS9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLYLnAS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC5F1F000E9;
	Tue, 16 Jun 2026 18:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632910;
	bh=dPF3L4I/ei4d0a4JsLGSlqvfVXWyz79bCjxvWpLiVSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLYLnAS980sghETfp77Fq8/athe0AxaHyExqDtpTRfsLIyirBG4Algfha+Vya1VNv
	 n3M5qxdDgQECcELXB4wy8r5soXcOnvu7Hty0jjBsj+iy/MLkl8AGYeIK38IaOKDjYN
	 dKb3ANnjbiRonJstWtOosrSnJ/aFWNh+byBVKGo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 500/522] KVM: arm64: Wake-up from WFI when iqrchip is in userspace
Date: Tue, 16 Jun 2026 20:30:47 +0530
Message-ID: <20260616145149.161412466@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -540,6 +540,11 @@ int kvm_arch_vcpu_ioctl_set_mpstate(stru
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


