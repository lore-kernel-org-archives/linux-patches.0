Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B741915E8B;
	Mon, 30 Dec 2024 15:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574191; cv=none; b=IVdNZ1Fp9U3EcPSyTlUmxfLmql2Lg//H4+IAfe3dzBuzTT2xF0+HLzXtnjUPWDqnh7rIr695B+5QkxohNp6wpZy0TwXBQQtPuehoDdSwWbo6lNgv0QUC3+QEl41lfF6vnsIJwfsK7bgr7ViuLwxTKZ9u1YSiaTlKSnYB9BAvF/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574191; c=relaxed/simple;
	bh=CDARV6xXxujvJtjSWR1WrzxGLuL3gFLAZuLOfaths2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUL93VUZn5XU1o7RROIu4pVeTHhxOsbXUYTgzLHBuNTqoD+gx2sMEAGW//63wENSX6+IL6IBbiSxLnzmA4nb83DrtDQG/8e/5l26j90HKic/CGO1U9a3LVlsY+htPrEk7g+O4THbzaK5JkdSH2ufUWFkAZBbeP5M0Y4XjglDIaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAQpKE1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAQpKE1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3FDC4CED0;
	Mon, 30 Dec 2024 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574191;
	bh=CDARV6xXxujvJtjSWR1WrzxGLuL3gFLAZuLOfaths2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAQpKE1P0ilHcZ6Bho9YvNPcfUVmuOh+eJePAxAN35iK2k1Vbh93hfgFyGAaZXyNr
	 k74C87Puv/2BjHjzABuddQVjccnaXtDDNlbf/qsu1TU/MVBMwjS6VIdhOZiyHInaB6
	 YgEP5Y2hLd9l8Yhpl9BCiqDBV+79XDvR9XslGzZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/114] bpf: Zero index arg error string for dynptr and iter
Date: Mon, 30 Dec 2024 16:43:01 +0100
Message-ID: <20241230154220.567133947@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit bd74e238ae6944b462f57ce8752440a011ba4530 ]

Andrii spotted that process_dynptr_func's rejection of incorrect
argument register type will print an error string where argument numbers
are not zero-indexed, unlike elsewhere in the verifier.  Fix this by
subtracting 1 from regno. The same scenario exists for iterator
messages. Fix selftest error strings that match on the exact argument
number while we're at it to ensure clean bisection.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241203002235.3776418-1-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                         | 12 +++++-----
 .../testing/selftests/bpf/progs/dynptr_fail.c | 22 +++++++++----------
 .../selftests/bpf/progs/iters_state_safety.c  | 14 ++++++------
 .../selftests/bpf/progs/iters_testmod_seq.c   |  4 ++--
 .../bpf/progs/test_kfunc_dynptr_param.c       |  2 +-
 .../selftests/bpf/progs/verifier_bits_iter.c  |  4 ++--
 6 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 84d958f2c031..767f1cb8c27e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7868,7 +7868,7 @@ static int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn
 	if (reg->type != PTR_TO_STACK && reg->type != CONST_PTR_TO_DYNPTR) {
 		verbose(env,
 			"arg#%d expected pointer to stack or const struct bpf_dynptr\n",
-			regno);
+			regno - 1);
 		return -EINVAL;
 	}
 
@@ -7922,7 +7922,7 @@ static int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn
 		if (!is_dynptr_reg_valid_init(env, reg)) {
 			verbose(env,
 				"Expected an initialized dynptr as arg #%d\n",
-				regno);
+				regno - 1);
 			return -EINVAL;
 		}
 
@@ -7930,7 +7930,7 @@ static int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn
 		if (!is_dynptr_type_expected(env, reg, arg_type & ~MEM_RDONLY)) {
 			verbose(env,
 				"Expected a dynptr of type %s as arg #%d\n",
-				dynptr_type_str(arg_to_dynptr_type(arg_type)), regno);
+				dynptr_type_str(arg_to_dynptr_type(arg_type)), regno - 1);
 			return -EINVAL;
 		}
 
