Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94C9D2F2;
	Tue,  4 Apr 2023 21:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0C7C433D2;
	Tue,  4 Apr 2023 21:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680643132;
	bh=Bd4XozHHNDWmhLnBLuJFvVK1v9kbAVXUGqJsndz1hUw=;
	h=From:Date:Subject:To:Cc:From;
	b=SHm+jHvIL+nwT3sGQ7w7RrxuYhhvNnO1wYO41r8cWb/e/IQ8YBqedTAceDFXZN53j
	 pdmFBKR/cDKAzEYP6Ckke2aOje4SkPgi9a7rR6812TWACTfbTeTaNXe1HrVU5bg0nI
	 HXRsbNbnX51JCMqja7Cr9i0KEX0ArTClM1GTTbq4x0xsBh+jRVowVg9sw98/HVC0DA
	 qNECAbmY/OwGwVZQD/uwVbxBp2dEhdnxHC8RGqs5qEt6LcR8aMLpdwJSWZqp0wokDn
	 KbAcipeLtGosFxvy2g1RCm+qGRunhc4C5MeDAIFxkwXmkTIlUZhaCojtqkx99s9fRY
	 uAudrgMRg9YDA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 04 Apr 2023 14:18:41 -0700
Subject: [PATCH] MIPS: Drop unused positional parameter in
 local_irq_{dis,en}able
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230404-mips-unused-named-parameters-v1-1-71d6c656f1de@kernel.org>
X-B4-Tracking: v=1; b=H4sIADCULGQC/x2NwQrDMAxDf6X4PEOaFgb7lbGD07itD8mCvY5B6
 b/P7UVCSDztYKzCBo9uB+WvmLyrh/7WwbRSXRgle4YY4hDGMGKRZrjVzThjpeLaSN0/rIZpiHm
 +90Q5EzgikTEmpTqtJ6SQ+ewsmvIsv+v3+TqOPwL0IpmHAAAA
To: tsbogend@alpha.franken.de
Cc: ndesaulniers@google.com, trix@redhat.com, linux-mips@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1819; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Bd4XozHHNDWmhLnBLuJFvVK1v9kbAVXUGqJsndz1hUw=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCk6U6zVPj+I1fCY7nrq+RL+m1M57xwsSrjo+Wfjwd2tu
 SfvRmns7ihlYRDjYJAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQATSWJh+F/hmX2ouL+gwXaL
 8ynVTg9FJmn+aXwrV2799GD6s2T2h3IM/+t4yn68fMezdaH/bMZ37UfnvVpTuj+8tH1L9COhQ2+
 61FkB
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with clang's integrated assembler, it points out that the
CONFIG_CPU_HAS_DIEI versions of local_irq_enable and local_irq_disable
have a named parameter that is not used in the body of the macro and it
thinks that $8 is a positional parameter, rather than a register:

  arch/mips/include/asm/asmmacro.h:48:2: warning: macro defined with named parameters which are not used in macro body, possible positional parameter found in body which will have no effect
   .macro local_irq_enable reg=$8
   ^

The comment above the function that performs this check in LLVM notes
that the warning may trigger in this case, even though it is not
problematic. It is easy enough to clean this up by just omitting the
named parameter for this version of the macro, as it is entirely unused.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1415
Link: https://github.com/llvm/llvm-project/commit/81c944cadb7f9e55b3517b7423a820e2577b9279
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/mips/include/asm/asmmacro.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/asmmacro.h b/arch/mips/include/asm/asmmacro.h
index 1c4438f3f2ab..067a635d3bc8 100644
--- a/arch/mips/include/asm/asmmacro.h
+++ b/arch/mips/include/asm/asmmacro.h
@@ -45,12 +45,12 @@
 #endif
 
 #ifdef CONFIG_CPU_HAS_DIEI
-	.macro	local_irq_enable reg=t0
+	.macro	local_irq_enable
 	ei
 	irq_enable_hazard
 	.endm
 
-	.macro	local_irq_disable reg=t0
+	.macro	local_irq_disable
 	di
 	irq_disable_hazard
 	.endm

---
base-commit: 101f26c72825c5dba1dfe826e4202a9a04b435c6
change-id: 20230404-mips-unused-named-parameters-b32df71aadda

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

