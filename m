Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387964AA3
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 16:03:37 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id 60so4494708uae.1
        for <patches@lists.linux.dev>; Fri, 18 Feb 2022 08:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a/tt/i/SHiINJEY0pzj/+Ldx+3Qwg7aOlXBO5O3mv/g=;
        b=dF4InSk4puY7t63FDNQji1VKBMAT10aW6SsRaj+tbGjKZBA7rCD6pWG5TDIOUYZs6d
         52g9JlO5u2/5vAvhhXDbgKidl3IcbTgCPe3jNeCsjUK9FLQY9n9zO8f1y5naKqP3Sa5P
         6GKB8aFGjIk9FgIJB2WZatULVInnG6CvYYyvh929X6pCjT5OuXW71PguXiOApK1ZNhuT
         riblrkDGEjVWLHl8fFmKnX12m+X1DNxNvEgBeFwgNXqv5j+bZkRW75RYE9667sBznToC
         Oi0OVnAmg+weJANXpwN9GQNBpPcnyRiuHypFs7bPUZZAfQYlurfZET/5qT1iznjdQTv8
         ZHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a/tt/i/SHiINJEY0pzj/+Ldx+3Qwg7aOlXBO5O3mv/g=;
        b=fWc0mHbRwxXEZvPwPUCUbbHeqNcy3TbjwzEIKsemSU7zdcx1K2OVzWmIjQhzAwQS3S
         n5AXiWc7G08AL22mvZw4gsLUUET+tg/m61KjpEmj0dHlfzcGLt+ZHau1/swG+Ae1tIEz
         B2QMCFUrdPCoeMKAhIytm8vrGk7K29WorsN9IgfCWjL1EFvYk/s6V2bzyu6p40Odz/gd
         mV6n59GOyDFqp5eLax7Iyph5UMLmVgFQM7CLNPh39v19NkRsDWEa53GDjev3XUXHjwE/
         8Oa2+QcMciiVTijLO/2RcdvfmIA6Gv3ric4bHqY+5gi2HYHwMRA8CGRqZy5tg0pZJhsp
         w6jA==
X-Gm-Message-State: AOAM532tlhbBznRsYxmUiswXPc+RZCBApqtNXg2oTlIPKyYLP5UvnGKe
	F74nBh8zsAO6oH8BV1ecDKRzSZTJRevwWTtQXkcJcg==
X-Google-Smtp-Source: ABdhPJweA9UfX0PBbz3wdvBXso5dR5TQDJ3ynb4y/07Jh18joreI6URQtKSRC6DR2FHWxXidwq0Il055iZlCfHPircE=
X-Received: by 2002:ab0:60b1:0:b0:341:543e:c388 with SMTP id
 f17-20020ab060b1000000b00341543ec388mr3233205uam.80.1645200215894; Fri, 18
 Feb 2022 08:03:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Yg54nse5qNQO3sbW@zn.tnic> <20220218013209.2436006-1-juew@google.com>
 <Yg+2Hc78nfSRmh/j@zn.tnic>
