Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553D47470;
	Wed,  5 Apr 2023 17:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E091C433D2;
	Wed,  5 Apr 2023 17:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680717400;
	bh=jVAC+4ymjcbvNsupEft+6hBzdRCfnsofg1xrrfqn2EE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VtGkj96fnXFRhZOFW35CsBKWfZ1/hZZH22iSRV99oWKoubYmnccIzXR0hKMt3LRNV
	 YCF7wADFu0UjIdtw/et1GgDXbcfonja4xyX97aUkHEKffk/VbfeJrwEGwyflIiYqjP
	 o4cYJ3hrSJp695Jkk7u6UuuKeZHM8oXWOP7v78C9PsmpY6/AC190FdW57Wk7WXAszk
	 zgBUnuWdUR/s57car2zRtQIuxBJJvuCy4njGmveVwu/Yc/YLRDD3qG1gam/ol7JgTj
	 xnMEaLC/V3zH1VtaAcytv1ZReq7Q5Du3WPmo9CHK5xcuBupoB3YC3KLYlv6RlOnQw2
	 eTCAQCaIkYZBg==
Date: Wed, 5 Apr 2023 18:56:36 +0100
From: Conor Dooley <conor@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	ndesaulniers@google.com, trix@redhat.com,
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] riscv: Adjust dependencies of HAVE_DYNAMIC_FTRACE
 selection
Message-ID: <20230405-dejected-unending-28e29d89f206@spud>
References: <20230404-riscv-dynamic-ftrace-checks-clang-v1-1-0ce296b7d423@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Y/qRivkW8sHyiGgn"
Content-Disposition: inline
In-Reply-To: <20230404-riscv-dynamic-ftrace-checks-clang-v1-1-0ce296b7d423@kernel.org>


--Y/qRivkW8sHyiGgn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2023 at 01:34:21PM -0700, Nathan Chancellor wrote:
> When building allmodconfig with clang and its integrated assembler and
> linking with a version of GNU ld prior to 2.36, the following link error
> occurs:
>=20
>   riscv64-linux-gnu-ld: .init.data has both ordered [`__patchable_functio=
n_entries' in init/main.o] and unordered [`.init_array.0' in kernel/trace/t=
race_benchmark.o] sections
>   riscv64-linux-gnu-ld: final link failed: bad value
>=20
> This is the same error addressed by commit 45bd8951806e ("arm64: Improve
> HAVE_DYNAMIC_FTRACE_WITH_REGS selection for clang") for arm64. See that
> changelog for a full description of why this error occurs with this
> combination of tools.
>=20
> In a similar manner as that change, restrict the
> CONFIG_HAVE_DYNAMIC_FTRACE selection to combinations of tools known to
> work so that there are no errors.
>=20
> Link: https://github.com/ClangBuiltLinux/linux/issues/1817
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/riscv/Kconfig | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index eb7f29a412f8..4b82838ac870 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -136,12 +136,23 @@ config RISCV
>  	select TRACE_IRQFLAGS_SUPPORT
>  	select UACCESS_MEMCPY if !MMU
>  	select ZONE_DMA32 if 64BIT
> -	select HAVE_DYNAMIC_FTRACE if !XIP_KERNEL && MMU && $(cc-option,-fpatch=
able-function-entry=3D8)
> +	select HAVE_DYNAMIC_FTRACE if !XIP_KERNEL && MMU && (CLANG_SUPPORTS_DYN=
AMIC_FTRACE || GCC_SUPPORTS_DYNAMIC_FTRACE)
>  	select HAVE_DYNAMIC_FTRACE_WITH_REGS if HAVE_DYNAMIC_FTRACE
>  	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_FUNCTION_TRACER if !XIP_KERNEL && !PREEMPTION
> =20
> +config CLANG_SUPPORTS_DYNAMIC_FTRACE
> +	def_bool CC_IS_CLANG
> +	# https://github.com/llvm/llvm-project/commit/6ab8927931851bb42b2c93a00=
801dc499d7d9b1e
> +	depends on CLANG_VERSION >=3D 130000
> +	# https://github.com/ClangBuiltLinux/linux/issues/1817
> +	depends on AS_IS_GNU || (AS_IS_LLVM && (LD_IS_LLD || LD_VERSION >=3D 23=
600))
> +
> +config GCC_SUPPORTS_DYNAMIC_FTRACE
> +	def_bool CC_IS_GCC
> +	depends on $(cc-option,-fpatchable-function-entry=3D8)

I thought about merging these, but I think you just end up with
something that is difficult to grok. Explanation in the arm64 is pretty
good & the change follows.
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>


--Y/qRivkW8sHyiGgn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZC22VAAKCRB4tDGHoIJi
0p76AP9x5WZy9i0kDAHbGvogZ6rJrVgolnqAW0uZIAwGqZdHPAD8Ds6dJzr3hChp
JMo2BHpHOC9Dn+Zzu8NxlXecUBFqAgc=
=4TDW
-----END PGP SIGNATURE-----

--Y/qRivkW8sHyiGgn--
