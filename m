Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFB012F5BC;
	Tue, 23 Jan 2024 01:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971780; cv=none; b=XlwLpwqbqOVK6FP1QPamxai7MMEvm+kLjOHhp4PgoxOUyx/yZZpmUH1LQgXAHV6mTHuB3l6zsfo4XWKM9nfjyhnvTXyWnT42yAQyO/SASIdq3GFbHc15sShjG0ijgfFILB3kftJfkei8U75HuAKtp/UdaK+b59Wc7WbCGMfgxUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971780; c=relaxed/simple;
	bh=gS21zIpAU1HEsMzRQSM5PiWTUtQhx40pFHV7SZmHWc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bck6YO97hEI5rldHUADdzI4aTXO2FCT+Sp2cjYt9Tma9WX4ipXANthIM5kpqhVL3XhtlNleXRLYAQ1cTpg5IZKD6sakXNiWfQfMNVPIzzkdQS+GJszhdh3LLteVzQu9Jf4dcQ6Pj+8vHGKrrJslAk9tiIrr05UpP7fsT9Xs1tV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbBRhH6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbBRhH6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23F6C433F1;
	Tue, 23 Jan 2024 01:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971780;
	bh=gS21zIpAU1HEsMzRQSM5PiWTUtQhx40pFHV7SZmHWc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbBRhH6px3mLSPqZiCW8HkCTquNQtShlBPb71vwTmOwKDU7O6Quwuna7rjodfdp8I
	 13lFNQkj+t9MTMQ1WBFwRmZf7atnFfndGJIQlfMmUHSY9ma/miAKKXL1gcIekOSyRt
	 DB8c/PLc3cK7gKzI2GSK0Wo7uZieDPL8zDS14rVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 318/417] KVM: arm64: vgic-its: Avoid potential UAF in LPI translation cache
Date: Mon, 22 Jan 2024 15:58:06 -0800
Message-ID: <20240122235802.830337969@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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


