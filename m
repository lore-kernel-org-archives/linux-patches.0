Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2D9168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77657C433EF;
	Mon,  8 May 2023 10:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542106;
	bh=cIssViBorXb94ENPT3pUT7IayBXCYZmS+9wfZvtmJsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AifSyWBTXbhmfbo9aBaUDTU4IZwR8p0D8pHuYu/OS5hCrXG5HR5vYl8JLvPEmZPAu
	 ddlvnQbSJwQYfDikkJ4Qh10ypa3TUi01ATNEU4Pfd7ds1PsjF1UdmtcXRmDe4JOtak
	 wO/E8NhPtbS5Ey7IioGYEKczn/MgDApIrDZJZLF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 329/663] bpf: rename list_head -> graph_root in field info types
Date: Mon,  8 May 2023 11:42:35 +0200
Message-Id: <20230508094438.859522897@linuxfoundation.org>
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

[ Upstream commit 30465003ad776a922c32b2dac58db14f120f037e ]

Many of the structs recently added to track field info for linked-list
head are useful as-is for rbtree root. So let's do a mechanical renaming
of list_head-related types and fields:

include/linux/bpf.h:
  struct btf_field_list_head -> struct btf_field_graph_root
  list_head -> graph_root in struct btf_field union
kernel/bpf/btf.c:
  list_head -> graph_root in struct btf_field_info

This is a nonfunctional change, functionality to actually use these
fields for rbtree will be added in further patches.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Link: https://lore.kernel.org/r/20221217082506.1570898-5-davemarchevsky@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: f6a6a5a97628 ("bpf: Fix struct_meta lookup for bpf_obj_free_fields kfunc call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   |  4 ++--
 kernel/bpf/btf.c      | 21 +++++++++++----------
 kernel/bpf/helpers.c  |  4 ++--
 kernel/bpf/verifier.c | 21 +++++++++++----------
 4 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8f9ad2722a2ba..6f207ba587283 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -189,7 +189,7 @@ struct btf_field_kptr {
 	u32 btf_id;
 };
 
-struct btf_field_list_head {
+struct btf_field_graph_root {
 	struct btf *btf;
 	u32 value_btf_id;
 	u32 node_offset;
@@ -201,7 +201,7 @@ struct btf_field {
 	enum btf_field_type type;
 	union {
 		struct btf_field_kptr kptr;
-		struct btf_field_list_head list_head;
+		struct btf_field_graph_root graph_root;
 	};
 };
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 9880faa7e6760..b38b3335cd1e7 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3228,7 +3228,7 @@ struct btf_field_info {
 		struct {
 			const char *node_name;
 			u32 value_btf_id;
-		} list_head;
+		} graph_root;
 	};
 };
 
@@ -3335,8 +3335,8 @@ static int btf_find_list_head(const struct btf *btf, const struct btf_type *pt,
 		return -EINVAL;
 	info->type = BPF_LIST_HEAD;
 	info->off = off;
-	info->list_head.value_btf_id = id;
-	info->list_head.node_name = list_node;
+	info->graph_root.value_btf_id = id;
+	info->graph_root.node_name = list_node;
 	return BTF_FIELD_FOUND;
 }
 
