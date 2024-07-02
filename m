Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739EE178381;
	Tue,  2 Jul 2024 17:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940046; cv=none; b=W2vWlTeVdigQOpjpmbGT4pui/oDssS23IsjIAopJesxYl1mHZlG847Nfj1jSdTYlr4Np/NeAr+Dnlsp0kAUlrYG/ahh0a8h/dUs29K48RpKgdPOzkQZ/Conuu1CJK/PF6s32j0YRp7OXZOReGlUV8jiRb65RWooUyAKZE2No8rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940046; c=relaxed/simple;
	bh=M9VfU4zB+oLYbem4oDZIpSeo2Evf870zIhOx9QdpL44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEREVR6H4+9W+2y7pI5ZmWA2CMpe4+XNrg15bzTgAOuw5DCxNCYEzWQ+Zt09Rj6Gssj4wVFzhXFOOM2y+GkEdUclgOUQtOCMUkqKGkh4u5RoU+0sgh8rkcqlDvjgE9yLTzoo3tQPnHV7IDtUTU8JbSnoc1IXqC6Lr9pd8hjLuP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xT61RXYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xT61RXYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F54C116B1;
	Tue,  2 Jul 2024 17:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940046;
	bh=M9VfU4zB+oLYbem4oDZIpSeo2Evf870zIhOx9QdpL44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xT61RXYmCCjCPmDUqN2y0P03jyv8qq22F+sYx/0HHazREMSz7+Zp1mgMLJkLmOKch
	 XFbsQzOOF337UkZCQb35EQ2bshcQzjdomzouKba3pin0XNpD0K4IY5lBzhBs/kpWh9
	 xTf+5BRmXRMM8M/5ZaBKLE8DUfL9i/H7hfO5s/Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zac Ecob <zacecob@protonmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 036/222] bpf: Fix the corner case with may_goto and jump to the 1st insn.
Date: Tue,  2 Jul 2024 19:01:14 +0200
Message-ID: <20240702170245.356351536@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 5337ac4c9b807bc46baa0713121a0afa8beacd70 ]

When the following program is processed by the verifier:
L1: may_goto L2
    goto L1
L2: w0 = 0
    exit

the may_goto insn is first converted to:
L1: r11 = *(u64 *)(r10 -8)
    if r11 == 0x0 goto L2
    r11 -= 1
    *(u64 *)(r10 -8) = r11
    goto L1
L2: w0 = 0
    exit

then later as the last step the verifier inserts:
  *(u64 *)(r10 -8) = BPF_MAX_LOOPS
as the first insn of the program to initialize loop count.

When the first insn happens to be a branch target of some jmp the
bpf_patch_insn_data() logic will produce:
L1: *(u64 *)(r10 -8) = BPF_MAX_LOOPS
    r11 = *(u64 *)(r10 -8)
    if r11 == 0x0 goto L2
    r11 -= 1
    *(u64 *)(r10 -8) = r11
    goto L1
L2: w0 = 0
    exit

because instruction patching adjusts all jmps and calls, but for this
particular corner case it's incorrect and the L1 label should be one
instruction down, like:
    *(u64 *)(r10 -8) = BPF_MAX_LOOPS
L1: r11 = *(u64 *)(r10 -8)
    if r11 == 0x0 goto L2
    r11 -= 1
    *(u64 *)(r10 -8) = r11
    goto L1
L2: w0 = 0
    exit

and that's what this patch is fixing.
After bpf_patch_insn_data() call adjust_jmp_off() to adjust all jmps
that point to newly insert BPF_ST insn to point to insn after.

Note that bpf_patch_insn_data() cannot easily be changed to accommodate
this logic, since jumps that point before or after a sequence of patched
instructions have to be adjusted with the full length of the patch.

Conceptually it's somewhat similar to "insert" of instructions between other
instructions with weird semantics. Like "insert" before 1st insn would require
adjustment of CALL insns to point to newly inserted 1st insn, but not an
adjustment JMP insns that point to 1st, yet still adjusting JMP insns that
cross over 1st insn (point to insn before or insn after), hence use simple
adjust_jmp_off() logic to fix this corner case. Ideally bpf_patch_insn_data()
would have an auxiliary info to say where 'the start of newly inserted patch
is', but it would be too complex for backport.

Fixes: 011832b97b31 ("bpf: Introduce may_goto instruction")
Reported-by: Zac Ecob <zacecob@protonmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Closes: https://lore.kernel.org/bpf/CAADnVQJ_WWx8w4b=6Gc2EpzAjgv+6A0ridnMz2TvS2egj4r3Gw@mail.gmail.com/
Link: https://lore.kernel.org/bpf/20240619011859.79334-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 50 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index add5ccbe87523..2233bf50a9012 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12546,6 +12546,16 @@ static bool signed_add32_overflows(s32 a, s32 b)
 	return res < a;
 }
 
+static bool signed_add16_overflows(s16 a, s16 b)
+{
+	/* Do the add in u16, where overflow is well-defined */
+	s16 res = (s16)((u16)a + (u16)b);
+
+	if (b < 0)
+		return res > a;
+	return res < a;
+}
+
 static bool signed_sub_overflows(s64 a, s64 b)
 {
 	/* Do the sub in u64, where overflow is well-defined */
@@ -18564,6 +18574,39 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 	return new_prog;
 }
 
+/*
+ * For all jmp insns in a given 'prog' that point to 'tgt_idx' insn adjust the
+ * jump offset by 'delta'.
+ */
+static int adjust_jmp_off(struct bpf_prog *prog, u32 tgt_idx, u32 delta)
+{
+	struct bpf_insn *insn = prog->insnsi;
+	u32 insn_cnt = prog->len, i;
+
+	for (i = 0; i < insn_cnt; i++, insn++) {
+		u8 code = insn->code;
+
+		if ((BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32) ||
+		    BPF_OP(code) == BPF_CALL || BPF_OP(code) == BPF_EXIT)
+			continue;
+
+		if (insn->code == (BPF_JMP32 | BPF_JA)) {
+			if (i + 1 + insn->imm != tgt_idx)
+				continue;
+			if (signed_add32_overflows(insn->imm, delta))
+				return -ERANGE;
+			insn->imm += delta;
+		} else {
+			if (i + 1 + insn->off != tgt_idx)
+				continue;
+			if (signed_add16_overflows(insn->imm, delta))
+				return -ERANGE;
+			insn->off += delta;
+		}
+	}
+	return 0;
+}
+
 static int adjust_subprog_starts_after_remove(struct bpf_verifier_env *env,
 					      u32 off, u32 cnt)
 {
@@ -20268,6 +20311,13 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 		if (!new_prog)
 			return -ENOMEM;
 		env->prog = prog = new_prog;
+		/*
+		 * If may_goto is a first insn of a prog there could be a jmp
+		 * insn that points to it, hence adjust all such jmps to point
+		 * to insn after BPF_ST that inits may_goto count.
+		 * Adjustment will succeed because bpf_patch_insn_data() didn't fail.
+		 */
+		WARN_ON(adjust_jmp_off(env->prog, subprog_start, 1));
 	}
 
 	/* Since poke tab is now finalized, publish aux to tracker. */
-- 
2.43.0



