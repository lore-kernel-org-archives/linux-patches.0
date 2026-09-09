Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26962DA775;
	Wed,  9 Sep 2026 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962527; cv=none; b=iSFeJ2kIj0fhkL7qT5Wm4CRr6h2Aj2vlErv7sc6il+0oT5xCRMa7674qiBDPQnPS2tAhuUZgCZ/cGQvb5lHFd7TR3BNaHs1KKVH8Q4p9vSIBx51AR+l1OGCYeSQQx8IinQ3ZZ6hjNlSkxn5DNlwBnXrZz7oShtcBr/m+teQb7bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962527; c=relaxed/simple;
	bh=EDNLMnIkKYmqpsHDGxthgk2H2YQ5g+xkRIRLPzzBc60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlfLdDKCwqQZZc8/ndYCvQEKYjLmW9fSOvJzolt47qFh1TOdyWf+81rF+yNGqSl8Eh2eBJPD3H9QuXzUCdwY+giHcKMCXTCBo83ffpMWSFexLrFUmdL8Ycgr2t9EKhl5BXdWSPuHeNsf1dDp50kcN0vu161kzbl0E3z81FE72nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxLjV8Cd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxLjV8Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81F71F00A3A;
	Wed,  9 Sep 2026 14:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962525;
	bh=gBOF5QEziX8tEVEDOkPQ737izVq8YULc+p7/e9gtQLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxLjV8Cd4TFGgQZtZBByVbsIiyM2Dlye9Obs+9ABVXKecEIjPQFeBJE1HaqXVhKE5
	 a4xaPgZh0jHlE5s765uzq5cZ4cUTXqC/GskbGtvRcgvdqLjz7OqhpVykLh3m/rGIFg
	 YA+7ck7SncuLYZWSjwdE4pT1j0BEgekCTWC8+IE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 321/556] KVM: arm64: vgic-v3: take an LPI reference in vgic_v3_save_pending_tables
Date: Wed,  9 Sep 2026 15:40:01 +0200
Message-ID: <20260909134241.954158215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -617,9 +617,13 @@ int vgic_v3_save_pending_tables(struct k
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
 
@@ -630,7 +634,7 @@ int vgic_v3_save_pending_tables(struct k
 		if (ptr != last_ptr) {
 			ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
 			if (ret)
-				goto out;
+				goto put_irq;
 			last_ptr = ptr;
 		}
 
@@ -642,7 +646,7 @@ int vgic_v3_save_pending_tables(struct k
 			vgic_v4_get_vlpi_state(irq, &is_pending);
 
 		if (stored == is_pending)
-			continue;
+			goto put_irq;
 
 		if (is_pending)
 			val |= 1 << bit_nr;
@@ -650,6 +654,8 @@ int vgic_v3_save_pending_tables(struct k
 			val &= ~(1 << bit_nr);
 
 		ret = vgic_write_guest_lock(kvm, ptr, &val, 1);
+put_irq:
+		vgic_put_irq(kvm, irq);
 		if (ret)
 			goto out;
 	}


