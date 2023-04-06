Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432A7D533;
	Thu,  6 Apr 2023 21:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD712C433D2;
	Thu,  6 Apr 2023 21:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680815395;
	bh=QxQh52djmd4QpZTOVeRRXf4csbgTBpjj8+kNAabQFbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=crpU4TPXjn1qyF/0xzR1oP7iTi9/POyVX+GURM8VAeI49kevnmueHLsScAivxHT9Q
	 AiBbGy/PgWv6N+fk3a/z4ECtuPBd64mgTDEQnBd8QYPclrHCOujs0RS+B4+GzW32Lg
	 3ddBjXDzPcZXRuoWHdcvDGCi6v5d2CY89TFKfTebCni5j8Ckozmw6MvXhgrmcw/oN8
	 oS4fdGNlG7e1bRF2fyHyaxsaZq43adtsEVoMJBiO3I6RreAHXk8TgTViU1QBv/0P4A
	 JDTTddRzHY8S16oWQ6bW048pbH8X5qlo3VyRtjcX/tNEuv9kLPGNeEwwqV3VXZfFim
	 J5NTvSHLVle+g==
Date: Thu, 6 Apr 2023 14:09:53 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] MIPS: generic: Do not select CPUs that are unsupported
 in clang
Message-ID: <20230406210953.GA53516@dev-arch.thelio-3990X>
References: <20230406-mips-clang-generic-selects-fix-v1-1-811690c9fb69@kernel.org>
 <AAAAB6A1-81EE-42A8-84F7-CF8D0DA16456@flygoat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AAAAB6A1-81EE-42A8-84F7-CF8D0DA16456@flygoat.com>

On Thu, Apr 06, 2023 at 09:59:45PM +0100, Jiaxun Yang wrote:
> 
> 
> > 2023年4月6日 21:09，Nathan Chancellor <nathan@kernel.org> 写道：
> > 
> > When building allnoconfig with clang after commit de34007751aa ("MIPS:
> > generic: Enable all CPUs supported by virt board in Kconfig"), the
> > following error occurs:
> > 
> >  error: unknown target CPU 'r4600'
> >  note: valid target CPU values are: mips1, mips2, mips3, mips4, mips5, mips32, mips32r2, mips32r3, mips32r5, mips32r6, mips64, mips64r2, mips64r3, mips64r5, mips64r6, octeon, octeon+, p5600
> > 
> > Working around that, there are similar errors for 'loongson2e' and
> > 'loongson2f'.
> > 
> > These CPUs are not supported in clang/LLVM, so do not select support for
> > them in MIPS_GENERIC_KERNEL when building with clang.
> > 
> > Fixes: de34007751aa ("MIPS: generic: Enable all CPUs supported by virt board in Kconfig")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Thanks for the patch.
> 
> Actually there is no need for any special support for those CPUs.
> We should be able to build those kernels with -march=mips3.
> 
> I think something like:
> 
> --- a/arch/mips/Makefile
> +++ b/arch/mips/Makefile
> @@ -150,7 +150,7 @@ cflags-y += $(call cc-option,-Wa$(comma)-mno-fix-loongson3-llsc,)
>  #
>  cflags-$(CONFIG_CPU_R3000)     += -march=r3000
>  cflags-$(CONFIG_CPU_R4300)     += -march=r4300 -Wa,--trap
> -cflags-$(CONFIG_CPU_R4X00)     += -march=r4600 -Wa,--trap
> +cflags-$(CONFIG_CPU_R4X00)     += $(call cc-option,-march=r4600,-march=mips3) -Wa,--trap
>  cflags-$(CONFIG_CPU_TX49XX)    += -march=r4600 -Wa,--trap
>  cflags-$(CONFIG_CPU_MIPS32_R1) += -march=mips32 -Wa,--trap
>  cflags-$(CONFIG_CPU_MIPS32_R2) += -march=mips32r2 -Wa,--trap
> @@ -181,8 +181,8 @@ endif
>  cflags-$(CONFIG_CAVIUM_CN63XXP1) += -Wa,-mfix-cn63xxp1
>  cflags-$(CONFIG_CPU_BMIPS)     += -march=mips32 -Wa,-mips32 -Wa,--trap
>  
> -cflags-$(CONFIG_CPU_LOONGSON2E) += -march=loongson2e -Wa,--trap
> -cflags-$(CONFIG_CPU_LOONGSON2F) += -march=loongson2f -Wa,--trap
> +cflags-$(CONFIG_CPU_LOONGSON2E) += $(call cc-option,-march=loongson2e,-march=mips3) -Wa,--trap
> +cflags-$(CONFIG_CPU_LOONGSON2F) += $(call cc-option,-march=loongson2f,-march=mips3) -Wa,--trap
>  # Some -march= flags enable MMI instructions, and GCC complains about that
>  # support being enabled alongside -msoft-float. Thus explicitly disable MMI.
>  cflags-$(CONFIG_CPU_LOONGSON2EF) += $(call cc-option,-mno-loongson-mmi)
> 
> Will make them build.

Thank you for taking a look and the suggestion! I applied it and tried
to build allnoconfig but I get

  error: ABI 'o32' is not supported on CPU 'mips3'

immediately, which could certainly be a bug in clang...

Cheers,
Nathan
