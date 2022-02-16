Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D652911
	for <patches@lists.linux.dev>; Wed, 16 Feb 2022 15:50:37 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id u2so3045282wrw.1
        for <patches@lists.linux.dev>; Wed, 16 Feb 2022 07:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hliIdd752PVyrplihGKCvTCkvfLt0yHXLtglCy+GWyU=;
        b=czP0AYbrLj85n4nJXQpyPUVWsaUiVbzsWOeQeC8FFdNtW8R2iTdOROaBqa5QP3NRxm
         XW32Q1P3CDIS4eRDLcyCCyhQvwOJeJVNxaokZSs73N6I8vXuoDVCLPLU+Eei9I1FZkzI
         SYyD07vaKzrq82JBN1KtclP7RyPv7WFTSMF3DNoVf3Ws7ZnBcny+zM4kEBDrBmciixq5
         O2Nx14octwS/7ABes15MXLUdISBz6KHx27WTZ7dxIFnMeJaCjA4W+St55du4SntWtFQ2
         2pqJpRQC0uxairq0BIRW6kyLhdAHJrcaYBcnrBDgdf974+bftDIXBUh/yfo/AABYRlnk
         +qWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hliIdd752PVyrplihGKCvTCkvfLt0yHXLtglCy+GWyU=;
        b=s3JhF4OtcQ+l6a+xijpfoVIX1P+Kkx9JGWPYT7Hy6RgpIcJ0rojjo4zjcC4BA6tbAY
         pswsQBkAIbE+9/1E7eF62BF6GgZwaT7IvpCfhFlTXQmCZKYnpz4l16jISXKGW4sEqz92
         ufLHXvVdVwoNGJdk3l6Z3ygl5FHgXen/DGHjxYggFPzy1aPYn1TYVgonwq5kOLjeOIfr
         yRu3BnwhFbHJvQKtYfPX1pM+6P/NN5sq6A6zQ2He9j/L5woe0iW365UyiZZGAwZrl/U9
         ZtP7cfoc57R4BJ12RGARYsYXntpIBAcWmCRxwbIlzxyVlWWT0VNxj6IrhpY6WwK9tL27
         rjhQ==
X-Gm-Message-State: AOAM532+r0m/f5hzElyn5bPv2Lm3ie9OOQfNHYmVe/TodHWraoXD60mU
	FDDUmkbpEVJft38m5OEdE/Bzn6McFGlK/7rF1VRy6g==
X-Google-Smtp-Source: ABdhPJxwRV9174mD3gl49gYRGGXMejExK2a5uLPXlChYmfaxta/eWmfJSbEJsak1HASA+hJbmEG4J0OkIWIQrRalU8M=
X-Received: by 2002:adf:fe43:0:b0:1e4:a213:b876 with SMTP id
 m3-20020adffe43000000b001e4a213b876mr2831720wrs.513.1645026636090; Wed, 16
 Feb 2022 07:50:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
 <20220208150945.266978-1-juew@google.com> <Ygwka++3eipjQzB2@zn.tnic>
 <YgwnqTc8FGG3orcE@agluck-desk3.sc.intel.com> <YgzRsfWOmqkNiNI7@zn.tnic>
In-Reply-To: <YgzRsfWOmqkNiNI7@zn.tnic>
From: Jue Wang <juew@google.com>
Date: Wed, 16 Feb 2022 07:50:24 -0800
Message-ID: <CAPcxDJ4=iknzYbN=b2oQxvJyODkQ_MWEj1wkKEuGwf4HQ3aPZA@mail.gmail.com>
Subject: Re: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine checks
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 16, 2022 at 2:28 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Feb 15, 2022 at 02:22:33PM -0800, Luck, Tony wrote:
> > This early in do_machine check we don't know whether this was from
> > a over enthusistic REP;MOVS fetch, or a "normal" machine check.
> > I don't think there is an easy way to tell the difference.
>
> That's what I am wondering: whether we can compare the buffers REP;
> MOVS was accessing and determine whether the access was out of bounds.
> Something ala _ASM_EXTABLE_ as it is done in arch/x86/lib/copy_mc_64.S,
> for example, which will land us in fixup_exception().
>
> Now there we'd need to know the range the thing was copying which should
> be in pt_regs and the address the MCE reported. If latter is not in the
> former range, we say ignore.

This is a great idea.

My slight reservation is that this suggests all use cases of "REP; MOVS*" must
take the _ASM_EXTABLE_ form, which is not possible; considering
"REP; MOVS*" can be exercised from any user space program.

>
> There's even some blurb about "recovering from fast-string exceptions"
> over copy_mc_enhanced_fast_string...
>
> Hmmm?
If there is a way to get all users of "REP; MOVS*" to use
copy_mc_enhanced_fast_string, this could work. I am not sure this is possible.

>
> > The first check:
> >
> >       if ((mcgstatus & MCG_STATUS_LMCES)
> >
> > is for "is this a local machine check"? So no broadcast sync
> > needed. But that needs a comment.
>
> Yap.
Updated in the latest patch sent.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
