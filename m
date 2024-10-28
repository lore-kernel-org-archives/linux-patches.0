Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E238837;
	Mon, 28 Oct 2024 06:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098294; cv=none; b=j62I0Ypv5LpADt/smF93jbT8SZPciDlcwrChOnt1A0IxqkyZ0GK8vdN4cKc5p9gbK+KL+e8V50bElvBf1P90pTUrPc1ob0/AFVIP5k92qbx1Ly2mTxy6P5GGAPJBtkLl0I32HgWGsdZlVMy3gyUKY+ZO+hMCB7tUz4sWB63FRmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098294; c=relaxed/simple;
	bh=NCNaqjxE8R0AzQBZ/JdEG7jAo12ifSprXNtOKzSnxNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOqpiB6Brykk4fAhWpcmHcpHFgClUYXnVFmRumvEx8pY4Hi4fsChhQgJqbpR2Ekdof/lGSNSF2c4a6DI+2ACqjActJsXJG3kh5vKKZkNUNGCFmoLUDGwwf1T5cz7gXqAUXR1lHVK1gcnk/NUNieU2N35o0Ve68AZGntaHgvi6k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeuTBNlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeuTBNlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B04C4CEC3;
	Mon, 28 Oct 2024 06:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098294;
	bh=NCNaqjxE8R0AzQBZ/JdEG7jAo12ifSprXNtOKzSnxNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeuTBNljhZ/hboSD2cBwADsJ+z5EQo+YHuXQPArNuVYVWYkyHdwxoBFcWavxRlf6/
	 lZk8ekfrI+NiQ6wFutxA1RRMqVy9weBE9oMqXpSfIiomi/TxuCNQ73N5QBEV5b654r
	 6EFx6eZDPNeX8ln3r3YIisxHlJepZ7BSyKe/hP8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 163/261] bpf: Add MEM_WRITE attribute
Date: Mon, 28 Oct 2024 07:25:05 +0100
Message-ID: <20241028062316.087813289@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f3e5ce397b8ef..eb1d3a2fe3339 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -635,6 +635,7 @@ enum bpf_type_flag {
 	 */
 	PTR_UNTRUSTED		= BIT(6 + BPF_BASE_TYPE_BITS),
 
+	/* MEM can be uninitialized. */
 	MEM_UNINIT		= BIT(7 + BPF_BASE_TYPE_BITS),
 
 	/* DYNPTR points to memory local to the bpf program. */
@@ -700,6 +701,13 @@ enum bpf_type_flag {
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
@@ -758,10 +766,10 @@ enum bpf_arg_type {
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
index c9e235807caca..cc8c00864a680 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -111,7 +111,7 @@ const struct bpf_func_proto bpf_map_pop_elem_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_MAP_VALUE | MEM_UNINIT,
+	.arg2_type	= ARG_PTR_TO_MAP_VALUE | MEM_UNINIT | MEM_WRITE,
 };
 
 BPF_CALL_2(bpf_map_peek_elem, struct bpf_map *, map, void *, value)
@@ -124,7 +124,7 @@ const struct bpf_func_proto bpf_map_peek_elem_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
-	.arg2_type	= ARG_PTR_TO_MAP_VALUE | MEM_UNINIT,
+	.arg2_type	= ARG_PTR_TO_MAP_VALUE | MEM_UNINIT | MEM_WRITE,
 };
 
 BPF_CALL_3(bpf_map_lookup_percpu_elem, struct bpf_map *, map, void *, key, u32, cpu)
@@ -539,7 +539,7 @@ const struct bpf_func_proto bpf_strtol_proto = {
 	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg4_size	= sizeof(s64),
 };
 
@@ -569,7 +569,7 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg4_size	= sizeof(u64),
 };
 
@@ -1745,7 +1745,7 @@ static const struct bpf_func_proto bpf_dynptr_from_mem_proto = {
 	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_LOCAL | MEM_UNINIT,
+	.arg4_type	= ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_LOCAL | MEM_UNINIT | MEM_WRITE,
 };
 
 BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, const struct bpf_dynptr_kern *, src,
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index de3b681d1d13d..e1cfe890e0be6 100644
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
index 26e69d4fc3dad..19b590b5aaec9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5973,7 +5973,7 @@ static const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
 	.arg1_type	= ARG_PTR_TO_MEM,
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg3_type	= ARG_ANYTHING,
-	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg4_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg4_size	= sizeof(u64),
 };
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d9bc5ef1cafc3..50c0b1088a9eb 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1226,7 +1226,7 @@ static const struct bpf_func_proto bpf_get_func_arg_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg3_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg3_size	= sizeof(u64),
 };
 
@@ -1243,7 +1243,7 @@ static const struct bpf_func_proto bpf_get_func_ret_proto = {
 	.func		= get_func_ret,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg2_size	= sizeof(u64),
 };
 
diff --git a/net/core/filter.c b/net/core/filter.c
index b7a5f525e65b8..ddcf35e91a5e4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6350,7 +6350,7 @@ static const struct bpf_func_proto bpf_skb_check_mtu_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_ANYTHING,
-	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_ALIGNED,
+	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
 	.arg3_size	= sizeof(u32),
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
@@ -6362,7 +6362,7 @@ static const struct bpf_func_proto bpf_xdp_check_mtu_proto = {
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



