Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592CA47DD76;
	Sat, 12 Sep 2026 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218381; cv=none; b=Dd+vqsam9FntDebntYxWf9XafAymjXN3KbJX+yCUlmLMzX1LpsMpBUknsGGFlyy0C7cEAKcyoj2cTDnRZ3ja8qR+P/CbF8UwDckK2932eyBqJFIxvfjsHSoKtpLgSS1bS60T+jVVGFAZSt6DfN4Ih8CHxaaMELiSumkF7BT/Yf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218381; c=relaxed/simple;
	bh=2eofLbyfBPFmZc0EXf9qxA3SrPp9rMR7WFYOzF/HsU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS3NcA10oZtcRiqTKU3rxwYNPI4mP/FcfvpVb+H8OIjkRmeCRf4hO+oEaLSkT05/eg0AdG0gp/IyoeoPTmFsa7UdBVBdzLYZiTtS3MC9f+F7xyHlbR3vj2o+5sY329VcoKXCyxTu33A2Y3HN3k7DufwMgiLDj96rsbYhIwNSef4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZaYIcdM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZaYIcdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE1E1F000FF;
	Sat, 12 Sep 2026 13:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218380;
	bh=znjVnJZcGgDVnQYIfP3UnipCzAKY4rbIYJVtUslCQ1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZaYIcdMo/imi2hd0c+ZbiMFkBJfml6xEytp074dOB9aOqQYwXv8zGyRcmRVkOBOB
	 BCqok+ynfEJ8uODTTGWzmUGLxnIVIWKxsiSIqpqy5b+Lxked2pS/lIYniQG3HZVZNp
	 22hdmD0EwjaVQf2rF7DGR4EPX9/mivSm6ypB7ikA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1133/1376] riscv, bpf: Fix missing sign-ext for signed 1-byte and 2-byte kfunc args
Date: Sat, 12 Sep 2026 08:59:19 +0200
Message-ID: <20260912065632.813327691@linuxfoundation.org>
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
index 43a58e5e123f2..55c2f85090d45 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1617,9 +1617,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 
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



