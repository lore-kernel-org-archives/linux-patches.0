Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8788B17727
	for <patches@lists.linux.dev>; Wed, 16 Aug 2023 22:41:23 +0000 (UTC)
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4882787744eso757054e0c.0
        for <patches@lists.linux.dev>; Wed, 16 Aug 2023 15:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692225682; x=1692830482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mmIqxa6frC+gPR1n1W6gSgs3JOKzmDAS0GTXjwaiYmA=;
        b=5Bs6sM4GRaoJLPQgY5xE+w4MsxnsgboK1Dh+YN60e0m/ucJzK4S8elgXG7atMdSjzx
         oOezkrK7ViKu51PnZH/Z3xLWwNhNcx1e5EDYw6y14A5B29UuZzphtgdpHJMYA53uFNWJ
         wwm/zz7P4OGidZfvmJ85fTEkb7klogJgqe0Sw85jgcD6/MxmUeY93gD2VDN2QtKEZzNQ
         53CvG28kl5EOZ6s7R/Sn/nIaFP1fuAY/dVuNby+9CaOyrXWT1XU8oVaaINkYd6XQLmZz
         FYC7dqMkHjzlfE3lmH/wJMGzPYM9HmKMjrlHWR096C+v32UrwmMH7+lVcGCCC3/9QwJt
         /6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692225682; x=1692830482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mmIqxa6frC+gPR1n1W6gSgs3JOKzmDAS0GTXjwaiYmA=;
        b=VazYQ32QTk4bTEX+KWOc/INfDyIwHDVdF54+7eYS4qSMBcJRSqNYuyKUj1NaIdDg3x
         cXc5N/p2jTRgHnC3IMbFP2ByajfIgHMUKlBjji2wm+0HtHaA8gj0Mo+U3yafMTPuyG3/
         fLQO3GPcpSW7MKLm0ftBeGyH1otKbdHFlzj4M05Wjy2TmawWTKSGGHh6a41lTndLSyuA
         3IDslw/2K/CqqGl5a95bb3tUrl5smpz1fOqGtfLEjnntrJdI7aEkFHJfISxH9H17yzuL
         pmiqiBwUN1KrPkQzWz7wBAl0wmFb14f90oFYuTbKlFP+Dt6jzuE8SWtLw1MdayWo2Df/
         lJEw==
X-Gm-Message-State: AOJu0YzOgj4c4UXMwXu6T1s6ovAhwOMtMXcRAmJ78Ws17jozfFx2vhPM
	8vo6V/KQjxeyEdo2TTHYoAxskjepjtiApgHV8oS+Mw==
X-Google-Smtp-Source: AGHT+IG1+IPfo+RX82+EOF4EsXRn+LG2oKvxL3tLdVcgq7pTP/+tdR7tm3COfErbYJ2EsxeSvKy8qQ9gkLN6OhX6Xoo=
X-Received: by 2002:a1f:c189:0:b0:48a:68d0:28fc with SMTP id
 r131-20020a1fc189000000b0048a68d028fcmr3232564vkf.4.1692225682132; Wed, 16
 Aug 2023 15:41:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230816-mips-vdso-cond-export-__vdso_gettimeofday-v1-1-fe725254c782@kernel.org>
In-Reply-To: <20230816-mips-vdso-cond-export-__vdso_gettimeofday-v1-1-fe725254c782@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 16 Aug 2023 15:41:11 -0700
Message-ID: <CAKwvOdmq2Yvf3g83xQdV9_X2NEHVNORb7xBMn2ivZ0jriBPv6w@mail.gmail.com>
Subject: Re: [PATCH] MIPS: VDSO: Conditionally export __vdso_gettimeofday()
To: Nathan Chancellor <nathan@kernel.org>
Cc: tsbogend@alpha.franken.de, linux-mips@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 16, 2023 at 2:59=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> ld.lld 16.0.0 and newer defaults to '--no-undefined-version', which
> causes the following error when CONFIG_MIPS_CLOCK_VSYSCALL is not set:
>
>   ld.lld: error: version script assignment of 'LINUX_2.6' to symbol '__vd=
so_gettimeofday' failed: symbol not defined
>
> Only export __vdso_gettimeofday() when it will be present in the final
> object file, which clears up the error.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308170532.zxFFv25c-lkp@i=
ntel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  arch/mips/vdso/vdso.lds.S | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/mips/vdso/vdso.lds.S b/arch/mips/vdso/vdso.lds.S
> index d90b65724d78..836465e3bcb8 100644
> --- a/arch/mips/vdso/vdso.lds.S
> +++ b/arch/mips/vdso/vdso.lds.S
> @@ -94,7 +94,9 @@ VERSION
>  #ifndef CONFIG_MIPS_DISABLE_VDSO
>         global:
>                 __vdso_clock_gettime;
> +#ifdef CONFIG_MIPS_CLOCK_VSYSCALL
>                 __vdso_gettimeofday;
> +#endif
>                 __vdso_clock_getres;
>  #if _MIPS_SIM !=3D _MIPS_SIM_ABI64
>                 __vdso_clock_gettime64;
>
> ---
> base-commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421
> change-id: 20230816-mips-vdso-cond-export-__vdso_gettimeofday-30ab92c716d=
4
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>


--=20
Thanks,
~Nick Desaulniers
