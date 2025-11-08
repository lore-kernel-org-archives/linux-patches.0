Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514B024166E;
	Sat,  8 Nov 2025 00:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762562234; cv=none; b=J4gGIztFxqNnWHG0e6S0ZBeHcwk50UwTEAB+RL6s9zaPP9eSbk44lWqX/9HH0IzT4c3UAcJ5Dl/E4ydsSg3I59U1UftWWgbBePiC+Ha2trgol+EQH0iIuBvY+s7CDVw6wux9VbqhN7qIfZyH+npZOAUIcJlqzCRMH6ulVM5dKZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762562234; c=relaxed/simple;
	bh=50HHS0ijG9TAVwMqmB+iIxiQVsMKkOQnCN7kXgu+NYk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=laNLfFyv3NvmPzrx5jc5ch9LTcvNN7tvQZ7NPFX1Vf3GWvcuLuYDTjoiHswrJE5FODMDGfFgZjcHCJuguHR3CMMHyWZNgoPm+e35pZ1wtcz9c6tTfhVoPK27bvBYEsrBjetoJc/W835FSFW3e5MBir2KypIyzlJPiJlpVnuKbGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOwHy49F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOwHy49F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07358C2BCB1;
	Sat,  8 Nov 2025 00:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762562232;
	bh=50HHS0ijG9TAVwMqmB+iIxiQVsMKkOQnCN7kXgu+NYk=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=oOwHy49FHh4GUcTBUUqVG4b7fTrjc/gMDnEREAAKy1Is+0XVL4NReGf+uUkJ59bJg
	 fawVrgoBcfMlmhIARI1MjLfL9RRYj9hYZJInTMwBtP6S+0zuU+2nXSsjs+3KGKwsYb
	 iBA/z+QqKpmmeSwNbOSZrmAB1njM2zljWehjxLi7jWTi43Qboip9/8488Uu9L/fcgs
	 rPA2VX20pKvIWesjXZZqjVOlaRYWZ04GEWs6imP6Ur3hGeXrw+zv8mgCfTfPZwfFL6
	 e87H+QfWwiXVP7zXUcNkNKqe/8FahpN45AVUuGRoqn6VUSVdgg1n4x5I5c951tncsU
	 /XSUnoAZA8FNw==
Date: Fri, 7 Nov 2025 17:37:08 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
    Alexandre Ghiti <alex@ghiti.fr>, 
    Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
    Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
    Andrew Jones <ajones@ventanamicro.com>, 
    Ben Dooks <ben.dooks@codethink.co.uk>, linux-riscv@lists.infradead.org, 
    llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH fixes] riscv: Fix CONFIG_AS_HAS_INSN for new .insn
 usage
In-Reply-To: <20251107-riscv-fix-new-insn-usage-v1-1-9a186c5928a0@kernel.org>
Message-ID: <6668adce-cab2-7f92-5403-723ef8c5ab04@kernel.org>
References: <20251107-riscv-fix-new-insn-usage-v1-1-9a186c5928a0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1559060956-1762562232=:644284"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1559060956-1762562232=:644284
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi Nathan,

On Fri, 7 Nov 2025, Nathan Chancellor wrote:

> After commit 44aa25c000b4 ("riscv: asm: use .insn for making custom
> instructions"), builds using LLVM older that 19 or binutils older than
> 2.38 fail with:
> 
>   arch/riscv/include/asm/vdso/processor.h: Assembler messages:
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   make[4]: *** [scripts/Makefile.build:287: arch/riscv/kernel/vdso/vgettimeofday.o] Error 1
> 
>   In file included from <built-in>:4:
>   In file included from lib/vdso/gettimeofday.c:6:
>   In file included from include/vdso/datapage.h:21:
>   In file included from include/vdso/processor.h:10:
>   arch/riscv/include/asm/vdso/processor.h:23:2: error: expected instruction format
>      23 |         ALT_RISCV_PAUSE();
>         |         ^
>   arch/riscv/include/asm/errata_list.h:47:3: note: expanded from macro 'ALT_RISCV_PAUSE'
>      47 |                 RISCV_PAUSE, /* Original RISC‑V pause insn */ \
>         |                 ^
>   arch/riscv/include/asm/insn-def.h:259:21: note: expanded from macro 'RISCV_PAUSE'
>     259 | #define RISCV_PAUSE     ASM_INSN_I("0x100000f")
>         |                         ^
>   arch/riscv/include/asm/asm.h:16:26: note: expanded from macro 'ASM_INSN_I'
>      16 | #define ASM_INSN_I(__x) ".insn " __x
>         |                          ^
>   <inline asm>:5:7: note: instantiated into assembly here
>       5 | .insn 0x100000f
>         |       ^
> 
> binutils gained support for '.insn <value>' in 2.38 [1] and LLVM gained
> support in 19 [2]. Adjust the test for CONFIG_AS_HAS_INSN to ensure that
> all versions of .insn are supported before being used.
> 
> Fixes: 44aa25c000b4 ("riscv: asm: use .insn for making custom instructions")
> Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=a262b82fdbf4cda3b0648b1adc32245ca3f78b7a [1]
> Link: https://github.com/llvm/llvm-project/commit/2a086dce691e3cc34a2fc27f4fb255bb2cbbfac9 [2]
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>  arch/riscv/Kconfig | 2 +- 1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for the fast fix, and sorry for the trouble. 

Clearly we're not doing sufficiently broad build testing here, either 
before branch submission, or on -next.  We'll fix this ASAP on the branch 
submission case, and work on improving -next autobuilds.

Queued for v6.18-rc.


- Paul
--8323329-1559060956-1762562232=:644284--
