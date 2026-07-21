Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807E243935B;
	Tue, 21 Jul 2026 23:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674874; cv=none; b=bB9hfPowJj5lp04g0qlRnXJO8F5ibydKtQn5JnJTFiuLTfVT6fmLx6ShAY+HHhHS+Y5Qs0w0LmMLfE2MuoOUw6KjMNk27C8vJiOrwLevYo9eUJLgn1VAnNzzDNmrZ6sOcuodM1EmQWoFb76laOeLw94VfaYhzjyFsdCQKVPdVDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674874; c=relaxed/simple;
	bh=FTq0DbWKwNX9q0jm+0YlIA09GneIpFQTfetr506yye8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9i6fNdc9MI+1dT1owQ4MxBiZnbTx5uJDoHqyD2A2uWIv33uOxdeHDqaYhpWf7Uf/Hl7qo8JZ1CrJJdib0XlFD1dg09fVduFPYZQbf6NcqfjlN++zv7mfWALwzYs63ITjVQbhxgWJFpIf01h1/idRP2fA3l4xft/2PmQboBqm8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0Wq06nk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0Wq06nk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60E81F000E9;
	Tue, 21 Jul 2026 23:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674873;
	bh=dzYXAoI7GZhjgc4Kq5jut+EEgUZaVqqq2o96t2qktMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0Wq06nklrGNw7eIXZPA9DY+ITgDfk1i5rQYwHXXTTa4xudA4qCleAsn5nc4Oq8l0
	 58smtU6ozJqmdXUVaL4R+nmToPYQkvPcmKYYsgVLUyzfSLSnWA+wR3ZI/ZLLPf362U
	 lW0CdlGcJQwWU/tJs8Jrm7dDqnR8hGq1zq0c8sOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 686/699] KVM: Move kvm_io_bus_get_dev() locking responsibilities to callers
Date: Tue, 21 Jul 2026 17:27:25 +0200
Message-ID: <20260721152411.250375086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/kvm/vgic/vgic-its.c |   15 +++++++++++----
 virt/kvm/kvm_main.c            |   16 +++++-----------
 2 files changed, 16 insertions(+), 15 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -704,6 +704,8 @@ struct vgic_its *vgic_msi_to_its(struct
 	u64 address;
 	struct kvm_io_device *kvm_io_dev;
 	struct vgic_io_device *iodev;
+	struct vgic_its *its = NULL;
+	int srcu_idx;
 
 	if (!vgic_has_its(kvm))
 		return ERR_PTR(-ENODEV);
@@ -713,18 +715,23 @@ struct vgic_its *vgic_msi_to_its(struct
 
 	address = (u64)msi->address_hi << 32 | msi->address_lo;
 
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+
 	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
 	if (!kvm_io_dev)
-		return ERR_PTR(-EINVAL);
+		goto out;
 
 	if (kvm_io_dev->ops != &kvm_io_gic_ops)
-		return ERR_PTR(-EINVAL);
+		goto out;
 
 	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
 	if (iodev->iodev_type != IODEV_ITS)
-		return ERR_PTR(-EINVAL);
+		goto out;
 
-	return iodev->its;
+	its = iodev->its;
+out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	return its ?: ERR_PTR(-EINVAL);
 }
 
 /*
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4558,25 +4558,19 @@ struct kvm_io_device *kvm_io_bus_get_dev
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
 


