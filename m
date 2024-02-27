Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D94678B61;
	Tue, 27 Feb 2024 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043506; cv=none; b=BvEYZ1MZYCRBacpDEBD2TolqUkyyUK5iFR7sUQhUYtEfdVp750mbURz5/IkD55eXuwaPFECPeTmh2h2TPJSioIdYX08q01Cf6RPG8C1cGNUv1Dc+eoJ+wNIQmhz9RdHcvLhQerVYASwKuSU5n+JS3g+S7xsOHvbGPCXkqO1GRL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043506; c=relaxed/simple;
	bh=egojRojeBmhURs6wDkOm5oZIZUhU73AYo0LV8O7cRxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub7cmz/UCqKUFb5mSbGy+KC7WNZoiS0Z2EVnw2ricUVMdfLE4yMK9F0YdrIP39hx+Nkleetgc1LhiDT6mjSpKBJCRUw/Dvk35Rjh4zc4YHiTftnSalv2oBfH0AfBpS929zbMd1htvxr1+kGmAsNnk/Mr0yDj28kJJ+qSg0c5MYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9bNZSl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9bNZSl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907B6C433F1;
	Tue, 27 Feb 2024 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043505;
	bh=egojRojeBmhURs6wDkOm5oZIZUhU73AYo0LV8O7cRxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9bNZSl0tmRGQoagPQIknJe3hTBOgpyJWIPBqPYqcn5faFysC6ThzXJhgl3W4TedB
	 +p0Pf5MA+jx7riZjlimzbZpdsUIuAin+bw5b8zRM48ZFcmKhn2kbl8rTdxGXS5e6DX
	 6OV14PvvzUQccAJWfzm0e9U9v2HWAvduR+0jM3aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 104/195] KVM: arm64: vgic-its: Test for valid IRQ in its_sync_lpi_pending_table()
Date: Tue, 27 Feb 2024 14:26:05 +0100
Message-ID: <20240227131613.903749245@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Oliver Upton <oliver.upton@linux.dev>

commit 8d3a7dfb801d157ac423261d7cd62c33e95375f8 upstream.

vgic_get_irq() may not return a valid descriptor if there is no ITS that
holds a valid translation for the specified INTID. If that is the case,
it is safe to silently ignore it and continue processing the LPI pending
table.

Cc: stable@vger.kernel.org
Fixes: 33d3bc9556a7 ("KVM: arm64: vgic-its: Read initial LPI pending table")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240221092732.4126848-2-oliver.upton@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -462,6 +462,9 @@ static int its_sync_lpi_pending_table(st
 		}
 
 		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
+
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending_latch = pendmask & (1U << bit_nr);
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);


