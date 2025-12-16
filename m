Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C5D3446B3;
	Tue, 16 Dec 2025 11:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886038; cv=none; b=k9phZDH39P1llaQWmahypcJ2c1+WbTgBW0GdD6MION18J/kkJJe0FKJx0vrpxerwHUXl8hjyl8vaFj9gvTwW8fnZ7ikiQkK3gC8PH8dSbLmw/ifXlC6PZenW10jrqi/2a1yWWNaVLxnT2unucL+zrhIrw9JnZRETz3xoF5ovzLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886038; c=relaxed/simple;
	bh=YD1ikXHK5yfguxZ7XnM+nOjImuUxgiS/rN2j13iG3Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxZkF1MLzpZR66TNVd5VjrUEJtU06VTDLbVU5RZlQV0Kgiauzs0u1Z6+/NbF/8F4Gdu00bK5ld/vHHNTBmejOmIlRcjCxOUA4DWEPYiofVun+VXVkdk9WohL0gWcctq6yp1XaiSh4iNG5mSNKupd9D5rXISuSxTLu63CR2WDcN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGwGjkyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGwGjkyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163A3C4CEF1;
	Tue, 16 Dec 2025 11:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886038;
	bh=YD1ikXHK5yfguxZ7XnM+nOjImuUxgiS/rN2j13iG3Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGwGjkySkSyuXHRVaaXGn3NsnkO3tJszZC9xtXRnsviUKCNglgDeA5WvY+NnpNmRt
	 bWfvYyLkw8CaC3gRLj4OMT19rAvHbKMacW/IZq4rc8qairaw9RZqxakNX6WUmsY9BA
	 N1Y3ynHm8UNuT5ENiuy9NSGBoK1+ElexOcpfKgsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 286/507] of/fdt: Consolidate duplicate code into helper functions
Date: Tue, 16 Dec 2025 12:12:07 +0100
Message-ID: <20251216111355.839612183@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Yuntao Wang <yuntao.wang@linux.dev>

[ Upstream commit 8278cb72c60399f6dc6300c409879fb4c7291513 ]

Currently, there are many pieces of nearly identical code scattered across
different places. Consolidate the duplicate code into helper functions to
improve maintainability and reduce the likelihood of errors.

Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Link: https://patch.msgid.link/20251115134753.179931-2-yuntao.wang@linux.dev
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Stable-dep-of: c85da64ce2c3 ("of/fdt: Fix incorrect use of dt_root_addr_cells in early_init_dt_check_kho()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c       | 41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/of_fdt.h |  9 +++++++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 0edd639898a63..0c18bdefbbeea 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -625,6 +625,47 @@ const void *__init of_get_flat_dt_prop(unsigned long node, const char *name,
 	return fdt_getprop(initial_boot_params, node, name, size);
 }
 
+const __be32 *__init of_flat_dt_get_addr_size_prop(unsigned long node,
+						   const char *name,
+						   int *entries)
+{
+	const __be32 *prop;
+	int len, elen = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
+
+	prop = of_get_flat_dt_prop(node, name, &len);
+	if (!prop || len % elen) {
+		*entries = 0;
+		return NULL;
+	}
+
+	*entries = len / elen;
+	return prop;
+}
+
+bool __init of_flat_dt_get_addr_size(unsigned long node, const char *name,
+				     u64 *addr, u64 *size)
+{
+	const __be32 *prop;
+	int entries;
+
+	prop = of_flat_dt_get_addr_size_prop(node, name, &entries);
+	if (!prop || entries != 1)
+		return false;
+
+	of_flat_dt_read_addr_size(prop, 0, addr, size);
+	return true;
+}
+
+void __init of_flat_dt_read_addr_size(const __be32 *prop, int entry_index,
+				      u64 *addr, u64 *size)
+{
+	int entry_cells = dt_root_addr_cells + dt_root_size_cells;
+	prop += entry_cells * entry_index;
+
+	*addr = dt_mem_next_cell(dt_root_addr_cells, &prop);
+	*size = dt_mem_next_cell(dt_root_size_cells, &prop);
+}
+
 /**
  * of_fdt_is_compatible - Return true if given node from the given blob has
  * compat in its compatible list
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index b8d6c0c208760..51dadbaa3d63a 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -55,6 +55,15 @@ extern int of_get_flat_dt_subnode_by_name(unsigned long node,
 					  const char *uname);
 extern const void *of_get_flat_dt_prop(unsigned long node, const char *name,
 				       int *size);
+
+extern const __be32 *of_flat_dt_get_addr_size_prop(unsigned long node,
+						   const char *name,
+						   int *entries);
+extern bool of_flat_dt_get_addr_size(unsigned long node, const char *name,
+				     u64 *addr, u64 *size);
+extern void of_flat_dt_read_addr_size(const __be32 *prop, int entry_index,
+				      u64 *addr, u64 *size);
+
 extern int of_flat_dt_is_compatible(unsigned long node, const char *name);
 extern unsigned long of_get_flat_dt_root(void);
 extern uint32_t of_get_flat_dt_phandle(unsigned long node);
-- 
2.51.0



