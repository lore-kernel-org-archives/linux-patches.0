Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25611F934
	for <patches@lists.linux.dev>; Mon,  2 Oct 2023 20:10:49 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-31c5cac3ae2so180536f8f.3
        for <patches@lists.linux.dev>; Mon, 02 Oct 2023 13:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696277448; x=1696882248; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFOstXEQlXhjDb+N/dzpV+yhV1gDE+Z2FA2nVC44tYo=;
        b=IdVAPIaHZWCBvnzi51wM3kCkr7mzKeIzW84/0usbc1BCN7O35SJjd7lS2Va6PRUo4/
         SAOAxiojSyaN/Vo1tcvH0DT+Jzz2cX8JW8lpKjJ7+PlRDMlhz7UNE7wLCuJnvF/Igkjw
         vb1/0OwA+e6lbOFbjQApwOphRis/U2NzG37qy9v3nNSnsbCUMfKMFFZOgWFaCwTI2JaT
         Cx0TYQcyeUz7NzgH4xPgPogCG+D9pZyAL3h6touMLm/we+oP2aGXhxfTs18RWvdNG+14
         sRG8lKUt5/BFY7WRcLQILEnwJvqxuoVmY2VZAQKJn4dGE831fOPphgGnPeMmVFdPutZk
         3wSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696277448; x=1696882248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vFOstXEQlXhjDb+N/dzpV+yhV1gDE+Z2FA2nVC44tYo=;
        b=fj9VKv/CkQyu3nDb02wR/gmkAeUsADtsRgD3PtjipVj2O5oaMJf+EhnTODC52A+o7m
         qiZkNrDe11eavBQT1NNgFH6A0sqy8DHX28n9+ogyCHlCfD6FR5yN6aeBsFOjFDNbhuh/
         6Jz53ORT28KUWEeahRfApdZUoJjsTkgjC9S5QXBVr/za3fOmMtoxS2tGdBDKGKsiR5Os
         PtZCjt6HVpQY88sxPg5DxeFzPWAPRJcLirac/0WPsNPfEFOe51IZZVVogsRfVxCXxn1t
         /xztVndp6tOD7avoE0UFJjFHlccOq9G6HCL6kthGTFOZZ4GCTgC9M4rrHbPO2/duJBVF
         42Qg==
X-Gm-Message-State: AOJu0Yx948w1koyJ+t76LWERpNOkr+FZ0/aZA56qo8O5vFQIU9FbnKiU
	3zVqTShK2paXYO6tP/VP+MAww/ZECIEQjnYg/jZhmQ==
X-Google-Smtp-Source: AGHT+IElqfgkTtUO0/BuQ+5/kFgQWb+8Ch4D3J+irZT5GSi7IJL+nl7tY7mlEpmV9MFXsVujdKNzO0SI8enMSxwms7k=
X-Received: by 2002:a5d:58e1:0:b0:31f:6524:2de1 with SMTP id
 f1-20020a5d58e1000000b0031f65242de1mr10259399wrd.32.1696277447607; Mon, 02
 Oct 2023 13:10:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231002-disable-wformat-truncation-overflow-non-kprintf-v1-1-35179205c8d9@kernel.org>
In-Reply-To: <20231002-disable-wformat-truncation-overflow-non-kprintf-v1-1-35179205c8d9@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 2 Oct 2023 13:10:34 -0700
Message-ID: <CAKwvOdn-NqEjfteby_9hKBcrC-24P7tRnmGiTpa4fL66eJOZ8w@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Disable clang's -Wformat-{overflow,truncation}-non-kprintf
To: Nathan Chancellor <nathan@kernel.org>
Cc: masahiroy@kernel.org, nicolas@fjasle.eu, trix@redhat.com, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 2, 2023 at 12:52=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Recently, clang added support for -Wformat-overflow and
> -Wformat-truncation. When building the kernel, it was discovered that
> clang's implementation of these warnings handles the '%p' specifier,
> which differs from GCC's implementation. This results in false positive
> warnings due to the kernel's various '%p' extensions. Fortunately, the
> clang developers placed this warning difference into a separate flag,
> allowing the kernel to turn off the warning for '%p' unconditionally.
>
> This is not currently an issue for a normal build, as -Wformat-overflow
> and -Wformat-truncation are unconditionally disabled, which includes
> this sub-warning. However, ever since commit 6d4ab2e97dcf ("extrawarn:
> enable format and stringop overflow warnings in W=3D1"), these warnings
> are in W=3D1 and the goal is to enable them in the normal build once they
> are all eliminated. Disable the warnings for W=3D1 to avoid false
> positives. This block should move with -Wformat-overflow and
> -Wformat-truncation when they are enabled for a normal build.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1923
> Link: https://github.com/llvm/llvm-project/issues/64871
> Link: https://github.com/llvm/llvm-project/pull/65969
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D111219
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D78512
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

This should be the final piece of the puzzle...a long arduous puzzle.
Thanks Nathan!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  scripts/Makefile.extrawarn | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index 2fe6f2828d37..bad1baa2cfb4 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -106,6 +106,13 @@ KBUILD_CFLAGS +=3D $(call cc-option, -Wunused-const-=
variable)
>  KBUILD_CFLAGS +=3D $(call cc-option, -Wpacked-not-aligned)
>  KBUILD_CFLAGS +=3D $(call cc-option, -Wformat-overflow)
>  KBUILD_CFLAGS +=3D $(call cc-option, -Wformat-truncation)
> +# Clang checks for overflow/truncation with '%p', while GCC does not:
> +# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D111219
> +# The kernel has many extensions to '%p' that clang does not understand,=
 so
> +# always disable these warnings when '-Wformat-truncation' and
> +# '-Wformat-overflow' are enabled.
> +KBUILD_CFLAGS +=3D $(call cc-disable-warning, format-overflow-non-kprint=
f)
> +KBUILD_CFLAGS +=3D $(call cc-disable-warning, format-truncation-non-kpri=
ntf)
>  KBUILD_CFLAGS +=3D $(call cc-option, -Wstringop-overflow)
>  KBUILD_CFLAGS +=3D $(call cc-option, -Wstringop-truncation)
>
>
> ---
> base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
> change-id: 20231002-disable-wformat-truncation-overflow-non-kprintf-033e8=
d8b4de8
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>


--=20
Thanks,
~Nick Desaulniers
