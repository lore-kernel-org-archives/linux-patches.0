Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047B781D
	for <patches@lists.linux.dev>; Fri,  3 Jun 2022 01:34:42 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id d129so6116403pgc.9
        for <patches@lists.linux.dev>; Thu, 02 Jun 2022 18:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=WmOqgdw/lnzn8y98yzEspXlCbFr81s8ZPh+l/fuZnvU=;
        b=xeAlMB6iggUl/Q8oT9BpeIQvESRsiCcKlbCJYKeCd+AcQwHrX+ICmf4uTA0ijqOnhb
         hxEH8wEdkCxiO39rdJvSTuiSk+QmJah1jdSSFKYR16Vch89RSDb+rLFKgvEqB6nzM7C/
         x4GILcrRidctOmr4tvRVPSzso60xvcL3oT7C4uJfyvIcemKJ6ei+Ip1bkliuZ3M4nug4
         dLqxlSUe7qMZIQlVWMIx2+W6w0hvM/XeGRINsuZ7tlNzTFbUXJ3f2kA0S6pxoSkhCPaH
         rF4/o2im3XsBaehO8nwSNKjSVo5nSQNm5L5QqiUfKUZEs5D8sga4hDWdZOW1h9YwCAjo
         brwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=WmOqgdw/lnzn8y98yzEspXlCbFr81s8ZPh+l/fuZnvU=;
        b=JMSRlsuSQGNhHmhNgr4THfVBd4Qa6x/GhUvAn0D6QKr+dkJhjEfpgaNsBRn2c2xZkF
         4ubaTKBsI8yTgaxILiWIUhABWOWmJEgGWxainfSus25CpYC2+Borbio6YC+hh+I5JZBh
         4PfcAJDrwAgRyigPSZ07cME0xSt2X727UELv5uergk7NJccD2LSDwq2TKxmEMU2ttHGA
         uhsy9JcxsJ8OmebnMLXwNoIRkAPYgHmo9TMyP7owDoGeADKAUUjCyaVmFyFR15pyc1yl
         DsHw7Yc5i61hCcf2Iju0NifQg4IAkZWAWGhQfYNSzkGG5AJlTJVitycvVOGH7itx6jTt
         H0aw==
X-Gm-Message-State: AOAM531HM9z4wLPlt1JQQxC9JbB6VySNABSXI4X16mdQJEyjtOX9C1+D
	lV6EXuXt+SjMWxrqtuUWqb9b8A==
X-Google-Smtp-Source: ABdhPJxwYUZESxzEAwVBw31/r+YLXs53IRagWzDsSQ7NAeM1zO5QT7RF2ZuUyKJXdRv88efZm8Br8Q==
X-Received: by 2002:a05:6a00:2353:b0:518:96b7:ceb8 with SMTP id j19-20020a056a00235300b0051896b7ceb8mr8062973pfj.5.1654220082298;
        Thu, 02 Jun 2022 18:34:42 -0700 (PDT)
Received: from localhost ([12.3.194.138])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b0016232dbd01fsm4082360plg.292.2022.06.02.18.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 18:34:41 -0700 (PDT)
Date: Thu, 02 Jun 2022 18:34:41 -0700 (PDT)
X-Google-Original-Date: Thu, 02 Jun 2022 18:34:32 PDT (-0700)
Subject:     Re: [PATCH] riscv: Move alternative length validation into subsection
In-Reply-To: <20220516214520.3252074-1-nathan@kernel.org>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  ndesaulniers@google.com, heiko@sntech.de, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
  llvm@lists.linux.dev, patches@lists.linux.dev, nathan@kernel.org, lkp@intel.com
