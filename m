Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EDA2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3D1C433EF;
	Mon, 24 Apr 2023 13:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343190;
	bh=EYz7GiP6sk84FAw91gCcYbCExrJDlxCdKUxsrNo5WeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2aPQ6HUr1Uq10eeSsuQISoOkXJ8LNZOUkk0zeqyv+xCZ2H6XB/1MA57iG8AE6MmB
	 jITt1611yL746HtA2zdMj5D686FT5xn0wpSnCPLL9Jqcgk5FAYIvHkErPDG++1Nrxp
	 R5vegVVNKbViqXj1FIebwRdNnNULdF7xJ83a/LUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Xuerui <kernel@xen0n.name>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.2 098/110] LoongArch: Make WriteCombine configurable for ioremap()
Date: Mon, 24 Apr 2023 15:18:00 +0200
Message-Id: <20230424131140.230840389@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

commit 16c52e503043aed1e2a2ce38d9249de5936c1f6b upstream.

LoongArch maintains cache coherency in hardware, but when paired with
LS7A chipsets the WUC attribute (Weak-ordered UnCached, which is similar
to WriteCombine) is out of the scope of cache coherency machanism for
PCIe devices (this is a PCIe protocol violation, which may be fixed in
newer chipsets).

This means WUC can only used for write-only memory regions now, so this
option is disabled by default, making WUC silently fallback to SUC for
ioremap(). You can enable this option if the kernel is ensured to run on
hardware without this bug.

Kernel parameter writecombine=on/off can be used to override the Kconfig
option.

Cc: stable@vger.kernel.org
Suggested-by: WANG Xuerui <kernel@xen0n.name>
Reviewed-by: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.rst |    1 +
 Documentation/admin-guide/kernel-parameters.txt |    6 ++++++
 arch/loongarch/Kconfig                          |   16 ++++++++++++++++
 arch/loongarch/include/asm/io.h                 |    4 +++-
 arch/loongarch/kernel/setup.c                   |   21 +++++++++++++++++++++
 5 files changed, 47 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -128,6 +128,7 @@ parameter is applicable::
 	KVM	Kernel Virtual Machine support is enabled.
 	LIBATA  Libata driver is enabled
 	LP	Printer support is enabled.
+	LOONGARCH LoongArch architecture is enabled.
 	LOOP	Loopback device support is enabled.
 	M68k	M68k architecture is enabled.
 			These options have more detailed description inside of
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6874,6 +6874,12 @@
 			When enabled, memory and cache locality will be
 			impacted.
 
+	writecombine=	[LOONGARCH] Control the MAT (Memory Access Type) of
+			ioremap_wc().
+
+			on   - Enable writecombine, use WUC for ioremap_wc()
+			off  - Disable writecombine, use SUC for ioremap_wc()
+
 	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
 			default x2apic cluster mode on platforms
 			supporting x2apic.
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -442,6 +442,22 @@ config ARCH_IOREMAP
 	  protection support. However, you can enable LoongArch DMW-based
 	  ioremap() for better performance.
 
+config ARCH_WRITECOMBINE
+	bool "Enable WriteCombine (WUC) for ioremap()"
+	help
+	  LoongArch maintains cache coherency in hardware, but when paired
+	  with LS7A chipsets the WUC attribute (Weak-ordered UnCached, which
+	  is similar to WriteCombine) is out of the scope of cache coherency
+	  machanism for PCIe devices (this is a PCIe protocol violation, which
+	  may be fixed in newer chipsets).
+
+	  This means WUC can only used for write-only memory regions now, so
+	  this option is disabled by default, making WUC silently fallback to
+	  SUC for ioremap(). You can enable this option if the kernel is ensured
+	  to run on hardware without this bug.
+
+	  You can override this setting via writecombine=on/off boot parameter.
+
 config ARCH_STRICT_ALIGN
 	bool "Enable -mstrict-align to prevent unaligned accesses" if EXPERT
 	default y
--- a/arch/loongarch/include/asm/io.h
+++ b/arch/loongarch/include/asm/io.h
@@ -54,8 +54,10 @@ static inline void __iomem *ioremap_prot
  * @offset:    bus address of the memory
  * @size:      size of the resource to map
  */
+extern pgprot_t pgprot_wc;
+
 #define ioremap_wc(offset, size)	\
-	ioremap_prot((offset), (size), pgprot_val(PAGE_KERNEL_WUC))
+	ioremap_prot((offset), (size), pgprot_val(pgprot_wc))
 
 #define ioremap_cache(offset, size)	\
 	ioremap_prot((offset), (size), pgprot_val(PAGE_KERNEL))
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -160,6 +160,27 @@ static void __init smbios_parse(void)
 	dmi_walk(find_tokens, NULL);
 }
 
+#ifdef CONFIG_ARCH_WRITECOMBINE
+pgprot_t pgprot_wc = PAGE_KERNEL_WUC;
+#else
+pgprot_t pgprot_wc = PAGE_KERNEL_SUC;
+#endif
+
+EXPORT_SYMBOL(pgprot_wc);
+
+static int __init setup_writecombine(char *p)
+{
+	if (!strcmp(p, "on"))
+		pgprot_wc = PAGE_KERNEL_WUC;
+	else if (!strcmp(p, "off"))
+		pgprot_wc = PAGE_KERNEL_SUC;
+	else
+		pr_warn("Unknown writecombine setting \"%s\".\n", p);
+
+	return 0;
+}
+early_param("writecombine", setup_writecombine);
+
 static int usermem __initdata;
 
 static int __init early_parse_mem(char *p)


