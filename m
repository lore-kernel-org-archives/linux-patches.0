Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0F718E35B;
	Mon, 28 Oct 2024 06:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097793; cv=none; b=q+QKTwTxHpTeOkQJb1vOW8tNulh3KdS1wSKasUcfbQkhJ1zfZm/KgLd+ppzCDbL0wsugwL5+3a/kmjmUadjZsoVhtifcEbjB5bMInYwE/k5DVgY/JN21eWuY+H4CqQSPz4jG6uzcDLjqM+jyk5y/AugXn83Mj2xg7exgJyZ65kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097793; c=relaxed/simple;
	bh=i/7HG7mlXVwWn8yUYinDWqlsmdtZTMfddQxtj5LWs1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8vK3LjBZrWa45MMQeLdxXn50zmj5WL36pJpQzb2kQGwVq+K5UNh7iEFX7NJveBE3AOv+uan8RnbXX5pqMxOoZrWQLU8WyxQgRzgcmUARp8tR4KnsHNcWDzbR5xAYGZNEFQdIqPUoo3nes+EGczKZguYe60A7Y8qq9eoVZIV/cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AC/rsdx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AC/rsdx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8576CC4CEC3;
	Mon, 28 Oct 2024 06:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097792;
	bh=i/7HG7mlXVwWn8yUYinDWqlsmdtZTMfddQxtj5LWs1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AC/rsdx/ZZyNBiUVD5RMFwtgjaHxXDpGnVn27hUijH6BWi8qAoYtmpZ4uiaKj8MSJ
	 Qk/aVW5q2qCyleOKF/Jjs20oAz63X63i+xVx6gfJwlxgMQRpYcWOgR90X8nsAuSdRZ
	 6uy2LXcCCMYrGk4EE3oaKEa6yFcoDBxq99bPuX/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/208] bpf: Add MEM_WRITE attribute
Date: Mon, 28 Oct 2024 07:25:30 +0100
Message-ID: <20241028062310.321738812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 6fad274f06f038c29660aa53fbad14241c9fd976 ]

Add a MEM_WRITE attribute for BPF helper functions which can be used in
bpf_func_proto to annotate an argument type in order to let the verifier
know that the helper writes into the memory passed as an argument. In
the past MEM_UNINIT has been (ab)used for this function, but the latter
merely tells the verifier that the passed memory can be uninitialized.

