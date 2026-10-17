Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74EC3B1EC8;
	Sat, 17 Oct 2026 17:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257710; cv=none; b=jpuDdBLqAIFTRIsaDL6XPqvFDsQUBv+TqZc4AnQI+1pT85I+CqAksbC5XbSDtMrJFdKXBwJnrst7TohKy/xcoKlqcZvSjkEK1Yy0p7tJ8AxgDoTYRIvEc8snA3mhjeLcM+4NHTsGLZrufD9PB7gihFCZBQo60LnYmRfa260yuFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257710; c=relaxed/simple;
	bh=wG/D3x30wKN9fCO2tZxY5VbpzNSyIGTMq802Cu9V9fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6tIa+9nkuXm5nZ/8Nz7kOrNzDowB+s0l2dfSSrdCnAJ7DCA1Fl40Xve1iug7tw/FknhPOY7pAkc1xuvmAlUTB46bKfnGQUNwarSQWkZYykxabGiZDR4Wv7YAcyhCEpNlstp9VwR1JLlibPY1adC1OwQJmKFaBQjCt00PlwPIQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlNiMBO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlNiMBO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B3E1F000C4;
	Sat, 17 Oct 2026 17:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257707;
	bh=JxGWVnnT3Qo0xKqq0u/BsA/AwmGZNQS1/btFhTWg+Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlNiMBO+p4sDKFQZCxN5w7ry9UT7V41NwQchCbCqxbUUt92dqw7oBHi1hPTFdEb+d
	 tAVd+6W0dJ6wezuv7w/EC1FUQjZpPSJxwi2c6DkW1qtFO10geoLDaUbfwHyCNLGpdg
	 Qk4OeIafKBlbqC6Y2YxvL6/G1S2XH4fTbqdYJx6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0644/1674] bpf: Prevent tailcall infinite loop caused by freplace
Date: Sat, 17 Oct 2026 17:48:36 +0200
Message-ID: <20261017160447.635897281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit d6083f040d5d8f8d748462c77e90547097df936e ]

There is a potential infinite loop issue that can occur when using a
combination of tail calls and freplace.

In an upcoming selftest, the attach target for entry_freplace of
tailcall_freplace.c is subprog_tc of tc_bpf2bpf.c, while the tail call in
entry_freplace leads to entry_tc. This results in an infinite loop:

entry_tc -> subprog_tc -> entry_freplace --tailcall-> entry_tc.

The problem arises because the tail_call_cnt in entry_freplace resets to
zero each time entry_freplace is executed, causing the tail call mechanism
to never terminate, eventually leading to a kernel panic.

To fix this issue, the solution is twofold:

1. Prevent updating a program extended by an freplace program to a
   prog_array map.
2. Prevent extending a program that is already part of a prog_array map
   with an freplace program.

This ensures that:

* If a program or its subprogram has been extended by an freplace program,
  it can no longer be updated to a prog_array map.
* If a program has been added to a prog_array map, neither it nor its
  subprograms can be extended by an freplace program.

Moreover, an extension program should not be tailcalled. As such, return
-EINVAL if the program has a type of BPF_PROG_TYPE_EXT when adding it to a
prog_array map.

Additionally, fix a minor code style issue by replacing eight spaces with a
tab for proper formatting.

Reviewed-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20241015150207.70264-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     | 17 +++++++++++----
 kernel/bpf/arraymap.c   | 26 +++++++++++++++++++++--
 kernel/bpf/core.c       |  1 +
 kernel/bpf/syscall.c    |  7 +++---
 kernel/bpf/trampoline.c | 47 ++++++++++++++++++++++++++++++++++-------
 5 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 19aa8a5257884..5b1bc7b2ddfae 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1258,8 +1258,12 @@ int bpf_dynptr_check_size(u32 size);
 u32 __bpf_dynptr_size(const struct bpf_dynptr_kern *ptr);
 
 #ifdef CONFIG_BPF_JIT
