Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0982141DE08;
	Sat, 12 Sep 2026 08:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202425; cv=none; b=jhTIMnL9JJdem9TPdqcI51gROHDJyNSfasOcz980eC/jP34E8c5AWLa9fXoSM3ont4rIb8a3HDK0LHRaUzbBl9B+38lm/eHTuPKL+SygHljYU7zTY+qnc7TPsACNAb9sKh6PZ2Lm7wIGJIZg0QZCni+GOgcSHoNkT7oLRd0B+dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202425; c=relaxed/simple;
	bh=PxaxQ3sEzdEB0TZD1FhmKnDXD+3PlLXIKoJSYgT/JSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbbPfwe5tf+gn6Lqm2IcPDNFhF7WztSGhH+caUKZk1Pw6azrIIs6R5ZVDDB2mRD1aD/oKRfFVuMZJHiNjnz8RGRD1vrxU+pqXwCppK4cW+ZdrWn9XQGsr/87aNbnJ/TlO6FhdvfcfhjI8N1C/KdPlW1D0ua+OaVRE7nw+iP6Yi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+oApqeA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+oApqeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5721F000FF;
	Sat, 12 Sep 2026 08:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202423;
	bh=Iguaa8k5ibcrPERRjmbXngmgCujsU8RvJi/JHLzy8G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+oApqeALqmrvGtyeUIq+5ZZegWU9aMHThymXawjA/SDiyTi1QzHPnSVW22k6OkcQ
	 7m7qqq0yea6s4wGMZ+twmBlr/5tTYw+h1uO3BNCRA1QggTuVgbybrWC8vEhJFCLddt
	 Kh0BDTB4VvYIqaIsUHnbxYrSCoKmUiMxLzx0xOsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1201/1815] bpf: Reject load-acquire from pointers requiring fault protection
Date: Sat, 12 Sep 2026 08:49:11 +0200
Message-ID: <20260912065717.203386551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 7db0a00445f1a40bacfe9b747405c11cb5f10fc9 ]

A BPF_LOAD_ACQ is not rewritten to a BPF_PROBE_MEM load by the verifier,
unlike a regular BPF_LDX, so the JIT emits a plain load with no exception
table entry and a fault panics the kernel instead of being handled.

Reject the source pointer types that a BPF_LDX would have had that fault
protection applied to, i.e. the ones bpf_convert_ctx_accesses() turns
into BPF_PROBE_MEM: a bare PTR_TO_BTF_ID, PTR_TO_BTF_ID | PTR_UNTRUSTED,
PTR_TO_BTF_ID | MEM_ALLOC | PTR_UNTRUSTED and PTR_TO_MEM | MEM_RDONLY |
PTR_UNTRUSTED.

This is reachable e.g. by loading ->mm out of a trusted task_struct
yields an untrusted pointer to mm_struct, and it is NULL for a kernel
thread:

  [...]
  SEC("tp_btf/sched_switch")
  int BPF_PROG(demo, bool preempt, struct task_struct *prev,
               struct task_struct *next)
  {
      struct mm_struct *mm = next->mm;  /* untrusted */

      out_ldx = (__u64)mm->pgd;         /* BPF_LDX      */
      out_acq = load_acquire(&mm->pgd); /* BPF_LOAD_ACQ */
      return 0;
  }
  [...]

Both dereference the same pointer, but only the BPF_LDX is protected
(x86-64 JIT, jump targets shown prog-relative):

  [...]
  ; out_ldx = (__u64)mm->pgd;
  17:   movq    $-10485760, %r10
  1e:   movq    %rsi, %r11
  21:   addq    $184, %r11
  28:   subq    %r10, %r11
  2b:   movabsq $140737498841088, %r10
  35:   cmpq    %r10, %r11
  38:   ja      0x3e                 <-- kernel addr?
  3a:   xorl    %edi, %edi           <-- no: dst = 0, skip the load
  3c:   jmp     0x45
  3e:   movq    184(%rsi), %rdi      <-- yes: load + extable entry
  [...]
  ; load_acquire(&mm->pgd)
  53:	movq    %rsi, %rdi
  56:	movq    184(%rdi), %rax       <-- no check, no extable entry
  [...]

Note that BPF_PROBE_MEM is not visible in a bpftool xlated dump, as
bpf_insn_prepare_dump() rewrites it back to BPF_MEM.

A PTR_TRUSTED pointer is deliberately not on the list. Such a load is
not converted either, but it does not need to be, since the pointer is
guaranteed live, so load-acquire from it stays allowed.

The check is gated on BPF_LOAD_ACQ so that atomic RMW and store-release
error messages are unchanged; writes (RMW / store-release) to such
pointers are already rejected elsewhere, so only load-acquire needs this.

Fixes: 880442305a39 ("bpf: Introduce load-acquire and store-release instructions")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260806201047.333389-1-daniel@iogearbox.net
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 85cae5684f59b..e9225a66ae72f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4843,6 +4843,30 @@ static bool is_arena_reg(struct bpf_verifier_env *env, int regno)
 	return reg->type == PTR_TO_ARENA;
 }
 
+static bool is_load_acq_unsafe(struct bpf_verifier_env *env, int regno,
+			       struct bpf_insn *insn)
+{
+	const struct bpf_reg_state *reg = reg_state(env, regno);
+
+	/*
+	 * A BPF_LOAD_ACQ is not rewritten to a BPF_PROBE_MEM load by the
+	 * verifier, unlike a regular BPF_LDX. The JIT would emit a plain load
+	 * with no exception table entry, so a fault (e.g. NULL deref) crashes
+	 * the kernel instead of being handled.
+	 *
+	 * Reject the source pointer types that a BPF_LDX would have had that
+	 * fault protection applied to, i.e. the ones bpf_convert_ctx_accesses()
+	 * turns into BPF_PROBE_MEM: a bare PTR_TO_BTF_ID and any PTR_UNTRUSTED
+	 * pointer (untrusted btf ids, untrusted MEM_ALLOC, rdonly untrusted
+	 * memory). A PTR_TRUSTED pointer is not among them, is not converted,
+	 * and stays allowed. Same for the other flagged PTR_TO_BTF_ID variants
+	 * (MEM_ALLOC, MEM_RCU, ...), hence the exact match on the base type.
+	 */
+	return insn->imm == BPF_LOAD_ACQ &&
+	       (reg->type == PTR_TO_BTF_ID ||
+		(type_flag(reg->type) & PTR_UNTRUSTED));
+}
+
 /* Return false if @regno contains a pointer whose type isn't supported for
  * atomic instruction @insn.
  */
@@ -4859,7 +4883,8 @@ static bool atomic_ptr_type_ok(struct bpf_verifier_env *env, int regno,
 		return false;
 	if (is_arena_reg(env, regno))
 		return bpf_jit_supports_insn(insn, true);
-
+	if (is_load_acq_unsafe(env, regno, insn))
+		return false;
 	return true;
 }
 
-- 
2.53.0



