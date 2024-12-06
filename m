Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AF01FCD11;
	Fri,  6 Dec 2024 15:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498077; cv=none; b=K13PAdLNelx8GoU2yrF0rhY7ZDK/ZuLIaUSLGZPHKaLuc+gsefGKCimOQW0AEo+UlMzsVggRkeBKAoeIf9y46Y/m7hz2GnGK3Op4tYsPOwWn9bcEmM/rsNrVFuqes6ch/LdZSQaL+Vc00AR5yKAK7IVdy4L1kj/cRj9QO0JeIsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498077; c=relaxed/simple;
	bh=LICoDRqU5H68em/6nNT4n4QEKQldloazsAHhLwgCGrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHiOjPufOGndiQdH4c2Tn4O9XEhX0j1jElw/7IAEv3adwhi686f8u6y0D/dwK+K31ITSsNHnlN60TwGpAf3Wk90KckCwUPUB2s/QH8q7KMcN3amQBcHlhWC0e0jwYp5/bf5YLvu3mEQs38EAa6Gj+Qmddyn7BM69ER/f10y8LrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouxyJ93s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouxyJ93s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE96C4CED1;
	Fri,  6 Dec 2024 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498076;
	bh=LICoDRqU5H68em/6nNT4n4QEKQldloazsAHhLwgCGrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouxyJ93s3KSHF2ypdMTtoo0aBaSgPA/Qlc7QHI+ljPgd/2bfgLBRZGASEKKJcbnCB
	 yono27ROcMzDaUXDejuLhekyWCw2lw4tHTgq/xjHinrjBrnhoLuADDLKA+0oDIXQYU
	 HO40VmBZSMOTLMXMIb5391sz92/A1KEjzfzX4BPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.6 478/676] KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR
Date: Fri,  6 Dec 2024 15:34:57 +0100
Message-ID: <20241206143712.035447117@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit d561491ba927cb5634094ff311795e9d618e9b86 upstream.

Make sure we filter out non-LPI invalidation when handling writes
to GICR_INVLPIR.

Fixes: 4645d11f4a553 ("KVM: arm64: vgic-v3: Implement MMIO-based LPI invalidation")
Reported-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241117165757.247686-2-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -555,6 +555,7 @@ static void vgic_mmio_write_invlpi(struc
 				   unsigned long val)
 {
 	struct vgic_irq *irq;
+	u32 intid;
 
 	/*
 	 * If the guest wrote only to the upper 32bit part of the
@@ -566,9 +567,13 @@ static void vgic_mmio_write_invlpi(struc
 	if ((addr & 4) || !vgic_lpis_enabled(vcpu))
 		return;
 
+	intid = lower_32_bits(val);
+	if (intid < VGIC_MIN_LPI)
+		return;
+
 	vgic_set_rdist_busy(vcpu, true);
 
-	irq = vgic_get_irq(vcpu->kvm, NULL, lower_32_bits(val));
+	irq = vgic_get_irq(vcpu->kvm, NULL, intid);
 	if (irq) {
 		vgic_its_inv_lpi(vcpu->kvm, irq);
 		vgic_put_irq(vcpu->kvm, irq);


