Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621071;
	b=VHuRjbt0YyJwRck5YwLRKWhVX6MllalnPhp8N8a8yUkHu32phk1gXTCuUSfmrXxyLIUc
	 Bd66w+jhY2NCh4OmcFehM40qHaCsCmYdvo5qNyUM0iHYuytI+UO7v9wdQ5GVnL9i2rI9L
	 251Eaffwjv/gXLzzdHsoKqMQMV5hnhHdcV72aqAqyYHpOL7cEQRqaekyYnyuONPcoLN9n
	 xEGFduct98/kVNIlyK0Akeye9ru6JdFDJ9JR6S5wtfyS58MGax8aIFbjMSleTVU8go771
	 JfLpCJF++gLggrtVKinJCpS3FBsXxFZEaTbTAzljh8FcsQ+VV04xY0tTKjMnF0VPvVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NMCSbjtB8XUc6ZKQ29JAPYVxkj9nmkdww3iXuNOuWk4=;
	b=oUAaq3bso9Y+aRHf99284Hh7CB5mg+JRpQ2gEz7RhRozd737RHZFKXScDPn2qzkIijvy
	 C37NJBVRLb8/QV3N9QKO5bz0CAbT0fT29EDb3GsZgEmDOrCKAVbeg/eiaSSMrUv5Aa5GK
	 cZHv2rnk8OnyAfUNhMD1eteH7WFoFqXwPb+jheWNCRYAYZOAeewcoJk14yJ2DzkdBekpc
	 yp0ZyIUG7ZkLlR+8fWO0huDn1EU8BtfDM0RrNG7NbaAi7TXEwQlBaSYQIeUvBf4oh9XeH
	 bAqqc4WJOLUFQPIaiu9Lu7YcfWhTkZWVC13QeAIhtvUf2l0SW10MR/0M6fxE9eL0Czw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k/L8cdFy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF99D606A31E;
	Wed, 25 Nov 2026 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k/L8cdFy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CB71F000C0;
	Wed, 25 Nov 2026 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621070;
	bh=NMCSbjtB8XUc6ZKQ29JAPYVxkj9nmkdww3iXuNOuWk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/L8cdFy0+U07cK0ufATs2QlJRSZkDwVANUQk27QnTLVCY+7FzAFQrYsTqtQh3oyI
	 XonyFA14fymvij9EKhJ5gV89A56Ys3WzxRdWZmHKp5Cm6BrBZxzj+EqZVIOdCscseT
	 9YzU09rTBEC3W0+t8hbLXr63BmP03bPG+xla+Pds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/990] bpf: Avoid changing callchain in bpf_get_stack_pe
Date: Wed, 25 Nov 2026 15:24:36 +0100
Message-ID: <20261125143824.643389447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 347c1d722e3ea4ffa2850585f5c76c6e551eac83 ]

There's no need to modify the trace object bpf_get_stack_pe, we just
need to pass the needed callchain length in separate argument.

This way we can have callchain pointers const and remove the trace->nr
modification and restoration.

Assisted-by: Codex:GPT-5.5

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-12-jolsa@kernel.org
Stable-dep-of: 007fd460798b ("bpf: Clamp the trace length in __bpf_get_stack() again")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 02b6b0e9cb6ce..2749985910855 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -541,7 +541,7 @@ const struct bpf_func_proto bpf_get_stackid_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
-static __u64 count_kernel_ip(struct perf_callchain_entry *trace)
+static __u64 count_kernel_ip(const struct perf_callchain_entry *trace)
 {
 	__u64 nr_kernel = 0;
 
@@ -621,15 +621,15 @@ const struct bpf_func_proto bpf_get_stackid_proto_pe = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
-static u32 callchain_store(struct perf_callchain_entry *trace, void *buf,
-			   u32 elem_size, u64 flags)
+static u32 callchain_store(const struct perf_callchain_entry *trace, u32 trace_nr,
+			   void *buf, u32 elem_size, u64 flags)
 {
 	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
-	u32 trace_nr, copy_len;
-	u64 *ips;
+	const u64 *ips;
+	u32 copy_len;
 
-	trace_nr = trace->nr - skip;
+	trace_nr = trace_nr - skip;
 	copy_len = trace_nr * elem_size;
 
 	ips = trace->ip + skip;
@@ -713,7 +713,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 		goto err_fault;
 	}
 
-	trace_nr = callchain_store(trace, buf, elem_size, flags);
+	trace_nr = callchain_store(trace, trace->nr, buf, elem_size, flags);
 
 	/* trace should not be dereferenced after this point */
 	if (may_fault)
@@ -817,8 +817,8 @@ const struct bpf_func_proto bpf_get_task_stack_sleepable_proto = {
 	.arg4_type	= ARG_ANYTHING,
 };
 
-static int __bpf_get_stack_pe(struct perf_callchain_entry *trace, void *buf, u32 size,
-			      u64 flags)
+static int __bpf_get_stack_pe(const struct perf_callchain_entry *trace, u32 trace_nr,
+			      void *buf, u32 size, u64 flags)
 {
 	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
 	u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
@@ -834,12 +834,12 @@ static int __bpf_get_stack_pe(struct perf_callchain_entry *trace, void *buf, u32
 		return -EINVAL;
 
 	max_depth = stack_map_calculate_max_depth(size, elem_size, flags);
-	trace->nr = min_t(u32, trace->nr, max_depth);
+	trace_nr = min_t(u32, trace_nr, max_depth);
 
-	if (trace->nr < skip)
+	if (trace_nr < skip)
 		return -EFAULT;
 
-	nr_trace = callchain_store(trace, buf, elem_size, flags);
+	nr_trace = callchain_store(trace, trace_nr, buf, elem_size, flags);
 	return callchain_finalize(buf, size, nr_trace, elem_size, flags, false /* !may_fault */);
 }
 
@@ -847,8 +847,8 @@ BPF_CALL_4(bpf_get_stack_pe, struct bpf_perf_event_data_kern *, ctx,
 	   void *, buf, u32, size, u64, flags)
 {
 	struct pt_regs *regs = (struct pt_regs *)(ctx->regs);
+	const struct perf_callchain_entry *trace;
 	struct perf_event *event = ctx->event;
-	struct perf_callchain_entry *trace;
 	bool kernel, user;
 	int err = -EINVAL;
 	__u64 nr_kernel;
@@ -871,13 +871,7 @@ BPF_CALL_4(bpf_get_stack_pe, struct bpf_perf_event_data_kern *, ctx,
 	nr_kernel = count_kernel_ip(trace);
 
 	if (kernel) {
-		__u64 nr = trace->nr;
-
-		trace->nr = nr_kernel;
-		err = __bpf_get_stack_pe(trace, buf, size, flags);
-
-		/* restore nr */
-		trace->nr = nr;
+		err = __bpf_get_stack_pe(trace, nr_kernel, buf, size, flags);
 	} else { /* user */
 		u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
 
@@ -885,7 +879,7 @@ BPF_CALL_4(bpf_get_stack_pe, struct bpf_perf_event_data_kern *, ctx,
 		if (skip > BPF_F_SKIP_FIELD_MASK)
 			goto clear;
 		flags = (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
-		err = __bpf_get_stack_pe(trace, buf, size, flags);
+		err = __bpf_get_stack_pe(trace, trace->nr, buf, size, flags);
 	}
 
 clear:
-- 
2.53.0



