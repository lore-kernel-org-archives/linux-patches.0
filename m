Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F3F184A
	for <patches@lists.linux.dev>; Tue, 14 Jun 2022 06:17:52 +0000 (UTC)
Received: by mail-oi1-f170.google.com with SMTP id p129so10467300oig.3
        for <patches@lists.linux.dev>; Mon, 13 Jun 2022 23:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=gOEl91mjcJeb3w5SzAgKFGPOqBzDaIuMhG5InT1ls1E=;
        b=THuDK5XPApSFGyrtaoCGy7gUt4PXTVEJSdeZJFL1xpqFgV1avMFFtdPiQC+2wRul08
         KheYxd3YdmF4qhojKX8MjxGYuo+y8+eSE+aavqVrtO+VlSCToLWqNs/J+nY7WhiRSR/W
         D/MFEvizYq4nBCWbd5uKKEG46Dhpsnfrzu9oo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=gOEl91mjcJeb3w5SzAgKFGPOqBzDaIuMhG5InT1ls1E=;
        b=qosBmHZr893LFqXkKlQt9FUCfTCyelJk1pS5aX++VQN29vyU2kdlNSM0vpOmS9FekY
         By1KPMJrGFvywPoN30xOxK7AYH+BkFl86+J4A8Q6exKowZDuR3OIP85n4R2AAq0jAb0I
         c+m8rsl/7eP+bRfnLYQBJmg9b5FmCTvTrNWt0Z8ade/xYSiVnaIPunmTHn4s0QzKv+cP
         Z3vAzOMtlc1orivAAaLncmyCbEi54bJqCs0EybBol2BKMufctwgXK2M7bBI3Gm22Roy1
         KsXveJ0TOhkl9Kt1PHmQfhqUdQsrYXlWZXxqOhpWuIihBRBXz/IRAgpl2zaglnPfqic5
         KsxQ==
X-Gm-Message-State: AOAM531aqIF8AN9L3i9s5IiaXl8yfRUPjVWrWY15vCNsvDz/3aC8J+BQ
	Kne7HbnsE7Es3qN3YdwMIctSFgSFxqq0x39o0j2W6A==
X-Google-Smtp-Source: ABdhPJzJAd9THv709T3xWg4FPuEIorZIfFmHVI1lG7V+TxQeJUuHS/awP2qLLjLflIxpvFu2uABRmPX5vG9rirgFSNY=
X-Received: by 2002:a05:6808:e87:b0:32e:4789:d2c with SMTP id
 k7-20020a0568080e8700b0032e47890d2cmr1220154oil.193.1655187471061; Mon, 13
 Jun 2022 23:17:51 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 13 Jun 2022 23:17:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Yqgc6sD7bEHLVYRg@google.com>
References: <20220611061825.4119270-1-swboyd@chromium.org> <Yqgc6sD7bEHLVYRg@google.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 13 Jun 2022 23:17:50 -0700
Message-ID: <CAE-0n53aiXq+eUC0gq=J0kO+_zFpZGnL42AgyEBVM-_wtccnJA@mail.gmail.com>
Subject: Re: [PATCH v2] platform/chrome: cros_ec: Always expose last resume result
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Guenter Roeck <groeck@chromium.org>, 
	chrome-platform@lists.linux.dev, Evan Green <evgreen@chromium.org>, 
	Rajat Jain <rajatja@chromium.org>, Matthias Kaehlcke <mka@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Tzung-Bi Shih (2022-06-13 22:30:18)
> On Fri, Jun 10, 2022 at 11:18:25PM -0700, Stephen Boyd wrote:
> > @@ -135,10 +135,10 @@ static int cros_ec_sleep_event(struct cros_ec_device *ec_dev, u8 sleep_event)
> >       buf.msg.command = EC_CMD_HOST_SLEEP_EVENT;
> >
> >       ret = cros_ec_cmd_xfer_status(ec_dev, &buf.msg);
> > -
> > -     /* For now, report failure to transition to S0ix with a warning. */
> > +     /* Report failure to transition to system wide suspend with a warning. */
> >       if (ret >= 0 && ec_dev->host_sleep_v1 &&
> > -         (sleep_event == HOST_SLEEP_EVENT_S0IX_RESUME)) {
> > +         (sleep_event == HOST_SLEEP_EVENT_S0IX_RESUME ||
> > +          sleep_event == HOST_SLEEP_EVENT_S3_RESUME)) {
> >               ec_dev->last_resume_result =
> >                       buf.u.resp1.resume_response.sleep_transitions;
>
> The warning in the if-block:
> WARN_ONCE(buf.u.resp1.resume_response.sleep_transitions &
>           EC_HOST_RESUME_SLEEP_TIMEOUT,
>           "EC detected sleep transition timeout. Total slp_s0 transitions: %d",
>           buf.u.resp1.resume_response.sleep_transitions &
>           EC_HOST_RESUME_SLEEP_TRANSITIONS_MASK);
>
> Not sure and I wonder if the term "slp_s0" is still generic enough to the case.
> And also [1].
>
> [1]: https://crrev.com/a311a7657ca0a488f507fa78fd9c2d825cbf083e/power_manager/powerd/system/suspend_configurator.cc#98

I don't know what "slp_s0" means. I guess it's some intelism? It could
change to "sleep" and work for me.

>
> At least we should fix [2] once the patch landed.
>
> [2]: https://crrev.com/a311a7657ca0a488f507fa78fd9c2d825cbf083e/power_manager/tools/suspend_stress_test#369

And by fix you mean change "S0iX" to "suspend"?
