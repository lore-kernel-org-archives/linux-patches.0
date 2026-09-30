Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CCF3749FA;
	Wed, 30 Sep 2026 16:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787085; cv=none; b=WHPMtqbRliKoI/h51KkYTjVqUlMTbhtcJUxqXmwpuA0bhqcZ2OWt5DmOamcW9CAXDATZ3aBvb2YcII0jGNnedT+JGxFh241oOpfGDUOnuc+3KTSpCzFyoybAX8ky+EPJfKxXOJ9ugLXAwJZ9g/VUxaMIIqjSYU4Y4QcnZFFdVaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787085; c=relaxed/simple;
	bh=34rxEEPxa8l2uz8kgFAK2UCfdgqS7vMTnRSf7vgnaqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YL5pOU99IgDr1HkBfDlqwZ4q6SZseoMRySGqN9VT+XaLd66LkQ+47CLogWTgp9ZhAN/yfM2Q4RsIx+9fbvQnEQ/wH0/mOGzRjpVPzyM2X9RPilQmlvAFngqh5d/szhZ0oBMTnwHE42eNISrtJIBppa4OpnsrDf0alu1XM7VwR/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRUSb3a4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRUSb3a4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB561F008A4;
	Wed, 30 Sep 2026 16:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787083;
	bh=uIqZtT7YiMNw9U8WnAn4b4tVUbZ6Pt5yYDBZcXnlrnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRUSb3a40WXg68KaIg+spSrpwDtabfmceZsMlB99c85RjgZSTfX2VHDsvvPxARF4j
	 9dfag7DWAbU7unZ+MN0CD1jWQaEmZLyn7jufvbmOtnv5PXAwPnzrHnYtgNo5rbGZ9L
	 x7LPIKt1OAAmsN7eeLKiHE42hOx5QNTZIKfYsXxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 104/457] bpf: Bound ownership depth through local kptrs and graph roots
Date: Wed, 30 Sep 2026 17:23:29 +0200
Message-ID: <20260930152348.296724228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit bfc888f04588f591851e95c974954cfca58e6c19 ]

Program-allocated objects can own other local objects through referenced
kptrs. bpf_obj_free_fields() follows those pointers through
__bpf_obj_drop_impl() synchronously, before the object storage is freed
through RCU. A self-referential local kptr type therefore permits arbitrarily
deep object chains, and dropping the head can exhaust the kernel stack.
Long acyclic type chains have the same problem.

btf_check_and_fixup_fields() still assumes referenced kptrs only point to
kernel types and checks ownership through list and rbtree roots only. Its
existing rule is sufficient for graph-only cycles: the target of each graph
edge must contain a node, so every type in a cycle has both a root and a
node. The rule rejects such a type owning another root, breaking every
cycle. It also limits graph-only chains to three types, or two if the first
type contains a node, and conservatively rejects longer acyclic chains.
The missing local-kptr edges, rather than a missed graph-only cycle, are the
bug introduced by support for bpf_kptr_xchg() into local kptrs.

Replace that restriction with one bounded ownership walk covering graph
roots and local referenced kptrs. Run it after all BTF records have been
fixed up, reject cycles and paths deeper than eight record-bearing types,
and cache each type's suffix depth while checking it against the remaining
budget. This also permits the longer acyclic graph-only layouts rejected
by the old rule; update their existing BTF tests accordingly.

Keep the bound independent of MAX_CALL_FRAMES because recursive destruction
can run below a BPF call chain. A plain local pointee without special-field
metadata adds only a final non-recursing drop. Non-owning kptrs and
kernel-BTF kptrs do not recurse through local records and remain outside the
walk. Include local percpu-kptr edges too, although allocation of percpu
objects with special fields is currently forbidden, so that relaxing that
restriction cannot bypass the ownership bound.

btf_check_and_fixup_fields() continues to initialize graph_root.value_rec,
including for separately allocated map records. The ownership relationships
belong to immutable program BTF and only need validation at BTF load time.

Fixes: b0966c724584 ("bpf: Support bpf_kptr_xchg into local kptr")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260914132444.2564218-2-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c                              | 134 +++++++++++-------
 .../selftests/bpf/prog_tests/linked_list.c    |   4 +-
 2 files changed, 88 insertions(+), 50 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ea3d50c99ec22..c4df013bf0066 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4269,13 +4269,10 @@ int btf_check_and_fixup_fields(const struct btf *btf, struct btf_record *rec)
 {
 	int i;
 
-	/* There are three types that signify ownership of some other type:
-	 *  kptr_ref, bpf_list_head, bpf_rb_root.
-	 * kptr_ref only supports storing kernel types, which can't store
-	 * references to program allocated local types.
-	 *
-	 * Hence we only need to ensure that bpf_{list_head,rb_root} ownership
-	 * does not form cycles.
+	/*
+	 * Check fields which require the complete BTF and initialize runtime
+	 * metadata. Ownership relationships are validated after every record has
+	 * been fixed up.
 	 */
 	if (IS_ERR_OR_NULL(rec) || !(rec->field_mask & (BPF_GRAPH_ROOT | BPF_UPTR)))
 		return 0;
@@ -4306,51 +4303,88 @@ int btf_check_and_fixup_fields(const struct btf *btf, struct btf_record *rec)
 		if (!meta)
 			return -EFAULT;
 		rec->fields[i].graph_root.value_rec = meta->record;
+	}
+	return 0;
+}
 
