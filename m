Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817BD4F472E;
	Tue, 13 Oct 2026 12:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894026; cv=none; b=BXH89yh6TZqTFP3zda5+EYaYpCCpm+ie7fFQOS3Entp8LPPL/SPvzydTtIQMKPLTnPTe1iabyeLwFndU0+muOW4FWyZ0LR1fvx3AP+rUjU7F1ho6gtdB81B8/M0ebYQcn6EwHsABZCYlbONpS9vwXww86tsI/KJam+uY3LCsNTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894026; c=relaxed/simple;
	bh=amAjXlWUW92rXFWuKlAncXVMpg2dHRFSFdzBkg1u3IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+vGMt6Ogc/2lJbXa7Vg6cInckJ7NlEIDSEh2+P1nto7z0bs1G/83B4DR+jDHR71zcYOSKesEXdDnesZZIu89MuanSaCwuPVN7aocyi99x5oicKjfeUczGjhex8f59wzXyqJAqbQ0NS3bqh5bV1XduKrCI1/znl8QYsPnhf/Gjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgzkgLIQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgzkgLIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59AD1F00893;
	Tue, 13 Oct 2026 12:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894025;
	bh=kOAait4zLbF120UZasGFUiQN57PgjKibJyzrwNuxp4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgzkgLIQaWbq/9eKfguVXqrTj3zP3os6JvEFZC3axBr4MTbR0TCudbySrZ8BY3QTF
	 lUc06HAu6cDrTF0YzzmB3AQ8vqu3ywtcw/q3DoL/+JPa1icnYmmv1tXz/+TrUz71qW
	 VM8MPk+amj1JHP1FVA89uOEbtUjH/y0GT906EeeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 421/621] bpf, s390: Clear fetch destination on faulting arena atomic
Date: Tue, 13 Oct 2026 13:36:56 +0200
Message-ID: <20261013112930.826720139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index d7cdd907ac797..c3ff2d82cd1c9 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -771,6 +771,8 @@ static void bpf_jit_probe_atomic_pre(struct bpf_jit *jit,
 				     struct bpf_insn *insn,
 				     struct bpf_jit_probe *probe)
 {
+	int load_reg;
+
 	if (BPF_MODE(insn->code) != BPF_PROBE_ATOMIC)
 		return;
 
@@ -780,6 +782,14 @@ static void bpf_jit_probe_atomic_pre(struct bpf_jit *jit,
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
@@ -1642,6 +1652,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 			if (load_probe.prg != -1) {
 				probe.prg = jit->prg;
 				probe.arena_reg = load_probe.arena_reg;
+				probe.reg = load_probe.reg;
 			}
 			loop_start = jit->prg;
 			/* 0: {csy|csg} %w0,%src,off(%arena) */
-- 
2.53.0



