Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1F213B280;
	Wed,  3 Jul 2024 11:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006040; cv=none; b=gLU4KYqY2QEHGsUu8LKzx4zmc3qYm7lnG39apppI3qqRQQOaMAMxJq8BxUJSjD4DL1F+pyoRSlxxhZm4gX4G4sJAyaCuzIF1SEfIql2+KxyA6spsfoAaPlTGci8cZXg4U5GDPwtVas3ZdctB/NjV0uzzyqMhS7TQlX8SAvl19ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006040; c=relaxed/simple;
	bh=+4SxkPlwTxUCji3erXlCLbdP5Jvjt8UOsCG1nWcXcvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw5UYRBqRE5dcuhWqK/McU4DFke2/ivUc4Rypj+l3/+Cn5eBaZsqHKPBzfBgkCa2REvhuOqbCHvJuxjOwWKRWB8J7SKgoTC0jeCXn2t927j0etcQWxblmRLYX6lEN+3Dn0be6C9zZQNBhvXpTYMQtyejAxHMyCfsgPvoMU+GUJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAW3b7oy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAW3b7oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655B4C2BD10;
	Wed,  3 Jul 2024 11:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006039;
	bh=+4SxkPlwTxUCji3erXlCLbdP5Jvjt8UOsCG1nWcXcvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAW3b7oyhBpg+gkntf12jC9uOyy6zds/QmcQb6u15S0uwEVx+bGiAAZta8IdJacvz
	 Zfl6JAOl6NpJlZDoXQtbnFjzA2aufGFPuzgfi0kJNdfMZKB1bFsqc3vZiPE0VECP8Y
	 0IZT08I/iSErj9TLIIsoa9GDQ5OtQRQqg3MycQYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/356] riscv: mm: init: try best to use IS_ENABLED(CONFIG_64BIT) instead of #ifdef
Date: Wed,  3 Jul 2024 12:39:45 +0200
Message-ID: <20240703102922.540113360@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 07aabe8fb6d1ac3163cc74c856521f2ee746270b ]

Try our best to replace the conditional compilation using
"#ifdef CONFIG_64BIT" by a check for "IS_ENABLED(CONFIG_64BIT)", to
simplify the code and to increase compile coverage.

Now we can also remove the __maybe_unused used in max_mapped_addr
declaration.

We also remove the BUG_ON check of mapping the last 4K bytes of the
addressable memory since this is always true for every kernel actually.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 994af1825a2a ("riscv: fix overlap of allocated page and PTR_ERR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 43 ++++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index d7115acab3501..c9d63c476d315 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -105,10 +105,9 @@ static void __init print_vm_layout(void)
 #endif
 	print_mlm("lowmem", (unsigned long)PAGE_OFFSET,
 		  (unsigned long)high_memory);
-#ifdef CONFIG_64BIT
-	print_mlm("kernel", (unsigned long)KERNEL_LINK_ADDR,
-		  (unsigned long)ADDRESS_SPACE_END);
-#endif
+	if (IS_ENABLED(CONFIG_64BIT))
+		print_mlm("kernel", (unsigned long)KERNEL_LINK_ADDR,
+			  (unsigned long)ADDRESS_SPACE_END);
 }
 #else
 static void print_vm_layout(void) { }
@@ -166,7 +165,7 @@ static void __init setup_bootmem(void)
 {
 	phys_addr_t vmlinux_end = __pa_symbol(&_end);
 	phys_addr_t vmlinux_start = __pa_symbol(&_start);
-	phys_addr_t __maybe_unused max_mapped_addr;
+	phys_addr_t max_mapped_addr;
 	phys_addr_t phys_ram_end;
 
 #ifdef CONFIG_XIP_KERNEL
@@ -175,17 +174,16 @@ static void __init setup_bootmem(void)
 
 	memblock_enforce_memory_limit(memory_limit);
 
-	/*
-	 * Reserve from the start of the kernel to the end of the kernel
-	 */
-#if defined(CONFIG_64BIT) && defined(CONFIG_STRICT_KERNEL_RWX)
 	/*
 	 * Make sure we align the reservation on PMD_SIZE since we will
 	 * map the kernel in the linear mapping as read-only: we do not want
 	 * any allocation to happen between _end and the next pmd aligned page.
 	 */
-	vmlinux_end = (vmlinux_end + PMD_SIZE - 1) & PMD_MASK;
-#endif
+	if (IS_ENABLED(CONFIG_64BIT) && IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
+		vmlinux_end = (vmlinux_end + PMD_SIZE - 1) & PMD_MASK;
+	/*
+	 * Reserve from the start of the kernel to the end of the kernel
+	 */
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
 
 
@@ -193,7 +191,6 @@ static void __init setup_bootmem(void)
 #ifndef CONFIG_XIP_KERNEL
 	phys_ram_base = memblock_start_of_DRAM();
 #endif
-#ifndef CONFIG_64BIT
 	/*
 	 * memblock allocator is not aware of the fact that last 4K bytes of
 	 * the addressable memory can not be mapped because of IS_ERR_VALUE
@@ -203,10 +200,11 @@ static void __init setup_bootmem(void)
 	 * address space is occupied by the kernel mapping then this check must
 	 * be done as soon as the kernel mapping base address is determined.
 	 */
-	max_mapped_addr = __pa(~(ulong)0);
-	if (max_mapped_addr == (phys_ram_end - 1))
-		memblock_set_current_limit(max_mapped_addr - 4096);
-#endif
+	if (!IS_ENABLED(CONFIG_64BIT)) {
+		max_mapped_addr = __pa(~(ulong)0);
+		if (max_mapped_addr == (phys_ram_end - 1))
+			memblock_set_current_limit(max_mapped_addr - 4096);
+	}
 
 	min_low_pfn = PFN_UP(phys_ram_base);
 	max_low_pfn = max_pfn = PFN_DOWN(phys_ram_end);
@@ -630,14 +628,6 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 	BUG_ON((PAGE_OFFSET % PGDIR_SIZE) != 0);
 	BUG_ON((kernel_map.phys_addr % PMD_SIZE) != 0);
 
-#ifdef CONFIG_64BIT
-	/*
-	 * The last 4K bytes of the addressable memory can not be mapped because
-	 * of IS_ERR_VALUE macro.
-	 */
-	BUG_ON((kernel_map.virt_addr + kernel_map.size) > ADDRESS_SPACE_END - SZ_4K);
-#endif
-
 	pt_ops.alloc_pte = alloc_pte_early;
 	pt_ops.get_pte_virt = get_pte_virt_early;
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -760,10 +750,9 @@ static void __init setup_vm_final(void)
 		}
 	}
 
-#ifdef CONFIG_64BIT
 	/* Map the kernel */
-	create_kernel_page_table(swapper_pg_dir, false);
-#endif
+	if (IS_ENABLED(CONFIG_64BIT))
+		create_kernel_page_table(swapper_pg_dir, false);
 
 	/* Clear fixmap PTE and PMD mappings */
 	clear_fixmap(FIX_PTE);
-- 
2.43.0