There have been bugs with overloading the latter but aside from that
there are also cases where the passed memory is read + written which
currently cannot be expressed, see also 4b3786a6c539 ("bpf: Zero former
ARG_PTR_TO_{LONG,INT} args in case of error").

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241021152809.33343-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 8ea607330a39 ("bpf: Fix overloading of MEM_UNINIT's meaning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h      | 14 +++++++++++---
 kernel/bpf/helpers.c     | 10 +++++-----
 kernel/bpf/ringbuf.c     |  2 +-
 kernel/bpf/syscall.c     |  2 +-
 kernel/trace/bpf_trace.c |  4 ++--
 net/core/filter.c        |  4 ++--
 6 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1e05cc80e0485..5a27fd533fabc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -616,6 +616,7 @@ enum bpf_type_flag {
 	 */
 	PTR_UNTRUSTED		= BIT(6 + BPF_BASE_TYPE_BITS),
 
+	/* MEM can be uninitialized. */
 	MEM_UNINIT		= BIT(7 + BPF_BASE_TYPE_BITS),
 
 	/* DYNPTR points to memory local to the bpf program. */
@@ -681,6 +682,13 @@ enum bpf_type_flag {
 	 */
 	MEM_ALIGNED		= BIT(17 + BPF_BASE_TYPE_BITS),
 
+	/* MEM is being written to, often combined with MEM_UNINIT. Non-presence
+	 * of MEM_WRITE means that MEM is only being read. MEM_WRITE without the
+	 * MEM_UNINIT means that memory needs to be initialized since it is also
+	 * read.
+	 */
+	MEM_WRITE		= BIT(18 + BPF_BASE_TYPE_BITS),
+
 	__BPF_TYPE_FLAG_MAX,
 	__BPF_TYPE_LAST_FLAG	= __BPF_TYPE_FLAG_MAX - 1,
 };
@@ -738,10 +746,10 @@ enum bpf_arg_type {
 	ARG_PTR_TO_SOCKET_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_SOCKET,
 	ARG_PTR_TO_STACK_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_STACK,
 	ARG_PTR_TO_BTF_ID_OR_NULL	= PTR_MAYBE_NULL | ARG_PTR_TO_BTF_ID,
-	/* pointer to memory does not need to be initialized, helper function must fill
-	 * all bytes or clear them in error case.
+	/* Pointer to memory does not need to be initialized, since helper function
+	 * fills all bytes or clears them in error case.
 	 */
-	ARG_PTR_TO_UNINIT_MEM		= MEM_UNINIT | ARG_PTR_TO_MEM,
+	ARG_PTR_TO_UNINIT_MEM		= MEM_UNINIT | MEM_WRITE | ARG_PTR_TO_MEM,
 	/* Pointer to valid memory of size known at compile time. */
 	ARG_PTR_TO_FIXED_SIZE_MEM	= MEM_FIXED_SIZE | ARG_PTR_TO_MEM,
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 3dba5bb294d8e..41d62405c8521 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -110,7 +110,7 @@ const struct bpf_func_proto bpf_map_pop_elem_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_MAP_VALUE | MEM_UNINIT,
+	.arg2_type	= ARG_PTR_TO_MAP_VALUE | MEM_UNINIT | MEM_WRITE,
 };
 
 BPF_CALL_2(bpf_map_peek_elem, struct bpf_map *, map, void *, value)
@@ -123,7 +123,7 @@ const struct bpf_func_proto bpf_map_peek_elem_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_MAP_VALUE | MEM_UNINIT,
+	.arg2_type	= ARG_PTR_TO_MAP_VALUE | MEM_UNINIT | MEM_WRITE,
 };
 
 BPF_CALL_3(bpf_map_lookup_percpu_elem, struct bpf_map *, map, void *, key, u32, cpu)
@@ -538,7 +538,7 @@ const struct bpf_func_proto bpf_strtol_proto = {
 	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg4_size	= sizeof(s64),
 };
 
@@ -568,7 +568,7 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg4_size	= sizeof(u64),
 };
 
@@ -1607,7 +1607,7 @@ static const struct bpf_func_proto bpf_dynptr_from_mem_proto = {
 	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_LOCAL | MEM_UNINIT,
+	.arg4_type	= ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_LOCAL | MEM_UNINIT | MEM_WRITE,
 };
 
 BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, const struct bpf_dynptr_kern *, src,
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 238d9b206bbde..246559c3e93d0 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -632,7 +632,7 @@ const struct bpf_func_proto bpf_ringbuf_reserve_dynptr_proto = {
 	.arg1_type	= ARG_CONST_MAP_PTR,
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_RINGBUF | MEM_UNINIT,
+	.arg4_type	= ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_RINGBUF | MEM_UNINIT | MEM_WRITE,
 };
 
 BPF_CALL_2(bpf_ringbuf_submit_dynptr, struct bpf_dynptr_kern *, ptr, u64, flags)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b43302c80cac5..8a1cadc1ff9dd 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5689,7 +5689,7 @@ static const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
 	.arg1_type	= ARG_PTR_TO_MEM,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg4_size	= sizeof(u64),
 };
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index bbdc4199748bd..ecc86a595b754 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1220,7 +1220,7 @@ static const struct bpf_func_proto bpf_get_func_arg_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg3_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg3_size	= sizeof(u64),
 };
 
@@ -1237,7 +1237,7 @@ static const struct bpf_func_proto bpf_get_func_ret_proto = {
 	.func		= get_func_ret,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg2_size	= sizeof(u64),
 };
 
diff --git a/net/core/filter.c b/net/core/filter.c
index bbb1432488430..a7d928345b1f4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6310,7 +6310,7 @@ static const struct bpf_func_proto bpf_skb_check_mtu_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_ANYTHING,
-	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg3_size	= sizeof(u32),
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
@@ -6322,7 +6322,7 @@ static const struct bpf_func_proto bpf_xdp_check_mtu_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_ANYTHING,
-	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg3_size	= sizeof(u32),
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
-- 
2.43.0



