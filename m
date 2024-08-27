Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014CE38DC7;
	Tue, 27 Aug 2024 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770383; cv=none; b=P80s05+n/3oo/F0PzKcusY6bqhpu81KNdpHx2V0ZS7UAuGbN3zDF8s+UQqjVx0PonC/3UTluQoKYHeBYeQq1Y1oarzYC7Cn5AHd6UjqER9yeYqolpSPysKsXAi3btpqC+rTGCGq7DDBvpFoVAG8C+ImCDZWmk4Dbsrv+B+vWZbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770383; c=relaxed/simple;
	bh=/XA2Bdi6fB4K/+d3Yqp/rWbAqnEsJCHDmF49mVimliM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTTHZSg9WBEPq3M+4PbaGocipUYUcCQo6MUOYdZ+aLMiNh3AMmn+FHPo1u5iqXJbM+/NaouWwprZHOr9v84uhiF1OfxNvXa51C6LMtpggsnkqP5kErve8AH3ov/ea/MdOixCsqe1cojSCp+GSPLsSTw2MS8buiMzWipUavasn1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhVU1k3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhVU1k3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D0BC61042;
	Tue, 27 Aug 2024 14:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770382;
	bh=/XA2Bdi6fB4K/+d3Yqp/rWbAqnEsJCHDmF49mVimliM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhVU1k3JseHxt75d0aHVWj7X04+6BeDgCrHwVGm1Ue8xzzHT8zWSs3CAWPeiX+PdZ
	 HRrsoxqHbuVaPUhCbkrmrVdjmRNX6NEt04J7FP2nQOodVII7q3fi9tKokesZqN/uK/
	 2l+0MzO8roj0yzhUCdM7QaV/YmM//Jud2y6x6vbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cupertino Miranda <cupertino.miranda@oracle.com>,
	jose.marchesi@oracle.com,
	david.faust@oracle.com,
	Yonghong Song <yonghong.song@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/341] selftests/bpf: Fix a few tests for GCC related warnings.
Date: Tue, 27 Aug 2024 16:37:23 +0200
Message-ID: <20240827143851.478078237@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cupertino Miranda <cupertino.miranda@oracle.com>

[ Upstream commit 5ddafcc377f98778acc08f660dee6400aece6a62 ]

This patch corrects a few warnings to allow selftests to compile for
GCC.

-- progs/cpumask_failure.c --

progs/bpf_misc.h:136:22: error: ‘cpumask’ is used uninitialized
[-Werror=uninitialized]
  136 | #define __sink(expr) asm volatile("" : "+g"(expr))
      |                      ^~~
progs/cpumask_failure.c:68:9: note: in expansion of macro ‘__sink’
   68 |         __sink(cpumask);

The macro __sink(cpumask) with the '+' contraint modifier forces the
the compiler to expect a read and write from cpumask. GCC detects
that cpumask is never initialized and reports an error.
This patch removes the spurious non required definitions of cpumask.

-- progs/dynptr_fail.c --

progs/dynptr_fail.c:1444:9: error: ‘ptr1’ may be used uninitialized
[-Werror=maybe-uninitialized]
 1444 |         bpf_dynptr_clone(&ptr1, &ptr2);

Many of the tests in the file are related to the detection of
uninitialized pointers by the verifier. GCC is able to detect possible
uninitialized values, and reports this as an error.
The patch initializes all of the previous uninitialized structs.

-- progs/test_tunnel_kern.c --

progs/test_tunnel_kern.c:590:9: error: array subscript 1 is outside
array bounds of ‘struct geneve_opt[1]’ [-Werror=array-bounds=]
  590 |         *(int *) &gopt.opt_data = bpf_htonl(0xdeadbeef);
      |         ^~~~~~~~~~~~~~~~~~~~~~~
progs/test_tunnel_kern.c:575:27: note: at offset 4 into object ‘gopt’ of
size 4
  575 |         struct geneve_opt gopt;

This tests accesses beyond the defined data for the struct geneve_opt
which contains as last field "u8 opt_data[0]" which clearly does not get
reserved space (in stack) in the function header. This pattern is
repeated in ip6geneve_set_tunnel and geneve_set_tunnel functions.
GCC is able to see this and emits a warning.
The patch introduces a local struct that allocates enough space to
safely allow the write to opt_data field.

-- progs/jeq_infer_not_null_fail.c --

progs/jeq_infer_not_null_fail.c:21:40: error: array subscript ‘struct
bpf_map[0]’ is partly outside array bounds of ‘struct <anonymous>[1]’
[-Werror=array-bounds=]
   21 |         struct bpf_map *inner_map = map->inner_map_meta;
      |                                        ^~