-int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr);
-int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr);
+int bpf_trampoline_link_prog(struct bpf_tramp_link *link,
+			     struct bpf_trampoline *tr,
+			     struct bpf_prog *tgt_prog);
+int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
+			       struct bpf_trampoline *tr,
+			       struct bpf_prog *tgt_prog);
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
@@ -1340,12 +1344,14 @@ void bpf_jit_uncharge_modmem(u32 size);
 bool bpf_prog_has_trampoline(const struct bpf_prog *prog);
 #else
 static inline int bpf_trampoline_link_prog(struct bpf_tramp_link *link,
-					   struct bpf_trampoline *tr)
+					   struct bpf_trampoline *tr,
+					   struct bpf_prog *tgt_prog)
 {
 	return -ENOTSUPP;
 }
 static inline int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
-					     struct bpf_trampoline *tr)
+					     struct bpf_trampoline *tr,
+					     struct bpf_prog *tgt_prog)
 {
 	return -ENOTSUPP;
 }
@@ -1444,6 +1450,9 @@ struct bpf_prog_aux {
 	bool tail_call_reachable;
 	bool xdp_has_frags;
 	bool changes_pkt_data;
+	bool is_extended; /* true if extended by freplace program */
+	u64 prog_array_member_cnt; /* counts how many times as member of prog_array */
+	struct mutex ext_mutex; /* mutex for is_extended and prog_array_member_cnt */
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index ec5c489ed3131..ca135fa407b85 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -909,22 +909,44 @@ static void *prog_fd_array_get_ptr(struct bpf_map *map,
 				   struct file *map_file, int fd)
 {
 	struct bpf_prog *prog = bpf_prog_get(fd);
+	bool is_extended;
 
 	if (IS_ERR(prog))
 		return prog;
 
-	if (!bpf_prog_map_compatible(map, prog)) {
+	if (prog->type == BPF_PROG_TYPE_EXT ||
+	    !bpf_prog_map_compatible(map, prog)) {
 		bpf_prog_put(prog);
 		return ERR_PTR(-EINVAL);
 	}
 
+	mutex_lock(&prog->aux->ext_mutex);
+	is_extended = prog->aux->is_extended;
+	if (!is_extended)
+		prog->aux->prog_array_member_cnt++;
+	mutex_unlock(&prog->aux->ext_mutex);
+	if (is_extended) {
+		/* Extended prog can not be tail callee. It's to prevent a
+		 * potential infinite loop like:
+		 * tail callee prog entry -> tail callee prog subprog ->
+		 * freplace prog entry --tailcall-> tail callee prog entry.
+		 */
+		bpf_prog_put(prog);
+		return ERR_PTR(-EBUSY);
+	}
+
 	return prog;
 }
 
 static void prog_fd_array_put_ptr(struct bpf_map *map, void *ptr, bool need_defer)
 {
+	struct bpf_prog *prog = ptr;
+
+	mutex_lock(&prog->aux->ext_mutex);
+	prog->aux->prog_array_member_cnt--;
+	mutex_unlock(&prog->aux->ext_mutex);
 	/* bpf_prog is freed after one RCU or tasks trace grace period */
-	bpf_prog_put(ptr);
+	bpf_prog_put(prog);
 }
 
 static u32 prog_fd_array_sys_lookup_elem(void *ptr)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ea78ef4774198..3fc818987ef0e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -123,6 +123,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
+	mutex_init(&fp->aux->ext_mutex);
 	mutex_init(&fp->aux->dst_mutex);
 
 	return fp;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1710391f386af..cd31c926f5da3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3125,7 +3125,8 @@ static void bpf_tracing_link_release(struct bpf_link *link)
 		container_of(link, struct bpf_tracing_link, link.link);
 
 	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&tr_link->link,
-						tr_link->trampoline));
+						tr_link->trampoline,
+						tr_link->tgt_prog));
 
 	bpf_trampoline_put(tr_link->trampoline);
 
@@ -3260,7 +3261,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	 *   in prog->aux
 	 *
 	 * - if prog->aux->dst_trampoline is NULL, the program has already been
