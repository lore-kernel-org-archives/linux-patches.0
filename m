Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A513F9F50;
	Sat, 12 Sep 2026 08:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203442; cv=none; b=mDxKKps/62Z1I+biOkqWwtsDwgZH3rNMYGgetr6UEte8PhVduhgKlptMHEt/rMRvYfpTdqX+MPJOxvDfdqYHsFQEHy6eLFhzs75jXEWNAlreMse6JghdtHk7LkSVIo6cW8pHnbytYGUq2b95JgRcybLsIxAYZzMyVNtj0BDH4DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203442; c=relaxed/simple;
	bh=BV64G/UJDMgIetDxC8adgq9W+PR/+ZQS/eMDRHIalc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeJ9uUNdBna+TJYIPCGR6qs+HVMAGQrHge+ae3HaeR3lm8mHhDyaHLdkfO3k8nGc7TC/0jgx0Nqy5hS3t7whD/uU48WaxV5fOwTm1WdYSPYYR42bfEGAus2+nEMSFOPltuz2AISNYAJ7gg4EhRRgTLhfr0X+yDfp6T5DH0Makq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSGYQN+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSGYQN+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B701F000FF;
	Sat, 12 Sep 2026 08:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203437;
	bh=JvNAU6YmKxbILxN8bcIoB3cZwDThvIbuKbZYogRhNOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSGYQN+kA1nzPIj9IXD6IuTaXQlXdCEvrVQXiHS8vRnGWHX/BsxLOshqCmE5m/e0K
	 XKh2npS3ocDZun14zg72jwAnd+Bt4lH1z6zrbxEEqEc542rN+qDlyhyOFHNJTRjUoQ
	 QeMQIa4sazy3H8UtXQqHNC4ltqeb4rAs7y5yi6/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1407/1815] bpf, s390: Clear fetch destination on faulting arena atomic
Date: Sat, 12 Sep 2026 08:52:37 +0200
Message-ID: <20260912065722.052666954@linuxfoundation.org>
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
index 9ddd89f71f282..408ae09be3a59 100644
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



