Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4277F657B3;
	Tue, 23 Jan 2024 01:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971799; cv=none; b=cbEzE+LX8Ih9dDZuyiXEZHeslguLMKtDnYAxfX7gNR5PRJtRZfasv6kCTBkh8sablDqaR/n5UmogJxR9Yd8XLEg6xi4XLUdtSWCXXiEHk4aD6U3AD60N+oSn3k1TH4ZptbPOYIs95cCegwgA5D9tP/p4dNT6N4RDp2/3OuC/Xmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971799; c=relaxed/simple;
	bh=sd6nSTg5yErosQZVyVtHV0bsTpItzEtIh8O0Z/+2T38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOpR38xuqY0sTmPfMkn9qSFL7Sam9Mb6CUBfcjYHySK0aPx65rJD971VlJUmRnZGVp+7juvRrGNT+25GqjMAO3wwyEm0CYaP5bwUrXOt1+cnHGDrpLytCfYqdSQnS5I9e/YcTxw2PubMTgP5mKHjzxNwl2tdwIQlMFVdulrXcg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4BwoXto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4BwoXto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6114C43394;
	Tue, 23 Jan 2024 01:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971799;
	bh=sd6nSTg5yErosQZVyVtHV0bsTpItzEtIh8O0Z/+2T38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4BwoXtou4SMW7wobpCQF6X7VrVK8fUe9r3oLMbp010GSaOhcWVbDiXKRmMiVg8fs
	 zrJpswLkmUftLgwdRo9ilhixPbvBuAD3E7RJwDBznfOGXU6SE2JWLhUA7cB7m143Hn
	 3phYlrHUVfEMw8o8UKOq1f5jkt+wR+CqotELxy1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 233/286] KVM: arm64: vgic-its: Avoid potential UAF in LPI translation cache
Date: Mon, 22 Jan 2024 15:58:59 -0800
Message-ID: <20240122235741.040987905@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

commit ad362fe07fecf0aba839ff2cc59a3617bd42c33f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -584,7 +584,11 @@ static struct vgic_irq *vgic_its_check_c
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+
 	irq = __vgic_its_check_cache(dist, db, devid, eventid);
+	if (irq)
+		vgic_get_irq_kref(irq);
+
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	return irq;
@@ -763,6 +767,7 @@ int vgic_its_inject_cached_translation(s
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->pending_latch = true;
 	vgic_queue_irq_unlock(kvm, irq, flags);
+	vgic_put_irq(kvm, irq);
 
 	return 0;
 }


