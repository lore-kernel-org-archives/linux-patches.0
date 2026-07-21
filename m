Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF1644AB62;
	Tue, 21 Jul 2026 21:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670739; cv=none; b=TjiVKNVtMKh6xk2kdqXpLuP0YyZM4Pfqy4876k4XjhHZEaKCsp65KPKdf/1qi3JfEqONanniQro6+GgBauRGJj4+vPPqxeSp5aK0CO9O053uabR3//AmXoW+nMHB8SR8P69WWFL5gkhH/AgQ/HV9JJkviyW53kyOooXmF6MXWM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670739; c=relaxed/simple;
	bh=3RnDhJs/oekE0T9tJQ2TGa0w27Nin8avcq4/NbjGCR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ug138YsNeAOt2Oegwlwo6rcxzZb4tU7TpzPozU5WhH30M440WwPNqWA0lcC0gUv+uQzeOTN24PlWHG1uhQG7eBreanvnKG4bxqg1v24gNFtwkY7Y8LS4raFYtzblJcvDSvwy74CZXknxn5I/gV8MnKf+9rkYVHcDquABU/VFMjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxLQyN+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxLQyN+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C96D1F000E9;
	Tue, 21 Jul 2026 21:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670738;
	bh=6QHBU3XrHAuI3ygeivS6jHg/lP2dQlpg7nAYQZBNkrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxLQyN+kNU7nycfxQQRVZ/bM6dkKfiu8nekw31s+xnJ4uZxeHzgWSJOWrnXbZPVp/
	 +/TM/TeYsicw4DRyYhotMo9U8W1+n0dc3VRmvDO2nmWUuRat7UltsIVMiOK0Jdyv9D
	 5Nov+e3vkFop9ASm1RowusV+VNMkNZXyZjR0utAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 1046/1067] KVM: Move kvm_io_bus_get_dev() locking responsibilities to callers
Date: Tue, 21 Jul 2026 17:27:27 +0200
Message-ID: <20260721152447.992025965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 3a07249981629ace483ebbef81ef6b34c2d2afec upstream.

kvm_io_bus_get_dev() returns a device that is only matched by the
address, and nothing else. This can cause a lifetime issue if
the matched device is not the expected type, as by the time
the caller can introspect the object, it might be gone (the srcu
lock having been dropped).

Given that there is only a single user of this helper, the simplest
option is to move the locking responsibility to the caller, which
can keep the srcu lock held for as long as it wants.

Note that this aligns with other kvm_io_bus*() helpers, which
already require the srcu lock to be held by the callers.

Reported-by: Will Deacon <will@kernel.org>
Fixes: 8a39d00670f07 ("KVM: kvm_io_bus: Add kvm_io_bus_get_dev() call")
Link: https://lore.kernel.org/all/20260626111344.802555-1-maz@kernel.org
Cc: stable@vger.kernel.org
Reviewed-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260627105105.1005990-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |    2 ++
 virt/kvm/kvm_main.c            |   16 +++++-----------
 2 files changed, 7 insertions(+), 11 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -713,6 +713,8 @@ struct vgic_its *vgic_msi_to_its(struct
 
 	address = (u64)msi->address_hi << 32 | msi->address_lo;
 
+	guard(srcu)(&kvm->srcu);
+
 	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
 	if (!kvm_io_dev)
 		return ERR_PTR(-EINVAL);
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5465,25 +5465,19 @@ struct kvm_io_device *kvm_io_bus_get_dev
 					 gpa_t addr)
 {
 	struct kvm_io_bus *bus;
-	int dev_idx, srcu_idx;
-	struct kvm_io_device *iodev = NULL;
+	int dev_idx;
 
-	srcu_idx = srcu_read_lock(&kvm->srcu);
+	lockdep_assert_held(&kvm->srcu);
 
 	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
 	if (!bus)
-		goto out_unlock;
+		return NULL;
 
 	dev_idx = kvm_io_bus_get_first_dev(bus, addr, 1);
 	if (dev_idx < 0)
-		goto out_unlock;
+		return NULL;
 
-	iodev = bus->range[dev_idx].dev;
-
-out_unlock:
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-
-	return iodev;
+	return bus->range[dev_idx].dev;
 }
 EXPORT_SYMBOL_GPL(kvm_io_bus_get_dev);
 


