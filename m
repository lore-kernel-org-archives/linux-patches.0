Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4FE31A6D;
	Wed, 25 Oct 2023 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z0Xoasu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F1BC433C8;
	Wed, 25 Oct 2023 18:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698258676;
	bh=INMspFkwPEugyi/hyVWi76tgtk+FhLddwDQRBXa/AY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z0Xoasu7L4mLfF33vg5aM4cSPhXXOY2MPkkXTR1FSeWBDSaSGfelykQ3J9z277w80
	 9oI9mePpgXQu7wAlk4biHD5Myh/BjvermvuhHoqgNsnIH8ObdS3qIdW2J4FQEJmfYv
	 di8h8EKIFY5Wsdyt53b+hN5xS98X13MYJe4KXyx00Qvw9nCg3jRw3t8muAzZQkkvFz
	 17yYMjMXd8+tbN5Bgm6l6frkGDFTHSzAPB9FP46pYdlICO9c8Pm4956F8Cno+8UDHO
	 FVHyxa82fU9va+DULeJflHQvfWYY/vArnKfnzahGKlui1OSFsCmTg3GRIF2WgadNQu
	 Nszueg91BYX0Q==
Date: Wed, 25 Oct 2023 11:31:14 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, ndesaulniers@google.com,
	trix@redhat.com, linux-arm-kernel@lists.infradead.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] arm64: Restrict CPU_BIG_ENDIAN to GNU as or LLVM IAS
 15.x or newer
Message-ID: <20231025183114.GA669177@dev-arch.thelio-3990X>
References: <20231025-disable-arm64-be-ias-b4-llvm-15-v1-1-b25263ed8b23@kernel.org>
 <ZTlYEZ7miLF0gDJj@FVFF77S0Q05N.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTlYEZ7miLF0gDJj@FVFF77S0Q05N.cambridge.arm.com>

On Wed, Oct 25, 2023 at 07:01:53PM +0100, Mark Rutland wrote:
> Hi Nathan,
> 
> On Wed, Oct 25, 2023 at 10:21:28AM -0700, Nathan Chancellor wrote:
> > A recent refactoring in the arm64 tree exposed an assembler bug in LLVM
> > with regards to the generation of NOPs for arm64 big endian, resulting
> > in near-immediate crashes on boot in QEMU.
> 
> Could we please put a bit more detail into the commit message about what
> exactly went wrong and how this was detected? I know that can be found
> from the github links below, but having to go chase that is a bit of a
> pain.

Sure, sorry for leaving that out of the initial revision.

> Would you be happy with the below? I've also added a Cc stable, since
> this is a potential state corruption issue.

That text looks much better to me, especially since it explains exactly
what goes wrong here (which I was unsure of, this helps). Thanks a lot!

Will / Catalin, would you like a v2 with that text or could it just be
copied and pasted from Mark's mail during application time? I am happy
to do whatever.

