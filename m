Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7536E7BB03;
	Wed, 21 Feb 2024 14:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525750; cv=none; b=QWbfVaHSEm/xz2m18zVMwZZXUpvWyoQcNCKCVMi4B9tE8rC8qKJpwnSityKfTOPcyiUHA8uX9oW7FmLbXB4lOIv5WS+gWD4fpoFqyUQpT7GG4ZBjU+DPY7uinOu5vJdJLnpbXtkAvRONqkxxe3uchYK0S1TxZ5sCqI+ASQmS24k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525750; c=relaxed/simple;
	bh=qs1yP0G1efgdTVPgsyXvUonh+D3TfB1RPYkSl2Rg7EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZetpdfvWE4Jp/ghQP4rY8sRKFceRD+jzKUb0n/6Z540n3AUrb7yP3F3d2+a3GA3eypE5TQvQWUMBuGOPLEhsOLvEIwpPsI/2oMRxrotG6dhg9RUzF0Rja8cSLmsRV/qxUMmJqZdqV6uzRyu/Lv+rEn8m9W8bjSjmSvdhC0RBIS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnxjbROz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnxjbROz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCD0C433C7;
	Wed, 21 Feb 2024 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525750;
	bh=qs1yP0G1efgdTVPgsyXvUonh+D3TfB1RPYkSl2Rg7EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnxjbROzX9cAD7OFbPKBCdudKuz+B7Zm8S8ORLCFxLn2bLlsbMeoxTLYOoKOkE9MW
	 YT2qaCTeZXs+k0PoDDoMNT3o3RGksLW7zb+VI8wavRPsS1heXRBaTvm1pHx9frn0fF
	 q/O6lwoknH7OYLgLHp5Ftye7KVVMMKppvgGRvelU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 252/267] KVM: arm64: vgic-its: Avoid potential UAF in LPI translation cache
Date: Wed, 21 Feb 2024 14:09:53 +0100
Message-ID: <20240221125948.164405813@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

[ Upstream commit ad362fe07fecf0aba839ff2cc59a3617bd42c33f ]

There is a potential UAF scenario in the case of an LPI translation
cache hit racing with an operation that invalidates the cache, such
as a DISCARD ITS command. The root of the problem is that
vgic_its_check_cache() does not elevate the refcount on the vgic_irq
before dropping the lock that serializes refcount changes.

Have vgic_its_check_cache() raise the refcount on the returned vgic_irq
and add the corresponding decrement after queueing the interrupt.

Cc: stable@vger.kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240104183233.3560639-1-oliver.upton@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index e06bb8ed7688..0533881bd2ab 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -581,7 +581,11 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+
 	irq = __vgic_its_check_cache(dist, db, devid, eventid);
+	if (irq)
+		vgic_get_irq_kref(irq);
+
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	return irq;
@@ -761,6 +765,7 @@ int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->pending_latch = true;
 	vgic_queue_irq_unlock(kvm, irq, flags);
+	vgic_put_irq(kvm, irq);
 
 	return 0;
 }
-- 
2.43.0



