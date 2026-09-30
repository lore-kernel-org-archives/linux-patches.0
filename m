Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEA551A15C;
	Wed, 30 Sep 2026 17:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789273; cv=none; b=E+xUsEBURjkhrZUXjJwky8Mb5+h5CMtmbjSe/CJ89KG/YaP3noLmtHaN+vO43nUxRzfMNbZDDHTsNmOult2NuoZtND+uUR9W0P+FdRciv6CeYV8ZWhuscgt90ZG3tuOwyAQH7eaYf0v3QRZY7fcMY6H5jJrsh5nUHcI4yK/hr9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789273; c=relaxed/simple;
	bh=x9apWKP6akWGbbOapaU+WauGuWbJahuw/GT6mUCBBGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvoxRlNsp0Nd5Uy9KboTgK6OYid8oMQBHP8yeSPTD9FYwzzL8Mis1qAiNnx5KYHKt9QJQZQEYquNyG4h+IHAW3Ok/2Ps9gShtaavlfA1e6PJUxYKBCB0ggHF2drNPGc/ls0o+gBZ2QziwwNUwI54WH4NtVtnyjsq0mFpFWWar5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LOkRyyL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LOkRyyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B734D1F0089B;
	Wed, 30 Sep 2026 17:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789272;
	bh=iz3nErTb2hcPFSbuSJfdcpiq8FYBLNCCFVFgMjDw2Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LOkRyyLTlaYUbzVsdgyhQ3nf+MNZaWDO4iWGNP7Ef/bDUYxucsyIKsk4xHQYmfSH
	 PtO+G/ugOZSEfZ1NDHjH3T9rqXbw63JSVEKjl3kT9MmjuYSAZPpXDnihaiu6oqoRom
	 D6dMeHruWAv97VwoaUqS/gbUjqmaJJ4TmYqf1wqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 419/877] bpf: Fix immediate JMP JEQ/JNE on MIPS32
Date: Wed, 30 Sep 2026 17:22:10 +0200
Message-ID: <20260930152423.732470018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 40a878b672f5d..15a2a153dc873 100644
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



