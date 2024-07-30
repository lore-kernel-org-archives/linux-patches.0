Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F411078F;
	Tue, 30 Jul 2024 16:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356455; cv=none; b=I1ej3KzdEnXt0twCYjhcnE8Wjx6Fd1cxtgvSKCaHJxZVEKz7yIBXRGohImM6V0mt9sq2VZcft3WtDv/HT5AXg80fGHudiX8YWcwZ7l6EloSyCNtxUlTOlsw6quOSqSHtogKt66nqKwNPAuLtWpT4wP838KVdeb2rGQapM8PWX4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356455; c=relaxed/simple;
	bh=sQTW3zME5rvavWF+szgR/ihuleU8q4Jzw17eBz4T6t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdAQWGmJfom5wxZmMARzp1SLQXwCeKytSgCilqQ6ceMqLmuoZOF7fi8Bv722gx3vm4IjPkL8GVGLIv8JRjRAEb2w6z7FiZaGxWapyeFxw46Kproo1uLEHWVF3i8Vn0cIUt994Vt5TYDt0dv0E+62ZEQhCcQXEL8ZLEpiQ8IBuQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jdw05GgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jdw05GgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52412C32782;
	Tue, 30 Jul 2024 16:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356455;
	bh=sQTW3zME5rvavWF+szgR/ihuleU8q4Jzw17eBz4T6t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jdw05GgWvIeEVHPpD18TlR0L9ubHBqDWPDlqlprkZzJQgwqFMNvAduvl68wKVRqYJ
	 XLqUIuDYkOGS58w4vN5rkggkcHSbbiXwBbiy6eSlMKOtzuopLPETqNGke68fVPMw5B
	 2+4zaIw2MaPcGNbkWeTOPH6bdhaWUMJpS24qyxhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/440] powerpc/kexec_file: fix cpus node update to FDT
Date: Tue, 30 Jul 2024 17:47:06 +0200
Message-ID: <20240730151623.408097627@linuxfoundation.org>
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

[ Upstream commit 932bed41217059638c78a75411b7893b121d2162 ]

While updating the cpus node, commit 40c753993e3a ("powerpc/kexec_file:
 Use current CPU info while setting up FDT") first deletes all subnodes
under the /cpus node. However, while adding sub-nodes back, it missed
adding cpus subnodes whose device_type != "cpu", such as l2-cache*,
l3-cache*, ibm,powerpc-cpu-features.

Fix this by only deleting cpus sub-nodes of device_type == "cpus" and
then adding all available nodes with device_type == "cpu".

Fixes: 40c753993e3a ("powerpc/kexec_file: Use current CPU info while setting up FDT")
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240510102235.2269496-3-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/core_64.c | 53 +++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kexec/core_64.c b/arch/powerpc/kexec/core_64.c
index 8a33de499316e..653b3c8c6a530 100644
--- a/arch/powerpc/kexec/core_64.c
+++ b/arch/powerpc/kexec/core_64.c
@@ -468,9 +468,15 @@ static int add_node_props(void *fdt, int node_offset, const struct device_node *
  * @fdt:              Flattened device tree of the kernel.
  *
  * Returns 0 on success, negative errno on error.
+ *
+ * Note: expecting no subnodes under /cpus/<node> with device_type == "cpu".
+ * If this changes, update this function to include them.
  */
 int update_cpus_node(void *fdt)
 {
+	int prev_node_offset;
+	const char *device_type;
+	const struct fdt_property *prop;
 	struct device_node *cpus_node, *dn;
 	int cpus_offset, cpus_subnode_offset, ret = 0;
 
@@ -481,30 +487,44 @@ int update_cpus_node(void *fdt)
 		return cpus_offset;
 	}
 
-	if (cpus_offset > 0) {
-		ret = fdt_del_node(fdt, cpus_offset);
+	prev_node_offset = cpus_offset;
+	/* Delete sub-nodes of /cpus node with device_type == "cpu" */
+	for (cpus_subnode_offset = fdt_first_subnode(fdt, cpus_offset); cpus_subnode_offset >= 0;) {
+		/* Ignore nodes that do not have a device_type property or device_type != "cpu" */
+		prop = fdt_get_property(fdt, cpus_subnode_offset, "device_type", NULL);
+		if (!prop || strcmp(prop->data, "cpu")) {
+			prev_node_offset = cpus_subnode_offset;
+			goto next_node;
+		}
+
+		ret = fdt_del_node(fdt, cpus_subnode_offset);
 		if (ret < 0) {
-			pr_err("Error deleting /cpus node: %s\n", fdt_strerror(ret));
-			return -EINVAL;
+			pr_err("Failed to delete a cpus sub-node: %s\n", fdt_strerror(ret));
+			return ret;
 		}
+next_node:
+		if (prev_node_offset == cpus_offset)
+			cpus_subnode_offset = fdt_first_subnode(fdt, cpus_offset);
+		else
+			cpus_subnode_offset = fdt_next_subnode(fdt, prev_node_offset);
 	}
 
-	/* Add cpus node to fdt */
-	cpus_offset = fdt_add_subnode(fdt, fdt_path_offset(fdt, "/"), "cpus");
-	if (cpus_offset < 0) {
-		pr_err("Error creating /cpus node: %s\n", fdt_strerror(cpus_offset));
+	cpus_node = of_find_node_by_path("/cpus");
+	/* Fail here to avoid kexec/kdump kernel boot hung */
+	if (!cpus_node) {
+		pr_err("No /cpus node found\n");
 		return -EINVAL;
 	}
 
-	/* Add cpus node properties */
-	cpus_node = of_find_node_by_path("/cpus");
-	ret = add_node_props(fdt, cpus_offset, cpus_node);
-	of_node_put(cpus_node);
-	if (ret < 0)
-		return ret;
+	/* Add all /cpus sub-nodes of device_type == "cpu" to FDT */
+	for_each_child_of_node(cpus_node, dn) {
+		/* Ignore device nodes that do not have a device_type property
+		 * or device_type != "cpu".
+		 */
+		device_type = of_get_property(dn, "device_type", NULL);
+		if (!device_type || strcmp(device_type, "cpu"))
+			continue;
 
-	/* Loop through all subnodes of cpus and add them to fdt */
-	for_each_node_by_type(dn, "cpu") {
 		cpus_subnode_offset = fdt_add_subnode(fdt, cpus_offset, dn->full_name);
 		if (cpus_subnode_offset < 0) {
 			pr_err("Unable to add %s subnode: %s\n", dn->full_name,
@@ -518,6 +538,7 @@ int update_cpus_node(void *fdt)
 			goto out;
 	}
 out:
+	of_node_put(cpus_node);
 	of_node_put(dn);
 	return ret;
 }
-- 
2.43.0