> Assuming you're happy with that text:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
> Mark.
> 
> ---->8----
> Prior to LLVM 15.0.0, LLVM's integrated assemble would incorrectly
> byte-swap NOP when compiling for big-endian, and the resulting series of
> bytes happened to match the encoding of FNMADD S21, S30, S0, S0.
> 
> This went unnoticed until commit:
> 
>   34f66c4c4d5518c1 ("arm64: Use a positive cpucap for FP/SIMD")
> 
> Prior to that commit, the kernel would always enable the use of FPSIMD
> early in boot when __cpu_setup() initialized CPACR_EL1, and so usage of
> FNMADD within the kernel was not detected, but could result in the
> corruption of user or kernel FPSIMD state.
> 
> After that commit, the instructions happen to trap during boot prior to
> FPSIMD being detected and enabled, e.g.
> 
> | Unhandled 64-bit el1h sync exception on CPU0, ESR 0x000000001fe00000 -- ASIMD
> | CPU: 0 PID: 0 Comm: swapper Not tainted 6.6.0-rc3-00013-g34f66c4c4d55 #1
> | Hardware name: linux,dummy-virt (DT)
> | pstate: 400000c9 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> | pc : __pi_strcmp+0x1c/0x150
> | lr : populate_properties+0xe4/0x254
> | sp : ffffd014173d3ad0
> | x29: ffffd014173d3af0 x28: fffffbfffddffcb8 x27: 0000000000000000
> | x26: 0000000000000058 x25: fffffbfffddfe054 x24: 0000000000000008
> | x23: fffffbfffddfe000 x22: fffffbfffddfe000 x21: fffffbfffddfe044
> | x20: ffffd014173d3b70 x19: 0000000000000001 x18: 0000000000000005
> | x17: 0000000000000010 x16: 0000000000000000 x15: 00000000413e7000
> | x14: 0000000000000000 x13: 0000000000001bcc x12: 0000000000000000
> | x11: 00000000d00dfeed x10: ffffd414193f2cd0 x9 : 0000000000000000
> | x8 : 0101010101010101 x7 : ffffffffffffffc0 x6 : 0000000000000000
> | x5 : 0000000000000000 x4 : 0101010101010101 x3 : 000000000000002a
> | x2 : 0000000000000001 x1 : ffffd014171f2988 x0 : fffffbfffddffcb8
> | Kernel panic - not syncing: Unhandled exception
> | CPU: 0 PID: 0 Comm: swapper Not tainted 6.6.0-rc3-00013-g34f66c4c4d55 #1
> | Hardware name: linux,dummy-virt (DT)
> | Call trace:
> |  dump_backtrace+0xec/0x108
> |  show_stack+0x18/0x2c
> |  dump_stack_lvl+0x50/0x68
> |  dump_stack+0x18/0x24
> |  panic+0x13c/0x340
> |  el1t_64_irq_handler+0x0/0x1c
> |  el1_abort+0x0/0x5c
> |  el1h_64_sync+0x64/0x68
> |  __pi_strcmp+0x1c/0x150
> |  unflatten_dt_nodes+0x1e8/0x2d8
> |  __unflatten_device_tree+0x5c/0x15c
> |  unflatten_device_tree+0x38/0x50
> |  setup_arch+0x164/0x1e0
> |  start_kernel+0x64/0x38c
> |  __primary_switched+0xbc/0xc4
> 
> Restrict CONFIG_CPU_BIG_ENDIAN to a known good assembler, which is
> either GNU as or LLVM's IAS 15.0.0 and newer, which contains the linked
> commit.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1948
> Link: https://github.com/llvm/llvm-project/commit/1379b150991f70a5782e9a143c2ba5308da1161c
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Cc: stable@vger.kernel.org
> 
> > Restrict CONFIG_CPU_BIG_ENDIAN to a known good assembler, which is
> > either GNU as or LLVM's IAS 15.0.0 and newer, which contains the linked
> > commit.
> > 
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1948
> > Link: https://github.com/llvm/llvm-project/commit/1379b150991f70a5782e9a143c2ba5308da1161c
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  arch/arm64/Kconfig | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index adf2f8a327be..92d33ece4c45 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -1360,6 +1360,8 @@ choice
> >  config CPU_BIG_ENDIAN
> >  	bool "Build big-endian kernel"
> >  	depends on !LD_IS_LLD || LLD_VERSION >= 130000
> > +	# https://github.com/llvm/llvm-project/commit/1379b150991f70a5782e9a143c2ba5308da1161c
> > +	depends on AS_IS_GNU || AS_VERSION >= 150000
> >  	help
> >  	  Say Y if you plan on running a kernel with a big-endian userspace.
> >  
> > 
> > ---
> > base-commit: 22e877699642285c47f5d7d83b2d59815c29ebe8
> > change-id: 20231025-disable-arm64-be-ias-b4-llvm-15-b6f30f3f24be
> > 
> > Best regards,
> > -- 
> > Nathan Chancellor <nathan@kernel.org>
> > 
