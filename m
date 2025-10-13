Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F1422257E;
	Mon, 13 Oct 2025 15:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368228; cv=none; b=geaLMO3XJi4meSRQ8Daq4GQJ7hh6Fguo3eqDBeMDnOCzzA+BiPVdwUZViFOTxAVdctEqW/ACJhi5x2FjONxRn2onjmWcknIav37CmWegFCC9s+ZynhlR/QaKjWwlY/vYKvIMwqxBtrg/4Q1R9LCVMCOkmo0vcbKfuQ1bIZY7aAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368228; c=relaxed/simple;
	bh=Z0Wlgi+2bBCnHIdcDjGDJITmLxC6M3EzO0Z6HHhKGmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ43W+x40tQkB4wbBHKL3rtOl7k5iXI9U+e+DVoiNnszIARO6mg+Sp7VDHFXGVzAn8CPS/KBLdP/KzJlcxW3XOxobycE1vfZd+FlcjirefO5c7oihP7Qna4VsLPG+Qzq9OEXWs+kj2XtOOT96Q9Ba31IcxEsqYa8JjGAbY75hZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrNDkbPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrNDkbPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BA6C4CEE7;
	Mon, 13 Oct 2025 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368228;
	bh=Z0Wlgi+2bBCnHIdcDjGDJITmLxC6M3EzO0Z6HHhKGmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrNDkbPLXbqXu3Pt+dyD2DCx3zrHeGs+/3otrW+qtoFdaf7ptQZ7+JJ2RobxuR3VZ
	 wirkSIwj4i/t7/WZMvFoOlDsepcouB86sKohCW66jbGdQR5RBcB+PxhzJN86+geadz
	 qcE4CGdawz9EQPuuTtTW0+ycB0w+2DkDJYwFxjCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/262] libbpf: Fix error when st-prefix_ops and ops from differ btf
Date: Mon, 13 Oct 2025 16:43:50 +0200
Message-ID: <20251013144329.299637325@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit 0cc114dc358cf8da2ca23a366e761e89a46ca277 ]

When a module registers a struct_ops, the struct_ops type and its
corresponding map_value type ("bpf_struct_ops_") may reside in different
btf objects, here are four possible case:

+--------+---------------+-------------+---------------------------------+
|        |bpf_struct_ops_| xxx_ops     |                                 |
+--------+---------------+-------------+---------------------------------+
| case 0 | btf_vmlinux   | btf_vmlinux | be used and reg only in vmlinux |
+--------+---------------+-------------+---------------------------------+
| case 1 | btf_vmlinux   | mod_btf     | INVALID                         |
+--------+---------------+-------------+---------------------------------+
| case 2 | mod_btf       | btf_vmlinux | reg in mod but be used both in  |
|        |               |             | vmlinux and mod.                |
+--------+---------------+-------------+---------------------------------+
| case 3 | mod_btf       | mod_btf     | be used and reg only in mod     |
+--------+---------------+-------------+---------------------------------+

Currently we figure out the mod_btf by searching with the struct_ops type,
which makes it impossible to figure out the mod_btf when the struct_ops
type is in btf_vmlinux while it's corresponding map_value type is in
mod_btf (case 2).

The fix is to use the corresponding map_value type ("bpf_struct_ops_")
as the lookup anchor instead of the struct_ops type to figure out the
`btf` and `mod_btf` via find_ksym_btf_id(), and then we can locate
the kern_type_id via btf__find_by_name_kind() with the `btf` we just
obtained from find_ksym_btf_id().

With this change the lookup obtains the correct btf and mod_btf for case 2,
preserves correct behavior for other valid cases, and still fails as
expected for the invalid scenario (case 1).

Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/bpf/20250926071751.108293-1-alibuda@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ac5ad30266a5e..060aecf60b76b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -990,35 +990,33 @@ find_struct_ops_kern_types(struct bpf_object *obj, const char *tname_raw,
 	const struct btf_member *kern_data_member;
 	struct btf *btf = NULL;
 	__s32 kern_vtype_id, kern_type_id;
-	char tname[256];
+	char tname[192], stname[256];
 	__u32 i;
 
 	snprintf(tname, sizeof(tname), "%.*s",
 		 (int)bpf_core_essential_name_len(tname_raw), tname_raw);
 
-	kern_type_id = find_ksym_btf_id(obj, tname, BTF_KIND_STRUCT,
-					&btf, mod_btf);
-	if (kern_type_id < 0) {
-		pr_warn("struct_ops init_kern: struct %s is not found in kernel BTF\n",
-			tname);
-		return kern_type_id;
-	}
-	kern_type = btf__type_by_id(btf, kern_type_id);
+	snprintf(stname, sizeof(stname), "%s%s", STRUCT_OPS_VALUE_PREFIX, tname);
 
-	/* Find the corresponding "map_value" type that will be used
-	 * in map_update(BPF_MAP_TYPE_STRUCT_OPS).  For example,
-	 * find "struct bpf_struct_ops_tcp_congestion_ops" from the
-	 * btf_vmlinux.
+	/* Look for the corresponding "map_value" type that will be used
+	 * in map_update(BPF_MAP_TYPE_STRUCT_OPS) first, figure out the btf
+	 * and the mod_btf.
+	 * For example, find "struct bpf_struct_ops_tcp_congestion_ops".
 	 */
-	kern_vtype_id = find_btf_by_prefix_kind(btf, STRUCT_OPS_VALUE_PREFIX,
-						tname, BTF_KIND_STRUCT);
+	kern_vtype_id = find_ksym_btf_id(obj, stname, BTF_KIND_STRUCT, &btf, mod_btf);
 	if (kern_vtype_id < 0) {
-		pr_warn("struct_ops init_kern: struct %s%s is not found in kernel BTF\n",
-			STRUCT_OPS_VALUE_PREFIX, tname);
+		pr_warn("struct_ops init_kern: struct %s is not found in kernel BTF\n", stname);
 		return kern_vtype_id;
 	}
 	kern_vtype = btf__type_by_id(btf, kern_vtype_id);
 
+	kern_type_id = btf__find_by_name_kind(btf, tname, BTF_KIND_STRUCT);
+	if (kern_type_id < 0) {
+		pr_warn("struct_ops init_kern: struct %s is not found in kernel BTF\n", tname);
+		return kern_type_id;
+	}
+	kern_type = btf__type_by_id(btf, kern_type_id);
+
 	/* Find "struct tcp_congestion_ops" from
 	 * struct bpf_struct_ops_tcp_congestion_ops {
 	 *	[ ... ]
@@ -1031,8 +1029,8 @@ find_struct_ops_kern_types(struct bpf_object *obj, const char *tname_raw,
 			break;
 	}
 	if (i == btf_vlen(kern_vtype)) {
-		pr_warn("struct_ops init_kern: struct %s data is not found in struct %s%s\n",
-			tname, STRUCT_OPS_VALUE_PREFIX, tname);
+		pr_warn("struct_ops init_kern: struct %s data is not found in struct %s\n",
+			tname, stname);
 		return -EINVAL;
 	}
 
-- 
2.51.0



