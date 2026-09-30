Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADD8515982;
	Wed, 30 Sep 2026 16:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787321; cv=none; b=ibU6gt24I0MQx/MsXreD2p7hlrWtFTjL6cGTDuuXLJFm1VC0mLy91cghl541+ms0yMvRb2vIBpNtsz6apVBoocrXtcHMfRZOwAY9vBfmj1McDHMGVKF4Br/yxUIoX1mHvknE0j0Cblb+pSftCDoZ4xWGEPS0lNLP6GzUnYUPvak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787321; c=relaxed/simple;
	bh=nYCh5DRwAeRgD+FoTur2WhFaP1YRHbLOv/tpz4cxBtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtM/IQxB1IaSmuc8XY7y5VOINI54MKgsKD/zFgYVoNhk/l5BaAt4P1rJfEiWeXJ/ux4z+7RxGqQgeTDI7UaRToVUFLXNlgGIze7qM10nEwGOjVSjuGjHijtI4WOV/DHReoTWLY+teFcUsI+CcwoiXE4VEcNZY7BLi7xvw0MpgeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEH/cv7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEH/cv7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3B91F00899;
	Wed, 30 Sep 2026 16:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787319;
	bh=4wt5jbGxi7IW39KgQN0fOn5Mb0o/yNFuRdabPWbpLl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEH/cv7zM04zmjOPM5csjPZh/zFiGsI6BCQeFhnO+NrHyujHDfCk61iij21tx7a7Y
	 aLQll9UkbSXW8NJ8U6XMmQSheNO8BYblPl3PGUpHZM4xMGASqabKBixAfRHx5GwitK
	 q2IUBuUoOKCwLJuhXtoesbyKqsdqkhPGp6WaL50Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 188/457] bpf: Fix immediate JMP JEQ/JNE on MIPS32
Date: Wed, 30 Sep 2026 17:24:53 +0200
Message-ID: <20260930152350.108931116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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



