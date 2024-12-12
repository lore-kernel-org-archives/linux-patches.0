Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D66228C8D;
	Thu, 12 Dec 2024 16:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020071; cv=none; b=asPgvIxBzSizr2GUdtBQ2sX1Y4djCTQJ7kfVEMB/BB0pM4ELgqn/8isJKGNZKhb+dlgjlWpYxDeICcM96m+/oNqtNQBqBhT4A2cq2EQJheKiQszmAlU0ReutJ1hj52CKNlWrgR9s0e/SPwJz/EYRurFqQO7NghbWCBLOmExubGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020071; c=relaxed/simple;
	bh=rufw4Vxv90xXQhhhJqyyLt/1ytHPmaMwB3sGScdZyBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuDGmzVyUDksokdKbFvrL5+qusSzssGTVxYlChAYqULEmk/ARc3CPtiTKxApid75g5INcOF4kpt0rq0z0kE3Fooy+2DPlJbDFtXSmjBz2l6Zgq1XwrSbPiiqfE8sRG4GKBEKTCicjhzs02Uxdm8qhmiyh6YKBddL0FnhaOD6HMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQDVvCyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQDVvCyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F422C4CED0;
	Thu, 12 Dec 2024 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020071;
	bh=rufw4Vxv90xXQhhhJqyyLt/1ytHPmaMwB3sGScdZyBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQDVvCynU1JUgCkpjTl16zpOM9I/q4XOMcdVz6iIBjElEZfL6ZgBmJOFsXRzM1lG2
	 XQorMmuyXboCxgaTBMmiNxpNG0ieXrLemg5FKDYZOGG7Ytf0p2ErU1rQ2aA+EDQlva
	 SaOo+n3yM67pCQOn3xQ2qE3hv6RHGON6mDWIzRow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.1 371/772] KVM: arm64: vgic-v3: Sanitise guest writes to GICR_INVLPIR
Date: Thu, 12 Dec 2024 15:55:16 +0100
Message-ID: <20241212144405.241000522@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


