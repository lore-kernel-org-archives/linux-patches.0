Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5681097E;
	Wed,  4 Oct 2023 10:01:26 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (unknown [217.70.183.195])
	by mslow1.mail.gandi.net (Postfix) with ESMTP id C78C9CFBC3;
	Wed,  4 Oct 2023 09:51:40 +0000 (UTC)
Received: by mail.gandi.net (Postfix) with ESMTPSA id EF6906000B;
	Wed,  4 Oct 2023 09:51:26 +0000 (UTC)
Message-ID: <f3e904ff-3ae1-b8ad-c400-7961f97b2b40@ghiti.fr>
Date: Wed, 4 Oct 2023 11:51:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3] RISC-V: build: Allow LTO to be selected
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, conor@kernel.org
Cc: ndesaulniers@google.com, trix@redhat.com, samitolvanen@google.com,
 twd2.me@gmail.com, linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
 patches@lists.linux.dev
References: <20231003-riscv-lto-v3-1-8aca61a4ecb4@kernel.org>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20231003-riscv-lto-v3-1-8aca61a4ecb4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

Hi Nathan,

On 03/10/2023 21:16, Nathan Chancellor wrote:
> From: Wende Tan <twd2.me@gmail.com>
>
> Allow LTO to be selected for RISC-V, only when LLD >= 14, since there is an
> issue [1] in prior LLD versions that prevents LLD to generate proper
> machine code for RISC-V when writing `nop`s.
>
> I have tested enabling LTO for `defconfig`. The LLD took ~2m21s and ~3GiB
> on our Intel Xeon Gold 6140 server and produced an 18MiB Image. The image
> can boot to shell using an archriscv rootfs on QEMU.
>
> I have also tested it for `allyesconfig` without COMPILE_TEST, FTRACE,
> KASAN, and GCOV. The LLD took ~7h03m and ~335GiB on the server,
> successfully producing a 1.7GiB Image. Unfortunately, we cannot boot this
> image because the `create_kernel_page_table()` -> `alloc_pmd_early()` ->
> `BUG_ON()` logic limits the image to be < 1GiB. Maybe we can fix it in a
> separate patch further.


Yes, I see 2 solutions:

- either use PUD mappings, which is not that easy because we'd need the 
physical and virtual addresses to both be aligned on 1GB, which is very 
unlikely (the kernel is generally loaded at 0x8020_0000). We could use a 
relocatable kernel to offset the virtual kernel address though.

- or use a second early_pmd, which would make sense as we reserve 2GB 
for the kernel mapping anyway, but I'm not sure it would work without a 
bunch of modifications.

Let me know if that would help and I'll give it a try (unless you want 
to take care of that of course!).

Alex


>
> Disable LTO for arch/riscv/kernel/pi, as llvm-objcopy expects an ELF
> object file when manipulating the files in that subfolder, rather than
> LLVM bitcode.
>
> [1] https://github.com/llvm/llvm-project/issues/50505, resolved by LLVM
>      commit e63455d5e0e5 ("[MC] Use local MCSubtargetInfo in writeNops")
>
> Tested-by: Wende Tan <twd2.me@gmail.com>
> Signed-off-by: Wende Tan <twd2.me@gmail.com>
> Co-developed-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> NOTE: I tested LLVM 14 through 18 with defconfig + full/thin LTO and
> allmodconfig + thin LTO. allmodconfig + thin LTO with LLVM 15 and 16
> shows
>
>    ld.lld: error: section size decrease is too large
>
> when linking vmlinux. This appears to be resolved in LLVM 17 with
> https://github.com/llvm/llvm-project/commit/9d37ea95df1b84cca9b5e954d8964c976a5e303e
> (I did not bisect but the commit message lines up with the issue). I
> kept the existing version check because defconfig worked fine but we may
> want to bump it to 17.0.0 if randconfigs trip over this.
>
> Changes in v3:
> - Disable LTO in arch/riscv/kernel/pi/Makefile, which was added to the
>    kernel after the submission of v2. This change matches arm64.
> - Link to v2: https://lore.kernel.org/r/20220512205545.992288-1-twd2.me@gmail.com/
>
> Changes in v2:
> - Some textual changes suggested by Nick.
> - Drop the changes to `arch/riscv/Makefile`, since the LLVM issue is
>    filed and resolved.
> - Drop the unnecessary changes to `arch/riscv/kernel/vdso/Makefile`.
> - Link to v1: https://lore.kernel.org/r/20210719205208.1023221-1-twd2.me@gmail.com/
> ---
>   arch/riscv/Kconfig            | 3 +++
>   arch/riscv/kernel/pi/Makefile | 3 +++
>   2 files changed, 6 insertions(+)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index d607ab0f7c6d..523640f7441e 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -46,6 +46,9 @@ config RISCV
>   	select ARCH_SUPPORTS_CFI_CLANG
>   	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
>   	select ARCH_SUPPORTS_HUGETLBFS if MMU
> +	# LLD >= 14: https://github.com/llvm/llvm-project/issues/50505
> +	select ARCH_SUPPORTS_LTO_CLANG if LLD_VERSION >= 140000
> +	select ARCH_SUPPORTS_LTO_CLANG_THIN if LLD_VERSION >= 140000
>   	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
>   	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
>   	select ARCH_USE_MEMTEST
> diff --git a/arch/riscv/kernel/pi/Makefile b/arch/riscv/kernel/pi/Makefile
> index 07915dc9279e..b75f150b923d 100644
> --- a/arch/riscv/kernel/pi/Makefile
> +++ b/arch/riscv/kernel/pi/Makefile
> @@ -9,6 +9,9 @@ KBUILD_CFLAGS	:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) -fpie \
>   		   -fno-asynchronous-unwind-tables -fno-unwind-tables \
>   		   $(call cc-option,-fno-addrsig)
>   
> +# Disable LTO
> +KBUILD_CFLAGS	:= $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
> +
>   KBUILD_CFLAGS	+= -mcmodel=medany
>   
>   CFLAGS_cmdline_early.o += -D__NO_FORTIFY
>
> ---
> base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
> change-id: 20231003-riscv-lto-f013beed8587
>
> Best regards,
