Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407D935F184;
	Fri,  7 Aug 2026 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116658; cv=none; b=IcUSl5BjfPmDAltN5IGLDqaPuMzMHOQ0t0UZq4l2ZPnySG5Q2ko+DpvNjZWT4AA11bAdIynAKzCkinXRTHT4gTvDYIwy9Z+Zjg0sWLQoguXATx7YBvDrY0ho/XL4oMRsKFtu5nKdxDEIangDmPhfbDDOo3vtFzRktVkhqQmU8Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116658; c=relaxed/simple;
	bh=0ip9VYX6jvXQJwlOFQmEmjSdBOgs8TBSvYoPFG1Lwmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y3liN0eDfp/gpz9BibCBVtIkziJIBGhltvuSrIfQ1+5C/g3zFmJ5OYG2HPEr4mRbFA2xlKCUbvu4/yuOK2F7vrWj05u9qx8RXAjqyztW+izs3YfHP+uuvEprfSoseHA+BLmy9/DsITHvLDT89QDoNOlu1PV4n5jT9nu9cchq2Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04ZBoi1O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04ZBoi1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AE71F000E9;
	Fri,  7 Aug 2026 15:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116657;
	bh=oIRfEvkRJkr+GWEfZ+auSg5HuZZfHTYVMMdPrTq6PzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=04ZBoi1OrDeeFm4a2BkgBARXAto/lg6o2LebveOf4IGUsnbGt3URNY0bvGbF8brD9
	 1OuFeGDjTrKfcJXG7ofFOE/qCsiYXmOcuTTGancv2mRpPg7N3kXH4QGBng46Kg0Flo
	 Ul5DUdIuzEvFcIINK5DSvysz0LOWwzIDUzvYQGnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 045/438] KVM: arm64: vgic: Fix race between LPI release and re-registration
Date: Fri,  7 Aug 2026 16:34:01 +0200
Message-ID: <20260807143428.958627500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos López <clopez@suse.de>

[ Upstream commit cbfe2b24a1ea9de35032dbdd100fdc700f5be92d ]

Fix a potential race between decrementing an LPI's reference count and
evicting that structure from the LPI xarray.

LPI structures are maintained in the VGIC LPI xarray (dist->lpi_xa).
When the reference count of an LPI structure drops to zero,
vgic_release_lpi_locked() removes the structure from the xarray and
frees it under the xarray lock.

However, the release of an LPI can race with a concurrent LPI
re-registration with the same INTID via vgic_add_lpi() on another CPU,
since the reference count drop and the xarray eviction are not performed
in a single atomic step. This can happen e.g. if the guest issues a
DISCARD while the LPI is still referenced from a vCPU's active-pending
list (ap_list), and the same INTID is re-mapped via MAPTI.

Particularly, vgic_release_lpi_locked() is called from two distinct
paths: direct release via vgic_put_irq(), and deferred release via
vgic_release_deleted_lpis(). During direct release, the issue can result
in deleting a newly registered LPI from the xarray:

  CPU0 (Releasing LPI)                    CPU1 (Adding new LPI)
  ====================                    =====================
  vgic_put_irq()
      __vgic_put_irq()
          refcount_dec_and_test()
                                          vgic_add_lpi()
                                              xa_lock_irqsave()
                                              old_irq = xa_load(.., intid)
                                              vgic_try_get_irq_ref(old_irq) == false
                        new IRQ inserted -->  __xa_store(.., intid, ..)
                                              xa_unlock_irqrestore()
  xa_lock_irqsave();
  vgic_release_lpi_locked()
      __xa_erase(.., irq->intid)   <-- BUG: new IRQ is erased
      kfree_rcu(old_irq)

During the deferred release path, the old IRQ can be leaked:

  CPU0 (Releasing LPI)                    CPU1 (Adding new LPI)
  ====================                    =====================
  vgic_put_irq_norelease()
      __vgic_put_irq()
          refcount_dec_and_test()
      irq->pending_release = true
                                          vgic_add_lpi()
                                              xa_lock_irqsave()
                                              old_irq = xa_load(.., intid)
                                              vgic_try_get_irq_ref(oldirq) == false
                 BUG: old IRQ overwritten --> __xa_store(.., intid, ..)
                                              xa_unlock_irqrestore()

  vgic_release_deleted_lpis()
      xa_lock_irqsave()
      xa_for_each() { .. } <-- old IRQ with pending_release = true
                               is gone, so it cannot be released

