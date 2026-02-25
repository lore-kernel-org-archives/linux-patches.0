Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522454369A;
	Wed, 25 Feb 2026 01:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982914; cv=none; b=jaXpRZDWRQFyyaT+gt3/nbpzXGtkiIcv20dxaQSSXMDLpPyQ0zmsKTtINuninCNlarQAb1/8BJw37ZlAgKuYKTZkK8lTYtT8OeRzcjm8inWNMqEpovesYkuPqFloRxvO1/JerkI9eHRNXwBeExFgdRr8QXP1vi7WO68/xVwmWPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982914; c=relaxed/simple;
	bh=b9vgqYUM+0IEvzXTqpvyB2NvadbFtWQFuNW1UuGr+yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgLKVXVBuGc/jKmxdyOTZhiH+VZ/zlHIaotMQb85x2PfywsguaxTkpUT2pFyEZyhtpqVj0bAa+qVlgFnQ/mplsBB6Enxdupi1Sk6cZ/BqRp4J2i5Mm/ZjANoRrwO5kC9wJ+YU9LFKScFOIZdAKdRzHPVYbHS+ozuZppyAHGGCeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GG0mLNb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GG0mLNb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11862C116D0;
	Wed, 25 Feb 2026 01:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982914;
	bh=b9vgqYUM+0IEvzXTqpvyB2NvadbFtWQFuNW1UuGr+yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GG0mLNb6/SJUS35x8B4QiwG452k5UXKRmmvlPwdMcseELbDShq/8U5pajy37FCX+l
	 Jf75Y4Ayf1FmBs7bXM4bBjIRmPMi0JdetDINSjI9EFNHG6B4n84ZTl3uceEz5nQvSo
	 RYONl5oSig+bYkE1amlOsKbuE4LagJwnX3kwriu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuran Liu <electronlsr@gmail.com>,
	Peili Gao <gplhust955@gmail.com>,
	Haoran Ni <haoran.ni.cs@gmail.com>,
	Zesen Liu <ftyghome@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 094/781] bpf: Fix memory access flags in helper prototypes
Date: Tue, 24 Feb 2026 17:13:23 -0800
Message-ID: <20260225012401.995436632@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zesen Liu <ftyghome@gmail.com>

[ Upstream commit 802eef5afb1865bc5536a5302c068ba2215a1f72 ]

After commit 37cce22dbd51 ("bpf: verifier: Refactor helper access type tracking"),
the verifier started relying on the access type flags in helper
function prototypes to perform memory access optimizations.

Currently, several helper functions utilizing ARG_PTR_TO_MEM lack the
corresponding MEM_RDONLY or MEM_WRITE flags. This omission causes the
verifier to incorrectly assume that the buffer contents are unchanged
across the helper call. Consequently, the verifier may optimize away
subsequent reads based on this wrong assumption, leading to correctness
issues.

For bpf_get_stack_proto_raw_tp, the original MEM_RDONLY was incorrect
since the helper writes to the buffer. Change it to ARG_PTR_TO_UNINIT_MEM
which correctly indicates write access to potentially uninitialized memory.

Similar issues were recently addressed for specific helpers in commit
ac44dcc788b9 ("bpf: Fix verifier assumptions of bpf_d_path's output buffer")
and commit 2eb7648558a7 ("bpf: Specify access type of bpf_sysctl_get_name args").

Fix these prototypes by adding the correct memory access flags.

Fixes: 37cce22dbd51 ("bpf: verifier: Refactor helper access type tracking")
Co-developed-by: Shuran Liu <electronlsr@gmail.com>
Signed-off-by: Shuran Liu <electronlsr@gmail.com>
Co-developed-by: Peili Gao <gplhust955@gmail.com>
Signed-off-by: Peili Gao <gplhust955@gmail.com>
Co-developed-by: Haoran Ni <haoran.ni.cs@gmail.com>
Signed-off-by: Haoran Ni <haoran.ni.cs@gmail.com>
Signed-off-by: Zesen Liu <ftyghome@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260120-helper_proto-v3-1-27b0180b4e77@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c     |  2 +-
 kernel/bpf/syscall.c     |  2 +-
 kernel/trace/bpf_trace.c |  6 +++---
 net/core/filter.c        | 20 ++++++++++----------
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index db72b96f9c8c8..f66284f8ec2cc 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1077,7 +1077,7 @@ const struct bpf_func_proto bpf_snprintf_proto = {
 	.func		= bpf_snprintf,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_MEM_OR_NULL | MEM_WRITE,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_PTR_TO_CONST_STR,
 	.arg4_type	= ARG_PTR_TO_MEM | PTR_MAYBE_NULL | MEM_RDONLY,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4ff82144f8853..ee116a3b7baf7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -6407,7 +6407,7 @@ static const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
 	.func		= bpf_kallsyms_lookup_name,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index fe28d86f7c357..59c2394981c72 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1022,7 +1022,7 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
 	.func		= bpf_snprintf_btf,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_WRITE,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE,
@@ -1526,7 +1526,7 @@ static const struct bpf_func_proto bpf_read_branch_records_proto = {
 	.gpl_only       = true,
 	.ret_type       = RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM_OR_NULL,
+	.arg2_type      = ARG_PTR_TO_MEM_OR_NULL | MEM_WRITE,
 	.arg3_type      = ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type      = ARG_ANYTHING,
 };
@@ -1661,7 +1661,7 @@ static const struct bpf_func_proto bpf_get_stack_proto_raw_tp = {
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg2_type	= ARG_PTR_TO_UNINIT_MEM,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
 };
diff --git a/net/core/filter.c b/net/core/filter.c
index 029e560e32ce3..b1f8e2930e1c4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6401,7 +6401,7 @@ static const struct bpf_func_proto bpf_xdp_fib_lookup_proto = {
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_WRITE,
 	.arg3_type      = ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };
@@ -6456,7 +6456,7 @@ static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
-	.arg2_type      = ARG_PTR_TO_MEM,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_WRITE,
 	.arg3_type      = ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };
@@ -8010,9 +8010,9 @@ static const struct bpf_func_proto bpf_tcp_raw_gen_syncookie_ipv4_proto = {
 	.gpl_only	= true, /* __cookie_v4_init_sequence() is GPL */
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg1_size	= sizeof(struct iphdr),
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -8042,9 +8042,9 @@ static const struct bpf_func_proto bpf_tcp_raw_gen_syncookie_ipv6_proto = {
 	.gpl_only	= true, /* __cookie_v6_init_sequence() is GPL */
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg1_size	= sizeof(struct ipv6hdr),
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
@@ -8062,9 +8062,9 @@ static const struct bpf_func_proto bpf_tcp_raw_check_syncookie_ipv4_proto = {
 	.gpl_only	= true, /* __cookie_v4_check is GPL */
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg1_size	= sizeof(struct iphdr),
-	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg2_size	= sizeof(struct tcphdr),
 };
 
@@ -8086,9 +8086,9 @@ static const struct bpf_func_proto bpf_tcp_raw_check_syncookie_ipv6_proto = {
 	.gpl_only	= true, /* __cookie_v6_check is GPL */
 	.pkt_access	= true,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg1_size	= sizeof(struct ipv6hdr),
-	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_RDONLY,
 	.arg2_size	= sizeof(struct tcphdr),
 };
 #endif /* CONFIG_SYN_COOKIES */
-- 
2.51.0



