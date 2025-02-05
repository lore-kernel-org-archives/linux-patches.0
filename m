Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339881FF618;
	Wed,  5 Feb 2025 14:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767086; cv=none; b=gvtvZjZrffUKGQq08Av1aTd0gU+xFQmIfqteEfpuI8N05R7uaOoCsg2viFX6cy9Bw7zPJJtmK7TxFfqb7vR+DLisuv5uGTFi6FBifgSeeIsbEzW3GWf9xAfCB4NIzLr4D3M27um03n8R/KmmS13tzJ1SHRhZ5IjE2TbZci1DFLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767086; c=relaxed/simple;
	bh=ncm3Sj1hhI8LjHVQvY6j+0xV6RuYiWXAytRaoT39FsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPOsl8w9IMBvj4A5284EPHSdSE6SNjWUyXHMwYDUGTnqd2Mmx4YbbCzXm12WpZig4hqfYiG7G/p+OO8vtL/OaNNUpOpWVuTK4Az4RmCwo80Hl+2zJKAQWN3S2pqMJDU4d6g4wZrg3ks9WjQP6AeW/yQ01kPruq55GZctJwxLbIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh12Ajtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh12Ajtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BE7C4CED1;
	Wed,  5 Feb 2025 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767086;
	bh=ncm3Sj1hhI8LjHVQvY6j+0xV6RuYiWXAytRaoT39FsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hh12Ajtv0L8+Kpr2upeyDBb5C5f09O/S7nZw7Tbj7bbHVVcKZUkfzdS0CZvg3qiB2
	 yXQGIVrpxQA5ohDQ4cSWfN2hStWA1+sH4qaFyQM8rkuarI9pylsjwpx9y0uXvy+gvi
	 9gEMNjn+LsvATweskxYU1HJcuxqnOjh3IF9b7Gdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 404/590] of: reserved_mem: Restructure how the reserved memory regions are processed
Date: Wed,  5 Feb 2025 14:42:39 +0100
Message-ID: <20250205134510.718836338@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Oreoluwa Babatunde <quic_obabatun@quicinc.com>

[ Upstream commit 8a6e02d0c00e7b62e6acb74146878bb91e9e7e31 ]

Reserved memory regions defined in the devicetree can be broken up into
two groups:
i) Statically-placed reserved memory regions
i.e. regions defined with a static start address and size using the
     "reg" property.
ii) Dynamically-placed reserved memory regions.
i.e. regions defined by specifying an address range where they can be
     placed in memory using the "alloc_ranges" and "size" properties.

These regions are processed and set aside at boot time.
This is done in two stages as seen below:

Stage 1:
At this stage, fdt_scan_reserved_mem() scans through the child nodes of
the reserved_memory node using the flattened devicetree and does the
following:

1) If the node represents a statically-placed reserved memory region,
   i.e. if it is defined using the "reg" property:
   - Call memblock_reserve() or memblock_mark_nomap() as needed.
   - Add the information for that region into the reserved_mem array
     using fdt_reserved_mem_save_node().
     i.e. fdt_reserved_mem_save_node(node, name, base, size).

2) If the node represents a dynamically-placed reserved memory region,
   i.e. if it is defined using "alloc-ranges" and "size" properties:
   - Add the information for that region to the reserved_mem array with
     the starting address and size set to 0.
     i.e. fdt_reserved_mem_save_node(node, name, 0, 0).
   Note: This region is saved to the array with a starting address of 0
   because a starting address is not yet allocated for it.

Stage 2:
After iterating through all the reserved memory nodes and storing their
relevant information in the reserved_mem array,fdt_init_reserved_mem() is
called and does the following:

1) For statically-placed reserved memory regions:
   - Call the region specific init function using
     __reserved_mem_init_node().
2) For dynamically-placed reserved memory regions:
   - Call __reserved_mem_alloc_size() which is used to allocate memory
     for each of these regions, and mark them as nomap if they have the
     nomap property specified in the DT.
   - Call the region specific init function.

The current size of the resvered_mem array is 64 as is defined by
MAX_RESERVED_REGIONS. This means that there is a limitation of 64 for
how many reserved memory regions can be specified on a system.
As systems continue to grow more and more complex, the number of
reserved memory regions needed are also growing and are starting to hit
this 64 count limit, hence the need to make the reserved_mem array
dynamically sized (i.e. dynamically allocating memory for the
reserved_mem array using membock_alloc_*).

