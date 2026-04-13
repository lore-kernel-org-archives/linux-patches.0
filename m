Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD422D8364;
	Mon, 13 Apr 2026 16:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098629; cv=none; b=RhfDt/K1+m9GCQAtIqgHGa+UikFs+fgUsxt8MJW/rV9eO4W0eDGDwTMZPszDFqJgEwvzq8VdYYx0xN8CasccX6Rl4R3r40dBEflYaNAY0p/AAHiuwCXQ0gou/lFs3L5zeWbA22ENKNX/5LcWtjYVFXtWYBapdn5S7p4whjH/lxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098629; c=relaxed/simple;
	bh=nA5q0HZmMh+h1u7J+Nxs2Q1t00KgKs4DUPEnP/UjH70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw8o3tWQzN+dpC0QEP2KxNPm10nIdr/0TzJRMbUlJce6VAA0nDyyFn8Hu2eFGpRrRjUb56NRFhnTq/QOaKYoy9B2UpmSKhKL/SJPi7B2wQyg9x9OurzDKzezyishuzu0Z3OqzUZ1DpvEBbE6qLMmVJ7VR/Tep6DzSnA33udfYGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TthNyfXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TthNyfXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A192C2BCAF;
	Mon, 13 Apr 2026 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098629;
	bh=nA5q0HZmMh+h1u7J+Nxs2Q1t00KgKs4DUPEnP/UjH70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TthNyfXtz0YGMYwdRokgawOHoaqqj3mSb3ePMBHxKeS6vEgAc4wiCU/8/tmBCSXQ3
	 StJEGcFbMor0mt/+Ul9K/asi6U6+xJkj1KqsTjWqfxstcyuY1cjrYalkxNwNXMXnx1
	 zr8aErB8gwj4GQG+kLYEkzIWWoyQPF0+1YtPXZyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 027/491] x86/efi: defer freeing of boot services memory
Date: Mon, 13 Apr 2026 17:54:32 +0200
Message-ID: <20260413155820.069013691@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit a4b0bf6a40f3c107c67a24fbc614510ef5719980 upstream.

efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
and EFI_BOOT_SERVICES_DATA using memblock_free_late().

There are two issue with that: memblock_free_late() should be used for
memory allocated with memblock_alloc() while the memory reserved with
memblock_reserve() should be freed with free_reserved_area().

More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
efi_free_boot_services() is called before deferred initialization of the
memory map is complete.

Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
RAM on EC2 t3a.nano instances which only have 512MB or RAM.

If the freed memory resides in the areas that memory map for them is
still uninitialized, they won't be actually freed because
memblock_free_late() calls memblock_free_pages() and the latter skips
uninitialized pages.

Using free_reserved_area() at this point is also problematic because
__free_page() accesses the buddy of the freed page and that again might
end up in uninitialized part of the memory map.

Delaying the entire efi_free_boot_services() could be problematic
because in addition to freeing boot services memory it updates
efi.memmap without any synchronization and that's undesirable late in
boot when there is concurrency.

More robust approach is to only defer freeing of the EFI boot services
memory.

Split efi_free_boot_services() in two. First efi_unmap_boot_services()
collects ranges that should be freed into an array then
efi_free_boot_services() later frees them after deferred init is complete.

