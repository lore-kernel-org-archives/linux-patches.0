Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70F725B0AA;
	Sat, 12 Sep 2026 10:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207879; cv=none; b=AWouGemyDJxdfBH4xCHTLdnilu3TCopWoY1OE4dBvgY2v79uUDV3D5IQ+2/Y0tEVaAS2ZQ8YZnj7b75+byFr8Xm8iPtyMae5V5Dx1AvJfHm94GJpCA8H+wPZioVFKhKUQGO5LlJDoDiWwjW8UnyBdg5MKTTE4CU/nPrVo6xahVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207879; c=relaxed/simple;
	bh=HIveSG25sFwDiGAG38yvVvknz5UpYfaHnsFUyUG0pMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4nkUot3vP7eXw5NA0uTqqj9RMp1sQTnuCv+33g/bVua5RcpdUyPTvnCrM9NkcYjK8v/nD1GdDhiRx1cih/Kz+75SQPwaWMXLLtn0wWuwJ1MDTPw8MaP4EuYsDIKmJQR1joTdzb1WAJCy5fhd5SqBHQ0I9LcYz3WOoYu4OKym4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzLpa032; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzLpa032"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1FF1F000FF;
	Sat, 12 Sep 2026 10:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207878;
	bh=03eMrBQprHd0NpCoIJUUuinJuhQ5utiZksNrjAAk+9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xzLpa032vHtRWx+/xtgJGthzapoJvy617J/8A1q96qpYlM3YfxKsNixWlRVmbK1hH
	 DUBF/6RaPgrjAyJ5YMrrx6kuHBSisR62CCPJVxx8FE21HK7l2spXJ9ecKAcdaLbq4O
	 2TsjFur9LsXOdydCofrsT9zXDF8cYeCGYS17Nm3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0501/1518] riscv, bpf: Fix kernel stack corruption in tailcall with CFI
Date: Sat, 12 Sep 2026 08:44:30 +0200
Message-ID: <20260912065634.778162304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 52fb1756ea1d2759dfef2d86245be00b05dac3a2 ]

When CONFIG_CFI_CLANG is enabled, prog->bpf_func already skips the kcfi
instruction during setup. Including it again in the tailcall jump offset
causes it to jump over an extra 4 bytes, skipping the stack pointer
adjustment, which will result in kernel stack corruption.

Fixes: 30a59cc79754 ("riscv, bpf: Fix possible infinite tailcall when CONFIG_CFI_CLANG is enabled")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20260708064436.2971933-5-pulehui@huaweicloud.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 9e9e6dcfc4825..1e9b2475f514c 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -18,7 +18,6 @@
 #define RV_MAX_REG_ARGS 8
 #define RV_FENTRY_NINSNS 2
 #define RV_FENTRY_NBYTES (RV_FENTRY_NINSNS * 4)
-#define RV_KCFI_NINSNS (IS_ENABLED(CONFIG_CFI) ? 1 : 0)
 /* imm that allows emit_imm to emit max count insns */
 #define RV_MAX_COUNT_IMM 0x7FFF7FF7FF7FF7FF
 
@@ -272,8 +271,8 @@ static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 	if (!is_tail_call)
 		emit_addiw(RV_REG_A0, RV_REG_A5, 0, ctx);
 	emit_jalr(RV_REG_ZERO, is_tail_call ? RV_REG_T3 : RV_REG_RA,
-		  /* kcfi, fentry and TCC init insns will be skipped on tailcall */
-		  is_tail_call ? (RV_KCFI_NINSNS + RV_FENTRY_NINSNS + 1) * 4 : 0,
+		  /* fentry and TCC init insns will be skipped on tailcall */
+		  is_tail_call ? (RV_FENTRY_NINSNS + 1) * 4 : 0,
 		  ctx);
 }
 
@@ -1973,6 +1972,8 @@ void bpf_jit_build_prologue(struct rv_jit_context *ctx, bool is_subprog)
 	/* emit kcfi type preamble immediately before the  first insn */
 	emit_kcfi(is_subprog ? cfi_bpf_subprog_hash : cfi_bpf_hash, ctx);
 
+	/* bpf prog starts here as kcfi skipped during prog->bpf_func setup */
+
 	/* nops reserved for auipc+jalr pair */
 	for (i = 0; i < RV_FENTRY_NINSNS; i++)
 		emit(rv_nop(), ctx);
-- 
2.53.0



