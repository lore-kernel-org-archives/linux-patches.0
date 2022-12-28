Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB601863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A60C433D2;
	Wed, 28 Dec 2022 15:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239960;
	bh=f8Zu+p/3nMcnJD5egr3E6jd9v0jIwhe1mg1Gwj1GyBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIrq2iE90f4TwIQYvEaViD1I45YweX5lpSCBDPZCHAynFSjE+yYqdMftL9w9wpH9R
	 fBtB+xj9Z/cuPxNWK86eQE7JJCHIWG7BCryt8rfBQP6x1Iq7zco3i8ianHGX0yo2Cl
	 2G8hR8N5wIw1Je9vN+OzEwjQDFsEau7h3WGYrcQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Pu Lehui <pulehui@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 290/731] riscv, bpf: Emit fixed-length instructions for BPF_PSEUDO_FUNC
Date: Wed, 28 Dec 2022 15:36:37 +0100
Message-Id: <20221228144304.976499783@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit b54b6003612a376e7be32cbc5c1af3754bbbbb3d ]

For BPF_PSEUDO_FUNC instruction, verifier will refill imm with
correct addresses of bpf_calls and then run last pass of JIT.
Since the emit_imm of RV64 is variable-length, which will emit
appropriate length instructions accorroding to the imm, it may
broke ctx->offset, and lead to unpredictable problem, such as
inaccurate jump. So let's fix it with fixed-length instructions.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Suggested-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20221206091410.1584784-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 3af4131c22c7..2e3f1a626a3a 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -120,6 +120,25 @@ static bool in_auipc_jalr_range(s64 val)
 		val < ((1L << 31) - (1L << 11));
 }
 
+/* Emit fixed-length instructions for address */
+static int emit_addr(u8 rd, u64 addr, bool extra_pass, struct rv_jit_context *ctx)
+{
+	u64 ip = (u64)(ctx->insns + ctx->ninsns);
+	s64 off = addr - ip;
+	s64 upper = (off + (1 << 11)) >> 12;
+	s64 lower = off & 0xfff;
+
+	if (extra_pass && !in_auipc_jalr_range(off)) {
+		pr_err("bpf-jit: target offset 0x%llx is out of range\n", off);
+		return -ERANGE;
+	}
+
+	emit(rv_auipc(rd, upper), ctx);
+	emit(rv_addi(rd, rd, lower), ctx);
+	return 0;
+}
+
+/* Emit variable-length instructions for 32-bit and 64-bit imm */
 static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
 {
 	/* Note that the immediate from the add is sign-extended,
@@ -887,7 +906,15 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		u64 imm64;
 
 		imm64 = (u64)insn1.imm << 32 | (u32)imm;
-		emit_imm(rd, imm64, ctx);
+		if (bpf_pseudo_func(insn)) {
+			/* fixed-length insns for extra jit pass */
+			ret = emit_addr(rd, imm64, extra_pass, ctx);
+			if (ret)
+				return ret;
+		} else {
+			emit_imm(rd, imm64, ctx);
+		}
+
 		return 1;
 	}
 
-- 
2.35.1