Link: https://lore.kernel.org/all/ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org
Fixes: 916f676f8dc0 ("x86, efi: Retain boot service code until after switching to virtual mode")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/efi.h          |    2 -
 arch/x86/platform/efi/efi.c         |    2 -
 arch/x86/platform/efi/quirks.c      |   55 ++++++++++++++++++++++++++++++++++--
 drivers/firmware/efi/mokvar-table.c |    2 -
 4 files changed, 55 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -151,7 +151,7 @@ extern int __init efi_reuse_config(u64 t
 extern void efi_delete_dummy_variable(void);
 extern void efi_switch_mm(struct mm_struct *mm);
 extern void efi_recover_from_page_fault(unsigned long phys_addr);
-extern void efi_free_boot_services(void);
+extern void efi_unmap_boot_services(void);
 
 /* kexec external ABI */
 struct efi_setup_data {
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -831,7 +831,7 @@ static void __init __efi_enter_virtual_m
 	}
 
 	efi_check_for_embedded_firmwares();
-	efi_free_boot_services();
+	efi_unmap_boot_services();
 
 	if (!efi_is_mixed())
 		efi_native_runtime_setup();
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -333,7 +333,7 @@ void __init efi_reserve_boot_services(vo
 
 		/*
 		 * Because the following memblock_reserve() is paired
-		 * with memblock_free_late() for this region in
+		 * with free_reserved_area() for this region in
 		 * efi_free_boot_services(), we must be extremely
 		 * careful not to reserve, and subsequently free,
 		 * critical regions of memory (like the kernel image) or
@@ -396,17 +396,33 @@ static void __init efi_unmap_pages(efi_m
 		pr_err("Failed to unmap VA mapping for 0x%llx\n", va);
 }
 
-void __init efi_free_boot_services(void)
+struct efi_freeable_range {
+	u64 start;
+	u64 end;
+};
+
+static struct efi_freeable_range *ranges_to_free;
+
+void __init efi_unmap_boot_services(void)
 {
 	struct efi_memory_map_data data = { 0 };
 	efi_memory_desc_t *md;
 	int num_entries = 0;
+	int idx = 0;
+	size_t sz;
 	void *new, *new_md;
 
 	/* Keep all regions for /sys/kernel/debug/efi */
 	if (efi_enabled(EFI_DBG))
 		return;
 
+	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
+	ranges_to_free = kzalloc(sz, GFP_KERNEL);
+	if (!ranges_to_free) {
+		pr_err("Failed to allocate storage for freeable EFI regions\n");
+		return;
+	}
+
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
@@ -451,7 +467,15 @@ void __init efi_free_boot_services(void)
 			size -= rm_size;
 		}
 
-		memblock_free_late(start, size);
+		/*
+		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
+		 * map are still not initialized and we can't reliably free
+		 * memory here.
+		 * Queue the ranges to free at a later point.
+		 */
+		ranges_to_free[idx].start = start;
+		ranges_to_free[idx].end = start + size;
+		idx++;
 	}
 
 	if (!num_entries)
@@ -492,6 +516,31 @@ void __init efi_free_boot_services(void)
 	}
 }
 
+static int __init efi_free_boot_services(void)
+{
+	struct efi_freeable_range *range = ranges_to_free;
+	unsigned long freed = 0;
+
+	if (!ranges_to_free)
+		return 0;
+
+	while (range->start) {
+		void *start = phys_to_virt(range->start);
+		void *end = phys_to_virt(range->end);
+
+		free_reserved_area(start, end, -1, NULL);
+		freed += (end - start);
+		range++;
+	}
+	kfree(ranges_to_free);
+
+	if (freed)
+		pr_info("Freeing EFI boot services memory: %ldK\n", freed / SZ_1K);
+
+	return 0;
+}
+arch_initcall(efi_free_boot_services);
+
 /*
  * A number of config table entries get remapped to virtual addresses
  * after entering EFI virtual mode. However, the kexec kernel requires
--- a/drivers/firmware/efi/mokvar-table.c
+++ b/drivers/firmware/efi/mokvar-table.c
@@ -85,7 +85,7 @@ static struct kobject *mokvar_kobj;
  * as an alternative to ordinary EFI variables, due to platform-dependent
  * limitations. The memory occupied by this table is marked as reserved.
  *
- * This routine must be called before efi_free_boot_services() in order
+ * This routine must be called before efi_unmap_boot_services() in order
  * to guarantee that it can mark the table as reserved.
  *
  * Implicit inputs:


