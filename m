Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F224F3B0ADE;
	Thu, 16 Jul 2026 14:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211678; cv=none; b=Wjfao3/8gY3ThBdxGUZfIXIe8jf//ZqE1UMHjL2Kp6Q4G09Q21kkblJYvbapL+9htQ3HuRfzBAJS5fg5J8ZEG7KTk40FWAEO/O4IkjMV6j6WBAsArEa1ZQMKG0z2AC8wOvRXWh4LY0OLSuj9aqV/Ap67wec6B/rY7gXqCtY2iXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211678; c=relaxed/simple;
	bh=Jw3yKbv66k4OkRFEZFC4F/j1auBeZwbkkNbCsez8t1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOFHApxz3wEvHxKYin+oj9ud6AeBuqKpDBWYPb90ufeSDnitMAQBXtfK60405/LUNHvykR37rhJBF/mk/pZ/3/OEZIN+Yg3Im8kozR+3IgZ/fcd2jlXZkgdLSIYYCupURY7MS1Yi9Xddrwj2ItXQk6K55CvAr3XYuq7Th/U9t7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcrZDvbp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcrZDvbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C7E1F000E9;
	Thu, 16 Jul 2026 14:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211676;
	bh=1BqA43o8jad9jHqsg/NV9nxRudWLj1DZoYCL9BA0Rcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WcrZDvbpbbrjaiaFfZFcNWZMTaI2RZNNNDoMq6ql4FafT3AcHOZWL9d61+p6xc2bw
	 +cTIng7krIjhA6/P1NLukwtMOO6+x7xsmd0iQOwIOQIyvQpzVRh4V+hr2jFxS0dKkY
	 hKSaQSxX9J2RhaldTzOcn/jP1mr+NQqZHkkD5EAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanzhen Gan <elysia-best@simplelinux.cn.eu.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 037/349] LoongArch: Add PIO for early access before ACPI PCI root register
Date: Thu, 16 Jul 2026 15:29:31 +0200
Message-ID: <20260716133034.144062599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 6061e65f95713b01f4313cda6637dfe3aa5412b4 upstream.

For ACPI system we suppose the ISA/LPC PIO range is registered together
with PCI root bridge. But the fact is there may be some early access to
the ISA/LPC PIO range before ACPI PCI root register (most of them are
due to abnormal BIOS). Unconditionally register the ISA/LPC PIO range
usually causes ACPI PCI root register fail because of the address range
confliction. So we add a pair of helpers: acpi_add_early_pio() to add
PIO for early access, and acpi_remove_early_pio() to remove PIO before
PCI root register. Since acpi_remove_early_pio() may be called multiple
times, we add an acpi_pio flag to ensure PIO be removed only once.

Cc: <stable@vger.kernel.org>
Tested-by: Yuanzhen Gan <elysia-best@simplelinux.cn.eu.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/acpi.h |    2 ++
 arch/loongarch/kernel/acpi.c      |   28 ++++++++++++++++++++++++++++
 arch/loongarch/kernel/setup.c     |    2 ++
 arch/loongarch/pci/acpi.c         |    2 ++
 4 files changed, 34 insertions(+)

--- a/arch/loongarch/include/asm/acpi.h
+++ b/arch/loongarch/include/asm/acpi.h
@@ -38,6 +38,8 @@ static inline bool acpi_has_cpu_in_madt(
 extern struct list_head acpi_wakeup_device_list;
 extern struct acpi_madt_core_pic acpi_core_pic[MAX_CORE_PIC];
 
+extern void acpi_add_early_pio(void);
+extern void acpi_remove_early_pio(void);
 extern int __init parse_acpi_topology(void);
 
 static inline u32 get_acpi_id_for_cpu(unsigned int cpu)
--- a/arch/loongarch/kernel/acpi.c
+++ b/arch/loongarch/kernel/acpi.c
@@ -15,6 +15,7 @@
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 #include <linux/serial_core.h>
+#include <linux/vmalloc.h>
 #include <asm/io.h>
 #include <asm/numa.h>
 #include <asm/loongson.h>
@@ -58,6 +59,33 @@ void __iomem *acpi_os_ioremap(acpi_physi
 		return ioremap_cache(phys, size);
 }
 
+#define PIO_BASE (unsigned long)PCI_IOBASE
+#define PIO_SIZE ALIGN(ISA_IOSIZE, PAGE_SIZE)
+
+static bool acpi_pio;
+
+/* Add PIO for early access */
+void acpi_add_early_pio(void)
+{
+	if (!acpi_disabled) {
+		acpi_pio = true;
+		vmap_page_range(PIO_BASE, PIO_BASE + PIO_SIZE,
+				LOONGSON_LIO_BASE, pgprot_device(PAGE_KERNEL));
+	}
+}
+
+/* Remove PIO for PCI register */
+void acpi_remove_early_pio(void)
+{
+	if (!acpi_pio)
+		return;
+
+	if (!acpi_disabled) {
+		acpi_pio = false;
+		vunmap_range(PIO_BASE, PIO_BASE + PIO_SIZE);
+	}
+}
+
 #ifdef CONFIG_SMP
 static int set_processor_mask(u32 id, u32 pass)
 {
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -510,6 +510,8 @@ static __init int arch_reserve_pio_range
 {
 	struct device_node *np;
 
+	acpi_add_early_pio();
+
 	for_each_node_by_name(np, "isa") {
 		struct of_range range;
 		struct of_range_parser parser;
--- a/arch/loongarch/pci/acpi.c
+++ b/arch/loongarch/pci/acpi.c
@@ -65,6 +65,8 @@ static int acpi_prepare_root_resources(s
 	struct resource_entry *entry, *tmp;
 	struct acpi_device *device = ci->bridge;
 
+	acpi_remove_early_pio();
+
 	status = acpi_pci_probe_root_resources(ci);
 	if (status > 0) {
 		acpi_evaluate_integer(device->handle, "PCIH", NULL, &pci_h);


