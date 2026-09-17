Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039894D1786;
	Thu, 17 Sep 2026 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668617; cv=none; b=dLX6UtVcH3YUs+IxlV8lGDcwIg4TJn1M8IBNqzYIXaoybur4aoNF/+dJFKoNbqEHm3r3pr2SSrCifc+XlNJXIyvC8CklmYJoOGN2m8LfZcAHbIRcm2YU2t0wCUGM54NN+oy80g640Gd1RQTVkbXFQbWOncKsVbnVGqwr8lzHdgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668617; c=relaxed/simple;
	bh=pBBAFKGoRGZu2enuXTFOcqO0JP5rQd/SPagEw48Xit0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Os1yGXvOVz2dWFNB0UK6vIjH4t063cPBYPu0uzwNBcMv+mudmUNrKdYOQUJIt0AISrJ3oiqmtOByM8h5eLL2UcL/qwTKYkS/aw3fodW9hX1tC+/wh9IFf8xGzyFDMMmtOH0rbKab1URhLP0uGqzRxW1bKPWm4XlA8k006rf5UwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBiqugLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBiqugLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B331F000FF;
	Thu, 17 Sep 2026 18:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668615;
	bh=3OdkDuaDSud6gPmeesx8bUH+8MMQSJknna/E2YwpVAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBiqugLgHkmz2tmQQwoUsdBuji25IrXTu8mBDOYZBLg/YOf1NYqphavWjYde23vQb
	 DwM/SUTZxP6p3lsW7FLj7YDjKaUFCt2sHXnSZjQzQIUK7q7rrFq4fBZvJ7vJdC2fHv
	 9MNY1Etuc3uvBGl5PKfcB3W2P6xXUoBfsW7/VV1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0484/1102] bpf: Mask pseudo pointer values in verifier logs
Date: Thu, 17 Sep 2026 16:07:07 +0100
Message-ID: <20260917151551.849569722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 309c4aa1b026a..dfcaffa14d049 100644
--- a/kernel/bpf/disasm.c
+++ b/kernel/bpf/disasm.c
@@ -311,7 +311,10 @@ void print_bpf_insn(const struct bpf_insn_cbs *cbs,
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



