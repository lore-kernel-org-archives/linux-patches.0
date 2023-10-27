Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D7C1EA8F;
	Fri, 27 Oct 2023 13:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXM/s95R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EC4C433C9;
	Fri, 27 Oct 2023 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698414332;
	bh=ctevIIpLyVC49UXwtFvJ8Z9qJet2+sIlcT00CIKauHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZXM/s95RNAO3hdB6ImpM3BP6MfNtxr6WVBF2C+iXJAcXFbvDTYAj4+4ClcSp0XDCS
	 rX3ijKSNwDz26WSrGCxoCFz5gdekhtZyJzC/Gj3k1iw4Q30ljSsKQPgqqmw6fTHdPs
	 nOGxOID1BgyJnuC1uZHQY7xGRl0TNsLQQvxNcIdIbNiCOoBaCJ1PLqfjZKRXOJ479P
	 lZbFCNvLxtvqTYFo06CgkMakHkrkM6eYKksyw2i92zXdi32GemWcWQDLCIgGHnQjiA
	 J+ehM1gEqJypAHKey6A6u1XpDCycaka1QIMsF51Ka+KiEQ42AgFe76+ba2Mma/InAh
	 8PmcrKHljIwEg==
Date: Fri, 27 Oct 2023 14:45:27 +0100
From: Conor Dooley <conor@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	ndesaulniers@google.com, trix@redhat.com, samitolvanen@google.com,
	twd2.me@gmail.com, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v4] RISC-V: build: Allow LTO to be selected
Message-ID: <20231027-disband-return-3a26708d772f@spud>
References: <20231017-riscv-lto-v4-1-e7810b24e805@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pnuOxGeoAc0cPDnR"
Content-Disposition: inline
In-Reply-To: <20231017-riscv-lto-v4-1-e7810b24e805@kernel.org>


--pnuOxGeoAc0cPDnR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Nathan,

