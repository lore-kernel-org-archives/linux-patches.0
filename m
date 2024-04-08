Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CB52DF73;
	Mon,  8 Apr 2024 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581408; cv=none; b=TyhI90NJPhOh1ETV9ZieeS3vG2j7sjnn/zPx8bKzjejftaZURv1DdAdV4cNpmv4qTs0npfGZgsz8zDf89VWUGq04rtR2QVKDOh80Y6XruhHWrd0CtYbrTQ4xK2d1cVwabUlwsZcnZQYo1nzzGjrgFCSVfzTax7PRkRfLVO41mGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581408; c=relaxed/simple;
	bh=XomF1350aEMRrK+NIVkckI2nizc1T+yVJiEKg2R5Z2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHHZT4gyvsw3KGNcowg2kwTdsPm6NgSgHI2m+9zNKIKmARer22jjeF5ppFZSpE072QYVaeVaFjfyc1iNIxxOb68nvOOu7eMmvNgmNA/T3wbQe/nNV1FLs5O2aXrg1JYKvEzO0xvwUEF0r5xhYpSze8tG/98sGS+ONXaZRafQm+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyQJVMdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyQJVMdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30F7C433F1;
	Mon,  8 Apr 2024 13:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581408;
	bh=XomF1350aEMRrK+NIVkckI2nizc1T+yVJiEKg2R5Z2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyQJVMdcmfqX4Kb7hIkCAG81xC0Bsu7vB+x+S7g87M2Rc/V4+iIzsHIh0w6F1UqsV
	 Rr/up9ae8CZ5ZHHMEFV+nZ/jPAWpL8OMrNgV7N0osl/SgWokfGl6uqrlWw5hu6ZTzX
	 7M+FrTl557KBh0NbYoODdDJ+SKq7jgtzO3RWfEKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan-Benedict Glaw <jbglaw@lug-owl.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/690] powerpc/fsl: Fix mfpmr build errors with newer binutils
Date: Mon,  8 Apr 2024 14:48:32 +0200
Message-ID: <20240408125401.195517544@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