-         *   attached to a target and its initial target was cleared (below)
+	 *   attached to a target and its initial target was cleared (below)
 	 *
 	 * - if tgt_prog != NULL, the caller specified tgt_prog_fd +
 	 *   target_btf_id using the link_create API.
@@ -3335,7 +3336,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	if (err)
 		goto out_unlock;
 
-	err = bpf_trampoline_link_prog(&link->link, tr);
+	err = bpf_trampoline_link_prog(&link->link, tr, tgt_prog);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
 		link = NULL;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 6f7968d3704eb..a75c3bdaa35ae 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -508,7 +508,27 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+static int bpf_freplace_check_tgt_prog(struct bpf_prog *tgt_prog)
+{
+	struct bpf_prog_aux *aux = tgt_prog->aux;
+
+	guard(mutex)(&aux->ext_mutex);
+	if (aux->prog_array_member_cnt)
+		/* Program extensions can not extend target prog when the target
+		 * prog has been updated to any prog_array map as tail callee.
+		 * It's to prevent a potential infinite loop like:
+		 * tgt prog entry -> tgt prog subprog -> freplace prog entry
+		 * --tailcall-> tgt prog entry.
+		 */
+		return -EBUSY;
+
+	aux->is_extended = true;
+	return 0;
+}
+
+static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link,
+				      struct bpf_trampoline *tr,
+				      struct bpf_prog *tgt_prog)
 {
 	enum bpf_tramp_prog_type kind;
 	struct bpf_tramp_link *link_exiting;
@@ -529,6 +549,9 @@ static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_tr
 		/* Cannot attach extension if fentry/fexit are in use. */
 		if (cnt)
 			return -EBUSY;
+		err = bpf_freplace_check_tgt_prog(tgt_prog);
+		if (err)
+			return err;
 		tr->extension_prog = link->link.prog;
 		return bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
 					  link->link.prog->bpf_func);
@@ -555,17 +578,21 @@ static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_tr
 	return err;
 }
 
-int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+int bpf_trampoline_link_prog(struct bpf_tramp_link *link,
+			     struct bpf_trampoline *tr,
+			     struct bpf_prog *tgt_prog)
 {
 	int err;
 
 	mutex_lock(&tr->mutex);
-	err = __bpf_trampoline_link_prog(link, tr);
+	err = __bpf_trampoline_link_prog(link, tr, tgt_prog);
 	mutex_unlock(&tr->mutex);
 	return err;
 }
 
-static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
+					struct bpf_trampoline *tr,
+					struct bpf_prog *tgt_prog)
 {
 	enum bpf_tramp_prog_type kind;
 	int err;
@@ -576,6 +603,8 @@ static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_
 		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP,
 					 tr->extension_prog->bpf_func, NULL);
 		tr->extension_prog = NULL;
+		guard(mutex)(&tgt_prog->aux->ext_mutex);
+		tgt_prog->aux->is_extended = false;
 		return err;
 	}
 	hlist_del_init(&link->tramp_hlist);
@@ -584,12 +613,14 @@ static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_
 }
 
 /* bpf_trampoline_unlink_prog() should never fail. */
-int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
+			       struct bpf_trampoline *tr,
+			       struct bpf_prog *tgt_prog)
 {
 	int err;
 
 	mutex_lock(&tr->mutex);
-	err = __bpf_trampoline_unlink_prog(link, tr);
+	err = __bpf_trampoline_unlink_prog(link, tr, tgt_prog);
 	mutex_unlock(&tr->mutex);
 	return err;
 }
@@ -604,7 +635,7 @@ static void bpf_shim_tramp_link_release(struct bpf_link *link)
 	if (!shim_link->trampoline)
 		return;
 
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&shim_link->link, shim_link->trampoline));
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&shim_link->link, shim_link->trampoline, NULL));
 	bpf_trampoline_put(shim_link->trampoline);
 }
 
@@ -716,7 +747,7 @@ int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
 		goto err;
 	}
 
-	err = __bpf_trampoline_link_prog(&shim_link->link, tr);
+	err = __bpf_trampoline_link_prog(&shim_link->link, tr, NULL);
 	if (err)
 		goto err;
 
-- 
2.53.0



