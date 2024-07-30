Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779CC1A6160;
	Tue, 30 Jul 2024 16:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356446; cv=none; b=mDP4D0QEPiz/m0p8HbXFIako8csH3kL84qF8dp0xCfu4xS6zGNsjy3zyeQD/esYeGp3oRUkcbXQ0rlQC/YuI9GTh998THI4kDQY4tXs9U2RwP4omhBz8Q+blNiUaf7AzuzgtKbu7dbo89zzlsxvp0mOHRaqE5OO8DO6Bz7QSl3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356446; c=relaxed/simple;
	bh=vDWZQMGlnRgMvabbltsYAWqM3ztFUX0XY30u/Naj1pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gic/qQ3xQRYf54QoJZLxnXqPovUXb/ghjaX3MuMUHcdFcjxV5QpByxTOWvCN8bH7p0AgSFSzFYRH9gzVEJcbQgxonQl1yAAyP4KeoKz5a7M/KK4kFsFxc0zbAZdUHqn07L4MXJbkibrsrxLevh3KXLseIOaDiz802qEc+iwocFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZoL0oq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZoL0oq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BB2C32782;
	Tue, 30 Jul 2024 16:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356446;
	bh=vDWZQMGlnRgMvabbltsYAWqM3ztFUX0XY30u/Naj1pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZoL0oq0sn0gem4jkLYMpa0CiSdIlxHuwIjtzJogoWvOT+uCR29J7Y/E7kJAXIf0H
	 1if53lJRhPIQIYKmcSsrRrx2rEAwsVe/hUc52oM/2Nl4oL2TgbTMX6S5rNbl4W7g4P
	 RJjWirdVZKpZW2CVkwSV6sCYtWA4+4OaUCa4nyNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/440] powerpc/kexec: make the update_cpus_node() function public
Date: Tue, 30 Jul 2024 17:47:05 +0200
Message-ID: <20240730151623.370108597@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit 0857beff9c1ec8bb421a8b7a721da0f34cc886c0 ]

Move the update_cpus_node() from kexec/{file_load_64.c => core_64.c}
to allow other kexec components to use it.

Later in the series, this function is used for in-kernel updates
to the kdump image during CPU/memory hotplug or online/offline events for
both kexec_load and kexec_file_load syscalls.

No functional changes are intended.

Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240326055413.186534-5-sourabhjain@linux.ibm.com
Stable-dep-of: 932bed412170 ("powerpc/kexec_file: fix cpus node update to FDT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kexec.h  |  4 ++
 arch/powerpc/kexec/core_64.c      | 91 +++++++++++++++++++++++++++++++
 arch/powerpc/kexec/file_load_64.c | 87 -----------------------------
 3 files changed, 95 insertions(+), 87 deletions(-)

diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
index a1ddba01e7d13..f2db1b443920e 100644
--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -181,6 +181,10 @@ static inline void crash_send_ipi(void (*crash_ipi_callback)(struct pt_regs *))
 
 #endif /* CONFIG_KEXEC_CORE */
 
+#if defined(CONFIG_KEXEC_FILE) || defined(CONFIG_CRASH_DUMP)
+int update_cpus_node(void *fdt);
+#endif
+
 #ifdef CONFIG_PPC_BOOK3S_64
 #include <asm/book3s/64/kexec.h>
 #endif
diff --git a/arch/powerpc/kexec/core_64.c b/arch/powerpc/kexec/core_64.c
index e465e44877376..8a33de499316e 100644
--- a/arch/powerpc/kexec/core_64.c
+++ b/arch/powerpc/kexec/core_64.c
@@ -17,6 +17,7 @@
 #include <linux/cpu.h>
 #include <linux/hardirq.h>
 #include <linux/of.h>
+#include <linux/libfdt.h>
 
 #include <asm/page.h>
 #include <asm/current.h>
@@ -31,6 +32,7 @@
 #include <asm/hw_breakpoint.h>
 #include <asm/svm.h>
 #include <asm/ultravisor.h>
+#include <asm/crashdump-ppc64.h>
 
 int machine_kexec_prepare(struct kimage *image)
 {
@@ -431,3 +433,92 @@ static int __init export_htab_values(void)
 }
 late_initcall(export_htab_values);
 #endif /* CONFIG_PPC_64S_HASH_MMU */
+
+#if defined(CONFIG_KEXEC_FILE) || defined(CONFIG_CRASH_DUMP)
+/**
+ * add_node_props - Reads node properties from device node structure and add
+ *                  them to fdt.
+ * @fdt:            Flattened device tree of the kernel
+ * @node_offset:    offset of the node to add a property at
+ * @dn:             device node pointer
+ *
+ * Returns 0 on success, negative errno on error.
+ */
+static int add_node_props(void *fdt, int node_offset, const struct device_node *dn)
+{
+	int ret = 0;
+	struct property *pp;
+
+	if (!dn)
+		return -EINVAL;
+
+	for_each_property_of_node(dn, pp) {
+		ret = fdt_setprop(fdt, node_offset, pp->name, pp->value, pp->length);
+		if (ret < 0) {
+			pr_err("Unable to add %s property: %s\n", pp->name, fdt_strerror(ret));
+			return ret;
+		}
+	}
+	return ret;
+}
+
+/**
+ * update_cpus_node - Update cpus node of flattened device tree using of_root
+ *                    device node.
+ * @fdt:              Flattened device tree of the kernel.
+ *
+ * Returns 0 on success, negative errno on error.
+ */
+int update_cpus_node(void *fdt)
+{
+	struct device_node *cpus_node, *dn;
+	int cpus_offset, cpus_subnode_offset, ret = 0;
+
+	cpus_offset = fdt_path_offset(fdt, "/cpus");
+	if (cpus_offset < 0 && cpus_offset != -FDT_ERR_NOTFOUND) {
+		pr_err("Malformed device tree: error reading /cpus node: %s\n",
+		       fdt_strerror(cpus_offset));
+		return cpus_offset;
+	}
+
+	if (cpus_offset > 0) {
+		ret = fdt_del_node(fdt, cpus_offset);
+		if (ret < 0) {
+			pr_err("Error deleting /cpus node: %s\n", fdt_strerror(ret));
+			return -EINVAL;
+		}
+	}
+
+	/* Add cpus node to fdt */
+	cpus_offset = fdt_add_subnode(fdt, fdt_path_offset(fdt, "/"), "cpus");
+	if (cpus_offset < 0) {
+		pr_err("Error creating /cpus node: %s\n", fdt_strerror(cpus_offset));
+		return -EINVAL;
+	}
+
+	/* Add cpus node properties */
+	cpus_node = of_find_node_by_path("/cpus");
+	ret = add_node_props(fdt, cpus_offset, cpus_node);
+	of_node_put(cpus_node);
+	if (ret < 0)
+		return ret;
+
+	/* Loop through all subnodes of cpus and add them to fdt */
+	for_each_node_by_type(dn, "cpu") {
+		cpus_subnode_offset = fdt_add_subnode(fdt, cpus_offset, dn->full_name);
+		if (cpus_subnode_offset < 0) {
+			pr_err("Unable to add %s subnode: %s\n", dn->full_name,
+			       fdt_strerror(cpus_subnode_offset));
+			ret = cpus_subnode_offset;
+			goto out;
+		}
+
+		ret = add_node_props(fdt, cpus_subnode_offset, dn);
+		if (ret < 0)
+			goto out;
+	}
+out:
+	of_node_put(dn);
+	return ret;
+}
+#endif /* CONFIG_KEXEC_FILE || CONFIG_CRASH_DUMP */
diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 349a781cea0b3..180c1dfe4aa77 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -952,93 +952,6 @@ unsigned int kexec_extra_fdt_size_ppc64(struct kimage *image)
 	return (unsigned int)(usm_entries * sizeof(u64));
 }
 
