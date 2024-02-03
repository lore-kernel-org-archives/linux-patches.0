Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FA4171A4;
	Sat,  3 Feb 2024 04:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933899; cv=none; b=FG5YHbIF234cxZRpoEBdQgAMz/L3MmKcznBtiU5JAsWjIuhczuyDUPLYfRhXf0OXSXtZNDxeRmOPNNDyn5w1E5n9q2mJvPhcWQ012taOmq7Jcx+iOMMiOUpMijxEq07aq+ibkc9gdvtJFwecxHqjDmyVSqHDlLk1rniMV19jdAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933899; c=relaxed/simple;
	bh=7zHMazhjr/KlOcHJn/rMdqoK2XymEYi0oZ5+YGOaZGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQ7Fg44vYZxm35Mvhav69bRiepPZ0q9mWjbaWWZ78QhGk16IDp0TchSBKor68+JmY7vE2cY4nD2prxry3THM5mS8DBqnSiDqoD61Rmz0tqx4k83GRSNindUnEGSclzSmFO6BvO62VbaiJ7hd4tESVq8fS+eEOdomCO17O8qywEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AyrKgIfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AyrKgIfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5E6C433C7;
	Sat,  3 Feb 2024 04:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933899;
	bh=7zHMazhjr/KlOcHJn/rMdqoK2XymEYi0oZ5+YGOaZGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AyrKgIfk2HYD8+xz52ne7kLM7DY4ztURGl95aR/BeoHlo2eDVs1CrRb71jyxOg74j
	 cFWfnv+L6YWEd4+1S8Vn2+SeRQoU0tTpMvL4w9QTQLsc/8bJX2gnIXUXatmtPP0Lg4
	 Jc2V5YebYzW/Vp7CDZUKuKVF2DXHdg/CjQ98TSIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederik Haxel <haxel@fzi.de>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 246/353] riscv: Make XIP bootable again
Date: Fri,  2 Feb 2024 20:06:04 -0800
Message-ID: <20240203035411.499566609@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederik Haxel <haxel@fzi.de>

[ Upstream commit 66f1e68093979816a23412a3fad066f5bcbc0360 ]

Currently, the XIP kernel seems to fail to boot due to missing
XIP_FIXUP and a wrong page_offset value. A superfluous XIP_FIXUP
has also been removed.

Signed-off-by: Frederik Haxel <haxel@fzi.de>
Link: https://lore.kernel.org/r/20231212130116.848530-2-haxel@fzi.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/head.S | 1 +
 arch/riscv/mm/init.c     | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 76ace1e0b46f..663881785b2b 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -89,6 +89,7 @@ relocate_enable_mmu:
 	/* Compute satp for kernel page tables, but don't load it yet */
 	srl a2, a0, PAGE_SHIFT
 	la a1, satp_mode
+	XIP_FIXUP_OFFSET a1
 	REG_L a1, 0(a1)
 	or a2, a2, a1
 
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 2e011cbddf3a..a65937336cdc 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -174,6 +174,9 @@ void __init mem_init(void)
 
 /* Limit the memory size via mem. */
 static phys_addr_t memory_limit;
+#ifdef CONFIG_XIP_KERNEL
+#define memory_limit	(*(phys_addr_t *)XIP_FIXUP(&memory_limit))
+#endif /* CONFIG_XIP_KERNEL */
 
 static int __init early_mem(char *p)
 {
@@ -952,7 +955,7 @@ static void __init create_fdt_early_page_table(uintptr_t fix_fdt_va,
 	 * setup_vm_final installs the linear mapping. For 32-bit kernel, as the
 	 * kernel is mapped in the linear mapping, that makes no difference.
 	 */
-	dtb_early_va = kernel_mapping_pa_to_va(XIP_FIXUP(dtb_pa));
+	dtb_early_va = kernel_mapping_pa_to_va(dtb_pa);
 #endif
 
 	dtb_early_pa = dtb_pa;
@@ -1055,9 +1058,9 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 #endif
 
 	kernel_map.virt_addr = KERNEL_LINK_ADDR + kernel_map.virt_offset;
-	kernel_map.page_offset = _AC(CONFIG_PAGE_OFFSET, UL);
 
 #ifdef CONFIG_XIP_KERNEL
+	kernel_map.page_offset = PAGE_OFFSET_L3;
 	kernel_map.xiprom = (uintptr_t)CONFIG_XIP_PHYS_ADDR;
 	kernel_map.xiprom_sz = (uintptr_t)(&_exiprom) - (uintptr_t)(&_xiprom);
 
@@ -1067,6 +1070,7 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 
 	kernel_map.va_kernel_xip_pa_offset = kernel_map.virt_addr - kernel_map.xiprom;
 #else
+	kernel_map.page_offset = _AC(CONFIG_PAGE_OFFSET, UL);
 	kernel_map.phys_addr = (uintptr_t)(&_start);
 	kernel_map.size = (uintptr_t)(&_end) - kernel_map.phys_addr;
 #endif
-- 
2.43.0