To fix the direct release path, move the reference count drop inside
the xarray lock, making sure that vgic_add_lpi() never encounters the
to-be-released LPI.

In the deferred release path, the refcount drop must happen under a raw
spinlock, so the xarray lock cannot be grabbed, and the same solution
does not work. Instead, update vgic_add_lpi(), so that if it evicts
an LPI from the xarray, it takes on the responsibility of freeing it.
Consequently, an LPI may now be freed concurrently after a deferred
release drops the refcount, so accessing the pending_release field is no
longer safe from use-after-free. Delete all uses of the flag, and update
vgic_release_deleted_lpis() to identify orphaned LPIs purely based on
their refcount.

Reported-by: Claude:claude-opus-4-6
Fixes: 3a08a6ca7c37 ("KVM: arm64: vgic-v3: Use bare refcount for VGIC LPIs")
Fixes: d54594accf73 ("KVM: arm64: vgic-v3: Erase LPIs from xarray outside of raw spinlocks")
Signed-off-by: Carlos López <clopez@suse.de>
Link: https://patch.msgid.link/20260715105137.3973823-4-clopez@suse.de
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 24 ++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic.c     | 18 ++++++++----------
 include/kvm/arm_vgic.h         |  3 ---
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7abb685c65465..e9ef7686a9524 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -116,18 +116,26 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		kfree(irq);
 		irq = oldirq;
 	} else {
-		ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
-	}
-
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+		/*
+		 * The entry is either empty or contains a dead LPI (refcount=0)
+		 * from the deferred release path, pending cleanup by
+		 * vgic_release_deleted_lpis(). Evict and free it if present.
+		 */
+		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
+		ret = xa_err(oldirq);
+		if (ret) {
+			xa_unlock_irqrestore(&dist->lpi_xa, flags);
+			kfree(irq);
 
-	if (ret) {
-		xa_release(&dist->lpi_xa, intid);
-		kfree(irq);
+			return ERR_PTR(ret);
+		}
 
-		return ERR_PTR(ret);
+		if (oldirq && !WARN_ON_ONCE(refcount_read(&oldirq->refcount)))
+			kfree_rcu(oldirq, rcu);
 	}
 
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+
 	/*
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
 	 * However we only have those structs for mapped IRQs, so we read in
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 4cd818ce90933..7fb9057fdd7ee 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -147,11 +147,7 @@ static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 
 static __must_check bool vgic_put_irq_norelease(struct kvm *kvm, struct vgic_irq *irq)
 {
-	if (!__vgic_put_irq(kvm, irq))
-		return false;
-
-	irq->pending_release = true;
-	return true;
+	return __vgic_put_irq(kvm, irq);
 }
 
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
@@ -168,12 +164,14 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
 	}
 
-	if (!__vgic_put_irq(kvm, irq))
+	if (!irq_is_lpi(kvm, irq->intid))
 		return;
 
-	xa_lock_irqsave(&dist->lpi_xa, flags);
-	vgic_release_lpi_locked(dist, irq);
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+	if (refcount_dec_and_lock_irqsave(&irq->refcount,
+					  &dist->lpi_xa.xa_lock, &flags)) {
+		vgic_release_lpi_locked(dist, irq);
+		xa_unlock_irqrestore(&dist->lpi_xa, flags);
+	}
 }
 
 static void vgic_release_deleted_lpis(struct kvm *kvm)
@@ -185,7 +183,7 @@ static void vgic_release_deleted_lpis(struct kvm *kvm)
 	xa_lock_irqsave(&dist->lpi_xa, flags);
 
 	xa_for_each(&dist->lpi_xa, intid, irq) {
-		if (irq->pending_release)
+		if (!refcount_read(&irq->refcount))
 			vgic_release_lpi_locked(dist, irq);
 	}
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 1388dc6028a9a..700d6c519d133 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -242,9 +242,6 @@ struct vgic_irq {
 					 * affinity reg (v3).
 					 */
 
-	bool pending_release:1;		/* Used for LPIs only, unreferenced IRQ
-					 * pending a release */
-
 	bool pending_latch:1;		/* The pending latch state used to calculate
 					 * the pending state for both level
 					 * and edge triggered IRQs. */
-- 
2.53.0



