Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9692D5C95;
	Mon, 27 Oct 2025 19:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593130; cv=none; b=rg+Gxigvp2DdH8lXh1eDzfJcbmfwxuISn80CbW8OyjE+wV4syAeuqrWHqJKpxygBqymdvEfAw7kiaGfj3axn+OvK9H/DgFz2Li/Qv0xWp/MdiMmPinFqFh8iKwjEEQjsH6vOt2L/MgrdLo/FwI1xhE4PGGQ9yjj6q7bAsy6GIac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593130; c=relaxed/simple;
	bh=bOsQRTy2NYUoCPpE0tWXApVZgubb3gvbzbWqcaqNGFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7DYavztp1yqyRtxPpf9XUaYCnrNWiRltp/BOadWwm1MNERj+yzFo35xSAZm/oRyfeoJTa/5GO7UT+Z2Kp6JKxS4p6YsqZspi/OG2mj+6ZkZ6Y8A9rwiKDlWTkYcAUctKPdyNNbfG8fjWu+4Q/gkaiy01r4p2H4xKEjsyPTemcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvTzgxAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvTzgxAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F590C4CEF1;
	Mon, 27 Oct 2025 19:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593130;
	bh=bOsQRTy2NYUoCPpE0tWXApVZgubb3gvbzbWqcaqNGFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvTzgxAH+4CA1dvnzpYJolf4JCBgVDV8BY4TTLJNjHOg1Y/oiFJ0LYD45Zjdb2BWb
	 qdD3dIfbv3Z22nz+Xc37rgiPHDd9BnuSC4QPWMCHAkZJ6VBUUZW0qTTgDL8R/euvMS
	 z4qpB2P7Zl9AUw6v3qQibLWpHVsWVmaGppvGrIlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Nutty Liu <liujingqi@lanxincomputing.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 024/184] riscv: mm: Use mmu-type from FDT to limit SATP mode
Date: Mon, 27 Oct 2025 19:35:06 +0100
Message-ID: <20251027183515.579489670@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit 17e9521044c9b3ee839f861d1ac35c5b5c20d16b ]

Some RISC-V implementations may hang when attempting to write an
unsupported SATP mode, even though the latest RISC-V specification
states such writes should have no effect. To avoid this issue, the
logic for selecting SATP mode has been refined:

The kernel now determines the SATP mode limit by taking the minimum of
the value specified by the kernel command line (noXlvl) and the
"mmu-type" property in the device tree (FDT). If only one is specified,
use that.
- If the resulting limit is sv48 or higher, the kernel will probe SATP
  modes from this limit downward until a supported mode is found.
- If the limit is sv39, the kernel will directly use sv39 without
  probing.

This ensures SATP mode selection is safe and compatible with both
hardware and user configuration, minimizing the risk of hangs.

Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>
Link: https://lore.kernel.org/r/20250722-satp-from-fdt-v1-2-5ba22218fa5f@pigmoral.tech
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/pi/fdt_early.c | 40 ++++++++++++++++++++++++++++++++
 arch/riscv/kernel/pi/pi.h        |  1 +
 arch/riscv/mm/init.c             | 11 ++++++---
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/pi/fdt_early.c b/arch/riscv/kernel/pi/fdt_early.c
index 9bdee2fafe47e..a12ff8090f190 100644
--- a/arch/riscv/kernel/pi/fdt_early.c
+++ b/arch/riscv/kernel/pi/fdt_early.c
@@ -3,6 +3,7 @@
 #include <linux/init.h>
 #include <linux/libfdt.h>
 #include <linux/ctype.h>
+#include <asm/csr.h>
 
 #include "pi.h"
 
@@ -183,3 +184,42 @@ bool fdt_early_match_extension_isa(const void *fdt, const char *ext_name)
 
 	return ret;
 }
