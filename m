Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5146C1079A
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 20:22:46 +0000 (UTC)
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2bcc4347d2dso4909711fa.0
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 13:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694031764; x=1694636564; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zxKCsV8R8YrR5Gy4S8qpXFuMk6MLJhqEnRXr9jkGcto=;
        b=bDQG/Sblu+VE+5ugk6xT02cUz/cfyFsFxVFpTu0uBtQJ5O4RaSBV6V94/80WaCbyIP
         BkGpEVndFxkaa7gDDpcbgRf/oBxcjb6kO5icfbPwQpuBmD7SJpw2RmMOs+iudTtJqWcW
         0FuCnLI1lXR8+EaELxb0snWIAWDwh45bB/ZZI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694031764; x=1694636564;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zxKCsV8R8YrR5Gy4S8qpXFuMk6MLJhqEnRXr9jkGcto=;
        b=VI01CN8SZFfCukTdY/aXQUwWexdYzchwcHEsOIBz3zzdryX8ZZoiO0GB+lC91GaVgr
         hewxri8SGnwMM5DsLyqI9L/C0YbSwiV8ICu9wgvqtBCtYwqDN0RhHQGAqWxSy6xt6i09
         0cLaTN0MnlbnGTCnE3o2GSIG5U3arThbYs3x8RArL7OC3ejhvqhzRNWIiapMthNwlLgr
         wBHecNrAKalXTRGXMNGDgX+iaVFxv9PAkXdAsPeddv04cXp/hg8X53yUZWrNLrSa1BUZ
         Lxfzwt0dgMl0OvbmZGtU4vV8eoljAB7ioWJc6HqFULqDNna4oFSN6rvhWQcgrU6NAIHr
         62kg==
X-Gm-Message-State: AOJu0YzQFbIrrDpgGEY6rwresRae8/Jxm0yotYs6N60hn2ydwkZ7pIK2
	K8kpACH2rosy6KUuGGYfNQpfWXBOaGGlHzyN35wSsQ==
X-Google-Smtp-Source: AGHT+IEmvetndVdOFFwz7V6Ymy0S4rpC+9TPoqGCwOVPobwU6fcOpZdLTjsBJP1lmQrg+aBzt/1Fql+MvEJ3cIL85Eo=
X-Received: by 2002:a2e:8756:0:b0:2b6:e2aa:8fbc with SMTP id
 q22-20020a2e8756000000b002b6e2aa8fbcmr3268617ljj.8.1694031764129; Wed, 06 Sep
 2023 13:22:44 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 6 Sep 2023 15:22:43 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZPjdZ3xNmBEBvNiS@smile.fi.intel.com>
References: <20230906180944.2197111-1-swboyd@chromium.org> <20230906180944.2197111-4-swboyd@chromium.org>
 <ZPjdZ3xNmBEBvNiS@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 6 Sep 2023 15:22:43 -0500
Message-ID: <CAE-0n53iGCL3q=CsDKZr28eMjx40miLNG6+-jf12JKMxuAKkKg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] platform/x86: intel_scu_ipc: Fail IPC send if
 still busy
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, 
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Andy Shevchenko (2023-09-06 13:13:27)
> On Wed, Sep 06, 2023 at 11:09:43AM -0700, Stephen Boyd wrote:
> > It's possible for interrupts to get significantly delayed to the point
> > that callers of intel_scu_ipc_dev_command() and friends can call the
> > function once, hit a timeout, and call it again while the interrupt
> > still hasn't been processed. This driver will get seriously confused if
> > the interrupt is finally processed after the second IPC has been sent
> > with ipc_command(). It won't know which IPC has been completed. This
> > could be quite disastrous if calling code assumes something has happened
> > upon return from intel_scu_ipc_dev_simple_command() when it actually
> > hasn't.
> >
> > Let's avoid this scenario by simply returning -EBUSY in this case.
> > Hopefully higher layers will know to back off or fail gracefully when
> > this happens. It's all highly unlikely anyway, but it's better to be
> > correct here as we have no way to know which IPC the status register is
> > telling us about if we send a second IPC while the previous IPC is still
> > processing.
>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> Also see below.
>
> ...
>
> > @@ -450,6 +468,12 @@ int intel_scu_ipc_dev_simple_command(struct intel_scu_ipc_dev *scu, int cmd,
> >               return -ENODEV;
> >       }
>
> >       scu = ipcdev;
>
> Side observation: Isn't this a bug? We should not override the supplied parameter.

If it is a bug that would be great to know. I wanted to make an API that
got the scu if it wasn't busy but then I ran across this code that
replaced the scu with ipcdev.
