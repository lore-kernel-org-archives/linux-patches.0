Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECB2524B1;
	Mon, 11 Dec 2023 18:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="co6KPXPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB30AC433C7;
	Mon, 11 Dec 2023 18:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319815;
	bh=yeWu/AXYAq4wqnavzoye7p/TwNGyHOYMopF+bW0CZZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=co6KPXPJ/CwgmKg/EhsA1oO8oy/TGykSnW06pVTDK3Be9WOiwboh9+EK1QbbvHXKq
	 jMp2+bbeUroLAe/EhzlRoTcd2k/E61m3l3+yfMoW/xfkmtwErSOklVNp5Ke2wxnOUy
	 zNKdYqgteww20xycBBQHVx8TXY/kFtDMPddrNkh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 236/244] MIPS: Loongson64: Handle more memory types passed from firmware
Date: Mon, 11 Dec 2023 19:22:09 +0100
Message-ID: <20231211182056.611928003@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit c7206e7bd214ebb3ca6fa474a4423662327d9beb upstream.

There are many types of revsered memory passed from firmware
that should be reserved in memblock, and UMA memory passed
from firmware that should be added to system memory for system
to use.

Also for memblock there is no need to align those space into page,
which actually cause problems.

Handle them properly to prevent memory corruption on some systems.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mach-loongson64/boot_param.h |    6 ++-
 arch/mips/loongson64/init.c                        |   42 +++++++++++++--------
 2 files changed, 31 insertions(+), 17 deletions(-)

--- a/arch/mips/include/asm/mach-loongson64/boot_param.h
+++ b/arch/mips/include/asm/mach-loongson64/boot_param.h
@@ -14,7 +14,11 @@
 #define ADAPTER_ROM		8
 #define ACPI_TABLE		9
 #define SMBIOS_TABLE		10
-#define MAX_MEMORY_TYPE		11
+#define UMA_VIDEO_RAM		11
+#define VUMA_VIDEO_RAM		12
+#define MAX_MEMORY_TYPE		13
+
+#define MEM_SIZE_IS_IN_BYTES	(1 << 31)
 
 #define LOONGSON3_BOOT_MEM_MAP_MAX 128
 struct efi_memory_map_loongson {
--- a/arch/mips/loongson64/init.c
+++ b/arch/mips/loongson64/init.c
@@ -49,8 +49,7 @@ void virtual_early_config(void)
 void __init szmem(unsigned int node)
 {
 	u32 i, mem_type;
-	static unsigned long num_physpages;
-	u64 node_id, node_psize, start_pfn, end_pfn, mem_start, mem_size;
+	phys_addr_t node_id, mem_start, mem_size;
 
 	/* Otherwise come from DTB */
 	if (loongson_sysconf.fw_interface != LOONGSON_LEFI)
@@ -64,27 +63,38 @@ void __init szmem(unsigned int node)
 
 		mem_type = loongson_memmap->map[i].mem_type;
 		mem_size = loongson_memmap->map[i].mem_size;
-		mem_start = loongson_memmap->map[i].mem_start;
+
+		/* Memory size comes in MB if MEM_SIZE_IS_IN_BYTES not set */
+		if (mem_size & MEM_SIZE_IS_IN_BYTES)
+			mem_size &= ~MEM_SIZE_IS_IN_BYTES;
+		else
+			mem_size = mem_size << 20;
+
+		mem_start = (node_id << 44) | loongson_memmap->map[i].mem_start;
 
 		switch (mem_type) {
 		case SYSTEM_RAM_LOW:
 		case SYSTEM_RAM_HIGH:
-			start_pfn = ((node_id << 44) + mem_start) >> PAGE_SHIFT;
-			node_psize = (mem_size << 20) >> PAGE_SHIFT;
-			end_pfn  = start_pfn + node_psize;
-			num_physpages += node_psize;
-			pr_info("Node%d: mem_type:%d, mem_start:0x%llx, mem_size:0x%llx MB\n",
-				(u32)node_id, mem_type, mem_start, mem_size);
-			pr_info("       start_pfn:0x%llx, end_pfn:0x%llx, num_physpages:0x%lx\n",
-				start_pfn, end_pfn, num_physpages);
-			memblock_add_node(PFN_PHYS(start_pfn),
-					  PFN_PHYS(node_psize), node,
+		case UMA_VIDEO_RAM:
+			pr_info("Node %d, mem_type:%d\t[%pa], %pa bytes usable\n",
+				(u32)node_id, mem_type, &mem_start, &mem_size);
+			memblock_add_node(mem_start, mem_size, node,
 					  MEMBLOCK_NONE);
 			break;
 		case SYSTEM_RAM_RESERVED:
-			pr_info("Node%d: mem_type:%d, mem_start:0x%llx, mem_size:0x%llx MB\n",
-				(u32)node_id, mem_type, mem_start, mem_size);
-			memblock_reserve(((node_id << 44) + mem_start), mem_size << 20);
+		case VIDEO_ROM:
+		case ADAPTER_ROM:
+		case ACPI_TABLE:
+		case SMBIOS_TABLE:
+			pr_info("Node %d, mem_type:%d\t[%pa], %pa bytes reserved\n",
+				(u32)node_id, mem_type, &mem_start, &mem_size);
+			memblock_reserve(mem_start, mem_size);
+			break;
+		/* We should not reserve VUMA_VIDEO_RAM as it overlaps with MMIO */
+		case VUMA_VIDEO_RAM:
+		default:
+			pr_info("Node %d, mem_type:%d\t[%pa], %pa bytes unhandled\n",
+				(u32)node_id, mem_type, &mem_start, &mem_size);
 			break;
 		}
 	}


