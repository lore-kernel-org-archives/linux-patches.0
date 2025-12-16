Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E10C3644A7;
	Tue, 16 Dec 2025 12:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887793; cv=none; b=u1piXnltGmILaSEtFeTmt/bSKSJ14JdZwcXgyR9ueing8i0YCt1nA/U2rv5gsApFp3panJCyNlGZIU5JxRzaVG8S9Vltj1fHaW5zzAk/78U8+HLJLHtii2HdFc49U5+h7ZXXbMFvD+MLLjD0DpGRXnWIg0RGvj9z20/tX73XL5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887793; c=relaxed/simple;
	bh=My+1MPUwfd+CuaoVtNvPj/iFkn1+EhYenVvh11yk1/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ct8hMno0S2zArU349w/P5FxdHzBHm0BwLKteJcOeuC1nJniJZCN74WQUAh+cXxnjMUjpcLlK1docULMrf0B1syTAGvaDIhWR7De9axwGCPv07gkxyjTAEWlcSCFVOFyHOPYV38puFqEZHqU69Iy0jEAlZamSv/smUFxtNYEGqXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jGpOx8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jGpOx8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6EBC4CEF5;
	Tue, 16 Dec 2025 12:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887792;
	bh=My+1MPUwfd+CuaoVtNvPj/iFkn1+EhYenVvh11yk1/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jGpOx8aCtvG4c7f8Cjfq7E+PilRCvOjq7vsh5XOBnKtePyBJaoSAqWrP0jINUAr+
	 3n8/xOF9E6y2WAtf4nJUSiXvGMgmA3ielJvV1GkncdrnUWyFk2lUAZXKxtVQzMaARQ
	 JmEIlemhRqpuMRdBkNzelKEyQ8aU5eMLEVXsmaDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 339/614] of/fdt: Consolidate duplicate code into helper functions
Date: Tue, 16 Dec 2025 12:11:46 +0100
Message-ID: <20251216111413.646520667@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Yuntao Wang <yuntao.wang@linux.dev>

[ Upstream commit 8278cb72c60399f6dc6300c409879fb4c7291513 ]

Currently, there are many pieces of nearly identical code scattered across
different places. Consolidate the duplicate code into helper functions to
improve maintainability and reduce the likelihood of errors.

Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Link: https://patch.msgid.link/20251115134753.179931-2-yuntao.wang@linux.dev
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Stable-dep-of: bec5f6092bc1 ("of/fdt: Fix the len check in early_init_dt_check_for_elfcorehdr()")
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



