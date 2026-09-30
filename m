Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9F63E3156;
	Wed, 30 Sep 2026 19:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796838; cv=none; b=EyFkrdEwiaC1z+kmpjvLqOErs0yT+PLpA+Uz7358sK0ziwsyzTzy0Xi546pYb1nFXfDb2+jmKaRme4wjukv9Jwk+5Uu5ae0ehPZ1j1B0kCuypVmSULDYRmUaHg79STHOQaPZ4aCWImbAfBZVgb1EJ0w1exeZLUXkwqFizSWyly0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796838; c=relaxed/simple;
	bh=ky1YjUQTxRYz8tz3Nz+yOc0GtssHd/GN9552NS8ZD8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmZhf8JVMurVGvd+q5UCK+Qm5qu0/q9ScXBpDP+saflX6zAMWpM2MKGGO2kzSUUYccnrGO29mFhCtrLXettRY0WyJWdZdUySt3w/HHcH3Occ9MAm7DyqIAOVbr+ZNKcaUN/XlAgumj4ycptEeEMcgoaBPYn8VjFjyG+/nmRhYWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNkls6uV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNkls6uV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546431F000FF;
	Wed, 30 Sep 2026 19:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796836;
	bh=Ey5CjbOrA/tNJUNxnKrDApPumY2gkm14qQE/CG6X7VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNkls6uVjBWKrTyMF2I2aINl0RozB7BEPPM0KFR5lwV6xaw1Sx4IxtWSslNW/AJHF
	 8xapyj5NpFCYdpx6yCe5F27AmHLG70PEJhNYDBJ1bQhCqOj1aUlwyh4jnIinF1dZcK
	 wjYmxU7gNtuBRvcEC8M7jFnTOwlq0cX7GJUeDcQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1055/1193] bpf: Fix immediate JMP JEQ/JNE on MIPS32
Date: Wed, 30 Sep 2026 17:28:59 +0200
Message-ID: <20260930152457.665993015@linuxfoundation.org>
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



