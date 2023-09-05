Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4ECA53
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 22:36:03 +0000 (UTC)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-500b6456c7eso5332443e87.2
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 15:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693953362; x=1694558162; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mqBAjXdhOu8rNG8LZMfu2X/hCbioMgAzV1nWy8X96U8=;
        b=PFRUW3WD4lWrJ2FLIWF4obQhM4gkoXyzfbKF5URv7+L1AkZNCgZAg2Tv/NVkqgM56P
         8hPQSCfhe5tFZ0Ak9c2pIGqv1XuR7DzNm+U/J5GOA8fGhPryOIMqHdtJKkr2dhSpLZpC
         hYmsqdWmNX6vXJy0aAHwN5wPCDbDrGlez1g1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693953362; x=1694558162;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqBAjXdhOu8rNG8LZMfu2X/hCbioMgAzV1nWy8X96U8=;
        b=RZ9bSg60mNBj/O/Ysy3DOo1073nBlBZR2PmXZym3MFG2zE2vJv6T+ITnv46/pReye7
         XYuRDkmUl68iDhlDv9ruyXd6LuI55TgyXa5MVxyqQB3wuy1tt1SDxZ/HalRmkV5x4Ce2
         I4mQ3FYjlGqsq4XW6lj354KJ/G89+zX+Oz3jX2P5MJWTo8njn31I8t2U54ho1CCAohz/
         OfGjg1VoHqJPWf3P58NIzoPOddhEbchqlUkq+GZtzcnaJkrKi5buVrQYVjwFwn1M1bOp
         /QF8a3ywC8ksKjh7DK0YBL1WwyPfmQKP3nu7vN4u58Eqc8eMmgWDS8LkYdrSj8kWJNNP
         yNFw==
X-Gm-Message-State: AOJu0YweuOTnPre+5RjyHemHMV+ULEX0bnh3t4NhHX0zYBm6uI76FA0Z
	3AJYbaAKYS0kI+jyhi4ug+ykeA29NM1fWXAYvbPgRQ==
X-Google-Smtp-Source: AGHT+IFEuggODTqIQUeNem7qYIdM/4a0tHs0r7nKkpG27Kc/WYRkH5LZUMm1RWDH7/xha6Fhn4IhMm50ZT6fmlDJJxg=
X-Received: by 2002:a19:e00d:0:b0:500:ba68:2344 with SMTP id
 x13-20020a19e00d000000b00500ba682344mr863179lfg.20.1693953361989; Tue, 05 Sep
 2023 15:36:01 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 5 Sep 2023 17:36:01 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZPCcevAt4CwCADe2@smile.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org> <20230831011405.3246849-3-swboyd@chromium.org>
 <ZPCcevAt4CwCADe2@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 5 Sep 2023 17:36:01 -0500
Message-ID: <CAE-0n53=8NEO0To++WYj+PVgGDNu5M3Tz93O+fsBo8_aAhr8EQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] platform/x86: intel_scu_ipc: Check status upon
 timeout in ipc_wait_for_interrupt()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, 
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Andy Shevchenko (2023-08-31 06:58:18)
> On Wed, Aug 30, 2023 at 06:14:02PM -0700, Stephen Boyd wrote:
> > It's possible for the completion in ipc_wait_for_interrupt() to timeout,
> > simply because the interrupt was delayed in being processed. A timeout
> > in itself is not an error. This driver should check the status register
> > upon a timeout to ensure that scheduling or interrupt processing delays
> > don't affect the outcome of the IPC return value.
> >
> >  CPU0                                                   SCU
> >  ----                                                   ---
> >  ipc_wait_for_interrupt()
> >   wait_for_completion_timeout(&scu->cmd_complete)
> >   [TIMEOUT]                                             status[IPC_BUSY]=0
> >
> > Fix this problem by reading the status bit in all cases, regardless of
> > the timeout. If the completion times out, we'll assume the problem was
> > that the IPC_BUSY bit was still set, but if the status bit is cleared in
> > the meantime we know that we hit some scheduling delay and we should
> > just check the error bit.
>
> Makes sense, thanks for fixing this!
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> Also see below.
>
> ...
>
> >  /* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
>
> Not sure if this comment needs to be updated / amended.

Or removed?
