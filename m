Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C56914008
	for <patches@lists.linux.dev>; Thu,  7 Sep 2023 20:11:20 +0000 (UTC)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-500b0f06136so2318305e87.0
        for <patches@lists.linux.dev>; Thu, 07 Sep 2023 13:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694117478; x=1694722278; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oEHxSDa9suqIfWb1cKERrinpzjakMUw8unQ7h6nJqSc=;
        b=O+SZnt8DRX6R4SAdNfhJ5Bv7Q0UATDhK7JeyAM5iihkcRpNHnUTxs7iMHVQvhoVQGa
         DA7HiCzNQBvyXBPLIkTXG8lCZl9YMfB3YRpeD4hYItI1yd0s3j2AkiHUBm1OYDMZKuYz
         OvWi/RH0LxthCdU79fObyP9mEuJRiLLOCGjRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694117478; x=1694722278;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEHxSDa9suqIfWb1cKERrinpzjakMUw8unQ7h6nJqSc=;
        b=FbtlgnR5o+08aospJGVQ+/mhaY5qsJ34iwpJyzgzRzlYY8fOdCrnhYFbypYidcD06O
         PKB83q3ksLScrrXouEJXLXs3i0wyIrMU8yul4dkx7edmwnJcwdNW6P5DfjZF79MXNTYx
         yb8OqZaPjw+mCGkJA91PMimOu+dZye5K0IWMqIp/ufN2AAFrXEDupyAgyJ/24jwgp4U2
         cl+5s9Ys2zmyFl/OcNbGnHuQl24M/+LX3vHUw7MypApgxJ+fmrpJLkY7pXX/EIYma1ZI
         8nXlOAQOKEByn9ronBzXGMKPk+bkWumhnDYmNVftHDjxOv651zWQA/BptQOAiP/2AEKR
         7NHA==
X-Gm-Message-State: AOJu0YzE6sDYTt4ABBOHTGmZbXHWvZvqBBu0hPbTO7da3BCpQTd8WLm0
	lmooerJ7672/9Q06POGTBefZK8kK6F0WWI0Ab0Xd7A==
X-Google-Smtp-Source: AGHT+IGR5cMoVWwXVyWrK1LKM17/LRlIOSjJUog6feEzya5HRB58qZr2MIyqwOsYVySx4563NE0zbrLUR3k/No5bLKY=
X-Received: by 2002:a05:6512:3a87:b0:4fb:9712:a717 with SMTP id
 q7-20020a0565123a8700b004fb9712a717mr458584lfu.13.1694117477859; Thu, 07 Sep
 2023 13:11:17 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 7 Sep 2023 13:11:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230907053513.GH1599918@black.fi.intel.com>
References: <20230906180944.2197111-1-swboyd@chromium.org> <20230906180944.2197111-2-swboyd@chromium.org>
 <20230907053513.GH1599918@black.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Thu, 7 Sep 2023 13:11:17 -0700
Message-ID: <CAE-0n51Ut296M2ZetuzXGpX32pS11bbWzfcbaFfqNxgSjzafJw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] platform/x86: intel_scu_ipc: Check status after
 timeout in busy_loop()
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Mika Westerberg (2023-09-06 22:35:13)
> On Wed, Sep 06, 2023 at 11:09:41AM -0700, Stephen Boyd wrote:
> > It's possible for the polling loop in busy_loop() to get scheduled away
> > for a long time.
> >
> >   status = ipc_read_status(scu); // status = IPC_STATUS_BUSY
> >   <long time scheduled away>
> >   if (!(status & IPC_STATUS_BUSY))
> >
> > If this happens, then the status bit could change while the task is
> > scheduled away and this function would never read the status again after
> > timing out. Instead, the function will return -ETIMEDOUT when it's
> > possible that scheduling didn't work out and the status bit was cleared.
> > Bit polling code should always check the bit being polled one more time
> > after the timeout in case this happens.
> >
> > Fix this by reading the status once more after the while loop breaks.
> >
> > Cc: Prashant Malani <pmalani@chromium.org>
> > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Fixes: e7b7ab3847c9 ("platform/x86: intel_scu_ipc: Sleeping is fine when polling")
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >
> > This is sufficiently busy so I didn't add any tags from previous round.
> >
> >  drivers/platform/x86/intel_scu_ipc.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
> > index 6851d10d6582..b2a2de22b8ff 100644
> > --- a/drivers/platform/x86/intel_scu_ipc.c
> > +++ b/drivers/platform/x86/intel_scu_ipc.c
> > @@ -232,18 +232,21 @@ static inline u32 ipc_data_readl(struct intel_scu_ipc_dev *scu, u32 offset)
> >  static inline int busy_loop(struct intel_scu_ipc_dev *scu)
> >  {
> >       unsigned long end = jiffies + IPC_TIMEOUT;
> > +     u32 status;
> >
> >       do {
> > -             u32 status;
> > -
> >               status = ipc_read_status(scu);
> >               if (!(status & IPC_STATUS_BUSY))
> > -                     return (status & IPC_STATUS_ERR) ? -EIO : 0;
> > +                     goto not_busy;
> >
> >               usleep_range(50, 100);
> >       } while (time_before(jiffies, end));
> >
> > -     return -ETIMEDOUT;
> > +     status = ipc_read_status(scu);
>
> Does the issue happen again if we get scheduled away here for a long
> time? ;-)

Given the smiley I'll assume you're making a joke. But to clarify, the
issue can't happen again because we've already waited at least
IPC_TIMEOUT jiffies, maybe quite a bit more, so if we get scheduled away
again it's a non-issue. If the status is still busy here then it's a
timeout guaranteed.

>
> Regardless, I'm fine with this as is but if you make any changes, I
> would prefer see readl_busy_timeout() used here instead (as was in the
> previous version).

We can't use readl_busy_timeout() (you mean readl_poll_timeout() right?)
because that implements the timeout with timekeeping and we don't know
if this is called from suspend paths after timekeeping is suspended or
from early boot paths where timekeeping isn't started.

We could use readl_poll_timeout_atomic() and then the usleep would be
changed to udelay. Not sure that is acceptable though to delay 50
microseconds vs. intentionally schedule away like the usleep call is
doing.
