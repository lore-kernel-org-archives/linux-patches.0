Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E8B4F5E9;
	Tue, 23 Jan 2024 00:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969888; cv=none; b=qywJ1DScVUe1PM5uJtdvw+BEwRV3b+CTAdou9PRcL+RnKz2m7IYGWzJXyVqqCb5N7h+GhuVpaeeF3uci+Vf8pmKj8rGgEtX1ZdU3vyuTHQWhzx9hnAnyz+VDoLHKFZtsZQlR/aiOghAwtGQ3AGT6Roq1ze8k0HCwfKvWUjNqj/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969888; c=relaxed/simple;
	bh=nmJ8kHU2vBl5mwipPZs3eZ6Y+xU3HrAOb9MjpqkgptM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDk8DVEi4dLC04WSM04I80ffV+4nMn1LoqGNIDhiHnrGbB09wYXp2sZfKXgiaUXDqbOs7+6Dx9k4O1g1hWCnFjKkahwuttOFiNRxczA6U+nfOc8dRRVmoYpQOfN3g5HwqQ9cu+oZe2CPabEDhllrscE1n7RxjdfT9gBxXFKe0LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPgkQVvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPgkQVvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5EEC433F1;
	Tue, 23 Jan 2024 00:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969888;
	bh=nmJ8kHU2vBl5mwipPZs3eZ6Y+xU3HrAOb9MjpqkgptM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPgkQVvWlXr3MXz7HR9bH7HtHWdsCyypLCzpoMDYucnapTLBH6iUZ32xDI3MZkkaG
	 NHQXIo7waSsGon+mtHj+DifNV5bDJwHrSbnvY7HYnKnVUfZbd047vhSK0WYfVqKwW4
	 pEUfyIh6kZOtz7HoWvsajWH+hAtze/d4B0NNLX5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.7 473/641] KVM: arm64: vgic-its: Avoid potential UAF in LPI translation cache
Date: Mon, 22 Jan 2024 15:56:17 -0800
Message-ID: <20240122235832.863358016@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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
@@ -590,7 +590,11 @@ static struct vgic_irq *vgic_its_check_c
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+
 	irq = __vgic_its_check_cache(dist, db, devid, eventid);
+	if (irq)
+		vgic_get_irq_kref(irq);
+
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	return irq;
@@ -769,6 +773,7 @@ int vgic_its_inject_cached_translation(s
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->pending_latch = true;
 	vgic_queue_irq_unlock(kvm, irq, flags);
+	vgic_put_irq(kvm, irq);
 
 	return 0;
 }


