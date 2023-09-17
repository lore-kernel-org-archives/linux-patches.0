Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E007A6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1C1C433C9;
	Sun, 17 Sep 2023 19:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980607;
	bh=wx5P+by7N+/En+1xVhcxiRHQSohnf5cH5ke8Z6CJLdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSMZdpXbr06bjRfH1TWDly8AYfMFxrarcwDD/NUM8iSfc+J/qSSZep1BDrZXgUpuK
	 abRF+UBM4xgkp0YdFoKMOPvajAVIuyPIHw7DIHSAf7Qlete6U5PkCGKYfuWBcMX2FQ
	 f6OS0O43BMsXA70bkOpfH3MHIxO4+m5WE+Fx22fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 242/285] bpf: fix bpf_probe_read_kernel prototype mismatch
Date: Sun, 17 Sep 2023 21:14:02 +0200
Message-ID: <20230917191059.741532041@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6a5a148aaf14747570cc634f9cdfcb0393f5617f ]

bpf_probe_read_kernel() has a __weak definition in core.c and another
definition with an incompatible prototype in kernel/trace/bpf_trace.c,
when CONFIG_BPF_EVENTS is enabled.

Since the two are incompatible, there cannot be a shared declaration in
a header file, but the lack of a prototype causes a W=1 warning:

kernel/bpf/core.c:1638:12: error: no previous prototype for 'bpf_probe_read_kernel' [-Werror=missing-prototypes]

On 32-bit architectures, the local prototype

u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)

passes arguments in other registers as the one in bpf_trace.c

BPF_CALL_3(bpf_probe_read_kernel, void *, dst, u32, size,
            const void *, unsafe_ptr)

which uses 64-bit arguments in pairs of registers.

As both versions of the function are fairly simple and only really
differ in one line, just move them into a header file as an inline
function that does not add any overhead for the bpf_trace.c callers
and actually avoids a function call for the other one.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/ac25cb0f-b804-1649-3afb-1dc6138c2716@iogearbox.net/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20230801111449.185301-1-arnd@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h      | 12 ++++++++++++
 kernel/bpf/core.c        | 10 ++--------
 kernel/trace/bpf_trace.c | 11 -----------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f58895830adae..f316affcd2e13 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2619,6 +2619,18 @@ static inline void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
 }
 #endif /* CONFIG_BPF_SYSCALL */
 
+static __always_inline int
+bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr)
+{
+	int ret = -EFAULT;
+
+	if (IS_ENABLED(CONFIG_BPF_EVENTS))
+		ret = copy_from_kernel_nofault(dst, unsafe_ptr, size);
+	if (unlikely(ret < 0))
+		memset(dst, 0, size);
+	return ret;
+}
+
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
 			  struct btf_mod_pair *used_btfs, u32 len);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index dc85240a01342..e3e45b651cd40 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1635,12 +1635,6 @@ bool bpf_opcode_in_insntable(u8 code)
 }
 
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
-u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
-{
-	memset(dst, 0, size);
-	return -EFAULT;
-}
-
 /**
  *	___bpf_prog_run - run eBPF program on a given context
  *	@regs: is the array of MAX_BPF_EXT_REG eBPF pseudo-registers
@@ -1931,8 +1925,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 		DST = *(SIZE *)(unsigned long) (SRC + insn->off);	\
 		CONT;							\
 	LDX_PROBE_MEM_##SIZEOP:						\
-		bpf_probe_read_kernel(&DST, sizeof(SIZE),		\
-				      (const void *)(long) (SRC + insn->off));	\
+		bpf_probe_read_kernel_common(&DST, sizeof(SIZE),	\
+			      (const void *)(long) (SRC + insn->off));	\
 		DST = *((SIZE *)&DST);					\
 		CONT;
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 30d8db47c1e2f..abf287b2678a1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -223,17 +223,6 @@ const struct bpf_func_proto bpf_probe_read_user_str_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
-static __always_inline int
-bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr)
-{
-	int ret;
-
-	ret = copy_from_kernel_nofault(dst, unsafe_ptr, size);
-	if (unlikely(ret < 0))
-		memset(dst, 0, size);
-	return ret;
-}
-
 BPF_CALL_3(bpf_probe_read_kernel, void *, dst, u32, size,
 	   const void *, unsafe_ptr)
 {
-- 
2.40.1



