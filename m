Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E101F890C;
	Tue,  3 Dec 2024 15:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240385; cv=none; b=i3CfWiFlspXHd7hnqZGHpZ44SfIYKo6KJ12WPw5m7PUW1TAcEDIdnjdBy+waiRNka6j3tGJGGgUuKWSaXUjN9YMgUhfCx5xVzoI6HplbtHSBkmbYkJoaH1Y7QymyWtglPGwkkXkuElgsHt94YNqiVxJ8OZG4iZAiVvmgkN5zwIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240385; c=relaxed/simple;
	bh=6aWq1PgLmmZL3C3N3k1X/LQmynZy6JZsFLXRNIFnzeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gH+3rr5oaFe0L1pW6crNKT2SqLXAOjQrZk1wzZFaYHDWNWgsu+SK11TzgHjRInBWdeL8QJtZiRtax4ygEgXfD4XKZJrwsXFXR4Q3UTHx5F4NjwrnvfAjSzVWsN3G9w2wrJiKMs0uBFn6usxWGK7DC51JNdsTP4yCjNT9aPXDA0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPRtp03F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPRtp03F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E2CC4CECF;
	Tue,  3 Dec 2024 15:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240385;
	bh=6aWq1PgLmmZL3C3N3k1X/LQmynZy6JZsFLXRNIFnzeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPRtp03FbZq4gQbAui7N1cQoH/+n12EwwbH0lPIWPSkWrmJEzasPjcXEiJtSJV5zo
	 M/nxBSgEjnC9CV9ibm2CdYI5BOmWyVc9P1LawXQ7uigEtrtOWOT3cBs0CEHatioq9i
	 VV1aCxgTfuUVJqr8xfZIRv1bDFzo7FDjoFvIHfcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/826] openrisc: Implement fixmap to fix earlycon
Date: Tue,  3 Dec 2024 15:37:27 +0100
Message-ID: <20241203144748.427486402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit 1037d186edfc551fa7ba2d4336e74e7575a07a65 ]