On Tue, Oct 17, 2023 at 03:21:04PM -0700, Nathan Chancellor wrote:
> From: Wende Tan <twd2.me@gmail.com>
>=20
> Allow LTO to be selected for RISC-V, only when LLD >=3D 14, since there is
> an issue [1] in prior LLD versions that prevents LLD to generate proper
> machine code for RISC-V when writing `nop`s.
>=20
> To avoid boot failures in QEMU [2], '-mattr=3D+c' and '-mattr=3D+relax'
> need to be passed via '-mllvm' to ld.lld, as there appears to be an
> issue with LLVM's target-features and LTO [3], which can result in
> incorrect relocations to branch targets [4]. Once this is fixed in LLVM,
> it can be made conditional on affected ld.lld versions.
>=20
> Disable LTO for arch/riscv/kernel/pi, as llvm-objcopy expects an ELF
> object file when manipulating the files in that subfolder, rather than
> LLVM bitcode.
>=20
> [1] https://github.com/llvm/llvm-project/issues/50505, resolved by LLVM
>     commit e63455d5e0e5 ("[MC] Use local MCSubtargetInfo in writeNops")
> [2] https://github.com/ClangBuiltLinux/linux/issues/1942
> [3] https://github.com/llvm/llvm-project/issues/59350
> [4] https://github.com/llvm/llvm-project/issues/65090
>=20
> Tested-by: Wende Tan <twd2.me@gmail.com>
> Signed-off-by: Wende Tan <twd2.me@gmail.com>
> Co-developed-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Testing notes from Nathan:
>=20
> I tested LLVM 14 through 18 with defconfig + full/thin LTO and
> allmodconfig + thin LTO. allmodconfig + thin LTO with LLVM 15 and 16
> shows
>=20
>   ld.lld: error: section size decrease is too large
>=20
> when linking vmlinux. This appears to be resolved in LLVM 17 with
> https://github.com/llvm/llvm-project/commit/9d37ea95df1b84cca9b5e954d8964=
c976a5e303e
> (I did not bisect but the commit message lines up with the issue). I
> kept the existing version check because defconfig worked fine but we may
> want to bump it to 17.0.0 if randconfigs trip over this.
>=20
> v4 now boots in QEMU for me with both full and thin LTO.
>=20
> Testing notes from Wende:
>=20
> I have tested enabling LTO for `defconfig`. The LLD took ~2m21s and ~3GiB
> on our Intel Xeon Gold 6140 server and produced an 18MiB Image. The image
> can boot to shell using an archriscv rootfs on QEMU.
>=20
> I have also tested it for `allyesconfig` without COMPILE_TEST, FTRACE,
> KASAN, and GCOV. The LLD took ~7h03m and ~335GiB on the server,
> successfully producing a 1.7GiB Image. Unfortunately, we cannot boot this
> image because the `create_kernel_page_table()` -> `alloc_pmd_early()` ->
> `BUG_ON()` logic limits the image to be < 1GiB. Maybe we can fix it in a
> separate patch further.
>=20
> Changes in v4:
> - Pass '-mattr=3D+c' and '-mattr=3D+relax' to ld.lld via '-mllvm' flags w=
hen
>   doing LTO due to LLVM not appearing to honor target-features when
>   performing LTO, which can result in incorrect branch targets. This
>   fixes boot with CONFIG_LTO_CLANG=3Dy with LLVM 15.0.0+.
> - Tidy up commit message and move testing notes to below the fold, as it
>   is not too relevant to the git history and it makes the rest of the
>   message more of an imperative mood.
> - Link to v3: https://lore.kernel.org/r/20231003-riscv-lto-v3-1-8aca61a4e=
cb4@kernel.org
>=20
> Changes in v3:
> - Disable LTO in arch/riscv/kernel/pi/Makefile, which was added to the
>   kernel after the submission of v2. This change matches arm64.
> - Link to v2: https://lore.kernel.org/r/20220512205545.992288-1-twd2.me@g=
mail.com/
>=20
> Changes in v2:
> - Some textual changes suggested by Nick.
> - Drop the changes to `arch/riscv/Makefile`, since the LLVM issue is
>   filed and resolved.
> - Drop the unnecessary changes to `arch/riscv/kernel/vdso/Makefile`.
> - Link to v1: https://lore.kernel.org/r/20210719205208.1023221-1-twd2.me@=
gmail.com/
> ---
>  arch/riscv/Kconfig            | 3 +++
>  arch/riscv/Makefile           | 5 +++++
>  arch/riscv/kernel/pi/Makefile | 3 +++
>  3 files changed, 11 insertions(+)
>=20
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index d607ab0f7c6d..523640f7441e 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -46,6 +46,9 @@ config RISCV
>  	select ARCH_SUPPORTS_CFI_CLANG
>  	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
>  	select ARCH_SUPPORTS_HUGETLBFS if MMU
> +	# LLD >=3D 14: https://github.com/llvm/llvm-project/issues/50505
> +	select ARCH_SUPPORTS_LTO_CLANG if LLD_VERSION >=3D 140000
> +	select ARCH_SUPPORTS_LTO_CLANG_THIN if LLD_VERSION >=3D 140000
>  	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
>  	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
>  	select ARCH_USE_MEMTEST
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 1329e060c548..709400ceac60 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -52,6 +52,11 @@ ifndef CONFIG_AS_IS_LLVM
>  	KBUILD_CFLAGS +=3D -Wa,-mno-relax
>  	KBUILD_AFLAGS +=3D -Wa,-mno-relax
>  endif
> +# LLVM has an issue with target-features and LTO: https://github.com/llv=
m/llvm-project/issues/59350
> +# Ensure it is aware of linker relaxation with LTO, otherwise relocation=
s may
> +# be incorrect: https://github.com/llvm/llvm-project/issues/65090
> +else ifeq ($(CONFIG_LTO_CLANG),y)
> +	KBUILD_LDFLAGS +=3D -mllvm -mattr=3D+c -mllvm -mattr=3D+relax
>  endif
>  endif
> =20
> diff --git a/arch/riscv/kernel/pi/Makefile b/arch/riscv/kernel/pi/Makefile
> index 07915dc9279e..b75f150b923d 100644
> --- a/arch/riscv/kernel/pi/Makefile
> +++ b/arch/riscv/kernel/pi/Makefile
> @@ -9,6 +9,9 @@ KBUILD_CFLAGS	:=3D $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_C=
FLAGS)) -fpie \
>  		   -fno-asynchronous-unwind-tables -fno-unwind-tables \
>  		   $(call cc-option,-fno-addrsig)
> =20

> +# Disable LTO

FWIW, this is a bit of a statement of the obvious, rather than being
helpful. If this ends up being respun, I think it'd be good to add the
context from the commit message. Otherwise,

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

> +KBUILD_CFLAGS	:=3D $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
> +
>  KBUILD_CFLAGS	+=3D -mcmodel=3Dmedany
> =20
>  CFLAGS_cmdline_early.o +=3D -D__NO_FORTIFY
>=20
> ---
> base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
> change-id: 20231003-riscv-lto-f013beed8587
>=20
> Best regards,
> --=20
> Nathan Chancellor <nathan@kernel.org>
>=20

--pnuOxGeoAc0cPDnR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZTu+9wAKCRB4tDGHoIJi
0l3QAP9ZgrESIpw39XC/9xW08tRMuE2w19D06+Sa5kJZVhr/DAEA9v/8ETOqQsqV
izTywJaWacSapjq0/ZxxCwtUCPVtKg8=
=ZDgT
-----END PGP SIGNATURE-----

--pnuOxGeoAc0cPDnR--
