Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1950E59D;
	Wed, 30 Sep 2026 16:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786521; cv=none; b=ikzH+KuZIobAE5OUjIdjkcAzb2uLrWp2k5ALr12pMM6Zsv8Hv3y+sdl0H4jCQN48/d9+ymrvJ9WZmSTK9Saa9l+8wJczhKuQj76xlcdo/N82h1rJ++GWj+iInELjpfWH5pMBdpMwA3zgm8tyleUZ5GBCRShHTO2STwUcnwkzhW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786521; c=relaxed/simple;
	bh=2Z4uHMcaCaTqk7vJww0IwV6NQtUNsaipXffTbJefhsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZByTCPZ0PVI4MJzNdoCxy09xRPt5sxL3nQor6xKQ1wvTqEtybmJDNn3i+0+3VVw6uZj8BWhEPTDcCq4+M2y+I7J/DAlBXLOhuhz8b3+lbsl9Cr94B7Lw6fh5pd7a5FLlyLlrCMrMRM0t/G1JpF/HhbCvjXNzbQZqGXXF3ZDvZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dufCjX3f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dufCjX3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A351F000FF;
	Wed, 30 Sep 2026 16:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786520;
	bh=nDzzGtM5NJC+aId6316jyyyViE66N7JJPEYSotfLvec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dufCjX3fbmMw5020DlPRfbMFrQ2iHF6mtm2qhT845lMFbFo6IYKhve5L58aZWkWh3
	 e4WXjFUEbiRcRebueIG/jvF6kqkPFcrlQapNruAVcAkLD5vN9R1ZPtrRpMgoC+7Cpi
	 yTUs2PIs/mfT3HU6W6apGZ6DXM2ergR5r3j79s24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 892/982] bpf: Fix immediate JMP JEQ/JNE on MIPS32
Date: Wed, 30 Sep 2026 17:27:08 +0200
Message-ID: <20260930152435.906179917@linuxfoundation.org>
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

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit db762fd96be225bd06161c9631160c755d891693 ]

An addu instruction was emitted instead of addiu, causing the immediate
value 1 to be interpreted as register $at. This made the comparison
result invalid when the immediate operand was negative. Note that $at
is mapped to BPF_REG_AX, which is used for constant blinding.

Fix the instruction to use the immediate form.

Found with test_bpf on MIPS32r1 emulated by QEMU.

Fixes: eb63cfcd2ee8 ("mips, bpf: Add eBPF JIT for 32-bit MIPS")
Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260923105158.3514342-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/net/bpf_jit_comp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/net/bpf_jit_comp32.c b/arch/mips/net/bpf_jit_comp32.c
index ace5db3fbd171..78f47c7b8d60d 100644
--- a/arch/mips/net/bpf_jit_comp32.c
+++ b/arch/mips/net/bpf_jit_comp32.c
@@ -1111,7 +1111,7 @@ static void emit_jmp_i64(struct jit_context *ctx,
 			emit(ctx, xor, tmp, lo(dst), tmp);
 		}
 		if (imm < 0) { /* Compare sign extension */
-			emit(ctx, addu, MIPS_R_T9, hi(dst), 1);
+			emit(ctx, addiu, MIPS_R_T9, hi(dst), 1);
 			emit(ctx, or, tmp, tmp, MIPS_R_T9);
 		} else {       /* Compare zero extension */
 			emit(ctx, or, tmp, tmp, hi(dst));
-- 
2.53.0



