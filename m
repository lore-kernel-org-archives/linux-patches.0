Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C6446C4BC;
	Tue, 21 Jul 2026 18:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659559; cv=none; b=bxtFTKz1m0sITW6WCVzRXEaoLtgz2AlrbU809lnuqgrbK2LE07iStfDbjPDLws5QyMgl5MvJHvHGCBJVtTSKMde41O65I40z+JLhBp/w2EldCIqbnOY2kC2XKS6Lxm8YZbwNBKaLxRrNQ6TQOtNm2HWl9cpGzWcqWjOLSiQtn4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659559; c=relaxed/simple;
	bh=l7Sz10LyKJuqHU4UDYeHw3DX+Cqw/2licRtBCTLvyss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUlG6y/OhVCEGg30NambH9sl0PS+9OcBMFSsuRj3K+OpBXmat8H+O2dqMmCmA0AqQjQ1eZfAVFWSDs3SMFpZmXD9f/nyVGf7r4D6/kED/lOO1WexCwjids72qS5y3gbFp1M6wJARXrfwA/QxNuCbXv9cMbxCufqiT2ZCtE4Pq2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwjFgXxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwjFgXxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5571F000E9;
	Tue, 21 Jul 2026 18:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659557;
	bh=O+BZqKe1bvZYeP1+gula44tVt14UyuUw656tihXla2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwjFgXxYgZcbSr0k+GnHb6JoN6WZkSA1TVom1yJVYko3qOnqldACXCatjPKSC9XSR
	 4omSCDKD+Hmpm61Fkq5D3DYKCHQegVWDrekpRxLZkmhP0XEhCnHDUD0vxi7mDI8Cnz
	 qCHT28qJxn7vM1yyQKdpKTjzdQ5G0BPey/a0i5Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1565/1611] bpf: Consistently use reg_state() for register access in the verifier
Date: Tue, 21 Jul 2026 17:28:01 +0200
Message-ID: <20260721152550.663916862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 7af3339948601e188d93d7e03326aeb8fcbd6bea ]

