Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017250;
	b=VSGiXzXOPJb3fYbUzlV0EmswYT9MuWUMXsQMjGJgEEl6n0gej/WslJnp7lPzFKD5/h9Z
	 bDyLtBW2MytjMGUYQDFX0zCg46+imSoAmmn28VwVI6hPk8aJlH2RqQKtg9YNmhPFGQyi+
	 M0o2O5SCXsIq/q/Spyqevec2zo5FRJ4vhMKeZE/xy7f2y50C1LBVBZzYCOI+YHZ+/S/Ks
	 QYABUAjY+xGrVK82PFuCcINAA203wPaEZNrpIAAeuP9mswN7YfAoGfM6pl7IFNUEtVC0x
	 sBJpmtbk82oOm348E3k2KZaB/XQeMUwo0Y9Q0YGZdgzczwXIfa9pVwqp+KhaxxUmhiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QNfc9RGDkIWAMMuJssqsCkI76GypYFdGjos3zmcY6tk=;
	b=CMUsejx2usSBPvspxQ+FLgRo+em22fPvbyqN4yWDk1pSpOalwLXu1c5AhElXbWzjRRwp
	 UljWuQAPRr9t5/dmXYLhjXdrz7TNtbF18WBmOBmfjNBcsvr+yVYr7au5XuDQzG1qvMGqe
	 Gn6wuqI6aWYgnaJEkDXKh6PXZmeXvfZaIjyENQAUwd654Q9c9JHNQDieP4CdPx2fdY9sn
	 O+vDuh+Ha0FOtix95k57rcW18Vbnxb86HSMITbA9wClkm/fplqlHk6BDkfU1WxVtknxu6
	 cWncO8nzN2Q20vrC+SSKRiaz5Ghsu8zxAeultBPTLjw6SKraLv3MP3R04GqQtWTYH4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cn3Mu08Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BDE606A325;
	Wed, 18 Nov 2026 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cn3Mu08Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4639C1F000C5;
	Wed, 18 Nov 2026 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017249;
	bh=QNfc9RGDkIWAMMuJssqsCkI76GypYFdGjos3zmcY6tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cn3Mu08Y7e3XDHUqQKggSm3Y5kVOZLFAvw5Vqu22XLWSB+gFXcpSJJQQejwWeIFhB
	 NkamjXXqiNwGPrtR1GBTsMdtV/ituzPN1AyPFO9Cwac4m/+rN2AJ4ISrqAuB37FBm7
	 zaXk+rUsQDZzzOUd2l/vyPeJGjsg9hkLrOmBAV+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0816/2651] bpf: Fix overflow of jump offset in may_goto expansion
Date: Wed, 18 Nov 2026 15:34:16 +0100
Message-ID: <20261118150317.274046982@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 8a12a00f6c5dba70a6d908fe27a3c980d42b9515 ]

may_goto is expanded into 'if AX == 0 goto off + 5' when it's timed,
off + 2 when it's not and off - 1 when it jumps backward. The sum is
stored into 16-bit off without a range check, so may_goto +32763
turns into:

  if r12 == 0x0 goto pc-32768

and the prog jumps backward when may_goto expires.

Emit 'if AX != 0 goto +1; gotol' when the offset doesn't fit and
compute the offset from the number of insns in the expansion.
JITs that don't support gotol will reject such prog.

Fixes: 011832b97b31 ("bpf: Introduce may_goto instruction")
Fixes: e723608bf428 ("bpf: Add verifier support for timed may_goto")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260924233130.1213812-6-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/fixups.c | 68 +++++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 24 deletions(-)

diff --git a/kernel/bpf/fixups.c b/kernel/bpf/fixups.c
index e187e51120858..64f088bc6f256 100644
--- a/kernel/bpf/fixups.c
+++ b/kernel/bpf/fixups.c
@@ -1571,6 +1571,30 @@ static int add_hidden_subprog(struct bpf_verifier_env *env, struct bpf_insn *pat
 	return 0;
 }
 
