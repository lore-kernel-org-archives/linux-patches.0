Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099373AE198;
	Sat, 17 Oct 2026 16:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255205; cv=none; b=nq9FUptZw4cjWnGuRQQC2p+cfE9b5VusHUaSKbNFgqU6R8cxNVqeMqpv0b03xroZwoXubaPezUzxwQUTg8Zs3p9qem11BFRh28VmjTIGgrXoy031SJGcuR/x2XXMEmq67c6zpXBNVqAj60zV2XOOHyndWknr2U3KWDaMAuudOew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255205; c=relaxed/simple;
	bh=X/4rBS8S5Rh7AOXXl3bMp511oGOcMPpaWnLiSKqu2XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/tVk35tN5FmAEC6y0E+rHqwXIIljiqR6rVoMnQpWr3nHXVaPIQIErQoSzegWOyXJ3LECs0wB+OG017ykN+m5Gn7V2I/KPVVogyD80KtvIStb/BGEaNZgpHnTmUFzUR1Bajnb5fZty0B/1TND1nGEe3HLAnbDk7gbRK8m3JLxEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsKJ9MXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsKJ9MXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D001F000C5;
	Sat, 17 Oct 2026 16:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255203;
	bh=oacNH1TI5lwJ2B06kpeUJ6ZGRrlrWRNbM3nmQwrHFm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsKJ9MXZBLM1SzVdiRQMK6Zg5mMKGf2Wfvc7FJ9fRanfrZ6KS9pKz0Wqftaie9h0c
	 wTdwoEeMr0Z3W0krtZKCIGxFshXCLWqgJMRLAWQ6U2owZLuW3gWnvZRRIEYqWgR7RC
	 HJmqeqwxdSiqa0tca26QF7V0NY3D3N89bK8GuoSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 697/869] riscv, bpf: Fix kernel stack corruption in tailcall with CFI
Date: Sat, 17 Oct 2026 17:58:58 +0200
Message-ID: <20261017160054.841719122@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8d37b8ffa6843..6086503d61edb 100644
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
 
@@ -2083,6 +2082,8 @@ void bpf_jit_build_prologue(struct rv_jit_context *ctx, bool is_subprog)
 	/* emit kcfi type preamble immediately before the  first insn */
 	emit_kcfi(is_subprog ? cfi_bpf_subprog_hash : cfi_bpf_hash, ctx);
 
+	/* bpf prog starts here as kcfi skipped during prog->bpf_func setup */
+
 	/* nops reserved for auipc+jalr pair */
 	for (i = 0; i < RV_FENTRY_NINSNS; i++)
 		emit(rv_nop(), ctx);
-- 
2.53.0



