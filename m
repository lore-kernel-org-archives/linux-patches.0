Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9521814532C;
	Tue, 27 Feb 2024 13:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041577; cv=none; b=H+hU0kHgefmAWYjO+KJp1W+NL4D2R6vv+henF5HyWG3LFhbRoIKgLLUGXTFMl4DPUJL8RjgRJzKSUbGJTuInV1n7/cQWx1vauCuaa4nozFLnGcqYbyu9awjuytDPHeRbaKS/HEYxfqy0p6WUwXj4jbB3aVYpIE3XCmaGM/DJIJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041577; c=relaxed/simple;
	bh=c0RMkEci6p8Ohc0SclYTOCnLXcdNNNWj2Fvi1sSEjfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaBk8F48/P2wjwDxbGCEeMwKoFHYtpu0PeIDAoh/0ITigrYdzYdX2b8UAm5z+xnx+gBgc49TMeUM2zTo6CzCCKMnY5l0ViAXHDR4cAjohu59EozrsG31AyldV+wYP8dMyCc9PMiO4vbbNdC8lXefqxLEhNmCtBmrC9mohkAZmCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aD4aolks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aD4aolks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23795C433C7;
	Tue, 27 Feb 2024 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041577;
	bh=c0RMkEci6p8Ohc0SclYTOCnLXcdNNNWj2Fvi1sSEjfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aD4aolks0ggmLQzorV/cvfJAMz0Aye+zM2fWOf31ngcNypKk12Iz6rxYDffSzynKT
	 hHdsPEdcCtqvufei7QY46H7zorZtEfzvqJ9lEG6b7PyKUAEeBPxtLViGhBuix+nBGT
	 xY75Gg0evJd+hTspFV9+SEbNyMZc60IC/Z0bG6ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 49/52] KVM: arm64: vgic-its: Test for valid IRQ in its_sync_lpi_pending_table()
Date: Tue, 27 Feb 2024 14:26:36 +0100
Message-ID: <20240227131550.145939523@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 virt/kvm/arm/vgic/vgic-its.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -469,6 +469,9 @@ static int its_sync_lpi_pending_table(st
 		}
 
 		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
+
 		spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending_latch = pendmask & (1U << bit_nr);
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);