+/*
+ * Expand may_goto: load the count from the stack, jump to the target of
+ * may_goto when it is zero, then the tail that updates the count.
+ * Use gotol when the target is too far for 16-bit offset of a conditional jump.
+ */
+static int may_goto_expand(struct bpf_insn *insn_buf, int off, int stack_off,
+			   const struct bpf_insn *tail, int tail_cnt)
+{
+	int cnt = 0;
+
+	/* Forward jump has to step over the tail */
+	off = off >= 0 ? off + tail_cnt : off - 1;
+
+	insn_buf[cnt++] = BPF_LDX_MEM(BPF_DW, BPF_REG_AX, BPF_REG_10, stack_off);
+	if (off == (s16)off) {
+		insn_buf[cnt++] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, off);
+	} else {
+		insn_buf[cnt++] = BPF_JMP_IMM(BPF_JNE, BPF_REG_AX, 0, 1);
+		insn_buf[cnt++] = BPF_JMP32_A(off >= 0 ? off : off - 1);
+	}
+	memcpy(insn_buf + cnt, tail, tail_cnt * sizeof(*tail));
+	return cnt + tail_cnt;
+}
+
 /* Do various post-verification rewrites in a single program pass.
  * These rewrites simplify JIT and interpreter implementations.
  */
@@ -1848,6 +1872,18 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 
 		if (bpf_is_may_goto_insn(insn) && bpf_jit_supports_timed_may_goto()) {
 			int stack_off_cnt = -stack_depth - 16;
+			/*
+			 * AX is used as an argument to pass in stack_off_cnt
+			 * (to add to r10/fp), and also as the return value of
+			 * the call to arch_bpf_timed_may_goto.
+			 */
+			struct bpf_insn tail[] = {
+				BPF_ALU64_IMM(BPF_SUB, BPF_REG_AX, 1),
+				BPF_JMP_IMM(BPF_JNE, BPF_REG_AX, 0, 2),
+				BPF_MOV64_IMM(BPF_REG_AX, stack_off_cnt),
+				BPF_EMIT_CALL(arch_bpf_timed_may_goto),
+				BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_AX, stack_off_cnt),
+			};
 
 			/*
 			 * Two 8 byte slots, depth-16 stores the count, and
@@ -1864,22 +1900,8 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 			 * after subtraction, rinse and repeat.
 			 */
 			stack_depth_extra = 16;
-			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_AX, BPF_REG_10, stack_off_cnt);
-			if (insn->off >= 0)
-				insn_buf[1] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, insn->off + 5);
-			else
-				insn_buf[1] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, insn->off - 1);
-			insn_buf[2] = BPF_ALU64_IMM(BPF_SUB, BPF_REG_AX, 1);
-			insn_buf[3] = BPF_JMP_IMM(BPF_JNE, BPF_REG_AX, 0, 2);
-			/*
-			 * AX is used as an argument to pass in stack_off_cnt
-			 * (to add to r10/fp), and also as the return value of
-			 * the call to arch_bpf_timed_may_goto.
-			 */
-			insn_buf[4] = BPF_MOV64_IMM(BPF_REG_AX, stack_off_cnt);
-			insn_buf[5] = BPF_EMIT_CALL(arch_bpf_timed_may_goto);
-			insn_buf[6] = BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_AX, stack_off_cnt);
-			cnt = 7;
+			cnt = may_goto_expand(insn_buf, insn->off, stack_off_cnt,
+					      tail, ARRAY_SIZE(tail));
 
 			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
 			if (!new_prog)
@@ -1891,16 +1913,14 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 			goto next_insn;
 		} else if (bpf_is_may_goto_insn(insn)) {
 			int stack_off = -stack_depth - 8;
+			struct bpf_insn tail[] = {
+				BPF_ALU64_IMM(BPF_SUB, BPF_REG_AX, 1),
+				BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_AX, stack_off),
+			};
 
 			stack_depth_extra = 8;
-			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_AX, BPF_REG_10, stack_off);
-			if (insn->off >= 0)
-				insn_buf[1] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, insn->off + 2);
-			else
-				insn_buf[1] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, insn->off - 1);
-			insn_buf[2] = BPF_ALU64_IMM(BPF_SUB, BPF_REG_AX, 1);
-			insn_buf[3] = BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_AX, stack_off);
-			cnt = 4;
+			cnt = may_goto_expand(insn_buf, insn->off, stack_off,
+					      tail, ARRAY_SIZE(tail));
 
 			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
 			if (!new_prog)
-- 
2.53.0