progs/jeq_infer_not_null_fail.c:14:3: note: object ‘m_hash’ of size 32
   14 | } m_hash SEC(".maps");

This example defines m_hash in the context of the compilation unit and
casts it to struct bpf_map which is much smaller than the size of struct
bpf_map. It errors out in GCC when it attempts to access an element that
would be defined in struct bpf_map outsize of the defined limits for
m_hash.
This patch disables the warning through a GCC pragma.

This changes were tested in bpf-next master selftests without any
regressions.

Signed-off-by: Cupertino Miranda <cupertino.miranda@oracle.com>
Cc: jose.marchesi@oracle.com
Cc: david.faust@oracle.com
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Link: https://lore.kernel.org/r/20240510183850.286661-2-cupertino.miranda@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/cpumask_failure.c     |  3 --
 .../testing/selftests/bpf/progs/dynptr_fail.c | 12 ++---
 .../bpf/progs/jeq_infer_not_null_fail.c       |  4 ++
 .../selftests/bpf/progs/test_tunnel_kern.c    | 47 +++++++++++--------
 4 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/cpumask_failure.c b/tools/testing/selftests/bpf/progs/cpumask_failure.c
index a9bf6ea336cf6..a988d2823b528 100644
--- a/tools/testing/selftests/bpf/progs/cpumask_failure.c
+++ b/tools/testing/selftests/bpf/progs/cpumask_failure.c
@@ -61,11 +61,8 @@ SEC("tp_btf/task_newtask")
 __failure __msg("bpf_cpumask_set_cpu args#1 expected pointer to STRUCT bpf_cpumask")
 int BPF_PROG(test_mutate_cpumask, struct task_struct *task, u64 clone_flags)
 {
-	struct bpf_cpumask *cpumask;
-
 	/* Can't set the CPU of a non-struct bpf_cpumask. */
 	bpf_cpumask_set_cpu(0, (struct bpf_cpumask *)task->cpus_ptr);
-	__sink(cpumask);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/dynptr_fail.c b/tools/testing/selftests/bpf/progs/dynptr_fail.c
index 7ce7e827d5f01..66a60bfb58672 100644
--- a/tools/testing/selftests/bpf/progs/dynptr_fail.c
+++ b/tools/testing/selftests/bpf/progs/dynptr_fail.c
@@ -80,7 +80,7 @@ SEC("?raw_tp")
 __failure __msg("Unreleased reference id=2")
 int ringbuf_missing_release1(void *ctx)
 {
-	struct bpf_dynptr ptr;
+	struct bpf_dynptr ptr = {};
 
 	bpf_ringbuf_reserve_dynptr(&ringbuf, val, 0, &ptr);
 
@@ -1385,7 +1385,7 @@ SEC("?raw_tp")
 __failure __msg("Expected an initialized dynptr as arg #1")
 int dynptr_adjust_invalid(void *ctx)
 {
-	struct bpf_dynptr ptr;
+	struct bpf_dynptr ptr = {};
 
 	/* this should fail */
 	bpf_dynptr_adjust(&ptr, 1, 2);
@@ -1398,7 +1398,7 @@ SEC("?raw_tp")
 __failure __msg("Expected an initialized dynptr as arg #1")
 int dynptr_is_null_invalid(void *ctx)
 {
-	struct bpf_dynptr ptr;
+	struct bpf_dynptr ptr = {};
 
 	/* this should fail */
 	bpf_dynptr_is_null(&ptr);
@@ -1411,7 +1411,7 @@ SEC("?raw_tp")
 __failure __msg("Expected an initialized dynptr as arg #1")
 int dynptr_is_rdonly_invalid(void *ctx)
 {
-	struct bpf_dynptr ptr;
+	struct bpf_dynptr ptr = {};
 
 	/* this should fail */
 	bpf_dynptr_is_rdonly(&ptr);
@@ -1424,7 +1424,7 @@ SEC("?raw_tp")
 __failure __msg("Expected an initialized dynptr as arg #1")
 int dynptr_size_invalid(void *ctx)
 {
-	struct bpf_dynptr ptr;
+	struct bpf_dynptr ptr = {};
 
 	/* this should fail */
 	bpf_dynptr_size(&ptr);
@@ -1437,7 +1437,7 @@ SEC("?raw_tp")
 __failure __msg("Expected an initialized dynptr as arg #1")
 int clone_invalid1(void *ctx)
 {
-	struct bpf_dynptr ptr1;
+	struct bpf_dynptr ptr1 = {};
 	struct bpf_dynptr ptr2;
 
 	/* this should fail */
diff --git a/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c b/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
index f46965053acb2..4d619bea9c758 100644
--- a/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
+++ b/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
@@ -4,6 +4,10 @@
 #include <bpf/bpf_helpers.h>
 #include "bpf_misc.h"
 
+#ifndef __clang__
+#pragma GCC diagnostic ignored "-Warray-bounds"
+#endif
+
 char _license[] SEC("license") = "GPL";
 
 struct {
diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index f66af753bbbb8..e68da33d7631d 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -597,12 +597,18 @@ int ip6vxlan_get_tunnel_src(struct __sk_buff *skb)
 	return TC_ACT_OK;
 }
 
+struct local_geneve_opt {
+	struct geneve_opt gopt;
+	int data;
+};
+
 SEC("tc")
 int geneve_set_tunnel(struct __sk_buff *skb)
 {
 	int ret;
 	struct bpf_tunnel_key key;
-	struct geneve_opt gopt;
+	struct local_geneve_opt local_gopt;
+	struct geneve_opt *gopt = (struct geneve_opt *) &local_gopt;
 
 	__builtin_memset(&key, 0x0, sizeof(key));
 	key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
@@ -610,14 +616,14 @@ int geneve_set_tunnel(struct __sk_buff *skb)
 	key.tunnel_tos = 0;
 	key.tunnel_ttl = 64;
 
-	__builtin_memset(&gopt, 0x0, sizeof(gopt));
-	gopt.opt_class = bpf_htons(0x102); /* Open Virtual Networking (OVN) */
-	gopt.type = 0x08;
-	gopt.r1 = 0;
-	gopt.r2 = 0;
-	gopt.r3 = 0;
-	gopt.length = 2; /* 4-byte multiple */
-	*(int *) &gopt.opt_data = bpf_htonl(0xdeadbeef);
+	__builtin_memset(gopt, 0x0, sizeof(local_gopt));
+	gopt->opt_class = bpf_htons(0x102); /* Open Virtual Networking (OVN) */
+	gopt->type = 0x08;
+	gopt->r1 = 0;
+	gopt->r2 = 0;
+	gopt->r3 = 0;
+	gopt->length = 2; /* 4-byte multiple */
+	*(int *) &gopt->opt_data = bpf_htonl(0xdeadbeef);
 
 	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
 				     BPF_F_ZERO_CSUM_TX);
@@ -626,7 +632,7 @@ int geneve_set_tunnel(struct __sk_buff *skb)
 		return TC_ACT_SHOT;
 	}
 
-	ret = bpf_skb_set_tunnel_opt(skb, &gopt, sizeof(gopt));
+	ret = bpf_skb_set_tunnel_opt(skb, gopt, sizeof(local_gopt));
 	if (ret < 0) {
 		log_err(ret);
 		return TC_ACT_SHOT;
@@ -661,7 +667,8 @@ SEC("tc")
 int ip6geneve_set_tunnel(struct __sk_buff *skb)
 {
 	struct bpf_tunnel_key key;
-	struct geneve_opt gopt;
+	struct local_geneve_opt local_gopt;
+	struct geneve_opt *gopt = (struct geneve_opt *) &local_gopt;
 	int ret;
 
 	__builtin_memset(&key, 0x0, sizeof(key));
@@ -677,16 +684,16 @@ int ip6geneve_set_tunnel(struct __sk_buff *skb)
 		return TC_ACT_SHOT;
 	}
 
-	__builtin_memset(&gopt, 0x0, sizeof(gopt));
-	gopt.opt_class = bpf_htons(0x102); /* Open Virtual Networking (OVN) */
-	gopt.type = 0x08;
-	gopt.r1 = 0;
-	gopt.r2 = 0;
-	gopt.r3 = 0;
-	gopt.length = 2; /* 4-byte multiple */
-	*(int *) &gopt.opt_data = bpf_htonl(0xfeedbeef);
+	__builtin_memset(gopt, 0x0, sizeof(local_gopt));
+	gopt->opt_class = bpf_htons(0x102); /* Open Virtual Networking (OVN) */
+	gopt->type = 0x08;
+	gopt->r1 = 0;
+	gopt->r2 = 0;
+	gopt->r3 = 0;
+	gopt->length = 2; /* 4-byte multiple */
+	*(int *) &gopt->opt_data = bpf_htonl(0xfeedbeef);
 
-	ret = bpf_skb_set_tunnel_opt(skb, &gopt, sizeof(gopt));
+	ret = bpf_skb_set_tunnel_opt(skb, gopt, sizeof(gopt));
 	if (ret < 0) {
 		log_err(ret);
 		return TC_ACT_SHOT;
-- 
2.43.0



