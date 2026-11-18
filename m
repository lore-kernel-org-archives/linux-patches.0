Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019431;
	b=uiXultaPdjVW5S5VmycK9jrf23tTeRSuKBJiiVLNRA5Pd2OtF9Xv/vFs5167IgUZ9ctc
	 bgvG+V6DQJ0U/Y3bGKHdwomW1seYgYVOp3lmVE5QXksVY8W7fgLhrq7frDtAqrBeJSOdM
	 yMObBUJ15NmpuELCf1HMiyXBx/N/igKxKafPaWLSg6gTEv4aOIPTBt7wC7u2+qaz960EF
	 5V+B0uyIPMsZ3E6vhkeQkPVD9vqc++agpke/l0NCQjNP6CnWT+nq98ubr6UqugPJAUeXo
	 +eo210aPKccslW+oZn/eSxZxcwhY+oAgfiTpn1TE2hmJTy2IRqCe8XNz6h2lkuN5WGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hBiVUu1NQgaIk17LdxSbl6n0+gRvdlpP62OHjCu+CR8=;
	b=t8X+M2SMKn+g8wqh4Xq0JDoX/lc36XTHcDIfkIc6bhk7cx215ySoUD51anKQ3HWOhDEw
	 e3TjxRywQmhH8tCe1x6AZCI5+yfNtw2Bv/8AQ5fU5qZ3VMd+/ZWKSCiRmMNGhNZr5EEx6
	 sl8mc47gI9DqCp4KHTzP5/dmzXfmNBusJpR9q70B0ZcMbaL/fChCGayeuqMoEkWLnBV/F
	 h17YI3gHdCL4IQafhDIxCG/d03MQh+0BYcEHn9dtoo/o4OpNr8YJ6kFX6FXXiN5AB2+0g
	 AGn+b4mdeHP85PD6gAf0ZKHDKlT3euONqKPuf6MNBIoNJziXgdP/gOn3XpH9AjSyoeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsbDIYbF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C30B60A3836;
	Wed, 18 Nov 2026 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsbDIYbF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FEA1F000D2;
	Wed, 18 Nov 2026 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019430;
	bh=hBiVUu1NQgaIk17LdxSbl6n0+gRvdlpP62OHjCu+CR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsbDIYbFb7vXQ3HAjgEorYEL7YfaqMFx99QpmmhhW9s+qYGE23iXleKRYLXfwKIF1
	 lZioOEcvEiTJ1DjZTAwdz6XEMu2Y06TfEz2U9hO06jEOXaJuAwE4tZJgmxn60se9Jp
	 nF+D8fYQvfmqonwDQA+Lgb15/xA/ysrsj6Jt/oAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wood <thepacketgeek@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1593/2651] bpf, arm64: Fix racy plt target update in bpf_arch_text_poke()
Date: Wed, 18 Nov 2026 15:47:13 +0100
Message-ID: <20261118150345.249654487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c1279fabce473..d393fa6bfbf4d 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -22,7 +22,6 @@
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
 #include <asm/text-patching.h>
-#include <asm/set_memory.h>
 
 #include "bpf_jit.h"
 
@@ -3237,21 +3236,22 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type old_t,
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



