Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769EA1F473A;
	Tue,  3 Dec 2024 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239629; cv=none; b=kQIFvKXDIufP51U8sIa089LCYqw35m7PfBSSh9NKylwKvhnr7IlcL/Xij7WrAagzS40CEoWACCmyOVUCSEUxnpLbP2+ekjutMwJFcWfv9uscpgceOcaG0Q9Aju6MHJp+/gxr5uEHO3oIs05eBhjwNFDOxvWDjllTN5TziA1SvyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239629; c=relaxed/simple;
	bh=TabT5E8xfFYE8/G0exg+7AeWLOPdFCRdYeRQTYqsYvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkoJJBo45BarKJWCO4ly+Fxg6HPTqqoGKMZxI0xfflajODAWLvdDMf32zQ2T1oE40H9nKTURkWpnCFkpGkSyeHIItJl8f3laNCu9xEafHxlpcp0v0rnO8FMqIeCSI4Ev5gW3psqBtcI8LmqcHtrWqu8u0XDFeJMgAuHHtXsnFrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zd4hfv4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zd4hfv4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDB8C4CECF;
	Tue,  3 Dec 2024 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239629;
	bh=TabT5E8xfFYE8/G0exg+7AeWLOPdFCRdYeRQTYqsYvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zd4hfv4BIs3w1iLwhA5PZWY99SJyPuOgMNKjAvoetwijFF66g3icPQPWXyanFrqy/
	 7IWe26Z1o4Hoy/vDQe2NmZ3YIBqVCLUEYzVTNyD+XklUb+8J8acXQ6oJjeCrsA3ndt
	 H7r0iLrtzNKsrv8HPJ+gmoZUt0VusazkigPFb41I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.11 648/817] KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR
Date: Tue,  3 Dec 2024 15:43:40 +0100
Message-ID: <20241203144021.253083359@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -530,6 +530,7 @@ static void vgic_mmio_write_invlpi(struc
 				   unsigned long val)
 {
 	struct vgic_irq *irq;
+	u32 intid;
 
 	/*
 	 * If the guest wrote only to the upper 32bit part of the
@@ -541,9 +542,13 @@ static void vgic_mmio_write_invlpi(struc
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


