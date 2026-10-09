Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D7F3431F8;
	Fri,  9 Oct 2026 14:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556605; cv=none; b=lc3v9+QdO1iMzmiwWAuIngbSJ7LMdaFHPg7X8Db1jqFdVmc+LuGnvw+RHsT+k5vmKv+RPs2FG9eC9vw+eAn8M43i+akB3tgvMr7ziyQ6nA7WtUyQpR0OmyLJDGvw+ARPyTuXDMPuD2DubEZ0KsicWivKTEj/ZEUWCuQBEs1nJJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556605; c=relaxed/simple;
	bh=9cPDB1fJ4nmxMyHXf33MUcA7iiTPEYImuPD1A4bw7aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu9uOyOxW3OLWPlbiAzFDuZPYcHJVFDVqFniLkMHUEwH3xlYEj+WRPCTfAyiPlihZrbCRbEXd5HBX0Qk6OnBI0EbBw9rjPYZmLHSB6N/coWWPiuy5s5aqRu3JxcRmz2FgmW5+T4A9vCUEXbdcPpQhlwJ7hEur85lDkqBb6wGlOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vH7QMFbS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vH7QMFbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6D11F000FF;
	Fri,  9 Oct 2026 14:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556604;
	bh=rtbKHtz+eaN4h3/MntyTFyHx60GzmIqoaht7Ra8JvkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vH7QMFbSeIeFum4oQv2sJLgW8wlDp+68btjzxn2MvuzFaS4terchfnbid0hRa1rAR
	 eSb+DcYbPyAPY7bmpWzGcx099y2tKaEKBcKXgaOL5RhXyoshQPivTqxnBtw7KMtQRK
	 dMckG15N8J1ai1q+HZpcxIzwojec/xrRN1C6eHIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 262/403] KVM: arm64: vgic-its: Fix MOVALL handling of source redistributor
Date: Fri,  9 Oct 2026 16:10:23 +0200
Message-ID: <20261009140958.304232551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -310,12 +310,16 @@ static int update_lpi_config(struct kvm
 	return ret;
 }
 
-static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
+static int update_affinity(struct vgic_irq *irq,
+			   struct kvm_vcpu *from_vcpu, struct kvm_vcpu *vcpu)
 {
 	struct its_vlpi_map map;
 	int ret;
 
 	guard(raw_spinlock_irqsave)(&irq->irq_lock);
+	if (from_vcpu && irq->target_vcpu != from_vcpu)
+		return 0;
+
 	irq->target_vcpu = vcpu;
 
 	if (!irq->hw)
@@ -353,7 +357,7 @@ static void update_affinity_ite(struct k
 		return;
 
 	vcpu = collection_to_vcpu(kvm, ite->collection);
-	update_affinity(ite->irq, vcpu);
+	update_affinity(ite->irq, NULL, vcpu);
 }
 
 /*
@@ -846,7 +850,7 @@ static int vgic_its_cmd_handle_movi(stru
 
 	vgic_its_invalidate_cache(its);
 
-	return update_affinity(ite->irq, vcpu);
+	return update_affinity(ite->irq, NULL, vcpu);
 }
 
 static bool __is_visible_gfn_locked(struct vgic_its *its, gpa_t gpa)
@@ -1373,7 +1377,7 @@ static int vgic_its_cmd_handle_movall(st
 		if (!irq)
 			continue;
 
-		update_affinity(irq, vcpu2);
+		update_affinity(irq, vcpu1, vcpu2);
 
 		vgic_put_irq(kvm, irq);
 	}


