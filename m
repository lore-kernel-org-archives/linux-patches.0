Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDBC3FE345;
	Wed, 20 May 2026 18:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302358; cv=none; b=AAcc27ZhucmD/rqDU/gxFq+6m2YcKmLMLAx9oUuFBH5qjBrryt+Y1N8qxuuf7JlwMOIGOeLHsCvcSLwhM7jb7nr727CKAo0u/bfb4POTCMRP/44uR+PKsibEGVrki1Op2CDfbbk3V+ykFLMfluHmB0f/NDC923y7hNDt5lqOMc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302358; c=relaxed/simple;
	bh=zegP+j/Fz3MW8P0DyLeWA67rHXrN8gzuuSCg46dgtVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUKPaCg3VScFiKLwqEwSmZhannZuydAs3SUOHEJ0Ek5cJ9EAzgclsz41t0R2+Hur3gfMR++TO7ITodV03b6lxEBOxGtbBukHEl9eJVheTAL8QHIWJ2sRJIjeyaAsrNN+AlOo1eMhDUH0ghsm3CHcAXldqJb6MfS0cCsjjQwClVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B34VJ6GR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B34VJ6GR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186A81F000E9;
	Wed, 20 May 2026 18:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302356;
	bh=vVnXyuFqR9roJkfNJGBF+xjZ7QzhGmo1IMZnodvmRpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B34VJ6GRuXmSKRA5saqJPD4UJ0X2APTgStdNre4LgsH811tE6Xlz81YGRz+2e35LH
	 PgtmPCrJMVFcpNmHZ4sVgLkAlLF7ZKtK8wuTVSsWEGIiazhSKZy+u1SIJGWlFvvqBy
	 nn3CJsX5YPUntJR7qWHuMXp61mdvEWIahAShKJgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/508] bpf, riscv: Remove redundant bpf_flush_icache() after pack allocator finalize
Date: Wed, 20 May 2026 18:20:59 +0200
Message-ID: <20260520162103.763789990@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 46ee1342b887c9387a933397d846ff6c9584322c ]

bpf_flush_icache() calls flush_icache_range() to clean the data cache
and invalidate the instruction cache for the JITed code region. However,
since commit 48a8f78c50bd ("bpf, riscv: use prog pack allocator in the
BPF JIT"), this flush is redundant.

bpf_jit_binary_pack_finalize() copies the JITed instructions to the ROX
region via bpf_arch_text_copy() -> patch_text_nosync(), and
patch_text_nosync() already calls flush_icache_range() on the written
range. The subsequent bpf_flush_icache() repeats the same cache
maintenance on an overlapping range.

Remove the redundant bpf_flush_icache() call and its now-unused
definition.

Fixes: 48a8f78c50bd ("bpf, riscv: use prog pack allocator in the BPF JIT")
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Tested-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/20260413191111.3426023-3-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit.h      | 6 ------
 arch/riscv/net/bpf_jit_core.c | 7 -------
 2 files changed, 13 deletions(-)

diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
index a5ce1ab76ecee..c444c79596703 100644
--- a/arch/riscv/net/bpf_jit.h
+++ b/arch/riscv/net/bpf_jit.h
@@ -11,7 +11,6 @@
 
 #include <linux/bpf.h>
 #include <linux/filter.h>
-#include <asm/cacheflush.h>
 
 static inline bool rvc_enabled(void)
 {
@@ -97,11 +96,6 @@ static inline void bpf_fill_ill_insns(void *area, unsigned int size)
 	memset(area, 0, size);
 }
 
-static inline void bpf_flush_icache(void *start, void *end)
-{
-	flush_icache_range((unsigned long)start, (unsigned long)end);
-}
-
 /* Emit a 4-byte riscv instruction. */
 static inline void emit(const u32 insn, struct rv_jit_context *ctx)
 {
diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index 7b70ccb7fec34..f57b95e830ac0 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -182,13 +182,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			prog = orig_prog;
 			goto out_offset;
 		}
-		/*
-		 * The instructions have now been copied to the ROX region from
-		 * where they will execute.
-		 * Write any modified data cache blocks out to memory and
-		 * invalidate the corresponding blocks in the instruction cache.
-		 */
-		bpf_flush_icache(jit_data->ro_header, ctx->ro_insns + ctx->ninsns);
 		for (i = 0; i < prog->len; i++)
 			ctx->offset[i] = ninsns_rvoff(ctx->offset[i]);
 		bpf_prog_fill_jited_linfo(prog, ctx->offset);
-- 
2.53.0



