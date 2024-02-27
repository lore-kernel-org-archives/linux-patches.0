Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31EC13B2B3;
	Tue, 27 Feb 2024 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041013; cv=none; b=dmKwker1Y8wWvh9lbt1jJfdZGbKlIUacJS9BCDv6MqQ+jeJpSeT9jiQLDywOeJ5yczE6KU9Vdckp+JaaDgyS7dxIq/Ig9qjpxbz24D0j5lBFv/nFVLcWWZhQGK11C/jjbUM75YQkFkfYSaNFl41OKG7rXR8yW6JrKahII9f1i1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041013; c=relaxed/simple;
	bh=CKkiOQvVTlY2fICjaVbXC98PcrnOP8dQvY5WGfSPHpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeVAcsYT3zs8PCJpQBBQLPRXYeUsLccfu2cGHexFG8/6cRz8aL/iFnEl8eT1DMJN/OEw0Hcof79QRdInacHb0aepH4I2KroJN/rvVZqXbTo94c9SY9r6EBnRFWDm/O8XG6+J8SXcFDjpO/rpXjKkEFevBusEc9YYkOMtDsLpJI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RW3QRAQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RW3QRAQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337FDC433C7;
	Tue, 27 Feb 2024 13:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041013;
	bh=CKkiOQvVTlY2fICjaVbXC98PcrnOP8dQvY5WGfSPHpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RW3QRAQEOzGnINeow/roXCX0fcN4MKwCCmLAMPWwghd2us5zY+Hy7dBU9KJOeTx42
	 2aZBavnzKgCtK6ut2/Vag0i+/7fo/70gK9PJe+2U7HEQ5/wZ0STNkDzec9kLwLgCcO
	 FkWygOnuiNDbBKbbOpstmQ4wfx7W9KbybO8rS62Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.7 189/334] KVM: arm64: vgic-its: Test for valid IRQ in its_sync_lpi_pending_table()
Date: Tue, 27 Feb 2024 14:20:47 +0100
Message-ID: <20240227131636.788638122@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -468,6 +468,9 @@ static int its_sync_lpi_pending_table(st
 		}
 
 		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
+
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending_latch = pendmask & (1U << bit_nr);
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);


