Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625153;
	b=xNUz3mLIFYNvLIzP0wy/pd30SnjV9pemW+aWB+t7F1LS4/lEXID9f/Uj8dwofACKZ93E
	 WA1doWna0HExw/A7GqtJbqA+LXQbVoDaQZzjXRDgbVbuEjWDGheqGa7yTsB4VsDYdiTYb
	 4N0F4xbUO+QbPctXgBK+wo/e9USYWn3yUe9TupTFumZZHf3RnXf7BGA8TpI0Vf5Ybxwlq
	 UqzKqXvi4xhD7QHddlOQUs1pKd56k17jtelsmbvozJh50Ld38H2tl/VU4gcLOJpV6rRgK
	 7j8EA1ChjqC2EErhwZ9XZBDLCOTfynvUFasKHtQswJV9bIn/lJX4+b7VXCf4J/JkU6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gvsl3zTIgmwsCsdvnOEXnGfTiRUlKKhYsTEiXqRFVIs=;
	b=hb2cXVW6dq180SvQwxKBqpJj6guQfAD8Vhks9FIm8ZO+SB8PiUktA5jDew+E1yF1/+Iz
	 e0dpZy/7Bg4H18ND6dg6sm2p6USmqb91GebKzJGLJcnn+rqx+utz/+0kFG25JfnHKjZ03
	 mLI3hE58AWApsmMCgCCcfu9kBhTetMSgijZXUerB3PoXT1AnH+YYvK7vo0iyfK+HMDE35
	 loKfcrTe/7DikVv9CR4/InArjtoJ0XtNHgtdGRL8zQviAoPyIEpCc+pk7k8krXfswGHPm
	 zM8x29+vlt0sIMdejm9W2kMT5wwT5sryesj02vFBX6RDVmcYycKskKb9Jc2Q8RiR0Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1GnigL2y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49B0606A330;
	Wed, 25 Nov 2026 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1GnigL2y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED331F000F2;
	Wed, 25 Nov 2026 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625153;
	bh=gvsl3zTIgmwsCsdvnOEXnGfTiRUlKKhYsTEiXqRFVIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GnigL2ykfUJ6q6QTunh8GU8c1LNTIZxwV10CHZQq3TsHZ7z54qb9R+qEGYeYBxhT
	 5DIaWkoZp8p4hpd+A+ZFFXjmUGbSn+iMM27xPr7OSwiIsnUf3qnT2taMzHHfbAWkVx
	 Mt2Zt1luBo5rVmIA3mpWga0EGt+grQI4MW6vw5vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 425/816] bpf: Fix overflow of jump offset in may_goto expansion
Date: Wed, 25 Nov 2026 15:32:53 +0100
Message-ID: <20261125143859.033614617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Moved may_goto expansion into a new may_goto_expand() helper in verifier.c's do_misc_fixups(), since fixups.c doesn't exist here, and dropped the timed may_goto hunk, which has no counterpart. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ab7cf92771d81..86482f36329dd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21156,6 +21156,30 @@ static int add_hidden_subprog(struct bpf_verifier_env *env, struct bpf_insn *pat
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
@@ -21443,16 +21467,14 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 
 		if (is_may_goto_insn(insn)) {
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



