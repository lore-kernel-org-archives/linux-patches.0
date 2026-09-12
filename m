Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7F63AFD15;
	Sat, 12 Sep 2026 09:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203690; cv=none; b=sM2IbDeaoZomy6Ew9nqJt4mgoYL+gEHzlRqJPjSgJjmpFTgnJzZnECmQc662JqUFzsihvlc2J7vGI74rvcJ39oyA10u8/EwjfyBmdVnihfCBhVyjxl7AKb0rYyW03KR50I5UghpfJVK20iml4IOVflIt1OfTAClnzqAdfV7MiTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203690; c=relaxed/simple;
	bh=0tuT0Oe+JEAeKC2u30PGlsTYRQWw4cWZHtYwq3dC+xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnMg2BCTLsZ3EU2EWpsb/kS1Gr18fgSYoNhNy9Rpmy/Vp3nf484Dhf462wzGGhHGTq+hwa87I/4+VB9qdqQ0+twUGYJu2mr+fNfb6+K0YIy8J5TeAhdXS06N1j88gXyfQlkgdlWdpqkq0qllNTJkxaH7vJ0Wr7gqSlMB3aSClDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mobq09vh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mobq09vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC9F1F000FF;
	Sat, 12 Sep 2026 09:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203689;
	bh=wbvw1lIE4HLexpUDstQlRugmm/z5gOL5L6hEdT3xzwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mobq09vhpBicwGhIIFLe2V8cJNf3MrmdkgzrpVmvFrtmWwAyehX+L8a6ojSotUZyw
	 IZ//UZkgm9Y6dsQwh6rHvGLmnKFjac6z6qzUjLUpmm2W3FgUid5CXAiGH4t2Wf9OTN
	 652MDlR5Yqc3sB9B3BSKCrIwDOernHbuAtm5VJ5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1457/1815] riscv, bpf: Fix missing sign-ext for signed 1-byte and 2-byte kfunc args
Date: Sat, 12 Sep 2026 08:53:27 +0200
Message-ID: <20260912065723.218083074@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit f2aaa621591093cfe8224a25ef2f04a3b1e304b0 ]

On RV64, the ABI requires sign-extension for signed 1-byte and 2-byte kfunc
args. However, the RV64 JIT currently does not perform sign-extension for
such kfunc args.

Before commit 7ce090afbf72 ("bpf: Infer zext_dst based on static register
liveness analysis"), state pruning could potentially omit zero-extension
of 32-bit subregisters, which inadvertently masked the above issue by making
the args appear as if they had been properly sign-extended. After that
commit, the problem is exposed, causing the kfunc_call/kfunc_call_test4
selftest to fail.

Fix this by extending the existing sign-extension logic to handle signed
1-byte and 2-byte kfunc args as well.

Fixes: 443574b03387 ("riscv, bpf: Fix kfunc parameters incompatibility between bpf and riscv abi")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260814064726.3607615-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index a5b987a824e38..a3af5070ac66d 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1830,9 +1830,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 
 			for (idx = 0; idx < fm->nr_args; idx++) {
 				u8 reg = bpf_to_rv_reg(BPF_REG_1 + idx, ctx);
+				bool sign = fm->arg_flags[idx] & BTF_FMODEL_SIGNED_ARG;
 
-				if (fm->arg_size[idx] == sizeof(int))
-					emit_sextw(reg, reg, ctx);
+				if (sign_extend(reg, reg, fm->arg_size[idx], sign, ctx))
+					return -EINVAL;
 			}
 		}
 
-- 
2.53.0



