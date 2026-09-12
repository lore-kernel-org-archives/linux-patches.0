Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704283911BD;
	Sat, 12 Sep 2026 08:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203420; cv=none; b=PVhZLtPk5DVqeDmFESq/pHvfAGfZzrNuHRKlUi8AvWxqv9by9xxmmmVh0epoXWf0wb1Cv/SVetOg/vfTbYUG8z77JNcSWURodni9IIRS/lQJ7ic/yK6qzln9fuAnaazJlAo7nG+sh5PkWW+1+N3gMYcc0gnNgpN2GibZ2kY0/6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203420; c=relaxed/simple;
	bh=lamiznS1D+eOQpD3/FnT02DGE/2Jff5he0NvYvMCxOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPmanhWhiyGhRX6P1EdQg/wsmVMWj8VVxCtJDlygg3JweOD11NVwvKYfC2OpkKjNtuC5+SgCT+LOQHu82Ms+kXcwHVp65dCU7HQre/9uD1k2cPvx6l/pT++1Z51YJ5Yo//ANKhDQ76eVnVaMuyPxNNcu6zH5SzXuwotqQnG+Aas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFnPNKeT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFnPNKeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426851F000FF;
	Sat, 12 Sep 2026 08:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203417;
	bh=bzazQFLGX5qYFlRa7kFMoArSZntNCa1RlH+6x1lj0XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFnPNKeTjj7xlGu/NDuzAnxaG1jz2KtArx6JwXlrZTeSzTcQM/IAgSPvHGKSojoSj
	 NNSHcKj0ZDePWe5BeY4Haa31mFzOO4JOajq5O6Ge5KZjc7tVWEMf9e1hUnIvurVm3z
	 CoKPEWmazev9JYUuW6kDy22yzuCHxsXk9KAMIKYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Pu Lehui <pulehui@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1403/1815] bpf, riscv: Clear fetch destination on faulting arena atomic
Date: Sat, 12 Sep 2026 08:52:33 +0200
Message-ID: <20260912065721.962069038@linuxfoundation.org>
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

[ Upstream commit 1519f488e8ce430c68ade11d24b8459631f5dca9 ]

A RMW atomic on an arena pointer is converted to BPF_PROBE_ATOMIC and
gets an exception table entry, but that entry records no destination
register to clear unless the instruction is a load-acquire today. That
is right for a plain BPF_{ADD,AND,OR,XOR}, which only writes memory,
but an RMW carrying BPF_FETCH also reads the old value into a register:
src_reg for BPF_{ADD,AND,OR,XOR} | BPF_FETCH and BPF_XCHG, and r0 for
BPF_CMPXCHG. emit_atomic_rmw() emits it that way, e.g.:

  [...]
  case BPF_XCHG:
          ctx->ex_insn_off = ctx->ninsns;
          emit(is64 ? rv_amoswap_d(rs, rs, rd, 1, 1) :
               rv_amoswap_w(rs, rs, rd, 1, 1), ctx);
  [...]

Thus, a fault over an unmapped arena page ex_handler_bpf() jumps over
the access but leaves rs untouched, and the program resumes with
whatever it held before the atomic instead of the 0 that every other
BPF_PROBE_* access delivers. Fill the exception table entry in from
bpf_atomic_load_reg(), which returns the BPF register an atomic reads
the memory operand into or -1 when it has none. A load-acquire ends up
with the same register it gets today, it just goes through the helper.
Unlike x86-64 and arm64, riscv64 does not report arena violations from
its exception handler, so there is no access direction to correct here,
only the missing register clear.

Fixes: fb7cefabae81 ("riscv, bpf: Add support arena atomics for RV64")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://patch.msgid.link/20260811131600.506721-2-daniel@iogearbox.net
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 0dea10823b8bb..a5b987a824e38 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1986,10 +1986,19 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			ret = emit_atomic_rmw(rd, rs, insn, ctx);
 
 		/* ret can be 1 (skip-zext); extable entry still needs to be added */
-		if (ret >= 0)
-			ret = add_exception_handler(insn,
-				bpf_atomic_is_load_acq(insn) ? rd : REG_DONT_CLEAR_MARKER,
-				ctx) ?: ret;
+		if (ret >= 0) {
+			/*
+			 * A load-acquire reads into dst_reg, and a read-modify-write
+			 * carrying BPF_FETCH reads the old value into src_reg, or into
+			 * r0 for a BPF_CMPXCHG. Clear that register on fault, the
+			 * remaining atomics have no destination register.
+			 */
+			int load_reg = bpf_atomic_load_reg(insn);
+
+			ret = add_exception_handler(insn, load_reg < 0 ?
+					REG_DONT_CLEAR_MARKER : regmap[load_reg],
+					ctx) ?: ret;
+		}
 
 		if (ret)
 			return ret;
-- 
2.53.0