On architectures such as arm64, memory allocated using memblock is
writable only after the page tables have been setup. This means that if
the reserved_mem array is going to be dynamically allocated, it needs to
happen after the page tables have been setup, not before.

Since the reserved memory regions are currently being processed and
added to the array before the page tables are setup, there is a need to
change the order in which some of the processing is done to allow for
the reserved_mem array to be dynamically sized.

It is possible to process the statically-placed reserved memory regions
without needing to store them in the reserved_mem array until after the
page tables have been setup because all the information stored in the
array is readily available in the devicetree and can be referenced at
any time.
Dynamically-placed reserved memory regions on the other hand get
assigned a start address only at runtime, and hence need a place to be
stored once they are allocated since there is no other referrence to the
start address for these regions.

Hence this patch changes the processing order of the reserved memory
regions in the following ways:

Step 1:
fdt_scan_reserved_mem() scans through the child nodes of
the reserved_memory node using the flattened devicetree and does the
following:

1) If the node represents a statically-placed reserved memory region,
   i.e. if it is defined using the "reg" property:
   - Call memblock_reserve() or memblock_mark_nomap() as needed.

2) If the node represents a dynamically-placed reserved memory region,
   i.e. if it is defined using "alloc-ranges" and "size" properties:
   - Call __reserved_mem_alloc_size() which will:
     i) Allocate memory for the reserved region and call
     memblock_mark_nomap() as needed.
     ii) Call the region specific initialization function using
     fdt_init_reserved_mem_node().
     iii) Save the region information in the reserved_mem array using
     fdt_reserved_mem_save_node().

Step 2:
1) This stage of the reserved memory processing is now only used to add
   the statically-placed reserved memory regions into the reserved_mem
   array using fdt_scan_reserved_mem_reg_nodes(), as well as call their
   region specific initialization functions.

2) This step has also been moved to be after the page tables are
   setup. Moving this will allow us to replace the reserved_mem
   array with a dynamically sized array before storing the rest of
   these regions.

Signed-off-by: Oreoluwa Babatunde <quic_obabatun@quicinc.com>
Link: https://lore.kernel.org/r/20241008220624.551309-2-quic_obabatun@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Stable-dep-of: 14bce187d160 ("of/fdt: Restore possibility to use both ACPI and FDT from bootloader")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c             |   5 +-
 drivers/of/of_private.h      |   3 +-
 drivers/of/of_reserved_mem.c | 168 ++++++++++++++++++++++++-----------
 3 files changed, 122 insertions(+), 54 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 546e76ac407cf..d3ecf2bdd2023 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -512,8 +512,6 @@ void __init early_init_fdt_scan_reserved_mem(void)
 			break;
 		memblock_reserve(base, size);
 	}
-
-	fdt_init_reserved_mem();
 }
 
 /**
@@ -1214,6 +1212,9 @@ void __init unflatten_device_tree(void)
 {
 	void *fdt = initial_boot_params;
 
+	/* Save the statically-placed regions in the reserved_mem array */
+	fdt_scan_reserved_mem_reg_nodes();
+
 	/* Don't use the bootloader provided DTB if ACPI is enabled */
 	if (!acpi_disabled)
 		fdt = NULL;
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index c235d6c909a16..1069886225257 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -9,6 +9,7 @@
  */
 
 #define FDT_ALIGN_SIZE 8
+#define MAX_RESERVED_REGIONS    64
 
 /**
  * struct alias_prop - Alias property in 'aliases' node
@@ -183,7 +184,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
 #endif
 
 int fdt_scan_reserved_mem(void);
-void fdt_init_reserved_mem(void);
+void __init fdt_scan_reserved_mem_reg_nodes(void);
 
 bool of_fdt_device_is_available(const void *blob, unsigned long node);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index fa5ecac0b6e98..70d6d727c91a6 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -27,7 +27,6 @@
 
 #include "of_private.h"
 
-#define MAX_RESERVED_REGIONS	64
 static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
 static int reserved_mem_count;
 
@@ -57,6 +56,7 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 	return err;
 }
 
+static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem);
 /*
  * fdt_reserved_mem_save_node() - save fdt node for second pass initialization
  */
