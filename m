Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2FB3D75AA;
	Fri,  9 Oct 2026 14:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557222; cv=none; b=m5vTNqpqlnIcTuSNV02OPESh6iixVew4i1736Rt8hyPC1p48Zuqf+XBYO1FxKr98ZNNUTaVUwwQpC06eDdzlSQWxD48Sjn4aw8h+jV5FZ/ldZ1/OUK9009/dT89k8s7EYTUeouk3nkjC/MNeSt/nhCwriS6CFxp5tz3RtDUtfz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557222; c=relaxed/simple;
	bh=meUrWEuRsWUiQoQkw1k/SPcnXKGZL8Hn+14qId9Dhmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fql5ojZEZ9WAGVFJU9BaK/+h278mHf+TDb2A3CaYAhEa8SESiLvHXTnhqYcUDC8yE6yKSQ4TDwCeNvwIaxIUf/q3YwQiqcXUP/bDGQosmMwgUJwJOPrhDMoEWLTtkEQ+PUqumQWYo0bIaOcQT+ZCcR98PFmjuQJV5OPWP1YEi48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlwildtq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlwildtq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C4E1F000FF;
	Fri,  9 Oct 2026 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557220;
	bh=cfE4E5s4jlWB+RPPFJX/XNO/Qunv3Qd/vBxlxEbL8Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlwildtqFT6LYVcSdEi6atrMdfgUgt5MGvpwlMs99Ne/AF058d/Xvqf21cjGvlzTL
	 +do3vJjvgDuolQny7t5vp3eQykLjktKq944pRcsTBSOJr8L5hVIOorKk56PkKE32fk
	 9cTKQb+y8lrtS4hppWqpjS4ks6lU0kRSnAF4w1Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 321/428] KVM: arm64: vgic: Take a refcount on IRQs referenced by last_lr_irq
Date: Fri,  9 Oct 2026 16:10:58 +0200
Message-ID: <20261009140953.181507082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 19bc5d79ece613f242b5ec03921a3b465321bfed upstream.

Referencing the last interrupt inserted in an LR is rather fragile, as
this interrupt can vanish if a concurrently unmapped LPI.

Solve this by bumping up the refcount on the interrupt when populating
last_lr_irq, and drop it at vgic_prune_ap_list() time, when LPIs are
being reclaimed.

Fixes: 6da5e537f5afe ("KVM: arm64: vgic: Pick EOIcount deactivations from AP-list tail")
Reported-by: Yuchao Zhang <ndaugoing@gmail.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260929093548.3598547-5-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -850,6 +850,17 @@ retry:
 		goto retry;
 	}
 
+	/*
+	 * Fix the last_lr_irq refcount which was obtained while
+	 * populating the LRs. This can also result in the LPI being
+	 * deleted.
+	 */
+	irq = *host_data_ptr(last_lr_irq);
+	if (irq) {
+		deleted_lpis |= vgic_put_irq_norelease(vcpu->kvm, irq);
+		*host_data_ptr(last_lr_irq) = NULL;
+	}
+
 	raw_spin_unlock(&vgic_cpu->ap_list_lock);
 
 	if (unlikely(deleted_lpis))
@@ -1015,8 +1026,10 @@ static void vgic_flush_lr_state(struct k
 		scoped_guard(raw_spinlock,  &irq->irq_lock) {
 			if (likely(vgic_target_oracle(irq) == vcpu)) {
 				vgic_populate_lr(vcpu, irq, count++);
-				if (count == kvm_vgic_global_state.nr_lr)
+				if (count == kvm_vgic_global_state.nr_lr) {
+					vgic_get_irq_ref(irq);
 					*host_data_ptr(last_lr_irq) = irq;
+				}
 			}
 		}
 


