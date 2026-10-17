Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF173914ED;
	Sat, 17 Oct 2026 16:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254880; cv=none; b=G+8rgjjo1ck8e9m34CiauhR9TFpFsY+SomNa9iB1gh9/kkA22IlzPHdDJcyhHKvSHg4TQrn2fEvRaqky32PTImXR5fyJk5M/3bHqMGT/JF6QvJ8OyzIfJjI1jLYzr0pW8utXkTV4D16MY2mce+P5ciF3kB7E22QKZfKQzoc95qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254880; c=relaxed/simple;
	bh=4LR1nUFCY485joS2NSYl7Ql+7/I5EZD4+O078shDyYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tB4vUjabMxW5b15mxysVyfJBxOk0sGADwvE0i5WnOe56qS34LDn5TnCKUngNTyIU8bi3hAjnfUoF5m+AQW2jDXAHLQORoZiQGg7s87zKxpllPwmlNT0OxtbrF89x49Ocgab1l1i69+tE4M3yw4I/hBB5jrAS5Mlz1MFd/jJ4x9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHKCpNkI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHKCpNkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4281F000C4;
	Sat, 17 Oct 2026 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254878;
	bh=I7tZ4sLnH1MvQhe2yU/vs4Ucf6oQFc50h8dIBxYv0P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHKCpNkI/T/TkWjS7QCZFaem+gMPJ0GK+NQOlWGsatVPB2zyPXUc+HgJ9yGjCe4/Z
	 2Ke4Rnvp5BEIaVMjuqalnkAi5MNPgQ/v6Eyg2MeuwB5BUzSUVmbIHdq6bqgN5to09K
	 hiWe3+KqwRWg50OV11wh6KUXWs7TIbW2HZKBRNxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 591/869] KVM: arm64: vgic-v3: take an LPI reference in vgic_v3_save_pending_tables
Date: Sat, 17 Oct 2026 17:57:12 +0200
Message-ID: <20261017160052.204214072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit f5b8f203bfc07a5a257dff859e66d2c500f9f509 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b217b256853c2..3d5e74585505a 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -416,9 +416,13 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 		bool is_pending;
 		bool stored;
 
+		irq = vgic_get_irq(kvm, NULL, index);
+		if (!irq)
+			continue;
+
 		vcpu = irq->target_vcpu;
 		if (!vcpu)
-			continue;
+			goto put_irq;
 
 		pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
 
@@ -429,7 +433,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 		if (ptr != last_ptr) {
 			ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
 			if (ret)
-				goto out;
+				goto put_irq;
 			last_ptr = ptr;
 		}
 
@@ -441,7 +445,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 			vgic_v4_get_vlpi_state(irq, &is_pending);
 
 		if (stored == is_pending)
-			continue;
+			goto put_irq;
 
 		if (is_pending)
 			val |= 1 << bit_nr;
@@ -449,6 +453,8 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 			val &= ~(1 << bit_nr);
 
 		ret = vgic_write_guest_lock(kvm, ptr, &val, 1);
+put_irq:
+		vgic_put_irq(kvm, irq);
 		if (ret)
 			goto out;
 	}
-- 
2.53.0



