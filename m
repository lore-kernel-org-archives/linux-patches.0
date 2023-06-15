Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C14EEAEE
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 19:42:31 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-43f519c0888so891072137.3
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 12:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686858150; x=1689450150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EEzNrFy4XtnBJchIRCyudJpLzlojDK3YzlAqwYMXFT0=;
        b=lBwTUjIilesidUCNGaAvZ+xj4jRGP9ZPcdF6CpMtEeTbtwKGGC9zJYJcwMkwh5GDSj
         6TO/HyTtOMlwBDHVt0L6hSeGPFlURYJRwbR0dz4PRCJYntqmF/3cCuuu0h/v1jxKA888
         pcmBRHsiMmLRBAi8IYio5/cKlRMvzj4FcDxzkLhnj050yvQrc9Y1F2XzKmuYr5NBlcP1
         EpPbrkvpKqrj1yDytJDpzeEKUPlcQGBPnhKCW4YtvBC64iiFEdkoC0QwKJLipXFkq7wc
         jGtl3rS0rfb7Pcfqsc0daraaxrNMh7MKpbrNuhkhT76TdPMOj1SNGsX7ycRIVoJ3AQy9
         BDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686858150; x=1689450150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EEzNrFy4XtnBJchIRCyudJpLzlojDK3YzlAqwYMXFT0=;
        b=dro58wunYTucvAxPO578YQaJJxE/BDxb1HzW5ICoxePIPdfPSVhFne0wgZRH1gsk2o
         mvLO7OleSaCUhBpi6iZ9a+4yq795pIFMDUm92FQ7I8rkna/oX0nNaxPaRinXZQ5lZ4MN
         pdQVqmhyJ4qnfMvj06fL3onOTVDent9vWpb+o8nLw1imPl205Ybupmv72I5BzhRYBYxe
         yd1Vxux0EKjmCGrVnne+FXTvhkLVsemm30ctssb/Ap571oWL91jQjrCrds3LfQmFYqJc
         Hnkk69xIIcmmxD9gxO4NQs7XFRxkHG2Av22bpgCI8DD+VHwaFxINJQz4kPMehVjrFHHq
         xP5g==
X-Gm-Message-State: AC+VfDxq22ff2xp3BLWisVimGvt366q+mAL5+28v2PHDZRcQY+KOR5+a
	CGCpmat4DJVj4Ut0U3I2le9o0CNthFG8czuwwqIHhA==
X-Google-Smtp-Source: ACHHUZ4DAcb8XJ7cK5trIjfYu8JayVxt4ZPxnD/vGCWza1Eoy4aPA1/eOXTHCyXUZSdlUS0q7KBknTMFqsdih3/7QPM=
X-Received: by 2002:a67:f34d:0:b0:43b:38a5:f8a0 with SMTP id
 p13-20020a67f34d000000b0043b38a5f8a0mr494060vsm.14.1686858149899; Thu, 15 Jun
 2023 12:42:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230615-mips-mark-core_vpe_count-as-init-v1-1-99c124367ea8@kernel.org>
In-Reply-To: <20230615-mips-mark-core_vpe_count-as-init-v1-1-99c124367ea8@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 15 Jun 2023 15:42:16 -0400
Message-ID: <CAKwvOdndp=2h9se6ddGiYJ6S4o_ROFLD2CH5ZuW-SRa=DMapzw@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Mark core_vpe_count() as __init
To: Nathan Chancellor <nathan@kernel.org>
Cc: tsbogend@alpha.franken.de, trix@redhat.com, jiaxun.yang@flygoat.com, 
	linux-mips@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 15, 2023 at 12:21=E2=80=AFPM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> After commit 96cb8ae28c65 ("MIPS: Rework smt cmdline parameters"),
> modpost complains when building with clang:
>
>   WARNING: modpost: vmlinux.o: section mismatch in reference: core_vpe_co=
unt (section: .text) -> smp_max_threads (section: .init.data)
>
> This warning occurs when core_vpe_count() is not inlined, as it appears
> that a non-init function is referring to an init symbol. However, this
> is not a problem in practice because core_vpe_count() is only called
> from __init functions, cps_smp_setup() and cps_prepare_cpus().
>
> Resolve the warning by marking core_vpe_count() as __init, as it is only
> called in an init context so it can refer to init functions and symbols
> and have its memory freed on boot.
>
> Fixes: 96cb8ae28c65 ("MIPS: Rework smt cmdline parameters")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  arch/mips/kernel/smp-cps.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/kernel/smp-cps.c b/arch/mips/kernel/smp-cps.c
> index bea6a13ea464..92575222713b 100644
> --- a/arch/mips/kernel/smp-cps.c
> +++ b/arch/mips/kernel/smp-cps.c
> @@ -29,7 +29,7 @@ static DECLARE_BITMAP(core_power, NR_CPUS);
>
>  struct core_boot_config *mips_cps_core_bootcfg;
>
> -static unsigned core_vpe_count(unsigned int cluster, unsigned core)
> +static unsigned __init core_vpe_count(unsigned int cluster, unsigned cor=
e)
>  {
>         return min(smp_max_threads, mips_cps_numvps(cluster, core));
>  }
>
> ---
> base-commit: 5cad8323040bb8d47e130c10ea4dcb7175c7602a
> change-id: 20230615-mips-mark-core_vpe_count-as-init-600dc73e367d
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
Thanks,
~Nick Desaulniers
