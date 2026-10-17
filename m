Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA4536CE19;
	Sat, 17 Oct 2026 16:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255010; cv=none; b=m3WGIi0p1VEkp1XUJett64DtNPoP/tnHq1DBGbTlGMh82mxzXJNmWs0fpCatKmezaDIi68B/Wt6SmWZBeBWepdZ7wrN9xv7ZpKfd/UUR0eddtpmSWYkoqyaY5e970mSgX2qr6t/eaQa4x1C/Rzp3ablYUTjcgYaGLrNpRGC+K18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255010; c=relaxed/simple;
	bh=C4dfjp7esMqf7R79+V1zpcGK7KcVSqEgGIk3BL4Ra/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4Zc0ZBIUeowqH+eDhmTbc5dSc1Kt+Om/9gqNrNPk1vyfnfCaJnMoqH4LuQyMbfLBEOZADLleVyO1EJiITO3lSpUi9g3tTlg9pDaFnrZ0t2tSu+OMqA/AuHMdZBWe72LtBdryYaT5tEqfXT78wxxhngop8naoNgk0JVHwUiaxoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NenrtJel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NenrtJel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B825A1F000C4;
	Sat, 17 Oct 2026 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255009;
	bh=vaAWa8jtXgg8Ykew4vOrG2F4GbkC+vhSv+H0MRAJpPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NenrtJel3qt/FcSaoFm70Pe2XnnW7pwQ+8AejwtvJ2MOFqzEf/QuEDoBT4Bak7dex
	 Htd1St6Y+m7YN9LJgxqWKSxQs4mNixUY1yBCQiXHKDitkGoyxIkScMZk+hipmCA66X
	 jiMQkQk+g8X7AhW9l8GRHwgoRB1Ap/zo1nWF6hH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 634/869] bpf, s390: Clear fetch destination on faulting arena atomic
Date: Sat, 17 Oct 2026 17:57:55 +0200
Message-ID: <20261017160053.279401495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit cc3e12330599f097f0e1f792435686ddc276f26d ]

Same missing register clear as on riscv64. A RMW atomic on an arena pointer
is converted to BPF_PROBE_ATOMIC and gets an exception table entry, but
bpf_jit_probe_atomic_pre() only fills in the arena base and the probe
offset, leaving probe->reg at the -1 that bpf_jit_probe_init() set, which
bpf_jit_probe_post() writes into the entry and ex_handler_bpf() then reads
back as "there is nothing to clear".

That is right for a plain BPF_{ADD,AND,OR,XOR}, which only writes memory,
but an RMW carrying BPF_FETCH also reads the old value into a register:
src_reg for BPF_{ADD,AND,OR,XOR} | BPF_FETCH and BPF_XCHG, and r0 for
BPF_CMPXCHG. So on a fault over an unmapped arena page the program resumes
at the landing pad with whatever that register held before the atomic
instead of the 0 that every other BPF_PROBE_* access delivers.

Fill probe->reg in from bpf_atomic_load_reg(). Unlike x86-64 and arm64,
s390x does not report arena violations from its exception handler, so there
is no access direction to correct here, only the missing register clear.

Fixes: 2f9469484a3b ("s390/bpf: Support arena atomics")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://patch.msgid.link/20260811131600.506721-5-daniel@iogearbox.net
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index c3ad3cf86ca64..55419813c570b 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -782,6 +782,8 @@ static void bpf_jit_probe_atomic_pre(struct bpf_jit *jit,
 				     struct bpf_insn *insn,
 				     struct bpf_jit_probe *probe)
 {
+	int load_reg;
+
 	if (BPF_MODE(insn->code) != BPF_PROBE_ATOMIC)
 		return;
 
@@ -791,6 +793,14 @@ static void bpf_jit_probe_atomic_pre(struct bpf_jit *jit,
 	EMIT4(0xb9080000, REG_W1, insn->dst_reg);
 	probe->arena_reg = REG_W1;
 	probe->prg = jit->prg;
+	/*
+	 * A read-modify-write carrying BPF_FETCH reads the old value into
+	 * src_reg, or into r0 for a BPF_CMPXCHG. Clear that register on
+	 * fault, the remaining atomics only write memory.
+	 */
+	load_reg = bpf_atomic_load_reg(insn);
+	if (load_reg >= 0)
+		probe->reg = reg2hex[load_reg];
 }
 
 static int bpf_jit_probe_post(struct bpf_jit *jit, struct bpf_prog *fp,
@@ -1653,6 +1663,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 			if (load_probe.prg != -1) {
 				probe.prg = jit->prg;
 				probe.arena_reg = load_probe.arena_reg;
+				probe.reg = load_probe.reg;
 			}
 			loop_start = jit->prg;
 			/* 0: {csy|csg} %w0,%src,off(%arena) */
-- 
2.53.0



