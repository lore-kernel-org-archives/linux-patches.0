Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CC21FB8
	for <patches@lists.linux.dev>; Tue, 15 Mar 2022 10:59:15 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id x4so21646234iop.7
        for <patches@lists.linux.dev>; Tue, 15 Mar 2022 03:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ERUzPoz66Ekz8nytoz/D+JRh+ZH5me7GDLLHYHnWy0A=;
        b=DNMXTz4QnRjR+nCPg4W8oECmhMSeuznOBIGbG0djWLZr7uEIVhpUlvllDzaVWq09Lq
         7qhBfxL7L9oioGj7719rt4ITKy36Zc8Tu0kKIVUgwp+zevLBroxAqlCg+Iib/zEG9IWh
         dyjuJBpMtnWrFM2RNQ68xWZQ58CfsGIrSLMp/i/94FYhJkBuzIlWDrn0wU/ISSOznOdH
         IZFAIdy1cROwMZNIxVtHKrf58YMJmGuwLIzi6crcr+8m2YAtwyDyb1oFoO6Hn0R/BtS6
         AALbrOCG1Tsi++dCllCQtTDlXHN+p0OmOSiWhP8gc2nMjiprqCgU6WwbrUQAX5yQwY8g
         rCEg==
X-Gm-Message-State: AOAM531RrXw4SLT/J1ziVeMtmHldd+spJnthzlIyxs7HpYcVJYka/DjC
	naDKm2rtsEAO56h9DmGCZzLfkFB0jQcn6fBkB74=
X-Google-Smtp-Source: ABdhPJze7jADM6hxsoUDLohxwrGeIietgUF+xluv+LJwGWqkX9IBmJfQx7VEw75753nUERdXj/GevRAwuXVs6OOkMe4=
X-Received: by 2002:a02:6910:0:b0:319:4f4c:eede with SMTP id
 e16-20020a026910000000b003194f4ceedemr22571720jac.301.1647341954431; Tue, 15
 Mar 2022 03:59:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220312195210.23573-1-rdunlap@infradead.org>
In-Reply-To: <20220312195210.23573-1-rdunlap@infradead.org>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 15 Mar 2022 11:59:02 +0100
Message-ID: <CAJZ5v0gBYki-PFHiNGuFmpxQGB_+rW0i5D6VThsPHY6GFwGnYg@mail.gmail.com>
Subject: Re: [PATCH v2] clocksource: acpi_pm: fix return value of __setup handler
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	Dan Carpenter <dan.carpenter@oracle.com>, John Stultz <john.stultz@linaro.org>, 
	Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, 
	"Rafael J. Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, Mar 12, 2022 at 8:52 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> __setup() handlers should return 1 to obsolete_checksetup() in
> init/main.c to indicate that the boot option has been handled.
> A return of 0 causes the boot option/value to be listed as an Unknown
> kernel parameter and added to init's (limited) environment strings.
>
> The __setup() handler interface isn't meant to handle negative return
> values -- they are non-zero, so they mean "handled" (like a return
> value of 1 does), but that's just a quirk. So return 1 from
> parse_pmtmr(). Also print a warning message if kstrtouint() returns
> an error.
>
> Fixes: 6b148507d3d0 ("pmtmr: allow command line override of ioport")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> From: Igor Zhbanov <i.zhbanov@omprussia.ru>
> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>

Can you please resend this with a CC to linux-acpi?

> ---
> v2: correct the Fixes: tag (Dan Carpenter)
>
>  drivers/clocksource/acpi_pm.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> --- linux-next-20220310.orig/drivers/clocksource/acpi_pm.c
> +++ linux-next-20220310/drivers/clocksource/acpi_pm.c
> @@ -229,8 +229,10 @@ static int __init parse_pmtmr(char *arg)
>         int ret;
>
>         ret = kstrtouint(arg, 16, &base);
> -       if (ret)
> -               return ret;
> +       if (ret) {
> +               pr_warn("PMTMR: invalid 'pmtmr=' value: '%s'\n", arg);
> +               return 1;
> +       }
>
>         pr_info("PMTMR IOPort override: 0x%04x -> 0x%04x\n", pmtmr_ioport,
>                 base);
