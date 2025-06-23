Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F298E1AD3FA;
	Mon, 23 Jun 2025 21:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715705; cv=none; b=fi6eB/eSdxfxP3HDd0SVSKHaGV87seMnguWqsdjrCh2Tntds5mTk8YDjO0+bcJVVacQEgug0F7P/0hc2l6tAMLWnTp7BJB0Tr4FfdnJ7uppb8HWVpbR58YKeA4IzyEmP4bdhYGthRUO2eSX2YNS7HSXMMB/FV2knRlXWQB2Q0dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715705; c=relaxed/simple;
	bh=y3WvLTkFX9npRT+Tf+AwNsGiGeyu5Cq2hHWH5xwXixI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVPXKh+Y/LEEDEYGSZjBhAFkW/iCM/TVAFvpd0CGKdmpo0KE59eoVI9eaPVzl8LRd2PE9m+PnkKXRwVjIJQITyC8oRPzOVlElaXmCmo2mGhVlG7lj/XdnlWZUddxDtoQnN2Lyi5pt8E2UsOLWmO0O2c6aUrD/RyFWBBlY2NwVyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JA0lyIAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JA0lyIAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DBAC4CEEA;
	Mon, 23 Jun 2025 21:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715704;
	bh=y3WvLTkFX9npRT+Tf+AwNsGiGeyu5Cq2hHWH5xwXixI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JA0lyIAgVsCZQMVUwxk/AQ0L/RnUHxPP156KqeOziqQ/Av27G+9/AGgCFaQ9BqksS
	 pRQ4SqhzSRAvmmWW3p+GUT/0gRVWNEO3sghlElYo1q/6QfQIJXfi/tBm/BJBWrmRUP
	 2WGBRoi555LTfWVpv2ocbORMZt2C1e4zLgsvWZGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.15 475/592] Revert "mm/execmem: Unify early execmem_cache behaviour"
Date: Mon, 23 Jun 2025 15:07:13 +0200
Message-ID: <20250623130711.730836622@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit 7cd9a11dd0c3d1dd225795ed1b5b53132888e7b5 upstream.

The commit d6d1e3e6580c ("mm/execmem: Unify early execmem_cache
behaviour") changed early behaviour of execemem ROX cache to allow its
usage in early x86 code that allocates text pages when
CONFIG_MITGATION_ITS is enabled.

The permission management of the pages allocated from execmem for ITS
mitigation is now completely contained in arch/x86/kernel/alternatives.c
and therefore there is no need to special case early allocations in
execmem.

This reverts commit d6d1e3e6580ca35071ad474381f053cbf1fb6414.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250603111446.2609381-6-rppt@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/init_32.c   |    3 ---
 arch/x86/mm/init_64.c   |    3 ---
 include/linux/execmem.h |    8 +-------
 mm/execmem.c            |   40 +++-------------------------------------
 4 files changed, 4 insertions(+), 50 deletions(-)

--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -30,7 +30,6 @@
 #include <linux/initrd.h>
 #include <linux/cpumask.h>
 #include <linux/gfp.h>
-#include <linux/execmem.h>
 
 #include <asm/asm.h>
 #include <asm/bios_ebda.h>
@@ -756,8 +755,6 @@ void mark_rodata_ro(void)
 	pr_info("Write protecting kernel text and read-only data: %luk\n",
 		size >> 10);
 
-	execmem_cache_make_ro();
-
 	kernel_set_to_readonly = 1;
 
 #ifdef CONFIG_CPA_DEBUG
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -34,7 +34,6 @@
 #include <linux/gfp.h>
 #include <linux/kcore.h>
 #include <linux/bootmem_info.h>
-#include <linux/execmem.h>
 
 #include <asm/processor.h>
 #include <asm/bios_ebda.h>
@@ -1392,8 +1391,6 @@ void mark_rodata_ro(void)
 	       (end - start) >> 10);
 	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
 
-	execmem_cache_make_ro();
-
 	kernel_set_to_readonly = 1;
 
 	/*
--- a/include/linux/execmem.h
+++ b/include/linux/execmem.h
@@ -54,7 +54,7 @@ enum execmem_range_flags {
 	EXECMEM_ROX_CACHE	= (1 << 1),
 };
 
-#if defined(CONFIG_ARCH_HAS_EXECMEM_ROX) && defined(CONFIG_EXECMEM)
+#ifdef CONFIG_ARCH_HAS_EXECMEM_ROX
 /**
  * execmem_fill_trapping_insns - set memory to contain instructions that
  *				 will trap
@@ -94,15 +94,9 @@ int execmem_make_temp_rw(void *ptr, size
  * Return: 0 on success or negative error code on failure.
  */
 int execmem_restore_rox(void *ptr, size_t size);
-
-/*
- * Called from mark_readonly(), where the system transitions to ROX.
- */
-void execmem_cache_make_ro(void);
 #else
 static inline int execmem_make_temp_rw(void *ptr, size_t size) { return 0; }
 static inline int execmem_restore_rox(void *ptr, size_t size) { return 0; }
-static inline void execmem_cache_make_ro(void) { }
 #endif
 
 /**
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -254,34 +254,6 @@ out_unlock:
 	return ptr;
 }
 
-static bool execmem_cache_rox = false;
-
-void execmem_cache_make_ro(void)
-{
-	struct maple_tree *free_areas = &execmem_cache.free_areas;
-	struct maple_tree *busy_areas = &execmem_cache.busy_areas;
-	MA_STATE(mas_free, free_areas, 0, ULONG_MAX);
-	MA_STATE(mas_busy, busy_areas, 0, ULONG_MAX);
-	struct mutex *mutex = &execmem_cache.mutex;
-	void *area;
-
-	execmem_cache_rox = true;
-
-	mutex_lock(mutex);
-
-	mas_for_each(&mas_free, area, ULONG_MAX) {
-		unsigned long pages = mas_range_len(&mas_free) >> PAGE_SHIFT;
-		set_memory_ro(mas_free.index, pages);
-	}
-
-	mas_for_each(&mas_busy, area, ULONG_MAX) {
-		unsigned long pages = mas_range_len(&mas_busy) >> PAGE_SHIFT;
-		set_memory_ro(mas_busy.index, pages);
-	}
-
-	mutex_unlock(mutex);
-}
-
 static int execmem_cache_populate(struct execmem_range *range, size_t size)
 {
 	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
@@ -302,15 +274,9 @@ static int execmem_cache_populate(struct
 	/* fill memory with instructions that will trap */
 	execmem_fill_trapping_insns(p, alloc_size, /* writable = */ true);
 
-	if (execmem_cache_rox) {
-		err = set_memory_rox((unsigned long)p, vm->nr_pages);
-		if (err)
-			goto err_free_mem;
-	} else {
-		err = set_memory_x((unsigned long)p, vm->nr_pages);
-		if (err)
-			goto err_free_mem;
-	}
+	err = set_memory_rox((unsigned long)p, vm->nr_pages);
+	if (err)
+		goto err_free_mem;
 
 	err = execmem_cache_add(p, alloc_size);
 	if (err)


