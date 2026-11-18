Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026110;
	b=FcVGBx4ZVSHni6pGJZNva54iT1LpHhFs+tK7YBi6iqc/ja+j/rjWpPl7ltYamtaMSUAt
	 8ibxB544NNmjGj6Fhtvrp58nyYJatyKB7BhY38631RKY0kh4LjFh9AC33/KjOiLCz4cGG
	 qYm8UAwS6J5mxUnptZHbGpAVfhRmjQMNlpdiG1gAk0axuG2S4Sy6/LoAh/XmeG2/RSNcx
	 nf/1EaWftsnCvylChMgMAsRPjI9kkwhbl0p7SysyKYdB39ggqhrhJyFVpa3UNcrF24h1p
	 vgwHzLJahi/c5tTm/EvYaW1qGjurdnZMJpNnNCIfCBEskBtorl0TyA12i56xAmV9YuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3fsGICjscuiXWqPNMeihNc4vMq/uofGFfaODQ1s9CEI=;
	b=y95eAY8nXUo6tNTo4yd9iqtUNEx9DP8SnVItgmtCnJr68vTeER55NJsqNVzxBb+8rCXZ
	 aUivBbbzlXp/ogavxDg0/vUAkuemFaLfutKNtG/Pfbut/tl9ussJUtsob5nCxEj5JQL0+
	 qwdpx2ni7KKCrkvt7G5fEYS0yL7k9xHQJAb/UVHk6qDVXwBnUkWuCbJ38lXRauJfdRXs6
	 2K1m8TezobTxWito1dvefVGBMViLJqqwNlbaP+CJepAmKkwR9bj1jFWP9qu8ycS9k2E8/
	 ofeqg6A9mvgKTqCxPCElywHEXqqzr8yJVdUjkxHuJtnEc8/2s+mrQ5NlwAgiXF3cc0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvKc6DAE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2AC606A32F;
	Wed, 18 Nov 2026 18:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvKc6DAE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA541F000C6;
	Wed, 18 Nov 2026 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026110;
	bh=3fsGICjscuiXWqPNMeihNc4vMq/uofGFfaODQ1s9CEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvKc6DAEFyE1kSXJn46tE4/sEZWCQlx2FEXZ2c13se1L8yh/0RSn2EMlWqNT4h1wM
	 vr6eZsYvvpkRYmi6FRr4pbBAxLIDheT2d9krEr6oHilycjiw7uyihne8z7sv62QAsS
	 zX2hnW048lQN7sim3uEV6B0qQv+GRIxXsf198MVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wood <thepacketgeek@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1317/2151] bpf, arm64: Fix racy plt target update in bpf_arch_text_poke()
Date: Wed, 18 Nov 2026 15:50:52 +0100
Message-ID: <20261118150210.067134497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Matthew Wood <thepacketgeek@gmail.com>

[ Upstream commit 6335e6719fd323c345427b7cf2d5d17c28fdbc41 ]

When a long-jump trampoline is attached to or detached from a bpf prog,
bpf_arch_text_poke() updates the plt target at the end of the prog by
temporarily making the page writable:

	set_memory_rw(page);
	WRITE_ONCE(plt->target, plt_target);
	set_memory_ro(page);

Since commit 1dad391daef1 ("bpf, arm64: use bpf_prog_pack for memory
management"), bpf progs are allocated from the bpf prog pack, so
unrelated progs and their plts commonly share a page. The sequence
above is not serialized against other pokers, it runs before text_mutex
is taken and callers only hold the lock of the trampoline being
updated. Two CPUs attaching to or detaching from different target progs
in the same page can therefore race:

	CPU A                           CPU B
	set_memory_rw(page)
	                                set_memory_rw(page)
	                                WRITE_ONCE(plt_B->target, ...)
	                                set_memory_ro(page)
	WRITE_ONCE(plt_A->target, ...)  <- permission fault

This was hit on an arm64 server with 64K pages while attaching fentry
programs to bpf progs:

  Unable to handle kernel write to read-only memory at virtual address ffff80008f46d5f8
  ESR = 0x000000009600004f
  FSC = 0x0f: level 3 permission fault
  pte=00c00200ea5a0783
  Internal error: Oops: 000000009600004f [#1]  SMP
  pc : bpf_arch_text_poke+0x214/0x238
  lr : bpf_arch_text_poke+0x200/0x238
  Call trace:
   bpf_arch_text_poke+0x214/0x238 (P)
   __bpf_trampoline_link_prog+0x1c8/0x470
   bpf_trampoline_link_prog+0x64/0x90
   bpf_tracing_prog_attach+0x318/0x4a8
   bpf_raw_tp_link_attach+0x104/0x258
   bpf_raw_tracepoint_open+0x6c/0x90
   __sys_bpf+0x134c/0x3e10

Rather than serializing the permission changes, stop changing page
permissions altogether and write the plt target with
aarch64_insn_write_literal_u64(). It writes through the text patching
fixmap under patch_lock, the same way the rest of the prog pack is
written, and performs a single-copy atomic 64-bit store. The plt target
is naturally aligned (see build_plt()), so CPUs concurrently executing
the plt still observe either the old or the new target. This is the
same helper ftrace and static calls use to update 64-bit literals that
are loaded concurrently.

Fixes: 1dad391daef1 ("bpf, arm64: use bpf_prog_pack for memory management")
Signed-off-by: Matthew Wood <thepacketgeek@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261009173802.1248441-1-thepacketgeek@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 10b9079c1212f..f2ed5e511acb9 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -22,7 +22,6 @@
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
 #include <asm/text-patching.h>
-#include <asm/set_memory.h>
 
 #include "bpf_jit.h"
 
@@ -2991,21 +2990,22 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
 		 */
 		plt_target = (u64)&dummy_tramp;
 
-	if (plt_target) {
-		/* non-zero plt_target indicates we're patching a bpf prog,
-		 * which is read only.
-		 */
-		if (set_memory_rw(PAGE_MASK & ((uintptr_t)&plt->target), 1))
-			return -EFAULT;
-		WRITE_ONCE(plt->target, plt_target);
-		set_memory_ro(PAGE_MASK & ((uintptr_t)&plt->target), 1);
-		/* since plt target points to either the new trampoline
-		 * or dummy_tramp, even if another CPU reads the old plt
-		 * target value before fetching the bl instruction to plt,
-		 * it will be brought back by dummy_tramp, so no barrier is
-		 * required here.
-		 */
-	}
+	/*
+	 * non-zero plt_target indicates we're patching a bpf prog,
+	 * which is read only. The prog may share its page in the bpf
+	 * prog pack with other progs, so write the aligned target
+	 * through the text patching fixmap without flipping the
+	 * page permissions to avoid racing with concurrent pokers.
+	 *
+	 * since plt target points to either the new trampoline
+	 * or dummy_tramp, even if another CPU reads the old plt
+	 * target value before fetching the bl instruction to plt,
+	 * it will be brought back by dummy_tramp, so no barrier is
+	 * required here.
+	 */
+	if (plt_target &&
+	    aarch64_insn_write_literal_u64(&plt->target, plt_target))
+		return -EFAULT;
 
 	/* if the old target and the new target are both long jumps, no
 	 * patching is required
-- 
2.53.0