From: Palmer Dabbelt <palmer@dabbelt.com>
To: nathan@kernel.org
Message-ID: <mhng-e4c58f1b-2015-48b1-88ae-dbb9db72643f@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Mon, 16 May 2022 14:45:21 PDT (-0700), nathan@kernel.org wrote:
> After commit 49b290e430d3 ("riscv: prevent compressed instructions in
> alternatives"), builds with LLVM's integrated assembler fail:
>
>   In file included from arch/riscv/mm/init.c:10:
>   In file included from ./include/linux/mm.h:29:
>   In file included from ./include/linux/pgtable.h:6:
>   In file included from ./arch/riscv/include/asm/pgtable.h:108:
>   ./arch/riscv/include/asm/tlbflush.h:23:2: error: expected assembly-time absolute expression
>           ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" (addr) : "memory"));
>           ^
>   ./arch/riscv/include/asm/errata_list.h:33:5: note: expanded from macro 'ALT_FLUSH_TLB_PAGE'
>   asm(ALTERNATIVE("sfence.vma %0", "sfence.vma", SIFIVE_VENDOR_ID,        \
>       ^
>   ./arch/riscv/include/asm/alternative-macros.h:187:2: note: expanded from macro 'ALTERNATIVE'
>           _ALTERNATIVE_CFG(old_content, new_content, vendor_id, errata_id, CONFIG_k)
>           ^
>   ./arch/riscv/include/asm/alternative-macros.h:113:2: note: expanded from macro '_ALTERNATIVE_CFG'
>           __ALTERNATIVE_CFG(old_c, new_c, vendor_id, errata_id, IS_ENABLED(CONFIG_k))
>           ^
>   ./arch/riscv/include/asm/alternative-macros.h:110:2: note: expanded from macro '__ALTERNATIVE_CFG'
>           ALT_NEW_CONTENT(vendor_id, errata_id, enable, new_c)
>           ^
>   ./arch/riscv/include/asm/alternative-macros.h:99:3: note: expanded from macro 'ALT_NEW_CONTENT'
>           ".org   . - (889b - 888b) + (887b - 886b)\n"                    \
>            ^
>   <inline asm>:26:6: note: instantiated into assembly here
>   .org    . - (889b - 888b) + (887b - 886b)
>           ^
>
> This error happens because LLVM's integrated assembler has a one-pass
> design, which means it cannot figure out the instruction lengths when
> the .org directive is outside of the subsection that contains the
> instructions, which was changed by the .option directives added by the
> above change.
>
> Move the .org directives before the .previous directive so that these
> directives are always within the same subsection, which resolves the
> failures and does not introduce any new issues with GNU as. This was
> done for arm64 in commit 966a0acce2fc ("arm64/alternatives: move length
> validation inside the subsection") and commit 22315a2296f4 ("arm64:
> alternatives: Move length validation in alternative_{insn, endif}").
>
> While there is no error from the assembly versions of the macro, they
> appear to have the same problem so just make the same change there as
> well so that there are no problems in the future.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1640
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/riscv/include/asm/alternative-macros.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/alternative-macros.h b/arch/riscv/include/asm/alternative-macros.h
> index e13b1f6bb400..ec2f3f1b836f 100644
> --- a/arch/riscv/include/asm/alternative-macros.h
> +++ b/arch/riscv/include/asm/alternative-macros.h
> @@ -27,9 +27,9 @@
>  	\new_c
>  	.option pop
>  889 :
> -	.previous
>  	.org    . - (889b - 888b) + (887b - 886b)
>  	.org    . - (887b - 886b) + (889b - 888b)
> +	.previous
>  	.endif
>  .endm
>
> @@ -94,9 +94,9 @@
>  	new_c "\n"							\
>  	".option pop\n"							\
>  	"889 :\n"							\
> -	".previous\n"							\
>  	".org	. - (887b - 886b) + (889b - 888b)\n"			\
>  	".org	. - (889b - 888b) + (887b - 886b)\n"			\
> +	".previous\n"							\
>  	".endif\n"
>
>  #define __ALTERNATIVE_CFG(old_c, new_c, vendor_id, errata_id, enable)	\
>
> base-commit: 93c0651617a62a69717299f1464dda798af8bebb

Thanks, this in on for-next (still for 5.19).  I'm going to CC stable so 
it'll get backported, as it seems pretty harmless.