With commit 53c98e35dcbc ("openrisc: mm: remove unneeded early ioremap
code") it was commented that early ioremap was not used in OpenRISC.  I
acked this but was wrong, earlycon was using it.  Earlycon setup now
fails with the below trace:

    Kernel command line: earlycon
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 0 at mm/ioremap.c:23
    generic_ioremap_prot+0x118/0x130
    Modules linked in:
    CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted
    6.11.0-rc5-00001-gce02fd891c38-dirty #141
    Call trace:
    [<(ptrval)>] dump_stack_lvl+0x7c/0x9c
    [<(ptrval)>] dump_stack+0x1c/0x2c
    [<(ptrval)>] __warn+0xb4/0x108
    [<(ptrval)>] ? generic_ioremap_prot+0x118/0x130
    [<(ptrval)>] warn_slowpath_fmt+0x60/0x98
    [<(ptrval)>] generic_ioremap_prot+0x118/0x130
    [<(ptrval)>] ioremap_prot+0x20/0x30
    [<(ptrval)>] of_setup_earlycon+0xd4/0x2e0
    [<(ptrval)>] early_init_dt_scan_chosen_stdout+0x18c/0x1c8
    [<(ptrval)>] param_setup_earlycon+0x3c/0x60
    [<(ptrval)>] do_early_param+0xb0/0x118
    [<(ptrval)>] parse_args+0x184/0x4b8
    [<(ptrval)>] ? start_kernel+0x0/0x78c
    [<(ptrval)>] parse_early_options+0x40/0x50
    [<(ptrval)>] ? do_early_param+0x0/0x118
    [<(ptrval)>] parse_early_param+0x48/0x68
    [<(ptrval)>] ? start_kernel+0x318/0x78c
    [<(ptrval)>] ? start_kernel+0x0/0x78c
    ---[ end trace 0000000000000000 ]---

To fix this we could either implement early_ioremap again or implement
fixmap.  In this patch we choose the later option of implementing basic
fixmap support.

While fixing this we also remove the old FIX_IOREMAP slots that were
used by early ioremap code.  That code was also removed by commit
53c98e35dcbc ("openrisc: mm: remove unneeded early ioremap code") but
these definitions were not cleaned up.

Fixes: 53c98e35dcbc ("openrisc: mm: remove unneeded early ioremap code")
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/Kconfig              |  3 +++
 arch/openrisc/include/asm/fixmap.h | 21 ++++-------------
 arch/openrisc/mm/init.c            | 37 ++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 69c0258700b28..3279ef457c573 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -65,6 +65,9 @@ config STACKTRACE_SUPPORT
 config LOCKDEP_SUPPORT
 	def_bool  y
 
+config FIX_EARLYCON_MEM
+	def_bool y
+
 menu "Processor type and features"
 
 choice
diff --git a/arch/openrisc/include/asm/fixmap.h b/arch/openrisc/include/asm/fixmap.h
index ecdb98a5839f7..aaa6a26a3e921 100644
--- a/arch/openrisc/include/asm/fixmap.h
+++ b/arch/openrisc/include/asm/fixmap.h
@@ -26,29 +26,18 @@
 #include <linux/bug.h>
 #include <asm/page.h>
 
-/*
- * On OpenRISC we use these special fixed_addresses for doing ioremap
- * early in the boot process before memory initialization is complete.
- * This is used, in particular, by the early serial console code.
- *
- * It's not really 'fixmap', per se, but fits loosely into the same
- * paradigm.
- */
 enum fixed_addresses {
-	/*
-	 * FIX_IOREMAP entries are useful for mapping physical address
-	 * space before ioremap() is useable, e.g. really early in boot
-	 * before kmalloc() is working.
-	 */
-#define FIX_N_IOREMAPS  32
-	FIX_IOREMAP_BEGIN,
-	FIX_IOREMAP_END = FIX_IOREMAP_BEGIN + FIX_N_IOREMAPS - 1,
+	FIX_EARLYCON_MEM_BASE,
 	__end_of_fixed_addresses
 };
 
 #define FIXADDR_SIZE		(__end_of_fixed_addresses << PAGE_SHIFT)
 /* FIXADDR_BOTTOM might be a better name here... */
 #define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
+#define FIXMAP_PAGE_IO		PAGE_KERNEL_NOCACHE
+
+extern void __set_fixmap(enum fixed_addresses idx,
+			 phys_addr_t phys, pgprot_t flags);
 
 #include <asm-generic/fixmap.h>
 
diff --git a/arch/openrisc/mm/init.c b/arch/openrisc/mm/init.c
index 1dcd78c8f0e99..d0cb1a0126f95 100644
--- a/arch/openrisc/mm/init.c
+++ b/arch/openrisc/mm/init.c
@@ -207,6 +207,43 @@ void __init mem_init(void)
 	return;
 }
 
+static int __init map_page(unsigned long va, phys_addr_t pa, pgprot_t prot)
+{
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	p4d = p4d_offset(pgd_offset_k(va), va);
+	pud = pud_offset(p4d, va);
+	pmd = pmd_offset(pud, va);
+	pte = pte_alloc_kernel(pmd, va);
+
+	if (pte == NULL)
+		return -ENOMEM;
+
+	if (pgprot_val(prot))
+		set_pte_at(&init_mm, va, pte, pfn_pte(pa >> PAGE_SHIFT, prot));
+	else
+		pte_clear(&init_mm, va, pte);
+
+	local_flush_tlb_page(NULL, va);
+	return 0;
+}
+
+void __init __set_fixmap(enum fixed_addresses idx,
+			 phys_addr_t phys, pgprot_t prot)
+{
+	unsigned long address = __fix_to_virt(idx);
+
+	if (idx >= __end_of_fixed_addresses) {
+		BUG();
+		return;
+	}
+
+	map_page(address, phys, prot);
+}
+
 static const pgprot_t protection_map[16] = {
 	[VM_NONE]					= PAGE_NONE,
 	[VM_READ]					= PAGE_READONLY_X,
-- 
2.43.0



