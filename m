Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D825519A2;
	Wed,  9 Sep 2026 14:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963960; cv=none; b=YvLcfKzjF9LyOCKgvJxlyuR2BPVKvq/6BDED3owKGQ+t0ytN/OuCprkarQa7K04ZLpEhlAorHsE1ENYxj8h3Oo1NHtu6W2J6Fr55Y4UebrdICGp+PxxkQT/2/E2kuJGmj46aJSbolSDjxOE8zrRjp0TCqyIV1RfdSSotLhS5Mdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963960; c=relaxed/simple;
	bh=GQSSA2Z1KCSQVTOidyVJMbLTEO7hlHX284WM4K8X4A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHfVV353OO7vVsqjxh8LM1gYXFwyby/0f8o/mY/QI6fMxR3MRfjWw0eGe3UVDwglzrmAXY7dENQE/eoRJZNu+Vj9OAA2d5UM6OjqITly0LwTM1bYyOly0m6VM5yY1+zHXbyYzRrpFo8Tm+EafjCdWEYdaFe34BTRRwiJyiRXNRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkEtBtkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkEtBtkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4865B1F00A3A;
	Wed,  9 Sep 2026 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963958;
	bh=wRqS5LeYRlKk7AboiCNpjLLNrbJSwgN6AzOvDmmuO/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkEtBtkHhAQlK5gp4XZ/pQz150TXY0YElHFKWuA6rC5xZekrnmHI06qrqtt1r87sg
	 2pKIXLuTc2wMMLNDLmNFpDvwI8PTMnsSC+sQTy20cTbijWDNhMO4jyqenBTus7/1IJ
	 kPyD6oQN5elz2TeryDnB0PLm50mSWds2bTzv3k2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 257/583] KVM: arm64: vgic-v3: take an LPI reference in vgic_v3_save_pending_tables
Date: Wed,  9 Sep 2026 15:39:02 +0200
Message-ID: <20260909134247.019419459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang <q.h.hack.winter@gmail.com>

commit f5b8f203bfc07a5a257dff859e66d2c500f9f509 upstream.

vgic_v3_save_pending_tables() iterates dist->lpi_xa using xa_for_each()
and dereferences the returned struct vgic_irq in the loop body without
holding a reference on the LPI.

The xarray iterator only provides temporary RCU coverage while looking up
the current entry. That is not sufficient for this loop body, which reads
fields from struct vgic_irq and performs guest memory accesses before the
iteration completes.

A concurrent path can trigger this race: the irqfd cached injection path
(vgic_its_inject_cached_translation) obtains a transient LPI reference
via vgic_its_check_cache() without holding kvm->lock, vcpu->mutex,
config_lock, or its_lock. If guest ITS DISCARD then drops the cache and
ITE references under its_lock, the transient inject reference may become
the final one. When vgic_put_irq() drops it, the LPI is erased from
lpi_xa and freed via kfree_rcu(). Meanwhile, vgic_v3_save_pending_tables()
may still hold a stale pointer obtained from the xarray iterator and
dereference it after the RCU grace period completes.

Fix this by re-fetching each iterated LPI via vgic_get_irq(), which takes
a stable reference, and dropping it with vgic_put_irq() on all paths.
This matches the pattern already used by other lpi_xa iterators in the
vgic ITS code.

Cc: stable@vger.kernel.org
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260807025534.34125-1-q.h.hack.winter@gmail.com
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -420,9 +420,13 @@ int vgic_v3_save_pending_tables(struct k
 		bool is_pending;
 		bool stored;
 
+		irq = vgic_get_irq(kvm, index);
+		if (!irq)
+			continue;
+
 		vcpu = irq->target_vcpu;
 		if (!vcpu)
-			continue;
+			goto put_irq;
 
 		pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
 
@@ -433,7 +437,7 @@ int vgic_v3_save_pending_tables(struct k
 		if (ptr != last_ptr) {
 			ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
 			if (ret)
-				goto out;
+				goto put_irq;
 			last_ptr = ptr;
 		}
 
@@ -445,7 +449,7 @@ int vgic_v3_save_pending_tables(struct k
 			vgic_v4_get_vlpi_state(irq, &is_pending);
 
 		if (stored == is_pending)
-			continue;
+			goto put_irq;
 
 		if (is_pending)
 			val |= 1 << bit_nr;
@@ -453,6 +457,8 @@ int vgic_v3_save_pending_tables(struct k
 			val &= ~(1 << bit_nr);
 
 		ret = vgic_write_guest_lock(kvm, ptr, &val, 1);
+put_irq:
+		vgic_put_irq(kvm, irq);
 		if (ret)
 			goto out;
 	}


