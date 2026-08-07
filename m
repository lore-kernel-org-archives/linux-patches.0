Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895652F1FDF;
	Fri,  7 Aug 2026 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114776; cv=none; b=Q69OcgnBGw3zCkkAQE/eW3pZYMsph/9Mb9MMch4bHu+recBI1TXc/VydMZYSeOe1E/ItDU9TkQ9njUupb0JULGilRM3njZ53q4pbzSrgxgIu7aOp0gpUWUJkaHQGE9uXLWVeQUQvdv8urroPL5bN7lUFqv+xElvLMwa/J2GmHWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114776; c=relaxed/simple;
	bh=ylWFPQViznyx7WpUbicMWFEPG+uNzG7TCG+bmUu1hKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7YaD72w+xM6XOWyxeXSphxi9vj5qSj6e1afBrz1dNJYLtpyysUNw3oMVChbuGo8wGDIPDnPQ5CjpwntA0t34H3YG9vljnreeR2IOX/CY3vLLiPacknTjruaikwJl0hh9fVi4kHqV7quUF2sIc0+giUFEBhe3P5vSa9072EHrNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSaihVqw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSaihVqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F7D1F000E9;
	Fri,  7 Aug 2026 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114775;
	bh=FxXUNfKrzvEHN/2f0YHiF6ncmt2wV7cJNuF8V2Xdt+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSaihVqw3tuOi/g0xegiOGGAvIE+qE+W087kxzUueaCe8sz0e3n4gfxPyzN+YNHLG
	 ufalKzmwkhCf7pEFbj1+yGrUZCO0uFgifLq8oR8GvdDnPl6G9ox2Vcmu4fGqW6gLQf
	 lI5dbYVhet9Oqs1oiv6GW+5gYg2s7zkM5Qj90z0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/396] KVM: arm64: Reject guest_memfd memslots when the VM has MTE
Date: Fri,  7 Aug 2026 16:33:22 +0200
Message-ID: <20260807143425.176021728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

[ Upstream commit 679d7201c1f09e37fa1c12ce28d84079c17fc87f ]

The user cannot use MTE on VMAs created by mapping a guest_memfd file,
as arch_calc_vm_flag_bits() does not set VM_MTE_ALLOWED.

When creating a guest_memfd backed memslot,
kvm_arch_prepare_memory_region() rejects the memslot if MTE is enabled for
the VM and if guest_memfd has been mapped in a VMA that intersects the
memslot.

However, the documentation for KVM_SET_USER_MEMORY_REGION2 explicitly
states that the only condition for userspace_addr is for it to be a legal
userspace address, but the mapping is not required to be valid nor
populated at memslot creation.

If userspace sets userspace_addr to an address that hasn't been mapped, or
if userspace_addr belongs to a VMA that isn't backed by the guest_memfd
file, or if the VMA doesn't intersect the memslot, memslot creation is
successful and KVM ends up with a VM with MTE and guest_memfd-backed
memslots.

The same happens if the order is reversed: when userspace enables MTE, KVM
does not check if memslots backed by guest_memfd are already present.

Fix both issues by rejecting guest_memfd-backed memslots when MTE is
enabled, and by rejecting MTE when guest_memfd-backed memslots are already
present.

Fixes: 32e200bd6e44 ("KVM: arm64: Enable support for guest_memfd backed memory")
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://patch.msgid.link/20260722090354.94245-1-alexandru.elisei@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/kvm/api.rst |  6 ++++++
 arch/arm64/kvm/arm.c           | 25 +++++++++++++++++++------
 arch/arm64/kvm/mmu.c           |  4 ++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f835f68b4fb9..10d8a366b2072 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8259,6 +8259,12 @@ When this capability is enabled all memory in memslots must be mapped as
 attempts to create a memslot with an invalid mmap will result in an
 -EINVAL return.
 
+``guest_memfd``, even though it is an anonymous file, is not supported with MTE.
+Attempting to create a memslot backed by ``guest_memfd`` when the MTE capability
+is enabled, or attempting to enable the MTE capability after
+``guest_memfd``-backed memslots have been created, will result in an -EINVAL
+return.
+
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 10fc6783cd608..5d2435dd76f35 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -96,14 +96,27 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			&kvm->arch.flags);
 		break;
-	case KVM_CAP_ARM_MTE:
-		mutex_lock(&kvm->lock);
-		if (system_supports_mte() && !kvm->created_vcpus) {
-			r = 0;
-			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
+	case KVM_CAP_ARM_MTE: {
+		struct kvm_memory_slot *memslot;
+		int bkt;
+
+		guard(mutex)(&kvm->lock);
+		if (!system_supports_mte() || kvm->created_vcpus)
+			break;
+
+		r = 0;
+		guard(mutex)(&kvm->slots_lock);
+		kvm_for_each_memslot(memslot, bkt, kvm_memslots(kvm)) {
+			if (kvm_slot_has_gmem(memslot)) {
+				r = -EINVAL;
+				break;
+			}
 		}
-		mutex_unlock(&kvm->lock);
+		if (r == 0)
+			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
 		break;
+
+	}
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 403a635483513..b4237699705b4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2323,6 +2323,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
 		return -EINVAL;
 
+	/* guest_memfd is incompatible with MTE. */
+	if (kvm_slot_has_gmem(new) && kvm_has_mte(kvm))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
-- 
2.53.0