+
+/**
+ *  set_satp_mode_from_fdt - determine SATP mode based on the MMU type in fdt
+ *
+ * @dtb_pa: physical address of the device tree blob
+ *
+ *  Returns the SATP mode corresponding to the MMU type of the first enabled CPU,
+ *  0 otherwise
+ */
+u64 set_satp_mode_from_fdt(uintptr_t dtb_pa)
+{
+	const void *fdt = (const void *)dtb_pa;
+	const char *mmu_type;
+	int node, parent;
+
+	parent = fdt_path_offset(fdt, "/cpus");
+	if (parent < 0)
+		return 0;
+
+	fdt_for_each_subnode(node, fdt, parent) {
+		if (!fdt_node_name_eq(fdt, node, "cpu"))
+			continue;
+
+		if (!fdt_device_is_available(fdt, node))
+			continue;
+
+		mmu_type = fdt_getprop(fdt, node, "mmu-type", NULL);
+		if (!mmu_type)
+			break;
+
+		if (!strcmp(mmu_type, "riscv,sv39"))
+			return SATP_MODE_39;
+		else if (!strcmp(mmu_type, "riscv,sv48"))
+			return SATP_MODE_48;
+		break;
+	}
+
+	return 0;
+}
diff --git a/arch/riscv/kernel/pi/pi.h b/arch/riscv/kernel/pi/pi.h
index 21141d84fea60..3fee2cfddf7cf 100644
--- a/arch/riscv/kernel/pi/pi.h
+++ b/arch/riscv/kernel/pi/pi.h
@@ -14,6 +14,7 @@ u64 get_kaslr_seed(uintptr_t dtb_pa);
 u64 get_kaslr_seed_zkr(const uintptr_t dtb_pa);
 bool set_nokaslr_from_cmdline(uintptr_t dtb_pa);
 u64 set_satp_mode_from_cmdline(uintptr_t dtb_pa);
+u64 set_satp_mode_from_fdt(uintptr_t dtb_pa);
 
 bool fdt_early_match_extension_isa(const void *fdt, const char *ext_name);
 
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 054265b3f2680..85cb70b10c071 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -816,6 +816,7 @@ static __meminit pgprot_t pgprot_from_va(uintptr_t va)
 
 #if defined(CONFIG_64BIT) && !defined(CONFIG_XIP_KERNEL)
 u64 __pi_set_satp_mode_from_cmdline(uintptr_t dtb_pa);
+u64 __pi_set_satp_mode_from_fdt(uintptr_t dtb_pa);
 
 static void __init disable_pgtable_l5(void)
 {
@@ -855,18 +856,22 @@ static void __init set_mmap_rnd_bits_max(void)
  * underlying hardware: establish 1:1 mapping in 4-level page table mode
  * then read SATP to see if the configuration was taken into account
  * meaning sv48 is supported.
+ * The maximum SATP mode is limited by both the command line and the "mmu-type"
+ * property in the device tree, since some platforms may hang if an unsupported
+ * SATP mode is attempted.
  */
 static __init void set_satp_mode(uintptr_t dtb_pa)
 {
 	u64 identity_satp, hw_satp;
 	uintptr_t set_satp_mode_pmd = ((unsigned long)set_satp_mode) & PMD_MASK;
-	u64 satp_mode_cmdline = __pi_set_satp_mode_from_cmdline(dtb_pa);
+	u64 satp_mode_limit = min_not_zero(__pi_set_satp_mode_from_cmdline(dtb_pa),
+					   __pi_set_satp_mode_from_fdt(dtb_pa));
 
 	kernel_map.page_offset = PAGE_OFFSET_L5;
 
-	if (satp_mode_cmdline == SATP_MODE_48) {
+	if (satp_mode_limit == SATP_MODE_48) {
 		disable_pgtable_l5();
-	} else if (satp_mode_cmdline == SATP_MODE_39) {
+	} else if (satp_mode_limit == SATP_MODE_39) {
 		disable_pgtable_l5();
 		disable_pgtable_l4();
 		return;
-- 
2.51.0



