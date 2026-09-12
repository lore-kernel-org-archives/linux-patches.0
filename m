Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BC9346ADC;
	Sat, 12 Sep 2026 07:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199359; cv=none; b=tNhXM5Gddet2MNY8YjKwsSHxEBDqGWDeFbvwR9Jr3vqlfKKOubI/FI/v0j2gyYWPS8ufUzGHutphxLxzCPjtITV/pgwOzl4QiaYE9T4i43X8Rsfjox0FhwVUAWnBWlfDlNtoFi6s9NVqMHto+6EDlpwV2o9JVzJjNt0ZlNyKHUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199359; c=relaxed/simple;
	bh=SOAMb7GJ3u895QoHbhXI76Q9WygW9VzDK2gutEIiH5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EyYWKW9YG5kt3YBY7APSPy0wLQVv1h8P+zjyMDfxwbTyjU85HPxVDNrwXgnVao7AAAoytOScX4KC6o/mnPs1IhmNoRB3iKL6wQt+aP/HFA4UKdEcjyT6O48FFuhs4+eKJLR5odZi1dE1eyuJtqLLrXEHWl4IubDD0KwSWor/YCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdFcq34c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdFcq34c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9231F000FF;
	Sat, 12 Sep 2026 07:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199358;
	bh=dRY2icsqqRCRHGj/ykCxADcLByCnotF40LqLs4/jh8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdFcq34c6AbId4L55w7+Uqj1Ki2XrVs6EX7/9eDppLL+tBlLYCcOG7BBQt0OZaaBT
	 EbGCgGgs8F6GImaEark2zI4g6ZY9O8uhXTdQt/kNwC+etcfqhJD9TCBgWtWWqSsRmb
	 5vHNa4BRvGZTMf2+hEQNeVWC5eoORpihD63k0hRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0568/1815] riscv, bpf: Fix kernel stack corruption in tailcall with CFI
Date: Sat, 12 Sep 2026 08:38:38 +0200
Message-ID: <20260912065702.215659793@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 0942116e59bc1..47177db842fd2 100644
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
 
@@ -2033,6 +2032,8 @@ void bpf_jit_build_prologue(struct rv_jit_context *ctx, bool is_subprog)
 	/* emit kcfi type preamble immediately before the  first insn */
 	emit_kcfi(is_subprog ? cfi_bpf_subprog_hash : cfi_bpf_hash, ctx);
 
+	/* bpf prog starts here as kcfi skipped during prog->bpf_func setup */
+
 	/* nops reserved for auipc+jalr pair */
 	for (i = 0; i < RV_FENTRY_NINSNS; i++)
 		emit(rv_nop(), ctx);
-- 
2.53.0