@@ -3604,13 +3604,14 @@ static int btf_parse_list_head(const struct btf *btf, struct btf_field *field,
 	u32 offset;
 	int i;
 
-	t = btf_type_by_id(btf, info->list_head.value_btf_id);
+	t = btf_type_by_id(btf, info->graph_root.value_btf_id);
 	/* We've already checked that value_btf_id is a struct type. We
 	 * just need to figure out the offset of the list_node, and
 	 * verify its type.
 	 */
 	for_each_member(i, t, member) {
-		if (strcmp(info->list_head.node_name, __btf_name_by_offset(btf, member->name_off)))
+		if (strcmp(info->graph_root.node_name,
+			   __btf_name_by_offset(btf, member->name_off)))
 			continue;
 		/* Invalid BTF, two members with same name */
 		if (n)
@@ -3627,9 +3628,9 @@ static int btf_parse_list_head(const struct btf *btf, struct btf_field *field,
 		if (offset % __alignof__(struct bpf_list_node))
 			return -EINVAL;
 
-		field->list_head.btf = (struct btf *)btf;
-		field->list_head.value_btf_id = info->list_head.value_btf_id;
-		field->list_head.node_offset = offset;
+		field->graph_root.btf = (struct btf *)btf;
+		field->graph_root.value_btf_id = info->graph_root.value_btf_id;
+		field->graph_root.node_offset = offset;
 	}
 	if (!n)
 		return -ENOENT;
@@ -3736,11 +3737,11 @@ int btf_check_and_fixup_fields(const struct btf *btf, struct btf_record *rec)
 
 		if (!(rec->fields[i].type & BPF_LIST_HEAD))
 			continue;
-		btf_id = rec->fields[i].list_head.value_btf_id;
+		btf_id = rec->fields[i].graph_root.value_btf_id;
 		meta = btf_find_struct_meta(btf, btf_id);
 		if (!meta)
 			return -EFAULT;
-		rec->fields[i].list_head.value_rec = meta->record;
+		rec->fields[i].graph_root.value_rec = meta->record;
 
 		if (!(rec->field_mask & BPF_LIST_NODE))
 			continue;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index af30c6cbd65db..527040ffead41 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1745,12 +1745,12 @@ void bpf_list_head_free(const struct btf_field *field, void *list_head,
 	while (head != orig_head) {
 		void *obj = head;
 
-		obj -= field->list_head.node_offset;
+		obj -= field->graph_root.node_offset;
 		head = head->next;
 		/* The contained type can also have resources, including a
 		 * bpf_list_head which needs to be freed.
 		 */
-		bpf_obj_free_fields(field->list_head.value_rec, obj);
+		bpf_obj_free_fields(field->graph_root.value_rec, obj);
 		/* bpf_mem_free requires migrate_disable(), since we can be
 		 * called from map free path as well apart from BPF program (as
 		 * part of map ops doing bpf_obj_free_fields).
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0afafb539d783..9c44fd71dcb55 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8997,21 +8997,22 @@ static int process_kf_arg_ptr_to_list_node(struct bpf_verifier_env *env,
 
 	field = meta->arg_list_head.field;
 
-	et = btf_type_by_id(field->list_head.btf, field->list_head.value_btf_id);
+	et = btf_type_by_id(field->graph_root.btf, field->graph_root.value_btf_id);
 	t = btf_type_by_id(reg->btf, reg->btf_id);
-	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, 0, field->list_head.btf,
-				  field->list_head.value_btf_id, true)) {
+	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, 0, field->graph_root.btf,
+				  field->graph_root.value_btf_id, true)) {
 		verbose(env, "operation on bpf_list_head expects arg#1 bpf_list_node at offset=%d "
 			"in struct %s, but arg is at offset=%d in struct %s\n",
-			field->list_head.node_offset, btf_name_by_offset(field->list_head.btf, et->name_off),
+			field->graph_root.node_offset,
+			btf_name_by_offset(field->graph_root.btf, et->name_off),
 			list_node_off, btf_name_by_offset(reg->btf, t->name_off));
 		return -EINVAL;
 	}
 
-	if (list_node_off != field->list_head.node_offset) {
+	if (list_node_off != field->graph_root.node_offset) {
 		verbose(env, "arg#1 offset=%d, but expected bpf_list_node at offset=%d in struct %s\n",
-			list_node_off, field->list_head.node_offset,
-			btf_name_by_offset(field->list_head.btf, et->name_off));
+			list_node_off, field->graph_root.node_offset,
+			btf_name_by_offset(field->graph_root.btf, et->name_off));
 		return -EINVAL;
 	}
 	/* Set arg#1 for expiration after unlock */
@@ -9453,9 +9454,9 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 
 				mark_reg_known_zero(env, regs, BPF_REG_0);
 				regs[BPF_REG_0].type = PTR_TO_BTF_ID | MEM_ALLOC;
-				regs[BPF_REG_0].btf = field->list_head.btf;
-				regs[BPF_REG_0].btf_id = field->list_head.value_btf_id;
-				regs[BPF_REG_0].off = field->list_head.node_offset;
+				regs[BPF_REG_0].btf = field->graph_root.btf;
+				regs[BPF_REG_0].btf_id = field->graph_root.value_btf_id;
+				regs[BPF_REG_0].off = field->graph_root.node_offset;
 			} else if (meta.func_id == special_kfunc_list[KF_bpf_cast_to_kern_ctx]) {
 				mark_reg_known_zero(env, regs, BPF_REG_0);
 				regs[BPF_REG_0].type = PTR_TO_BTF_ID | PTR_TRUSTED;
-- 
2.39.2



