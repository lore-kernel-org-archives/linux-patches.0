Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A8222F74A;
	Thu, 16 Jul 2026 14:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210412; cv=none; b=sQa4UucJBWB6ORtiITUr4FMA0fvURAGnXyHdF+gghmZi18S1jPVBZxSmUmbLOUtEvDRyIPBAHCtM07holyrTuntg0MJOWFqJBLbCu8QlqvesHPNw878nl1tfDZChdfxgOXk5uQ0EnmRFLGv1vXfRLEfk/j4t/kxUy0vkXAGZ3hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210412; c=relaxed/simple;
	bh=wA3ldRCPPXV78136pc9RYTwsYEtkHPRqar+bZnZ0svc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srw3ooO2uaxZE8zpso6mk7LOjsI8/w5+MV0HQlE9k6AeD2wLSURBRkd1o5t3WTaBPvwtF2q7JHTKdYm17oMvR7eiybegE1DvXMbhEl6uem6spAFaYRCUT5chlytoLDh1m8jnV0b7GNMsbxRB7VJfEDgsPJ/RV9fzwUk4ymWxYaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Eb7rFDo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Eb7rFDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A83E1F000E9;
	Thu, 16 Jul 2026 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210410;
	bh=qqiTJ4l44YPBTLCoNeUoA1NmPy45b7HEsOUBR5hx2uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Eb7rFDoxndik9RK2QUAiQ/KkgzyZbzxuMjPOLhQPIdiBvKPEI9/doWIZr8JJP3ZP
	 4GFVhycRqmE5oS3nVK8K1entlt0hfJNgK4OlprUZZx3g2zb5yuC+zmqp2kQPeon5ej
	 GvRoRKXH7fVGM2aCyPc2s05wsqrgTFjhVVXprz/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanzhen Gan <elysia-best@simplelinux.cn.eu.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 036/480] LoongArch: Add PIO for early access before ACPI PCI root register
Date: Thu, 16 Jul 2026 15:26:23 +0200
Message-ID: <20260716133045.481355349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -16,6 +16,7 @@
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 #include <linux/serial_core.h>
+#include <linux/vmalloc.h>
 #include <asm/io.h>
 #include <asm/numa.h>
 #include <asm/loongson.h>
@@ -59,6 +60,33 @@ void __iomem *acpi_os_ioremap(acpi_physi
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


