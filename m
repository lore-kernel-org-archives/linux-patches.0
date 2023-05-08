Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F39168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3DBC433D2;
	Mon,  8 May 2023 10:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542125;
	bh=q9WR8utF4TVVo+z3xkxrHALy4mgxL0HSKTarbo5rd74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSxYoQaR3zyNPiRDxL8fSQqGjQZqI++eS+hojfd4QSD/UvwgnfUCMKTRzbs2H+C+n
	 UULANk7SR6QTTVs2rYUlpTz9Dl6a/VAfAHl0PshgWtYewhdrWsMXctddQ60x+ekozL
	 kjlDl1/pwZzf5mP0kDpNRsGpJttHyhlLM0NkdS7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 334/663] bpf: Add support for bpf_rb_root and bpf_rb_node in kfunc args
Date: Mon,  8 May 2023 11:42:40 +0200
Message-Id: <20230508094439.014256411@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Marchevsky <davemarchevsky@fb.com>

[ Upstream commit cd6791b4b6f66f6b7925c840efe5c8fa0ce1ac87 ]

Now that we find bpf_rb_root and bpf_rb_node in structs, let's give args
that contain those types special classification and properly handle
these types when checking kfunc args.

"Properly handling" these types largely requires generalizing similar
handling for bpf_list_{head,node}, with little new logic added in this
patch.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Link: https://lore.kernel.org/r/20230214004017.2534011-4-davemarchevsky@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: f6a6a5a97628 ("bpf: Fix struct_meta lookup for bpf_obj_free_fields kfunc call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 238 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 203 insertions(+), 35 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2997869917613..3bb38cb9c604f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8438,6 +8438,9 @@ struct bpf_kfunc_call_arg_meta {
 	struct {
 		struct btf_field *field;
 	} arg_list_head;
+	struct {
+		struct btf_field *field;
+	} arg_rbtree_root;
 };
 
 static bool is_kfunc_acquire(struct bpf_kfunc_call_arg_meta *meta)
@@ -8549,6 +8552,8 @@ enum {
 	KF_ARG_DYNPTR_ID,
 	KF_ARG_LIST_HEAD_ID,
 	KF_ARG_LIST_NODE_ID,
+	KF_ARG_RB_ROOT_ID,
+	KF_ARG_RB_NODE_ID,
 };
 
 BTF_ID_LIST(kf_arg_btf_ids)
@@ -8590,6 +8595,16 @@ static bool is_kfunc_arg_list_node(const struct btf *btf, const struct btf_param
 	return __is_kfunc_ptr_arg_type(btf, arg, KF_ARG_LIST_NODE_ID);
 }
 