-		/* We need to set value_rec for all root types, but no need
-		 * to check ownership cycle for a type unless it's also a
-		 * node type.
-		 */
-		if (!(rec->field_mask & BPF_GRAPH_NODE))
+static int btf_owned_type_idx(const struct btf *btf, struct btf_struct_metas *tab,
+			      const struct btf_field *field)
+{
+	struct btf_struct_meta *meta;
+	u32 btf_id;
+
+	if (field->type & BPF_GRAPH_ROOT) {
+		btf_id = field->graph_root.value_btf_id;
+	} else if (field->type == BPF_KPTR_REF || field->type == BPF_KPTR_PERCPU) {
+		if (btf_is_kernel(field->kptr.btf))
+			return -ENOENT;
+		btf_id = field->kptr.btf_id;
+	} else {
+		return -ENOENT;
+	}
+
+	meta = btf_find_struct_meta(btf, btf_id);
+	if (!meta)
+		return field->type & BPF_GRAPH_ROOT ? -EFAULT : -ENOENT;
+	return meta - tab->types;
+}
+
+/*
+ * Each ownership edge adds kernel frames through bpf_obj_free_fields() and
+ * __bpf_obj_drop_impl(). Keep the bound deliberately small because object
+ * destruction can itself run below a BPF call chain. A final pointee without
+ * special fields is not present in the struct metadata table and adds only a
+ * non-recursing drop.
+ */
+#define BTF_MAX_OWNERSHIP_DEPTH 8
+
+static int btf_ownership_depth(const struct btf *btf,
+			       struct btf_struct_metas *tab, u8 *depth,
+			       int idx, int depth_left)
+{
+	const struct btf_record *rec = tab->types[idx].record;
+	int i, ret, max_depth = 0;
+
+	if (!depth_left)
+		return -ELOOP;
+	if (depth[idx])
+		goto done;
+
+	for (i = 0; i < rec->cnt; i++) {
+		ret = btf_owned_type_idx(btf, tab, &rec->fields[i]);
+		if (ret == -ENOENT)
 			continue;
+		if (ret < 0)
+			return ret;
+		ret = btf_ownership_depth(btf, tab, depth, ret, depth_left - 1);
+		if (ret < 0)
+			return ret;
+		max_depth = max(max_depth, ret);
+	}
+	depth[idx] = max_depth + 1;
+done:
+	return depth[idx] > depth_left ? -ELOOP : depth[idx];
+}
 
-		/* We need to ensure ownership acyclicity among all types. The
-		 * proper way to do it would be to topologically sort all BTF
-		 * IDs based on the ownership edges, since there can be multiple
-		 * bpf_{list_head,rb_node} in a type. Instead, we use the
-		 * following resaoning:
-		 *
-		 * - A type can only be owned by another type in user BTF if it
-		 *   has a bpf_{list,rb}_node. Let's call these node types.
-		 * - A type can only _own_ another type in user BTF if it has a
-		 *   bpf_{list_head,rb_root}. Let's call these root types.
-		 *
-		 * We ensure that if a type is both a root and node, its
-		 * element types cannot be root types.
-		 *
-		 * To ensure acyclicity:
-		 *
-		 * When A is an root type but not a node, its ownership
-		 * chain can be:
-		 *	A -> B -> C
-		 * Where:
-		 * - A is an root, e.g. has bpf_rb_root.
-		 * - B is both a root and node, e.g. has bpf_rb_node and
-		 *   bpf_list_head.
-		 * - C is only an root, e.g. has bpf_list_node
-		 *
-		 * When A is both a root and node, some other type already
-		 * owns it in the BTF domain, hence it can not own
-		 * another root type through any of the ownership edges.
-		 *	A -> B
-		 * Where:
-		 * - A is both an root and node.
-		 * - B is only an node.
-		 */
-		if (meta->record->field_mask & BPF_GRAPH_ROOT)
-			return -ELOOP;
+static int btf_check_ownership_depth(const struct btf *btf,
+				     struct btf_struct_metas *tab)
+{
+	u8 *depth;
+	int i, ret = 0;
+
+	depth = kvcalloc(tab->cnt, sizeof(*depth), GFP_KERNEL | __GFP_NOWARN);
+	if (!depth)
+		return -ENOMEM;
+
+	for (i = 0; i < tab->cnt; i++) {
+		ret = btf_ownership_depth(btf, tab, depth, i,
+					  BTF_MAX_OWNERSHIP_DEPTH);
+		if (ret < 0)
+			break;
+		ret = 0;
 	}
-	return 0;
+	kvfree(depth);
+	return ret;
 }
 
 static void __btf_struct_show(const struct btf *btf, const struct btf_type *t,
@@ -6045,6 +6079,10 @@ static struct btf *btf_parse(const union bpf_attr *attr, bpfptr_t uattr,
 			if (err < 0)
 				goto errout_meta;
 		}
+
+		err = btf_check_ownership_depth(btf, struct_meta_tab);
+		if (err < 0)
+			goto errout_meta;
 	}
 
 	err = bpf_log_attr_finalize(attr_log, &env->log);
diff --git a/tools/testing/selftests/bpf/prog_tests/linked_list.c b/tools/testing/selftests/bpf/prog_tests/linked_list.c
index 8defea0253ed9..178d133d59238 100644
--- a/tools/testing/selftests/bpf/prog_tests/linked_list.c
+++ b/tools/testing/selftests/bpf/prog_tests/linked_list.c
@@ -713,7 +713,7 @@ static void test_btf(void)
 			break;
 
 		err = btf__load_into_kernel(btf);
-		ASSERT_EQ(err, -ELOOP, "check btf");
+		ASSERT_EQ(err, 0, "check btf");
 		btf__free(btf);
 		break;
 	}
@@ -772,7 +772,7 @@ static void test_btf(void)
 			break;
 
 		err = btf__load_into_kernel(btf);
-		ASSERT_EQ(err, -ELOOP, "check btf");
+		ASSERT_EQ(err, 0, "check btf");
 		btf__free(btf);
 		break;
 	}
-- 
2.53.0



