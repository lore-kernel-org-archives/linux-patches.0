Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C96681ADA;
	Tue,  3 Dec 2024 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242235; cv=none; b=XZpVcnggL1+HIZxK1jNXqgNCBgBJjHnSz5RbM+KPW97BKnDg5IoHp6rgCBY/NUfuknDVEYlj5hBQVcxMB6BgKM9JQXaOrooiDKrbQ0IWQWXH36IdVO0IETznhGSGvU0CvXtXWm/DJt/sSjQihoy4i5lI1gLdUl9fDw3HkbR+gVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242235; c=relaxed/simple;
	bh=HW8RhBmzvts8UqOH1HiF1GmcDNhvm5U17TkdvnGBshA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pevo/drLobJp5UH5mC7mFNKQnkcRcs4Fi60a0q04y/7Ebpr/ROkO9kt7uUIGH4f4mpa68nDHjYD50kwmBvEEYOuSCf1NpgIfc+tPw1BjWDMMhvg9WqXSwYn7+5D2Tt99uhLschksoJUKD0/rxzPvMNb4mj26mtawh2akozgsEIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THasrRWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THasrRWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F049C4CECF;
	Tue,  3 Dec 2024 16:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242234;
	bh=HW8RhBmzvts8UqOH1HiF1GmcDNhvm5U17TkdvnGBshA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THasrRWS9dade4QxSGpVP5aNKMp1AG9clrRJKP/1BXeUQCYJVxWsNZmVnIeHFuec/
	 mggIs8kqoFLhQChzstwhSIOApd6pT86YttUjIPPJ0hC0PvdKuOpR8JK0nhoU0+I5YJ
	 6JO/HHBIWN7ornOothCZUGkU/Q6IFqMxNM2PlbxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.12 645/826] KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR
Date: Tue,  3 Dec 2024 15:46:12 +0100
Message-ID: <20241203144808.909957563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


