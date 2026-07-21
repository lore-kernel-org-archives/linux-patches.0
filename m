Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1482D7DF1;
	Tue, 21 Jul 2026 20:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664842; cv=none; b=pX3XzVTt8wFdEtdTdM8MaycpA2QONANzYyk//FSQxYslcniY/5S0xw1S3tP23AiMO675FDk9/NNC0DsXXmtPsmbAu4rFQ2jxT/Avt5uIBfJTRZz1E2mFtFEKx+Y8fHaZx8J4naJmdmpU1E/crLt89nbC2+dfDwepZT+prAasK2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664842; c=relaxed/simple;
	bh=umsmb3/wMXbo4v90jDNmL/8EPc1Dbpw6uNpzlOciO+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBUrlKGsXQ95RP5gR++NcHOiT/wU8tvJ5ZZj2JDI+9PVuWZ55WIkSvH5m/p6CVWFBqtyFJVkgzaYdtMHji0290h30h/a+/4adHHw+LBPtMGFoXLOOYMfobXJC+GcmeQQW7JoD3/Am2HTtCEkhsMbqM6WWeJdF1mezlGxPufI+XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8/VcEVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8/VcEVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D481F000E9;
	Tue, 21 Jul 2026 20:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664840;
	bh=DOlb2eug/3w9XmXDK/whuHvX9R/OXVWSS0uIGxkGkf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8/VcEVJmL+ARaKmIG/3XqJMpYlzugKrlZS39pSdEj5TsGlLrOwD8hzL47CniPtaD
	 J/c1dEgUTmLy0PZFHM9OdQYg9GDYn2PONVBJ6m8ukkMHeZXjI1+QLMedysGIZkGtpT
	 NhjPsKl4ZjXKkWLAJRQQixJwPLHPoP3Cll2AyoFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0078/1266] LoongArch: Add PIO for early access before ACPI PCI root register
Date: Tue, 21 Jul 2026 17:08:35 +0200
Message-ID: <20260721152443.545064386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/acpi.h |  2 ++
 arch/loongarch/kernel/acpi.c      | 28 ++++++++++++++++++++++++++++
 arch/loongarch/kernel/setup.c     |  2 ++
 arch/loongarch/pci/acpi.c         |  2 ++
 4 files changed, 34 insertions(+)

diff --git a/arch/loongarch/include/asm/acpi.h b/arch/loongarch/include/asm/acpi.h
index 49e29b29996f0f..4f31109714c0ab 100644
--- a/arch/loongarch/include/asm/acpi.h
+++ b/arch/loongarch/include/asm/acpi.h
@@ -37,6 +37,8 @@ static inline bool acpi_has_cpu_in_madt(void)
 extern struct list_head acpi_wakeup_device_list;
 extern struct acpi_madt_core_pic acpi_core_pic[MAX_CORE_PIC];
 
+extern void acpi_add_early_pio(void);
+extern void acpi_remove_early_pio(void);
 extern int __init parse_acpi_topology(void);
 
 static inline u32 get_acpi_id_for_cpu(unsigned int cpu)
diff --git a/arch/loongarch/kernel/acpi.c b/arch/loongarch/kernel/acpi.c
index 1f529b13490b3b..34101b753eaac3 100644
--- a/arch/loongarch/kernel/acpi.c
+++ b/arch/loongarch/kernel/acpi.c
@@ -14,6 +14,7 @@
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 #include <linux/serial_core.h>
+#include <linux/vmalloc.h>
 #include <asm/io.h>
 #include <asm/numa.h>
 #include <asm/loongson.h>
@@ -57,6 +58,33 @@ void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
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
+		ioremap_page_range(PIO_BASE, PIO_BASE + PIO_SIZE,
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
 static int set_processor_mask(u32 id, u32 flags)
 {
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 2e34ece474eece..729b0660b61c1a 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -530,6 +530,8 @@ static __init int arch_reserve_pio_range(void)
 {
 	struct device_node *np;
 
+	acpi_add_early_pio();
+
 	for_each_node_by_name(np, "isa") {
 		struct of_range range;
 		struct of_range_parser parser;
diff --git a/arch/loongarch/pci/acpi.c b/arch/loongarch/pci/acpi.c
index 2d584a59a2a049..b53dae9d57c899 100644
--- a/arch/loongarch/pci/acpi.c
+++ b/arch/loongarch/pci/acpi.c
@@ -65,6 +65,8 @@ static int acpi_prepare_root_resources(struct acpi_pci_root_info *ci)
 	struct resource_entry *entry, *tmp;
 	struct acpi_device *device = ci->bridge;
 
+	acpi_remove_early_pio();
+
 	status = acpi_pci_probe_root_resources(ci);
 	if (status > 0) {
 		acpi_evaluate_integer(device->handle, "PCIH", NULL, &pci_h);
-- 
2.53.0



