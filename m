Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EE33EFD3D;
	Wed, 20 May 2026 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298749; cv=none; b=il4zO9VBv1o0Cs2PUbEg/SeuwuNrZkWLv4fQN+pusV1ZEDgUJOt4sMZJNvTSPpnv7PUbhN2UZFI1+px0Pt+xrPp/fEkUiHCR0ys2fSae6BcHRBqfTZIEWctwFapxLsHybApj/tih3X7q1T8Sq5q4kUAMnzPmJ4blf2fuAYJR2z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298749; c=relaxed/simple;
	bh=i9zJJO2QEfcjWPp3pQDTSSN3XevfkfQHhJ9MKcj0csU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n693tomHML0iUv6oMgOX++0PqeVibLCy51Gb+H3A7t43qVQ7/4ZrGRTmY/Wv+SI84/Hu+DLjkygV7xWt+cPVVSrKHlQOi3mMjbXGc/4aRr3/4GPyQ97fx7SkRoBAUYwMDghwm3QOLpgPpi2EJMawp1k1zE13Us6rXwT/1fXwK4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqdnLvr/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqdnLvr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CB21F000E9;
	Wed, 20 May 2026 17:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298748;
	bh=DtruqdUzD1suM7NPLxU5ZeKZhFpkrkP/nAgekRby2LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqdnLvr/5FqieoyE5caHbM1mmKIXla54NSkoJd1SAg2jRkqXLbMuDDpUx3HIOLqwg
	 CQBjXDv7WCUzK85Z+TVyyAMRiAQwiKlgel6jNAKNGn7gWSbDBNbVH3AU9BuS5Ay2r6
	 CCOp9H6B5o+NqG9Upx8uYVYqpt/6iuvK8zyOEMnU=
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
Subject: [PATCH 6.18 487/957] bpf, riscv: Remove redundant bpf_flush_icache() after pack allocator finalize
Date: Wed, 20 May 2026 18:16:10 +0200
Message-ID: <20260520162145.086323147@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 632ced07bca44..da02717902442 100644
--- a/arch/riscv/net/bpf_jit.h
+++ b/arch/riscv/net/bpf_jit.h
@@ -11,7 +11,6 @@
 
 #include <linux/bpf.h>
 #include <linux/filter.h>
-#include <asm/cacheflush.h>
 
 /* verify runtime detection extension status */
 #define rv_ext_enabled(ext) \
@@ -105,11 +104,6 @@ static inline void bpf_fill_ill_insns(void *area, unsigned int size)
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
index f6ca5cfa6b2fd..191bf0e66c824 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -183,13 +183,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
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



