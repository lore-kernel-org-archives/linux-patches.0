Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1ED27702D;
	Wed,  4 Feb 2026 15:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219037; cv=none; b=LhgF0icU1rG8IxjxHpVaW7O5of7WIgxvkeqPTeBXDdUz+tZCU0DJGY2oG2QxZ+b/S2jLJ0rgU/ygaXLKRJmPzt5507F52vyq9wuZ6FMDMzvzaF4ZXJxbqA6RMh5NVN1UqPBCyprlNDXcx1XRumO5o64acFhnreSiFHfLZK1OwqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219037; c=relaxed/simple;
	bh=n7WTztXh/luR65vijceZ4BfvGv3VgGwSVFdC9fRnmw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYpmzejXsoq3CpKqaS6Qj9e1p27P5PDxRjFNVZfoRghU8/LmCn9MnXqCxh/hRkSYJtL/uvzZPvLFXFVbTW5/zRPs36vF2Q26oBrXXGZ5/Gr6j/vYEIfpxJwyUDoQArFpaSiJDLJRfyinPACyQANib1O3XtE6jG0iMwpcFcIkt/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhxuiQjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhxuiQjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF38AC4CEF7;
	Wed,  4 Feb 2026 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219037;
	bh=n7WTztXh/luR65vijceZ4BfvGv3VgGwSVFdC9fRnmw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhxuiQjXLQkkWTm8doa+1JPiXUVnTPzzmfYPXikcNg8kv2EFkxy16WPhDbnb49wpI
	 nLJ5sVWufeuecvhxBs8CHMQfSBsYhN+cLwkFZ6Tl2XCKDGqKhOrOAF0lJvwIvB8WFQ
	 CwlvXYClt5z8LqtjpTw1BcK0B3tzKRmA8xFFzUmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/122] of/reserved_mem: Simplify the logic of fdt_scan_reserved_mem_reg_nodes()
Date: Wed,  4 Feb 2026 15:40:30 +0100
Message-ID: <20260204143853.586458851@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

[ Upstream commit 85a8a30c5b8e0ffaaf9f4dc51550dc71a1100df4 ]

Use the existing helper functions to simplify the logic of
fdt_scan_reserved_mem_reg_nodes()

Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Link: https://patch.msgid.link/20251115134753.179931-8-yuntao.wang@linux.dev
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Stable-dep-of: 0fd17e598333 ("of: reserved_mem: Allow reserved_mem framework detect "cma=" kernel param")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 2e9ea751ed2df..e5ea4f1e5eff7 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -230,12 +230,9 @@ static void __init __rmem_check_for_overlap(void);
  */
 void __init fdt_scan_reserved_mem_reg_nodes(void)
 {
-	int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
 	const void *fdt = initial_boot_params;
 	phys_addr_t base, size;
-	const __be32 *prop;
 	int node, child;
-	int len;
 
 	if (!fdt)
 		return;
@@ -256,29 +253,21 @@ void __init fdt_scan_reserved_mem_reg_nodes(void)
 
 	fdt_for_each_subnode(child, fdt, node) {
 		const char *uname;
+		u64 b, s;
 
-		prop = of_get_flat_dt_prop(child, "reg", &len);
-		if (!prop)
-			continue;
 		if (!of_fdt_device_is_available(fdt, child))
 			continue;
 
-		uname = fdt_get_name(fdt, child, NULL);
-		if (len && len % t_len != 0) {
-			pr_err("Reserved memory: invalid reg property in '%s', skipping node.\n",
-			       uname);
+		if (!of_flat_dt_get_addr_size(child, "reg", &b, &s))
 			continue;
-		}
 
-		if (len > t_len)
-			pr_warn("%s() ignores %d regions in node '%s'\n",
-				__func__, len / t_len - 1, uname);
+		base = b;
+		size = s;
 
-		base = dt_mem_next_cell(dt_root_addr_cells, &prop);
-		size = dt_mem_next_cell(dt_root_size_cells, &prop);
-
-		if (size)
+		if (size) {
+			uname = fdt_get_name(fdt, child, NULL);
 			fdt_reserved_mem_save_node(child, uname, base, size);
+		}
 	}
 
 	/* check for overlapping reserved regions */
-- 
2.51.0