In-Reply-To: <Yg+2Hc78nfSRmh/j@zn.tnic>
From: Jue Wang <juew@google.com>
Date: Fri, 18 Feb 2022 08:03:24 -0800
Message-ID: <CAPcxDJ4c3eGXTB9UPJmZ8dzyCNPW4Lv9s1QSeoCWq_LdNWTrJw@mail.gmail.com>
Subject: Re: [PATCH v2] x86/mce: work around an erratum on fast string copy instructions.
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 18, 2022 at 7:07 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Feb 17, 2022 at 05:32:09PM -0800, Jue Wang wrote:
> > +static noinstr bool quirk_skylake_repmov(void)
> > +{
> > +     u64 mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
> > +     u64 misc_enable = __rdmsr(MSR_IA32_MISC_ENABLE);
> > +
> > +     /*
> > +      * Apply the quirk only to local machine checks, i.e., no broadcast
> > +      * sync is needed.
> > +      */
> > +     if ((mcgstatus & MCG_STATUS_LMCES) &&
> > +         unlikely(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
> > +             u64 mc1_status = mce_rdmsrl(MSR_IA32_MCx_STATUS(1));
> > +
> > +             /* Check for a software-recoverable data fetch error. */
> > +             if ((mc1_status &
> > +                  (MCI_STATUS_VAL | MCI_STATUS_OVER | MCI_STATUS_UC | MCI_STATUS_EN |
> > +                   MCI_STATUS_ADDRV | MCI_STATUS_MISCV | MCI_STATUS_PCC |
> > +                   MCI_STATUS_AR | MCI_STATUS_S)) ==
> > +                  (MCI_STATUS_VAL |                   MCI_STATUS_UC | MCI_STATUS_EN |
> > +                   MCI_STATUS_ADDRV | MCI_STATUS_MISCV |
> > +                   MCI_STATUS_AR | MCI_STATUS_S)) {
> > +                     misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
> > +                     __wrmsr(MSR_IA32_MISC_ENABLE,
> > +                             (u32)misc_enable, (u32)(misc_enable >> 32));
>
> "You're going to have to use the mce_{rd,wr}msrl() routines."
>
> I actually really meant that.
Thanks.

Since MSR_IA32_MISC_ENABLE is not a MCA register, I wonder if we want
to mix its read/write with the injected MCE code. I was a bit concerned about
potential race with mce-inject and the read/write to MSR_IA32_MISC_ENABLE.

>
> And I went and simplified this a bit more so that it is more readable,
> diff ontop.
>
> Also, Tony, I think the clearing of MCG_STATUS should happen last.
>
> ---
> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
> index c1a41da99975..1741be9b9464 100644
> --- a/arch/x86/kernel/cpu/mce/core.c
> +++ b/arch/x86/kernel/cpu/mce/core.c
> @@ -831,34 +831,35 @@ quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
>   */
>  static noinstr bool quirk_skylake_repmov(void)
>  {
> -       u64 mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
> -       u64 misc_enable = __rdmsr(MSR_IA32_MISC_ENABLE);
> +       u64 mcgstatus   = mce_rdmsrl(MSR_IA32_MCG_STATUS);
> +       u64 misc_enable = mce_rdmsrl(MSR_IA32_MISC_ENABLE);
> +       u64 mc1_status;
>
>         /*
>          * Apply the quirk only to local machine checks, i.e., no broadcast
>          * sync is needed.
>          */
> -       if ((mcgstatus & MCG_STATUS_LMCES) &&
> -           (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
> -               u64 mc1_status = mce_rdmsrl(MSR_IA32_MCx_STATUS(1));
> -
> -               /* Check for a software-recoverable data fetch error. */
> -               if ((mc1_status &
> -                    (MCI_STATUS_VAL | MCI_STATUS_OVER | MCI_STATUS_UC | MCI_STATUS_EN |
> -                     MCI_STATUS_ADDRV | MCI_STATUS_MISCV | MCI_STATUS_PCC |
> -                     MCI_STATUS_AR | MCI_STATUS_S)) ==
> -                    (MCI_STATUS_VAL |                   MCI_STATUS_UC | MCI_STATUS_EN |
> -                     MCI_STATUS_ADDRV | MCI_STATUS_MISCV |
> -                     MCI_STATUS_AR | MCI_STATUS_S)) {
> -                       misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
> -                       __wrmsr(MSR_IA32_MISC_ENABLE,
> -                               (u32)misc_enable, (u32)(misc_enable >> 32));
> -                       mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
> -                       mce_wrmsrl(MSR_IA32_MCx_STATUS(1), 0);
> -                       pr_err_once("Errata detected, disable fast string copy instructions.\n");
> -                       return true;
> -               }
> +       if (!(mcgstatus & MCG_STATUS_LMCES) ||
> +           !(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING))
> +               return false;
> +
> +       mc1_status = mce_rdmsrl(MSR_IA32_MCx_STATUS(1));
> +
> +       /* Check for a software-recoverable data fetch error. */
> +       if ((mc1_status &
> +            (MCI_STATUS_VAL | MCI_STATUS_OVER | MCI_STATUS_UC | MCI_STATUS_EN |
> +             MCI_STATUS_ADDRV | MCI_STATUS_MISCV | MCI_STATUS_PCC |
> +             MCI_STATUS_AR | MCI_STATUS_S)) ==
> +            (MCI_STATUS_VAL |                   MCI_STATUS_UC | MCI_STATUS_EN |
> +             MCI_STATUS_ADDRV | MCI_STATUS_MISCV |
> +             MCI_STATUS_AR | MCI_STATUS_S)) {
> +               misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
> +               mce_wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +               mce_wrmsrl(MSR_IA32_MCx_STATUS(1), 0);
> +               pr_err_once("Erratum detected, disable fast string copy instructions.\n");
> +               return true;
>         }
> +
>         return false;
>  }
>
> @@ -1432,7 +1433,7 @@ noinstr void do_machine_check(struct pt_regs *regs)
>                 return unexpected_machine_check(regs);
>
>         if (mce_flags.skx_repmov_quirk && quirk_skylake_repmov())
> -               return;
> +               goto clear;
>
>         /*
>          * Establish sequential order between the CPUs entering the machine
> @@ -1576,6 +1577,7 @@ noinstr void do_machine_check(struct pt_regs *regs)
>  out:
>         instrumentation_end();
>
> +clear:
>         mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
>  }
>  EXPORT_SYMBOL_GPL(do_machine_check);
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