@@ -75,6 +75,9 @@ static void __init fdt_reserved_mem_save_node(unsigned long node, const char *un
 	rmem->base = base;
 	rmem->size = size;
 
+	/* Call the region specific initialization function */
+	fdt_init_reserved_mem_node(rmem);
+
 	reserved_mem_count++;
 	return;
 }
@@ -107,7 +110,6 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 	phys_addr_t base, size;
 	int len;
 	const __be32 *prop;
-	int first = 1;
 	bool nomap;
 
 	prop = of_get_flat_dt_prop(node, "reg", &len);
@@ -135,10 +137,6 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 			       uname, &base, (unsigned long)(size / SZ_1M));
 
 		len -= t_len;
-		if (first) {
-			fdt_reserved_mem_save_node(node, uname, base, size);
-			first = 0;
-		}
 	}
 	return 0;
 }
@@ -166,12 +164,77 @@ static int __init __reserved_mem_check_root(unsigned long node)
 	return 0;
 }
 
+static void __init __rmem_check_for_overlap(void);
+
+/**
+ * fdt_scan_reserved_mem_reg_nodes() - Store info for the "reg" defined
+ * reserved memory regions.
+ *
+ * This function is used to scan through the DT and store the
+ * information for the reserved memory regions that are defined using
+ * the "reg" property. The region node number, name, base address, and
+ * size are all stored in the reserved_mem array by calling the
+ * fdt_reserved_mem_save_node() function.
+ */
+void __init fdt_scan_reserved_mem_reg_nodes(void)
+{
+	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
+	const void *fdt = initial_boot_params;
+	phys_addr_t base, size;
+	const __be32 *prop;
+	int node, child;
+	int len;
+
+	if (!fdt)
+		return;
+
+	node = fdt_path_offset(fdt, "/reserved-memory");
+	if (node < 0) {
+		pr_info("Reserved memory: No reserved-memory node in the DT\n");
+		return;
+	}
+
+	if (__reserved_mem_check_root(node)) {
+		pr_err("Reserved memory: unsupported node format, ignoring\n");
+		return;
+	}
+
+	fdt_for_each_subnode(child, fdt, node) {
+		const char *uname;
+
+		prop = of_get_flat_dt_prop(child, "reg", &len);
+		if (!prop)
+			continue;
+		if (!of_fdt_device_is_available(fdt, child))
+			continue;
+
+		uname = fdt_get_name(fdt, child, NULL);
+		if (len && len % t_len != 0) {
+			pr_err("Reserved memory: invalid reg property in '%s', skipping node.\n",
+			       uname);
+			continue;
+		}
+		base = dt_mem_next_cell(dt_root_addr_cells, &prop);
+		size = dt_mem_next_cell(dt_root_size_cells, &prop);
+
+		if (size)
+			fdt_reserved_mem_save_node(child, uname, base, size);
+	}
+
+	/* check for overlapping reserved regions */
+	__rmem_check_for_overlap();
+}
+
+static int __init __reserved_mem_alloc_size(unsigned long node, const char *uname);
+
 /*
  * fdt_scan_reserved_mem() - scan a single FDT node for reserved memory
  */
 int __init fdt_scan_reserved_mem(void)
 {
 	int node, child;
+	int dynamic_nodes_cnt = 0;
+	int dynamic_nodes[MAX_RESERVED_REGIONS];
 	const void *fdt = initial_boot_params;
 
 	node = fdt_path_offset(fdt, "/reserved-memory");
@@ -193,8 +256,24 @@ int __init fdt_scan_reserved_mem(void)
 		uname = fdt_get_name(fdt, child, NULL);
 
 		err = __reserved_mem_reserve_reg(child, uname);
-		if (err == -ENOENT && of_get_flat_dt_prop(child, "size", NULL))
-			fdt_reserved_mem_save_node(child, uname, 0, 0);
+		/*
+		 * Save the nodes for the dynamically-placed regions
+		 * into an array which will be used for allocation right
+		 * after all the statically-placed regions are reserved
+		 * or marked as no-map. This is done to avoid dynamically
+		 * allocating from one of the statically-placed regions.
+		 */
+		if (err == -ENOENT && of_get_flat_dt_prop(child, "size", NULL)) {
+			dynamic_nodes[dynamic_nodes_cnt] = child;
+			dynamic_nodes_cnt++;
+		}
+	}
+	for (int i = 0; i < dynamic_nodes_cnt; i++) {
+		const char *uname;
+
+		child = dynamic_nodes[i];
+		uname = fdt_get_name(fdt, child, NULL);
+		__reserved_mem_alloc_size(child, uname);
 	}
 	return 0;
 }
