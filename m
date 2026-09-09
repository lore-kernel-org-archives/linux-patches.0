Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A380F56C624;
	Wed,  9 Sep 2026 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963965; cv=none; b=ePCIzjXJChtuiZzq1ClblOh5Z8pxJ0esz8M2Gfx4TA85NRnPYvtscYBnV6FKg32AWylbu+mngzIXdWH0g7tJrEqD1uzvP8/Ky2x94ik3z4I/KzHAWA4RdcjehVrpQu44rTazZc4nkQuB/7qJjaItyrVDCtWqdQ8nNADim00A+0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963965; c=relaxed/simple;
	bh=n3x7OofklfWWLFUWzjL6z7U8ziGQ0Cgu6toM3TBOwLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7dKUk7CvCLdyiiZwbvcY4v3yJvQ2OwC12fShuzWygbq8K3juaSNnG/eFKUhxjaDJVzGUc1eobCOlTspQPzLt26S8xanO0CFjTuty18Y9hMgHqJoDj/ua5WKblfWM+1BRFk4BVbR7oawU1AXETBAVGBlpDn4SjccnKp1IFISzNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=av761gyO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="av761gyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F9D1F00A3A;
	Wed,  9 Sep 2026 14:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963964;
	bh=zzxF0gnSZXA807RbXvgjaV9UT2npL7H64/ci4b0Lwug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=av761gyOvQmfBmjgXA/Ix0y2o8Vdd//R1uC9pPxAWufC+Z/gZ6yJmk98nUTZ03oKi
	 fyc+YLWyAlwdQ8eBZI2TnwQENiwMDjPCgwt8I78iRNT2uyiaqHwD4wFEINLJ/4/3K5
	 TyJxZpeiGY0jYn1KY+BZP8dWFUJiBWIJ48aAAck0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 259/583] KVM: arm64: vgic: Reset in_kernel on private IRQ allocation failure
Date: Wed,  9 Sep 2026 15:39:04 +0200
Message-ID: <20260909134247.083157385@linuxfoundation.org>
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
@@ -173,6 +173,7 @@ int kvm_vgic_create(struct kvm *kvm, u32
 		}
 
 		kvm->arch.vgic.vgic_model = 0;
+		kvm->arch.vgic.in_kernel = false;
 		goto out_unlock;
 	}
 


