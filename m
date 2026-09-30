Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5ED4FD78D;
	Wed, 30 Sep 2026 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785008; cv=none; b=Ne6BTNW4rRfmaNIHeDjMLHJ3tryjGO1UW/3XjcHoP4LhLSvQjmUWLi2XLLjhjmcG43y0SdF/MTzDfwJgANI2yuETzC1QG4xcDjmmjAc3DQ7fWRsBswrfBeHa9q4J0DQ3IECSF9poxM4tc9/YNZCSONzSz+FjV2PnigNzwBF6yPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785008; c=relaxed/simple;
	bh=SyooBOBJdOYge8MrthHH3Y4H8qSK4yya4BbNVkV6/P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPIzmR4sM982anu77KrhHbQYKqp/lJT7YIJ5+Es3g/GBAxZSeJ6IbeoxiVnr2SGOutSTGo26UGcXmkGwm/Gf1vArm2x/5KnabaxV7yKp7pRRcd1WQic/546o/Md63Z6hSKUCNMKYyjxcIc2prP5IMBQx3e9HKBIEDS4hIV14isY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMklqR9k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMklqR9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADECD1F00898;
	Wed, 30 Sep 2026 16:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785000;
	bh=kiXl//ZGMFq/yI5n5NauExYuczqJRn3CWMpalhXge94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMklqR9k3Kv1rOhnswxrjJG3ClbjLuqK9QjV8Ozu7W3pfrd5EnYEIbOOsDOPybuVY
	 foqXIeNiybEF/GJbRLonUtjcdnmHvvcyspO9Gq/JpmaGYRDathzZtz6ZUi6oc4Ngit
	 g2CVbi4BwgXZtGY4dh4EDGBb4x0cAlwpF1gpAza8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 309/982] bpf: Mask pseudo pointer values in verifier logs
Date: Wed, 30 Sep 2026 17:17:25 +0200
Message-ID: <20260930152423.457323108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>

[ Upstream commit 72a85e9464a5332fb2cd7efd26d9295275ceda2d ]

print_bpf_insn() masks ldimm64 immediates for pointer-bearing pseudo
sources when pointer leaks are not allowed, but the mask only covers
BPF_PSEUDO_MAP_FD and BPF_PSEUDO_MAP_VALUE.

BPF_PSEUDO_MAP_IDX, BPF_PSEUDO_MAP_IDX_VALUE, and BPF_PSEUDO_BTF_ID can
also be resolved to kernel pointer values before the verifier log prints
the instruction. Include them in the existing pointer classification so
the log prints 0x0 instead of the rewritten address.

Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
Fixes: 387544bfa291 ("bpf: Introduce fd_idx")
Signed-off-by: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
Link: https://lore.kernel.org/r/20260623-f01-13-pseudo-btf-id-cap-bpf-v2-1-a190ebb8f3e2@mails.tsinghua.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/disasm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/disasm.c b/kernel/bpf/disasm.c
index 7b4afb7d96db1..9661cce10689a 100644
--- a/kernel/bpf/disasm.c
+++ b/kernel/bpf/disasm.c
@@ -244,7 +244,10 @@ void print_bpf_insn(const struct bpf_insn_cbs *cbs,
 			 */
 			u64 imm = ((u64)(insn + 1)->imm << 32) | (u32)insn->imm;
 			bool is_ptr = insn->src_reg == BPF_PSEUDO_MAP_FD ||
-				      insn->src_reg == BPF_PSEUDO_MAP_VALUE;
+				      insn->src_reg == BPF_PSEUDO_MAP_VALUE ||
+				      insn->src_reg == BPF_PSEUDO_MAP_IDX ||
+				      insn->src_reg == BPF_PSEUDO_MAP_IDX_VALUE ||
+				      insn->src_reg == BPF_PSEUDO_BTF_ID;
 			char tmp[64];
 
 			if (is_ptr && !allow_ptr_leaks)
-- 
2.53.0