@@ -254,8 +333,7 @@ static int __init __reserved_mem_alloc_in_range(phys_addr_t size,
  * __reserved_mem_alloc_size() - allocate reserved memory described by
  *	'size', 'alignment'  and 'alloc-ranges' properties.
  */
-static int __init __reserved_mem_alloc_size(unsigned long node,
-	const char *uname, phys_addr_t *res_base, phys_addr_t *res_size)
+static int __init __reserved_mem_alloc_size(unsigned long node, const char *uname)
 {
 	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
 	phys_addr_t start = 0, end = 0;
@@ -335,9 +413,8 @@ static int __init __reserved_mem_alloc_size(unsigned long node,
 		return -ENOMEM;
 	}
 
-	*res_base = base;
-	*res_size = size;
-
+	/* Save region in the reserved_mem array */
+	fdt_reserved_mem_save_node(node, uname, base, size);
 	return 0;
 }
 
@@ -426,48 +503,37 @@ static void __init __rmem_check_for_overlap(void)
 }
 
 /**
- * fdt_init_reserved_mem() - allocate and init all saved reserved memory regions
+ * fdt_init_reserved_mem_node() - Initialize a reserved memory region
+ * @rmem: reserved_mem struct of the memory region to be initialized.
+ *
+ * This function is used to call the region specific initialization
+ * function for a reserved memory region.
  */
-void __init fdt_init_reserved_mem(void)
+static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem)
 {
-	int i;
-
-	/* check for overlapping reserved regions */
-	__rmem_check_for_overlap();
-
-	for (i = 0; i < reserved_mem_count; i++) {
-		struct reserved_mem *rmem = &reserved_mem[i];
-		unsigned long node = rmem->fdt_node;
-		int err = 0;
-		bool nomap;
+	unsigned long node = rmem->fdt_node;
+	int err = 0;
+	bool nomap;
 
-		nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
+	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
 
-		if (rmem->size == 0)
-			err = __reserved_mem_alloc_size(node, rmem->name,
-						 &rmem->base, &rmem->size);
-		if (err == 0) {
-			err = __reserved_mem_init_node(rmem);
-			if (err != 0 && err != -ENOENT) {
-				pr_info("node %s compatible matching fail\n",
-					rmem->name);
-				if (nomap)
-					memblock_clear_nomap(rmem->base, rmem->size);
-				else
-					memblock_phys_free(rmem->base,
-							   rmem->size);
-			} else {
-				phys_addr_t end = rmem->base + rmem->size - 1;
-				bool reusable =
-					(of_get_flat_dt_prop(node, "reusable", NULL)) != NULL;
-
-				pr_info("%pa..%pa (%lu KiB) %s %s %s\n",
-					&rmem->base, &end, (unsigned long)(rmem->size / SZ_1K),
-					nomap ? "nomap" : "map",
-					reusable ? "reusable" : "non-reusable",
-					rmem->name ? rmem->name : "unknown");
-			}
-		}
+	err = __reserved_mem_init_node(rmem);
+	if (err != 0 && err != -ENOENT) {
+		pr_info("node %s compatible matching fail\n", rmem->name);
+		if (nomap)
+			memblock_clear_nomap(rmem->base, rmem->size);
+		else
+			memblock_phys_free(rmem->base, rmem->size);
+	} else {
+		phys_addr_t end = rmem->base + rmem->size - 1;
+		bool reusable =
+			(of_get_flat_dt_prop(node, "reusable", NULL)) != NULL;
+
+		pr_info("%pa..%pa (%lu KiB) %s %s %s\n",
+			&rmem->base, &end, (unsigned long)(rmem->size / SZ_1K),
+			nomap ? "nomap" : "map",
+			reusable ? "reusable" : "non-reusable",
+			rmem->name ? rmem->name : "unknown");
 	}
 }
 
-- 
2.39.5



