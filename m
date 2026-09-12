Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4C1CA6F;
	Sat, 12 Sep 2026 11:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211395; cv=none; b=MGwV1W/ioVuKIVCWboXl6SosI7QGe9A4Um1aB5gjYCk6tslA8LnEIqPGXjPAu0mO8oMdLfkhq+RiIMbjXAd41Ljs518i88ASrq3KQBCTY3J/p/VY3NNWO1HJ24VRSVVjeUXrnbwOYXycQ5mH+YbGM1Ry9/nQPGdE7IwZQvGFG/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211395; c=relaxed/simple;
	bh=/+vwyVX1IyIwqO77cuBV7PxYsKD7N/mc8qA+ATNhdjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhNgNhIlFfF6BRF9WnFOfJNN0sASMc16KRdHHa+qPVr35b1Ts4KvpW/4pHiYmKmXqeMuHaXB4tTL9Rdt904aszCwXqo3YBqDb9T7MKSjBCWMYE/eXhhmASbvTlAWhYV2C8dMTXuF9gWx2Fs1CgmfvgPgdebWB08DtTsO4No7mcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETkQJhVY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETkQJhVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BE71F00893;
	Sat, 12 Sep 2026 11:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211393;
	bh=QFfdzqXgbzpVeA9leYg6lQBn5evmEoQCn5NP7zgAstU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETkQJhVYLcqTQ91lwemonNb9sp73DhB/pS60XkjWDQi+x1r5G1Zw6sUEEDeSn/UXp
	 jXXw2u5iiJ5Z/W4WCWQsdbFG4R9Sj5D6ODpij/rQxUGgxFktbyCoXYdxxL0KB3JXN1
	 Ubev1WxbAEpKTJw6AAFK+3iwbxjNwoEyNdNkz3sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1195/1518] riscv, bpf: Fix missing sign-ext for signed 1-byte and 2-byte kfunc args
Date: Sat, 12 Sep 2026 08:56:04 +0200
Message-ID: <20260912065650.514036341@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a90066cc9d58b..3e4eea261ab96 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1770,9 +1770,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 
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



