Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6710B37C0E2;
	Sat, 12 Sep 2026 07:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197750; cv=none; b=UUCKBUjSm5Jykk0RmfcHEwIy/eYJ80lUH+kG+Jsu+iMtB9Db3XPx/otT0Wtthxfmf2OxS123fADlLLZ6u1FlkOike+jXRty3xxpmdQE6VgF43IQjDhJdM7BtsxBuGQMq+RKnXFkYjTxPFk9vhQp3fsxw+5Nsd+0gGFJ583YqZgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197750; c=relaxed/simple;
	bh=8JseQ1qvR83e3iRmfhD4jrmFUFuVQtMsUpCrq29VD1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vB4nwmhOJEd17lCztcpTGXi4bxe9/M1Alm6o53c5EvmdD8MbKbidHAZJ35dDkBmEWWwQE7t5I6+yDc2QB91L1Qu1n7rokWPnhHDIzk90+hKHmZEnZgxGJ2N7iqd3HKZM9P6qGOEcyuT++Hvx2bwQD6lIDOqmIoQPQ+TCFy2HNeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QY/Ki7Rl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QY/Ki7Rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F781F000FF;
	Sat, 12 Sep 2026 07:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197749;
	bh=n4bxdmiru28DlWN4br1uTSaR55IXeWJSoRonzjXDxwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QY/Ki7RlNzYAniEg9COPNWb1BfQbn9XWKMYLQM2HqEoq3GL5KTEJDHyd5DSoxHKR9
	 Ky1KdR8MBbqABT0claWFDXld1B2JTKfOLJLDaat5afld67I6Q7mw7mdeHH+IreJQKG
	 M3RMgbOOQp0cyUJXaG1GVLDH+MWbn/r86fUxrg94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Amery Hung <ameryhung@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0240/1815] bpf: Reject MEM_ALLOC BTF accesses past object bounds
Date: Sat, 12 Sep 2026 08:33:10 +0200
Message-ID: <20260912065654.622675659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit 9c9ee0324c774490ae953162aaaf4561d222bd93 ]

BTF struct walks relax the struct-size check for accesses through a
trailing flexible array. That is valid for ordinary BTF type walking, but
PTR_TO_BTF_ID | MEM_ALLOC values point to objects allocated with the static
BTF type size.

When walking a MEM_ALLOC object, reject the access before applying the
flexible-array relaxation if the access range extends past the struct size.
Apply the same policy to struct ID matching so kfunc and kptr type checks
do not walk past the allocated object bounds either.

