Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7DF10F9;
	Thu,  2 Nov 2023 02:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkGdaTwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5506C433C8;
	Thu,  2 Nov 2023 02:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698891549;
	bh=czmTJWGlC2A4F+PpPIZtRcQfp/u6tBBFvfSYhhga5mE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DkGdaTwUKxKwP8PCNG0ZbuyZU1sbvwp7cprxvRaTrn8qVGNKN2g8pKWnxVnb30SMc
	 kwS7U6t52F/RLSU2tcMQsS5KTp6XtxrI4nxZUoqy7kJ5HXePoop7A/FyygVNa3GN7i
	 /dxHae9GpLjQ5aQdVtR6g8ori3ztBqLKrd/QfupI3YWtu0ixPGIGSE2xa9VLWALAnk
	 ltfl64Ju1xU0CJMBDz1Ajx5DSYR3SGSPiEaNP8qTgB6RlZwsT4SS8G2Xo5H2umGy4D
	 OFuMRG7/PSaO2XpqdZ4bjzEn03cft6wEPidC0RrtBRDZnEXiT5PJsSAgRJtUE5GVGa
	 JrGM+uZkGArmw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-9db6cf8309cso40295466b.0;
        Wed, 01 Nov 2023 19:19:09 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw6mBjaZgbUhHpfd6LwKDr7k7MLm44r+r7kjkui6X2iffMEdYep
	MNiKXfhb9lDcfh0ByAmdx2UGKmWW+pOCGD4ZcmI=
X-Google-Smtp-Source: AGHT+IGyPbHjbTnQ7f8KAYYDzh0jQTdtafu5w7r4h3UxVFHPQ5XQ6pZ0ym82tbsOeUPVr9UvsqNO40lpXTStG5USI+o=
X-Received: by 2002:a17:907:3da6:b0:9ae:614f:2023 with SMTP id
 he38-20020a1709073da600b009ae614f2023mr2994966ejc.56.1698891548216; Wed, 01
 Nov 2023 19:19:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231101-loongarch-always-inline-percpu-ops-v1-1-b8f2e9a71729@kernel.org>
 <20231101195517.GA1221384@dev-arch.thelio-3990X>
In-Reply-To: <20231101195517.GA1221384@dev-arch.thelio-3990X>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 2 Nov 2023 10:18:55 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7GjzYvS+F2__um0qJixb2Kp6=Nuiqjaz=gZupossOa=g@mail.gmail.com>
Message-ID: <CAAhV-H7GjzYvS+F2__um0qJixb2Kp6=Nuiqjaz=gZupossOa=g@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: Mark __percpu functions as always inline
To: Nathan Chancellor <nathan@kernel.org>
Cc: kernel@xen0n.name, ndesaulniers@google.com, trix@redhat.com, 
	jiaxun.yang@flygoat.com, loongarch@lists.linux.dev, llvm@lists.linux.dev, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Nathan,

On Thu, Nov 2, 2023 at 3:55=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> On Wed, Nov 01, 2023 at 12:43:29PM -0700, Nathan Chancellor wrote:
> > A recent change to the optimization pipeline in LLVM reveals some
> > fragility around the inlining of LoongArch's __percpu functions, which
> > manifests as a BUILD_BUG() failure:
> >
> >   In file included from kernel/sched/build_policy.c:17:
> >   In file included from include/linux/sched/cputime.h:5:
> >   In file included from include/linux/sched/signal.h:5:
> >   In file included from include/linux/rculist.h:11:
> >   In file included from include/linux/rcupdate.h:26:
> >   In file included from include/linux/irqflags.h:18:
> >   arch/loongarch/include/asm/percpu.h:97:3: error: call to '__compileti=
me_assert_51' declared with 'error' attribute: BUILD_BUG failed
> >      97 |                 BUILD_BUG();
> >         |                 ^
> >   include/linux/build_bug.h:59:21: note: expanded from macro 'BUILD_BUG=
'
> >      59 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
> >         |                     ^
> >   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG=
_ON_MSG'
> >      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond=
), msg)
> >         |                                     ^
> >   include/linux/compiler_types.h:425:2: note: expanded from macro 'comp=
iletime_assert'
> >     425 |         _compiletime_assert(condition, msg, __compiletime_ass=
ert_, __COUNTER__)
> >         |         ^
> >   include/linux/compiler_types.h:413:2: note: expanded from macro '_com=
piletime_assert'
> >     413 |         __compiletime_assert(condition, msg, prefix, suffix)
> >         |         ^
> >   include/linux/compiler_types.h:406:4: note: expanded from macro '__co=
mpiletime_assert'
> >     406 |                         prefix ## suffix();                  =
           \
> >         |                         ^
> >   <scratch space>:86:1: note: expanded from here
> >      86 | __compiletime_assert_51
> >         | ^
> >   1 error generated.
> >
> > If these functions are not inlined, the BUILD_BUG() in the default case
> > cannot be eliminated since the compiler cannot prove it is never used,
> > resulting in a build failure due to the error attribute.
> >
> > Mark these functions as __always_inline so that the BUILD_BUG() only
> > triggers when the default case genuinely cannot be eliminated due to an
> > unexpected size.
> >
> > Cc:  <stable@vger.kernel.org>
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1955
> > Fixes: 46859ac8af52 ("LoongArch: Add multi-processor (SMP) support")
> > Link: https://github.com/llvm/llvm-project/commit/1a2e77cf9e11dbf56b572=
0c607313a566eebb16e
>
> This should have also had:
>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
>
> I can pick it up if I have to send a v2.
>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  arch/loongarch/include/asm/percpu.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/loongarch/include/asm/percpu.h b/arch/loongarch/inclu=
de/asm/percpu.h
> > index b9f567e66016..8fb857ae962b 100644
> > --- a/arch/loongarch/include/asm/percpu.h
> > +++ b/arch/loongarch/include/asm/percpu.h
> > @@ -32,7 +32,7 @@ static inline void set_my_cpu_offset(unsigned long of=
f)
> >  #define __my_cpu_offset __my_cpu_offset
> >
> >  #define PERCPU_OP(op, asm_op, c_op)                                  \
> > -static inline unsigned long __percpu_##op(void *ptr,                 \
> > +static __always_inline unsigned long __percpu_##op(void *ptr,         =
               \
> >                       unsigned long val, int size)                    \
> >  {                                                                    \
> >       unsigned long ret;                                              \
> > @@ -63,7 +63,7 @@ PERCPU_OP(and, and, &)
> >  PERCPU_OP(or, or, |)
> >  #undef PERCPU_OP
> >
> > -static inline unsigned long __percpu_read(void *ptr, int size)
> > +static __always_inline unsigned long __percpu_read(void *ptr, int size=
)
> >  {
> >       unsigned long ret;
> >
Thank you for your patch, but I think __percpu_write() and
__percpu_xchg() also need __always_inline because they also have
BUILD_BUG(). Although we don't meet problems about them, they have
potential problems in theory.

Huacai

> >
> > ---
> > base-commit: 278be83601dd1725d4732241f066d528e160a39d
> > change-id: 20231101-loongarch-always-inline-percpu-ops-cf77c161871f
> >
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> >
>
