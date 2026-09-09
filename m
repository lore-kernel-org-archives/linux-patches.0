Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06F55519A2;
	Wed,  9 Sep 2026 14:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962534; cv=none; b=fb6uyVvOpyZ5qjKxZgv4+dOGDxN05cG4JDSDEESs5u4K2Sas9r6RdvDp1v5GOxUZDbfzz12pl3fG5fB/WrNuwN4i4mS55J5v846JAT2h8v/36Ww70+ucVkXsuY1zkrl9nk3t0PbfKsgZkIKPMH0jhzxY+qNDNYZOjPL5/mZId1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962534; c=relaxed/simple;
	bh=f9AcZQmm79+nesC20f/1zSHxkN4NSz9bG22s2tzM0k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzSmhdmP30gzNyqUQHeuwO7OPqlHTDbwe0/joum0oA1/ClwN3551Jx93ucZYLeqrx+x1r78smFncavddiuHMnP4NIhRPA+6yVspHw9874d4sASjTa3HyuhDYzbOiN0+sflS9ZJVRm/fwNsFz4VoYdsCb+Hec2n2lmaluPeeS+J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhmkvVzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhmkvVzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EC41F00A3A;
	Wed,  9 Sep 2026 14:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962532;
	bh=R58xxrykTGpUVyjC9OgpvCjTXgMg63lZCpJSpj6x2ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhmkvVzzSDXp/kxJdj2rpGP6rFmXyEqI2U0NmOIUg9+HfPMoCGebfF+Ple+oDwGk5
	 iLz3y6Lb2abg1o+/Rdwhd++ZwoCN1OjPmkJpEe43qa5RPq+4KhVXT6VUwNg/rb3ej8
	 KYB3T5ejrO6PSGwOnSXbobo0t0RIUgfdLsVOvhrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 323/556] KVM: arm64: vgic: Reset in_kernel on private IRQ allocation failure
Date: Wed,  9 Sep 2026 15:40:03 +0200
Message-ID: <20260909134242.021912782@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

commit 43347154e7ab642474c886bc54ad090166c0d9c9 upstream.

kvm_vgic_create() sets vgic.in_kernel before allocating the per-vCPU
private IRQs, but the allocation-failure path resets only vgic_model and
leaves in_kernel set. As irqchip_in_kernel() is !!in_kernel, the VM is
left with an in-kernel irqchip but no model, and the -EEXIST guard at the
top of kvm_vgic_create() rejects every retry, so userspace cannot recover
from a transient -ENOMEM.

Reset in_kernel alongside vgic_model on the failure path.

Fixes: 9435c1e1431003 ("KVM: arm64: gic: Set vgic_model before initing private IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260802150845.3485757-1-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -176,6 +176,7 @@ int kvm_vgic_create(struct kvm *kvm, u32
 		}
 
 		kvm->arch.vgic.vgic_model = 0;
+		kvm->arch.vgic.in_kernel = false;
 		goto out_unlock;
 	}
 


