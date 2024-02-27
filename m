Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C65313A882;
	Tue, 27 Feb 2024 14:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044220; cv=none; b=TJQ+chZKKLZlJ4HBk/w/O8IufcdFLyuv7smevFY2stqz0r8AispPR6niThr4NnswAumNH61P0X+/nWxnNxJf7kP9X0+GZZGPqejnfyyg8N9VDFaDwQ0Lqoy95fVU1Kvo+7eosHLltc+Co8SHUR0sUP/hH3yqrfrz43/axeZIgLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044220; c=relaxed/simple;
	bh=JmGZfGDd3X6LvYZk5NKmAX50kazkCSpL2qK1bNlJXI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAJkRr8yJhZ9kO6/7q9+4vUJk/tb9rF3VyKt2soM5b05Pr2PmFxEKdTibx2WNFoiCusM9+bOe4B4mfQHORDU87pIjqgk9jP+/u2NIfdZSAf9/yzPzNfMVpp8jiy2oaDFrfPQD1oiM2WN0YFYwpGnhH1Oze+FYVXNPNgYmRJclsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF0Mk06i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF0Mk06i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D92DC433F1;
	Tue, 27 Feb 2024 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044219;
	bh=JmGZfGDd3X6LvYZk5NKmAX50kazkCSpL2qK1bNlJXI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XF0Mk06idZcAnZujIr+icW9Ot7F/DGSrs3XjKmjUQNip1jQw9Y+1h5MF+VOqwfCMq
	 lr4Vh/qSroduR0RhK9v4GnCujsDxifpEUDRy+uuS44t+l4RQws/W4Lvj216r59REo5
	 QDU4SQHYbxg9dYeFD8AlKJOUa74F2AQO4wqgTsWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 078/122] KVM: arm64: vgic-its: Test for valid IRQ in its_sync_lpi_pending_table()
Date: Tue, 27 Feb 2024 14:27:19 +0100
Message-ID: <20240227131601.257628033@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


