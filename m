Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC75347BD7;
	Thu, 30 Jul 2026 14:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421225; cv=none; b=bhzIoEqnBAPLSN3PaLPXFuT/8/yqqNZ8Nwtgp7RbYH9w8Gh2rdHdaTcTf2vTVQ7QeMWW8Rzd511eYyr9mEmYPCct1TE4MVCRjv4VdaUi5HLse5Y2D1RLaqPvrDQlI4QlQsivf9j9YGQHiq0UB9gTaPJRXqJJpHC9dmitY2zgPiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421225; c=relaxed/simple;
	bh=CLZTHI16XHuBaMhOrh7unRnvsGH3BrmACf2XI2PkmsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrWMkoMnA4zhiPnbMObsY9XxgRLhW5QjFSqRQ/10JVbP7RfcfCz0aHk42TCj6DAxYI+gwQn24sAPmZN3ZtOwkrwZLLSaqBBDmfx3MNTUmTd+eU/A23gFZr2eJhWWFNcqPvSOrk7mzdN+XuhsGcbIy8r3a1g3Mzh56SEnPJGUNlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFDt9hHr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFDt9hHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79921F000E9;
	Thu, 30 Jul 2026 14:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421224;
	bh=nFHr0UGV4mE2w6FAJFsnzGYLd+gxQ0VXecb8mUwQGEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFDt9hHrCqB8lsumA+EDlYEHlWIZSjK3EO8dsxar1OSjbpoJZ7NjqUb1cHloSeIDu
	 4gbPABXUkFpE8XaGBtd2DZ6Hd1b+fAKv5fomuA5gC8ARDIbk1zhmaBQgnOS4hD7xgL
	 uw6NMwLxeG6fzMC0EtNntaC6knlztwgccNLPOUBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Rosenthal <phil@phil.gs>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.1 008/744] KVM: x86/mmu: Fix use-after-free on vendor module reload
Date: Thu, 30 Jul 2026 16:04:41 +0200
Message-ID: <20260730141444.457663339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7502,7 +7502,9 @@ void kvm_mmu_invalidate_mmio_sptes(struc
 static void mmu_destroy_caches(void)
 {
 	kmem_cache_destroy(pte_list_desc_cache);
+	pte_list_desc_cache = NULL;
 	kmem_cache_destroy(mmu_page_header_cache);
+	mmu_page_header_cache = NULL;
 }
 
 static void kvm_wake_nx_recovery_thread(struct kvm *kvm)


