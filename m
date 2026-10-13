Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA3B4DDB56;
	Tue, 13 Oct 2026 12:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895433; cv=none; b=dbl+bnLpTVHCk8trhVycuhMemDcDCUorkqiV6+vL8gPMw47zoPOunP8+NC6YMDJe/qwweP1ZW7hybQk8KdXK0Bvw/PoxtJAlR6TDKa9gGHnrJX+WnUtc7E3aScuC191BPmaqoM/4MhBvz25GMmZ6CP5eXpU8Sw7960cLPV8qGX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895433; c=relaxed/simple;
	bh=NPPnw0mtK01nQ4xihloyEGe1ECAndt8nPmZ2Bxl0Byo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWzSlEphX+bgQYhYc3NYEDBDgNJpant6cDW32XkD3j642xJT9B6rKaiThCg1LogZd9yZ7D2esC+lIIUwzIuzVfUNK1hsxW/fjT810xTqZhx55R5oJmX/yROAkdnbm3niAkKq/I+NSSlprGASbPKqAqRC7a25qwcEs1eFrhxPOUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtZKswVB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtZKswVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11451F000FF;
	Tue, 13 Oct 2026 12:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895432;
	bh=9NOB77xklZPOApdfyXuz2qWVVMITZf4S0+9mQKibrT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VtZKswVBzJRIBPvU8eiEM9+PK5mKVgyRVxhKgS/Qor3cXO3o6e01yi0Mkzh9eYNvR
	 2ZvfhqT+rhTwbib6++b+r3oG3vilQe+IkA9ZKxYat/640jRCHlRbtxnM6mXnL20n+1
	 EDYrDMbXJ5d78Ax5oke3L7t592mm5wrn0eATTHRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.12 271/497] KVM: arm64: vgic-its: Fix MOVALL handling of source redistributor
Date: Tue, 13 Oct 2026 13:37:18 +0200
Message-ID: <20261013112914.325250311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit 751f4641560be8568dcc5af400c0e55a283abf51 upstream.

The MOVALL command moves the pending state of all LPIs targeting a given
redistributor to another one. However, we seem to have lost the
filtering on the source RD, which means we move all LPIs to the target.

Not quite what the spec mandates.

Hack update_affinity() to take an optional source vcpu that is used as a
filter when non-NULL, restoring the filtering that was performed by
vgic_copy_lpi_list() back in the days.

Fixes: 11f4f8f3e6e06 ("KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_cmd_handle_movall()")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260929093548.3598547-7-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -344,12 +344,18 @@ static int update_lpi_config(struct kvm
 	return 0;
 }
 
-static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
+static int update_affinity(struct vgic_irq *irq,
+			   struct kvm_vcpu *from_vcpu, struct kvm_vcpu *vcpu)
 {
 	int ret = 0;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	if (from_vcpu && irq->target_vcpu != from_vcpu) {
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		return 0;
+	}
+
 	irq->target_vcpu = vcpu;
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
@@ -391,7 +397,7 @@ static void update_affinity_ite(struct k
 		return;
 
 	vcpu = collection_to_vcpu(kvm, ite->collection);
-	update_affinity(ite->irq, vcpu);
+	update_affinity(ite->irq, NULL, vcpu);
 }
 
 /*
@@ -869,7 +875,7 @@ static int vgic_its_cmd_handle_movi(stru
 
 	vgic_its_invalidate_cache(its);
 
-	return update_affinity(ite->irq, vcpu);
+	return update_affinity(ite->irq, NULL, vcpu);
 }
 
 static bool __is_visible_gfn_locked(struct vgic_its *its, gpa_t gpa)
@@ -1396,7 +1402,7 @@ static int vgic_its_cmd_handle_movall(st
 		if (!irq)
 			continue;
 
-		update_affinity(irq, vcpu2);
+		update_affinity(irq, vcpu1, vcpu2);
 
 		vgic_put_irq(kvm, irq);
 	}


