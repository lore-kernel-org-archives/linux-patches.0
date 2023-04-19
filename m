Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4202ED300
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 22:03:44 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1a50cb65c92so4386845ad.0
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 15:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681941823; x=1684533823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zh5e890yF5vPU5jFDEQlJGrwn7FtrHqnTGkDM3PEhGk=;
        b=nYVR6pd5ohHan4cvMM25Oc7l0XYFR7FKSc+MZWSm47m/oOsn4bUdrLtiApb2BMvn9W
         WMcUClzdzEaRKUhQqYcVkdaaXR7KftttiGhQ7uahIeMcUbgwCNxXOFoRc0bqdUzsQNhH
         TNIgJE1vhzIYwtrMizt4qj93JwRprxsgCnHVpqaBaO8fnbOpHZOl6pX9icRFTPPabgWH
         AspQ5jLPqr23bvNYBUnbbxE6dz4gJfQw9RdJkVEwTGJ1vMBdxoV9soEmxUrCqrFDZaYs
         5JTEhKZT+WcDaVg3XI73+vIz4c16Lv6VGec0UOth4LxNfXZuXXhJIDLO0/ERPMvIbgGy
         4C2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681941823; x=1684533823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zh5e890yF5vPU5jFDEQlJGrwn7FtrHqnTGkDM3PEhGk=;
        b=KQifKEe5DcfCrzl7KszPj+jeVAV8WZ6UWhqdjg67FosbgegTpsybXalM2LSrnGn3pl
         WghdpU0annSUADYNvyabIEQulvtr6AxOfQ4uFXKzvazdvh+iCW1xjYmezxJkht8aEkix
         2gDkIkIKeeZFwTWvPnYnrGkLbl+NbUm2UuNuJtx6YIFF3+G4JVqqu19S6U/w1L06pLlT
         exwT4JAwCi/SuwAMcocs3v3kxTfKeSoVHsWI2XekvnTOTscnfAaHIcmcVVxScUJ5gHES
         JaesEucAO22sz4ROWB9Nienb4Oa9kVUBghg4oekNjZZNR2GCxsi3ORXBT0BJsaaoAwqK
         e45w==
X-Gm-Message-State: AAQBX9cCaOjtgxGkLuR6AZQWnVuLdxfJJuOHkkV0oEVDDIUnlhP7Mt0V
	ftRg2HvN8ruCfBxNTPWBel8mD9sj2jGb4VLLvFbf/Q==
X-Google-Smtp-Source: AKy350Y2Z2JjZ2qaX/ON4uPm2q//KaaWuchhgDJWWtGCJjwBgwDhMMx5Eo7igcV2qq6xRhf+gjVMj3nsuoCURnpIxZM=
X-Received: by 2002:a17:902:f78c:b0:1a2:94bb:e104 with SMTP id
 q12-20020a170902f78c00b001a294bbe104mr6667157pln.39.1681941823522; Wed, 19
 Apr 2023 15:03:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230419-mips-check_bugs-init-attribute-v1-1-91e6eed55b89@kernel.org>
In-Reply-To: <20230419-mips-check_bugs-init-attribute-v1-1-91e6eed55b89@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 19 Apr 2023 15:03:31 -0700
Message-ID: <CAKwvOdmuQBnZR_pB5bUdsF+OoB_4pxBT9TNFF83fZhzwZ1gbxw@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Mark check_bugs{,_early}() as __init
To: Nathan Chancellor <nathan@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: jpoimboe@kernel.org, peterz@infradead.org, linux-mips@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 11:43=E2=80=AFAM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> After commit ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING
> forcibly"), a compiler may choose not to inline a function marked with
> just 'inline'. If check_bugs() is not inlined into start_kernel(), which
> occurs when building with clang after commit 9ea7e6b62c2b ("init: Mark
> [arch_call_]rest_init() __noreturn"), modpost complains with:
>
>   WARNING: modpost: vmlinux.o: section mismatch in reference: check_bugs =
(section: .text) -> check_bugs32 (section: .init.text)
>
> check_bugs() is only called from start_kernel(), which itself is marked
> __init, so mark check_bugs() as __init as well to clear up the warning
> and make everything work properly.
>
> While there is currently no warning about check_bugs_early(), it could
> have the same problem, as it is called from arch_setup() and calls
> check_bugs64_early(), both marked __init. Mark it as __init for the same
> reason as above.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> NOTE: This is based on v6.3-rc7, as the issue shows up due to a patch in
> the tip tree, but this appears to be an ancient issue that could have
> showed up at any point (hence why no explicit Fixes tag), so I chose a
> base that should allow either the MIPS or tip folks to apply this patch.

Probably for the MIPS tree.

>
> Additionally, I was tempted to remove the explicit 'inline' since the
> compiler is free to do whatever it wants anyways but this is a static
> function in a header so we would need to add '__maybe_unused', which is
> already added with 'inline' in a normal build so I just left it alone.
> ---
>  arch/mips/include/asm/bugs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/include/asm/bugs.h b/arch/mips/include/asm/bugs.h
> index d72dc6e1cf3c..9b9bf9bc7d24 100644
> --- a/arch/mips/include/asm/bugs.h
> +++ b/arch/mips/include/asm/bugs.h
> @@ -24,13 +24,13 @@ extern void check_bugs64_early(void);
>  extern void check_bugs32(void);
>  extern void check_bugs64(void);
>
> -static inline void check_bugs_early(void)
> +static inline void __init check_bugs_early(void)
>  {
>         if (IS_ENABLED(CONFIG_CPU_R4X00_BUGS64))
>                 check_bugs64_early();
>  }

If the only call site is in arch/mips/kernel/setup.c, then perhaps we
can move the definition of check_bugs_early there and mark it static
__init and drop inline?

Unless we foresee other callers potentially in the future?  Patch
otherwise LGTM.  Thanks for the patch!

>
> -static inline void check_bugs(void)
> +static inline void __init check_bugs(void)
>  {
>         unsigned int cpu =3D smp_processor_id();
>
>
> ---
> base-commit: 6a8f57ae2eb07ab39a6f0ccad60c760743051026
> change-id: 20230419-mips-check_bugs-init-attribute-026103bdb255
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
Thanks,
~Nick Desaulniers
