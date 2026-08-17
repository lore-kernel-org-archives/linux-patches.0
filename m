Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD1E282F29;
	Mon, 17 Aug 2026 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978865; cv=none; b=diioOXBiP54Dlp/Fs1uKjssglHZhl1VYqEqpXCVax6ohmBpUGPtr/8UmQljqb9kzqaSXwXlEbKpSwMJ3qXH4eLwfUW/CRO+ZbZpp1U/D3zcXWkPyteqPUA2XKz5NXWT54yuaD0cM5X0iXSb9cTJz5r2s975GA+dgaCS3klEe8Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978865; c=relaxed/simple;
	bh=M6gAAGifeX/3X7Ku05TrN40OPN0FeJjmoJfeaCZxQcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzox3RtPgPSWJBipi/X02hkG3cZ/c3XkuWsGhIvXu8zYDNFrnzJDY96y5ZvErJanPLUk68zOBQhMCNGDt+Q8KEw1YIwaQarGh4zHw4SH8Q9tj2aTjKoObNn9rdLIKW9wGLPunqGXngWPoVHWZkXte053hFA4FWWBfSBYvO3kPV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nO/MgHSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nO/MgHSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62E21F000E9;
	Mon, 17 Aug 2026 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978864;
	bh=kJXmiTd26GBhU5h94I6g7uvQkHloCN8XTRD5t6+Q6Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nO/MgHSpBZeDWGzA/Ngi2wFq5/CflJF2sVtkrMTMlzfJQ04BO9RqRP20Ok2/QyiUZ
	 9xuX2kAZtwsA6W9lloXo1VoSwX7pCvm89EeXrQJPUV3Wbyl8bktBJedFw6F3C5YieP
	 En5ZNN35PqbHv7jLY6am8DFBdTIZ0W9yWZEPuM8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Rosenthal <phil@phil.gs>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 008/609] KVM: x86/mmu: Fix use-after-free on vendor module reload
Date: Mon, 17 Aug 2026 15:25:04 +0200
Message-ID: <20260817132543.425893563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -6643,7 +6643,9 @@ static struct shrinker mmu_shrinker = {
 static void mmu_destroy_caches(void)
 {
 	kmem_cache_destroy(pte_list_desc_cache);
+	pte_list_desc_cache = NULL;
 	kmem_cache_destroy(mmu_page_header_cache);
+	mmu_page_header_cache = NULL;
 }
 
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)


