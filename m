Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79E33C3437;
	Wed, 30 Sep 2026 19:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794882; cv=none; b=LYc+GjZJHNEt/wd3WYUwUzUlWrAXoWXVT5jf+gqQJ+fDnoWhNvnYdtSYWNJSdB/kWsSgsq68Kr6oeG4JOMU5ZFAScFRykG50l/VyXFFOvYleamd9+YvLyLHGclEouj6/XgXEn1pAZP4U1Bq91QJtWSccFY/sxEZqV6ynzUmYKzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794882; c=relaxed/simple;
	bh=M7Y0/GgDN4Df724cvJY2da5+kvB6hK+B93ceE+ft2vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4QP4RBCwDsG2FOouKY9LeX2wIg1pbkimSTR/n4D6LdyaGj9h3bnLtS/7289zunh1gP8TopWlwWt1xXQbE2Mw5jDvIr08Tzs1R5j677n07DQmTb8ZgQ6HyltcUCjLFh5gIVnvolvjMjdryAKaZhfpkN3FTREx4UYytBDO7SEt1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIkrI8Il; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIkrI8Il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB361F0089B;
	Wed, 30 Sep 2026 19:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794858;
	bh=+o7oV+l9qQGl6mkEpc+U0MJj2SLlm+zf0MGV6qsAjcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIkrI8Il/NKzs2e475bc7WCotvfdzlAsoriEGy/+tAhZ8D52MDR8pVlqgDVLm9cf4
	 qPycRHUggO3ZXyuWOZD/GDj4o3QsExNR3jwABjzVCvgeaKI24w2bqlcTVA4dpJrE9x
	 I2OpjKLzE0OlopGA9RLrSsJ9Ob3Bmdkh2FadcCJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0357/1193] bpf: Mask pseudo pointer values in verifier logs
Date: Wed, 30 Sep 2026 17:17:21 +0200
Message-ID: <20260930152442.100133774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 49940c26a2274..cc3c9792c4a61 100644
--- a/kernel/bpf/disasm.c
+++ b/kernel/bpf/disasm.c
@@ -287,7 +287,10 @@ void print_bpf_insn(const struct bpf_insn_cbs *cbs,
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



