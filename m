Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464713A6B7A;
	Thu, 16 Apr 2026 23:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776382635; cv=none; b=VlF/T2DEAAbtM9leui5E2E5ZmPi+T5H2j+XzKMXROyxikKzD1oppniHJhlczONfjoHKFxPMV7ubg9rHQas/k0Ld2tWX8584nmZghQuhW5r2OUi6F58u/Cx5p1jv+WXb4Cc8JveG4IDzjpdD/A40yu0D4vVfJI/9KuvHzPj3BNNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776382635; c=relaxed/simple;
	bh=GW5/+NpIhNRfKz0Natu09b2YnTkxIzuoHQWQKYAyVP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obfAVxdN+bo6x9ff8QMGIjIOx4jnbqUOBjIts7sSgs+z8EsWDM1/F6f8bSDG+RcBvWmMt3bmZNNh5JKIEyq0/pLa6Dd5/iKmZ2XinZLeI7KUdgwDixlBsqaA/ub0q9xVoA1UPLcUuNyckJZA7oRH0pGg+HtLwr6JFXidlgc6b5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qdsqtQp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qdsqtQp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1764DC2BCB3;
	Thu, 16 Apr 2026 23:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776382634;
	bh=GW5/+NpIhNRfKz0Natu09b2YnTkxIzuoHQWQKYAyVP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qdsqtQp+zeYDmRuIN8cgQYW0kUIYUoDJ0a8w+B6Pwr8F+y2oeHn0QNsrmcZeZBmkU
	 IThMKQ9X9R1Q6h10hyxAjLkSCrNwu/ia76ou2GmaCeIXj5RQEs0YBsgvf7U7bm/Noy
	 E3cbvTJ0l7oMOu7nlwfA8aXD/Fj1jE5h0eSOmIdcJ2CXbjBjXNlTzLavyb0npaulI9
	 D9q9hjJjgU0Q9WSm1Lw7KpfTCWNT8v4466EqEw2t8dv4Gqio6C3otp9AMEZUfOGI+g
	 Vku4wJmIHFo2KIOfVc9NYf4OrWsg1KDdHB+kXugIagozHSF+0U/qohcfuI1V5iCW58
	 kfX7xL7le9vwg==
Date: Thu, 16 Apr 2026 16:37:10 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Hari Bathini <hbathini@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] powerpc/vdso: Drop -DCC_USING_PATCHABLE_FUNCTION_ENTRY
 from 32-bit flags with clang
Message-ID: <20260416233710.GA581965@ax162>
References: <20260311-ppc-vdso-drop-cc-using-pfe-define-clang-v1-1-66c790e22650@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-ppc-vdso-drop-cc-using-pfe-define-clang-v1-1-66c790e22650@kernel.org>

Ping? This patch is pretty simple and fixes many build warnings since
inline is used many times in this file. I can take this via my
clang-fixes tree with an appropriate ack if that would be easier.

On Wed, Mar 11, 2026 at 05:39:56PM -0700, Nathan Chancellor wrote:
> After commit 73cdf24e81e4 ("powerpc64: make clang cross-build
> friendly"), building 64-bit little endian + CONFIG_COMPAT=y with clang
> results in many warnings along the lines of:
> 
>   $ cat arch/powerpc/configs/compat.config
>   CONFIG_COMPAT=y
> 
>   $ make -skj"$(nproc)" ARCH=powerpc LLVM=1 ppc64le_defconfig compat.config arch/powerpc/kernel/vdso/
>   ...
>   In file included from <built-in>:4:
>   In file included from lib/vdso/gettimeofday.c:6:
>   In file included from include/vdso/datapage.h:15:
>   In file included from include/vdso/cache.h:5:
>   arch/powerpc/include/asm/cache.h:77:8: warning: unknown attribute 'patchable_function_entry' ignored [-Wunknown-attributes]
>      77 | static inline u32 l1_icache_bytes(void)
>         |        ^~~~~~
>   include/linux/compiler_types.h:235:58: note: expanded from macro 'inline'
>     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
>         |                                                          ^~~~~~~
>   include/linux/compiler_types.h:215:34: note: expanded from macro 'notrace'
>     215 | #define notrace                 __attribute__((patchable_function_entry(0, 0)))
>         |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   ...
> 
> arch/powerpc/Makefile adds -DCC_USING_PATCHABLE_FUNCTION_ENTRY to
> KBUILD_CPPFLAGS, which is inherited by the 32-bit vDSO. However, the
> 32-bit little endian target does not support
> '-fpatchable-function-entry', resulting in the warnings above.
> 
> Remove -DCC_USING_PATCHABLE_FUNCTION_ENTRY from the 32-bit vDSO flags
> when building with clang to avoid the warnings.
> 
> Fixes: 73cdf24e81e4 ("powerpc64: make clang cross-build friendly")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/powerpc/kernel/vdso/Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
> index 8834dfe9d727..368759f81708 100644
> --- a/arch/powerpc/kernel/vdso/Makefile
> +++ b/arch/powerpc/kernel/vdso/Makefile
> @@ -62,6 +62,12 @@ CC32FLAGSREMOVE += -fno-stack-clash-protection
>  # 32-bit one. clang validates the values passed to these arguments during
>  # parsing, even when -fno-stack-protector is passed afterwards.
>  CC32FLAGSREMOVE += -mstack-protector-guard%
> +# ftrace is disabled for the vdso but arch/powerpc/Makefile adds this define to
> +# KBUILD_CPPFLAGS, which enables use of the 'patchable_function_entry'
> +# attribute in the 'inline' define via 'notrace'. This attribute is not
> +# supported for the powerpcle target, resulting in many instances of
> +# -Wunknown-attributes.
> +CC32FLAGSREMOVE += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
>  endif
>  LD32FLAGS := -Wl,-soname=linux-vdso32.so.1
>  AS32FLAGS := -D__VDSO32__
> 
> ---
> base-commit: 35e4f2a17eb40288f9bcdb09549fa04a63a96279
> change-id: 20260311-ppc-vdso-drop-cc-using-pfe-define-clang-46d6f5041544
> 
> Best regards,
> --  
> Nathan Chancellor <nathan@kernel.org>
> 