Fixes: 958cf2e273f0 ("bpf: Introduce bpf_obj_new")
Fixes: 36d8bdf75a93 ("bpf: Add alloc/xchg/direct_access support for local percpu kptr")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/4b8c8a81102ba4b595011434c881194f264ddc59.1782807039.git.chenyy23@mails.tsinghua.edu.cn
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   |  2 +-
 kernel/bpf/btf.c      | 17 +++++++++++------
 kernel/bpf/verifier.c | 11 +++++++----
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ba09795e0bfdb..adf53f7edf287 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -3146,7 +3146,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 bool btf_struct_ids_match(struct bpf_verifier_log *log,
 			  const struct btf *btf, u32 id, int off,
 			  const struct btf *need_btf, u32 need_type_id,
-			  bool strict);
+			  bool strict, bool walk_flex_arrays);
 
 int btf_distill_func_proto(struct bpf_verifier_log *log,
 			   struct btf *btf,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index c4673a54c4baf..e904f6086d2e1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7108,7 +7108,7 @@ enum bpf_struct_walk_result {
 static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 			   const struct btf_type *t, int off, int size,
 			   u32 *next_btf_id, enum bpf_type_flag *flag,
-			   const char **field_name)
+			   const char **field_name, bool walk_flex_arrays)
 {
 	u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
 	const struct btf_type *mtype, *elem_type = NULL;
@@ -7135,11 +7135,14 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 		*flag |= PTR_UNTRUSTED;
 
 	if (off + size > t->size) {
+		struct btf_array *array_elem;
+
+		if (!walk_flex_arrays)
+			goto error;
+
 		/* If the last element is a variable size array, we may
 		 * need to relax the rule.
 		 */
-		struct btf_array *array_elem;
-
 		if (vlen == 0)
 			goto error;
 
@@ -7404,7 +7407,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
 
 	t = btf_type_by_id(btf, id);
 	do {
-		err = btf_struct_walk(log, btf, t, off, size, &id, &tmp_flag, field_name);
+		err = btf_struct_walk(log, btf, t, off, size, &id, &tmp_flag,
+				      field_name, !type_is_alloc(reg->type));
 
 		switch (err) {
 		case WALK_PTR:
@@ -7463,7 +7467,7 @@ bool btf_types_are_same(const struct btf *btf1, u32 id1,
 bool btf_struct_ids_match(struct bpf_verifier_log *log,
 			  const struct btf *btf, u32 id, int off,
 			  const struct btf *need_btf, u32 need_type_id,
-			  bool strict)
+			  bool strict, bool walk_flex_arrays)
 {
 	const struct btf_type *type;
 	enum bpf_type_flag flag = 0;
@@ -7482,7 +7486,8 @@ bool btf_struct_ids_match(struct bpf_verifier_log *log,
 	type = btf_type_by_id(btf, id);
 	if (!type)
 		return false;
-	err = btf_struct_walk(log, btf, type, off, 1, &id, &flag, NULL);
+	err = btf_struct_walk(log, btf, type, off, 1, &id, &flag, NULL,
+			      walk_flex_arrays);
 	if (err != WALK_STRUCT)
 		return false;
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fdc5fbb1f78ca..4e8b653fb34b9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4349,7 +4349,8 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 	 */
 	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->var_off.value,
 				  kptr_field->kptr.btf, kptr_field->kptr.btf_id,
-				  kptr_field->type != BPF_KPTR_UNREF))
+				  kptr_field->type != BPF_KPTR_UNREF,
+				  !type_is_alloc(reg->type)))
 		goto bad_type;
 	return 0;
 bad_type:
@@ -7947,7 +7948,7 @@ static int check_reg_type(struct bpf_verifier_env *env, struct bpf_reg_state *re
 
 			if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id,
 						  reg->var_off.value, btf_vmlinux, *arg_btf_id,
-						  strict_type_match)) {
+						  strict_type_match, !type_is_alloc(reg->type))) {
 				verbose(env, "%s is of type %s but %s is expected\n",
 					reg_arg_name(env, argno),
 					btf_type_name(reg->btf, reg->btf_id),
@@ -11414,7 +11415,8 @@ static int process_kf_arg_ptr_to_btf_id(struct bpf_verifier_env *env,
 	reg_ref_t = btf_type_skip_modifiers(reg_btf, reg_ref_id, &reg_ref_id);
 	reg_ref_tname = btf_name_by_offset(reg_btf, reg_ref_t->name_off);
 	struct_same = btf_struct_ids_match(&env->log, reg_btf, reg_ref_id, reg->var_off.value,
-					   meta->btf, ref_id, strict_type_match);
+					   meta->btf, ref_id, strict_type_match,
+					   !type_is_alloc(reg->type));
 	/* If kfunc is accepting a projection type (ie. __sk_buff), it cannot
 	 * actually use it -- it must cast to the underlying type. So we allow
 	 * caller to pass in the underlying type.
@@ -11861,7 +11863,8 @@ __process_kf_arg_ptr_to_graph_node(struct bpf_verifier_env *env,
 	et = btf_type_by_id(field->graph_root.btf, field->graph_root.value_btf_id);
 	t = btf_type_by_id(reg->btf, reg->btf_id);
 	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, 0, field->graph_root.btf,
-				  field->graph_root.value_btf_id, true)) {
+				  field->graph_root.value_btf_id, true,
+				  !type_is_alloc(reg->type))) {
 		verbose(env, "operation on %s expects arg#1 %s at offset=%d "
 			"in struct %s, but arg is at offset=%d in struct %s\n",
 			btf_field_type_name(head_field_type),
-- 
2.53.0