+static bool is_kfunc_arg_rbtree_root(const struct btf *btf, const struct btf_param *arg)
+{
+	return __is_kfunc_ptr_arg_type(btf, arg, KF_ARG_RB_ROOT_ID);
+}
+
+static bool is_kfunc_arg_rbtree_node(const struct btf *btf, const struct btf_param *arg)
+{
+	return __is_kfunc_ptr_arg_type(btf, arg, KF_ARG_RB_NODE_ID);
+}
+
 /* Returns true if struct is composed of scalars, 4 levels of nesting allowed */
 static bool __btf_type_is_scalar_struct(struct bpf_verifier_env *env,
 					const struct btf *btf,
@@ -8649,6 +8664,8 @@ enum kfunc_ptr_arg_type {
 	KF_ARG_PTR_TO_BTF_ID,	     /* Also covers reg2btf_ids conversions */
 	KF_ARG_PTR_TO_MEM,
 	KF_ARG_PTR_TO_MEM_SIZE,	     /* Size derived from next argument, skip it */
+	KF_ARG_PTR_TO_RB_ROOT,
+	KF_ARG_PTR_TO_RB_NODE,
 };
 
 enum special_kfunc_type {
@@ -8756,6 +8773,12 @@ get_kfunc_ptr_arg_type(struct bpf_verifier_env *env,
 	if (is_kfunc_arg_list_node(meta->btf, &args[argno]))
 		return KF_ARG_PTR_TO_LIST_NODE;
 
+	if (is_kfunc_arg_rbtree_root(meta->btf, &args[argno]))
+		return KF_ARG_PTR_TO_RB_ROOT;
+
+	if (is_kfunc_arg_rbtree_node(meta->btf, &args[argno]))
+		return KF_ARG_PTR_TO_RB_NODE;
+
 	if ((base_type(reg->type) == PTR_TO_BTF_ID || reg2btf_ids[base_type(reg->type)])) {
 		if (!btf_type_is_struct(ref_t)) {
 			verbose(env, "kernel function %s args#%d pointer type %s %s is not supported\n",
@@ -8984,95 +9007,193 @@ static bool is_bpf_list_api_kfunc(u32 btf_id)
 	       btf_id == special_kfunc_list[KF_bpf_list_pop_back];
 }
 
-static int process_kf_arg_ptr_to_list_head(struct bpf_verifier_env *env,
-					   struct bpf_reg_state *reg, u32 regno,
-					   struct bpf_kfunc_call_arg_meta *meta)
+static bool is_bpf_rbtree_api_kfunc(u32 btf_id)
+{
+	return btf_id == special_kfunc_list[KF_bpf_rbtree_add] ||
+	       btf_id == special_kfunc_list[KF_bpf_rbtree_remove] ||
+	       btf_id == special_kfunc_list[KF_bpf_rbtree_first];
+}
+
+static bool is_bpf_graph_api_kfunc(u32 btf_id)
+{
+	return is_bpf_list_api_kfunc(btf_id) || is_bpf_rbtree_api_kfunc(btf_id);
+}
+
+static bool check_kfunc_is_graph_root_api(struct bpf_verifier_env *env,
+					  enum btf_field_type head_field_type,
+					  u32 kfunc_btf_id)
 {
+	bool ret;
+
+	switch (head_field_type) {
+	case BPF_LIST_HEAD:
+		ret = is_bpf_list_api_kfunc(kfunc_btf_id);
+		break;
+	case BPF_RB_ROOT:
+		ret = is_bpf_rbtree_api_kfunc(kfunc_btf_id);
+		break;
+	default:
+		verbose(env, "verifier internal error: unexpected graph root argument type %s\n",
+			btf_field_type_name(head_field_type));
+		return false;
+	}
+
+	if (!ret)
+		verbose(env, "verifier internal error: %s head arg for unknown kfunc\n",
+			btf_field_type_name(head_field_type));
+	return ret;
+}
+
+static bool check_kfunc_is_graph_node_api(struct bpf_verifier_env *env,
+					  enum btf_field_type node_field_type,
+					  u32 kfunc_btf_id)
+{
+	bool ret;
+
+	switch (node_field_type) {
+	case BPF_LIST_NODE:
+		ret = (kfunc_btf_id == special_kfunc_list[KF_bpf_list_push_front] ||
+		       kfunc_btf_id == special_kfunc_list[KF_bpf_list_push_back]);
+		break;
+	case BPF_RB_NODE:
+		ret = (kfunc_btf_id == special_kfunc_list[KF_bpf_rbtree_remove] ||
+		       kfunc_btf_id == special_kfunc_list[KF_bpf_rbtree_add]);
+		break;
+	default:
+		verbose(env, "verifier internal error: unexpected graph node argument type %s\n",
+			btf_field_type_name(node_field_type));
+		return false;
+	}
+
+	if (!ret)
+		verbose(env, "verifier internal error: %s node arg for unknown kfunc\n",
+			btf_field_type_name(node_field_type));
+	return ret;
+}
+
+static int
+__process_kf_arg_ptr_to_graph_root(struct bpf_verifier_env *env,
+				   struct bpf_reg_state *reg, u32 regno,
+				   struct bpf_kfunc_call_arg_meta *meta,
+				   enum btf_field_type head_field_type,
+				   struct btf_field **head_field)
+{
+	const char *head_type_name;
 	struct btf_field *field;
 	struct btf_record *rec;
-	u32 list_head_off;
+	u32 head_off;
 
-	if (meta->btf != btf_vmlinux || !is_bpf_list_api_kfunc(meta->func_id)) {
-		verbose(env, "verifier internal error: bpf_list_head argument for unknown kfunc\n");
+	if (meta->btf != btf_vmlinux) {
+		verbose(env, "verifier internal error: unexpected btf mismatch in kfunc call\n");
 		return -EFAULT;
 	}
 
+	if (!check_kfunc_is_graph_root_api(env, head_field_type, meta->func_id))
+		return -EFAULT;
+
+	head_type_name = btf_field_type_name(head_field_type);
 	if (!tnum_is_const(reg->var_off)) {
 		verbose(env,
-			"R%d doesn't have constant offset. bpf_list_head has to be at the constant offset\n",
-			regno);
+			"R%d doesn't have constant offset. %s has to be at the constant offset\n",
+			regno, head_type_name);
 		return -EINVAL;
 	}
 
 	rec = reg_btf_record(reg);
-	list_head_off = reg->off + reg->var_off.value;
-	field = btf_record_find(rec, list_head_off, BPF_LIST_HEAD);
+	head_off = reg->off + reg->var_off.value;
+	field = btf_record_find(rec, head_off, head_field_type);
 	if (!field) {
-		verbose(env, "bpf_list_head not found at offset=%u\n", list_head_off);
+		verbose(env, "%s not found at offset=%u\n", head_type_name, head_off);
 		return -EINVAL;
 	}
 
 	/* All functions require bpf_list_head to be protected using a bpf_spin_lock */
 	if (check_reg_allocation_locked(env, reg)) {
-		verbose(env, "bpf_spin_lock at off=%d must be held for bpf_list_head\n",
-			rec->spin_lock_off);
+		verbose(env, "bpf_spin_lock at off=%d must be held for %s\n",
+			rec->spin_lock_off, head_type_name);
 		return -EINVAL;
 	}
 
-	if (meta->arg_list_head.field) {
-		verbose(env, "verifier internal error: repeating bpf_list_head arg\n");
+	if (*head_field) {
+		verbose(env, "verifier internal error: repeating %s arg\n", head_type_name);
 		return -EFAULT;
 	}
-	meta->arg_list_head.field = field;
+	*head_field = field;
 	return 0;
 }
 
-static int process_kf_arg_ptr_to_list_node(struct bpf_verifier_env *env,
+static int process_kf_arg_ptr_to_list_head(struct bpf_verifier_env *env,
 					   struct bpf_reg_state *reg, u32 regno,
 					   struct bpf_kfunc_call_arg_meta *meta)
 {
+	return __process_kf_arg_ptr_to_graph_root(env, reg, regno, meta, BPF_LIST_HEAD,
+							  &meta->arg_list_head.field);
+}
+
+static int process_kf_arg_ptr_to_rbtree_root(struct bpf_verifier_env *env,
+					     struct bpf_reg_state *reg, u32 regno,
+					     struct bpf_kfunc_call_arg_meta *meta)
+{
+	return __process_kf_arg_ptr_to_graph_root(env, reg, regno, meta, BPF_RB_ROOT,
+							  &meta->arg_rbtree_root.field);
+}
+
+static int
+__process_kf_arg_ptr_to_graph_node(struct bpf_verifier_env *env,
+				   struct bpf_reg_state *reg, u32 regno,
+				   struct bpf_kfunc_call_arg_meta *meta,
+				   enum btf_field_type head_field_type,
+				   enum btf_field_type node_field_type,
+				   struct btf_field **node_field)
+{
+	const char *node_type_name;
 	const struct btf_type *et, *t;
 	struct btf_field *field;
-	u32 list_node_off;
+	u32 node_off;
 
-	if (meta->btf != btf_vmlinux ||
-	    (meta->func_id != special_kfunc_list[KF_bpf_list_push_front] &&
-	     meta->func_id != special_kfunc_list[KF_bpf_list_push_back])) {
-		verbose(env, "verifier internal error: bpf_list_node argument for unknown kfunc\n");
+	if (meta->btf != btf_vmlinux) {
+		verbose(env, "verifier internal error: unexpected btf mismatch in kfunc call\n");
 		return -EFAULT;
 	}
 
+	if (!check_kfunc_is_graph_node_api(env, node_field_type, meta->func_id))
+		return -EFAULT;
+
+	node_type_name = btf_field_type_name(node_field_type);
 	if (!tnum_is_const(reg->var_off)) {
 		verbose(env,
-			"R%d doesn't have constant offset. bpf_list_node has to be at the constant offset\n",
-			regno);
+			"R%d doesn't have constant offset. %s has to be at the constant offset\n",
+			regno, node_type_name);
 		return -EINVAL;
 	}
 
-	list_node_off = reg->off + reg->var_off.value;
-	field = reg_find_field_offset(reg, list_node_off, BPF_LIST_NODE);
-	if (!field || field->offset != list_node_off) {
-		verbose(env, "bpf_list_node not found at offset=%u\n", list_node_off);
+	node_off = reg->off + reg->var_off.value;
+	field = reg_find_field_offset(reg, node_off, node_field_type);
+	if (!field || field->offset != node_off) {
+		verbose(env, "%s not found at offset=%u\n", node_type_name, node_off);
 		return -EINVAL;
 	}
 
-	field = meta->arg_list_head.field;
+	field = *node_field;
 
 	et = btf_type_by_id(field->graph_root.btf, field->graph_root.value_btf_id);
 	t = btf_type_by_id(reg->btf, reg->btf_id);
 	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, 0, field->graph_root.btf,
 				  field->graph_root.value_btf_id, true)) {
-		verbose(env, "operation on bpf_list_head expects arg#1 bpf_list_node at offset=%d "
+		verbose(env, "operation on %s expects arg#1 %s at offset=%d "
 			"in struct %s, but arg is at offset=%d in struct %s\n",
+			btf_field_type_name(head_field_type),
+			btf_field_type_name(node_field_type),
 			field->graph_root.node_offset,
 			btf_name_by_offset(field->graph_root.btf, et->name_off),
-			list_node_off, btf_name_by_offset(reg->btf, t->name_off));
+			node_off, btf_name_by_offset(reg->btf, t->name_off));
 		return -EINVAL;
 	}
 
-	if (list_node_off != field->graph_root.node_offset) {
-		verbose(env, "arg#1 offset=%d, but expected bpf_list_node at offset=%d in struct %s\n",
-			list_node_off, field->graph_root.node_offset,
+	if (node_off != field->graph_root.node_offset) {
+		verbose(env, "arg#1 offset=%d, but expected %s at offset=%d in struct %s\n",
+			node_off, btf_field_type_name(node_field_type),
+			field->graph_root.node_offset,
 			btf_name_by_offset(field->graph_root.btf, et->name_off));
 		return -EINVAL;
 	}
@@ -9080,6 +9201,24 @@ static int process_kf_arg_ptr_to_list_node(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static int process_kf_arg_ptr_to_list_node(struct bpf_verifier_env *env,
+					   struct bpf_reg_state *reg, u32 regno,
+					   struct bpf_kfunc_call_arg_meta *meta)
+{
+	return __process_kf_arg_ptr_to_graph_node(env, reg, regno, meta,
+						  BPF_LIST_HEAD, BPF_LIST_NODE,
+						  &meta->arg_list_head.field);
+}
+
+static int process_kf_arg_ptr_to_rbtree_node(struct bpf_verifier_env *env,
+					     struct bpf_reg_state *reg, u32 regno,
+					     struct bpf_kfunc_call_arg_meta *meta)
+{
+	return __process_kf_arg_ptr_to_graph_node(env, reg, regno, meta,
+						  BPF_RB_ROOT, BPF_RB_NODE,
+						  &meta->arg_rbtree_root.field);
+}
+
 static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_arg_meta *meta)
 {
 	const char *func_name = meta->func_name, *ref_tname;
@@ -9208,6 +9347,8 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 		case KF_ARG_PTR_TO_DYNPTR:
 		case KF_ARG_PTR_TO_LIST_HEAD:
 		case KF_ARG_PTR_TO_LIST_NODE:
+		case KF_ARG_PTR_TO_RB_ROOT:
+		case KF_ARG_PTR_TO_RB_NODE:
 		case KF_ARG_PTR_TO_MEM:
 		case KF_ARG_PTR_TO_MEM_SIZE:
 			/* Trusted by default */
@@ -9286,6 +9427,20 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 			if (ret < 0)
 				return ret;
 			break;
+		case KF_ARG_PTR_TO_RB_ROOT:
+			if (reg->type != PTR_TO_MAP_VALUE &&
+			    reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
+				verbose(env, "arg#%d expected pointer to map value or allocated object\n", i);
+				return -EINVAL;
+			}
+			if (reg->type == (PTR_TO_BTF_ID | MEM_ALLOC) && !reg->ref_obj_id) {
+				verbose(env, "allocated object must be referenced\n");
+				return -EINVAL;
+			}
+			ret = process_kf_arg_ptr_to_rbtree_root(env, reg, regno, meta);
+			if (ret < 0)
+				return ret;
+			break;
 		case KF_ARG_PTR_TO_LIST_NODE:
 			if (reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
 				verbose(env, "arg#%d expected pointer to allocated object\n", i);
@@ -9299,6 +9454,19 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 			if (ret < 0)
 				return ret;
 			break;
+		case KF_ARG_PTR_TO_RB_NODE:
+			if (reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
+				verbose(env, "arg#%d expected pointer to allocated object\n", i);
+				return -EINVAL;
+			}
+			if (!reg->ref_obj_id) {
+				verbose(env, "allocated object must be referenced\n");
+				return -EINVAL;
+			}
+			ret = process_kf_arg_ptr_to_rbtree_node(env, reg, regno, meta);
+			if (ret < 0)
+				return ret;
+			break;
 		case KF_ARG_PTR_TO_BTF_ID:
 			/* Only base_type is checked, further checks are done here */
 			if ((base_type(reg->type) != PTR_TO_BTF_ID ||
@@ -14297,7 +14465,7 @@ static int do_check(struct bpf_verifier_env *env)
 					if ((insn->src_reg == BPF_REG_0 && insn->imm != BPF_FUNC_spin_unlock) ||
 					    (insn->src_reg == BPF_PSEUDO_CALL) ||
 					    (insn->src_reg == BPF_PSEUDO_KFUNC_CALL &&
-					     (insn->off != 0 || !is_bpf_list_api_kfunc(insn->imm)))) {
+					     (insn->off != 0 || !is_bpf_graph_api_kfunc(insn->imm)))) {
 						verbose(env, "function calls are not allowed while holding a lock\n");
 						return -EINVAL;
 					}
-- 
2.39.2