@@ -7999,7 +7999,7 @@ static int process_iter_arg(struct bpf_verifier_env *env, int regno, int insn_id
 	 */
 	btf_id = btf_check_iter_arg(meta->btf, meta->func_proto, regno - 1);
 	if (btf_id < 0) {
-		verbose(env, "expected valid iter pointer as arg #%d\n", regno);
+		verbose(env, "expected valid iter pointer as arg #%d\n", regno - 1);
 		return -EINVAL;
 	}
 	t = btf_type_by_id(meta->btf, btf_id);
@@ -8009,7 +8009,7 @@ static int process_iter_arg(struct bpf_verifier_env *env, int regno, int insn_id
 		/* bpf_iter_<type>_new() expects pointer to uninit iter state */
 		if (!is_iter_reg_valid_uninit(env, reg, nr_slots)) {
 			verbose(env, "expected uninitialized iter_%s as arg #%d\n",
-				iter_type_str(meta->btf, btf_id), regno);
+				iter_type_str(meta->btf, btf_id), regno - 1);
 			return -EINVAL;
 		}
 
@@ -8033,7 +8033,7 @@ static int process_iter_arg(struct bpf_verifier_env *env, int regno, int insn_id
 			break;
 		case -EINVAL:
 			verbose(env, "expected an initialized iter_%s as arg #%d\n",
-				iter_type_str(meta->btf, btf_id), regno);
+				iter_type_str(meta->btf, btf_id), regno - 1);
 			return err;
 		case -EPROTO:
 			verbose(env, "expected an RCU CS when using %s\n", meta->func_name);
diff --git a/tools/testing/selftests/bpf/progs/dynptr_fail.c b/tools/testing/selftests/bpf/progs/dynptr_fail.c
index 8f36c9de7591..dfd817d0348c 100644
--- a/tools/testing/selftests/bpf/progs/dynptr_fail.c
+++ b/tools/testing/selftests/bpf/progs/dynptr_fail.c
@@ -149,7 +149,7 @@ int ringbuf_release_uninit_dynptr(void *ctx)
 
 /* A dynptr can't be used after it has been invalidated */
 SEC("?raw_tp")
-__failure __msg("Expected an initialized dynptr as arg #3")
+__failure __msg("Expected an initialized dynptr as arg #2")
 int use_after_invalid(void *ctx)
 {
 	struct bpf_dynptr ptr;
@@ -428,7 +428,7 @@ int invalid_helper2(void *ctx)
 
 /* A bpf_dynptr is invalidated if it's been written into */
 SEC("?raw_tp")
-__failure __msg("Expected an initialized dynptr as arg #1")
+__failure __msg("Expected an initialized dynptr as arg #0")
 int invalid_write1(void *ctx)
 {
 	struct bpf_dynptr ptr;
@@ -1407,7 +1407,7 @@ int invalid_slice_rdwr_rdonly(struct __sk_buff *skb)
 
 /* bpf_dynptr_adjust can only be called on initialized dynptrs */
 SEC("?raw_tp")
-__failure __msg("Expected an initialized dynptr as arg #1")
+__failure __msg("Expected an initialized dynptr as arg #0")
 int dynptr_adjust_invalid(void *ctx)
 {
 	struct bpf_dynptr ptr = {};
@@ -1420,7 +1420,7 @@ int dynptr_adjust_invalid(void *ctx)
 
 /* bpf_dynptr_is_null can only be called on initialized dynptrs */
 SEC("?raw_tp")
-__failure __msg("Expected an initialized dynptr as arg #1")
+__failure __msg("Expected an initialized dynptr as arg #0")
 int dynptr_is_null_invalid(void *ctx)
 {
 	struct bpf_dynptr ptr = {};
@@ -1433,7 +1433,7 @@ int dynptr_is_null_invalid(void *ctx)
 
 /* bpf_dynptr_is_rdonly can only be called on initialized dynptrs */
 SEC("?raw_tp")
-__failure __msg("Expected an initialized dynptr as arg #1")
+__failure __msg("Expected an initialized dynptr as arg #0")
 int dynptr_is_rdonly_invalid(void *ctx)
 {
 	struct bpf_dynptr ptr = {};
@@ -1446,7 +1446,7 @@ int dynptr_is_rdonly_invalid(void *ctx)
 
 /* bpf_dynptr_size can only be called on initialized dynptrs */
 SEC("?raw_tp")
-__failure __msg("Expected an initialized dynptr as arg #1")
+__failure __msg("Expected an initialized dynptr as arg #0")
 int dynptr_size_invalid(void *ctx)
 {
 	struct bpf_dynptr ptr = {};
@@ -1459,7 +1459,7 @@ int dynptr_size_invalid(void *ctx)
 
 /* Only initialized dynptrs can be cloned */
 SEC("?raw_tp")
-__failure __msg("Expected an initialized dynptr as arg #1")
+__failure __msg("Expected an initialized dynptr as arg #0")
 int clone_invalid1(void *ctx)
 {
 	struct bpf_dynptr ptr1 = {};
@@ -1493,7 +1493,7 @@ int clone_invalid2(struct xdp_md *xdp)
 
 /* Invalidating a dynptr should invalidate its clones */
 SEC("?raw_tp")
-__failure __msg("Expected an initialized dynptr as arg #3")
+__failure __msg("Expected an initialized dynptr as arg #2")
 int clone_invalidate1(void *ctx)
 {
 	struct bpf_dynptr clone;
@@ -1514,7 +1514,7 @@ int clone_invalidate1(void *ctx)
 
 /* Invalidating a dynptr should invalidate its parent */
 SEC("?raw_tp")
-__failure __msg("Expected an initialized dynptr as arg #3")
+__failure __msg("Expected an initialized dynptr as arg #2")
 int clone_invalidate2(void *ctx)
 {
 	struct bpf_dynptr ptr;
@@ -1535,7 +1535,7 @@ int clone_invalidate2(void *ctx)
 
 /* Invalidating a dynptr should invalidate its siblings */
 SEC("?raw_tp")
-__failure __msg("Expected an initialized dynptr as arg #3")
+__failure __msg("Expected an initialized dynptr as arg #2")
 int clone_invalidate3(void *ctx)
 {
 	struct bpf_dynptr ptr;
@@ -1723,7 +1723,7 @@ __noinline long global_call_bpf_dynptr(const struct bpf_dynptr *dynptr)
 }
 
 SEC("?raw_tp")
-__failure __msg("arg#1 expected pointer to stack or const struct bpf_dynptr")
+__failure __msg("arg#0 expected pointer to stack or const struct bpf_dynptr")
 int test_dynptr_reg_type(void *ctx)
 {
 	struct task_struct *current = NULL;
diff --git a/tools/testing/selftests/bpf/progs/iters_state_safety.c b/tools/testing/selftests/bpf/progs/iters_state_safety.c
index d47e59aba6de..f41257eadbb2 100644
--- a/tools/testing/selftests/bpf/progs/iters_state_safety.c
+++ b/tools/testing/selftests/bpf/progs/iters_state_safety.c
@@ -73,7 +73,7 @@ int create_and_forget_to_destroy_fail(void *ctx)
 }
 
 SEC("?raw_tp")
-__failure __msg("expected an initialized iter_num as arg #1")
+__failure __msg("expected an initialized iter_num as arg #0")
 int destroy_without_creating_fail(void *ctx)
 {
 	/* init with zeros to stop verifier complaining about uninit stack */
@@ -91,7 +91,7 @@ int destroy_without_creating_fail(void *ctx)
 }
 
 SEC("?raw_tp")
-__failure __msg("expected an initialized iter_num as arg #1")
+__failure __msg("expected an initialized iter_num as arg #0")
 int compromise_iter_w_direct_write_fail(void *ctx)
 {
 	struct bpf_iter_num iter;
@@ -143,7 +143,7 @@ int compromise_iter_w_direct_write_and_skip_destroy_fail(void *ctx)
 }
 
 SEC("?raw_tp")
-__failure __msg("expected an initialized iter_num as arg #1")
+__failure __msg("expected an initialized iter_num as arg #0")
 int compromise_iter_w_helper_write_fail(void *ctx)
 {
 	struct bpf_iter_num iter;
@@ -230,7 +230,7 @@ int valid_stack_reuse(void *ctx)
 }
 
 SEC("?raw_tp")
-__failure __msg("expected uninitialized iter_num as arg #1")
+__failure __msg("expected uninitialized iter_num as arg #0")
 int double_create_fail(void *ctx)
 {
 	struct bpf_iter_num iter;
@@ -258,7 +258,7 @@ int double_create_fail(void *ctx)
 }
 
 SEC("?raw_tp")
-__failure __msg("expected an initialized iter_num as arg #1")
+__failure __msg("expected an initialized iter_num as arg #0")
 int double_destroy_fail(void *ctx)
 {
 	struct bpf_iter_num iter;
@@ -284,7 +284,7 @@ int double_destroy_fail(void *ctx)
 }
 
 SEC("?raw_tp")
-__failure __msg("expected an initialized iter_num as arg #1")
+__failure __msg("expected an initialized iter_num as arg #0")
 int next_without_new_fail(void *ctx)
 {
 	struct bpf_iter_num iter;
@@ -305,7 +305,7 @@ int next_without_new_fail(void *ctx)
 }
 
 SEC("?raw_tp")
-__failure __msg("expected an initialized iter_num as arg #1")
+__failure __msg("expected an initialized iter_num as arg #0")
 int next_after_destroy_fail(void *ctx)
 {
 	struct bpf_iter_num iter;
diff --git a/tools/testing/selftests/bpf/progs/iters_testmod_seq.c b/tools/testing/selftests/bpf/progs/iters_testmod_seq.c
index 4a176e6aede8..6543d5b6e0a9 100644
--- a/tools/testing/selftests/bpf/progs/iters_testmod_seq.c
+++ b/tools/testing/selftests/bpf/progs/iters_testmod_seq.c
@@ -79,7 +79,7 @@ int testmod_seq_truncated(const void *ctx)
 
 SEC("?raw_tp")
 __failure
-__msg("expected an initialized iter_testmod_seq as arg #2")
+__msg("expected an initialized iter_testmod_seq as arg #1")
 int testmod_seq_getter_before_bad(const void *ctx)
 {
 	struct bpf_iter_testmod_seq it;
@@ -89,7 +89,7 @@ int testmod_seq_getter_before_bad(const void *ctx)
 
 SEC("?raw_tp")
 __failure
-__msg("expected an initialized iter_testmod_seq as arg #2")
+__msg("expected an initialized iter_testmod_seq as arg #1")
 int testmod_seq_getter_after_bad(const void *ctx)
 {
 	struct bpf_iter_testmod_seq it;
diff --git a/tools/testing/selftests/bpf/progs/test_kfunc_dynptr_param.c b/tools/testing/selftests/bpf/progs/test_kfunc_dynptr_param.c
index e68667aec6a6..cd4d752bd089 100644
--- a/tools/testing/selftests/bpf/progs/test_kfunc_dynptr_param.c
+++ b/tools/testing/selftests/bpf/progs/test_kfunc_dynptr_param.c
@@ -45,7 +45,7 @@ int BPF_PROG(not_valid_dynptr, int cmd, union bpf_attr *attr, unsigned int size)
 }
 
 SEC("?lsm.s/bpf")
-__failure __msg("arg#1 expected pointer to stack or const struct bpf_dynptr")
+__failure __msg("arg#0 expected pointer to stack or const struct bpf_dynptr")
 int BPF_PROG(not_ptr_to_stack, int cmd, union bpf_attr *attr, unsigned int size)
 {
 	unsigned long val = 0;
diff --git a/tools/testing/selftests/bpf/progs/verifier_bits_iter.c b/tools/testing/selftests/bpf/progs/verifier_bits_iter.c
index a7a6ae6c162f..8bcddadfc4da 100644
--- a/tools/testing/selftests/bpf/progs/verifier_bits_iter.c
+++ b/tools/testing/selftests/bpf/progs/verifier_bits_iter.c
@@ -32,7 +32,7 @@ int BPF_PROG(no_destroy, struct bpf_iter_meta *meta, struct cgroup *cgrp)
 
 SEC("iter/cgroup")
 __description("uninitialized iter in ->next()")
-__failure __msg("expected an initialized iter_bits as arg #1")
+__failure __msg("expected an initialized iter_bits as arg #0")
 int BPF_PROG(next_uninit, struct bpf_iter_meta *meta, struct cgroup *cgrp)
 {
 	struct bpf_iter_bits it = {};
@@ -43,7 +43,7 @@ int BPF_PROG(next_uninit, struct bpf_iter_meta *meta, struct cgroup *cgrp)
 
 SEC("iter/cgroup")
 __description("uninitialized iter in ->destroy()")
-__failure __msg("expected an initialized iter_bits as arg #1")
+__failure __msg("expected an initialized iter_bits as arg #0")
 int BPF_PROG(destroy_uninit, struct bpf_iter_meta *meta, struct cgroup *cgrp)
 {
 	struct bpf_iter_bits it = {};
-- 
2.39.5



