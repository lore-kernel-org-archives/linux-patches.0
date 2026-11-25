Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622442;
	b=LKw44j9vYW8A9GZE927q7vsyudhCY6w2va7K4MKqBCvgr7zZto3T6TfSVOniQGWwzANG
	 Z/yMFzrVPkgYBV9J94Dg7484hkTJc/I1sypZht3Eru5juqSxsbeYOXhMunvCPA52fbkjy
	 jY9IlZWt6Ulwm7GxkCqXKZ0ph8jWzaFANLGjpRzf1xmT8TkGnYerzdu2+KATsuktCYaV6
	 wdIgL88/95pNrzurRn4dPZP4rw+ER7oMv9LM5hyEi05w4h1rQv98z1Vy80O1CE9FsZh2q
	 QIqlMIITTzY78sPcPl8d4SNp2F9uRYGcxQMku2zi0r8b4nRdwarxylplnob5q2SAuSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/VUlKNPjpTtIIIInKXjLbsmJKX7lEmdpeG6bZtJksHA=;
	b=z2Qigt3bZuqfr3I9z+1aQE+Wddb39MFEyEup3xqP72MUq0rHfCc27PxKUUWahA2IEsLS
	 Y9Fdb5jzD4f8TXGyBL5MN8piAFlKAcEsiOfOuQLkRywxVnk2MHAm5s7Fh2I7n8flVSGxd
	 VY0JZMGgJtlHM+/ZW54IAZamlaj3sKMD5SH/L2kmRTMJrOBcIwg76M3xvmDZxvwkbGpdb
	 OQGZe4ydA+o/E2WfRI4a+7lMwXrPjwKjjM0L/SGDY7/i64nU6DrNMI0JU55Mjho+Y8rL8
	 LG6RGQ7Hv6eoZwOpiYNgtmaRhie0e1ia2Eru+eEdJCa0pY9FTiawjhk6FqwEq+Zz5dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jf6g08C+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A44F606A31E;
	Wed, 25 Nov 2026 16:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jf6g08C+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CF71F000C4;
	Wed, 25 Nov 2026 16:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622441;
	bh=/VUlKNPjpTtIIIInKXjLbsmJKX7lEmdpeG6bZtJksHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jf6g08C+MnMyp4zSCL9vmP9FIRjSyORH6et7SudpK7BnQHLb7Z7PJRZtp7xTlYPXd
	 gNQ/SJc61QG57jDOWzucCmli41wnC+dJ3k2a7O0CAbixxx8Ob0uRnyaFN7wjPGNnSY
	 5bGuj8eyHrmpXeQkzPeeYn+g7dUqUxfGmYqyyAMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 537/990] bpf: Fix overflow of jump offset in may_goto expansion
Date: Wed, 25 Nov 2026 15:31:44 +0100
Message-ID: <20261125143834.670852425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: Ported the may_goto overflow fix into verifier.c, since this tree has no fixups.c, and used the older do_misc_fixups() and is_may_goto_insn() names. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 68 ++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 24 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 13864488b5a07..407526349ccfa 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22735,6 +22735,30 @@ static int add_hidden_subprog(struct bpf_verifier_env *env, struct bpf_insn *pat
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
@@ -23015,6 +23039,18 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 
 		if (is_may_goto_insn(insn) && bpf_jit_supports_timed_may_goto()) {
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
@@ -23031,22 +23067,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
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
@@ -23058,16 +23080,14 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			goto next_insn;
 		} else if (is_may_goto_insn(insn)) {
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



