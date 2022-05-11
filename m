Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2680D3207
	for <patches@lists.linux.dev>; Wed, 11 May 2022 20:02:10 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id z5-20020a9d62c5000000b00606041d11f1so1216057otk.2
        for <patches@lists.linux.dev>; Wed, 11 May 2022 13:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=ZiUnLeYbAAtBNeslKJ9kDfYPeiKddn2ujL9ZO9dbSss=;
        b=bD2jJUxhWqh1lySszIE6XLnaP0Rc3hQKNhJYPj+1QAWKz166Ne05+bVaF9Ip0b6RNp
         39+W5UNlxspOsU6LgoLlexDdWL8RmmShTWAPFeqztyIjMs6ce3dbUqnfajF+meUDTiBj
         mgkc3OkV+pyIX2EXl8ByYXT+ExNA+K16yEWXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=ZiUnLeYbAAtBNeslKJ9kDfYPeiKddn2ujL9ZO9dbSss=;
        b=KJH22WY/S38tyeqgetNzAR8TLytXa0saAjJf3DRFBejo9CVCBA/IUkFiUuKEYeSWCh
         s8/oEQWdIZqaSQBWDzjjJdzsjOLQsezSJGMTnhD6cGYez6TrSm0sawzJLQNGCWUy5rgE
         +YDpgLPX/yO+a5aOpOY+niEh4W+mVN6uuuGa2pyVMTLsCGGDdZpdk4L2HmbV25CdkHz8
         5YglDZHueCIp9UswSl0K9DzXWLlbIeRtm5UI7/j/p3182Kwv1VrrACC77TR9WDLvqzdK
         6HlVMwT74RACuqauZBlbxsdQeqm15xIpK+T4J5tdlXEvnSfk0rwdNUx9m/IhJY4xnvPY
         UiuA==
X-Gm-Message-State: AOAM532jAlB1MXckm+WIlzW+h+1CstfAcTkj45sKy5zG4dkMJd2fURmn
	IQOenOIkRQaM3+Okp8iYW9qQHXNEm1lO1cZV+6EpzQ==
X-Google-Smtp-Source: ABdhPJzQSi37hJE4uy4An6c89r8omucO8AAe2OanTEc2+fADtdfeWbzQmb0Q/jsDaV/PniOYPvDHQ45PkpNAOpxBjrQ=
X-Received: by 2002:a05:6830:13ce:b0:606:702b:87f0 with SMTP id
 e14-20020a05683013ce00b00606702b87f0mr8503289otq.159.1652299330101; Wed, 11
 May 2022 13:02:10 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 May 2022 13:02:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <87sfphpwvy.ffs@tglx>
References: <20220504223148.644228-1-swboyd@chromium.org> <87sfphpwvy.ffs@tglx>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 11 May 2022 13:02:09 -0700
Message-ID: <CAE-0n51KTiQjVqJgFe3S9qCiTM+2jdqyVZ1trNO1KanbQJccyA@mail.gmail.com>
Subject: Re: [PATCH] timers: Provide a better debugobjects hint for delayed works
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Thomas Gleixner (2022-05-10 02:20:01)
> On Wed, May 04 2022 at 15:31, Stephen Boyd wrote:
> > ---
> > I have an alternative approach which is to treat delayed works with a
> > different debug_obj_descr structure but it basically boils down to
> > another version of timer debugobjects in the workqueue code. The idea is
> > to make the delayed work active once the timer is queued and then
> > convert it over from a delayed work descriptor to a work descriptor once
> > the timer runs delayed_work_timer_fn() or when we pull it off to flush
> > out.
>
> Nah.

:)

>
> >  #include <linux/uaccess.h>
> >  #include <asm/unistd.h>
> > @@ -617,7 +618,17 @@ static const struct debug_obj_descr timer_debug_descr;
> >
> >  static void *timer_debug_hint(void *addr)
> >  {
> > -     return ((struct timer_list *) addr)->function;
> > +     struct timer_list *timer = addr;
> > +
> > +     if (timer->function == delayed_work_timer_fn) {
> > +             struct delayed_work *dwork;
> > +
> > +             dwork = container_of(timer, struct delayed_work, timer);
> > +
> > +             return dwork->work.func;
> > +     }
>
> The same issue exists for kthread_delayed_work_timer_fn.
>
> So maybe something like the uncompiled/untested below.

Cool. Looks good to me. One problem below.

>
> Thanks,
>
>         tglx
> ---
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -638,9 +638,35 @@ static void internal_add_timer(struct ti
>
>  static const struct debug_obj_descr timer_debug_descr;
>
> +struct timer_hint {
> +       void    (*function)(struct timer_list *);
> +       long    offset;
> +};
> +
> +#define TIMER_HINT(fn, container, timr, hintfn)                        \
> +       {                                                       \
> +               .function = fn,                                 \
> +               .offset   = offsetof(container, hintfn) -       \
> +                           offsetof(container, timr)   \
> +       }
> +
> +static const struct timer_hint timer_hints[] = {
> +       TIMER_HINT(delayed_work_timer_fn,
> +                  struct delayed_work, timer, work.func),
> +       TIMER_HINT(kthread_delayed_work_timer_fn,
> +                  struct kthread_delayed_work, timer, work.func),
> +};
> +
>  static void *timer_debug_hint(void *addr)
>  {
> -       return ((struct timer_list *) addr)->function;
> +       struct timer_list *timer = addr;
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(timer_hints); i++) {
> +               if (timer_hints[i].function == timer->function)
> +                       return addr + timer_hints[i].offset;

This locates the correct address of the function pointer 'work.func' but
it needs to be dereferenced to return the function's address instead of
the pointer to the function. We don't really care about the function
signature so we could cast it to a void function pointer and deref:

                      void (**fn)(void) = addr + timer_hints[i].offset;

		      return *fn;

I'll send this version of the patch.
