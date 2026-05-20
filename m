Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBD03FE66D;
	Wed, 20 May 2026 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302379; cv=none; b=Eom09Rw5OuVugm3QygBNBcRZsFzt+TglAUOhAIE6I4F1PazdphHsvjJXRMhPCsnoja02JQxHpbeyuZtTYadocXl8qId1bJw7Y+arpmHlr8Q9w8RaW8ZDlj3O163loH72Uhj/cINe0mUDblsmYDNHZUnSgf4inLmQHVsvZitezgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302379; c=relaxed/simple;
	bh=VUfWHrdTgXgZSuVQhsy4qcECgNDnUHIcADBVLc0CEE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apHZhP5hI6cW2T9nD1To6qWWUmwPY5/7+TI3QPsLBp5Cup61nojSbF3JJDmhP7FM39jzEVem3QLvV8z9VsPXJlM91FZsBK0jPwSVju70C3AE++h0a8uWeQKWInoUkAQ4F6M1WayQAiBUlskLDGjXBw8s5DW41SQGrc3CS4Mgx1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00JZftqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00JZftqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644B31F000E9;
	Wed, 20 May 2026 18:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302377;
	bh=rKns3p3/rjECN+49IbGEvbvz5j21W20aT2YyG9O3gck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00JZftqfgghjooHIeN9DjfgM1z/DGQOzOXmDKy/E5gegwx1TdYgA0V2sFJ0VWxMfe
	 Ls8hUsVMvrbedjXQUTYPN/WlrIQTd2MReXh4gJcQmcWBq8Jw8zJdpJbjzAqj5dO00D
	 WjPysZpt2F9LjZsRFO+ek1VJ+HrYLG+UrqKNazW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jonas Rebmann <jre@pengutronix.de>,
	Puranjay Mohan <puranjay@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/508] bpf, arm32: Reject BPF-to-BPF calls and callbacks in the JIT
Date: Wed, 20 May 2026 18:21:06 +0200
Message-ID: <20260520162103.918004769@linuxfoundation.org>
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

[ Upstream commit e1d486445af3c392628532229f7ce5f5cf7891b6 ]

The ARM32 BPF JIT does not support BPF-to-BPF function calls
(BPF_PSEUDO_CALL) or callbacks (BPF_PSEUDO_FUNC), but it does
not reject them either.

When a program with subprograms is loaded (e.g. libxdp's XDP
dispatcher uses __noinline__ subprograms, or any program using
callbacks like bpf_loop or bpf_for_each_map_elem), the verifier
invokes bpf_jit_subprogs() which calls bpf_int_jit_compile()
for each subprogram.

For BPF_PSEUDO_CALL, since ARM32 does not reject it, the JIT
silently emits code using the wrong address computation:

    func = __bpf_call_base + imm

where imm is a pc-relative subprogram offset, producing a bogus
function pointer.

For BPF_PSEUDO_FUNC, the ldimm64 handler ignores src_reg and
loads the immediate as a normal 64-bit value without error.

In both cases, build_body() reports success and a JIT image is
allocated. ARM32 lacks the jit_data/extra_pass mechanism needed
for the second JIT pass in bpf_jit_subprogs(). On the second
pass, bpf_int_jit_compile() performs a full fresh compilation,
allocating a new JIT binary and overwriting prog->bpf_func. The
first allocation is never freed. bpf_jit_subprogs() then detects
the function pointer changed and aborts with -ENOTSUPP, but the
original JIT binary has already been leaked. Each program
load/unload cycle leaks one JIT binary allocation, as reported
by kmemleak:

    unreferenced object 0xbf0a1000 (size 4096):
      backtrace:
        bpf_jit_binary_alloc+0x64/0xfc
        bpf_int_jit_compile+0x14c/0x348
        bpf_jit_subprogs+0x4fc/0xa60

Fix this by rejecting both BPF_PSEUDO_CALL in the BPF_CALL
handler and BPF_PSEUDO_FUNC in the BPF_LD_IMM64 handler, falling
through to the existing 'notyet' path. This causes build_body()
to fail before any JIT binary is allocated, so
bpf_int_jit_compile() returns the original program unjitted.
bpf_jit_subprogs() then sees !prog->jited and cleanly falls
back to the interpreter with no leak.

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Fixes: 1c2a088a6626 ("bpf: x64: add JIT support for multi-function programs")
Reported-by: Jonas Rebmann <jre@pengutronix.de>
Closes: https://lore.kernel.org/bpf/b63e9174-7a3d-4e22-8294-16df07a4af89@pengutronix.de
Tested-by: Jonas Rebmann <jre@pengutronix.de>
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/r/20260417143353.838911-1-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/net/bpf_jit_32.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 6a1c9fca5260b..2292245cfe7a9 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1594,6 +1594,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 	{
 		u64 val = (u32)imm | (u64)insn[1].imm << 32;
 
+		if (insn->src_reg == BPF_PSEUDO_FUNC)
+			goto notyet;
+
 		emit_a32_mov_i64(dst, val, ctx);
 
 		return 1;
@@ -1785,6 +1788,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		const s8 *r5 = bpf2a32[BPF_REG_5];
 		const u32 func = (u32)__bpf_call_base + (u32)imm;
 
+		if (insn->src_reg == BPF_PSEUDO_CALL)
+			goto notyet;
+
 		emit_a32_mov_r64(true, r0, r1, ctx);
 		emit_a32_mov_r64(true, r1, r2, ctx);
 		emit_push_r64(r5, ctx);
-- 
2.53.0



