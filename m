Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BA7429000;
	Sat, 12 Sep 2026 13:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218200; cv=none; b=DOF+p3k4W8i3nueR0YmBHCFCF0atkD9gZ3+Bw7xKmZNCxWd7RryjtqHmMj7rPqRFeGwIkrgsb/79ZDcocbP7k8gwhM5zWID6ejLWoiGInAhPn12xeJz5EJn9bDvxDfOHNtNIYDMkVGzUbHYbAzoHKBXCVxsb0PT+7Nttl9qcfuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218200; c=relaxed/simple;
	bh=C4dfjp7esMqf7R79+V1zpcGK7KcVSqEgGIk3BL4Ra/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKZy52Vwijf+EXFOirTgV8u7fw5ZXvrHv+y2HUDIOeJ+4nJf7SbiO9TjqsCcEOxMAE1gESgYcgadey21aLSjYHU0zUiExENp//wHJXraBZMwJ+f7MQLwcGJCp6ucE5rYyfiCutw5H+ZvAVntmHyzKV7ioAVdCXCrtDMs5cLVNmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4/9JePI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4/9JePI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934C21F000FF;
	Sat, 12 Sep 2026 13:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218198;
	bh=vaAWa8jtXgg8Ykew4vOrG2F4GbkC+vhSv+H0MRAJpPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4/9JePIVTxlddkinAu1+TukaQrBSBP4BKZLM8Kd9CY8hkBj/jEPHTR8YnNMf83tu
	 ku0wP35va78G6YKuUdq5ZTqA1w9wpH5b7bygYi8EBKQH5piIpBodDfm7tFu1vwaezo
	 eN/PVspOteWJTFUkEm7Y9gZqAK9pSq/7bNwgsHvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1094/1376] bpf, s390: Clear fetch destination on faulting arena atomic
Date: Sat, 12 Sep 2026 08:58:40 +0200
Message-ID: <20260912065631.943010912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



