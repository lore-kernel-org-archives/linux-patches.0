Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A385370D6D;
	Thu, 17 Sep 2026 17:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665073; cv=none; b=Fvw1DPHquzhCU+0rDpsVnhFHVCzDGopzwS718jnydW6z8O4M2d0Wd7w0bDjdIv0TG/mqN+aSjK3cuboQwKP3YIH7SJumJMuPn49NrvBaNcIIUMsYtRmbzlpMEu7y3UQIfJ0bdCKMOBnhUwDLqWgUCp3/R4LHEjWQxTDvocIJh8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665073; c=relaxed/simple;
	bh=uegayGGWDAWBv0ADLnF7Xo/YlnP9vWRWW4+JBRyDhQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYosC7+CWdFUP5uYbF3lpOpARbzFCFNkUInAvX8O+mfOCrKFzMbBZBsThr1kYVPxaSt4GJsRkMqQANQwfS2jKZByDHhSLm9t8dUz4LFSeMYiZ7QjwTVsHpj5SMoS/R5NbmFnEn5JZb8z2ye02yeneQnYnrYydo52x+oXWmUXYH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xo8NOH/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xo8NOH/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D4D1F00893;
	Thu, 17 Sep 2026 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665071;
	bh=kSbnl+7WgizQmccsJ2lF302g/ULlILBDrPDcfVfcWxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xo8NOH/7BInH6ko0SvSOtm7nwL/T6nPPufiigYV2iGJyoNpkxLHtIaTEFXd1P1VAn
	 xJdCbJF3pB2tnlF7MSZdphBWB72yhhwDdsDlWY1xwqcwLagbwsrkGBoutn484jewWj
	 XB1uJ0YioEgZedILNmYCYVoiyENj3uk+/U3uED5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0583/1250] bpf: Mask pseudo pointer values in verifier logs
Date: Thu, 17 Sep 2026 16:06:18 +0100
Message-ID: <20260917151607.690317196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 20883c6b1546c..f52c174f2dbb1 100644
--- a/kernel/bpf/disasm.c
+++ b/kernel/bpf/disasm.c
@@ -323,7 +323,10 @@ void print_bpf_insn(const struct bpf_insn_cbs *cbs,
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



