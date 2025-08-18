Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB7627A44D;
	Mon, 18 Aug 2025 18:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543484; cv=none; b=VUlG2vucaGbIpVhqxzWo00k1h3B5tViPB0MHzEHZxxyoa+9Di/ObYo3H4Xb4m0DqG/3zH7VsOqlwAML8Ru+bBUDN1Fw1QcBNqqooXyib2zrUjIefFetRpWj7JqGnWRHhclPu6kmG4/17J+IkNju6jWFts2TWiPI/ZHXtPrW7+QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543484; c=relaxed/simple;
	bh=Lo/ub4li53YNr1WaIGrKXm3nOcZoyqX45dFKpUE/HGc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IYEa99pNlCAwABsJMs9IMmsEbl8cBa+xOabuImvUU6d95ttefoaoeHyy/9b94Tu997ia2Yq3UcZ+2DWr8ZBxTyFQD2w/L5YYCXwu3MmmbmKdkEaLlWZb3GwR4Ycm4sqlfxnEhdFxYsfY7aJPAraB+U5bK/Lkpz0YMGZ6eXzi/GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6e3LWLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6e3LWLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B057C4CEF1;
	Mon, 18 Aug 2025 18:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755543484;
	bh=Lo/ub4li53YNr1WaIGrKXm3nOcZoyqX45dFKpUE/HGc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Z6e3LWLqwJMq1KH+qj0/Fmu8yDb1BBX9t4FTH54hI4h973CZnTpMdQe0yFL/IH9tA
	 pCsSjXQo6APZddUNk0sy+2JT+p4C2qxmY791U2XOl3xcp+7M94oDFd68hAWk99eBnk
	 NPkceO3ksRPXfp7ZCgh8lhQOMQ7v3MLGRhXBoF43I8oCa2iHIZ3kHqbp+LrPZ4X/AH
	 uRG8bXG/fozVd8mjyYR/r0rex+Hr5EjOZHmgITuMF1sGZKgSoNXmhC5VjkQEz+0uKB
	 kvqdj+Ha5FSRV2uynB83jevrQFdWxurd7TSK/FoyQMRhWdAgM0fq63IJ81wAnKKPO5
	 8RvV5nFCkZ6DQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 18 Aug 2025 11:57:22 -0700
Subject: [PATCH 06/10] powerpc: Drop unnecessary initializations in
 __copy_inst_from_kernel_nofault()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250818-bump-min-llvm-ver-15-v1-6-c8b1d0f955e0@kernel.org>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1386; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Lo/ub4li53YNr1WaIGrKXm3nOcZoyqX45dFKpUE/HGc=;
 b=kA0DAAoWHWsmkXHAGpYByyZiAGijd6LIRMAmizf05GAFI656eYaM6oZfysm97od+caMT+X1qh
 Ih1BAAWCgAdFiEEe+MlxzExnM0B2MqSHWsmkXHAGpYFAmijd6IACgkQHWsmkXHAGpbCRQEAhZUJ
 c5moRU96wqS6sel3EZtjKLlCUhQfKQ+4rjjsf6AA/3YwNtKRMEcuUOZ/r8iucyJ4g/oC9S/y29F
 RkRUcIb0B
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, the zero initializations of val and suffix
added by commit 0d76914a4c99 ("powerpc/inst: Optimise
copy_inst_from_kernel_nofault()") to avoid a bogus case of
-Wuninitialized can be dropped because the preprocessor condition is
always false.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/inst.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/include/asm/inst.h b/arch/powerpc/include/asm/inst.h
index 684d3f453282..ffa82167c860 100644
--- a/arch/powerpc/include/asm/inst.h
+++ b/arch/powerpc/include/asm/inst.h
@@ -143,10 +143,6 @@ static inline int __copy_inst_from_kernel_nofault(ppc_inst_t *inst, u32 *src)
 {
 	unsigned int val, suffix;
 
-/* See https://github.com/ClangBuiltLinux/linux/issues/1521 */
-#if defined(CONFIG_CC_IS_CLANG) && CONFIG_CLANG_VERSION < 140000
-	val = suffix = 0;
-#endif
 	__get_kernel_nofault(&val, src, u32, Efault);
 	if (IS_ENABLED(CONFIG_PPC64) && get_op(val) == OP_PREFIX) {
 		__get_kernel_nofault(&suffix, src + 1, u32, Efault);

-- 
2.50.1

