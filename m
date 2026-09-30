Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3C14C651B;
	Wed, 30 Sep 2026 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785273; cv=none; b=L2vf0aaxZBTpuFDL45LbIwWDN7YVw5KFPTslH3Hv7lEyJo+4bq/AKEaHXxIsEvI3e1ik6yCijy1gXGM12zRL3PbSl/8BV8U+owSR+sajT7yIWqlMYFDI7srN+8jvtX2NYxW4K37FsKKxBEaVKpejZUmY3gxJ6dUafIuJu0sc6zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785273; c=relaxed/simple;
	bh=uAhnH71hs70frfPuAx8g28VJyC21Yt23ODlBCNhM1BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/Udw2lcDLFTRke+95WeOkovHQDSC4bC535zUjXOC65dRlpxr5U1F9XEjYY7dJGLAaYU70DtWnGxc6OWGCGdDdn7ds37PkKBC6RKyZw2J/WfD0Wn57z/hkZBPQR6CTAWUe4nJ70D9buHhx7qSVdGX+7zW53r0siPlIdnYMPoeBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoaGU1F7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoaGU1F7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFA91F000FF;
	Wed, 30 Sep 2026 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785268;
	bh=TFvuIxBAuRqiM0HheDE6oXIvsnaaueu2m4qQF/DftoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hoaGU1F7TIOCyWz7TP818a5saUAcEOXr/whSwU9kP7fyQKWrDggSrIYY44zwxoqUL
	 vHnAsWjCxwiU5LX+yl6mpC60bS9SdRDzE0hg21tKDvy85Ph2S4t7yciutBudz4Dwhh
	 SBtSe4K4UV3AqbC5SF79R5jcDa0IsyxEtz2fKLV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 404/982] bpf: Introduce might_sleep field in bpf_func_proto
Date: Wed, 30 Sep 2026 17:19:00 +0200
Message-ID: <20260930152425.488508703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 01685c5bddaa6df3d662c8afed5e5289fcc68e5a ]

Introduce bpf_func_proto->might_sleep to indicate a particular helper
might sleep. This will make later check whether a helper might be
sleepable or not easier.

Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20221124053211.2373553-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 620614bf7672 ("bpf: Mark bpf_btf_find_by_name_kind() as sleepable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h      | 1 +
 kernel/bpf/bpf_lsm.c     | 6 ++++--
 kernel/bpf/helpers.c     | 2 ++
 kernel/bpf/verifier.c    | 5 +++++
 kernel/trace/bpf_trace.c | 4 ++--
 5 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 436d862682916..92884bf344f8c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -616,6 +616,7 @@ struct bpf_func_proto {
 	u64 (*func)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 	bool gpl_only;
 	bool pkt_access;
+	bool might_sleep;
 	enum bpf_return_type ret_type;
 	union {
 		struct {
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 61e93253b6b5e..e7e195a2e5f98 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -179,6 +179,7 @@ BTF_ID_LIST_SINGLE(bpf_ima_inode_hash_btf_ids, struct, inode)
 static const struct bpf_func_proto bpf_ima_inode_hash_proto = {
 	.func		= bpf_ima_inode_hash,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
 	.arg1_btf_id	= &bpf_ima_inode_hash_btf_ids[0],
@@ -197,6 +198,7 @@ BTF_ID_LIST_SINGLE(bpf_ima_file_hash_btf_ids, struct, file)
 static const struct bpf_func_proto bpf_ima_file_hash_proto = {
 	.func		= bpf_ima_file_hash,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
 	.arg1_btf_id	= &bpf_ima_file_hash_btf_ids[0],
@@ -249,9 +251,9 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_bprm_opts_set:
 		return &bpf_bprm_opts_set_proto;
 	case BPF_FUNC_ima_inode_hash:
-		return prog->aux->sleepable ? &bpf_ima_inode_hash_proto : NULL;
+		return &bpf_ima_inode_hash_proto;
 	case BPF_FUNC_ima_file_hash:
-		return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
+		return &bpf_ima_file_hash_proto;
 	case BPF_FUNC_get_attach_cookie:
 		return bpf_prog_has_trampoline(prog) ? &bpf_get_attach_cookie_proto : NULL;
 #ifdef CONFIG_NET
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index cf422c80b30b3..4cd7854932944 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -661,6 +661,7 @@ BPF_CALL_3(bpf_copy_from_user, void *, dst, u32, size,
 const struct bpf_func_proto bpf_copy_from_user_proto = {
 	.func		= bpf_copy_from_user,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
@@ -691,6 +692,7 @@ BPF_CALL_5(bpf_copy_from_user_task, void *, dst, u32, size,
 const struct bpf_func_proto bpf_copy_from_user_task_proto = {
 	.func		= bpf_copy_from_user_task,
 	.gpl_only	= true,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c201435ddafd2..e2ce9f664a40a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7504,6 +7504,11 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		return -EINVAL;
 	}
 
+	if (!env->prog->aux->sleepable && fn->might_sleep) {
+		verbose(env, "helper call might sleep in a non-sleepable prog\n");
+		return -EINVAL;
+	}
+
 	/* With LD_ABS/IND some JITs save/restore skb from r1. */
 	changes_data = bpf_helper_changes_pkt_data(fn->func);
 	if (changes_data && fn->arg1_type != ARG_PTR_TO_CTX) {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 1d1a70d561965..fcddc223c3f06 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1502,9 +1502,9 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_task_stack:
 		return &bpf_get_task_stack_proto;
 	case BPF_FUNC_copy_from_user:
-		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
+		return &bpf_copy_from_user_proto;
 	case BPF_FUNC_copy_from_user_task:
-		return prog->aux->sleepable ? &bpf_copy_from_user_task_proto : NULL;
+		return &bpf_copy_from_user_task_proto;
 	case BPF_FUNC_snprintf_btf:
 		return &bpf_snprintf_btf_proto;
 	case BPF_FUNC_per_cpu_ptr:
-- 
2.53.0



