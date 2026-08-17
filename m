Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B407F3ABD99;
	Mon, 17 Aug 2026 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975428; cv=none; b=UKqy/NdOx+jNPB1kABznFIlLNDf8ETowDx1yVXv5wNWG7wVhAZsHggA3hkykeWReSeQjAZ8DGhp8B1rOYVXfWllpLmGBVE5nTedRg76x+SKAD/KOW9qUEH7obIHiRkgyjCiIbNgQSj5DaUZn3dd6CVf8YcOBdHMwE+bWdv1AgUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975428; c=relaxed/simple;
	bh=ayL6glugdTDJTDz00QOphaYyKcEFOGlIag9G9nrAHas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVeN3KQhqfCDnCjU4B0tuKqofsJp4K1f8rYZDusRSpsnIySh+ZmTdBsWyvB4ex6F3X3ldaXu3g1SyDrlmqYgg6+0NIqQsqlxmkgoIUXoOYOXTC2DPnHTYu8IqmVMWEadPk5pI3c/y5gMDH0O5/ZVVOQQHlsvKhQGPA8zx7uxK4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ze4/NG1U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ze4/NG1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3161F000E9;
	Mon, 17 Aug 2026 14:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975427;
	bh=WNRD6C0Z/scqMoqtl+F4L0JQfPXmmXSSIHtzt4Ac9HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ze4/NG1USTbuX0knM0rU2TIb+qGSZww9E8HraBcHrHYkuNxR5gJgSqgMoBG0vT0xm
	 9oRCYq7xTH1o7lYCvDOKDDC7nEa2cGeLak4H2A/kqcD/dPNI4pyvt5rfzuBsoM2O5n
	 Jia2d04tUm9d9ZlfxOd60bi7YyL0xwM+OcLURvI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Rosenthal <phil@phil.gs>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 005/389] KVM: x86/mmu: Fix use-after-free on vendor module reload
Date: Mon, 17 Aug 2026 15:27:24 +0200
Message-ID: <20260817132539.031206420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Phil Rosenthal <phil@phil.gs>

commit 52f2f7c30126037975389aa04d24c506a5177c35 upstream.

mmu_destroy_caches() destroys pte_list_desc_cache and
mmu_page_header_cache, but leaves both pointers unchanged.  The pointers
live in kvm.ko, and therefore survive when a vendor module is unloaded
while kvm.ko remains loaded.

If creation of pte_list_desc_cache fails during a subsequent vendor
module load, its assignment sets pte_list_desc_cache to NULL and the
error path calls mmu_destroy_caches().  mmu_page_header_cache still
points to the cache destroyed during the preceding vendor module
unload.  Passing that stale pointer to kmem_cache_destroy() causes a
slab use-after-free.

Reproduce the issue on a v7.1.3 kernel with CONFIG_KASAN=y,
CONFIG_KASAN_GENERIC=y, CONFIG_KVM=m, and CONFIG_KVM_INTEL=m.  A
one-shot test hook forces pte_list_desc_cache to NULL on the second
invocation of kvm_mmu_vendor_module_init():

  1. Load kvm.ko and kvm-intel.ko, creating both caches.
  2. Unload only kvm_intel, leaving kvm.ko loaded.
  3. Reload kvm_intel and force initialization through the -ENOMEM path.

KASAN reports:

  BUG: KASAN: slab-use-after-free in
  kvm_mmu_vendor_module_init+0x5b/0x170 [kvm]
  ...
  kmem_cache_destroy+0x21/0x1d0
  kvm_mmu_vendor_module_init+0x5b/0x170 [kvm]
  ...
  Allocated by task 16817:
  __kmem_cache_create_args+0x12c/0x3b0
  __kmem_cache_create.constprop.0+0xb6/0xf0 [kvm]
  kvm_mmu_vendor_module_init+0x13b/0x170 [kvm]
  ...
  Freed by task 16820:
  kmem_cache_destroy+0x117/0x1d0
  kvm_mmu_vendor_module_exit+0x21/0x30 [kvm]

Clear both pointers immediately after destroying their caches so that
the stored state reflects the caches' lifetime and repeated cleanup is
safe.

With the fix applied, the same injected vendor module reload fails with
-ENOMEM as expected and produces no KASAN report.

Fixes: cb498ea2ce1d ("KVM: Portability: Combine kvm_init and kvm_init_x86")
Cc: stable@vger.kernel.org
Signed-off-by: Phil Rosenthal <phil@phil.gs>
Message-ID: <20260718-kvm-mmu-cache-uaf-v3-1-e103b93c74e1@phil.gs>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5814,7 +5814,9 @@ static struct shrinker mmu_shrinker = {
 static void mmu_destroy_caches(void)
 {
 	kmem_cache_destroy(pte_list_desc_cache);
+	pte_list_desc_cache = NULL;
 	kmem_cache_destroy(mmu_page_header_cache);
+	mmu_page_header_cache = NULL;
 }
 
 static void kvm_set_mmio_spte_mask(void)


