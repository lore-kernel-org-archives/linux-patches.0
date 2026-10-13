Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A524F93D0;
	Tue, 13 Oct 2026 12:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894328; cv=none; b=AL7DA0K5ajgPnqbAyUh9JSsySyn0idVtK9jQS/QZBQYAMZMeNLTeBBy6itmKl1M1U8qraJNvF4C0ExhNXgxofCACjp0ib9GfbKoFaZTuhfclFdu/F1EMKdG9CIRWkZ9gXtYkv52q6NubZ5PQdGG4dHqOFthovfvHRHrE8ICAZFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894328; c=relaxed/simple;
	bh=KZjQ72BRTiDVc+V6LC17WQQEMYKUwaPUiKhzpDlc8SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CToia6cqdN54LGrw+svlfaMjP6WK5QTW/S/CrsioelBFcsxCvjIZiPimR2GMhB9JsSu954OkVTpn75ixgW1W1llVFad31DBNvJd7XS2kYP+ZIh6G/wYAcg1lizTvnt6+TDY8wcwQwRY3zy9iQY7o6pSddU5B8lk/yPE9OM2JPF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNT/9f4g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNT/9f4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029821F000FF;
	Tue, 13 Oct 2026 12:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894326;
	bh=wwv+TEMBS798HSquBjY6g2UeJt9EVvVUkthrQJIZw2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNT/9f4gSRMg1F7wgdMAV1QxUD8qUIee860W16TZ7MLkyEogSfBLuM2q7QqwW8Nbp
	 nMoyxRDcT+7f9pDWTrWWwCKPcWzEpTku5pF6YVvXJ2QADPma9hWcjj/h9JfTtKroXv
	 hahtKrse8G3pd+2Rpa9ETZOBUQaCpPdiqQgtzSig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Amery Hung <ameryhung@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 486/621] bpf: Reject MEM_ALLOC BTF accesses past object bounds
Date: Tue, 13 Oct 2026 13:38:01 +0200
Message-ID: <20261013112932.363738853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
 kernel/bpf/verifier.c | 12 ++++++++----
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 774603d0a8bae..d018a74a882d0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2830,7 +2830,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 bool btf_struct_ids_match(struct bpf_verifier_log *log,
 			  const struct btf *btf, u32 id, int off,
 			  const struct btf *need_btf, u32 need_type_id,
-			  bool strict);
+			  bool strict, bool walk_flex_arrays);
 
 int btf_distill_func_proto(struct bpf_verifier_log *log,
 			   struct btf *btf,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 3509bbe39efaa..706b3eefd9ef5 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6986,7 +6986,7 @@ enum bpf_struct_walk_result {
 static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 			   const struct btf_type *t, int off, int size,
 			   u32 *next_btf_id, enum bpf_type_flag *flag,
-			   const char **field_name)
+			   const char **field_name, bool walk_flex_arrays)
 {
 	u32 i, moff, mtrue_end, msize = 0, total_nelems = 0;
 	const struct btf_type *mtype, *elem_type = NULL;
@@ -7013,11 +7013,14 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
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
 
@@ -7280,7 +7283,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
 
 	t = btf_type_by_id(btf, id);
 	do {
-		err = btf_struct_walk(log, btf, t, off, size, &id, &tmp_flag, field_name);
+		err = btf_struct_walk(log, btf, t, off, size, &id, &tmp_flag,
+				      field_name, !type_is_alloc(reg->type));
 
 		switch (err) {
 		case WALK_PTR:
@@ -7339,7 +7343,7 @@ bool btf_types_are_same(const struct btf *btf1, u32 id1,
 bool btf_struct_ids_match(struct bpf_verifier_log *log,
 			  const struct btf *btf, u32 id, int off,
 			  const struct btf *need_btf, u32 need_type_id,
-			  bool strict)
+			  bool strict, bool walk_flex_arrays)
 {
 	const struct btf_type *type;
 	enum bpf_type_flag flag = 0;
@@ -7358,7 +7362,8 @@ bool btf_struct_ids_match(struct bpf_verifier_log *log,
 	type = btf_type_by_id(btf, id);
 	if (!type)
 		return false;
-	err = btf_struct_walk(log, btf, type, off, 1, &id, &flag, NULL);
+	err = btf_struct_walk(log, btf, type, off, 1, &id, &flag, NULL,
+			      walk_flex_arrays);
 	if (err != WALK_STRUCT)
 		return false;
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 696e1b8d06608..419455fe03267 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5934,7 +5934,8 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 	 */
 	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->off,
 				  kptr_field->kptr.btf, kptr_field->kptr.btf_id,
-				  kptr_field->type != BPF_KPTR_UNREF))
+				  kptr_field->type != BPF_KPTR_UNREF,
+				  !type_is_alloc(reg->type)))
 		goto bad_type;
 	return 0;
 bad_type:
@@ -9529,7 +9530,8 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 
 			if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->off,
 						  btf_vmlinux, *arg_btf_id,
-						  strict_type_match)) {
+						  strict_type_match,
+						  !type_is_alloc(reg->type))) {
 				verbose(env, "R%d is of type %s but %s is expected\n",
 					regno, btf_type_name(reg->btf, reg->btf_id),
 					btf_type_name(btf_vmlinux, *arg_btf_id));
@@ -12829,7 +12831,8 @@ static int process_kf_arg_ptr_to_btf_id(struct bpf_verifier_env *env,
 
 	reg_ref_t = btf_type_skip_modifiers(reg_btf, reg_ref_id, &reg_ref_id);
 	reg_ref_tname = btf_name_by_offset(reg_btf, reg_ref_t->name_off);
-	struct_same = btf_struct_ids_match(&env->log, reg_btf, reg_ref_id, reg->off, meta->btf, ref_id, strict_type_match);
+	struct_same = btf_struct_ids_match(&env->log, reg_btf, reg_ref_id, reg->off, meta->btf, ref_id, strict_type_match,
+					   !type_is_alloc(reg->type));
 	/* If kfunc is accepting a projection type (ie. __sk_buff), it cannot
 	 * actually use it -- it must cast to the underlying type. So we allow
 	 * caller to pass in the underlying type.
@@ -13266,7 +13269,8 @@ __process_kf_arg_ptr_to_graph_node(struct bpf_verifier_env *env,
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



