Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0D93ED136;
	Wed, 20 May 2026 17:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298733; cv=none; b=n2HMwS9JVQH+cQH43USh9pglCGJM/s7NcgoZshzaxGZgkSB9C8C3dUGasDmOyP5S+g0TdCPWB1dStr5/MYn079p2ihZXcvyCZOdT2iVxaEbRaAkC/O1kQu3qOebbCSa2Q+5h5cy1wBP8/bCF+8dAz7o0NEe+4NRdnwlYmZWIGgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298733; c=relaxed/simple;
	bh=nhRxLOWFakYqaf6V3OSdD8wck2YlYyvnOLjfH2zk1vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOvj+FRpf4soj1tZufeWgPfrtWJi/yvA1NWF0KgsMjDiQI/dJgk3uMQsadjlwwGwMWmQXjKX8hnjxHScqln9yLbjMRNTx5UAtofKRkDEpgBUwPBai2EWLAVaYi1XqK+nb455crBewssGdqlfADIjYlEW/oTju95jXWQaVj3eXjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGkxAW9u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGkxAW9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0BA1F000E9;
	Wed, 20 May 2026 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298732;
	bh=Tmd/M+dn2yo1RMcYSgsBJ7TwlRwBelttvNDybcmlVo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGkxAW9utdJ9kIEcSv6hfoXmKTgIe60yituFBXBFpr0rybIPnDd/I3YVhG6M7KcG+
	 HpMeAZVQ0jYOwVXwgwHyvi64leTwvv3qAmnoommrGtXp/UznhXNM9Ota40VMq2CO5D
	 kL17NuFvMoGyoLJzjo5iW6QB5Gy5kmIU2zKWfNsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 486/957] bpf, arm64: Remove redundant bpf_flush_icache() after pack allocator finalize
Date: Wed, 20 May 2026 18:16:09 +0200
Message-ID: <20260520162145.064310688@linuxfoundation.org>
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

[ Upstream commit 42f18ae53011826cfd3c84d041817e7f07bc645b ]

bpf_flush_icache() calls flush_icache_range() to clean the data cache
and invalidate the instruction cache for the JITed code region. However,
since commit 1dad391daef1 ("bpf, arm64: use bpf_prog_pack for memory
management"), this flush is redundant.

bpf_jit_binary_pack_finalize() copies the JITed instructions to the ROX
region via bpf_arch_text_copy() -> aarch64_insn_copy() -> __text_poke(),
and __text_poke() already calls flush_icache_range() on the written
range. The subsequent bpf_flush_icache() repeats the same cache
maintenance on an overlapping range, including an unnecessary second
synchronous IPI to all CPUs via kick_all_cpus_sync().

Remove the redundant bpf_flush_icache() call and its now-unused
definition.

Fixes: 1dad391daef1 ("bpf, arm64: use bpf_prog_pack for memory management")
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20260413191111.3426023-2-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 4b2aacdd43221..873c1b784a872 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -18,7 +18,6 @@
 
 #include <asm/asm-extable.h>
 #include <asm/byteorder.h>
-#include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
@@ -1964,11 +1963,6 @@ static int validate_ctx(struct jit_ctx *ctx)
 	return 0;
 }
 
-static inline void bpf_flush_icache(void *start, void *end)
-{
-	flush_icache_range((unsigned long)start, (unsigned long)end);
-}
-
 static void priv_stack_init_guard(void __percpu *priv_stack_ptr, int alloc_size)
 {
 	int cpu, underflow_idx = (alloc_size - PRIV_STACK_GUARD_SZ) >> 3;
@@ -2207,12 +2201,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			prog = orig_prog;
 			goto out_off;
 		}
-		/*
-		 * The instructions have now been copied to the ROX region from
-		 * where they will execute. Now the data cache has to be cleaned to
-		 * the PoU and the I-cache has to be invalidated for the VAs.
-		 */
-		bpf_flush_icache(ro_header, ctx.ro_image + ctx.idx);
 	} else {
 		jit_data->ctx = ctx;
 		jit_data->ro_image = ro_image_ptr;
-- 
2.53.0



