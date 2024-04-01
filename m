Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAD11E86C;
	Mon,  1 Apr 2024 16:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989517; cv=none; b=M+ZswP/8o/yC/KzSPKmjUPCCk9z31Gs79+VuEqDeOXIbdLgqx8v/CNMv9+GE4Y/BMXbrYpMcbkCNRI4Q+Aaf9eZBAC4xd31yqWJLirlP0LcsI57oDD19WothRPkeLbHk8AuQwZOxhSuRWWQ18SgmvKQr96kN4QF4Bda1lfjKgOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989517; c=relaxed/simple;
	bh=UZAm8W/HhUHetzB6gxul5PrTbP5oE3rNfH4pWWJ4poI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDNH5JbJo75gIlCOGX+5pS7f/qEESxO+10youp0Qs3z8prmMuqFAJ53RKVerb53msPb77aQtwa+QaO82l4ToTaWZeC0z3Z6Yzi9zv52LfxMti+uqZ8aY65AOquInfIHfqcy38wuqIC3fHLkVZCTT0HQdm6+YS+MADjVAcFW2ZCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bf1hKnUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bf1hKnUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1B9C433F1;
	Mon,  1 Apr 2024 16:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989517;
	bh=UZAm8W/HhUHetzB6gxul5PrTbP5oE3rNfH4pWWJ4poI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bf1hKnUp1EPmFlzo0AwdfUZG2UI39oUw8kocSfBzJW7z1TaXPqJdeigs+sTkSUYOU
	 I6H4iODgqppHAF1V4qR+WoJ0KYjBwsoC2TidJ3snfvXeRrIoxUM2ifhEbpuhPsZIg8
	 hgewAKjaZbKKTHym8y0aZgGb/2AZT8nNHXDDtC10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan-Benedict Glaw <jbglaw@lug-owl.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/396] powerpc/fsl: Fix mfpmr build errors with newer binutils
Date: Mon,  1 Apr 2024 17:42:02 +0200
Message-ID: <20240401152550.097628182@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 5f491356b7149564ab22323ccce79c8d595bfd0c ]

Binutils 2.38 complains about the use of mfpmr when building
ppc6xx_defconfig:

    CC      arch/powerpc/kernel/pmc.o
  {standard input}: Assembler messages:
  {standard input}:45: Error: unrecognized opcode: `mfpmr'
  {standard input}:56: Error: unrecognized opcode: `mtpmr'

This is because by default the kernel is built with -mcpu=powerpc, and
the mt/mfpmr instructions are not defined.

It can be avoided by enabling CONFIG_E300C3_CPU, but just adding that to
the defconfig will leave open the possibility of randconfig failures.

So add machine directives around the mt/mfpmr instructions to tell
binutils how to assemble them.

Cc: stable@vger.kernel.org
Reported-by: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240229122521.762431-3-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/reg_fsl_emb.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/reg_fsl_emb.h b/arch/powerpc/include/asm/reg_fsl_emb.h
index a21f529c43d96..8359c06d92d9f 100644
--- a/arch/powerpc/include/asm/reg_fsl_emb.h
+++ b/arch/powerpc/include/asm/reg_fsl_emb.h
@@ -12,9 +12,16 @@
 #ifndef __ASSEMBLY__
 /* Performance Monitor Registers */
 #define mfpmr(rn)	({unsigned int rval; \
-			asm volatile("mfpmr %0," __stringify(rn) \
+			asm volatile(".machine push; " \
+				     ".machine e300; " \
+				     "mfpmr %0," __stringify(rn) ";" \
+				     ".machine pop; " \
 				     : "=r" (rval)); rval;})
-#define mtpmr(rn, v)	asm volatile("mtpmr " __stringify(rn) ",%0" : : "r" (v))
+#define mtpmr(rn, v)	asm volatile(".machine push; " \
+				     ".machine e300; " \
+				     "mtpmr " __stringify(rn) ",%0; " \
+				     ".machine pop; " \
+				     : : "r" (v))
 #endif /* __ASSEMBLY__ */
 
 /* Freescale Book E Performance Monitor APU Registers */
-- 
2.43.0



