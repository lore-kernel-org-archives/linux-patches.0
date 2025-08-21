Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4E12D837C;
	Thu, 21 Aug 2025 21:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810972; cv=none; b=TBfgo5iGKUgRMGoU7x5Riyuwec0DWU4byXULExdSRpjxouVlUJFX2UjguKuUin38NFicKF9lfrZu1DZHe8euOu6TBM9ZBztpWaxOiLJDjukQ8Fmc+DSw/4ZoTg0w8eE70nbt/CDoRzIv375a6B1uB4SWTDgV1hwj6hY5qhYRz2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810972; c=relaxed/simple;
	bh=VGQQUffBKqpf2H5DeF+t1nkRASxbDSX8NAduqgnqPbk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GsG4qENjOjNsnHTFyQ1K2VeSjsAvkuKoRZDZoVUIm9EQeaNu/LNBCcF5CyCzxH3NBSJIlieaYF4/crl2d3SJFU8R2q62zSnFRVIPY8XKOg1zd5IIhhM81rleJ6o4PMKpshKUzzODKAtTkmotoBPLpZrQ1/TqtEE4kShUbaSkHkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dz2OPjIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dz2OPjIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B20C4AF09;
	Thu, 21 Aug 2025 21:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810971;
	bh=VGQQUffBKqpf2H5DeF+t1nkRASxbDSX8NAduqgnqPbk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Dz2OPjICxh9rvlzA1oWyJydNTsN/KJBpcD7R933teboo6pz8NFaVzKPhAChC6iq14
	 FwZnGeeGI/9IqZwDuekx0JxcfFlgk2m73gb3cbvgr/nkAL+/Mg1Y8rdY/PTe+N3Uxo
	 RFVAWKLCZ5u7zg7/ms8djejWF8uS3pooOaJQWCKbb15NP9zuGmRF9yE0uNm4OEjijK
	 ChWjQMcqGP1FVnGCzYp7jNth24enrwHFLvlWNebGOlivrf8w/vR+Rylnm66O9m5Uiy
	 4XGUGj1CcmaoPPaukJSj7GFSkaJ2KBpDKlWqFmacbPF5eOUZKyupGpI6tHeo6pBwS5
	 hQqW0+uVafABA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 14:15:43 -0700
Subject: [PATCH v2 06/12] powerpc: Drop unnecessary initializations in
 __copy_inst_from_kernel_nofault()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-bump-min-llvm-ver-15-v2-6-635f3294e5f0@kernel.org>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1428; i=nathan@kernel.org;
 h=from:subject:message-id; bh=VGQQUffBKqpf2H5DeF+t1nkRASxbDSX8NAduqgnqPbk=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnLe5qsbnOnbElI2r/nStGKR7NVeD9fqqrOF4jTmqh6p
 HPr5fYHHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAie3IZGRpyXQzenGP5fUO5
 OWj37vqDApfD321/ON+1kq+JScZ2uiwjw8b/k05Y3dU1+vnpp/ZK+3d165qdtCziv4Vo3fZM1Zj
 nxggA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, the zero initializations of val and suffix
added by commit 0d76914a4c99 ("powerpc/inst: Optimise
copy_inst_from_kernel_nofault()") to avoid a bogus case of
-Wuninitialized can be dropped because the preprocessor condition is
always false.

Reviewed-by: Kees Cook <kees@kernel.org>
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

