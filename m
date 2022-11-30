Received: from conssluserg-03.nifty.com (conssluserg-03.nifty.com [210.131.2.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8788BBA51;
	Wed, 30 Nov 2022 22:21:41 +0000 (UTC)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174]) (authenticated)
	by conssluserg-03.nifty.com with ESMTP id 2AUMLOTp018641;
	Thu, 1 Dec 2022 07:21:24 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 2AUMLOTp018641
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1669846885;
	bh=k5TnRkjFmB+0wMVTITyaBsYH4EkERxs/m8UlcytiUqA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=wezRxcPL57rNZmvQDUfqHkvrnpWW6KcJuM5zkvY4DWlVXSwmILOWeW7EnKHIcGxzC
	 Agu37VlemU6SjxxPDu2gzZkCd6+lmu4SGVFvnj/6TuP1qTJ6Ixxx1LWcc1BuEYdaDS
	 AWh6/yLOw1gJak/wKaB4+oSl7NWcw14iYftsWMV0Q2gsBJRHKZkFPu0EophkAljJux
	 mINa+xUJRAZT9gqXFGcF3C61zUb4LCrL7l53DdX6btf1Y1sslZci2kZUBNkhRxNurc
	 1dAItGSzvagxjhaNwL+7czO78HV9CtUYzRXVUIKQ4xOX7Zp1+hNUplWXoin6hsBYvQ
	 hAnxvKLakmEVA==
X-Nifty-SrcIP: [209.85.167.174]
Received: by mail-oi1-f174.google.com with SMTP id m204so135023oib.6;
        Wed, 30 Nov 2022 14:21:24 -0800 (PST)
X-Gm-Message-State: ANoB5pndhIOZLzkn7irFjpLmvYwpol5OctKco8IEjcR20kauND4bKx6J
	1hSUKVACf/3hpZntbcs2fumwac+/f5WbiEfCl2w=
X-Google-Smtp-Source: AA0mqf6or5JAcRyjvHHEkc7ygsMt2uCHycUgQSriEZZOcXQJpheBCozq7ScqXqGnuUQJLwC7n8y7iHcjChYlkCgNDz8=
X-Received: by 2002:aca:1c06:0:b0:354:28ae:23b3 with SMTP id
 c6-20020aca1c06000000b0035428ae23b3mr21855293oic.287.1669846883543; Wed, 30
 Nov 2022 14:21:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221129190123.872394-1-nathan@kernel.org> <20221129190123.872394-2-nathan@kernel.org>
In-Reply-To: <20221129190123.872394-2-nathan@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 1 Dec 2022 07:20:47 +0900
X-Gmail-Original-Message-ID: <CAK7LNATMtRu00GYwJW_VvTSTcY6eqnx=4EEj8PFC5adrnHunSw@mail.gmail.com>
Message-ID: <CAK7LNATMtRu00GYwJW_VvTSTcY6eqnx=4EEj8PFC5adrnHunSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] padata: Do not mark padata_mt_helper() as __init
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 30, 2022 at 4:02 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> When building arm64 allmodconfig + ThinLTO with clang and a proposed
> modpost update to account for -ffuncton-sections, the following warning
> appears:



How to enable -ffuncton-sections for ARCH=arm64 ?
(in other words, how to set CONFIG_LD_DEAD_CODE_DATA_ELIMINATION ?)

In upstream, it is only possible for mips and powerpc.

./arch/mips/Kconfig:82: select HAVE_LD_DEAD_CODE_DATA_ELIMINATION
./arch/powerpc/Kconfig:237: select HAVE_LD_DEAD_CODE_DATA_ELIMINATION



Is there another proposal to add it for arm64,
or is this about a downstream kernel?





>
>   WARNING: modpost: vmlinux.o: section mismatch in reference: padata_work_init (section: .text.padata_work_init) -> padata_mt_helper (section: .init.text)
>   WARNING: modpost: vmlinux.o: section mismatch in reference: padata_work_init (section: .text.padata_work_init) -> padata_mt_helper (section: .init.text)
>
> In both cases, an __init function calls padata_work_init(), which is not
> marked __init, with padata_mt_helper(), another __init function, as a
> work function argument.
>
> padata_work_init() is called from non-init paths, otherwise it could be
> marked __init to resolve the warning. Instead, remove __init from
> padata_mt_helper() to resolve the warning.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: linux-crypto@vger.kernel.org
> ---
>  kernel/padata.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/padata.c b/kernel/padata.c
> index e5819bb8bd1d..c2271d7e446d 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -45,7 +45,7 @@ struct padata_mt_job_state {
>  };
>
>  static void padata_free_pd(struct parallel_data *pd);
> -static void __init padata_mt_helper(struct work_struct *work);
> +static void padata_mt_helper(struct work_struct *work);
>
>  static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
>  {
> @@ -425,7 +425,7 @@ static int padata_setup_cpumasks(struct padata_instance *pinst)
>         return err;
>  }
>
> -static void __init padata_mt_helper(struct work_struct *w)
> +static void padata_mt_helper(struct work_struct *w)
>  {
>         struct padata_work *pw = container_of(w, struct padata_work, pw_work);
>         struct padata_mt_job_state *ps = pw->pw_data;
> --
> 2.38.1
>


-- 
Best Regards
Masahiro Yamada