-/**
- * add_node_props - Reads node properties from device node structure and add
- *                  them to fdt.
- * @fdt:            Flattened device tree of the kernel
- * @node_offset:    offset of the node to add a property at
- * @dn:             device node pointer
- *
- * Returns 0 on success, negative errno on error.
- */
-static int add_node_props(void *fdt, int node_offset, const struct device_node *dn)
-{
-	int ret = 0;
-	struct property *pp;
-
-	if (!dn)
-		return -EINVAL;
-
-	for_each_property_of_node(dn, pp) {
-		ret = fdt_setprop(fdt, node_offset, pp->name, pp->value, pp->length);
-		if (ret < 0) {
-			pr_err("Unable to add %s property: %s\n", pp->name, fdt_strerror(ret));
-			return ret;
-		}
-	}
-	return ret;
-}
-
-/**
- * update_cpus_node - Update cpus node of flattened device tree using of_root
- *                    device node.
- * @fdt:              Flattened device tree of the kernel.
- *
- * Returns 0 on success, negative errno on error.
- */
-static int update_cpus_node(void *fdt)
-{
-	struct device_node *cpus_node, *dn;
-	int cpus_offset, cpus_subnode_offset, ret = 0;
-
-	cpus_offset = fdt_path_offset(fdt, "/cpus");
-	if (cpus_offset < 0 && cpus_offset != -FDT_ERR_NOTFOUND) {
-		pr_err("Malformed device tree: error reading /cpus node: %s\n",
-		       fdt_strerror(cpus_offset));
-		return cpus_offset;
-	}
-
-	if (cpus_offset > 0) {
-		ret = fdt_del_node(fdt, cpus_offset);
-		if (ret < 0) {
-			pr_err("Error deleting /cpus node: %s\n", fdt_strerror(ret));
-			return -EINVAL;
-		}
-	}
-
-	/* Add cpus node to fdt */
-	cpus_offset = fdt_add_subnode(fdt, fdt_path_offset(fdt, "/"), "cpus");
-	if (cpus_offset < 0) {
-		pr_err("Error creating /cpus node: %s\n", fdt_strerror(cpus_offset));
-		return -EINVAL;
-	}
-
-	/* Add cpus node properties */
-	cpus_node = of_find_node_by_path("/cpus");
-	ret = add_node_props(fdt, cpus_offset, cpus_node);
-	of_node_put(cpus_node);
-	if (ret < 0)
-		return ret;
-
-	/* Loop through all subnodes of cpus and add them to fdt */
-	for_each_node_by_type(dn, "cpu") {
-		cpus_subnode_offset = fdt_add_subnode(fdt, cpus_offset, dn->full_name);
-		if (cpus_subnode_offset < 0) {
-			pr_err("Unable to add %s subnode: %s\n", dn->full_name,
-			       fdt_strerror(cpus_subnode_offset));
-			ret = cpus_subnode_offset;
-			goto out;
-		}
-
-		ret = add_node_props(fdt, cpus_subnode_offset, dn);
-		if (ret < 0)
-			goto out;
-	}
-out:
-	of_node_put(dn);
-	return ret;
-}
-
 static int copy_property(void *fdt, int node_offset, const struct device_node *dn,
 			 const char *propname)
 {
-- 
2.43.0