Replace the pattern of declaring a local regs array from cur_regs()
and then indexing into it with the more concise reg_state() helper.
This simplifies the code by eliminating intermediate variables and
makes register access more consistent throughout the verifier.

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20260113134826.2214860-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 53040a81ae57 ("bpf: Keep dynamic inner array lookups nullable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5690,8 +5690,8 @@ static int check_stack_write(struct bpf_
 static int check_map_access_type(struct bpf_verifier_env *env, u32 regno,
 				 int off, int size, enum bpf_access_type type)
 {
-	struct bpf_reg_state *regs = cur_regs(env);
-	struct bpf_map *map = regs[regno].map_ptr;
+	struct bpf_reg_state *reg = reg_state(env, regno);
+	struct bpf_map *map = reg->map_ptr;
 	u32 cap = bpf_map_flags_to_cap(map);
 
 	if (type == BPF_WRITE && !(cap & BPF_MAP_CAN_WRITE)) {
@@ -6195,8 +6195,7 @@ static bool may_access_direct_pkt_data(s
 static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
 			       int size, bool zero_size_allowed)
 {
-	struct bpf_reg_state *regs = cur_regs(env);
-	struct bpf_reg_state *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	int err;
 
 	/* We may have added a variable offset to the packet pointer; but any
@@ -6283,8 +6282,7 @@ static int check_sock_access(struct bpf_
 			     u32 regno, int off, int size,
 			     enum bpf_access_type t)
 {
-	struct bpf_reg_state *regs = cur_regs(env);
-	struct bpf_reg_state *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	struct bpf_insn_access_aux info = {};
 	bool valid;
 
@@ -7469,8 +7467,7 @@ static int check_stack_access_within_bou
 		int regno, int off, int access_size,
 		enum bpf_access_type type)
 {
-	struct bpf_reg_state *regs = cur_regs(env);
-	struct bpf_reg_state *reg = regs + regno;
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	struct bpf_func_state *state = func(env, reg);
 	s64 min_off, max_off;
 	int err;
@@ -8414,7 +8411,7 @@ static int process_spin_lock(struct bpf_
 {
 	bool is_lock = flags & PROCESS_SPIN_LOCK, is_res_lock = flags & PROCESS_RES_LOCK;
 	const char *lock_str = is_res_lock ? "bpf_res_spin" : "bpf_spin";
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	struct bpf_verifier_state *cur = env->cur_state;
 	bool is_const = tnum_is_const(reg->var_off);
 	bool is_irq = flags & PROCESS_LOCK_IRQ;
@@ -8530,7 +8527,7 @@ static int process_spin_lock(struct bpf_
 static int check_map_field_pointer(struct bpf_verifier_env *env, u32 regno,
 				   enum btf_field_type field_type)
 {
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	bool is_const = tnum_is_const(reg->var_off);
 	struct bpf_map *map = reg->map_ptr;
 	u64 val = reg->var_off.value;
@@ -8577,7 +8574,7 @@ static int check_map_field_pointer(struc
 static int process_timer_func(struct bpf_verifier_env *env, int regno,
 			      struct bpf_call_arg_meta *meta)
 {
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	struct bpf_map *map = reg->map_ptr;
 	int err;
 
@@ -8601,7 +8598,7 @@ static int process_timer_func(struct bpf
 static int process_wq_func(struct bpf_verifier_env *env, int regno,
 			   struct bpf_kfunc_call_arg_meta *meta)
 {
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	struct bpf_map *map = reg->map_ptr;
 	int err;
 
@@ -8622,7 +8619,7 @@ static int process_wq_func(struct bpf_ve
 static int process_task_work_func(struct bpf_verifier_env *env, int regno,
 				  struct bpf_kfunc_call_arg_meta *meta)
 {
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	struct bpf_map *map = reg->map_ptr;
 	int err;
 
@@ -8642,7 +8639,7 @@ static int process_task_work_func(struct
 static int process_kptr_func(struct bpf_verifier_env *env, int regno,
 			     struct bpf_call_arg_meta *meta)
 {
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	struct btf_field *kptr_field;
 	struct bpf_map *map_ptr;
 	struct btf_record *rec;
@@ -8715,7 +8712,7 @@ static int process_kptr_func(struct bpf_
 static int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn_idx,
 			       enum bpf_arg_type arg_type, int clone_ref_obj_id)
 {
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	int err;
 
 	if (reg->type != PTR_TO_STACK && reg->type != CONST_PTR_TO_DYNPTR) {
@@ -8835,7 +8832,7 @@ static bool is_kfunc_arg_iter(struct bpf
 static int process_iter_arg(struct bpf_verifier_env *env, int regno, int insn_idx,
 			    struct bpf_kfunc_call_arg_meta *meta)
 {
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	const struct btf_type *t;
 	int spi, err, i, nr_slots, btf_id;
 
@@ -9307,7 +9304,7 @@ static int check_reg_type(struct bpf_ver
 			  const u32 *arg_btf_id,
 			  struct bpf_call_arg_meta *meta)
 {
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	enum bpf_reg_type expected, type = reg->type;
 	const struct bpf_reg_types *compatible;
 	int i, j;
@@ -9720,7 +9717,7 @@ static int check_func_arg(struct bpf_ver
 			  int insn_idx)
 {
 	u32 regno = BPF_REG_1 + arg;
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	enum bpf_arg_type arg_type = fn->arg_type[arg];
 	enum bpf_reg_type type = reg->type;
 	u32 *arg_btf_id = NULL;
@@ -11250,7 +11247,7 @@ record_func_key(struct bpf_verifier_env
 		int func_id, int insn_idx)
 {
 	struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
-	struct bpf_reg_state *regs = cur_regs(env), *reg;
+	struct bpf_reg_state *reg;
 	struct bpf_map *map = meta->map_ptr;
 	u64 val, max;
 	int err;
@@ -11262,7 +11259,7 @@ record_func_key(struct bpf_verifier_env
 		return -EINVAL;
 	}
 
-	reg = &regs[BPF_REG_3];
+	reg = reg_state(env, BPF_REG_3);
 	val = reg->var_off.value;
 	max = map->max_entries;
 
@@ -11408,8 +11405,7 @@ static struct bpf_insn_aux_data *cur_aux
 
 static bool loop_flag_is_zero(struct bpf_verifier_env *env)
 {
-	struct bpf_reg_state *regs = cur_regs(env);
-	struct bpf_reg_state *reg = &regs[BPF_REG_4];
+	struct bpf_reg_state *reg = reg_state(env, BPF_REG_4);
 	bool reg_is_null = register_is_null(reg);
 
 	if (reg_is_null)
@@ -12680,7 +12676,7 @@ static int process_kf_arg_ptr_to_btf_id(
 static int process_irq_flag(struct bpf_verifier_env *env, int regno,
 			     struct bpf_kfunc_call_arg_meta *meta)
 {
-	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	struct bpf_reg_state *reg = reg_state(env, regno);
 	int err, kfunc_class = IRQ_NATIVE_KFUNC;
 	bool irq_save;
 


